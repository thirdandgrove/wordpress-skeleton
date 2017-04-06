# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
current_dir = File.dirname(File.expand_path(__FILE__))
settings = YAML.load_file("#{current_dir}/config.yaml")

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty32"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.hostname = settings['hostname']
  config.vm.network "private_network", ip: settings['ip']

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "..", "/vagrant", owner: "vagrant", group: "www-data"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet_manifests"
    puppet.manifest_file = "default.pp"
  end

end
