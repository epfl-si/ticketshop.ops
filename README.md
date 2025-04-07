# ticketshop.ops

This repositry regroups the configuration-as-code to provision, configure,
deploy and manage the EPFL's TicketShop uses [Ansible] wrapped in a
convenient [suitcase], called [`cffsible`](./cffsible).

## Prerequisites

* Be member of the [Keybase] `/keybase/team/epfl_ticketshop/` team.
* Be member of the EPFL group `vra_p_svc0049`.


## Deploy

```bash
./cffsible      # (--prod for production environment)
```

Start a new "cloud" build

```bash
./cffsible -t image.startbuild
```

Restart the app

```bash
./cffsible -t app.restart`    # (--prod for production environment)
```


[Ansible]: https://www.ansible.com (Ansible is Simple IT Automation)
[suitcase]: https://github.com/epfl-si/ansible.suitcase (Install Ansible and its dependency stack into a temporary directory)
[Keybase]: https://keybase.io
