# ticketshop.ops

This repositry regroups the configuration-as-code to provision, configure,
deploy and manage the EPFL's Ticketsop app. It uses [Ansible] wrapped in a
convenient [suitcase], called [`cffsible`](./cffsible).


## TL;DR

`./cffsible`

1. Build the ticketshop image on top of `ghcr.io/epfl-si/common-web`, and the source code from https://github.com/epfl-si/ticketshop
1. Adds some secrets and config map, creates a service, routes and a deployment config.
1. If needed or asked, will redeploy the pod.

Detailled operations might look like:
```
./cffsible -vvv -t ticketshop.is,ticketshop.build
$ oc logs -f bc/ticketshop --version=NN -n ticketshop-test
./cffsible -vvv -t ticketshop.promote --prod
./cffsible -vvv -t ticketshop.secrets,ticketshop.routes,ticketshop.service,ticketshop.cm,ticketshop.dc --prod
```

## Prerequisites

* Access to our [Keybase] `/keybase/team/epfl_ticketshop/` directory.
* Access to `ticketshop-test` & `ticketshop-prod` namespaces on our [OpenShift] cluster.


## Tags
<!--- for f in $(find . -path ./ansible-deps-cache -prune -false -o -name '*.yml'); do cat $f | yq '.[] | {name, tags}| with_entries( select( .value != null ) )' 2>/dev/null; done --->

| name                             | tags                                                                    |
|:---------------------------------|:------------------------------------------------------------------------|
|Secrets                           | `ticketshop.dbs`<br>`ticketshop.secrets`                                |
|Service                           | `ticketshop.service`                                                    |
|Routes                            | `ticketshop.routes`                                                     |
|Config Map                        | `ticketshop.config`<br>`ticketshop.cm`                                  |
|Deployment Config                 | `ticketshop.dc`<br>`ticketshop.deploy`<br>`ticketshop.deploymentconfig` |
|Redeploy                          | `ticketshop.deploy.force`                                               |
|Build image                       | `ticketshop.is`<br>`ticketshop.image`<br>`ticketshop.imagestream`       |
|Rebuild now                       | `ticketshop.build`                                                      |
|Promote                           | `ticketshop.promote`                                                    |



[Ansible]: https://www.ansible.com (Ansible is Simple IT Automation)
[suitcase]: https://github.com/epfl-si/ansible.suitcase (Install Ansible and its dependency stack into a temporary directory)
[c4science]: https://c4science.ch/diffusion/3794/history/dev/
[Keybase]: https://keybase.io
[OpenShift]: https://openshift.com
[//]: # "comment"
