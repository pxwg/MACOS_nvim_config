return {
  "michaelb/sniprun",
  branch = "master",

  build = "sh install.sh",
  -- do 'sh install.sh 1' if you want to force compile locally
  -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

  config = function()
    require("sniprun").setup({
      display = { "Api" },
      -- borders = "shadow",
      -- display = { "TempFloatingWindow", "LongTempFloatingWindow", "Api" },
      -- repl_enable = { "Mathematica_original" },
      interpreter_options = {
        Mathematica_original = {
          use_javagraphics_if_contains = { "Plot" }, -- a pattern that need <<JavaGraphics
        },
      },
    })
  end,
}
