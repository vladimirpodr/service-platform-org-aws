### Transit Gateway: Interconnect project VPCs
module "tgw" {
  source  = "git@github.com:org/aws-terraform-modules.git//transit-gateway/gateway?ref=main"

  description = "Connect ${var.project_name} VPCs to Egress VPC."

  name = local.basename
}

### Create Transit Gateway Route for Association route table:
### To drop traffic between spoke VPCs
resource "aws_ec2_transit_gateway_route" "route_to_blackhole" {
  transit_gateway_route_table_id = module.tgw.association_rt_id
  destination_cidr_block         = local.project_cidr
  blackhole                      = true
}

### Share Transit Gateway with other accounts in Organization
resource "aws_ram_resource_share" "tgw_share" {
  name                      = "${local.basename}-tgw-share"
  allow_external_principals = false

  tags = {
    Name = "${local.basename}-tgw-share"
  }
}

data "aws_organizations_organization" "org_com" {}

resource "aws_ram_principal_association" "tgw_share" {
  principal          = data.aws_organizations_organization.org_com.arn
  resource_share_arn = aws_ram_resource_share.tgw_share.arn
}

resource "aws_ram_resource_association" "tgw_share" {
  resource_arn       = module.tgw.arn
  resource_share_arn = aws_ram_resource_share.tgw_share.arn
}
