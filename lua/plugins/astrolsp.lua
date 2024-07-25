-- if true then return {} end
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
			--
			pyright = function(_, opts)
				require("lspconfig").pyright.setup(opts)
				require("dap-python").setup("~/.local/share/.virtualenvs/debugpy/bin/python")
			end,

			jdtls = function(_, opts)
				vim.api.nvim_create_autocmd("Filetype", {
					pattern = "java",
					callback = function()
						require("todo-comments").setup()
						require("telescope").setup({
							defaults = {
								file_ignore_patterns = {
									"%.jar",
									"plugin",
								},
							},
						})
					end,
				})

				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.css", "*.html", "*.js", "*.xml" },
					callback = function() -- auto build for thymeleaf template
						local root_dir =
							require("jdtls.setup").find_root({ "mvnw", ".git", "gradlew", "pom.xml", "build.gradle" })
						if root_dir and root_dir ~= "" then
							local Job = require("plenary.job")
							Job:new({
								command = "./mvnw",
								args = { "compile" },
								cwd = root_dir,
							}):start()
						end
					end,
				})
			end,
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
						if require("astrolsp").config.features.codelens then
							vim.lsp.codelens.refresh({ bufnr = args.buf })
						end
					end,
				},
			},
		},
		-- mappings to be set up on attaching of a language server
		mappings = {
			n = {
				-- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
				gD = {
					function()
						vim.lsp.buf.declaration()
					end,
					desc = "Declaration of current symbol",
					cond = "textDocument/declaration",
				},
				["<Leader>uY"] = {
					function()
						require("astrolsp.toggles").buffer_semantic_tokens()
					end,
					desc = "Toggle LSP semantic highlight (buffer)",
					cond = function(client)
						return client.supports_method("textDocument/semanticTokens/full")
							and vim.lsp.semantic_tokens ~= nil
					end,
				},
				["<Leader>j"] = { name = "Java" },
				["<Leader>ji"] = {
					function()
						require("jdtls").organize_imports()
					end,
					desc = "organize_imports",
				},
				["<Leader>jd"] = { desc = "junit test" },
				["<Leader>jda"] = {
					function()
						require("jdtls").test_class({
							after_test = function()
								require("dapui").toggle()
							end,
						})
					end,
					desc = "test class",
				},
				["<Leader>jdc"] = {
					function()
						require("jdtls").test_nearest_method({
							after_test = function()
								require("dapui").toggle()
							end,
						})
					end,
					desc = "test method",
				},
				["<Leader>jt"] = { desc = "Template" },
				["<Leader>jtj"] = {
					function()
						vim.cmd("Template class")
					end,
					desc = "class Template",
				},
				["<Leader>jti"] = {
					function()
						vim.cmd("Template interface")
					end,
					desc = "interface Template",
				},
				["<Leader>jtc"] = {
					function()
						vim.cmd("Template controller")
					end,
					desc = "controller Template",
				},
				["<Leader>jts"] = {
					function()
						vim.cmd("Template service")
					end,
					desc = "service Template",
				},
				["<Leader>jtm"] = {
					function()
						vim.cmd("Template mybatis")
					end,
					desc = "mybatis Template",
				},
				["<Leader>jte"] = {
					function()
						vim.cmd("Template enum")
					end,
					desc = "enum class Template",
				},
				["<Leader>jtv"] = {
					function()
						vim.cmd("Template vo")
					end,
					desc = "value object Template",
				},
				["<Leader>jtf"] = {
					function()
						require("javautil").makeRequestMapping()
					end,
					desc = "mapping method Template",
				},
				["<Leader>jr"] = { desc = "generate annotation" },
				["<Leader>jrf"] = {
					function()
						require("neogen").generate({ type = "func" })
					end,
					desc = "generate javadoc annotation for method",
				},
				["<Leader>Tn"] = {
					function()
						require("todo-comments").jump_next()
					end,
					desc = "next-TODO comment",
				},
				["<Leader>fT"] = {
					function()
						vim.cmd("TodoTelescope")
					end,
					desc = "Telescope TODO",
				},
				["<Leader>r"] = { desc = "reset plugin" },
				["<Leader>rd"] = {
					function()
						require("dapui").setup()
					end,
					desc = "reset dapui",
				},
				["<Leader>rj"] = {
					function()
						require("jdtls.dap").setup_dap_main_class_configs({
							config_overrides = { vmArgs = "-Dspring.profiles.active=dev" },
						})
					end,
					desc = "find main class for java",
				},
			},
			v = {
				["<Leader>j"] = { name = "java" },
				["<Leader>jj"] = { desc = "convert" },
				["<Leader>jjv"] = {
					function()
						require("javautil").mysqlToValueObject()
					end,
					desc = "convert ddl for mysql to value object",
				},
				["<Leader>jjo"] = {
					function()
						require("javautil").mysqlToObjectMapper()
					end,
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
