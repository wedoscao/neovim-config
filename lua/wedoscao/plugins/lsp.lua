return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},
	{
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = {
				"williamboman/mason.nvim",
			},
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
						"html",
						"marksman",
						"sqlls",
						"vimls",
						"bashls",
						"emmet_language_server",
						"htmx",
						"gopls",
						"pylsp",
						"clangd",
						"cmake",
						"templ",
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
						vim.api.nvim_create_autocmd("BufEnter", {
							callback = function(ev)
								local bufnr = ev.buf
								local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
								local filename = vim.fn.expand("%:t")
								if filename:sub(-#".rs") == ".rs" then
									vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
									vim.api.nvim_create_autocmd("BufWritePre", {
										group = augroup,
										buffer = bufnr,
										command = "RustFmt",
									})
								end
							end,
						})

						require("lspconfig").rust_analyzer.setup({
							checkOnSave = {
								command = "clippy",
							},
						})
					end,
					["bashls"] = function()
						require("lspconfig").bashls.setup({
							filetypes = { "sh", "zsh" },
						})
					end,
				})
			end,
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason-lspconfig.nvim",
			},
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
			"folke/neodev.nvim",
		},
	},
	{
		{
			"jay-babu/mason-null-ls.nvim",
			dependencies = {
				"williamboman/mason.nvim",
			},
			config = function()
				require("mason-null-ls").setup({
					ensure_installed = {
						"gofumpt",
						"stylua",
						"prettierd",
						"sql-formatter",
						"shfmt",
						"black",
						"clang-format",
					},
					automatic_installation = false,
					handlers = {},
				})
			end,
		},
		{
			"nvimtools/none-ls.nvim",
			dependencies = {
				"jay-babu/mason-null-ls.nvim",
			},
			config = function()
				local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						null_ls.builtins.formatting.prettierd.with({
							env = {
								PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(
									vim.fn.stdpath("config") .. "/utils/.prettierrc.json"
								),
							},
						}),
						null_ls.builtins.formatting.shfmt.with({
							filetypes = { "sh", "zsh" },
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
