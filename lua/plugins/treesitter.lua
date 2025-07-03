
return {
  {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
          require("nvim-treesitter.configs").setup({
              ensure_installed = {
                  "lua",
                  "python",
                  "java",   
                  "xml",
                  "yaml",
                  "json",
                  "go",
                  "bash",
                  "html",
                  "css",
                  "javascript",
                  "typescript",
              },
              sync_install = false,
              auto_install = true, -- Automatically install missing parsers when entering buffer
              highlight = {
                  enable = true,
                  additional_vim_regex_highlighting = false,
              },
              indent = {
                  enable = true,
              },
          })
      end
  }
}
