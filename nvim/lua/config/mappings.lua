-- stylua: ignore start
-- Basic Keymaps ==============================================================
--  See `:help vim.keymap.set()`
-- Helper function
local keymap = function(mode, keys, cmd, opts)
	opts = opts or {}
	if opts.silent == nil then
		opts.silent = true
	end
	vim.keymap.set(mode, keys, cmd, opts)
end

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Clear search on pressing <Esc> in normal mode
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Disable arrow keys in normal mode
_G.Util.keymap("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
keymap("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
keymap("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
keymap("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
--
-- Better command history navigation
keymap("c", "<C-p>", "<Up>", { silent = false })
keymap("c", "<C-n>", "<Down>", { silent = false })

-- Leader keymaps =============================================================
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

_G.Config.leader_group_clues = {
	-- { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
	{ mode = "n", keys = "<Leader>e", desc = "+Explore" }, -- Oil
	{ mode = "n", keys = "<Leader>s", desc = "+Search" },
	{ mode = "n", keys = "<Leader>g", desc = "+Git" },
	{ mode = "n", keys = "<Leader>l", desc = "+LSP" },
  { mode = "n", keys = "<Leader>t", desc = "+Toggle" },
  { mode = "n", keys = "<Leader>x", desc = "+Trouble" },
	{ mode = "n", keys = "<Leader>q", desc = "+Quickfix list" },
	{ mode = "n", keys = "<Leader>v", desc = "+Visits" },
	{ mode = "x", keys = "<Leader>l", desc = "+LSP" },
}

-- Create `<Leader>` mappings
local nmap_leader = function(suffix, rhs, desc, opts)
	opts = opts or {}
	opts.desc = desc
	keymap("n", "<leader>" .. suffix, rhs, opts)
end
local xmap_leader = function(suffix, rhs, desc, opts)
	opts = opts or {}
	opts.desc = desc
	keymap("x", "<leader>" .. suffix, rhs, opts)
end

-- e is for 'explore', using Oil
nmap_leader("ef", "<CMD>Oil<CR>", "[E]xplore [F]iles")

-- s is for 'search'
-- NOTE: See plugins/telescope.lua

-- g is for 'git'
nmap_leader("gc", "<Cmd>Git commit<CR>", "Commit")
nmap_leader("gC", "<Cmd>Git commit --amend<CR>", "Commit amend")
nmap_leader("gg", "<Cmd>lua Config.open_lazygit()<CR>", "Git tab")
nmap_leader("gl", "<Cmd>Git log --oneline<CR>", "Log")
nmap_leader("gL", "<Cmd>Git log --oneline --follow -- %<CR>", "Log buffer")
nmap_leader("go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay")
nmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at cursor")
xmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at selection")

-- l is for 'LSP'
local formatting_cmd = '<CMD>lua require("conform").format({ lsp_fallback = true })<CR>'
nmap_leader('la', '<CMD>lua vim.lsp.buf.signature_help()<CR>', 'Function [a]rguments popup')
nmap_leader('le', '<CMD>lua vim.diagnostic.open_float()<CR>', '[E]rror diagnostic popup')
nmap_leader('lf', formatting_cmd, '[F]ormat')
xmap_leader('lf', formatting_cmd, '[F]ormat selection')
nmap_leader('li', '<CMD>lua vim.lsp.buf.hover()<CR>', '[I]nformation popup')
nmap_leader('lj', '<CMD>lua vim.diagnostic.goto_next()<CR>', 'Go down [j] to next diagnostic')
nmap_leader('lk', '<CMD>lua vim.diagnostic.goto_prev()<CR>', 'Go up [k] to prev diagnostic')
nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>', '[R]eferences')
nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', '[r]ename')
nmap_leader('ld', '<Cmd>lua vim.lsp.buf.definition()<CR>','[d]efinition')

-- v is for 'visits'
nmap_leader('vv', '<Cmd>lua MiniVisits.add_label("core")<CR>',    'Add "core" label')
nmap_leader('vV', '<Cmd>lua MiniVisits.remove_label("core")<CR>', 'Remove "core" label')
nmap_leader('vl', '<Cmd>lua MiniVisits.add_label()<CR>',          'Add label')
nmap_leader('vL', '<Cmd>lua MiniVisits.remove_label()<CR>',       'Remove label')

local map_pick_core = function(keys, cwd, desc)
  local rhs = function()
    local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
    MiniExtra.pickers.visit_paths({ cwd = cwd, filter = 'core', sort = sort_latest }, { source = { name = desc } })
  end
  nmap_leader(keys, rhs, desc)
end
map_pick_core('vc', '', 'Core visits (all)')
map_pick_core('vC', nil, 'Core visits (cwd)')


-- Diagnostic keymaps
-- nmap_leader("<leader>xx", function()
-- 	require("trouble").toggle()
-- end, { desc = "Toggle Diagnostic Panel" })
-- nmap_leader("<leader>xw", function()
-- 	require("trouble").toggle("workspace_diagnostics")
-- end, { desc = "[W]orkspace Diagnostics" })
-- nmap_leader("<leader>xd", function()
-- 	require("trouble").toggle("document_diagnostics")
-- end, { desc = "[D]ocument Diagnostics" })
-- nmap_leader("<leader>xq", function()
-- 	require("trouble").toggle("quickfix")
-- end, { desc = "Show [Q]uickfix List Items" })
-- nmap_leader("<leader>xl", function()
-- 	require("trouble").toggle("loclist")
-- end, { desc = "Show [L]ocation List Items" })
-- nmap_leader("gR", function()
-- 	require("trouble").toggle("lsp_references")
-- end, { desc = "Show [R]eferences of the word under the cursor" })
-- -- TODO: Evaluate those features of trouble:
-- -- lsp_definitions: definitions of the word under the cursor from the builtin LSP client
-- -- lsp_type_definitions: type definitions of the word under the cursor from the builtin LSP client

-- Increment/decrement numbers
-- C-A to increment the number under the cursor
-- C-X to decrement the number under the cursor
-- 't' is for toggle
local function toggleInlayHints()
  _G.Config.inlay_hints_visible = not _G.Config.inlay_hints_visible
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.server_capabilities.inlayHintProvider then
      local bufnr = vim.api.nvim_get_current_buf()
      if _G.Config.inlay_hints_visible then
        vim.lsp.buf.inlay_hint(bufnr, true)
      else
        vim.lsp.buf.clear_inlay_hints(bufnr)
      end
    end
  end
end
nmap_leader("ti", toggleInlayHints, '[T]oggle [I]nlay Hints')

-- Quickfix list
local function current_buffer_diagonistics_to_quickfix()
  local diagnostics = vim.diagnostic.get(0)
  local qflist = {}
  for _, diag in ipairs(diagnostics) do
    table.insert(qflist, {
      bufnr = diag.bufnr,
          lnum = diag.lnum + 1,  -- Convert 0-indexed to 1-indexed
          col = diag.col + 1,    -- Convert 0-indexed to 1-indexed
          text = diag.message,
          type = diag.severity == vim.diagnostic.severity.ERROR and 'E' or 'W',
      })
  end
  vim.fn.setqflist(qflist, 'r')
  vim.notify('Quickfixlist updated')
end
nmap_leader('qd', current_buffer_diagonistics_to_quickfix, '[Q]uickfix list: [d]iagonistics of this buffer')
nmap_leader('qo', '<CMD>copen<CR>', '[Q]uickfix list: [o]pen')
nmap_leader('qc', '<CMD>cclose<CR>', '[Q]ickfix list: [c]lose')

-- [[ Basic Autocommands ]]
--  See :help lua-guide-autocommands
local augroup = vim.api.nvim_create_augroup
local baumertnGroup = augroup("baumertn", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", { clear = true })

-- Remove trailing whitespace on save.
autocmd({ "BufWritePre" }, {
	group = baumertnGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
autocmd("LspAttach", {
	group = baumertnGroup,
	callback = function(event)
		local map = function(keys, func, desc)
			nmap_leader(keys, func, "LSP: " .. desc, { buffer = event.buf })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-T>.
		-- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		-- -- Find references for the word under your cursor.
		-- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		-- -- Jump to the implementation of the word under your cursor.
		-- --  Useful when your language has ways of declaring types without an actual implementation.
		-- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		-- -- Jump to the type of the word under your cursor.
		-- --  Useful when you're not sure what type a variable is and you want to see
		-- --  the definition of its *type*, not where it was *defined*.
		-- map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
		-- -- Fuzzy find all the symbols in your current document.
		-- --  Symbols are things like variables, functions, types, etc.
		-- map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		-- -- Fuzzy find all the symbols in your current workspace
		-- --  Similar to document symbols, except searches over your whole project.
		-- map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		-- -- Rename the variable under your cursor
		-- --  Most Language Servers support renaming across files, etc.
		-- map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		-- -- Execute a code action, usually your cursor needs to be on top of an error
		-- -- or a suggestion from your LSP for this to activate.
		-- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		-- -- Opens a popup that displays documentation about the word under your cursor
		-- --  See `:help K` for why this keymap
		-- map("K", vim.lsp.buf.hover, "Hover Documentation")
		-- -- WARN: This is not Goto Definition, this is Goto Declaration.
		-- --  For example, in C this would take you to the header
		-- map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		-- -- Show a window that displays the function signature.
		-- vim.keymap.set("i", "<C-k>", function()
		-- 	vim.lsp.buf.signature_help()
		-- end, { buffer = event.buf, desc = "LSP: Show function signature" })

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			-- Enable inlay hints by default
			vim.lsp.inlay_hint.enable()
		end
	end,
})
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = yank_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- stylua: ignore end
