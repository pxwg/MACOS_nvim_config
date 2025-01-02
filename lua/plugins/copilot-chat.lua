local replace = require("util.replace_ai")
local choose = require("util.markdown_code")
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  },
  build = "make tiktoken", -- Only on MacOS or Linux
  keys = {
    {
      "<leader>aI",
      function()
        choose.select_markdown_code_block()
        replace.replace_content_and_back()
      end,
      desc = "Replace with AI and go back",
      mode = { "n", "v" }, -- Normal and Visual mode
    },
    {
      "<leader>ai",
      function()
        choose.select_markdown_code_block()
        replace.replace_content()
      end,
      desc = "Replace with AI",
      mode = { "n", "v" }, -- Normal and Visual mode
    },
    {
      "<leader>an",
      function()
        choose.select_markdown_code_block()
        replace.insert_content()
      end,
      desc = "Insert with AI",
      mode = { "n", "v" }, -- Normal and Visual mode
    },
    {
      "<leader>ag",
      function()
        choose.select_markdown_code_block()
      end,
      desc = "Select AI code",
      mode = { "n", "v" }, -- Normal and Visual mode
    },
    {
      "<C-l>",
      false,
    },
  },
  opts = {
    auto_insert_mode = true, -- Automatically enter insert mode when opening window and on new prompt
    debug = false, -- Enable debugging

    mappings = {
      reset = {
        normal = "<C-b>",
        insert = "<C-b>",
      },
      complete = {
        detail = "Use @<localleader>s or /<localleader>s for options.",
        insert = "<localleader>s",
      },
    },
  },
  lazy = true, -- Enable lazy loading
  cmd = "CopilotChat",
}
