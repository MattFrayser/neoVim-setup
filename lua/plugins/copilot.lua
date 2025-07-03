-- Not using atm

return {
    {
        "github/copilot.vim",
        enabled = false,
        --[[
        config = function()

            vim.g.copilot_no_tab_map = true

            vim.keymap.set('i', '<C-Enter>', 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,
                desc = "Accept all Copilot suggestion"
            })
            -- Accept WORD (next word only)
            vim.keymap.set('i', '<C-w>', '<Plug>(copilot-accept-word)', {
                desc = "Accept next word from Copilot"
            })

            -- Accept LINE (current line only)
            vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept-line)', {
                desc = "Accept current line from Copilot"
            })

            -- Next/Previous suggestions
            vim.keymap.set('i', '<C-j>', '<Plug>(copilot-next)')
            vim.keymap.set('i', '<C-k>', '<Plug>(copilot-previous)')

            -- Dismiss suggestion
            vim.keymap.set('i', '<C-n>', '<Plug>(copilot-dismiss)')

            -- Toggle Copilot on/off
            vim.keymap.set('n', '<leader>ct', ':Copilot toggle<CR>', { desc = "Toggle Copilot" })
        end
        --]]
    }
}
 
