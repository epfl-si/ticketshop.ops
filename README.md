# ticketshop.ops

Configuration-as-code to provision, configure, deploy and manage the EPFL TicketShop on OpenShift.

## Prerequisites

- Member of the [Keybase] `/keybase/team/epfl_ticketshop/` team
- Member of the EPFL group `vra_p_svc0049`
- `oc` CLI installed and in `$PATH`
- `python3` with `pyyaml` (`pip install pyyaml`)
- `keybase` running locally

## Deploy

```bash
./deploy.sh           # test environment (default)
./deploy.sh --test    # test environment
./deploy.sh --prod    # production environment
```

The script will:
1. Log into the correct OpenShift cluster (skipped if already connected)
2. Switch to the target namespace
3. Read secrets from Keybase and create/update them in OpenShift

## Environments

| Environment | Cluster | Namespace |
|-------------|---------|-----------|
| test | `api.ocpitst0001.xaas.epfl.ch` | `svc0049t-ticketshop` |
| prod | `api.ocpitsp0001.xaas.epfl.ch` | `svc0049p-ticketshop` |

## Manifests

Kustomize overlays are in `manifests/overlays/{test,prod}` and build on the base in `manifests/base/`.

[Keybase]: https://keybase.io
