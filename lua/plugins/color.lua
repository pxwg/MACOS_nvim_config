return {
  {
    "catppuccin",
    name = "catppuccin",
    opts = {
      transparent_background = true,
      integrations = {
        snacks = true,
        vimtex = false,
      },
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
        overrides = {
          PmenuSel = { bg = "#0e3631", fg = "#fbf1c7", italic = true },
        },
      })
    end,
  },
  -- TODO: 把颜色改得花花绿绿的!
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    name = "cyberdream",
    opts = {
      transparent = true,
      extensions = {
        telescope = false,
        notify = false,
        noice = true,
        mini = true,
        snacks = true,
      },
      theme = {
        variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
        saturation = 1,
        highlights = {
          texMathZone = { fg = "#5ef1ff" },
          texMathSymbol = { fg = "#5ef1ff" },
          texMathOper = { fg = "#ff5ef1" },
        },
      },
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    name = "nightfox",
    opts = {
      terminal_colors = false,
      modules = {
        snacks = true,
        telescope = false,
        notify = false,
        noice = true,
        vimtex = false,
        mini = true,
      },
      groups = { all = { Normal = { bg = "NONE" }, NormalNC = { bg = "NONE" } } },
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
