return {
    "nvim-lua/plenary.nvim",
    {
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup({
                enable_tailwind = true,
            })
        end,
    },
    "nvim-tree/nvim-web-devicons",
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({
                opleader = {
                    line = "<C-_>",
                },
            })
        end,
    },
}
