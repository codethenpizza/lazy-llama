# Lazy Llama
lazy-llama is a Neovim plugin that integrates with a local language model (LLM) to provide code suggestions and explanations. It allows you to send prompts to an LLM and display the responses directly within Neovim.

## Features
- Send code or text prompts to a local LLM server.
- Receive and display responses from the LLM.
- Configurable server URL and model settings.
- Supports streaming responses for real-time feedback.
- Loading spinner to indicate ongoing LLM processing.

## Usage

### Request Explanation for Selected Code

You can select a block of code in visual mode and then request an explanation for it. Use the `:ExplainCode` command to send the selected text to the LLM and get an explanation.

1. Select the code in visual mode.
2. Run the command `:ExplainCode`.

### Request General Explanation

To request a general explanation or ask anything, use the `:Explain` command. This command will prompt you to enter a prompt string, which will then be sent to the LLM and the response will be displayed.

```vim
:Explain
```

## Installation
### Using packer.nvim
Add the following to your init.lua or init.vim:

```lua
use {
    'codethenpizza/lazy-llama',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
        require('lazy-llama').setup({
            url = "http://localhost:11434", -- default URL
            model = "deepseek-llm", -- default model
            stream = true, -- enable streaming by default
        })
    end
}
```

### Using vim-plug
Add the following to your init.vim or init.lua:

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'codethenpizza/lazy-llama'
lua << EOF
require('lazy-llama').setup({
    url = "http://localhost:11434", -- default URL
    model = "deepseek-llm", -- default model
})
EOF
```

## Before installing
Make sure you have a [Ollama](https://ollama.com/) server running. You can use the DeepSeek LLM (set by default) or [any other model](https://ollama.com/library) available on the platform.
The plugin will send requests to the server using the specified URL and model.

## Configuration
The plugin can be configured using the setup function. You can provide custom configuration options to override the default settings.

### Default Configuration
```lua
require('lazy-llama').setup({
    url = "http://localhost:11434",
    model = "deepseek-llm",
})
```
### Custom Configuration
You can override the default configuration by passing a table with your desired settings:

```lua
require('lazy-llama').setup({
    url = "http://my-custom-url",
    model = "custom-model",
})
```

## License
This project is licensed under the MIT License.

## Acknowledgements
A big thank you to the authors and maintainers of the following plugins, which served as inspiration for `lazy-llama`:
- [ollama.nvim](https://github.com/nomnivore/ollama.nvim)
- [ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)


