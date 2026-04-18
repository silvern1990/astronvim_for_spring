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
    "coder/claudecode.nvim",
    config = true,
    keys = {
      { "<leader>a", nil, desc = "Claude Code"},
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    }
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
  {
    "VidocqH/lsp-lens.nvim",
    opts = {
      enable = true,
      include_declaration = false,
    },
  },

  -- color scheme
  {
    "morhetz/gruvbox",
  },
  {
    "sainnhe/everforest",
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
          "*.jar",
          "*.jpeg",
          "*.jpg",
          "*.png",
          "*.dbm",
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
    "rmagatti/auto-session",
    opts = {
      auto_save_enabled = true,
    }
  },
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

      local preserved_console_buf = nil

      dap.listeners.after.event_initialized.dapview_config = function()
        dapview.open()
      end

      -- 디버그 세션이 종료되기 전에, 디버그 콘솔 버퍼를 별도의 버퍼에 백업
      dap.listeners.before.event_terminated.dapview_config = function()
        local s = dap.session()
        if s and s.term_buf then
          local lines = vim.api.nvim_buf_get_lines(s.term_buf, 0, -1, false)
          if not vim.tbl_isempty(lines) then
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

            vim.bo[buf].buftype = "nofile"
            vim.bo[buf].bufhidden = "hide"
            vim.bo[buf].swapfile = false
            vim.bo[buf].filetype = "dap-view-console"

            preserved_console_buf = buf
          end
        end
      end

      -- 디버그 세션이 종료된 후에 저장된 콘솔 버퍼를 dap-view 윈도우에 연결
      dap.listeners.after.event_terminated.dapview_config = function()
        if not preserved_console_buf
          or not vim.api.nvim_buf_is_valid(preserved_console_buf)
        then
          return
        end

        require("dap-view").open()

        vim.schedule(function()
          local console_win = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "dap-view" then
              console_win = win
            end
          end

          if not console_win then return end

          vim.wo[console_win].winfixbuf = false
          vim.api.nvim_win_set_buf(console_win, preserved_console_buf)
          vim.api.nvim_win_set_cursor(console_win, {vim.api.nvim_buf_line_count(preserved_console_buf), 0})
          vim.wo[console_win].winfixbuf = true
        end)

      end

      dap.listeners.before.event_exited.dapview_config = function()
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

