if true then return {} end
return {
  -- {
  --   -- vim 커맨드 교정
  --   "m4xshen/hardtime.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  --   opts = {}
  -- },
    {
        "nvim-neo-tree/neo-tree.nvim",
        -- opts = {
        --     buffers = {
        --         follow_current_file = {
        --             enabled = false,
        --             leave_dirs_open = false
        --         },
        --     }
        -- }
        opts = function(_, opts)
            -- opts.filesystem.follow_current_file.enabled = false
        end
    },
}
