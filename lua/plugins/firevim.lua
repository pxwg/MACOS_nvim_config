return {
  "glacambre/firenvim",
  build = ":call firenvim#install(0)",
  config = function()
    if vim.g.started_by_firenvim then
      vim.o.laststatus = 0
      vim.opt.guifont = "JetBrainsMono Nerd Font:h28"
    end
  end
}
