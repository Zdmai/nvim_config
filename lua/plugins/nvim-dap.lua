return {
  {
    "mfussenegger/nvim-dap",
    version = "*",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP: 继续执行", },
      { "<Leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP: 在当前行添加/删除断点", },
    },
    config = function()
      local dap = require "dap"
      dap.adapters.python = {
        type = "executable",
        command = os.getenv "HOME" .. "/.virtualenvs/tools/bin/python",
        -- command = "${workspaceFolder}/.venv/bin/python",
        cwd = "${workspaceFolder}",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = 'python';
          request = 'launch';
          name = "Launch file";
          program = "${file}";
          pythonPath = ".venv/bin/python";
        },
      }

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("可执行文件的路径: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "nvim-dap",
    keys = {
      {
        "<Leader>dg",
        function()
          require("dapui").toggle {}
        end,
        desc = "DAP: 切换 DAP GUI",
      },
    },
    config = function(_, opts)
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
    end,
    opts = { ... },
  },
  {
    "mfussenegger/nvim-dap-python",
  },
}
