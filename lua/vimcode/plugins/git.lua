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

return M
