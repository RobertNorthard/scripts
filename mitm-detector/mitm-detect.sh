#!/bin/bash
#
# Description: Detect man-in-the-middle attacks by comparing well known SSL certificate fingerprints.
#              Trusted fingerprints courtesy of https://www.grc.com/fingerprints.htm
#

# Check if openssl in $PATH
OPENSSL=$(which openssl)
RES=$?

if [ "$RES" != "0" ]; then
	echo "openssl needs to be in your PATH"
	exit 1
fi

# Trsusted fingerprints file
TRUST_FINGERPRINTS="trusted.txt"
MITM_DETECTED="false"

cat $TRUST_FINGERPRINTS | while read i; do

    HOST=$(echo "${i}" | awk '{print $1}')
    FINGERPRINT=$(echo "${i}" | awk '{print $2}')

    # echo QUIT to exit openssl session
    NEW_FINGERPRINT=$(echo QUIT | openssl s_client -connect $HOST:443 2>/dev/null | openssl x509 -noout -fingerprint | cut -f2 -d'=')

    if [ "$FINGERPRINT" != "$NEW_FINGERPRINT" ]; then
        echo "$HOST $FINGERPRINT != $NEW_FINGERPRINT"
        MITM_DETECTED="true"
        exit 1
    fi
done

if [ "$MITM_DETECTED" == "true" ]; then
    echo "Man in the middle attach detected!"
    exit 1
else
    echo "Fingerprint check for hosts in $TRUST_FINGERPRINTS passed!"
    exit 0
fi