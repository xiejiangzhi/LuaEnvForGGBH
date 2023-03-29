local M = {}
local MT = {}
MT.__index = MT

local ST = CS.System.DateTime(1970, 1, 1)

function M.new(dir, env)
  return setmetatable({
    mod_dir = dir,
    enable_reload = true,
    loaded = {},
    loaded_ts = {},
    env = env
  }, MT)
end

function MT:enable()
  self.enable_reload = true
end

function MT:disable()
  self.enable_reload = false
end

function MT:load(module)
  local m = self.loaded[module]
  if m ~= nil and not self.enable_reload then
    return m
  end

  local fpath = self.mod_dir..'/'..module:gsub('%.', '/')..'.lua'
  fpath = fpath:gsub('/', '\\')
  local file_wt = CS.System.IO.FileInfo(fpath).LastWriteTime
  local ts = (file_wt - ST).TotalSeconds
  if ts == self.loaded_ts[module] then
    return m
  end

  Logger.info('load script '..fpath..' ts: '..ts)
  local fn = loadfile(fpath, 'bt', self.env)
  if fn then
    m = fn()
  else
    m = nil
  end
  self.loaded[module] = m or false
  self.loaded_ts[module] = ts
  return m
end

return M
