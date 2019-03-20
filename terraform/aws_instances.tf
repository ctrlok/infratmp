module "aws-us-east-1" {
  source          = "./aws_module/"
  region          = "us-east-1"
  subnet_ids      = ["subnet-2b07424e", "subnet-36daca1e", "subnet-5ad54756"]
  name            = "morze"
  ami             = "ami-0073aa21979fcd18a"                                   // Generated bu Packer, Possible to switch to latest version, but I'm not sure that is a good idea
  vpc_id          = "vpc-d749f8b2"
  route53_zone_id = "ZPFJ4CNL4HAM9"
  count           = 2
}
