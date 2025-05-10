return {
	{
		"echasnovski/mini.diff",
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
	{ "echasnovski/mini-git", version = false, main = "mini.git", opts = {} },
}
