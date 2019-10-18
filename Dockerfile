FROM debian:stretch

MAINTAINER Christian Luginbühl <dinkel@pimprecords.com>

ENV OPENLDAP_VERSION 2.4.44
ENV DEBUG_LEVEL 32768

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ldap-utils \
        slapd=${OPENLDAP_VERSION}* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## LDAPS
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	libsasl2-2 \
	sasl2-bin \
	libsasl2-modules

## LDAPS AND/OR RUN LDIF AFTER OPENLDAP STARTUP
# Mount the "/after_work" volume and copy your ldif files to it
# For ldaps see ldaps.template.ldif
RUN mkdir /after_work
COPY ./after_work.sh /after_work.sh
RUN chmod 770 /after_work.sh

RUN mv /etc/ldap /etc/ldap.dist

COPY modules/ /etc/ldap.dist/modules

COPY entrypoint.sh /entrypoint.sh

EXPOSE 389
## DEFAULT LDAPS PORT
EXPOSE 636

VOLUME ["/etc/ldap", "/var/lib/ldap"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["sh", "-c", "slapd -h 'ldap:/// ldaps:/// ldapi:///' -d ${DEBUG_LEVEL} -u openldap -g openldap"]