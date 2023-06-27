local M = {}

-- <data>/site/pack/plugins/opt

M.load_plugins = function(plugins)
    for _, plugin in ipairs(plugins) do
        vim.cmd("packadd! " .. plugin)
    end
end

return M
