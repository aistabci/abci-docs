#!/bin/sh

for www in www1-m www2-m; do
    for lang in ja en; do
        rsync -az --delete $lang/site_pdf/ $www:/var/www/html/user/docs_pdf/$lang
        rsync -az --delete $lang/site_pdf/ $www:/var/www/html/user/docs_pdf/$lang
    done
done
