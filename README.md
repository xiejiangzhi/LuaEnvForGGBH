LuaEnv
=======

加入 NLua 到 Mod 环境加，支持从剧情功能以及剧情条件处调用。


## Usage

先订阅 LuaEnv mod. 然后你的 mod 就可以使用 lua 功能了。

### Add main.lua

首先在你自己的 mod 项目的 ModAssets 中创建一个 Scripts 目录，然后加入一个 `main.lua` 到 Scripts 文件中。

LuaEnv 会自动查找所有已加载的 mod，并检查是否有 `main.lua`， 如果有就会自动加载。
每个 `main.lua` 执行 require 时都会优先从自己的 Scripts 目录下查找。


### AddFunc

增加剧情函数

```lua
-- fn_name 可以是任意字符，但不要有 `_`， 因为调用时是以 `_` 分隔的
-- 最好的你的 `{ModName}.{FuncName}`
-- 比如你的 mod 叫 BestMod, 那就可以用 `BestMod.Xxx` 前缀去定义名字，这样可以避免和别人的 mod 冲突
local fn_name = 'MyMod.MyFunc'
AddFunc(fn_name, function(name, df, args)
  -- name 等于 fn_name
  -- df: DrameFunction 剧情数据，可以取到剧情角色啥的，具体可以看官方代码文档

  -- 这里简单演示打印一些数据到控制台
  print('Inside lua test func', name, df, args)
  print('left', df.data.unitLeft)
  print('right', df.data.unitRight)
  print('UnitA', df.data.unitA)

  -- g 是 C# 里面定义的，这里可以直接取到，基本上 C# 里面的大多都可以直接在 lua 里调用和实现了
  -- 具体使用要看 NLua ，我也不太了解
  print('g', g, g.world.playerUnit)

  -- args 里面就是调用的所有参数, 所有参数都是字符串
  -- 比如 addFeature_lua_MyMod.MyFunc_123_asdf_321， 这里 args 就有3个， 分别是 123， asdf, 321
  for i = 0, args.Length - 1 do
    print(i, args[i])
  end
end)
```

通过 json 中的 function 调用 `addFeature_lua_MyMod.MyFunc_arg1_arg2`


### AddCond

增加条件函数

```lua
-- cond_name 可以是任意字符，但不要有 `_`， 因为调用时是以 `_` 分隔的
-- 最好的你的 `{ModName}.{CondName}`
local cond_name = 'MyMod.MyCond'
AddFunc(cond_name, function(name, dc, args)
  -- name 等于 cond_name
  -- dc: DrameCondition 条件数据，可以取到条件角色啥的，具体可以看官方代码文档

  -- 这里简单演示打印一些数据到控制台
  print('Inside lua test cond', name, dc, args)
  print('unitA', dc.data.unitA)
  print('unitB', dc.data.unitB)
  print('unitC', dc.data.unitC)
  print('args len', args.Length)

  -- 条件参数, 所有都是字符串 数字需要 tonumber(args[i]) 转换
  for i = 0, args.Length - 1 do
    print(i, args[i])
  end
  -- 必须返回一个 bool 值来决定这个条件是否通过， true 通过， false 失败
  return true
end)
```

通过 json 中的 condition 调用 `lua_MyMod.MyFunc_arg1_arg2`

### Other

其它输出的函数

```lua
print_debug(string)
print_warn(string)
print_error(string)

typeof(obj)
ctype(obj)
set_enable_debug_log(true) -- 如果为 false , print_debug 就不会输出了
```

另外可以考虑 LuaEnv Example 示例效果