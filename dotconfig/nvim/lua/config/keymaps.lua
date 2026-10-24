-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save buffer" })
vim.keymap.set("n", ".", ":", { desc = "Enter command mode" })
vim.keymap.set("n", "zz", ":wq<CR>", { desc = "Save and quit" })
