
-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
--
---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    -- colorscheme = "nightfly",
    colorscheme = "catppuccin",
    termguicolors = true,
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes

        NeoTreeNormal = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeNormalNC = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabActive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabInactive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeWinSeparator = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabSeparatorActive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabSeparatorInactive = { bg = "NONE", ctermbg = "NONE" },

        LineNr = { bg = "NONE", ctermbg = "NONE"},
        Normal = { bg = "NONE", ctermbg = "NONE" },
        NormalNC = { bg = "NONE", ctermbg = "NONE"},
        EndOfBuffer = { bg = "NONE", ctermbg = "NONE"},
        TabLine = { bg = "NONE", ctermbg = "NONE" },
        TabLineSel = { bg = "NONE", ctermbg = "NONE" },
        TabLineFill = { bg = "NONE", ctermbg = "NONE" },

      },
      astrodark = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
