# Kali 2024
# ---
# Packer Template to create an Kali for Qemu

# Packer Config

packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
	vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

# Variable Definitions
variable "iso_url" {
    type = string
    default = "https://cdimage.kali.org/kali-2024.1/kali-linux-2024.1-installer-amd64.iso"
}

variable "iso_checksum" {
    type = string
    default = "c150608cad5f8ec71608d0713d487a563d9b916a0199b1414b6ba09fce788ced"
}

# Resource Definition for the VM Template
source "qemu" "Kali2024" {
    
    # VM General Settings
    vm_name = "Kali"
    memory = "8192" 
    cores = "8"
    sockets = "1"

    # VM OS Settings
    # (Option 1) Local ISO File
    #iso_file = "local:iso/kali-linux-2024.1-installer-amd64.iso"
    # - or -
    # (Option 2) Download ISO
    iso_url = "${var.iso_url}"
    iso_checksum = "${var.iso_checksum}"

    # Disk Settings
    disk_interface    = "virtio-scsi"
    disk_size         = "25G"
    format            = "qcow2"
    disk_discard      = "ignore"
    disk_detect_zeroes= "unmap"
    disk_cache        = "writeback"
    disk_image        = false
    disk_compression  = true
    
    # Qemu Settings
#    qemuargs = [ 	
#    	["-machine", "type=q35,accel=kvm:whpx:tcg"],
#    ]
    
    accelerator = "kvm"
    
    net_device = "virtio-net"

    # PACKER Autoinstall Settings
    http_directory = "http" 
    
    # PACKER Boot Commands
    boot_command = [
        "<esc><wait>",
        "install <wait>",
        "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
        "locale=en_US ",
        "keymap=de ",
        "hostname=kali ",
        "domain='' ",
        "<enter>"
      ]
    boot_wait = "5s"

    # SSH Settings
    ssh_username = "vagrant"
    
    # (Option 1) Add your Password here
    ssh_password = "vagrant"
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    #ssh_private_key_file = "~/.ssh/tempkey_ed"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "60m"
    
    shutdown_command  = "echo 'vagrant2' | sudo -S shutdown -P now"
} 

# Build Definition to create the VM Template
build {
    name = "Kali2024"
    sources = ["source.qemu.Kali2024"]
    
    provisioner "shell" {
    	execute_command = "echo 'vagrant' | {{.Vars}} sudo -S bash -euxo pipefail '{{.Path}}'"
    	scripts = [ 
    	    "scripts/vagrant.sh",
    	    "scripts/minimize.sh"
    	]
    }
    
    post-processor "vagrant" {
        vagrantfile_template = "Vagrantfile.tpl"
    }
}

