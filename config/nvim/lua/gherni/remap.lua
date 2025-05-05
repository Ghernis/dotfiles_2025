--vim.g.mapleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode
keymap("i","kj", "<Esc>", opts)

-- Normal mode window movement
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

-- File operations
keymap("n", "<leader>w", ":update<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)

-- Undotree
--keymap("n", "<leader>u", ":UndotreeShow<CR>", opts)

-- Resizing
keymap("n", "<leader>+", ":vertical resize +5<CR>", opts)
keymap("n", "<leader>-", ":vertical resize -5<CR>", opts)

-- Local cd and compile
keymap("n", "<leader>cd", ":lcd %:p:h<CR>", opts)
keymap("n", "<leader>co", ":!comp \"%\"<CR>", opts)

-- Disable Q
keymap("n", "Q", "<nop>", opts)

