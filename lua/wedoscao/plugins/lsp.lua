return {
	{
		{
			"williamboman/mason-lspconfig.nvim",
			priority = 999,
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = {
						"rust_analyzer",
						"lua_ls",
						"tsserver",
						"tailwindcss",
						"jsonls",
						"cssls",
						"taplo",
						"html",
						"marksman",
						"sqlls",
						"vimls",
						"bashls",
						"emmet_language_server",
						"htmx",
					},
				})
				require("mason-lspconfig").setup_handlers({
					-- The first entry (without a key) will be the default handler
					-- and will be called for each installed server that doesn't have
					-- a dedicated handler.
					function(server_name) -- default handler (optional)
						require("lspconfig")[server_name].setup({})
					end,
					["rust_analyzer"] = function()
						require("rust-tools").setup({
							server = {
								settings = {
									["rust-analyzer"] = {
										checkOnSave = true,
										check = {
											command = "clippy",
											features = "all",
										},
									},
								},
							},
						})
					end,
				})
			end,
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("UserLspConfig", {}),
					callback = function(ev)
						local opts = { buffer = ev.buf }
						vim.keymap.set("n", "<leader>hv", vim.lsp.buf.hover, opts)
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
						vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
						vim.keymap.set("n", "<leader>f", function()
							vim.lsp.buf.format({ async = true })
						end, opts)
						vim.keymap.set("n", "<leader>er", function()
							local _opts = {
								focusable = false,
								close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
								border = "rounded",
								source = "always",
								prefix = " ",
								scope = "cursor",
							}
							vim.diagnostic.open_float(nil, _opts)
						end)
					end,
				})
			end,
		},

		{
			"simrat39/rust-tools.nvim",
			config = function() end,
		},
		{
			"folke/neodev.nvim",
		},
	},
	{
		{
			"jay-babu/mason-null-ls.nvim",
			priotiry = 999,
			config = function()
				require("mason-null-ls").setup({
					ensure_installed = { "stylua", "prettierd", "sql-formatter", "rustfmt", "beautysh" },
					automatic_installation = false,
					handlers = {},
				})
			end,
		},
		{
			"nvimtools/none-ls.nvim",
			config = function()
				local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
				require("null-ls").setup({
					sources = {
						require("null-ls").builtins.formatting.prettierd.with({
							env = {
								PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(
									vim.fn.stdpath("config") .. "/utils/.prettierrc.json"
								),
							},
						}),
					},
					-- you can reuse a shared lspconfig on_attach callback here
					on_attach = function(client, bufnr)
						if client.supports_method("textDocument/formatting") then
							vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = augroup,
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format({ async = false })
								end,
							})
						end
					end,
				})
			end,
		},
	},
}
