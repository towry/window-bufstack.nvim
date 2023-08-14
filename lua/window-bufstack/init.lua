local M = {}

local function init_on_vim_start()
  local bufstack = require('window-bufstack.bufstack')
  local group = vim.api.nvim_create_augroup("window_bufstack_events", { clear = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function(args)
      local win = vim.api.nvim_get_current_win()
      local buf = args.buf
      bufstack.push(buf, win)
    end,
  })
  -- BufUnload vs BufDelete ?
  vim.api.nvim_create_autocmd('BufUnload', {
    group = group,
    callback = function(args)
      local win = vim.api.nvim_get_current_win()
      local buf = args.buf
      bufstack.delete_buf(buf, win)
    end,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    pattern = "*",
    callback = function(info)
      local win = tonumber(info.match)
      if win then
        bufstack.remove_stack(win)
      end
    end
  })

  local winds = vim.api.nvim_list_wins()
  for _, win in ipairs(winds) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
    if buftype == "" then
      bufstack.push(buf, win)
    end
  end
end

function M.setup(opts)
  local config = require('window-bufstack.config')
  if vim.v.vim_did_enter and (not vim.g.loaded_window_bufstack) then
    config.require_init_after_config = true
    vim.g.loaded_window_bufstack = 1
  end
  config.setup(opts)
  if config.require_init_after_config then
    init_on_vim_start()
  end
end

function M.init_on_vim_start()
  if vim.v.vim_did_enter then
    init_on_vim_start()
  else
    vim.api.nvim_create_augroup('win_bufstack_init', { clear = true })
    vim.api.nvim_create_autocmd('VimEnter', {
      group = "win_bufstack_init",
      once = true,
      callback = init_on_vim_start,
    })
  end
end

return M
