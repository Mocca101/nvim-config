return {
  find_closest_parent_path = function(file)
    local path = vim.fn.expand '%:p:h' -- Get the directory of the current file
    local uv = vim.loop -- Neovim's built-in libuv bindings

    while path do
      local file_path = path .. file
      local stat = uv.fs_stat(file_path)

      if stat and stat.type == 'file' then
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
  end,
}
