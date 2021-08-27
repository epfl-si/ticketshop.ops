FROM {{ cadi_base_image_uri }}

RUN cpanm utf8::all

# Enable apache modules. `headers` and `env` modules are enabled by default.
RUN sed -i \
    -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
    -e 's/^\s#\(LoadModule .*mod_cgid\?.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_remoteip.so\)/\1/' \
    /usr/local/apache2/conf/httpd.conf

COPY .ssh /root/.ssh

WORKDIR /usr/local/apache2
RUN git clone ssh://git@c4science.ch/diffusion/3794/ticketshop.git
{# Image gets squashed; see ../tasks/ticketshop-openshift-build-tasks.yml #}
RUN rm -rf /root/.ssh
