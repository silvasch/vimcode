local M = {}

M.wrap_cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

M.wrap_func = function(func_name)
    return M.wrap_cmd("Funcs " .. func_name)
end

return M

