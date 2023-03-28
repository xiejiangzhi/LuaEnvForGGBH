local M = {}

-- val: 0, 1, 2, 3
function M.get_df_unit(df, val)
  if val == '0' then
    return g.world.playerUnit
  elseif val == '1' then
    return df.data.unitLeft
  elseif val == '2' then
    return df.data.unitRight
  elseif val == '3' then
    return df.data.unitA
  end
end

-- val: 0, 1, 2, 3
function M.get_dc_unit(dc, val)
  if val == '0' then
    return g.world.playerUnit
  elseif val == '1' then
    return dc.data.unitA
  elseif val == '2' then
    return dc.data.unitB
  elseif val == '3' then
    return dc.data.unitC
  end
end

return M