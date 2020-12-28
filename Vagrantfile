# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vagrant.plugins = ['vagrant-hosts', 'vagrant-vbguest']

  config.vbguest.installer_options = { allow_kernel_upgrade: true }

  config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'

  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '192.168.10.100', ['kdc.example.com']
    provisioner.add_host '192.168.10.101', ['ns.example.com']
    provisioner.add_host '192.168.10.102', ['client.example.com']
  end

  config.vm.define 'kdc' do |kdc|
    kdc.vm.box = 'centos/7'
    kdc.vm.hostname = 'kdc.example.com'
    kdc.vm.network 'private_network', ip: '192.168.10.100', netmask: '255.255.255.0', virtualbox__intnet: 'intnet1'

    kdc.vm.provider 'virtualbox' do |vb|
      vb.name = 'centos7_krb5_kdc'
    end

    kdc.vm.provision 'shell', path: 'scripts/kdc.sh'
  end

  config.vm.define 'dns' do |dns|
    dns.vm.box = 'centos/7'
    dns.vm.hostname = 'ns.example.com'
    dns.vm.network 'private_network', ip: '192.168.10.101', netmask: '255.255.255.0', virtualbox__intnet: 'intnet1'

    dns.vm.provider 'virtualbox' do |vb|
      vb.name = 'centos7_krb5_dns'
    end

    dns.vm.provision 'shell', path: 'scripts/dns.sh'
  end

  config.vm.define 'client' do |client|
    client.vm.box = 'centos/7'
    client.vm.hostname = 'client.example.com'
    client.vm.network 'private_network', ip: '192.168.10.102', netmask: '255.255.255.0', virtualbox__intnet: 'intnet1'

    client.vm.provider 'virtualbox' do |vb|
      vb.name = 'centos7_krb5_client'
    end

    client.vm.provision 'shell', path: 'scripts/client.sh'
  end
end
