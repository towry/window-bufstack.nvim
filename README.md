# [window-bufstack.nvim](https://github.com/towry/window-bufstack.nvim)

Get next visited buf of given window, useful for choosing next buffer after closing a
buffer in a window.

Note:

1. This plugin doesn't handle buffer management like delete or restore, it just
   record what buffer has been opened in a window.
2. In my expectation, when I run `:vsplit` a window, and use `bdelete` to close
   the buffer in that window, the window should be closed because it only have
   one buffer visited it. This plugin helps to achive this workflow.
3. When you have two same buffer opened in two window and you use `bdelete` to
   close one of theme, you find both windows are closed, this is the behavior of
   `bdelete`, you may want to use vim api to check if the buffer opened in
   another window so you can use other command other than `bdelete` to remove
   the buffer from the window.

## Using

```lua
local plugin_spec = {
  'towry/window-bufstack.nvim',
  # currently no opts, buf setup call is needed.
  # so you can also use config = true if you use lazy.nvim.
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
