-- if true then return {} end
return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "codelldb" },
    },
  },
  {
    -- for python debugger
    "mfussenegger/nvim-dap-python",
  },
}
