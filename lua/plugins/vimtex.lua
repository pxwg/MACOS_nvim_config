return {
  "lervag/vimtex",
  -- lazy = true,
  config = function()
    vim.cmd([[
let g:tex_flavor='latex'
let g:vimtex_view_method='skim'
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

    -- 定义 convert_tex_to_pdf 函数
    local function convert_tex_to_pdf()
      local filename = vim.fn.expand("%:t")
      local pdf_filename = filename:gsub("%.tex$", ".pdf")
      local pdf_path = vim.fn.expand("%:p:h") .. "/" .. pdf_filename

      if vim.fn.filereadable(pdf_path) == 1 then
        local command = "~/tdf.sh " .. pdf_path
        vim.fn.system(command)
      else
        print("没有PDF文件!")
      end
    end

    _G.convert_tex_to_pdf = convert_tex_to_pdf

    -- 添加键映射
    vim.api.nvim_set_keymap(
      "n",
      "<localleader>lp",
      ":lua convert_tex_to_pdf()<CR>",
      { noremap = true, silent = true, desc = "Convert tex to pdf" }
    )
  end,
}
