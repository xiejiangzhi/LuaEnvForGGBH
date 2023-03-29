LuaEnv
=======

为鬼谷八荒加入 XLua(lua5.4) 环境，让所有 Mod 支持执行 lua 脚本
加入了简单的剧情框架来支持快速添加剧情的条件与函数功能。


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
  -- 具体使用要看 XLua ，我也不太了解
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

### Hot Reload

实现了一个简单的接口 `auto_load` 自动重载加载项目下的脚本，用法同 require, 但会在文件修改后自动重新加载, 这样就可以在游戏中直接修改代码马上生效了。

比如

```lua
AddFunc('xxx', function()
  -- 加载 Scripts 下的 funcs_impl.lua 并调用返回的函数 xxx
  -- 每次 funcs_impl 更新时，都会重新加载最新的
  auto_load('funcs_impl').xxx()
end)
```

可以通过 `enable`, `disable` 来关闭自动重载功能

```lua
auto_load('funcs_impl') --  文件修改自动重新加载
reloader:disable() -- 关闭自动重载
auto_load('funcs_impl') --  文件修改不会重新加载
```

### XLua

lua 环境中可以访问所有 C# 类和方法，通过 `CS.{namespace}.xxx` 来访问

比如访问游戏中常用的 `g` 变量， `CS.g.world.playerUnit` 这些在 lua 里也是直接这样写就可以访问了

对于 C# 的数组，也是直接下标访问，基于0的，比如数组元素访问 `arr[0]`, 数组长度 `arr.Length`
array, list 之类的循环可以使用 `for k, v in luanet.each(arr) do print(k, v) end` 来实现

创建 C# 数组 `luanet.make_array(Int32, { 1, 2, 3 })`, 其它的类型也是直接使用类型名 `String`, `Double` 创建

更多请自行了解 [XLua](https://github.com/Tencent/xLua)

### Other

每个 mod 都会有自己的全局环境, 里面有自己的 mod id, mod dir

```
print(ModId, ModDir)
```

NLua 中可以直接访问所有的 C# 类与接口，所的 GGBH_API 里面的接口都可以直接访问了。

另外可以参考 LuaEnv Example ，以及 接口扩展 项目的代码。


## Console

不会 Unity ，不知道怎么写，自己就使用 UnityExplorer 的 Console，在里面通过下面的代码运行 Lua

```C#
// 这里面直接执行 lua 代码测试
MOD_LuaEnv.ModMain.LuaState.DoString(@"
  log = CS.UnityExplorer.CSConsole.ScriptInteraction.Log(123)
  log('123fdsa')
");
```