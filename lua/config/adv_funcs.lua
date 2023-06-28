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

M.select_colorscheme = function()
    local before_background = vim.o.background
    local before_color = vim.api.nvim_exec("colorscheme", true)
    local need_restore = true

    local colors = { before_color }
    if not vim.tbl_contains(colors, before_color) then
        table.insert(colors, 1, before_color)
    end

    colors = vim.list_extend(
        colors,
        vim.tbl_filter(function(color)
            return color ~= before_color
        end, vim.fn.getcompletion("", "color"))
    )

    vim.ui.select(
        colors,
        { prompt = "Select colorscheme..." },
        function(choice)
            if choice == nil then
                return
            end
            vim.cmd("colorscheme " .. choice)
        end
    )
end

return M
