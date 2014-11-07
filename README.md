docker-dokuwiki
===============

Docker container image with dokuwiki and nginx

###How to run

    docker run -d -p 8000:80 --name dokuwiki istepanov/dokuwiki

Then access dokuwiki at URL `http://HOST:8000/`, where `HOST` is your host's IP address or domain name (e.g. `http://example.com:8000/`). You can replace 8000 with any available TCP port you want.

###How to make data persistent

To make sure data won't be deleted if container is removed, create an empty container named `dokuwiki-data` and attach dokuwiki container's volume to it. The volume won't be deleted if at least one container owns it.

    docker run --volumes-from dokuwiki --name dokuwiki-data busybox
    
    # now you can safely delete dokuwiki container
    docker stop dokuwiki && docker rm dokuwiki
    
    # to restore dokuwiki, create new dokuwiki container and attach dokuwiki-data volume to it
    docker run -d -p 8000:80 --volumes-from dokuwiki-data --name dokuwiki istepanov/dokuwiki
