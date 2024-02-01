function SetColorscheme(colorscheme) 
    local colorscheme = colorscheme or vim.g.colorscheme
    vim.cmd.colorscheme(colorscheme)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetColorscheme()
