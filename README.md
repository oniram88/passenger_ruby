passenger_ruby
==============

docker image with passenger and ruby


viene utilizzato passenger standalone che ascolterà sulla porta 80
fuori dal container sarà presente nginx che girerà quando opportuno le richieste a passenger

il sistema presuppone che l'applicativo sia posizionato nella solita cartella /var/www

Ci sono tre file inseriti in automatico nel sistema di boot:
/etc/my_init.d/a_install.sh
/etc/my_init.d/b_migrate.sh
/etc/my_init.d/c_precompile.sh
basta cancellarli per non lanciare le varie funzionalità.



configurazione in nginx 

http {
    ...

    # These are some "magic" Nginx configuration options that aid in making
    # WebSockets work properly with Passenger Standalone. Please learn more
    # at http://nginx.org/en/docs/http/websocket.html
    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }

    server {
        listen 80;
        server_name www.foo.com;

        # Tells Nginx to serve static assets from this directory.
        root /webapps/foo/public;

        location / {
            # Tells Nginx to forward all requests for www.foo.com
            # to the Passenger Standalone instance listening on port 4000.
            proxy_pass http://127.0.0.1:4000;

            # These are "magic" Nginx configuration options that
            # should be present in order to make the reverse proxying
            # work properly. Also contains some options that make WebSockets
            # work properly with Passenger Standalone. Please learn more at
            # http://nginx.org/en/docs/http/ngx_http_proxy_module.html
            proxy_http_version 1.1;
            proxy_set_header Host $http_host;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_buffering off;
        }
    }

    # We handle bar in a similar manner.
    server {
        listen 80;
        server_name www.bar.com;

        root /webapps/bar/public;

        location / {
            # bar is listening on port 4010 instead of 4000, we
            # change the URL here.
            proxy_pass http://127.0.0.1:4010;

            proxy_http_version 1.1;
            proxy_set_header Host $http_host;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_buffering off;
        }
    }
}
