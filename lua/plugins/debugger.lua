local dap_layout = {
  layouts = {
    {
      elements = {
        {
          id = "breakpoints",
          size = 0.15
        },
        {
          id = "repl",
          size = 0.85
        }
      },
      position = "bottom",
      size = 0.30
    },
  }
}

return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {"codelldb"}
    }
  },
  {
    -- for python debugger
    "mfussenegger/nvim-dap-python",
  },
  {
    "rcarriga/nvim-dap-ui",
    config = dap_layout,
  },
}
