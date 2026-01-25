local opt = vim.opt
local api = vim.api
local o = vim.o
-- local g = vim.g

-- set the leader key
vim.g.mapleader = " "

-- vim, not vi (wonder if this is still necessary in neovim)
opt.compatible = false
opt.number = true
opt.clipboard ="unnamedplus"

o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function ()
	vim.opt.number = false
	vim.opt.relativenumber = false
    end
})

