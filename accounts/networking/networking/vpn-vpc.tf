### VPC
module "vpn_vpc" {
  source = "git@github.com:org/aws-terraform-modules.git//network/vpc?ref=main"

  name = "${local.basename}-vpn"
  cidr = local.vpn_vpc_cidr

  private_subnets_bits     = 2
  private_zones            = local.vpn_vpc_zone_names
  has_nat                  = false
  vpc_s3_endpoint_enable   = true
  vpc_flow_logs_bucket_arn = local.log_archive_bucket
}

# Attach the VPC to Transit gateway
module "vpn_vpc_tgw_attachment" {
  source = "git@github.com:org/aws-terraform-modules.git//transit-gateway/attachment/"

  providers = {
    aws.transit = aws.transit
  }

  name = "${local.basename}-vpn"

  transit_gateway_id                = module.tgw.id
  transit_gateway_association_rt_id = module.tgw.propagation_rt_id
  transit_gateway_propagation_rt_id = module.tgw.association_rt_id

  vpc_id  = module.vpn_vpc.id
  subnets = module.vpn_vpc.private_subnets.ids

  # Add attached VPC RT routes to peered VPCs or Internet via TGW.
  vpc_route_peer_cidr = local.project_cidr
  vpc_route_tables    = module.vpn_vpc.rts_private
}
