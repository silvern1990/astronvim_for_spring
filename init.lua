return {
  options = {
    opt = {
      shiftwidth=4,
      tabstop=4,
      softtabstop=4,
    },
  },
  lsp = {
    formatting = {
      format_on_save = false
    },
    setup_handlers = {
      -- add custom handler
      jdtls = function(_, opts)
        vim.api.nvim_create_autocmd("Filetype", {
          pattern = "java",
          callback = function()
            if opts.root_dir and opts.root_dir ~= ""
            then
              require("jdtls").start_or_attach(opts)
              require("todo-comments").setup()
            end
          end,
        })
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern={"*.css", "*.html", "*.js"},
          callback = function() -- auto build for thymeleaf template 
            local root_dir = require("jdtls.setup").find_root({"mvnw"})
            if root_dir and root_dir ~= ""
            then
              local Job = require("plenary.job")
              Job:new{
                command = "./mvnw",
                args = { "compile" },
                cwd = root_dir,
              }:start()
            end
          end
        })

      end,
    },
    config = {
      -- set jdtls server settings
      jdtls = function()
        -- use this function notation to build some variables
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = require("jdtls.setup").find_root(root_markers)


        -- calculate workspace dir
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
        os.execute("mkdir " .. workspace_dir)

        -- get the mason install path
        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

        -- get the current OS
        local os
        if vim.fn.has "macunix" then
          os = "mac"
        elseif vim.fn.has "win32" then
          os = "win"
        else
          os = "linux"
        end


        local bundles = {
          vim.fn.glob(
            "/Users/zero/.local/share/debug/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
            1),
        }
        vim.list_extend(bundles,
          vim.split(vim.fn.glob("/Users/zero/.local/share/debug/vscode-java-test/server/*.jar", 1), "\n"))

        -- return the server config
        return {
          cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-javaagent:" .. install_path .. "/lombok.jar",
            "-Xms1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
            "-configuration",
            install_path .. "/config_" .. os,
            "-data",
            workspace_dir,
          },
          root_dir = root_dir,
          init_options = {
            bundles = bundles
          },
        }
      end,
    },
    mappings = {
      n = {
        -- java key map --
        ["<leader>j"] = { desc="Java" },
        ["<leader>ji"] = { function() require'jdtls'.organize_imports() end, desc = "organize_imports" },
        ["<leader>jd"] = { desc = "junit test" },
        ["<leader>jda"] = { function() require'jdtls'.test_class({after_test=function() require'dapui'.toggle() end}) end, desc = "test class" },
        ["<leader>jdc"] = { function() require'jdtls'.test_nearest_method({after_test=function() require'dapui'.toggle() end}) end, desc = "test method" },
        ["<leader>jt"] = { desc="Template" },
        ["<leader>jtj"] = { function() vim.cmd('Template class') end, desc = "class Template"},
        ["<leader>jti"] = { function() vim.cmd('Template interface') end, desc = "interface Template"},
        ["<leader>jtc"] = { function() vim.cmd('Template controller') end, desc = "controller Template"},
        ["<leader>jts"] = { function() vim.cmd('Template service') end, desc = "service Template"},
        ["<leader>jtm"] = { function() vim.cmd('Template mybatis') end, desc = "mybatis Template"},
        ["<leader>jte"] = { function() vim.cmd('Template enum') end, desc = "enum class Template"},
        ["<leader>jr"] = { desc = "generate annotation" },
        ["<leader>jrf"] = { function() require'neogen'.generate({ type = "func" }) end, desc = "generate javadoc annotation for method"},
        ["<leader>Tn"] = { function() require'todo-comments'.jump_next() end, desc = "next-TODO comment" },
        ["<leader>fT"] = { function() vim.cmd('TodoTelescope') end, desc = "Telescope TODO" },
        -- reset key map --
        ["<leader>r"] = { desc = "reset plugin" },
        ["<leader>rd"] = { function() require'dapui'.setup({layouts = { { elements = { { id = "scopes", size = 0.2 }, { id = "breakpoints", size = 0.2 }, { id = "stacks", size = 0.2 }, { id = "watches", size = 0.2 }, }, position = "left", size = 30 }, { elements = { { id = "console", size = 1 }, }, position = "bottom", size = 10 }}}) end, desc = "reset dapui"},
        -- debugging key map -- 
        ["<leader>dV"] = { function() require'dapui'.float_element('console', {width=180, height=100, enter=true}) end, desc = "float console window" },
        ["<leader>dR"] = { function() require("dap").repl.toggle({height=15}) end, desc = "Toggle REPL" },
      },
    }
  },
  colorscheme = "nightfly",
  plugins = {
    "morhetz/gruvbox", -- color scheme
    "folke/tokyonight.nvim", -- color scheme
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*" 
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        require("catppuccin").setup{}
      end,
    }, --color scheme
    "bluz71/vim-nightfly-colors", -- color scheme
    "m4xshen/hardtime.nvim", -- offer good command for workflow
    "mfussenegger/nvim-jdtls", -- load jdtls on module
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "jdtls" },
      },
    },
    {
      "silvern1990/template.nvim", cmd = {'Template'}, config = function()
        require('template').setup({
          temp_dir = "~/.config/nvim/lua/user/template", author="silvern1990", email="silvern1990@gmail.com"
        })
      end
    },
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      "rcarriga/nvim-dap-ui",
      config = {
        layouts = {
          {
            elements = {
              {
                id = "scopes",
                size = 0.2
              },
              {
                id = "breakpoints",
                size = 0.2
              },
              {
                id = "stacks",
                size = 0.2
              },
              {
                id = "watches",
                size = 0.2
              },
            },
            position = "left",
            size = 30
          },
          {
            elements = {
              {
                id = "console",
                size = 1
              },
            },
            position = "bottom",
            size = 10
          }
        }
      },
    }
  },
}
