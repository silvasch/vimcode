local vimcode = require("vimcode")

local config = require("config")

local opts = config.opts or {}
local gs = config.gs or {}
local plugins = config.plugins or {}
local funcs = config.funcs or {}
local mappings = config.mappings or {}

vimcode.plugins.load_plugins(plugins)

vimcode.options.load_opts(opts)
vimcode.options.load_gs(gs)

vimcode.funcs.create_user_command(funcs)
vimcode.mappings.load_mappings(mappings)
vimcode.run.create_user_command()

if not (config.colorscheme == nil) then
    vim.cmd("colorscheme " .. config.colorscheme)
end

