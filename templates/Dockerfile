FROM {{ cadi_base_image_uri }}

RUN cpanm utf8::all

# Enable apache modules. `headers` and `env` modules are enabled by default.
RUN sed -i \
    -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
    -e 's/^\s#\(LoadModule .*mod_cgid\?.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_remoteip.so\)/\1/' \
    /usr/local/apache2/conf/httpd.conf
