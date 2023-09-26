local M = {}
local state = nil
local default_config = {
  --- File types to ignore
  ignore_filetype = {},
}

M.require_init_after_config = false

M.config = setmetatable({}, {
  __index = function(_, key)
    if state == nil then
      return default_config[key]
    end
    return state[key]
  end,
})

function M.setup(options)
  local new_options = vim.tbl_deep_extend("force", default_config, options or {})
  state = new_options
end

function M.is_configured()
  return state ~= nil
end

return M
