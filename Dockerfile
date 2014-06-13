FROM centos
MAINTAINER yonecle
RUN yum -y install openldap-servers

ADD config.cpio /tmp/
RUN cd /tmp ; cpio --quiet -i -F config.cpio

RUN rm -fr /etc/openldap/slapd.d
RUN cp /tmp/slapd.conf /etc/openldap/slapd.conf
RUN cp /tmp/DB_CONFIG /var/lib/ldap/DB_CONFIG ; chown ldap:ldap /var/lib/ldap/*
RUN slapadd -l /tmp/base.ldif ; slapadd -l /tmp/user.ldif ; chown ldap:ldap /var/lib/ldap/*
# RUN /usr/sbin/slapd -h ldapi:/// -u ldap ; ldapadd -x -H ldapi:/// -D "cn=Manager,dc=ad,dc=example,dc=com" -w redhat -f /tmp/base.ldif

EXPOSE 389

ENTRYPOINT ["/usr/sbin/slapd","-h,"ldap:///","ldapi:///","-u","ldap","-d1"]
