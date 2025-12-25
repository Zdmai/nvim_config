require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local unmap = vim.keymap.del

map("i", "jk", "<ESC>")

-- nvimtree
-- unmap("n", "<C-n>")
map("n", "<leader-e>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

-- comment
unmap("n", "<leader>/")
unmap("v", "<leader>/")
map("n", "<C-_>", "gcc", { desc = "toggle comment", remap = true })
map("v", "<C-_>", "gc",  { desc = "toggle comment", remap = true })

map("n", "<C-h>", function()
end, { desc = "switch window left" })

map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- terminal
unmap("n", "<leader>h")
unmap("n", "<leader>v")

-- map("n", "<leader>v", function()
--   require("nvchad.term").new { pos = "vsp" }
-- end, { desc = "terminal new vertical term" })

-- map({ "n", "t" }, "<A-i>", function()
--   require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
-- end, { desc = "terminal toggle floating term" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
