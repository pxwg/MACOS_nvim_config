return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      commands = {
        -- Override delete to use trash instead of rm
        delete = function(state)
          local inputs = require("neo-tree.ui.inputs")
          local path = state.tree:get_node().path
          local msg = "Are you sure you want to delete " .. path
          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            vim.fn.system({
              "trash",
              vim.fn.fnameescape(path),
            })
            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end,
      },
    },
  },
}
