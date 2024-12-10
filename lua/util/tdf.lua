local M = {}

local function getPages()
  local handle = io.popen('hs -c "print(getPages())"')
  if not handle then
    print("Failed to open handle")
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  if not result then
    print("Failed to read result")
    return nil
  end

  -- print(result)
  return result
end

_G.getPages = getPages

-- TODO: need to consider the inverse searching which could trigger to the source file (via synctex 'input')

function M.convert_tex_to_pdf()
  local tex_filename = vim.fn.expand("%:t")
  local tex_filepath = vim.fn.expand("%:p")
  local pdf_filename = tex_filename:gsub("%.tex$", ".pdf")
  local pdf_filepath = [["]] .. vim.fn.expand("%:p:h") .. "/" .. pdf_filename .. [["]]
  local pdf_pos = vim.fn.expand("%:p:h") .. "/" .. pdf_filename

  local line_number = vim.fn.line(".")
  local column_number = vim.fn.col(".")
  local synctex_command =
    string.format("synctex view -i %d:%d:%s -o %s", line_number, column_number, tex_filepath, pdf_filepath)

  local result = vim.fn.system(synctex_command)

  if vim.fn.filereadable(pdf_pos) == 0 then
    vim.notify("Error: PDF file not found at " .. pdf_filepath, vim.log.levels.WARN)
    return
  end

  local page = result:match("Page:(%d+)")
  local x = result:match("x:([%d%.]+)")
  local y = result:match("y:([%d%.]+)")

  local hs_command = string.format("hs -c 'openPDF(%s,%s,%s,%s)'", pdf_filepath, x, y, page)
  vim.fn.system(hs_command)
  vim.fn.system("hs -c 'enterLaTeXMode()'")
end

function M.synctex_forward()
  local tex_filename = vim.fn.expand("%:t")
  local tex_filepath = vim.fn.expand("%:p")
  local pdf_filename = tex_filename:gsub("%.tex$", ".pdf")
  local pdf_filepath = vim.fn.expand("%:p:h") .. "/" .. pdf_filename

  local line_number = vim.fn.line(".")
  local column_number = vim.fn.col(".")
  local synctex_command =
    string.format("synctex view -i %d:%d:%s -o %s", line_number, column_number, tex_filepath, pdf_filepath)

  -- 执行命令并获取输出
  local result = vim.fn.system(synctex_command)

  -- 打印 synctex_command 和 result 以进行调试
  -- print("synctex_command:", synctex_command)
  -- print("result:", result)

  local page = result:match("Page:(%d+)")
  local x = result:match("x:([%d%.]+)")
  local y = result:match("y:([%d%.]+)")

  -- print("Page:" .. page)
  -- print("x:" .. x)
  -- print("y:" .. y)

  if page and x and y then
    local hs_command = string.format("hs -c 'drawRedDotOnA4(%s,%s,%s)'", x, y, page)
    local hs_result = vim.fn.system(hs_command)
    --   print("hs_command:", hs_command)
    --   print("hs_result:", hs_result)
    -- else
    --   print("Failed to extract Page, x, or y values.")
  end
end

-- TODO: need to consider the inverse searching which could trigger to the source file (via synctex 'input')
function M.synctex_inverse()
  local page_number = getPages()
  page_number = tonumber(page_number)

  -- Read x and y from /tmp/nvim_hammerspoon_latex.txt
  local file = io.open("/tmp/nvim_hammerspoon_latex.txt", "r")
  local x, y
  if file then
    x = file:read("*line")
    y = file:read("*line")
    file:close()
  else
    print("Failed to open /tmp/nvim_hammerspoon_latex.txt")
    return
  end

  -- Check if x and y are not nil
  if not x or not y then
    print("x or y is nil")
    return
  end

  -- Get the current file path and pdf file path
  local pdf_filename = vim.fn.expand("%:t"):gsub("%.tex$", ".pdf")
  local pdf_filepath = vim.fn.expand("%:p:h") .. "/" .. pdf_filename
  -- Construct the synctex edit command
  local synctex_command = string.format("synctex edit -o %s:%s:%s:%s", page_number, x, y, pdf_filepath)

  -- Execute the command and get the result
  local handle = io.popen(synctex_command)
  local result = nil
  if handle then
    result = handle:read("*a")
    handle:close()
  end
  local line = result:match("Line:(%d+)")
  local column = result:match("Column:(%-?%d+)")

  -- Convert the result to a number and jump to the line
  local line_number = tonumber(line)
  local column_number = tonumber(column)
  -- print("column_number:", column_number)
  if line_number and column_number then
    vim.fn.cursor(line_number, 1)
  else
    print("Failed to get line number from synctex edit command")
  end
end

return M
