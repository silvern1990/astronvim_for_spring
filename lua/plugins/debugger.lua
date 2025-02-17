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
            require("telescope").setup {
              defaults = {
                file_ignore_patterns = {
                  "%.jar",
                  "static/plugin",
                },
              },
            }
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
            local project_name = root_dir:match('.*/(.*)')
            local vmArgs = "-Djava.net.preferIPv4Stack=true"


            if project_name == 'SMART_PEM7' or project_name == 'GS_ASAN_SVBS' then
              vmArgs = vmArgs .. ' -Dkey.file.path=' .. root_dir .. '/testKey -Dfile.dec.key=88cbd881097ca61985320c65a8e36061'
            end

            require("jdtls.dap").setup_dap_main_class_configs({
              config_overrides = {
                vmArgs = vmArgs,
              },
            }) 

          end
        end,
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    config = {
      layouts = { {
          elements = { {
              id = "scopes",
              size = 0.25
            }, {
              id = "breakpoints",
              size = 0.25
            }, {
              id = "stacks",
              size = 0.25
            }, {
              id = "watches",
              size = 0.25
            } },
          position = "right",
          size = 40
        }, {
          elements = { {
              id = "repl",
              size = 0.5
            }, {
              id = "console",
              size = 0.5
            } },
          position = "bottom",
          size = 20
        } },
    }
  },
}
