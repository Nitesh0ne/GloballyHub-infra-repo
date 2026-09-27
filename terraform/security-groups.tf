resource "aws_security_group" "kubernetes" {
  name        = "${var.project_name}-kubernetes"
  description = "Security group for the Kubernetes cluster"
  vpc_id      = aws_vpc.kubernetes.id

  tags = {
    Name = "${var.project_name}-kubernetes-sg"
  }
}

# SSH access for administration and Ansible.
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.kubernetes.id
  description       = "SSH administration and Ansible"
  cidr_ipv4         = var.ssh_allowed_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Kubernetes API access.
resource "aws_vpc_security_group_ingress_rule" "kubernetes_api" {
  security_group_id = aws_security_group.kubernetes.id
  description       = "Kubernetes API access"
  cidr_ipv4         = var.kubernetes_api_allowed_cidr
  from_port         = 6443
  ip_protocol       = "tcp"
  to_port           = 6443
}

# HTTP ingress.
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.kubernetes.id
  description       = "HTTP application ingress"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# HTTPS ingress.
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.kubernetes.id
  description       = "HTTPS application ingress"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Kubernetes node-to-node communication.
# Only instances using this security group can use this rule.
resource "aws_vpc_security_group_ingress_rule" "cluster_internal" {
  security_group_id            = aws_security_group.kubernetes.id
  description                  = "All traffic between Kubernetes nodes"
  referenced_security_group_id = aws_security_group.kubernetes.id
  ip_protocol                  = "-1"
}

# Allow nodes to reach the Internet for OS packages,
# container images, Kubernetes components, etc.
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.kubernetes.id
  description       = "Allow outbound Internet traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
