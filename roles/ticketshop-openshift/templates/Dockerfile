FROM {{ ticketshop_base_image.mirrored }}

USER 0

RUN set -e -x; apt-get update ; \
    apt-get install -y --no-install-recommends libxml-libxml-perl; \
    rm -rf /var/lib/apt/lists/*

# TODO: hoist this in parent image (https://github.com/epfl-si/common-web/pull/1)
RUN cpanm Apache::DBI

RUN set -e -x; cd /var/www/vhosts; git clone https://github.com/epfl-si/ticketshop {{ ticketshop_vhost_dir }}

WORKDIR /var/www/vhosts/{{ ticketshop_vhost_dir }}

RUN mv perllib/ticketshop_lib.pm /opt/dinfo/lib/perl/

RUN cpanm --installdeps --notest . || ( cat /root/.cpanm/work/*/build.log; exit 1 )

# Ensure that the logs and Tequila state directories exist and are writable by apache
RUN set -e -x; for subdir in logs Tequila/Sessions; do mkdir -p $subdir; chmod 777 -R $subdir; done

RUN a2enmod cgi

RUN echo "guests.aeskey\tnone" > /opt/dinfo/etc/secrets.conf

# Temp version marked
RUN touch $(date "+%Y%m%d-%H%M%S")_deployed

USER 1001
ENTRYPOINT ["/usr/sbin/apache2", "-e", "debug", "-D", "FOREGROUND"]
