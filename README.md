# ticketshop.ops

This repositry regroups the configuration-as-code to provision, configure,
deploy and manage the EPFL's Ticketsop app. It uses [Ansible] wrapped in a
convenient [suitcase], called [`cffsible`](./cffsible).


## TL;DR

`./cffsible`

1. Uses the «IDEV-FSD cadi base image» to build the ticketshop image, checkouting the code from [c4science].
1. Adds some secrets and config map, create a service, routes and a deployment config.
1. If needed or asked, it will redeploy the pod.


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
|`idevfsd-checkouter` secret (ssh) | `ticketshop.checkouter`                                                 |
|Build image                       | `ticketshop.is`<br>`ticketshop.image`<br>`ticketshop.imagestream`       |
|Rebuild now                       | `ticketshop.build`                                                      |



[Ansible]: https://www.ansible.com (Ansible is Simple IT Automation)
[suitcase]: https://github.com/epfl-si/ansible.suitcase (Install Ansible and its dependency stack into a temporary directory)
[c4science]: https://c4science.ch/diffusion/3794/history/dev/
[Keybase]: https://keybase.io
[OpenShift]: https://openshift.com
[//]: # "comment"
