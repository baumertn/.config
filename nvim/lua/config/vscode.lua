-- Mappings for code commenting
vim.keymap.set("x", "gc", "<Plug>VSCodeCommentary")
vim.keymap.set("n", "gc", "<Plug>VSCodeCommentary")
vim.keymap.set("o", "gc", "<Plug>VSCodeCommentary")
vim.keymap.set("n", "gcc", "<Plug>VSCodeCommentaryLine")

-- Simulate tab switching
vim.keymap.set("n", "]b", "<Cmd>Tabnext<CR>")
vim.keymap.set("n", "[b", "<Cmd>Tabprev<CR>")
