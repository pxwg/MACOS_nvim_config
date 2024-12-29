local function enabled()
  if vim.g.started_by_firenvim then
    return false
  else
    return true
  end
end

return {
  {
    "catppuccin",
    priority = 1000000,
    name = "catppuccin",
    opts = {
      transparent_background = true,
      integrations = {
        -- cmp = true,
        snacks = true,
        vimtex = false,
      },
      highlight_overrides = {
        all = {
          Conceal = { fg = "#f5c2e7" },
          FloatBorder = { fg = "#b4befe" },
          PmenuSel = { italic = true },
          CmpItemAbbrDeprecated = { fg = "#b4befe", strikethrough = true },
          CmpItemAbbrMatch = { fg = "#b4befe" },
          CmpItemAbbrMatchFuzzy = { fg = "#b4befe" },
          CmpItemAbbrDefault = { fg = "#b4befe" },
          CmpItemAbbr = { fg = "#bac2de" },
          -- Add the following lines
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000000,
    name = "tokyonight",
    opts = {
      transparent = enabled(),
      styles = { sidbars = "transparent", floats = "transparent" },
      on_highlights = function(hl)
        hl.Normal = { bg = "NONE" }
        hl.NormalNC = { bg = "NONE" }
        hl.Conceal = { fg = "#f5c2e7" }
        hl.PmenuSel = { italic = true }
        hl.FloatBorder = { fg = "#b4befe" }
        hl.PmenuSel = { italic = true, bg = "#3c4048" }
        hl.Conceal = { fg = "#5ef1ff" }
        hl.Normal = { bg = "NONE" }
        hl.NormalNC = { bg = "NONE" }
        hl.BufferLineFill = { bg = "NONE" }
        hl.NeoTreeNormal = { bg = "NONE" }
        hl.WhichKeyNormal = { bg = "NONE" }
        hl.lualine_c_normal = { fg = "#828bb8", bg = "NONE" }
        hl.lualine_c_inactive = { fg = "#828bb8", bg = "NONE" }
      end,
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 10000000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
        overrides = {
          PmenuSel = { bg = "#0e3631", fg = "#fbf1c7", italic = true },
          Conceal = { fg = "#d79921" },
        },
      })
    end,
  },
  -- TODO: 把颜色改得花花绿绿的!
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    name = "cyberdream",
    -- enabled = false,
    priority = 10000000,

    opts = {
      transparent = true,
      borderless_telescope = false,
      extensions = {
        -- telescope = false,
        notify = false,
        noice = true,
        mini = true,
        snacks = true,
      },
      theme = {
        variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
        saturation = 1,
        highlights = {
          PmenuSel = { bg = "#3c4048", italic = true },
          texFileArg = { fg = "#ff5ea0" },
          Special = { fg = "#5ef1ff" },
          operator = { fg = "#ff5ea0" },
          texMathSymbol = { fg = "#ff5ea0" },
          texMathOper = { fg = "#5ef1ff" },
          FloatBorder = { fg = "#a080ff" },
          TelescopeBorder = { fg = "#a080ff" },
          BorderBG = { fg = "#ff5ea0" },
          WinSeparator = { fg = "#acacac" },
          texCmdPackage = { fg = "#5eff6c" },
          texCmdClass = { fg = "#5eff6c" },
          texMathZone = { fg = "#5ef1ff" },
          texMathCmd = { fg = "#5ef1ff" },
          texCmdPart = { fg = "#ffbd5e" },
          texMathDelim = { fg = "#ffbd5e" },
          Conceal = { fg = "#5ef1ff" },
        },
      },
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    name = "nightfox",
    priority = 10000000,
    opts = {
      terminal_colors = false,
      modules = {
        snacks = true,
        telescope = false,
        notify = false,
        noice = true,
        vimtex = false,
        mini = true,
        neotree = false,
      },
      groups = {
        all = {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          Conceal = { fg = "#b4befe" },
          BufferLineFill = { bg = "NONE" },
          WinSeparator = { fg = "#bac2de" },
          StatusLine = { bg = "NONE" },
          StatusLineNC = { bg = "NONE" },
          TabLine = { bg = "NONE" }, -- 添加这一行
          TabLineFill = { bg = "NONE" }, -- 添加这一行
          TabLineSel = { bg = "NONE" }, -- 添加这一行
          NeoTreeNormal = { bg = "NONE" }, -- 添加这一行
          NeoTreeNormalNC = { bg = "NONE" }, -- 添加这一行
          -- BorderBG = { fg = "#b4befe" },
        },
      },
    },
  },
  specs = {
    {
      "akinsho/bufferline.nvim",
      optional = true,
      opts = {
        theme = "auto",
      },
    },
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        options = {
          theme = "auto",
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_c = {
            { "filename", color = { bg = "NONE" } },
          },
        },
        inactive_sections = {
          lualine_c = {
            { "filename", color = { bg = "NONE" } },
          },
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = require("util.random_color").get_random_name(),
    },
  },
}
