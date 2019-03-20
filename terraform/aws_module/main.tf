provider "aws" {
  region = "${var.region}"
}

resource "aws_lb" "nlb" {
  name                             = "nlb"
  internal                         = false
  load_balancer_type               = "network"
  subnets                          = "${var.subnet_ids}"
  enable_cross_zone_load_balancing = true

  tags {
    Name = "morze_balancer"
  }
}

resource "aws_lb_listener" "morze" {
  load_balancer_arn = "${aws_lb.nlb.arn}"
  port              = "5000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.morze.arn}"
  }
}

resource "aws_lb_target_group" "morze" {
  name     = "${var.name}"
  port     = 5000
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "morze" {
  count            = "${var.count}"
  target_group_arn = "${aws_lb_target_group.morze.arn}"
  target_id        = "${element(aws_instance.morze.*.id, count.index)}"
  port             = 5000
}

resource "aws_instance" "morze" {
  count           = "${var.count}"
  ami             = "${var.ami}"
  security_groups = ["${aws_security_group.instances.name}"]
  instance_type   = "t2.micro"

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_security_group" "instances" {
  name        = "${var.name}"
  description = "Allow inbound traffic from nlb to instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "balancers" {
  zone_id = "${var.route53_zone_id}"
  name    = "morze.aws.ctrlok.dev"
  type    = "A"

  set_identifier = "${var.name}-${var.region}"

  latency_routing_policy {
    region = "${var.region}"
  }

  alias {
    name                   = "${aws_lb.nlb.dns_name}"
    zone_id                = "${aws_lb.nlb.zone_id}"
    evaluate_target_health = true
  }
}
