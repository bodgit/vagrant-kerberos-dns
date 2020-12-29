# Vagrant Kerberos realm

This Vagrantfile spins up three CentOS 7 virtual machines:

* A KDC configured with an `EXAMPLE.COM` realm.
* A BIND instance configured for GSS-TSIG dynamic updates hosting the following zones:
  * `example.com.`
  * `10.168.192.in-addr.arpa.`
* A client machine with the BIND utilities installed.

All three machines have SSH configured to allow GSSAPI.

Get up and running:
```
$ vagrant plugin install vagrant-hosts vagrant-vbguest
$ vagrant up
$ vagrant ssh client
```
Currently only VirtualBox is supported.
