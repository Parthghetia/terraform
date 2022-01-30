## Configure the vSphere Provider
provider "vsphere" {
    vsphere_server = "${var.vsphere_server}"
    user = "${var.vsphere_user}"
    password = "${var.vsphere_password}"
    allow_unverified_ssl = true
}

## Build VM
data "vsphere_datacenter" "dc" {
  name = "Datacenter01"
}

data "vsphere_datastore" "datastore" {
  name          = "QNAP123_DatastoreNFS"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "ocp01"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "vm-network-vlan30" {
  name          = "VLAN30-vsancluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "vm-network-asus-to-internet" {
  name          = "Asus-to-Internet"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "vm-network-vlan90" {
  name          = "VLAN90-vsancluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "masters" {
  count            = "3"
  name             = "ocp01-master-0${count.index + 1}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 4
  memory     = 16384
  wait_for_guest_net_timeout = 0
  guest_id = "rhel8_64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-vlan90.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 120
   eagerly_scrub    = false
   thin_provisioned = true
  }
}

resource "vsphere_virtual_machine" "workers" {
  count            = "4"
  name             = "ocp01-worker-0${count.index + 1}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 4
  memory     = 16384
  wait_for_guest_net_timeout = 0
  guest_id = "rhel8_64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-vlan90.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 120
   eagerly_scrub    = false
   thin_provisioned = true
  }
}
resource "vsphere_virtual_machine" "infra" {
  count            = "3"
  name             = "ocp01-infra-0${count.index + 1}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 4
  memory     = 16384
  wait_for_guest_net_timeout = 0
  guest_id = "rhel8_64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-vlan90.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 120
   eagerly_scrub    = false
   thin_provisioned = true
  }
}
resource "vsphere_virtual_machine" "bootstrap" {
  name             = "ocp01-bootstrap"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 4
  memory     = 16384
  wait_for_guest_net_timeout = 0
  guest_id = "rhel8_64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-vlan90.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 120
   eagerly_scrub    = false
   thin_provisioned = true
  }
}
resource "vsphere_virtual_machine" "bastion" {
  name             = "ocp01-bastion"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 2
  memory     = 8192
  wait_for_guest_net_timeout = 0
  guest_id = "centos8_64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-vlan30.id}"
   adapter_type   = "vmxnet3"
  }
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-asus-to-internet.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 80
   eagerly_scrub    = false
   thin_provisioned = true
  }
}
resource "vsphere_virtual_machine" "idm" {
  name             = "ocp01-idm01"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 4
  memory     = 16384
  wait_for_guest_net_timeout = 0
  guest_id = "centos8_64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-vlan30.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 120
   eagerly_scrub    = false
   thin_provisioned = true
  }
}
resource "vsphere_virtual_machine" "dhcp" {
  name             = "ocp01-dhcp"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 4
  memory     = 8192
  wait_for_guest_net_timeout = 0
  guest_id = "centos8_64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-vlan30.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 120
   eagerly_scrub    = false
   thin_provisioned = true
  }
}
resource "vsphere_virtual_machine" "lb01" {
  name             = "ocp01-lb01"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 1
  memory     = 8192
  wait_for_guest_net_timeout = 0
  guest_id = "centos8_64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-vlan30.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 80
   eagerly_scrub    = false
   thin_provisioned = true
  }
}
resource "vsphere_virtual_machine" "nexus01" {
  name             = "ocp01-nexus01"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 1
  memory     = 8192
  wait_for_guest_net_timeout = 0
  guest_id = "centos8_64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network-vlan30.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 80
   eagerly_scrub    = false
   thin_provisioned = true
  }
}
