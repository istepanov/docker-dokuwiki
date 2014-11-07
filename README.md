docker-dokuwiki
===============

Docker container image with [DokuWiki](https://www.dokuwiki.org/dokuwiki) and nginx

###How to run

    docker run -d -p 8000:80 --name dokuwiki istepanov/dokuwiki

then access DokuWiki at URL `http://HOST:8000/`, where `HOST` is your host's IP address or domain name (e.g. `http://example.com:8000/`). You can replace 8000 with any available TCP port you want.

###How to make data persistent

To make sure data won't be deleted if container is removed, create an empty container named `dokuwiki-data` and attach DokuWiki container's volumes to it. Volumes won't be deleted if at least one container owns them.

    # create data container
    docker run --volumes-from dokuwiki --name dokuwiki-data busybox
    
    # now you can safely delete dokuwiki container
    docker stop dokuwiki && docker rm dokuwiki
    
    # to restore dokuwiki, create new dokuwiki container and attach dokuwiki-data volume to it
    docker run -d -p 8000:80 --volumes-from dokuwiki-data --name dokuwiki istepanov/dokuwiki

###How to backup data

	# create dokuwiki-backup.tar.gz archive in current directory using temporaty container
    docker run -ti --rm --volumes-from dokuwiki -v $(pwd):/backup ubuntu tar zcvf /backup/dokuwiki-backup.tar.gz /var/www

###How to restore from backup

    #create new dokuwiki container, but don't start it yet
    docker create -p 8000:80 --name dokuwiki istepanov/dokuwiki
    
    # create data container for persistency (optional)
    docker run --volumes-from dokuwiki --name dokuwiki-data busybox
    
    # restore from backup using temporary container
    docker run -ti --rm --volumes-from dokuwiki -w / -v $(pwd):/backup ubuntu tar xzvf /backup/dokuwiki-backup.tar.gz
    
    # start dokuwiki
    docker start dokuwiki
