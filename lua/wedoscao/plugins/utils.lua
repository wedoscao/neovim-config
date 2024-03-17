return {
	"nvim-lua/plenary.nvim",
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
