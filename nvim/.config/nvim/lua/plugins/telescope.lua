return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8", -- or branch = "0.1.x"
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Find buffer" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help tags" },
  },
  opts = {
    defaults = {
       find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
       prompt_prefix = "   ",
       layout_strategy = "flex",
       sorting_strategy = "ascending",
       layout_config = { prompt_position = "top" },
    },
    pickers = {
       find_files = {
	 theme = "dropdown",
       }
    },
    },
}
