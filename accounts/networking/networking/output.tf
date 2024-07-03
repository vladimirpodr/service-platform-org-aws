### Outputs
output "tgw" {
  value = {
    id                = module.tgw.id
    association_rt_id = module.tgw.association_rt_id
    propagation_rt_id = module.tgw.propagation_rt_id
  }
}

output "egress_vpc" {
  value = {
    id   = module.egress_vpc.id
    name = module.egress_vpc.name
    cidr = local.egress_vpc_cidr

    rt_default  = module.egress_vpc.rt_default
    rt_public   = module.egress_vpc.rt_public
    rts_private = module.egress_vpc.rts_private
  }
}

output "egress_vpc_tgw_attachment_id" {
  value = module.egress_vpc_tgw_attachment.id
}

output "vpn_vpc" {
  value = {
    id   = module.vpn_vpc.id
    name = module.vpn_vpc.name
    cidr = local.vpn_vpc_cidr

    rt_default  = module.vpn_vpc.rt_default
    rt_public   = module.vpn_vpc.rt_public
    rts_private = module.vpn_vpc.rts_private
  }
}

output "vpn_vpc_tgw_attachment_id" {
  value = module.vpn_vpc_tgw_attachment.id
}
