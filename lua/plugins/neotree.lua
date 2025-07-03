return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = false, -- Show hidden files
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_by_name = {
                        -- Java/Maven specific ignores
                        "target",
                        ".DS_Store",
                        "thumbs.db",
                        "node_modules",
                    },
                    hide_by_pattern = {
                        "*.class",
                        "*.jar",
                        "*.war",
                    },
                },
                follow_current_file = {
                    enabled = true,
                },
        }
        })
        vim.keymap.set('n', '<leader>n', ':Neotree filesystem toggle<CR>', {})
        vim.keymap.set('n', '<leader>gs', ':Neotree git_status<CR>', { desc = "Git status" })
    end
    }
 
