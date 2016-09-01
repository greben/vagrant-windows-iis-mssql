# -*- mode: ruby -*-
# vi: set ft=ruby :

#raise "vagrant-vbguest plugin must be installed" unless Vagrant.has_plugin? "vagrant-reload"
required_plugins = %w(vagrant-reload)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'


if ! File.exists?('./NDP452-KB2901907-x86-x64-AllOS-ENU.exe')
  puts '.Net 4.5.2 installer could not be found!'
  puts "Please run:\n curl -O http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-64-#AllOS-ENU.exe"
  exit 1
end

if ! File.exists?('./BuildTools_Full.exe')
  puts 'Microsoft Build Tools 2013 installer could not be found!'
  puts "Please run:\n curl -O http://download.microsoft.com/download/9/B/B/9BB1309E-1A8F-4A47-A6C5-ECF76672A3B3/BuildTools_Full.exe"
  exit 1
end

if ! File.exists?('./SQLEXPRWT_x64_ENU.exe')
  puts 'SQL Server installer could not be found!'
  puts "Please run:\n curl -O http://download.microsoft.com/download/0/4/B/04BE03CD-EAF3-4797-9D8D-2E08E316C998/SQLEXPRWT_x64_ENU.exe"
  exit 1
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|  

  def provisioning(config, shell_arguments)
    config.vm.provision "shell", path: "vagrant-scripts/provision.cmd", args: shell_arguments
  end


  config.vm.provider "virtualbox" do |vb|
      #vb.memory = "2048"
      vb.memory = "1200"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--vram", "128"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "win2008r2"   
  end  

  config.vm.boot_timeout = 600

  config.vm.define "win2k8r2_dev" do|win2k8r2_dev|
    win2k8r2_dev.vm.box = "ferventcoder/win2008r2-x64-nocm"
    win2k8r2_dev.vm.guest = :windows
    
    win2k8r2_dev.vm.communicator = "winrm"
    
    win2k8r2_dev.vm.network "private_network", ip: "192.168.123.123"
    win2k8r2_dev.vm.network :forwarded_port, guest: 1025, host: 1025
    win2k8r2_dev.vm.network :forwarded_port, guest: 3389, host: 1234
    win2k8r2_dev.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    win2k8r2_dev.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: false
   
	  provisioning(win2k8r2_dev, ["win2k8r2_dev", "win2k8r2_dev"])

    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/setup-winrm.cmd"  

    # synced folder
    win2k8r2_dev.vm.synced_folder "../shared", "/host_shared"
    win2k8r2_dev.vm.synced_folder "../src", "/src"
    # .NET 4.5
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/install-dot-net.ps1"  
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/install-dot-net-45.cmd"
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/install-msbuild-tools-2013.cmd"

	  # Run a reboot of a Windows guest, assuming that you are set up with the
  	# relevant plugins and configurations to manage a Windows guest in
  	# Vagrant.
  	#win2k8r2_dev.vm.provision :windows_reboot

    # Database
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/install-sql-server.cmd" 
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/configure-sql-server.ps1"  
    
    #Restore DB
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/create-database.cmd"
     
    # IIS   
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/install-iis.cmd"
      
    #Create Website
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/copy-website.ps1"
    
    # this can be run by a provision but it's intent is to be use to update a running box with new code
    # win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/copy-src-to-website.ps1"
    # if this build fail the rest of the provison script will not be run
    #  win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/build-website.cmd"
    
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/creating-website-in-iis.cmd"
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/setup-permissions-for-website-folder.ps1"
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/install-boxstarter.ps1"
	  #win2k8r2_dev.vm.provision :reload
    win2k8r2_dev.vm.provision :shell, path: "vagrant-scripts/boxstarter-install-apps.ps1"
    win2k8r2_dev.vm.provision "file",
           source: "vagrant-scripts/boxstarter-install-apps.ps1",
           destination: "desktop\\boxstarter-install-apps.ps1" 

	 #config.vm.define "win2k8r2_prod" do |win2k8r2_prod|
	 #   win2k8r2_prod.vm.box = "dummy"
	 #   provisioning(win2k8r2_prod, ["win2k8r2_prod", "ubuntu"])
   #end 
              
  end
end