vim.cmd.packadd("Automic.pkg")

Pack.boot("packages.configs"):custom({
	"core.options",
	"core.keymaps",
	"core.commands",
	"core.lsp",
})
