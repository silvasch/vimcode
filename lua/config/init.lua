local utils = require("vimcode.utils")

local config = {
    colorscheme = "catppuccin",
}

local plugins = {
    {
        name = "nvim-autopairs",
        on_load = function()
            require("nvim-autopairs").setup({})
        end,
    },

    { name = "plenary.nvim", },
    { name = "telescope.nvim", },
    { name = "dressing.nvim", },

    { name = "nvim-lspconfig" },
    { name = "nvim-cmp" },
    { name = "cmp-nvim-lsp" },
    { name = "LuaSnip" },
    {
        name = "lsp-zero.nvim",
        on_load = function()
            local lsp = require("lsp-zero").preset("recommended")

            lsp.setup_servers({
                "rust_analyzer",
                "clangd",
                "gopls",
            })

            require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

            lsp.setup()

            local cmp = require("cmp")

            cmp.setup({
                mapping = {
                    ["<cr>"] = cmp.mapping.confirm({ select = false }),
                },
            })
        end
    },

    {
        name = "nvim-treesitter",
        on_load = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "c",
                    "rust",
                    "python",
                    "go",
                },
                highlight = {
                    enable = true,
                },
            })
        end,
    },

    { name = "catppuccin", },
}

local opts = {
    -- tab width
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,

    -- line numbers
    number = true,
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

    lazygit = {
        func = function()
            vim.cmd("terminal lazygit")
            vim.cmd("startinsert")
        end,
        desc = "Open lazygit",
    },

    lsp_rename = {
        func = vim.lsp.buf.rename,
        desc = "LSP: Rename the current symbol",
    },
    lsp_actions = {
        func = vim.lsp.buf.code_action,
        desc = "LSP: Code actions",
    },
    lsp_hover = {
        func = vim.lsp.buf.hover,
        desc = "LSP: Hover",
    },
    lsp_format = {
        func = vim.lsp.buf.format,
        desc = "LSP: Format",
    },

    open_terminal = {
        func = function()
            vim.cmd("vsplit")
            vim.cmd("wincmd w")
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
        func = function()
            local handle = io.popen(
            "find -not -path './.git/*' -not -path './target/*' -not -path './node_modules/*' -type f")
            if handle == nil then
                error("failed to list files")
            end
            local result = handle:read("*a")
            handle:close()
            local files = {}
            for s in result:gmatch("[^\r\n]+") do
                table.insert(files, s)
            end
            vim.ui.select(
                files,
                { prompt = "Open..." },
                function(choice)
                    if choice == nil then
                        return
                    end
                    vim.cmd("e " .. choice)
                end
            )
        end,
        desc = "Open the file picker",
    },

    select_colorscheme = {
        func = function()
            local before_color = vim.api.nvim_exec("colorscheme", true)

            local colors = { before_color }
            if not vim.tbl_contains(colors, before_color) then
                table.insert(colors, 1, before_color)
            end

            colors = vim.list_extend(
                colors,
                vim.tbl_filter(function(color)
                    return color ~= before_color
                end, vim.fn.getcompletion("", "color"))
            )

            vim.ui.select(
                colors,
                { prompt = "Select colorscheme..." },
                function(choice)
                    if choice == nil then
                        return
                    end
                    vim.cmd("colorscheme " .. choice)
                end
            )
        end,
        desc = "Select colorscheme",
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
        ["f"] = utils.wrap_func("open_file_picker"),

        ["<leader>la"] = utils.wrap_func("lsp_actions"),
        ["<leader>lr"] = utils.wrap_func("lsp_rename"),
        ["<leader>lh"] = utils.wrap_func("lsp_hover"),

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

config.plugins = plugins
config.opts = opts
config.gs = gs
config.funcs = funcs
config.mappings = mappings

return config
