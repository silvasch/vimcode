local utils = require("utils")

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
        if file_dir == "/" then
            return nil
        end
    end
    return file_dir .. "/" .. file_name
end

function run(name, run_config)
    if run_config[name] == nil then
        print("'" .. name .. "' is not a name of a run config")
        return
    end

    utils.make_terminal(run_config[name].cmd)
end

function show_runs(run_config)
    local run_descriptions = {}
    for _, run in pairs(run_config) do
        table.insert(run_descriptions, run.desc)
    end

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
        
        run(run_name, run_config)
    end)
end

M.create_user_command = function()
    vim.api.nvim_create_user_command(
        "Run",
        function(opts)
            local file_path = find_run_config()
            if file_path == nil then
                print("Could not find a run.json")
                return
            end
            local file = io.open(file_path, "r")
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

            if opts.fargs[1] == nil then
                show_runs(run_config)
            else
                run(opts.fargs[1], run_config)
            end
        end,
        { nargs = "?" }
    )
end

return M
