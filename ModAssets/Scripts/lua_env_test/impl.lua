local M = {}

-- df: DramaFunction
function M.test_func(name, df, args)
  Logger.info('Inside lua test func', name, df, args)
  Logger.info('left', df.data.unitLeft)
  Logger.info('right', df.data.unitRight)
  Logger.info('UnitA', df.data.unitA)
  Logger.info('g', g, g.world.playerUnit)
  for i = 0, args.Length - 1 do
    Logger.info(i, args[i])
  end
end

-- cond DramaCondition
function M.test_cond(name, dc, args)
  Logger.info('Inside lua test cond', name, dc, args)
  Logger.info('unitA', dc.data.unitA)
  Logger.info('unitB', dc.data.unitB)
  Logger.info('unitC', dc.data.unitC)
  Logger.info('args len', args.Length)
  for i = 0, args.Length - 1 do
    Logger.info(i, args[i])
  end
  -- must return a bool value for condition
  return true
end

return M