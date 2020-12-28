#!/bin/sh

set -e

yum -y install bind bind-utils krb5-workstation pam_krb5

install -o root -g root -m 0644 /vagrant/krb5.conf /etc/krb5.conf

kadmin <<EOF
secret
addprinc -randkey host/ns.example.com
ktadd host/ns.example.com
addprinc -randkey DNS/ns.example.com
ktadd -k /etc/named.keytab DNS/ns.example.com
quit
EOF

chown root:named /etc/named.keytab
chmod 0640 /etc/named.keytab

install -o root -g named -m 0640 /vagrant/named.conf /etc/named.conf

for i in example.com 10.168.192.in-addr.arpa ; do
	install -o named -g named -m 0644 /vagrant/db.${i} /var/named/dynamic
done

systemctl enable named.service
systemctl start named.service

install -o root -g root -m 0600 /vagrant/sshd_config /etc/ssh/sshd_config
install -o root -g root -m 0644 /vagrant/ssh_config /etc/ssh/ssh_config

systemctl reload sshd.service

authconfig --enablekrb5  --update

useradd test
