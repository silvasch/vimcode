local M = {}

M.wrap_cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

M.wrap_func = function(func_name)
    return M.wrap_cmd("Funcs " .. func_name)
end

M.make_terminal = function(cmd)
    vim.cmd("split")
    vim.cmd("wincmd j")
    if cmd == nil then
        vim.cmd("terminal")
    else
        vim.cmd("terminal " .. cmd)
    end
    vim.cmd("startinsert")
end

return M
