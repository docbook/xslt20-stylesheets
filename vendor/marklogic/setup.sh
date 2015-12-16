#!/bin/bash

# Configure the admin user and password and the hostname.

ADMIN_USER=admin
ADMIN_PASS=admin
HOSTNAME=localhost

# Configure options

LOCALE_DATABASE=1
LOCALE_MODULES=1
LOCALE_FILESYSTEM=1
LOCALE_DIRECTORY=`dirname $0`/../../xslt/base/common/locales

# Configure artifact names

FOREST_NAME="DocBook.locales"
DATABASE_NAME="DocBook.locales"

ROLE_NAME="docbook-locales"
INTERNAL_ROLE_NAME="docbook-locales-internal"

# No user-servicable parts below here

EXEC_PRIV_URI="http://docbook.org/vendor/marklogic/docbook-locales"
EXEC_PRIV_NAME="docbook-locales"

AMP1_NS="http://docbook.org/vendor/marklogic/locales"
AMP2_NS="http://docbook.org/vendor/marklogic/docbook"

CURLOPT="--anyauth -u $ADMIN_USER:$ADMIN_PASS -H Accept:application/json"
CTYPE="-H Content-Type:application/json"
POST="-X POST $CTYPE"
API="http://$HOSTNAME:8002/manage/v2"

PAYLOAD="{\"privilege-name\": \"$EXEC_PRIV_NAME\",\
\"action\": \"$EXEC_PRIV_URI\", \"kind\": \"execute\"}"

echo "Create privilege $EXEC_PRIV_NAME"
curl $CURLOPT $POST --data-binary "$PAYLOAD" "$API/privileges"

PAYLOAD="{\"role-name\": \"$ROLE_NAME\",\
\"description\": \"The DocBook user role\",\
\"privilege\": [{\"privilege-name\": \"$EXEC_PRIV_NAME\",\
\"action\": \"$EXEC_PRIV_URI\", \"kind\": \"execute\"}]}"

echo "Create role $ROLE_NAME"
curl $CURLOPT $POST --data-binary "$PAYLOAD" "$API/roles"

if [ $LOCALE_DATABASE = 1 ]; then
  PAYLOAD="{\"forest-name\": \"$FOREST_NAME\",\
  \"host\": \"\$ML-LOCALHOST\"}"

  echo "Create forest $FOREST_NAME"
  curl $CURLOPT $POST --data-binary "$PAYLOAD" "$API/forests"

  PAYLOAD="{\"database-name\": \"$DATABASE_NAME\",\
  \"forest\": [\"$FOREST_NAME\"]}"

  echo "Create database $DATABASE_NAME"
  curl $CURLOPT $POST --data-binary "$PAYLOAD" "$API/databases"
fi

PRIV="{\"privilege-name\": \"xslt-invoke\",\
\"action\": \"http://marklogic.com/xdmp/privileges/xslt-invoke\",\
\"kind\": \"execute\"},\
{\"privilege-name\": \"xslt-eval\",\
\"action\": \"http://marklogic.com/xdmp/privileges/xslt-eval\",\
\"kind\": \"execute\"}"

PRIV1="{\"privilege-name\": \"xdmp-eval\",\
\"action\": \"http://marklogic.com/xdmp/privileges/xdmp-eval\",\
\"kind\": \"execute\"},\
{\"privilege-name\": \"xdmp-eval-in\",\
\"action\": \"http://marklogic.com/xdmp/privileges/xdmp-eval-in\",\
\"kind\": \"execute\"}"

PRIV2="{\"privilege-name\": \"xdmp-document-get\",\
\"action\": \"http://marklogic.com/xdmp/privileges/xdmp-document-get\",\
\"kind\": \"execute\"}"

if [ $LOCALE_DATABASE = 1 -o $LOCALE_MODULES = 1 ]; then
    PRIV="$PRIV,$PRIV1"
    if [ $LOCALE_FILESYSTEM = 1 ]; then
        PRIV="$PRIV,$PRIV1,$PRIV2"
    fi
else
    if [ $LOCALE_FILESYSTEM = 1 ]; then
        PRIV="$PRIV,$PRIV2"
    fi
fi

PAYLOAD="{\"role-name\": \"$INTERNAL_ROLE_NAME\",\
\"description\": \"The internal DocBook user role\",\
\"privilege\": [$PRIV]}"

echo "Create role $INTERNAL_ROLE_NAME"
curl $CURLOPT $POST --data-binary "$PAYLOAD" "$API/roles"

PAYLOAD="{\"namespace\": \"$AMP1_NS\", \
\"local-name\": \"load-from-database\", \
\"document-uri\": \"/DocBook/base/common/marklogic.xqy\", \
\"modules-database\": \"\", \
\"role\": [\"$INTERNAL_ROLE_NAME\"]}"

echo "Create amp for mldb:load-from-database"
curl $CURLOPT $POST --data-binary "$PAYLOAD" "$API/amps"

PAYLOAD="{\"namespace\": \"$AMP1_NS\", \
\"local-name\": \"load-locale-filesystem\", \
\"document-uri\": \"/DocBook/base/common/marklogic.xqy\", \
\"modules-database\": \"\", \
\"role\": [\"$INTERNAL_ROLE_NAME\"]}"

echo "Create amp for mldb:load-locale-filesystem"
curl $CURLOPT $POST --data-binary "$PAYLOAD" "$API/amps"

PAYLOAD="{\"namespace\": \"$AMP2_NS\", \
\"local-name\": \"transform\", \
\"document-uri\": \"/DocBook/vendor/marklogic/docbook.xqy\", \
\"modules-database\": \"\", \
\"role\": [\"$INTERNAL_ROLE_NAME\"]}"

echo "Create amp for mldb:transform"
curl $CURLOPT $POST --data-binary "$PAYLOAD" "$API/amps"

CTYPE="-H Content-Type:application/xml"
PUT="-X PUT $CTYPE"
API="http://$HOSTNAME:8000/v1/documents"
CURLOPT="--anyauth -u $ADMIN_USER:$ADMIN_PASS"

if [ $LOCALE_DATABASE = 1 ]; then
for LOCALE in $LOCALE_DIRECTORY/*.xml; do
    LANG=`basename $LOCALE .xml`
    echo "Uploading $LANG locale..."
    curl $CURLOPT $PUT --upload-file $LOCALE \
     "$API?uri=/DocBook/locales/$LANG.xml&database=$DATABASE_NAME&perm:$ROLE_NAME=read"
done
fi
