istepanov/dokuwiki
==================

Docker container image with [DokuWiki](https://www.dokuwiki.org/dokuwiki) and nginx

### How to run

Assume your docker host is localhost and HTTP public port is 8000 (change these values if you need).

First, run new dokuwiki container:

    docker run -d -p 8000:80 --name dokuwiki istepanov/dokuwiki:2.0

Then setup dokuwiki using installer at URL `http://localhost:8000/install.php`

### How to make data persistent

To make sure data won't be deleted if container is removed, create an empty container named `dokuwiki-data` and attach DokuWiki container's volumes to it. Volumes won't be deleted if at least one container owns them.

    # create data container
    docker run --volumes-from dokuwiki --name dokuwiki-data busybox

    # now you can safely delete dokuwiki container
    docker stop dokuwiki && docker rm dokuwiki

    # to restore dokuwiki, create new dokuwiki container and attach dokuwiki-data volume to it
    docker run -d -p 8000:80 --volumes-from dokuwiki-data --name dokuwiki istepanov/dokuwiki:2.0

### Persistent plugins

Dokuwiki installs plugins to `lib/plugins/`, but this folder isn't inside persistent volume storage by default, so all plugins will be erased when container is re-created.  The recommended way to make plugins persistent is to create your own Docker image with `istepanov/dokuwiki` as a base image and use shell commands inside the Dockerfile to install needed plugins.

Example (install [Dokuwiki ToDo](https://www.dokuwiki.org/plugin:todo) plugin):

    FROM istepanov/dokuwiki
    MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

    # this is an example Dockerfile that demonstrates how to add Dokuwiki plugins to istepanov/dokuwiki image

    RUN apt-get update && \
        apt-get install -y unzip && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

    # add todo plugin
    RUN curl -O -L "https://github.com/leibler/dokuwiki-plugin-todo/archive/stable.zip" && \
        unzip stable.zip -d /var/www/lib/plugins/ && \
        mv /var/www/lib/plugins/dokuwiki-plugin-todo-stable /var/www/lib/plugins/todo && \
        rm -rf stable.zip

### How to backup data

    # create dokuwiki-backup.tar.gz archive in current directory using temporaty container
    docker run --rm --volumes-from dokuwiki -v $(pwd):/backup ubuntu tar zcvf /backup/dokuwiki-backup.tar.gz /var/dokuwiki-storage

**Note:** only these folders are backed up:

* `data/pages/`
* `data/meta/`
* `data/media/`
* `data/media_attic/`
* `data/media_meta/`
* `data/attic/`
* `conf/`

### How to restore from backup

    #create new dokuwiki container, but don't start it yet
    docker create -p 8000:80 --name dokuwiki istepanov/dokuwiki:2.0

    # create data container for persistency (optional)
    docker run --volumes-from dokuwiki --name dokuwiki-data busybox

    # restore from backup using temporary container
    docker run --rm --volumes-from dokuwiki -w / -v $(pwd):/backup ubuntu tar xzvf /backup/dokuwiki-backup.tar.gz

    # start dokuwiki
    docker start dokuwiki
