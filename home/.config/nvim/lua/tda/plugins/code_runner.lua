require("code_runner").setup({
	filetype = {
		javascript = "node",
		typescript = "deno run",
		rust = "cargo run",
		c = {
			"cd $dir &&",
			"gcc $fileName -o /tmp/$fileNameWithoutExt &&",
			"/tmp/$fileNameWithoutExt",
		},
		cpp = {
			"cd $dir &&",
			"g++ $fileName -o /tmp/$fileNameWithoutExt &&",
			"/tmp/$fileNameWithoutExt",
		},
		python = "python3 -u",
		java = {
			"cd $dir &&",
			"javac $fileName &&",
			"java $fileNameWithoutExt",
		},
	},
})
