return {
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  opts = {
    modes = { insert = true, command = true, terminal = false },
    -- skip autopair when next character is one of these
    -- skip_next = { [=[[%w%%%'%[%"%.%`%$]]=] },
    -- -- skip_next = { [=[[%w%%%'%[%"%.%`%$%(%)]]=] },
    -- -- skip autopair when the cursor is inside these treesitter nodes
    -- skip_ts = { "string" },
    -- -- skip autopair when next character is closing pair
    -- -- and there are more closing pairs than opening pairs
    -- skip_unbalanced = true,
    -- -- better deal with markdown code blocks
    -- markdown = true,
    mappings = {
      ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
      ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
      ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

      [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
      ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
      ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
    },
  },
  config = function(_, opts)
    -- local filetype = vim.bo.filetype
    --
    -- -- 如果文件类型是 tex，则禁用 () 的自动补全
    -- if filetype == "tex" then
    --   opts.mappings["("] = nil
    --   opts.mappings[")"] = nil
    -- end

    -- 否则，启用 mini.pairs
    LazyVim.mini.pairs(opts)
  end,
}
