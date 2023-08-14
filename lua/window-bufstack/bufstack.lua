local M = {}
local session_windows = {}

local api = vim.api
local INVALID_BUF_ID = -1

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
    if buf > 0 and api.nvim_buf_is_valid(buf) then
      return buf
    end
  end
end

--- Delete buf from stack
---@param bufnr number
---@param winid? number
function M.delete_buf(bufnr, winid)
  if not winid then
    winid = api.nvim_get_current_win()
  end
  local stack = session_windows[winid] or {}
  for i, v in ipairs(stack) do
    if v == bufnr then
      table.remove(stack, i)
      break;
    end
  end
end

--- Ignore next income buffer, because it maybe being loaded into this window
--- automatically and unwanted.
--- For example, you can call this method before you run `:bdelete`, so the next
--- auto loaded buffer can be ignored when we run pop.
---@param winid? number
function M.ignore_next(winid)
  M.push(INVALID_BUF_ID, winid)
end

--- Peek next buf on the stack.
---@param winid? number
function M.peek_bufstack(winid)
  if not winid then
    winid = api.nvim_get_current_win()
  end

  local stack = session_windows[winid]
  if not stack then return end

  return stack[#stack]
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

  M.delete_buf(bufnr, winid)

  local next = stack[#stack]
  if next == INVALID_BUF_ID then
    bufnr = -(bufnr)
    stack[#stack] = bufnr
    return
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
