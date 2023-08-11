local M = {}
local session_windows = {}

local api = vim.api

--- Get next buffer on the window.
---@param winid? number
function M.pop(winid)
  if not winid then
    winid = api.nvim_get_current_win()
  end
  local stack = session_windows[winid] or {}

  while true do
    local buf = table.remove(stack)
    if not buf then
      return
    end
    if api.nvim_buf_is_valid(buf) then
      return buf
    end
  end
end

--- Push a buffer onto the window
---@param bufnr number
---@param winid? number
function M.push(bufnr, winid)
  if not winid then
    winid = api.nvim_get_current_win()
  end
  if not session_windows[winid] then
    session_windows[winid] = {}
  end
  if not bufnr then
    bufnr = api.nvim_get_current_buf()
  end
  local stack = session_windows[winid]
  for i, v in ipairs(stack) do
    if v == bufnr then
      table.remove(stack, i)
    end
  end
  table.insert(stack, bufnr)
end

---@param winid number
function M.remove_stack(winid)
  if not winid then return end
  if not session_windows[winid] then return end
  session_windows[winid] = nil
end

---@param winid number
function M.debug(winid)
  if winid then
    vim.print(session_windows[winid])
    return
  end
  vim.print(session_windows)
end

return M
