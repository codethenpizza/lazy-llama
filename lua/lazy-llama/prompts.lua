local utils = require('lazy-llama.utils')

local prompts = {}

function prompts.get_code_explanation_prompt()
  local selected_text = utils.get_visual_selection()
  local file_extension = utils.get_current_buffer_file_extension()

  return "This code locates in the file " ..
      vim.fn.expand('%:t') ..
      " and it has extension " ..
      file_extension .. ".\n\n" ..
      "Explain detailed what it does. Code:" ..
      selected_text
end

return prompts
