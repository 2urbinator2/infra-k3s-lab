Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-24.04"

  nat_exists = `VBoxManage list natnetworks`.include?("NatNetwork")

  if !nat_exists
    system("VBoxManage natnetwork add --netname NatNetwork --network 10.0.3.0/24 --dhcp on")
    system("VBoxManage natnetwork start --netname NatNetwork")
  end

  vms = [
  { name: "cluster-control", memory: 2048, cpus: 1 },
  { name: "cluster-worker", memory: 1024, cpus: 1 }
  ]

  vms.each do |cfg|
    config.vm.define cfg[:name] do |vm|
      vm.vm.hostname = cfg[:name]

      vm.vm.network "private_network", type: "dhcp", adapter: 3

      if cfg[:name] == "cluster-control"
        vm.vm.network "forwarded_port", guest: 30080, host: 30080 
        vm.vm.network "forwarded_port", guest: 31000, host: 31000  
      end

      vm.vm.provider "virtualbox" do |vb|
        vb.name = cfg[:name]
        vb.memory = cfg[:memory]
        vb.cpus = cfg[:cpus]

        vb.customize ["modifyvm", :id, "--nic2", "natnetwork", "--nat-network2", "NatNetwork"]
      end
    end
  end

  config.vm.provision "shell", inline: <<-SHELL, run: "always"
  if ! command -v dhclient > /dev/null; then
    apt-get update
    apt-get install -y isc-dhcp-client
  fi

  sudo dhclient enp0s9
  SHELL

end