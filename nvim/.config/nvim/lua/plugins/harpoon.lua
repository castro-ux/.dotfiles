return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    -- Basic Telescope integration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    -------------------------------------------------------------------------
    -- 🔑 Keymaps (MUST be inside the config function)
    -------------------------------------------------------------------------

    -- Open Harpoon list with Telescope
    vim.keymap.set("n", "<C-e>", function()
      toggle_telescope(harpoon:list())
    end, { desc = "Open Harpoon window" })

    -- Add current file
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Add file to Harpoon list" })

    -- Remove current file
    vim.keymap.set("n", "<leader>r", function()
      harpoon:list():remove()
    end, { desc = "Remove file from Harpoon list" })

    -- Jump directly to files 1–4
    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Go to Harpoon 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Go to Harpoon 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Go to Harpoon 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Go to Harpoon 4" })

    -- Optional: toggle Harpoon quick menu
    vim.keymap.set("n", "<leader>m", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Toggle Harpoon quick menu" })
  end,
}
