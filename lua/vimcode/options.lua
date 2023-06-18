local M = {}

M.load_opts = function(opts)
	for name, value in pairs(opts) do
		vim.opt[name] = value
	end
end

M.load_gs = function(gs)
	for name, value in pairs(gs) do
		vim.g[name] = value
	end
end

return M
