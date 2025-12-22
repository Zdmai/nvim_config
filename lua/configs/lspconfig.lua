require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "clangd", "lua_ls", "ruff", "pyright" }

-------------------
-- python lsp config --
-------------------
-- 在 init.lua 最上面

-- 1. 配置 Pyright (负责定义跳转、补全、类型检查)
vim.lsp.config.pyright = {
  -- 可以在这里覆盖 settings
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
}

-- 2. 配置 Ruff (负责 Linting 和 Formatting)
vim.lsp.config.ruff = {
  --这里建议直接手写 root_markers，比从 lspconfig 提取函数更稳定
  root_markers = { "pyproject.toml", "ruff.toml", ".git", "setup.py" },

  -- Ruff 不需要太多 settings，但我们需要用 on_attach 关掉它的 Hover
  on_attach = function(client, bufnr)
    -- 禁用 Ruff 的 Hover 功能，避免和 Pyright 冲突
    client.server_capabilities.hoverProvider = false
  end,
}

-- read :h vim.lsp.config for changing options of lsp servers
--

vim.lsp.enable(servers)
