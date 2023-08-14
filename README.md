# [window-bufstack.nvim](https://github.com/towry/window-bufstack.nvim)

Get next visited buf of given window, useful for choosing next buffer after closing a
buffer in a window.

Note:

1. This plugin doesn't handle buffer management tasks like deletion or restoration; it simply records which buffers have been opened in a window.
2. In my expectation, when I run :vsplit on a window and use bdelete to close the buffer in that window, the window should be closed because it only has one buffer visited. This plugin helps achieve this workflow.
3. When you have the same buffer opened in two windows and you use bdelete to close one of them, you'll find that both windows are closed. This is the behavior of bdelete. You may want to use the Vim API to check if the buffer is opened in another window, so you can use a different command other than bdelete to remove the buffer from the window.

## Using

```lua
local plugin_spec = {
  'towry/window-bufstack.nvim',
  -- currently no opts, buf setup call is needed.
  -- so you can also use config = true if you use lazy.nvim.
  opts = {},
  keys = {
    {
      "<S-q>",
      function()
          local bufstack = require('window-bufstack.bufstack')
          -- ignore next auto load buf because of `bdelete`.
          bufstack.ignore_next()
          vim.cmd('bdelete')

          -- vim.print(bufstack.debug())
          local next_buf = bufstack.pop()
          if not next_buf then
            -- no other buffers visited this window, you can close this window
            -- or do what you want.
            vim.cmd('q')
          else
            -- set next visited buf on this window.
            vim.api.nvim_win_set_buf(0, next_buf)
          end
      end,
      desc = "Close current buffer in window",
    }
  }
}
```

## TODO

- [ ] mark window as pinned?

## Mabye similar

- https://github.com/wilfreddenton/history.nvim
