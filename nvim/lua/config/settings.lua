
--stylua: ignore start
-- General ====================================================================
-- vim.o.backup = false -- Don't store backups
-- vim.o.writebackup = false -- Don't store backups
vim.o.mouse       = 'a'            -- Enable mouse
vim.o.mousescroll = 'ver:25,hor:6' -- Customize mouse scroll
vim.o.switchbuf   = 'usetab'       -- Use already opened buffers when switching i.e. jumping to errors.
vim.o.undofile    = true           -- Enable persistend undo
vim.o.timeout     = true
vim.o.timeoutlen  = 300

vim.o.shada       = "'100,<50,s10,:1000,/100,@100,h" -- Limit what is stored in ShaDa file

vim.cmd('filetype plugin indent on') -- Enable all filetype plugins
--UI ==========================================================================
vim.o.breakindent    = true  -- Indent wrapped lines to match line start
vim.o.colorcolumn    = '+1'  -- Draw colored column one step to the right of desired maximum width
vim.o.cursorline     = true  -- Enable highlight the current line
vim.o.cursorcolumn   = false -- Disable highlight of the current column (TODO: Might want to add a script to enable this.)
vim.o.clipboard      = "unnamedplus" -- Copy to system clipboard by default
vim.o.hlsearch       = true
vim.o.laststatus     = 2     -- Always show statusline
vim.linebreak        = true  -- Wrap long lines at `breakat` if `wrap = true`
vim.o.list           = true  -- Show helpful characters for invisible control characters
vim.o.wrap           = false -- Soft line wrapping
vim.o.number         = true  -- Show line numbers
vim.o.relativenumber = true  -- Make line numbers relative to the current line
vim.o.ruler          = true  -- Cursor position in document
vim.o.scrolloff      = 15    -- Minimal number of screen lines to keep above and below the cursor.
vim.o.showmode       = false -- Statusline has the mode.
vim.o.signcolumn     = 'yes' -- Always show the sign columns
vim.o.splitbelow     = true  -- New horizontal split below
vim.o.splitright     = true  -- New vertical splits on the reight
vim.o.termguicolors  = true  -- Enable GUI colors, should not be needed anymore.

vim.o.listchars = table.concat({ 'extends:…', 'trail:·', 'nbsp:␣', 'precedes:…', 'tab:»  ' }, ',')
if vim.fn.has('nvim-0.9') == 1 then
	vim.o.splitkeep = 'screen' -- Reduce scroll during window split
end

-- Colors =====================================================================
-- Enable syntax highlighing if it wasn't already (as it is time consuming)
-- Don't use defer it because it affects start screen appearance
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- Editing ====================================================================
vim.o.autoindent    = true     -- Use auto indent
vim.o.expandtab     = true     -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j' -- Improve comment editing
vim.o.ignorecase    = true     -- Ignore case when searching (use `\C` to force not doing that)
vim.o.incsearch     = true     -- Show search results while typing
vim.o.infercase     = true     -- Infer letter cases for a richer built-in keyword completion
vim.o.shiftwidth    = 2        -- Use this number of spaces for indentation
vim.o.smartcase     = true     -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent   = true     -- Make indenting smart
vim.o.tabstop       = 2        -- Insert 2 spaces for a tab
vim.o.virtualedit   = 'block'  -- Allow going past the end of line in visual block mode
vim.opt.inccommand  = "split"
vim.opt.cursorline  = true -- Show which line your cursor is on

vim.opt.scrolloff = 15 -- Minimal number of screen lines to keep above and below the cursor.


vim.opt.iskeyword:append('-')  -- Treat dash separated words as a word text object

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Spelling ===================================================================
vim.o.spelllang    = 'en,de'
vim.o.spelloptions = 'camel'      -- Treat parts of camelCase words as sperate
vim.opt.complete:append('kspell') -- Add spellcheck options for autocomplete
vim.opt.complete:remove('t')      -- Don't use tags for completion
-- vim.o.dictionary = vim.fn.stdpath('config') .. '/misc/dict/english.txt' -- Use specific dictionaries

-- Folds ======================================================================
vim.o.foldmethod       = 'expr'
vim.o.foldexpr         = 'v:lua.RegionFold(v:lnum)'
vim.o.foldlevel        = 1        -- Display all fold except top ones
vim.o.foldnestmax      = 5       -- Don't nest more than 10 folds
vim.g.markdown_folding = 1        -- Fold headings in markdown

function RegionFold(lnum)
  local line = vim.fn.getline(lnum)
  if line:match("#region") then
    return "a1"  -- Start of a fold
  elseif line:match("#endregion") then
    return "s1"  -- End of a fold
  end
  -- Fall back to indent folding
  return "=" .. vim.fn.indent(lnum)
end

if vim.fn.has('nvim-0.10') == 1 then
  vim.o.foldtext = ''        -- Use underlying text with its highlighting
end

-- Autocommands ===============================================================
local my_group = vim.api.nvim_create_augroup('baumertnGroup', {})
vim.api.nvim_create_autocmd('FileType', {
  group = my_group,
  callback = function()
    -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
    -- If don't do this on `FileType`, this keeps reappearing due to being set in
    -- filetype plugins.
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')
  end,
  desc = [[Ensure proper 'formatoptions']],
})

--stylua: ignore end
