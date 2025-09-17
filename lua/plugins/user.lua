-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

local lfs = require('lfs')
local function find_app_jsx_dir(path)
  for file in lfs.dir(path) do
    if file ~= "." and file ~= ".." then
      local full_path = path .. "/" .. file
      local attr = lfs.attributes(full_path)

      if attr then
        if attr.mode == "file" and file == "App.js" then
          return path:gsub("/src", "")
        elseif attr.mode == "directory" then
          local found = find_app_jsx_dir(full_path)
          if found then return found end
        end
      end
    end
  end
  return nil
end

---@type LazySpec
return {
  {
    "Astronvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        -- first key is the augroup name
        react_build = {
          {
            event = "BufWritePost",
            pattern = "*.js",
            callback = function()
              if not _G['react_project'] then
                _G['react_project'] = find_app_jsx_dir(".")
                if not _G['react_project'] then
                  _G['react_project'] = 'not found'
                end
              end

              if _G['react_project'] and _G['react_project'] ~= 'not found' then
                local Job = require('plenary.job')
                Job:new{
                  command = "bash",
                  args = { "-c", "npm --prefix " .. _G['react_project'] .. " run build && ./mvnw compile" },
                  cwd = ".",
                  on_exit = function(j, return_val)
                    vim.schedule(function()
                      if return_val == 0 then
                        vim.fn.system("notify-send 'vim' '✅ build completed!' && canberra-gtk-play -i message --volume=1")
                      else
                        local error_msg = "❌ build fail!\n" .. table.concat(j:stderr_result(), "\n")
                        vim.fn.system("notify-send -u critical '" .. error_msg .. "' && canberra-gtk-play -i message --volume=1")
                      end
                    end)
                  end
                }:start()
              end

            end
          }
        }
      }
    }
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "gemini",
      -- openai = {
      --   endpoint = "https://api.openai.com/v1",
      --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
      --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      --   temperature = 0,
      --   max_completion_tokens = 16384, -- Increase this to include reasoning tokens (for reasoning models)
      --   --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      -- },
      providers = {
        gemini = {
          model = "gemini-2.5-pro"
        },
      }
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
          viewmode = "replace",
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
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
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   opts = {
  --     settings = {
  --       java = {
  --         completion = {
  --           favoriteStaticMembers = {
  --             "org.hamcrest.MatcherAssert.assertThat",
  --             "org.hamcrest.Matchers.*",
  --             "org.hamcrest.CoreMatchers.*",
  --             "org.junit.jupiter.api.Assertions.*",
  --             "java.util.Objects.requireNonNull",
  --             "java.util.Objects.requireNonNullElse",
  --             "org.mockito.Mockito.*",
  --             "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
  --             "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
  --           }
  --         }
  --       }
  --     }
  --   }
  -- },

  -- dap ui
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   config = function(plugin, opts)
  --
  --     -- vim.api.nvim_create_autocmd("BufWinEnter", {
  --     --   pattern = { "\\[dap-repl\\]", "DAP *" },
  --     --   group = vim.api.nvim_create_augroup("set_dap_win_options", { clear = true }),
  --     --   callback = function(args)
  --     --     local file, err = io.open("/dev/pts/8", "w")
  --     --     file:write("test")
  --     --     file:close()
  --     --     local win = vim.fn.bufwinid(args.buf)
  --     --     vim.schedule(function()
  --     --       if not vim.api.nvim_win_is_valid(win) then return end
  --     --       vim.api.nvim_set_option_value("wrap", true, { win = win })
  --     --     end)
  --     --   end
  --     -- })
  --
  --     -- require('dapui').setup{
  --     --   layouts = {
  --     --     {
  --     --       elements = {
  --     --         {
  --     --           id = "scopes",
  --     --           size = 0.25,
  --     --         },
  --     --         {
  --     --           id = "breakpoints",
  --     --           size = 0.25,
  --     --         },
  --     --         {
  --     --           id = "stacks",
  --     --           size = 0.25,
  --     --         },
  --     --         {
  --     --           id = "watches",
  --     --           size = 0.25,
  --     --         },
  --     --       },
  --     --       position = "right",
  --     --       size = 40,
  --     --     },
  --     --     {
  --     --       elements = {
  --     --         {
  --     --           id = "repl",
  --     --           size = 0.5,
  --     --         },
  --     --         {
  --     --           id = "console",
  --     --           size = 0.5,
  --     --         },
  --     --       },
  --     --       position = "bottom",
  --     --       size = 20,
  --     --     },
  --     --   },
  --     -- }
  --   end
  -- },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    keys = {
      {"<leader>ff", function() Snacks.picker.files({
        exclude = {
          "target/*",
          "*.class",
          "/static/plugin",
          "*.min.css",
          "*.min.js",
          "*.jar"
        }
      }) end, desc = "Find Files"},
      {"<leader>fT", function() Snacks.picker.todo_comments({
        exclude = {
          "**/static/plugin/**/*.js",
          "*.min.css",
          "*.min.js",
        }
      }) end, desc = "TODO"}
    }
  },
  -- {
  --   "https://git.sr.ht/~jcc/vim-sway-nav",
  -- },
  {
    "igorlfs/nvim-dap-view",
    opts = {
      winbar = {
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
      }
    },
    config = function(_, opts)


      local dap = require("dap")
      local dapview = require("dap-view")

      dap.listeners.after.event_initialized.dapview_config = function()
        dapview.open()
      end
      dap.listeners.before.event_terminated.dapview_config = function()
        dapview.close()
      end
      dap.listeners.before.event_exited.dapview_config = function()
        dapview.close()
      end

      dapview.setup(opts)
    end

  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(plugin, opts)
      -- run default Astronvim nvim-dap-ui configuration function
      require("astronvim.plugins.configs.nvim-dap-ui")(plugin, opts)

      -- change dap events that are created
      local dap = require("dap")
      dap.listeners.after.event_initialized.dapui_config = nil
      dap.listeners.before.event_terminated.dapui_config = nil
      dap.listeners.before.event_exited.dapui_config = nil

      -- disable dap-ui on jdtls
      package.loaded["dapui"] = {
        open = function() require("dap-view").open() end,
        close = function() require("dap-view").close() end,
        toggle = function() require("dap-view").toggle() end,
      }


    end
  },
}

