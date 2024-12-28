return {
  "folke/zen-mode.nvim",
  enabled = false,
  opts = {
    on_open = function()
      vim.o.cmdheight = 1
    end,
    on_close = function()
      vim.o.cmdheight = 0
    end,
    window = {
      width = 0.75,
      options = {
        signcolumn = "no", -- disable signcolumn
        number = false, -- disable number column
        relativenumber = false, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        -- cursorcolumn = false, -- disable cursor column
        -- foldcolumn = "0", -- disable fold column
        -- list = false, -- disable whitespace characters
      },
    },
    gitsin = { enabled = true },
    -- plugins = { wezterm = { enabled = true, font = "+1" } },

    vim.api.nvim_set_keymap(
      "n",
      "<leader>z",
      ":ZenMode<CR>",
      { noremap = true, silent = true, desc = "Toggle Zen Mode" }
    ),
  },
}
