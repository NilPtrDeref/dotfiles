return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
      set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
      set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
      set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<left>", function() mc.matchAddCursor(-1) end)
      set({ "n", "x" }, "<right>", function() mc.matchAddCursor(1) end)
      set({ "n", "x" }, "<leader><left>", function() mc.matchSkipCursor(-1) end)
      set({ "n", "x" }, "<leader><right>", function() mc.matchSkipCursor(1) end)

      -- In normal/visual mode, press `mwap` will create a cursor in every match of
      -- the word captured by `iw` (or visually selected range) inside the bigger
      -- range specified by `ap`. Useful to replace a word inside a function, e.g. mwif.
      set({ "n", "x" }, "mw", function()
        mc.operator({ motion = "iw", visual = true })
      end)

      -- Press `mWi"ap` will create a cursor in every match of string captured by `i"` inside range `ap`.
      set("n", "mW", mc.operator)

      -- Add all matches in the document
      set({ "n", "x" }, "<leader>A", mc.matchAllAddCursors)

      -- Rotate the main cursor.
      set({ "n", "x" }, "<C-left>", mc.nextCursor)
      set({ "n", "x" }, "<C-right>", mc.prevCursor)

      -- Delete the main cursor.
      set({ "n", "x" }, "<leader>x", mc.deleteCursor)
      set({ "n", "x" }, "<leader><leader>", mc.clearCursors)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)

      -- bring back cursors if you accidentally clear them
      set("n", "<leader>gv", mc.restoreCursors)

      -- Align cursor columns.
      set("n", "<leader>a", mc.alignCursors)

      -- Append/insert for each line of visual selections.
      set("x", "I", mc.insertVisual)
      set("x", "A", mc.appendVisual)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end
  }
}
