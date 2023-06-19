local M = {}

M.load_plugins = function(plugins, profile)
    -- Bootstrap lazy
    local lazypath = vim.fn.stdpath("data") .. "/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup(plugins, {
        root = vim.fn.stdpath("data") .. "/plugins/" .. profile,
        lockfile = vim.fn.stdpath("data") .. "/plugins/" .. profile .. "lazy-lock.json",
    })
end

return M
