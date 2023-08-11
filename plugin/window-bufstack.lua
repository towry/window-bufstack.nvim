if vim.fn.has("nvim-0.9.0") == 0 then
  vim.api.nvim_err_writeln("window-bufstack requires at least nvim-0.9")
  return
end

-- make sure this file is loaded only once
if vim.g.loaded_window_bufstack == 1 then
  return
end
vim.g.loaded_window_bufstack = 1

local config = require('window-bufstack.config')
if not config.is_configured() then
  config.require_init_after_config = true
  return
end

local win_bufstack = require("window-bufstack")
win_bufstack.init_on_vim_start()
