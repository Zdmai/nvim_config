local M = {}

function M:move(direct)
  local table_dir = {
    east  = { td = "-R", vd = "h" },
    west  = { td = "-L", vd = "l" },
    north = { td = "-U", vd = "k" },
    south = { td = "-D", vd = "j" },
  }
  local dir = table_dir[direct]
  if not dir then
    vim.log.info("Invalid direction: " .. tostring(direct))
    return  -- 无效方向，直接返回
  end

  print(dir)

  if vim.env.TMUX ~= nil then
    vim.cmd("silent !tmux select-pane " .. dir.td)
  else
    vim.cmd("wincmd " .. dir.vd)
  end
end

return M
