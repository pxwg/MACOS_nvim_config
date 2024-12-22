return {
  "arnamak/stay-centered.nvim",
  keys = {
    {
      "<leader>ct",
      function()
        require("stay-centered").toggle()
      end,
      desc = "Toggle stay-centered",
    },
    opts = { enabled = true },
  },
}
