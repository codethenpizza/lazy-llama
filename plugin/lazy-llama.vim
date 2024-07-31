lua require("lazy-llama")

command! ExplainCode lua require('lazy-llama').get_code_explanation()

nnoremap <silent> <leader>y :ExplainCode<CR>
vnoremap <silent> <leader>y :<C-u>ExplainCode<CR>

command! Explain lua require('lazy-llama').get_explanation(vim.fn.input("Enter prompt: "))
