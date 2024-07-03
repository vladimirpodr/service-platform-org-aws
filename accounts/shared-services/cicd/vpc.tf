### VPC
module "vpc" {
  source = "git@github.com:org/aws-terraform-modules.git//network/vpc?ref=main"

  name = local.basename
  cidr = local.vpc_cidr

  private_zones = local.zone_names

  private_subnets_base     = 0
  private_subnets_bits     = 2
  has_nat                  = false
  vpc_s3_endpoint_enable   = true
  vpc_flow_logs_bucket_arn = local.log_archive_bucket
}

# Attach the VPC to Transit gateway
module "tgw-attachment" {
  source = "git@github.com:org/aws-terraform-modules.git//transit-gateway/attachment/"

  providers = {
    aws.transit = aws.transit
  }

  name = local.basename

  transit_gateway_id                = local.tgw.id
  transit_gateway_association_rt_id = local.tgw.propagation_rt_id
  transit_gateway_propagation_rt_id = local.tgw.propagation_rt_id

  vpc_id  = module.vpc.id
  subnets = module.vpc.private_subnets.ids

  # Add attached VPC RT routes to peered VPCs or Internet via TGW.
  vpc_route_peer_cidr = "0.0.0.0/0"
  vpc_route_tables    = module.vpc.rts_private
}

# TG RT Routes: route from env VPCs to Pipeline VPC
resource "aws_ec2_transit_gateway_route" "tgw_rt" {
  provider = aws.transit

  transit_gateway_route_table_id = local.tgw.association_rt_id
  destination_cidr_block         = local.vpc_cidr
  transit_gateway_attachment_id  = module.tgw-attachment.id
}
