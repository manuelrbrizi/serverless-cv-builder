locals {
  cognito_pools = {
    main_pool = {
      name = "main_user_pool"
    }
  }
}

module "cognito" {
  source   = "./modules/cognito"
  for_each = local.cognito_pools

  name = each.value.name

}