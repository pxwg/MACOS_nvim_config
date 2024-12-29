local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.env.LANG = "zh_CN.UTF-8"
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
vim.o.timeoutlen = 50
vim.o.ttimeout = true
vim.o.ttimeoutlen = 10
-- vim.o.scrolloff = 10

local file_path = "/tmp/nvim_hammerspoon_latex.txt"
local file = io.open(file_path, "r")
if not file then
  file = io.open(file_path, "w")
  if not file then
    print("failed to create " .. file_path)
    return
  end
  file:close()
  print(file_path .. " created")
end

require("lazy").setup({
  ui = {
    border = "rounded",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
  },
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        texlab = {
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
    },
  },
})

vim.g.python3_host_prog = "/opt/homebrew/Caskroom/miniconda/base/bin/python3"

  vim.cmd([[
        highlight! BorderBG guibg=NONE guifg=#b4befe
        highlight! normalfloat guibg=none guifg=none
        highlight! BufferLineFill guibg=none
        " highlight! Normal guibg=NONE
        " highlight! NormalNC guibg=NONE
        highlight! WinSeparator guibg=None guifg=#bac2de
        highlight! StatusLine guibg=NONE guifg=#c0caf5
        highlight! StatusLineNC guibg=NONE guifg=#c0caf5
        highlight! TabLine guibg=NONE guifg=#c0caf5
        highlight! TabLineFill guibg=NONE guifg=#c0caf5
        highlight! TabLineSel guibg=NONE guifg=#c0caf5
        highlight! NeoTreeNormal guibg=NONE guifg=#c0caf5
        highlight! NeoTreeNormalNC guibg=NONE guifg=#c0caf5
]])
vim.o.pumblend = 0

-- if vim.g.colors_name == "nightfox" then
-- vim.cmd([[
--     highlight Normal guibg=#191C28
--     highlight! NormalNC guibg=#191C28
--   ]])
-- end

require("util.listen_code_change")
