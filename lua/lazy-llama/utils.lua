local utils = {}

-- Wrap text to fit within a certain width
function utils.wrap_text(text, max_width)
  local lines = {}
  for line in text:gmatch("[^\r\n]+") do
    while #line > max_width do
      local wrap_pos = line:sub(1, max_width):find("%s[^%s]*$")
      if not wrap_pos then
        wrap_pos = max_width
      end
      table.insert(lines, line:sub(1, wrap_pos - 1))
      line = line:sub(wrap_pos + 1)
    end
    table.insert(lines, line)
  end
  return lines
end

-- Get the visual selection in the vsiual mode
function utils.get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  if #lines == 0 then
    return ""
  end

  lines[1] = string.sub(lines[1], start_pos[3])
  lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])

  return table.concat(lines, "\n")
end

function utils.get_selected_text()
  local mode = vim.fn.mode()
  local prompt

  if mode == 'v' or mode == 'V' then
    prompt = utils.get_visual_selection()
  else
    prompt = vim.api.nvim_get_current_line()
  end

  return prompt
end

function utils.get_current_buffer_file_extension()
  -- Get the buffer number of the current buffer
  local buf = vim.api.nvim_get_current_buf()
  -- Get the filename of the buffer
  local filename = vim.api.nvim_buf_get_name(buf)
  return vim.fn.fnamemodify(filename, ":e")
end

function utils.get_buffer(width)
  local buf = vim.api.nvim_create_buf(false, true)

  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  })

  return buf
end

return utils
