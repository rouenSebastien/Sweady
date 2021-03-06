resource "scaleway_server" "swarm_glusterfs" {
  name  = "swarm_glusterfs-${count.index + 1}"
  image = "${data.scaleway_image.docker.id}"
  type  = "${var.scw_type_glusterfs}"
  count = "${var.swarm_glusterfs}"
  dynamic_ip_required = true
  security_group = "${scaleway_security_group.swarm.id}"

  volume {
    size_in_gb = 50
    type = "l_ssd"
  }

  provisioner "local-exec" {
    command = "sleep 30 && ansible-playbook -i '${self.public_ip},' --private-key ${var.scw_ssh_key} '../../ansible/swarm_glusterfs.ansible.yaml' -e 'disk=vdb' -T 300 --user=root"
  }
}