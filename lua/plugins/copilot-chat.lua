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
  opts = {
    auto_insert_mode = true, -- Automatically enter insert mode when opening window and on new prompt
    debug = false, -- Enable debugging

    mappings = {
      complete = {
        detail = "Use @<localleader>s or /<localleader>s for options.",
        insert = "<localleader>s",
      },
    },
    key = {
      {
        "n",
        "v",
        "<leader>aI",
        function()
  choose.select_markdown_code_block()
  replace.replace_content_and_back()
        end,
        { noremap = true, silent = true, desc = "Replace selected text with AI code and back" },
      },
      {
        "n",
        "v",
        "<leader>ai",
        function()
  choose.select_markdown_code_block()
  replace.replace_content()
        end,
        { noremap = true, silent = true, desc = "Replace selected text with AI code" },
      },
      {
        "n",
        "<leader>an",
        function()
  choose.select_markdown_code_block()
  replace.insert_content()
        end,
        { noremap = true, silent = true, desc = "Insert AI code to the new line" },
      },
      {
        "n",
        "<leader>ag",
        function()
  choose.select_markdown_code_block()
        end,
        { noremap = true, silent = true, desc = "Jump and select AI code" },
      },
    },
  },
  lazy = true, -- Enable lazy loading
  cmd = "CopilotChat",
}
