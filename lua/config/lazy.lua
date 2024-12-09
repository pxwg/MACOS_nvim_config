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
vim.cmd([[
  command! StartHammerspoon lua StartHammerspoon()
]])

function StartHammerspoon()
  local job = vim.fn.jobstart("hs -c \"require('latex_pdf_view')\"", {
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        print(line)
      end
    end,
    on_stderr = function(_, data, _)
      for _, line in ipairs(data) do
        print(line)
      end
    end,
    on_exit = function(_, code, _)
      print("Hammerspoon exited with code " .. code)
    end,
  })
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
        highlight Conceal guifg=#f5c2e7
        highlight Pmenu guibg=#191C28
        highlight! BorderBG guibg=NONE guifg=#b4befe
        highlight Normal guibg=#191C28
        highlight! NormalNC guibg=#191C28
  highlight normalfloat guibg=none guifg=none
  " highlight floatborder guibg=none
    " highlight NormalFloat guibg=NONE
    " highlight FloatBorder guibg=NONE
]])

vim.o.pumblend = 0
