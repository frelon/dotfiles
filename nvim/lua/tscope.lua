require("telescope").setup({
	pickers = {
		find_files = {
			hidden = false

		},
	},
    defaults = { 
      file_ignore_patterns = { 
        "node_modules" 
      }
    }
})
