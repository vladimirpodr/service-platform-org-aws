### VPC
module "egress_vpc" {
  source  = "git@github.com:org/aws-terraform-modules.git//network/vpc?ref=main"

  name = "${local.basename}-egress"
  cidr = local.egress_vpc_cidr

  public_zones  = local.vpc_zone_names
  private_zones = local.vpc_zone_names

  public_subnets_bits      = 3
  private_subnets_base     = 4
  private_subnets_bits     = 3
  vpc_s3_endpoint_enable   = true
  vpc_flow_logs_bucket_arn = local.log_archive_bucket
}

# Attach the VPC to Transit gateway
module "egress_vpc_tgw_attachment" {
  source    = "git@github.com:org/aws-terraform-modules.git//transit-gateway/attachment/"
  providers = {
    aws.transit = aws.transit
  }

  name = "${local.basename}-egress"

  transit_gateway_id                = module.tgw.id
  transit_gateway_association_rt_id = module.tgw.propagation_rt_id

  vpc_id              = module.egress_vpc.id
  subnets             = module.egress_vpc.private_subnets.ids

  # Add attached VPC RT routes to peered VPCs or Internet via TGW.
  vpc_route_peer_cidr = local.project_cidr
  vpc_route_tables    = module.egress_vpc.rt_public
}

# TG RT Routes: all private egress traffic to the Internet should be routed via Egress VPC
resource "aws_ec2_transit_gateway_route" "tgw_rt_assoc" {
  transit_gateway_route_table_id = module.tgw.association_rt_id

  destination_cidr_block = "0.0.0.0/0"

  transit_gateway_attachment_id = module.egress_vpc_tgw_attachment.id
}

resource "aws_ec2_transit_gateway_route" "tgw_rt_prop" {
  transit_gateway_route_table_id = module.tgw.propagation_rt_id

  destination_cidr_block = "0.0.0.0/0"

  transit_gateway_attachment_id = module.egress_vpc_tgw_attachment.id
}
