local utils = require("utils")

local config = {
    colorscheme = "catppuccin-mocha",
}

local opts = {
    -- tab width
	tabstop = 4,
	shiftwidth = 4,
	expandtab = true,

    -- line numbers
    relativenumber = true,
}

local gs = {
	mapleader = " ",
}

local plugins = {
    {
        "stevearc/dressing.nvim",
        config = true,
        dependencies = {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.1",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
        },
    },
    { "nvim-tree/nvim-web-devicons" },

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    -- colorschemes
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}

local funcs = {
    new_file = {
        func = utils.wrap_cmd("enew"),
        desc = "Create a new file",
    },
    save_file = {
        func = function()
            local file_name = vim.fn.bufname()
            if file_name == "" then
                file_name = vim.fn.input("Filename (esc or leave empty to cancel): ", "", "file")
                if file_name == nil or file_name == "" then
                    return
                end
            end
            vim.cmd("write " .. file_name)
        end,
        desc = "Save the current file", 
    },

    find_files = {
        func = utils.wrap_cmd("Telescope find_files"),
        desc = "Open the file picker",
    },
    select_buffer = {
        func = utils.wrap_cmd("Telescope buffers"),
        desc = "Select a buffer",
    },

    open_terminal = {
        func = function()
            utils.make_terminal()
        end,
        desc = "Open the terminal",
    }
}

local mappings = {
    n = {
        ["<leader>p"] = utils.wrap_cmd("Funcs"),
        ["<leader>r"] = utils.wrap_cmd("Run"),
        
        ["<leader>n"] = utils.wrap_func("new_file"),
        ["<leader>w"] = utils.wrap_func("new_file"),

        ["<leader>f"] = utils.wrap_func("find_files"),
        ["<leader>b"] = utils.wrap_func("select_buffer"),
        ["<leader>t"] = utils.make_terminal,

        ["<C-Left>"] = "<C-w><Left>",
        ["<C-Right>"] = "<C-w><Right>",
        ["<C-Up>"] = "<C-w><Up>",
        ["<C-Down>"] = "<C-w><Down>",
        ["<C-h>"] = "<C-w>s",
        ["<C-v>"] = "<C-w>v",
    },
}

config.opts = opts
config.gs = gs
config.plugins = plugins
config.funcs = funcs
config.mappings = mappings
return config
