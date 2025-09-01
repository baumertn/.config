return {
	{
		"nvim-mini/mini.diff",
		version = false,
		opts = {
			view = {
				style = "sign",
				signs = {
					add = "+",
					change = "~",
					delete = "_",
					topdelete = "‾",
					changedelete = "~",
					untracked = "?",
				},
			},
		},
	},
	{ "nvim-mini/mini-git", version = false, main = "mini.git", opts = {} },
}
