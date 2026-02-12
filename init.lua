vim.pack.add({
    -- remove the vim's warning
    { src = 'https://github.com/folke/neodev.nvim' },

    ----------------------
    -- LSP 配置 --
    ----------------------
    -- neovim's lsp preconfig example
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    -- manage the lsp package, like ruff, pyright, clangd
    -- must install lua-ls in mason
    { src = 'https://github.com/mason-org/mason.nvim' },

    -- color scheme
    -- { src = 'https://github.com/Mofiqul/dracula.nvim' },
    -- { src = 'https://github.com/shaunsingh/nord.nvim' },
    -- { src = 'https://github.com/sainnhe/everforest' },
    { src = 'https://github.com/sainnhe/gruvbox-material' },

    -- good for show lsp info inline
    { src = 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' },

    -- file manage
    { src = 'https://github.com/stevearc/oil.nvim' },

    -- vim tmux navigate
    { src = 'https://github.com/christoomey/vim-tmux-navigator' },

    -- -- telescope
    -- { src = 'http://github.com/nvim-lua/plenary.nvim' },
    -- { src = 'https://github.com/nvim-telescope/telescope.nvim' },

    -- cmp
    -- { src = 'https://github.com/saghen/blink.cmp' },

    -- tagbar
    -- { src = 'https://github.com/preservim/tagbar' },

    -- snacks
    { src = 'https://github.com/folke/snacks.nvim' },
    -- flash
    { src = 'https://github.com/folke/flash.nvim' },
    -- which-key
    { src = 'https://github.com/folke/which-key.nvim' },

    -- opencode
    { src = 'https://github.com/NickvanDyke/opencode.nvim' },

    -- todo-comments
    { src = 'https://github.com/folke/todo-comments.nvim' },

    -- git
    { src = 'https://github.com/sindrets/diffview.nvim' },

})

----------------------
-- 补全 --
----------------------
-- blink.cmp 安装补全配置以及触发加载
vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
}, {
    load = function(plug_data)
        vim.api.nvim_create_autocmd("InsertEnter", {
            once = true,
            callback = function()
                vim.cmd.packadd(plug_data.spec.name)
                -- 加载 plugin 文件
                require("blink.cmp").setup({
                    keymap = { preset = "super-tab" },
                    sources = {
                        default = { "lsp", "path", "snippets", "buffer" },
                    },
                })
            end,
        })
    end,
})


-- NOTE:
-- :TodoQuickFix  -- This uses the quickfix list to show all todos in your project.
-- :TodoLocList   -- This uses the location list to show all todos in your project.
-- :Trouble todo  -- List all project todos in trouble
-- :TodoTelescope -- Search through all project todos with Telescope

require("todo-comments").setup({})

require("which-key").setup({
    preset = "helix",
})

require("snacks").setup({
    bigfile = { enabled = true },
    -- explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
        enabled = true,
        timeout = 3000,
    },
    picker = { enabled = true },
    toggle = { enabled = true },
    quickfile = { enabled = true },
    terminal = { enabled = true },
    win = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
})

require('mason').setup()

-- require('blink.cmp').setup({
-- 	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
-- 	-- 'super-tab' for mappings similar to vscode (tab to accept)
-- 	-- 'enter' for enter to accept
-- 	-- 'none' for no mappings
-- 	--
-- 	-- All presets have the following mappings:
-- 	-- C-space: Open menu or open docs if already open
-- 	-- C-n/C-p or Up/Down: Select next/previous item
-- 	-- C-e: Hide menu
-- 	-- C-k: Toggle signature help (if signature.enabled = true)
-- 	--
-- 	-- See :h blink-cmp-config-keymap for defining your own keymap
-- 	keymap = { preset = 'default' },
--
-- 	appearance = {
-- 		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
-- 		-- Adjusts spacing to ensure icons are aligned
-- 		nerd_font_variant = 'mono'
-- 	},
--
-- 	-- (Default) Only show the documentation popup when manually triggered
-- 	completion = { documentation = { auto_show = false } },
--
-- 	-- Default list of enabled providers defined so that you can extend it
-- 	-- elsewhere in your config, without redefining it, due to `opts_extend`
-- 	sources = {
-- 		default = { 'lsp', 'path', 'snippets', 'buffer' },
-- 	},
--
-- 	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
-- 	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
-- 	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
-- 	--
-- 	-- See the fuzzy documentation for more information
-- 	fuzzy = { implementation = "prefer_rust_with_warning" }
-- })


-- tiny-inline-diagnostic
require("tiny-inline-diagnostic").setup()
-- Disable Neovim's default virtual text diagnostics
vim.diagnostic.config({ virtual_text = false })


-- Source - https://stackoverflow.com/a/79656109␍
-- Posted by Jo Totland␍
-- Retrieved 2026-01-16, License - CC BY-SA 4.0␍

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require',
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.enable({ 'lua_ls', 'ruff', 'pyright', 'clangd' })


-- vim.cmd.colorscheme 'nord'
-- vim.g.background = "dark"
-- vim.cmd.colorscheme "everforest"
vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_background = 'soft'
vim.cmd.colorscheme 'gruvbox-material'

-- oil.nvim
require("oil").setup({})

-- override above configs
require "options"
-- 在 init.lua 中的简单配置
require('plugins.translate').setup_keymaps()
require "keymaps"
