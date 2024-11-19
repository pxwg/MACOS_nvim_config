local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
vim.o.timeoutlen = 50
vim.o.ttimeout = true
vim.o.ttimeoutlen = 10
vim.g.PinyinSearch_Dict = "~/.config/nvim/spell/PinyinSearch.dict"

-- vim.api.nvim_create_augroup("dashbroad", { clear = true })
-- vim.api.nvim_create_autocmd("VimEnter", {
--   group = "dashbroad",
--   command = "Dashboard",
-- })

-- vim.api.nvim_create_augroup("copilot_chat", { clear = true })
-- vim.api.nvim_create_autocmd("VimEnter", {
--   group = "copilot_chat",
--   callback = function()
--     vim.cmd("CopilotChat")
--   end,
-- })

-- require("plugins.nvim-cmp")
-- require("lsp.rime_2").setup_rime()

require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   after = {
  --     "hrsh7th/nvim-cmp",
  --     version = false, -- last release is way too old
  --     event = { "InsertEnter", "CmdlineEnter" },
  --     dependencies = {
  --       "hrsh7th/cmp-nvim-lsp",
  --       "hrsh7th/cmp-buffer",
  --       "hrsh7th/cmp-path",
  --     },
  --   },
  -- },
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

-- vim.cmd("colorscheme catppuccin")

-- -- 记录启动开始时间
-- local start_time = vim.loop.hrtime()
--
-- -- 在 VimEnter 事件后计算启动时间
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     local end_time = vim.loop.hrtime()
--     local elapsed_time = (end_time - start_time) / 1e6 -- 转换为毫秒
--     print(string.format("Neovim 启动时间: %.2f ms", elapsed_time))
--   end,
-- })

-- require("lspconfig")
-- require("plugins.nvim-cmp")
vim.api.nvim_exec(
  [[
  autocmd VimEnter * CopilotChat
  ]],
  false
)

--
-- -- 确保启动时进入 normal 模式
-- vim.api.nvim_exec(
--   [[
--   autocmd VimEnter * stopinsert
--   ]],
--   false
-- )
--
-- -- 移动到左侧窗口
-- vim.api.nvim_exec(
--   [[
--   autocmd VimEnter * wincmd h
-- ]],
--   false
-- )
vim.api.nvim_exec(
  [[
  autocmd VimEnter * CopilotChatClose
]],
  false
)
vim.api.nvim_create_augroup("copilot_chat", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "copilot_chat",
  pattern = "copilot-chat",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

vim.g.python3_host_prog = "/opt/homebrew/Caskroom/miniconda/base/bin/python3"

vim.cmd([[
        highlight Conceal guifg=#f5c2e7
        highlight Pmenu guibg=#1e1e2e
        highlight! BorderBG guibg=NONE guifg=#b4befe
      ]])
vim.cmd([[
  highlight Normal guibg=#191C28
]])
vim.o.pumblend = 0
require("lsp.rime_2").setup_rime()
