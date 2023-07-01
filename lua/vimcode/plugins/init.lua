local git = require("vimcode.plugins.git")

local plugins_dir = vim.fn.stdpath("data") .. "/site/pack/plugins/opt/"
local config_file  = vim.fn.stdpath("config") .. "/lua/config/init.lua"

local M = {}

function add_plugin(opts)
    local url = opts.fargs[1]
    local name = opts.fargs[2]
    if name == nil then
        error("name is required")
    end
    local branch = opts.fargs[3]

    local file = io.open(config_file, "r")
    io.input(file)

    lines_before = {}
    lines_after = {}
    found_plugins_section = false

    for line in io.lines() do
        if string.find(line, "-> plugins end") then
            found_plugins_section = true 
        end

        if found_plugins_section then
            table.insert(lines_after, line)
        else
            table.insert(lines_before, line)
        end
    end

    io.close()

    local out = ""
    for _, line in ipairs(lines_before) do
        out = out .. line .. "\n"
    end
    if branch == nil then
        out = out .. string.format([[-- -> %s begin
{
    url = "%s",
    name = "%s",
},
-- -> %s end
]], name, url, name, name)
    else
        out = out .. string.format([[-- -> %s begin
{
    url = "%s",
    name = "%s",
    branch = "%s",
},
-- -> %s end
]], name, url, name, branch, name)
    end
    for _, line in ipairs(lines_after) do
        out = out .. line .. "\n"
    end

    local file = io.open(config_file, "w")
    io.output(file)
    io.write(out)
    io.close()

    load_plugin({
        url = url,
        name = name,
        branch = branch,
    })

    print(string.format("Added package '%s'. Restart neovim to load it.", name))
end

function remove_plugin(name)
    local file = io.open(config_file, "r")
    io.input(file)

    local is_at_entry = false

    out = ""
    for line in io.lines() do
        if not is_at_entry then
            if string.find(line, string.format("-> %s begin", name))  then
                is_at_entry = true
            end
        end

        if not is_at_entry then
            out = out .. line .. "\n"
        end

        if is_at_entry then
            if string.find(line, string.format("-> %s end", name)) then
                is_at_entry = false
            end
        end
    end

    local file = io.open(config_file, "w")
    io.output(file)
    io.write(out)
    io.close()

    os.execute("rm -rf " .. plugins_dir .. name)

    print(string.format("Removed package '%s'. Restart neovim for the changes to take effect.", name))
end

function load_plugin(plugin)
    if not (vim.fn.isdirectory(plugins_dir .. plugin.name) ~= 0) then
        git.clone(plugins_dir, plugin.url, plugin.name, plugin.branch, function()
            vim.cmd("packadd! " .. plugin.name)
            print("Called on_success")
        end)
    else
        vim.cmd("packadd! " .. plugin.name)
    end

    if not (plugin.on_load == nil) then
        plugin.on_load()
    end
end

M.load_plugins = function(plugins)
    if plugins == nil then
        return
    end

    vim.fn.mkdir(plugins_dir, "p")

    for _, plugin in ipairs(plugins) do
        load_plugin(plugin)
    end

    vim.api.nvim_create_user_command(
        "PackAdd",
        function(opts)
            add_plugin(opts)
        end,
	    { nargs = "+" }
    )
    vim.api.nvim_create_user_command(
        "PackRm",
        function(opts)
            remove_plugin(opts.fargs[1])
        end,
	    { nargs = 1 }
    )
end

return M
