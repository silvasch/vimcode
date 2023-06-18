local M = {}

function show_funcs(funcs)
    local func_descriptions = {}
    for _, func in pairs(funcs) do
        table.insert(func_descriptions, func.desc)
    end

    vim.ui.select(func_descriptions, {
        prompt = "Run:"
    }, function(choice)
        if choice == nil then
            return
        end

        for _, func in pairs(funcs) do
            if func.desc == choice then
                func.func()
            end
        end
    end)
end

function M.create_user_command(funcs)
    vim.api.nvim_create_user_command(
        "Funcs",
        function(opts)
            if opts.fargs[1] == nil then
                show_funcs(funcs)
            else
                funcs[opts.fargs[1]].func()
            end
        end,
        {
            nargs = "?",
        }
    )
end

return M
