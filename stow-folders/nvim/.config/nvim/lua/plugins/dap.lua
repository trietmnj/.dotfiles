-- plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Keymaps
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })

      -- Python
      local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(debugpy_path)
    end,
  },
}
