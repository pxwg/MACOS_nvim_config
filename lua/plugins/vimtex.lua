local synctex = require("util.tdf")
return {
  "lervag/vimtex",
  -- lazy = true,
  config = function()
    vim.cmd([[
let g:tex_flavor='latex'
let g:vimtex_view_method=''
let g:vimtex_quickfix_mode=0
let g:vimtex_fold_enabled=0
" let g:tex_conceal='abdmg'
let g:vimtex_syntax_conceal = {
          \ 'accents': 1,
          \ 'ligatures': 1,
          \ 'cites': 1,
          \ 'fancy': 1,
          \ 'spacing': 1,
          \ 'greek': 1,
          \ 'math_bounds': 1,
          \ 'math_delimiters': 1,
          \ 'math_fracs': 1,
          \ 'math_super_sub': 1,
          \ 'math_symbols': 1,
          \ 'sections': 0,
          \ 'styles': 1,
          \}
]])

    vim.cmd([[
let g:vimtex_compiler_latexmk = {
        \ 'aux_dir' : '',
        \ 'out_dir' : '',
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'hooks' : [],
        \ 'options' : [
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}
]])

    vim.cmd([[
augroup FoldTextHighlight
    autocmd!
    autocmd FileType tex highlight Folded guifg=#A0A0A0 guibg=#282828
augroup END
]])

    -- keymapping for forward search
    vim.keymap.set(
      "n",
      "<localleader>lf",
      " ",
      { noremap = true, silent = true, desc = "Forward Searching", callback = synctex.synctex_forward() }
    )
    -- keymapping for inverse search
    -- vim.keymap.set(
    --   "n",
    --   "<localleader>li",
    --   " ",
    --   { noremap = true, silent = true, desc = "Inverse Searching", callback = synctex.synctex_edit }
    -- )
    -- keymapping for show pdf
    vim.keymap.set("n", "<localleader>lp", function()
      synctex.convert_tex_to_pdf()
      vim.fn.system("hs -c 'enterLaTeXMode()'")
    end, { noremap = true, silent = true, desc = "View PDF in Terminal" })
  end,
}
