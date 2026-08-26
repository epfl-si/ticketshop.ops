#!/bin/bash
set -euo pipefail

TEST_SERVER="https://api.ocpitst0001.xaas.epfl.ch:6443"
TEST_NAMESPACE="svc0049t-ticketshop"
PROD_SERVER="https://api.ocpitsp0001.xaas.epfl.ch:6443"
PROD_NAMESPACE="svc0049p-ticketshop"
KEYBASE_SECRETS="/keybase/team/epfl_ticketshop/secrets.yml"
SERVICE_NAME="svc0049"

usage() {
    cat <<EOF
Usage: $0 [--test|--prod]

Options:
  --test    Deploy to test environment (default)
  --prod    Deploy to production environment
  --help    Show this help
EOF
}

ENV="test"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --test) ENV="test"; shift ;;
        --prod) ENV="prod"; shift ;;
        --help) usage; exit 0 ;;
        *) echo "Unknown option: $1"; usage; exit 1 ;;
    esac
done

if [[ "$ENV" == "prod" ]]; then
    SERVER="$PROD_SERVER"
    NAMESPACE="$PROD_NAMESPACE"
    AUTH_URL="https://ticketshop.epfl.ch"
else
    SERVER="$TEST_SERVER"
    NAMESPACE="$TEST_NAMESPACE"
    AUTH_URL="https://test-ticketshop.epfl.ch"
fi

# OC login — skip if already on the right cluster
current_server=$(oc whoami --show-server 2>/dev/null || true)
if [[ "$current_server" == "$SERVER" ]]; then
    echo "Already logged into $SERVER"
else
    echo "Logging into OpenShift at $SERVER..."
    oc login "$SERVER" --web
fi

oc project "$NAMESPACE"

# Read and parse secrets from Keybase
echo "Reading secrets from Keybase..."
SECRETS_RAW=$(keybase fs read "$KEYBASE_SECRETS")

get() {
    python3 -c "
import sys, yaml
data = yaml.safe_load(sys.stdin)
keys = '$1'.split('.')
val = data
for k in keys:
    val = val[k]
print(val, end='')
" <<< "$SECRETS_RAW"
}

ENV_SECRETS_PREFIX="$ENV"

API_USERNAME=$(get "$ENV_SECRETS_PREFIX.api.username")
API_PASSWORD=$(get "$ENV_SECRETS_PREFIX.api.password")
API_URL=$(get "$ENV_SECRETS_PREFIX.api.url")
AUTH_ID=$(get "$ENV_SECRETS_PREFIX.auth.id")
AUTH_SECRET_VAL=$(get "$ENV_SECRETS_PREFIX.auth.secret")
AUTH_ISSUER=$(get "$ENV_SECRETS_PREFIX.auth.issuer")
AUTH_SECRET=$(get "$ENV_SECRETS_PREFIX.secret")
DFS_USERNAME=$(get "$ENV_SECRETS_PREFIX.dfs.username")
DFS_PASSWORD=$(get "$ENV_SECRETS_PREFIX.dfs.password")
DFS_URL=$(get "$ENV_SECRETS_PREFIX.dfs.url")
DB_USERNAME=$(get "$ENV_SECRETS_PREFIX.database.username")
DB_PASSWORD=$(get "$ENV_SECRETS_PREFIX.database.password")
DB_HOST=$(get "$ENV_SECRETS_PREFIX.database.host")
DB_NAME=$(get "$ENV_SECRETS_PREFIX.database.name")
TELEGRAM_TOKEN=$(get "$ENV_SECRETS_PREFIX.telegram.token")
S3_ACCESS_KEY=$(get "$ENV_SECRETS_PREFIX.s3.accessKey")
S3_SECRET=$(get "$ENV_SECRETS_PREFIX.s3.secret")
PULLER=$(get "puller")

DATABASE_URL="postgres://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:5432/${DB_NAME}"

echo "Creating secrets in $NAMESPACE..."

oc apply -f - <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: ticketshop-secrets
  namespace: $NAMESPACE
type: Opaque
stringData:
  API_USERNAME: "$API_USERNAME"
  API_PASSWORD: "$API_PASSWORD"
  API_URL: "$API_URL"
  AUTH_MICROSOFT_ENTRA_ID_ID: "$AUTH_ID"
  AUTH_MICROSOFT_ENTRA_ID_SECRET: "$AUTH_SECRET_VAL"
  AUTH_MICROSOFT_ENTRA_ID_ISSUER: "$AUTH_ISSUER"
  AUTH_SECRET: "$AUTH_SECRET"
  DFS_USERNAME: "$DFS_USERNAME"
  DFS_PASSWORD: "$DFS_PASSWORD"
  SAP_URL: "$DFS_URL"
  AUTH_URL: "$AUTH_URL"
  DATABASE_URL: "$DATABASE_URL"
YAML

oc apply -f - <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: ticketshop-db-credentials
  namespace: $NAMESPACE
  labels:
    cnpg.io/reload: "true"
type: kubernetes.io/basic-auth
stringData:
  username: "$DB_USERNAME"
  password: "$DB_PASSWORD"
  database: "$DB_NAME"
YAML

oc apply -f - <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: telegram-bot-token
  namespace: $NAMESPACE
type: Opaque
stringData:
  BOT_TOKEN: "$TELEGRAM_TOKEN"
YAML

oc apply -f - <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: s3-credentials
  namespace: $NAMESPACE
type: Opaque
stringData:
  AWS_ACCESS_KEY: "$S3_ACCESS_KEY"
  AWS_SECRET: "$S3_SECRET"
YAML

oc apply -f - <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: ${SERVICE_NAME}-pull-secret
  namespace: $NAMESPACE
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: "$PULLER"
YAML

echo "Done."
