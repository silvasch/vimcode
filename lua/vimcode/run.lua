local M = {}

function find_run_config()
    local file_dir = vim.fn.getcwd()
    local file_name = "run.json"
    while true do
        local f = io.open(file_dir .. "/" .. file_name, "r")
        if f ~= nil then
            io.close(f)
            break
        end
        file_dir = vim.fn.fnamemodify(file_dir, ":h")
    end
    return file_dir .. "/" .. file_name
end

function run(name, run_config)
    if name == nil then
        return
    end

    if run_config[name] == nil then
        print("'" .. name .. "' is not a name of a run config")
        return
    end

    vim.cmd("terminal " .. run_config[name].command)
    vim.cmd("startinsert")
end

function show_runs(run_config)
    local run_descriptions = {}
    for _, run in pairs(run_config) do
        table.insert(run_descriptions, run.desc)
    end

    local run_name = nil

    vim.ui.select(run_descriptions, {
        prompt = "Run..."
    }, function(choice)
        if choice == nil then
            return
        end

        for name, run in pairs(run_config) do
            if run.desc == choice then
                run_name = name
            end
        end
    end)

    return run_name
end

M.create_user_command = function()
    vim.api.nvim_create_user_command(
        "Run",
        function(opts)
            local file = io.open(find_run_config(), "r")
            io.input(file)
            local run_config = vim.json.decode(
                io.read("*a"),
                {
                    luanil = {
                        object = true,
                        array = true,
                    },
                }
            )

            local run_name = ""
            if opts.fargs[1] == nil then
                run_name = show_runs(run_config)
            else
                run_name = opts.fargs[1]
            end

            run(run_name, run_config)
        end,
        { nargs = "?" }
    )
end

return M
