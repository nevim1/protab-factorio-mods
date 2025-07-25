local AutoBuildOutpost = {
  type = "bool-setting",
  name = "AutoBuildOutpost",
  setting_type = "runtime-global",
  default_value = false
}

data:extend({AutoBuildOutpost})

local bfsMaxDepth = {
  type = "int-setting",
  name = "bfsMaxDepth",
  setting_type = "runtime-per-user",
  minimum_value = 10,
  default_value = 150000
}

data:extend({bfsMaxDepth})
