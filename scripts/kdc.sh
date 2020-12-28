#!/bin/sh

set -e

yum -y install krb5-server krb5-workstation pam_krb5

install -o root -g root -m 0600 /vagrant/kdc.conf /var/kerberos/krb5kdc/kdc.conf
install -o root -g root -m 0600 /vagrant/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl

install -o root -g root -m 0644 /vagrant/krb5.conf /etc/krb5.conf

kdb5_util create -s -r EXAMPLE.COM <<EOF
password
password
EOF

for i in krb5kdc kadmin ; do
	systemctl enable ${i}.service
	systemctl start ${i}.service
done

kadmin.local <<EOF
addprinc root/admin
secret
secret
addprinc test
test
test
addprinc -randkey host/kdc.example.com
ktadd host/kdc.example.com
quit
EOF

install -o root -g root -m 0600 /vagrant/sshd_config /etc/ssh/sshd_config
install -o root -g root -m 0644 /vagrant/ssh_config /etc/ssh/ssh_config

systemctl reload sshd.service

authconfig --enablekrb5  --update

useradd test
