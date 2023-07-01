local M = {}

M.add_plugin = function()
    vim.ui.input(
        {
            prompt = "URL: ",
        },
        function(url)
            if url == nil or url == "" then
                return
            end

            vim.ui.input(
                {
                    prompt = "Name: ",
                },
                function(name)
                    if name == nil or name == "" then
                        return
                    end
                    vim.ui.input(
                        {
                            prompt = "Branch (leave empty for default): ",
                        },
                        function(branch)
                            vim.cmd("PlugAdd " .. url .. " " .. name .. " " .. branch) 
                        end
                    )
                end
            ) 
        end
    )
end

M.remove_plugin = function()
    vim.ui.input(
        {
            prompt = "Name: ",
        },
        function(name)
            vim.cmd("PlugRm " .. name) 
        end
    )
end

return M
