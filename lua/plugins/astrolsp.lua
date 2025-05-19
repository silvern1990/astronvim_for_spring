-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
        ["gI"] = { function() vim.lsp.buf.implementation() end, desc = "go to implementation"},
        ["<Leader>j"] = { name = "Java" },
        ["<Leader>ji"] = { function() require("jdtls").organize_imports() end, desc = "organize_imports" },
        ["<Leader>jd"] = { desc = "junit test" },
        ["<Leader>jda"] = {
          function()
            require("jdtls").test_class { after_test = function() require("dapui").toggle() end }
          end,
          desc = "test class",
        },
        ["<Leader>jdc"] = {
          function()
            local root_dir = require("jdtls.setup").find_root { "mvnw", ".git", "gradlew", "pom.xml", "build.gradle" }
            local project_name = root_dir:match ".*/(.*)"
            local vmArgs = "-Djava.net.preferIPv4Stack=true"

            if project_name == "SMART_PEM7" or project_name == "GS_ASAN_SVBS" then
              vmArgs = vmArgs
                .. " -Dkey.file.path="
                .. root_dir
                .. "/testKey -Dfile.dec.key=88cbd881097ca61985320c65a8e36061"
            end

            require("jdtls").test_nearest_method {
              config_overrides = {
                vmArgs = vmArgs,
              },
              after_test = function() require("dapui").toggle() end,
            }
          end,
          desc = "test method",
        },
        ["<Leader>jt"] = { desc = "Template" },
        ["<Leader>jtj"] = { function() vim.cmd "Template class" end, desc = "class Template" },
        ["<Leader>jti"] = { function() vim.cmd "Template interface" end, desc = "interface Template" },
        ["<Leader>jtc"] = { function() vim.cmd "Template controller" end, desc = "controller Template" },
        ["<Leader>jts"] = { function() vim.cmd "Template service" end, desc = "service Template" },
        ["<Leader>jtm"] = { function() vim.cmd "Template mybatis" end, desc = "mybatis Template" },
        ["<Leader>jte"] = {
          function()
            local data_type = vim.fn.input "Enter data type: "
            vim.cmd("Template var=" .. data_type .. " enum")
          end,
          desc = "enum class Template",
        },
        ["<Leader>jtv"] = { function() vim.cmd "Template vo" end, desc = "value object Template" },
        ["<Leader>jtf"] = { function() require("javautil").makeRequestMapping() end, desc = "mapping method Template" },
        ["<Leader>jr"] = { desc = "generate annotation" },
        ["<Leader>jrf"] = {
          function() require("neogen").generate { type = "func" } end,
          desc = "generate javadoc annotation for method",
        },
        ["<Leader>Tn"] = { function() require("todo-comments").jump_next() end, desc = "next-TODO comment" },
        ["<Leader>r"] = { desc = "reset plugin" },
        ["<Leader>rd"] = {
          function()
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
            }
            require("dapui").setup(config)
          end,
          desc = "reset dapui",
        },
        ["<Leader>rj"] = {
          function()
            require("jdtls.dap").setup_dap_main_class_configs {
              config_overrides = { vmArgs = "-Dspring.profiles.active=dev" },
            }
          end,
          desc = "find main class for java",
        },
        ["<Leader>lR"] = {
          function() require("telescope.builtin").lsp_references() end,
          desc = "lsp references in telescope",
        },
      },
      v = {
        ["<Leader>j"] = { name = "java" },
        ["<Leader>jj"] = { desc = "convert" },
        ["<Leader>jjq"] = {
          function() require("javautil").columnToMybatisValue() end,
          desc = "make insert query value",
        },
        ["<Leader>jjv"] = {
          function() require("javautil").mysqlToValueObject() end,
          desc = "convert ddl for mysql to value object",
        },
        ["<Leader>jjo"] = {
          function() require("javautil").mysqlToObjectMapper() end,
          desc = "convert ddl for mysql to objectMapper",
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
