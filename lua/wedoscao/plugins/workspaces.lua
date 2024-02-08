local function get_workspace_names()
	local workspaces = require("workspaces")
	local workspace_names = {}
	for _, item in ipairs(workspaces.get()) do
		table.insert(workspace_names, item.name)
	end
	return workspace_names
end

local ui = require("wedoscao.ui")

return {
	"natecraddock/workspaces.nvim",
	config = function()
		local workspaces = require("workspaces")
		workspaces.setup({})
		vim.keymap.set("n", "<leader>wo", function()
			workspaces.sync_dirs()
			local workspace_names = get_workspace_names()
			ui.show_menu(workspace_names, function(selection)
				workspaces.open(selection)
			end, { title = "Open Workspace" })
		end)

		vim.keymap.set("n", "<leader>wr", function()
			workspaces.sync_dirs()
			local workspace_names = get_workspace_names()
			for _, item in ipairs(workspaces.get()) do
				table.insert(workspace_names, item.name)
			end
			ui.show_menu(workspace_names, function(name)
				workspaces.remove(name)
			end, { title = "Remove Workspace" })
		end)

		vim.keymap.set("n", "<leader>wad", function()
			ui.show_input(function(path)
				local expanded_path = vim.fn.expand(path)
				workspaces.add_dir(expanded_path)
			end, { title = "Add Dir" })
		end)

		vim.keymap.set("n", "<leader>wrd", function()
			ui.show_input(function(path)
				local expanded_path = vim.fn.expand(path)
				workspaces.remove_dir(expanded_path)
			end, { title = "Remove Dir" })
		end)

		local has_nvim = false
		for _, item in ipairs(get_workspace_names()) do
			if item == "nvim" then
				has_nvim = true
			end
		end
		if not has_nvim then
			workspaces.add(vim.fn.expand("~/.config/nvim"), "nvim")
		end
		workspaces.open("nvim")
	end,
}
