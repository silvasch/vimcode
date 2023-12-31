local M = {}

M.load_plugins = function(plugins)
    vim.cmd("set packpath+=" .. vim.fn.stdpath("config") .. "/lua/config/plugins")

    for _, plugin in ipairs(plugins) do
        vim.cmd("packadd! " .. plugin.name)
        if not (plugin.on_load == nil) then
            plugin.on_load()
        end
    end
end

return M
