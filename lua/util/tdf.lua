local M = {}

local function getPages()
  local handle = io.popen('hs -c "print(getPages())"')
  local result = handle:read("*a")
  handle:close()
  return result
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

  -- 提取 Page, x, y 参数的值
  local page = result:match("Page:(%d+)")
  local x = result:match("x:([%d%.]+)")
  local y = result:match("y:([%d%.]+)")

  -- -- 打印提取的值以进行调试
  -- print("Page:" .. page)
  -- print("x:" .. x)
  -- print("y:" .. y)

  -- 构建命令行并执行
  if page and x and y then
    local hs_command = string.format("hs -c 'drawRedDotOnA4(%s,%s,%s)'", x, y, page)
    local hs_result = vim.fn.system(hs_command)
    --   print("hs_command:", hs_command)
    --   print("hs_result:", hs_result)
    -- else
    --   print("Failed to extract Page, x, or y values.")
  end
end

function M.synctex_inverse()
  local page_number = getPages()
  page_number = tonumber(page_number)

  -- Get the current file path and pdf file path
  local pdf_filename = vim.fn.expand("%:t"):gsub("%.tex$", ".pdf")
  local pdf_filepath = vim.fn.expand("%:p:h") .. "/" .. pdf_filename
  -- Construct the synctex edit command
  local synctex_command = string.format(
    "synctex edit -o %s:1:1:%s | grep -m1 'Line:' | sed 's/Line://' | tr -d '\\n'",
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
