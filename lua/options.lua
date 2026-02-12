local opt = vim.opt
local api = vim.api
local o = vim.o
-- local g = vim.g

-- set the leader key
vim.g.mapleader = " "

----------------------
-- 通用 Neovim 设置 --
----------------------
opt.clipboard = "unnamedplus"

-- vim, not vi (wonder if this is still necessary in neovim)
opt.compatible = false
opt.number = true                           -- 显示行号
opt.relativenumber = true                   -- 显示相对行号
opt.cursorline = true                       -- 高亮光标所在行
opt.expandtab = true                        -- 使用空格代替 Tab
opt.tabstop = 4                             -- Tab 键宽度为 2
opt.shiftwidth = 4                          -- 缩进宽度为 2
opt.wrap = false                            -- 不自动换行
opt.scrolloff = 5                           -- 上下保留 5 行作为缓冲
opt.signcolumn = "yes"                      -- 永远显示 sign column（诊断标记）
opt.winborder = "rounded"                   -- 窗口边框样式
opt.ignorecase = true                       -- 搜索忽略大小写
opt.smartcase = true                        -- 当包含大写字母时，搜索区分大小写
opt.smartindent = true
opt.hlsearch = false                        -- 搜索匹配不高亮
opt.incsearch = true                        -- 增量搜索
opt.foldmethod = "expr"                     -- 折叠方式使用表达式
opt.foldexpr = "nvim_treesitter#foldexpr()" -- 使用 Treesitter 表达式折叠
opt.foldlevel = 99                          -- 打开文件时默认不折叠


api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end
})


-- 复制高亮提示
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "highlight copying text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 500 })
    end,
})

-- lazy
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    desc = "自定义事件LazyFile",
    pattern = "*",
    once = true,
    callback = function()
        if not vim.g._lazyfile_triggered then
            vim.g._lazyfile_triggered = true
            vim.schedule(function()
                vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile" })
            end)
        end
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = "LazyFile",
    callback = function()
        vim.diagnostic.config({
            virtual_text = true,
            update_in_insert = true,
            underline = true,
            float = {
                border = "rounded"
            }
        })
        -- vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "diagnostic messages" })
        -- vim.keymap.set("n", "[d", function()
        --  vim.diagnostic.jump({ wrap = true, count = -1 })
        -- end, { desc = "prev diagnostic" })

        -- vim.keymap.set("n", "]d", function()
        --  vim.diagnostic.jump({ wrap = true, count = 1 })
        -- end, { desc = "next diagnostic" })
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method('textDocument/completion') and vim.lsp.completion then
            vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

            vim.keymap.set('i', '<Tab>', function()
                vim.lsp.completion.get()
            end, { desc = 'completion' })
        end
    end,
})
