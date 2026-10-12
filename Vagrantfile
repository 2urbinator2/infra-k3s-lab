Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-24.04"

  vms = [
    { name: "cluster-control", memory: 2048, cpus: 1 },
    { name: "cluster-worker",  memory: 2048, cpus: 1 }
  ]

  vms.each do |cfg|
    config.vm.define cfg[:name] do |vm|
      vm.vm.hostname = cfg[:name]

      vm.vm.provider "virtualbox" do |vb|
        vb.name = cfg[:name]
        vb.memory = cfg[:memory]
        vb.cpus = cfg[:cpus]

        vb.customize ["modifyvm", :id, "--nic2", "natnetwork",  "--nat-network2", "NatNetwork"]
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