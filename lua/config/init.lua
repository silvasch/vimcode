local utils = require("vimcode.utils")
local adv_funcs = require("config.adv_funcs")

local config = {}

local opts = {
    -- tab width
	tabstop = 4,
	shiftwidth = 4,
	expandtab = true,

    -- line numbers
    relativenumber = true,

    signcolumn = "yes",
}

local gs = {
	mapleader = " ",
}

local funcs = {
    new_file = {
        func = utils.wrap_cmd("enew"),
        desc = "Create a new file",
    },
    save_file = {
        func = adv_funcs.save_file,
        desc = "Save the current file", 
    },

    open_terminal = {
        func = function()
            vim.cmd("terminal")
            vim.cmd("startinsert")
        end,
        desc = "Open the terminal",
    },
    open_file_explorer = {
        func = utils.wrap_cmd("Explore"),
        desc = "Open the file explorer",
    },
    open_file_picker = {
        func = adv_funcs.file_picker,
        desc = "Open the file picker",
    },

    open_config = {
        func = function()
            vim.cmd("e " .. vim.fn.stdpath("config") .. "/lua/config/init.lua") 
        end,
        desc = "Open the config file",
    },
}

local mappings = {
    n = {
        ["<leader>p"] = utils.wrap_cmd("Funcs"),
        ["<leader>r"] = utils.wrap_cmd("Run"),
        
        ["<leader>n"] = utils.wrap_func("new_file"),
        ["<leader>w"] = utils.wrap_func("save_file"),

        ["<leader>t"] = utils.wrap_func("open_terminal"),
        ["<leader>e"] = utils.wrap_func("open_file_explorer"),
        ["<leader>f"] = utils.wrap_func("open_file_picker"),

        ["<C-Left>"] = "<C-w><Left>",
        ["<C-Right>"] = "<C-w><Right>",
        ["<C-Up>"] = "<C-w><Up>",
        ["<C-Down>"] = "<C-w><Down>",
        ["<C-h>"] = "<C-w>s",
        ["<C-v>"] = "<C-w>v",
    },
    t = {
        ["<esc>"] = "<C-d>",
    },
}

config.opts = opts
config.gs = gs
config.funcs = funcs
config.mappings = mappings
return config

