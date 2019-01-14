#!/bin/bash
# epaper.zeit.de
#
# First 2019' issue of Zeit was release at 2018-12-27, the second issue at 2019-01-03.
#
# Examples:
# https://premium.zeit.de/system/files/2019-02/epub/die_zeit_2019_3.epub
# https://premium.zeit.de/system/files/2019-01/epub/die_zeit_2019_2_0.epub
# https://premium.zeit.de/system/files/2018-52/epub/die_zeit_2019_1.epub
# https://premium.zeit.de/system/files/2018-51/epub/die_zeit_2018_53.epub
# https://premium.zeit.de/system/files/2018-50/epub/die_zeit_2018_52.epub
#
# COMMENT: Easy to read, so no fancy bash'ing.
#
# TODO: Certification seems to be broken because wget is linked against old ssl?
# TODO: Testing
# TODO: Smarter on device debugging
# TODO: Stop quering every day, when e.g. the link has changed (be more server friendly)

##################
#### Configuration

if [ -z "$wget_sync_settings" ];
then
    echo "$0: Debug mode"
    wget_sync_settings="."
fi

## HTTP authentication
if [ -e $wget_sync_settings/config.sh ]; then
    echo "$0: Loading auth";
    source $wget_sync_settings/auth.sh
else
    echo "$0: Did not find $wget_sync_settings/auth.sh. Exiting."
    echo "$0: Please create the file auth.sh in .wget-sync on your device:"
    echo "$0: http_username=\"your_username\""
    echo "$0: http_password=\"your_password\""
    exit 1
fi

# A new issue is released every thursday. So the issue week is different to the standard week (= reference date)
diff=4
todaytimestamp=$(date +'%s')
let reftimestamp=$todaytimestamp+$diff*24*3600
referencedate=$(date -d "@$reftimestamp" +'%Y-%m-%d')
year=$(date -d "@$reftimestamp" +%Y)
week=$(date -d "@$reftimestamp" +%U)
let issue=$week+1
week=$(printf %02d $week)

# Compose URL as seen in the script header
url="https://premium.zeit.de/system/files/${year}-${week}/epub/die_zeit_${year}_${issue}.epub"

# Check URL
wgetoutputraw=$(wget --user="$http_username" --password="$http_password" --no-check-certificate --spider "$url" 2>&1)
echo "$wgetoutputraw" # DEBUG
wgetoutput=$(echo $wgetoutputraw | grep '200' | wc -l)
valid=$(echo "$wgetoutput")

# If invalid the URL might end with a "_0.epub" (See examples above)
if [ "$valid" -eq 0 ]
then
  echo "$0: URL seems to be wrong. Trying another one..."
  url=${url/.epub/_0.epub}
  wgetoutput=$(wget --user="$http_username" --password="$http_password" --no-check-certificate --spider "$url" 2>&1 | grep '200' | wc -l)
  valid=$(echo "$wgetoutput")

  if [ "$valid" -eq 0 ]
  then
    echo "$0: Still wrong URL. Canceling..."
    exit
  fi
fi

echo "$0: Results:"
echo "$0: Today:       $(date -d @$todaytimestamp +'%Y-%m-%d')"
echo "$0: Reference:   $referencedate"
echo "$0: URL:         $url"
echo "$0: File exists: $valid"

## Set to a comma seperated list of allowed extensions
#exts="epub,mobi,cbz,cbr,pdf"
exts="epub"

###Extras:

# DEBUG: Get some info about the system
# echo ""
# ls /usr/bin
# echo ""
# ls -la /usr/lib/
# echo ""
# openssl version
# echo ""
# uname -a
# END DEBUG

### Custom CA certificate. If using SSL supply the certificate in ".wget-settings/cert.crt" on your kobo root while mounted.
### The format is PEM 
