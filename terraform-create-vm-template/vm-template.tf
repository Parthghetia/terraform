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

data "vsphere_network" "vm-network" {
  name          = "ASUStoInternet"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "CentOS-for-OCP"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "gitlab-03" {
  name             = "gitlab03"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus   = 2
  memory     = 8192
  wait_for_guest_net_timeout = 0
  guest_id = "ubuntu64Guest"
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.vm-network.id}"
   adapter_type   = "vmxnet3"
  }
  disk {
   label            = "disk0"
   size             = 80
   eagerly_scrub    = false
   thin_provisioned = true
  }
}