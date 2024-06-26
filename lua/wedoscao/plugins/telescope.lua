return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-web-devicons" },
	config = function()
		require("telescope").setup({
			defaults = { file_ignore_patterns = { "^.git/", "%.png", "%.jpg", "%.jpeg", "%.gif", "%.webp", "%.ico" } },
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		vim.keymap.set("n", "<leader>fe", builtin.diagnostics, {})
		require("telescope").load_extension("workspaces")
	end,
}
