Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-24.04"

  vms = [
    { name: "cluster-control", memory: 2048, cpus: 1, ip: "192.168.56.10" },
    { name: "cluster-worker",  memory: 2048, cpus: 1, ip: "192.168.56.11" }
  ]

  vms.each do |cfg|
    config.vm.define cfg[:name] do |vm|
      vm.vm.hostname = cfg[:name]

      vm.vm.network "private_network", ip: cfg[:ip]

      vm.vm.provider "virtualbox" do |vb|
        vb.name = cfg[:name]
        vb.memory = cfg[:memory]
        vb.cpus = cfg[:cpus]

      end

    end

  end

end