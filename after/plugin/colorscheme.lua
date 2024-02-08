local function set_colorscheme(colorscheme)
	colorscheme = colorscheme or vim.g.colorscheme or "default"
	vim.cmd.colorscheme(colorscheme)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

set_colorscheme()

local function set_colorscheme_ui()
	local ui = require("wedoscao.ui")
	local coloschemes = vim.fn.getcompletion("", "color")
	for i, v in ipairs(coloschemes) do
		if v == "default" then
			table.remove(coloschemes, i)
			table.insert(coloschemes, 1, "default")
			break
		end
	end
	ui.show_menu(coloschemes, function(selection)
		if selection == "default" then
			selection = vim.g.colorscheme or "default"
		end
		set_colorscheme(selection)
	end, { title = "Colorscheme" })
end

vim.keymap.set("n", "<leader>co", set_colorscheme_ui)
