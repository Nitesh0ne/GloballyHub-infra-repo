data "aws_ami" "ubuntu" {
  count = var.ubuntu_ami_id == "" ? 1 : 0

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  ubuntu_ami = var.ubuntu_ami_id != "" ? var.ubuntu_ami_id : data.aws_ami.ubuntu[0].id

  kubernetes_nodes = {
    control = {
      name       = "k8s-control-1"
      subnet_idx = 0
      role       = "control-plane"
    }

    worker_1 = {
      name       = "k8s-worker-1"
      subnet_idx = 1
      role       = "worker"
    }

    worker_2 = {
      name       = "k8s-worker-2"
      subnet_idx = 2
      role       = "worker"
    }
  }
}

resource "aws_instance" "kubernetes" {
  for_each = local.kubernetes_nodes

  ami           = local.ubuntu_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = aws_subnet.public[each.value.subnet_idx].id


  vpc_security_group_ids = [
    aws_security_group.kubernetes.id
  ]

  associate_public_ip_address = true

  monitoring = false

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = each.value.name
    Role = each.value.role
  }
}