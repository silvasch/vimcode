local M = {}

M.clone = function(dir, url, name, branch, on_success)
    local command_args = {
        "clone",
        "--depth=1",
        url,
    }
    if not (branch == nil) then
        table.insert(command_args, "--branch")
        table.insert(command_args, branch)
    end
    table.insert(command_args, name)

    vim.loop.spawn(
        "git",
        {
            args = command_args,
            cwd = dir,
        },
        vim.schedule_wrap(function(code)
            if code == 0 then
                on_success()
            else
                error(string.format("failed to clone '%s' (%s)", name, url))
            end
        end)
    )
end

M.pull = function(dir, name, on_success)
    local dir = opt..name
    local branch = vim.fn.system('git -C " .. dir .. " branch --show-current | tr -d "\n"')
    vim.loop.spawn(
        "git",
        {
            args = { "pull", "origin", branch, "--update-shallow", "--ff-only", "--progress", "--rebase=false" },
            cwd = dir,
        },
        vim.schedule_wrap(function(code)
            if code == 0 then
                on_success()
            else
                error(string.format("failed to pull '%s' (%s)", name, url))
            end
        end)
    )
end

return M
