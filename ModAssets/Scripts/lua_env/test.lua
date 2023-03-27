-- df: DramaFunction
AddFunc('test-func', function(name, df, args)
  print('Inside lua test func', name, df, args)
  print('left', df.data.unitLeft)
  print('right', df.data.unitRight)
  print('UnitA', df.data.unitA)
  print('g', g, g.world.playerUnit)
  for i = 0, args.Length - 1 do
    print(i, args[i])
  end
end)

-- cond DramaCondition
AddCond('test-cond', function(name, dc, args)
  print('Inside lua test cond', name, dc, args)
  print('unitA', dc.data.unitA)
  print('unitB', dc.data.unitB)
  print('unitC', dc.data.unitC)
  print('args len', args.Length)
  for i = 0, args.Length - 1 do
    print(i, args[i])
  end
  -- must return a bool value for condition
  return true
end)
