---@param target string|table When using a table the function will iterate
--- over each of the targets until the path is found. Meaning if the first
--- element of the table is found in a parent path the remaining elements
--- won't be used for the search.
local find_closest_parent_path

find_closest_parent_path = function(target)
  local path = vim.fn.expand '%:p:h' -- Get the directory of the current file
  local uv = vim.loop -- Neovim's built-in libuv bindings

  if type(target) ~= 'table' and type(target) ~= 'string' then
    return nil
  end

  -- If target is a table search for each of the table values in turn
  if type(target) == 'table' then
    for key, value in pairs(target) do
      print(value)
      local found_path = find_closest_parent_path(value)
      if found_path ~= nil then
        return found_path
      end
    end
    return nil -- INFO: No paht found -> exit early
  end

  -- INFO: If we get here the target should be a string
  while path do
    local file_path = path .. '/' .. target
    local stat = uv.fs_stat(file_path)

    if stat then
      return path -- Found it!
    end

    -- Move up one directory
    local parent = vim.fn.fnamemodify(path, ':h')
    if parent == path then
      break -- Reached root
    end
    path = parent
  end

  return nil -- Not found
end

return {
  find_closest_parent_path = find_closest_parent_path,
}
