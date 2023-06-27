local M = {}

M.save_file = function()
    local file_name = vim.fn.bufname()
    if file_name == "" then
        file_name = vim.fn.input("Filename (esc or leave empty to cancel): ", "", "file")
        if file_name == nil or file_name == "" then
            return
        end
    end
    vim.cmd("write " .. file_name)
end

M.file_picker = function()
    local handle = io.popen("find -not -path './.git/*' -not -path './target/*' -not -path './node_modules/*' -type f")
    local result = handle:read("*a")
    handle:close()
    files = {}
    for s in result:gmatch("[^\r\n]+") do
        table.insert(files, s)
    end 
    vim.ui.select(
        files,
        { prompt = "Open..." },
        function(choice)
            if choice == nil then
                return
            end
        vim.cmd("e " .. choice)
    end
    )
end

return M
