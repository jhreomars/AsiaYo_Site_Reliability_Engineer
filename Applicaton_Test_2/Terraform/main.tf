locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "networking" {
  source = "./modules/networking"
  
  name_prefix        = local.name_prefix
  vpc_cidr          = var.vpc_cidr
  availability_zones = var.availability_zones
  
  environment = var.environment
  
  tags = merge(
    var.default_tags,
    {
      Module = "networking"
    }
  )
}

module "eks" {
  source = "./modules/eks"
  depends_on = [module.networking]
  
  name_prefix     = local.name_prefix
  cluster_version = "1.27"
  
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
  
  environment = var.environment
  
  node_groups = {
    general = {
      name           = "general"
      instance_types = ["t3.large"]
      min_size      = 3
      max_size      = 5
      desired_size  = 3
    }
  }
  
  tags = merge(
    var.default_tags,
    {
      Module = "eks"
    }
  )
}

module "ecr" {
  source = "./modules/ecr"
  
  name_prefix = local.name_prefix
  environment = var.environment
  
  tags = merge(
    var.default_tags,
    {
      Module = "ecr"
    }
  )
}