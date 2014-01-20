# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"

  config.vm.provision :salt do |salt|
    salt.always_install = true
    salt.verbose = true

    salt.minion_config = "deploy/minion.conf"
    salt.run_highstate = true  # change to true if you want
                                # `vagrant up` to automatically provision
  end

  config.vm.network :private_network, ip: "10.11.12.13"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8000, host: 8000

  config.cache.auto_detect = true

  config.vm.synced_folder "deploy/salt", "/srv/salt", :nfs => true
  config.vm.synced_folder "deploy/pillar", "/srv/pillar", :nfs => true

  config.vm.provider :virtualbox do |vb|
    vb.gui = false

    # Use VBoxManage to customize the VM. For example to change memory:
    # vb.customize ["modifyvm", :id, "--memory", "1024", "--cpuexecutioncap", "50"]
  end

end


# to run masterless:
# vagrant ssh
# salt-call --local state.highstate -l debug
