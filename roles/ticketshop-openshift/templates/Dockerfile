FROM {{ cadi_base_image_uri }}

# Install perl dependencies needed for ticketshop
RUN cpanm utf8::all HTML::Template JSON::SL XML::LibXML Net::CIDR

# Enable apache modules. `headers` and `env` modules are enabled by default.
# Make apache listen on port 8080
RUN sed -i \
    -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
    -e 's/^\s#\(LoadModule .*mod_cgid\?.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_remoteip.so\)/\1/' \
    -e 's/^Listen 80$/Listen 8080/' \
    /usr/local/apache2/conf/httpd.conf

# Include the ticketshop apache's configuration, e.g. make everything being
# served from the dinfo standard '/var/www/vhosts/ticketshop.epfl.ch'.
RUN echo "Include conf/25-ticketshop.epfl.ch.conf" \
        >> /usr/local/apache2/conf/httpd.conf

# Create the vhosts directory
RUN mkdir -p /var/www/vhosts/

# Copy the SSH private key for the idevfsd-checkouter (c4science), in order
# to be able to git clone a private repo in /var/www/vhosts/ticketshop.epfl.ch.
# Please read https://cloud.redhat.com/blog/how-to-squash-openshift-docker-build-layers-to-remove-secrets
# on secrets removal.
COPY .ssh /root/.ssh
WORKDIR /var/www/vhosts/
RUN git clone --branch {{ ticketshop_git_branch }} ssh://git@c4science.ch/diffusion/3794/ticketshop.git {{ ticketshop_vhost_dir }}
RUN cd {{ ticketshop_vhost_dir }} && git rev-parse --abbrev-ref HEAD && cat .git/HEAD

# Ensure that the logs directory exists and is writable by apache
RUN mkdir -p /usr/local/apache2/logs && \
    chmod 777 -R /usr/local/apache2/logs
RUN mkdir -p /var/www/vhosts/{{ ticketshop_vhost_dir }}/logs && \
    chmod 777 -R /var/www/vhosts/{{ ticketshop_vhost_dir }}/logs
RUN chown www-data:www-data -R /var/www/vhosts/{{ ticketshop_vhost_dir }}/htdocs
RUN chown www-data:www-data -R /var/www/vhosts/{{ ticketshop_vhost_dir }}/cgi-bin
RUN chown www-data:www-data -R /var/www/vhosts/{{ ticketshop_vhost_dir }}/private
# Tequila's sessions directory
RUN mkdir -p /var/www/vhosts/{{ ticketshop_vhost_dir }}/Tequila/Sessions && \
    chmod 777 -R /var/www/vhosts/{{ ticketshop_vhost_dir }}/Tequila/Sessions

WORKDIR /var/www/vhosts/{{ ticketshop_vhost_dir }}

# Temp version marked
RUN touch $(date "+%Y%m%d-%H%M%S")_deployed

{# Image gets squashed; see ../tasks/ticketshop-openshift-build-tasks.yml #}
RUN rm -rf /root/.ssh
