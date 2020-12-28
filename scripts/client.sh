#!/bin/sh

set -e

yum -y install bind-utils krb5-workstation pam_krb5

install -o root -g root -m 0644 /vagrant/krb5.conf /etc/krb5.conf

kadmin <<EOF
secret
addprinc -randkey host/client.example.com
ktadd host/client.example.com
quit
EOF

install -o root -g root -m 0600 /vagrant/sshd_config /etc/ssh/sshd_config
install -o root -g root -m 0644 /vagrant/ssh_config /etc/ssh/ssh_config

systemctl reload sshd.service

authconfig --enablekrb5  --update

useradd test
