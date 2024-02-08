local function show_input(callback, opts)
	if not opts then
		opts = {}
	end
	local popup = require("plenary.popup")
	local height = 1
	local width = 30
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	local win_id = popup.create("", {
		title = opts.title and opts.title or "Input",
		highlight = "InputWindow",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		maxheight = height,
		borderchars = borderchars,
	})

	local bufnr = vim.api.nvim_win_get_buf(win_id)
	vim.keymap.set("n", "<Esc>", function()
		vim.api.nvim_win_close(win_id, true)
	end, { silent = false, buffer = bufnr })

	vim.keymap.set("i", "<Enter>", function() end)

	vim.keymap.set("n", "<Enter>", function()
		local lines = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
		local input = table.concat(lines, "\n")
		callback(input)
		vim.api.nvim_win_close(win_id, true)
	end, { silent = false, buffer = bufnr })
end

local function show_menu(what, callback, opts)
	if not opts then
		opts = {}
	end
	local popup = require("plenary.popup")
	local width = 30
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
	local height = 1
	if #what > 20 then
		height = 20
	elseif #what > 1 then
		height = #what
	end

	local win_id = popup.create(what, {
		title = opts.title and opts.title or "Menu",
		highlight = "MenuWindow",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = 1,
		maxheight = height,
		borderchars = borderchars,
		callback = function(_, selection)
			callback(selection)
		end,
	})
	vim.cmd("set noma")

	local bufnr = vim.api.nvim_win_get_buf(win_id)
	vim.api.nvim_create_autocmd("WinClosed", {
		buffer = bufnr,
		callback = function()
			vim.cmd("set ma")
		end,
	})

	vim.keymap.set("n", "<Esc>", function()
		vim.api.nvim_win_close(win_id, true)
	end, { silent = false, buffer = bufnr })
end

return {
	show_input = show_input,
	show_menu = show_menu,
}
