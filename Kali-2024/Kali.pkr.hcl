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
    vmware = {
        version = "~>1"
        source = "github.com/hashicorp/vmware"
    }
  }
}

# Variable Definitions
variable "iso_url" {
    type = string
    default = "https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-installer-amd64.iso"
    #default = "https://cdimage.kali.org/kali-2024.2/kali-linux-2024.2-installer-amd64.iso"
}

variable "iso_checksum" {
    type = string
    default = "2ba1abf570ea0685ca4a97dd9c83a65670ca93043ef951f0cd7bbff914fa724a"
    #default = "5eb9dc96cccbdfe7610d3cbced1bd6ee89b5acdfc83ffee1f06e6d02b058390c"
}

variable "vagrant_cloud_box" {
    type = string
    default = "dfir-dd/kali"
}

# You have to set this in your creds.pkr.hcl
variable "vagrant_cloud_version" {
    type = string
}

# You have to set this in your creds.pkr.hcl
variable "vagrant_cloud_id" {
    type = string
}

# You have to set this in your creds.pkr.hcl
variable "vagrant_cloud_token" {
    type = string
}

# Resource Definition for the VM Template
source "qemu" "qemu-Kali2024" {
    
    # VM General Settings
    vm_name = "Kali"
    memory = "8192" 
    cores = "8"
    sockets = "1"

    # VM OS Settings
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
    qemuargs = [ 	
    	["-machine", "type=q35,accel=kvm:whpx:tcg"],
    ]
    
    # accelerator = "kvm"
    
    net_device = "virtio-net"

    # PACKER Autoinstall Settings
    http_directory = "http" 
    
    # PACKER Boot Commands
    boot_command = [
        "<esc><wait>",
        "install <wait>",
        "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed_qemu.cfg ",
        "locale=en_US ",
        "keymap=us ",
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
    
    shutdown_command  = "echo 'vagrant' | sudo -S shutdown -P now"
} 


source "vmware-iso" "VMWare-Kali2024" {
    
    # VM General Settings
    vm_name = "Kali"
    memory = "8192" 
    cores = "8"
    network = "nat"

    # VM OS Settings
    guest_os_type = "debian10-64"
    iso_url = "${var.iso_url}"
    iso_checksum = "${var.iso_checksum}"

    # PACKER Autoinstall Settings
    http_directory = "http" 
    
    # PACKER Boot Commands
    boot_command = [
        "<esc><wait>",
        "install <wait>",
        "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed_vmware.cfg ",
        "locale=en_US ",
        "keymap=us ",
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
    
    shutdown_command  = "echo 'vagrant' | sudo -S shutdown -P now"
} 

# Build Definition to create the VM Template
build {
    name = "Kali2024"
    sources = [
        "source.vmware-iso.VMWare-Kali2024",
        "source.qemu.qemu-Kali2024"
        ]
    
    provisioner "file" {
        source = "files/hayabusa-wrapper.sh"
        destination = "/tmp/hayabusa-wrapper.sh"
    }

    provisioner "shell" {
    	execute_command = "echo 'vagrant' | {{.Vars}} sudo -S bash -euxo pipefail '{{.Path}}'"
    	scripts = [ 
    	    "scripts/base-tools.sh",
            "scripts/rust.sh",
            "scripts/regripper.sh",
            "scripts/dissect.sh",
            "scripts/ewftools.sh",
            "scripts/hayabusa.sh",
            "scripts/vagrant.sh",
            "scripts/minimize.sh"
    	]
    }

    post-processors {
        post-processor "vagrant" {
            vagrantfile_template = "Vagrantfile.tpl"
        }

        post-processor "vagrant-registry" {
            box_tag = "${var.vagrant_cloud_box}"
            client_id = "${var.vagrant_cloud_id}"
            client_secret = "${var.vagrant_cloud_token}"
            version = "${var.vagrant_cloud_version}"
            no_release = "true"
        }
    } 
}
