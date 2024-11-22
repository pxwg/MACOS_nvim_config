return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  },
  build = "make tiktoken", -- Only on MacOS or Linux
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
