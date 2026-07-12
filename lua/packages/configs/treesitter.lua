Pack.register({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	module = "nvim-treesitter",
	build = ":TSUpdate",
}):load({
	event = "BufReadPost",
	once = true,
	var = {
		attach = function(buf)
			buf = buf or vim.api.nvim_get_current_buf()
			local ft = vim.bo[buf].filetype
			if ft == "" or vim.bo[buf].buftype ~= "" then
				return
			end

			local lang = vim.treesitter.language.get_lang(ft) or ft
			local no_err, is_added = pcall(vim.treesitter.language.add, lang)
			if not no_err or not is_added then
				vim.notify("🌱 Installing " .. lang .. " parser...", vim.log.levels.INFO)
				require("nvim-treesitter").install({ lang }):wait(60000)
				pcall(vim.treesitter.language.add, lang)
			end

			pcall(vim.treesitter.start, buf, lang)
		end,
		enable = {
			use = true,
			callback = function()
				vim.api.nvim_create_autocmd("FileType", {
					callback = function(ev)
						attach(ev.buf)
					end,
				})
				attach()
			end,
		},
	},
	config = function(plugin)
		plugin.setup({
			install_dir = vim.fn.stdpath("data") .. "/treesitter",
		})
	end,
})
