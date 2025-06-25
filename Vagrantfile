hostname = ENV['VAGRANT_HOSTNAME'] || 'dev-station'
vm_memory = ENV['VAGRANT_VM_MEMORY'] || 4096
num_cpus = ENV['VAGRANT_NUM_CPUS'] || 4
vm_base_image = ENV['VAGRANT_VM_BASE_IMAGE'] || 'ubuntu/jammy64'
repositories_dir = ENV['VAGRANT_REPOSITORIES_DIR'] || '/repo'
home_dir = ENV['HOME']

Vagrant.configure("2") do |config|

  config.vm.box = vm_base_image
  config.vm.hostname = hostname


  config.vm.provider "virtualbox" do |vb|
    vb.name = hostname
    vb.cpus = num_cpus
    vb.memory = vm_memory
    vb.gui = false
  end

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
  config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh"

  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder repositories_dir, repositories_dir
  config.vm.synced_folder "userfiles", "/tmp/userfiles"

  if File.file?("./bootstrap.bash")
    config.vm.provision "shell", path: "./bootstrap.bash", privileged: true, run: "always"
  end
end
