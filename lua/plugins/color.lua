return {
  {
    "catppuccin",
    priority = 1000,
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
          -- Normal = { bg = "NONE" },
          -- NormalNC = { bg = "NONE" },
          -- BufferLineFill = { bg = "NONE" },
          CmpItemAbbrDeprecated = { fg = "#b4befe", strikethrough = true },
          FloatBorder = { fg = "#b4befe" },
          PmenuSel = { italic = true },
          -- table.insert(PmenuSel, { italic = true }),
          CmpItemAbbrMatch = { fg = "#b4befe" },
          CmpItemAbbrMatchFuzzy = { fg = "#b4befe" },
          -- CmpItemKindVariable = { fg = "#b4befe" },
          -- CmpItemKindInterface = { fg = "#b4befe" },
          -- CmpItemKindText = { fg = "#b4befe" },
          -- CmpItemKindFunction = { fg = "#b4befe" },
          -- CmpItemKindMethod = { fg = "#b4befe" },
          -- CmpItemKindKeyword = { fg = "#b4befe" },
          -- CmpItemKindProperty = { fg = "#b4befe" },
          -- CmpItemKindUnit = { fg = "#b4befe" },
          CmpItemAbbrDefault = { fg = "#b4befe" },
          -- CmpItemMenuDefault = { fg = "#b4befe" },
          CmpItemAbbr = { fg = "#bac2de" },
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    name = "tokyonight",
    opts = {
      transparent = true,
      styles = { sidbars = "transparent", floats = "transparent" },
      on_highlights = function(hl, c)
        hl.PmenuSel = { italic = true }
        hl.Conceal = { fg = "#5ef1ff" }
        hl.Normal = { bg = "NONE" }
        hl.NormalNC = { bg = "NONE" }
        hl.BufferLineFill = { bg = "NONE" }
      end,
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
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
    priority = 1000,

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
          PmenuSel = { italic = true },
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
    priority = 1000,
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
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = require("util.random_color").get_random_name(),
    },
  },
}
