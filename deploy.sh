#!/bin/sh

for www in www1-m www2-m; do
    for lang in ja en; do
        rsync -az --delete $lang/site/ $www:/var/www/html/docs/$lang/
    done
    ssh $www -- "find /var/www/html/docs         | xargs chown -R apache:apache";
    ssh $www -- "find /var/www/html/docs -type f | xargs chmod 644";
    ssh $www -- "find /var/www/html/docs -type d | xargs chmod 755";
done
