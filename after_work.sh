#!/bin/bash

PATH_LDIF="/after_work/"
cd ${PATH_LDIF}
if ls *.ldif > /dev/null 2>&1 ;then
    codrec=1
    while [ "$coderec" != "0" ]; do
        sleep 1
        ldapsearch -Y EXTERNAL -H ldapi:/// -LLL cn=config > /dev/null 2>&1
        coderec=$?
    done
    for myLdif in *.ldif ;do
        echo "--- $myLdif "
        ldapmodify -Y EXTERNAL -H ldapi:/// -f ${PATH_LDIF}${myLdif}
        echo "---"
    done
fi