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
      mode = { "n", "v" }, -- Normal and Visual mode
    },
    {
      "<leader>ai",
      function()
        choose.select_markdown_code_block()
        replace.replace_content()
      end,
      mode = { "n", "v" }, -- Normal and Visual mode
    },
    {
      "<leader>an",
      function()
        choose.select_markdown_code_block()
        replace.insert_content()
      end,
      mode = { "n", "v" }, -- Normal and Visual mode
    },
    {
      "<leader>ag",
      function()
        choose.select_markdown_code_block()
      end,
      mode = { "n", "v" }, -- Normal and Visual mode
    },
  },
  opts = {
    auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
    debug = false, -- Enable debugging

    mappings = {
      complete = {
        detail = "Use @<localleader>s or /<localleader>s for options.",
        insert = "<localleader>s",
      },
    },
  },
  lazy = true, -- Enable lazy loading
  cmd = "CopilotChat",
}
