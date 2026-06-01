vim.lsp.enable({
	-- Python
	"basedpyright",
	-- ruff_lsp = {},
	-- Go
	"gopls",
	"templ",
	-- Javascript & Typescript
	"ts_ls",
	"lua_ls",
})
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local buf = args.buf
		local map = function(lhs, rhs)
			vim.keymap.set("n", lhs, rhs, { buffer = buf })
		end

		map("gd", vim.lsp.buf.definition)
		map("gD", vim.lsp.buf.declaration)
		map("gr", vim.lsp.buf.references)
		map("gi", vim.lsp.buf.implementation)
		map("K", vim.lsp.buf.hover)
		map("<leader>rn", vim.lsp.buf.rename)
		map("<leader>ca", vim.lsp.buf.code_action)
		map("<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end)
	end,
})

return {
	"mason-org/mason.nvim",
	opts = {},
}
