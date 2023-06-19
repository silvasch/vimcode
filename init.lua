local vimcode = require("vimcode")

-- load config
local profile = os.getenv("NVIM_PROFILE")
if profile == nil then
    profile = require("config").default_profile
end
if profile == "none" then
    return
end
local config = require("config.profiles." .. profile)

local opts = config.opts or {}
local gs = config.gs or {}
local plugins = config.plugins or {}
local funcs = config.funcs or {}
local mappings = config.mappings or {}

vimcode.options.load_opts(opts)
vimcode.options.load_gs(gs)
vimcode.plugins.load_plugins(plugins, profile)
vimcode.funcs.create_user_command(funcs)
vimcode.mappings.load_mappings(mappings)
vimcode.run.create_user_command()
vim.cmd("colorscheme " .. config.colorscheme)
