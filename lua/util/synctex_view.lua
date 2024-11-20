local M = {}

function M.synctex_view()
  local tex_filename = vim.fn.expand("%:t")
  local tex_filepath = vim.fn.expand("%:p")
  local pdf_filename = tex_filename:gsub("%.tex$", ".pdf")
  local pdf_filepath = vim.fn.expand("%:p:h") .. "/" .. pdf_filename

  local line_number = vim.fn.line(".")
  local column_number = vim.fn.col(".")

  -- Get the word under the cursor
  local word = vim.fn.expand("<cword>")

  local synctex_command = string.format(
    "synctex view -i %d:%d:%s -o %s | grep -m1 'Page:' | sed 's/Page://' | tr -d '\\n'",
    line_number,
    column_number,
    tex_filepath,
    pdf_filepath
  )

  local result = vim.fn.system(synctex_command)

  local result_number = tonumber(result) - 1

  local applescript_command = string.format(
    [[
    tell application "iTerm2"
      tell current session of current window
        tell application "System Events" to keystroke "]" using {command down}
        delay 0.1
        write text "g%s"
        write text "/%s"
      end tell
    end tell
  ]],
    result_number,
    word
  )

  vim.fn.system({ "osascript", "-e", applescript_command })
end

function M.convert_tex_to_pdf()
  local filename = vim.fn.expand("%:t")
  local pdf_filename = filename:gsub("%.tex$", ".pdf")
  local pdf_path = vim.fn.expand("%:p:h") .. "/" .. pdf_filename

  if vim.fn.filereadable(pdf_path) == 1 then
    local command = "~/tdf.sh " .. pdf_path
    vim.fn.system(command)
  else
    print("No pdf file found")
  end
end

return M
