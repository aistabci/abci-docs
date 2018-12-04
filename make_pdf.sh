#!/bin/sh

HTML2PDFCMD="/usr/bin/xvfb-run /usr/bin/wkhtmltopdf -B 30 -T 35.01 -L 30 -R 30"
SLEEP_SEC=1

for lang in ja en
do
    # make pdfs
    dest_prefix="$lang/site_pdf"
    [ ! -d $dest_prefix ] && mkdir $dest_prefix
    $HTML2PDFCMD $lang/site/index.html $dest_prefix/index.pdf
    sleep $SLEEP_SEC

    for file in $lang/site/*/index.html
    do
        seqtion_no=`dirname $file | xargs basename`
        $HTML2PDFCMD $file $dest_prefix/${seqtion_no}.pdf
        sleep $SLEEP_SEC
    done

    # make index.html
    : > $dest_prefix/index.html
    for file in $dest_prefix/*.pdf
    do
        filebase=`basename $file`
        echo "<a href=\"$filebase\">$filebase</a>" >> $dest_prefix/index.html
    done
done
