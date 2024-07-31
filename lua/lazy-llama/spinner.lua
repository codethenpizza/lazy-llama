local spinner = {}

function spinner.start_loading_spinner(buf)
  local spinner_frames = { '|', '/', '-', '\\' }
  local frame_index = 1
  local spinner_line = nil

  local function update_spinner()
    local num_lines = vim.api.nvim_buf_line_count(buf)

    -- If there are no lines, set an empty line
    if num_lines == 0 then
      vim.api.nvim_buf_set_lines(buf, 0, 0, false, { '' })
      num_lines = 1
    end

    -- Clear the previous spinner line if it exists
    if spinner_line and spinner_line > 0 and spinner_line <= num_lines then
      local current_line = vim.api.nvim_buf_get_lines(buf, spinner_line - 1, spinner_line, false)[1] or ""
      local updated_line = string.gsub(current_line, '^[|/-\\] Loading...', '')
      vim.api.nvim_buf_set_lines(buf, spinner_line - 1, spinner_line, false, { updated_line })
    end

    -- Set the new spinner character at the last line of the buffer
    spinner_line = num_lines
    local spinner_char = spinner_frames[frame_index]
    local spinner_text = spinner_char .. ' Loading...'
    vim.api.nvim_buf_set_lines(buf, spinner_line - 1, spinner_line, false, { spinner_text })

    -- Move to the next frame
    frame_index = (frame_index % #spinner_frames) + 1
  end

  -- Update the spinner every 100 ms
  local timer = vim.loop.new_timer()
  timer:start(0, 100, vim.schedule_wrap(function()
    update_spinner()
  end))

  return timer
end

function spinner.stop_loading_spinner(timer, buf)
  timer:stop()
  timer:close()

  -- Clear the spinner line
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #lines > 0 then
    vim.api.nvim_buf_set_lines(buf, #lines - 1, #lines, false, { '' })
  end
end

return spinner
