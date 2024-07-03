### Outputs
output "vpc" {
  value = {
    id   = module.vpc.id
    name = module.vpc.name
    cidr = local.vpc_cidr

    rt_default  = module.vpc.rt_default
    rt_public   = module.vpc.rt_public
    rts_private = module.vpc.rts_private
  }
}