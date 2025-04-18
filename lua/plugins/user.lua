-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
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
        author = "Park-Jin-Su",
        email = "silvern1990@gmail.com",
      }
    end,
  },
  {
    "silvern1990/javautil.nvim",
  },

  -- color scheme
  {
    "morhetz/gruvbox",
  },
  {
    "folke/tokyonight.nvim",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function() require("catppuccin").setup {} end,
  },
  {
    "navarasu/onedark.nvim",
  },
  {
    "bluz71/vim-nightfly-colors",
  },
  {
    "rebelot/kanagawa.nvim",
  },

  -- jdtls setting
  {
    "mfussenegger/nvim-jdtls",
    config = function(_, opts)
      -- setup autocmd on filetype detect java
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "java", -- autocmd to start jdtls
        callback = function()
          if opts.root_dir and opts.root_dir ~= "" then
            require("jdtls").start_or_attach(opts)
            require("todo-comments").setup()
          else
            require("astrocore").notify("jdtls: root_dir not found. Please specify a root marker", vim.log.levels.ERROR)
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.css", "*.html", "*.js", "*.xml" },
        callback = function() -- auto build for thymeleaf template
          local root_dir = require("jdtls.setup").find_root { "mvnw", ".git", "gradlew", "pom.xml", "build.gradle" }
          if root_dir and root_dir ~= "" then
            local Job = require "plenary.job"
            Job:new({
              command = "./mvnw",
              args = { "compile" },
              cwd = root_dir,
            }):start()
          end
        end,
      })
      -- create autocmd to load main class configs on LspAttach.
      -- This ensures that the LSP is fully attached.
      -- See https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
      vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*.java",
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- ensure that only the jdtls client is activated
          if client.name == "jdtls" then
            local root_dir = require("jdtls.setup").find_root { "mvnw", ".git", "gradlew", "pom.xml", "build.gradle" }
            local project_name = root_dir:match ".*/(.*)"
            local vmArgs = "-Djava.net.preferIPv4Stack=true"

            if project_name == "SMART_PEM7" or project_name == "GS_ASAN_SVBS" then
              vmArgs = vmArgs
                .. " -Dkey.file.path="
                .. root_dir
                .. "/testKey -Dfile.dec.key=88cbd881097ca61985320c65a8e36061"
            end

            require("jdtls.dap").setup_dap_main_class_configs {
              config_overrides = {
                vmArgs = vmArgs,
              },
            }
          end
        end,
      })
    end,
  },

  -- dap ui
  {
    "rcarriga/nvim-dap-ui",
    config = {
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "right",
          size = 40,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 20,
        },
      },
    },
  },
}
