local spinner = require('lazy-llama.spinner')
local utils = require('lazy-llama.utils')
local prompts = require('lazy-llama.prompts')
local M = {}

-- Default configuration
local default_config = {
  url = "http://localhost:11434",
  model = "deepseek-llm",
}

-- Configuration table to store the final configuration
local config = {}

function M.setup(user_config)
  -- Merge default config with user config
  config = vim.tbl_deep_extend("force", default_config, user_config or {})
end

local function get_data_from_llm(prompt, callback)
  local curl = require('plenary.curl')

  local llm_url = config.url .. "/api/generate"
  local request_data = {
    prompt = prompt,
    model = config.model,
    stream = true,
  }

  local request_data_json = vim.fn.json_encode(request_data)

  -- Use a coroutine to handle streaming
  local co = coroutine.create(function()
    curl.post(llm_url, {
      body = request_data_json,
      headers = {
        ['Content-Type'] = 'application/json',
      },
      stream = function(_, chunk)
        -- Handle streaming data
        if chunk then
          vim.schedule(function()
            local partial_response = vim.fn.json_decode(chunk)
            if partial_response and partial_response.response then
              callback(partial_response.response, partial_response.done)
            end
          end)
        end
      end
    })
  end)
  coroutine.resume(co)
end

M.get_explanation = function(prompt)
  local width = math.floor(vim.o.columns * 0.8)
  local buf = utils.get_buffer(width)

  -- Start the loading spinner
  local spinner_timer = spinner.start_loading_spinner(buf)
  -- Accumulate data as it comes in
  local accumulated_data = ""

  -- Callback function to handle streaming data
  local function handle_streaming_data(data, is_steam_end)
    if is_steam_end then
      -- Stop the loading spinner
      spinner.stop_loading_spinner(spinner_timer, buf)
      return
    end

    accumulated_data = accumulated_data .. data
    -- Wrap and set the lines in the buffer
    local lines = utils.wrap_text(accumulated_data, width)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end

  -- Get suggestions with streaming
  get_data_from_llm(prompt, handle_streaming_data)
end

M.get_code_explanation = function()
  local prompt = prompts.get_code_explanation_prompt()
  M.get_explanation(prompt)
end


return M
