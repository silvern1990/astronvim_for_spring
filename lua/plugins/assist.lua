-- if true then return {} end

return {
  {
    -- method 주석 생성
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  {
    -- TODO 코멘트 지원
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    -- 템플릿 지원
    "silvern1990/template.nvim",
    cmd = { "Template" },
    config = function()
      require("template").setup {
        temp_dir = "~/.config/nvim/lua/user/template",
        author = "silvern1990",
        email = "silvern1990@gmail.com",
      }
    end,
  },
  {
    "silvern1990/javautil.nvim",
  },
}
