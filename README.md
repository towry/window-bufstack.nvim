# WIP: window-bufstack.nvim

[![Integration][integration-badge]][integration-runs]

WIP: Get next visited buf of given window, useful for choose next buf after closing a
buf in a window.

## Using

```lua
local plugin_spec = {
  'towry/window-bufstack.nvim',
  opts = {},
  keys = {
    {
      "<S-q>",
      function()
        local bufstack = require('window-bufstack')
        bufstack.pop()
        local next_buf = bufstack.pop()
        if not next_buf then
          --- quit window and close the buf.
          vim.cmd(':q')
        else
          -- switch to next_buf and close the previous buffer.
        end
      end,
      desc = "Close current buffer in window",
    }
  }
}
```

## Testing

This uses [busted][busted], [luassert][luassert] (both through
[plenary.nvim][plenary]) and [matcher_combinators][matcher_combinators] to
define tests in `test/spec/` directory. These dependencies are required only to
run tests, that's why they are installed as git submodules.

Make sure your shell is in the `./test` directory or, if it is in the root directory,
replace `make` by `make -C ./test` in the commands below.

To init the dependencies run

```bash
$ make prepare
```

To run all tests just execute

```bash
$ make test
```

If you have [entr(1)][entr] installed you may use it to run all tests whenever a
file is changed using:

```bash
$ make watch
```

In both commands you myght specify a single spec to test/watch using:

```bash
$ make test SPEC=spec/my_awesome_plugin/my_cool_module_spec.lua
$ make watch SPEC=spec/my_awesome_plugin/my_cool_module_spec.lua
```

## Github actions

An Action will run all the tests and the linter on every commit on the main
branch and also on Pull Request. Tests will be run using
[stable and nightly][neovim-test-versions] versions of Neovim.

[lua]: https://www.lua.org/
[entr]: https://eradman.com/entrproject/
[luarocks]: https://luarocks.org/
[busted]: https://olivinelabs.com/busted/
[luassert]: https://github.com/Olivine-Labs/luassert
[plenary]: https://github.com/nvim-lua/plenary.nvim
[matcher_combinators]: https://github.com/m00qek/matcher_combinators.lua
[integration-badge]: https://github.com/m00qek/plugin-template.nvim/actions/workflows/integration.yml/badge.svg
[integration-runs]: https://github.com/m00qek/plugin-template.nvim/actions/workflows/integration.yml
[neovim-test-versions]: .github/workflows/integration.yml#L17
[help]: doc/my-awesome-plugin.txt
