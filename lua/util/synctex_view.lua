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
      tell application "System Events" to keystroke "[" using {command down}
      delay 1.5
      tell application "System Events" to keystroke "]" using {command down}
      delay 0.5
      write text "/*"
      tell application "System Events" to keystroke "[" using {command down}
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
  local osascript_command = [[osascript -e 'tell application "System Events" to keystroke "[" using {command down}' ]]
  vim.fn.system(osascript_command)
end

function M.synctex_edit()
  -- Prompt user to input page number
  local page_number = vim.fn.input("Enter page number: ")
  page_number = tonumber(page_number)

  -- Get the current file path and pdf file path
  local pdf_filename = vim.fn.expand("%:t"):gsub("%.tex$", ".pdf")
  local pdf_filepath = vim.fn.expand("%:p:h") .. "/" .. pdf_filename

  -- Construct the synctex edit command
  local synctex_command = string.format(
    "synctex edit -o %s:60:20:%s | grep -m1 'Line:' | sed 's/Line://' | tr -d '\\n'",
    page_number,
    pdf_filepath
  )

  -- Execute the command and get the result
  local result = vim.fn.system(synctex_command)

  -- Convert the result to a number and jump to the line
  local line_number = tonumber(result)
  if line_number then
    vim.fn.cursor(line_number, 1)
  else
    print("Failed to get line number from synctex edit command")
  end
end

return M
