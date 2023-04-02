using System;
using System.Collections.Generic;
using System.Linq;
using HarmonyLib;
using MelonLoader;
using UnhollowerBaseLib;
using UnityEngine;

using static FairyChickenExtensions;

namespace MOD_LuaEnv.GameHook {

    // ignore order to run
    [HarmonyPatch(typeof(DramaFunction))]
    [HarmonyPatch("OptionsFunction")]
    public class LuaFunctionPatch {
        [HarmonyPrefix]
        public static bool Prefix(DramaFunction __instance, ref string function, ref DramaFunctionData functionData)
        {
            if (string.IsNullOrEmpty(function) || function == "0")
                return true;

            Logger.Debug($"----- raw funcs：{function}");

            var funcs = function.Split('|');
            var newFuncsList = new List<string>();

            for (int i = 0; i < funcs.Length; i++) {
                if (funcs[i].StartsWith("lua_")) {
                    Logger.Debug($"----- exec lua funcs：{funcs[i]}");
                    try {
                        var func_params = funcs[i].Split('_');
                        var ret = ModMain.LuaState.GetFunction("ExecFunc").TryCall(
                            func_params[1], __instance, func_params.Skip(2).Take(func_params.Length - 1).ToArray()
                        );
                    } catch (Exception e) {
                        Logger.Error(e);
                    }
                } else {
                    newFuncsList.Add(funcs[i]);
                }
            }

            if (newFuncsList.Count > 0) {
                function = string.Join("|", newFuncsList);
                Logger.Debug($"----- final funcs：{function}");
                return true;
            } else {
                return false;
            }
        }
    }

    // function AddFeature_lua_a.b.c_arg1_arg2_arg3
    [HarmonyPatch(typeof(DramaFunction))]
    [HarmonyPatch("AddFeature")]
    public class AddFeaturePatch {
        [HarmonyPrefix]
        public static bool Prefix(DramaFunction __instance, Il2CppStringArray values) {
            var rawCommand = string.Join("_", values);
            if (values.Count <= 2) { return true; }
            var command = values[1];
            if (command != "lua") { return true; }
            var fn_name = values[2];
            Logger.Info($"exec lua function：{rawCommand}");

            try {
                ModMain.LuaState.GetFunction("ExecFunc").TryCall(
                    fn_name, __instance, values.Skip(3).Take(values.Length - 3).ToArray()
                );
            } catch (Exception e) {
                Logger.Error(e);
                throw;
            }

            return false;
        }
    }


    // condition lua_a.b.c_arg1_arg2_arg3
    [HarmonyPatch(typeof(UnitCondition))]
    [HarmonyPatch("Condition")]
    public class DramaConditionPatch {
        [HarmonyPrefix]
        public static bool Prefix(UnitCondition __instance, ref bool __result)
        {
            var condition = __instance.condition;
            if (condition == "0" || string.IsNullOrEmpty(condition))
                return true;

            var array = condition.Split('|');
            var newArrayList = new List<string>();
            int startPos = 0;
            bool isOrMode = false;
            if (array[0] == "or")
            {
                startPos = 1;
                isOrMode = true;
            }

            for (int i = startPos; i < array.Length; i++)
            {
                var paramArray = array[i].Split('_');
                var conditionName = paramArray[0];
                if (conditionName == "lua")
                {
                    bool result;
                    bool err = false;
                    try {
                        var ret = ModMain.LuaState.GetFunction("ExecCond").TryCall(
                            paramArray[1], __instance, paramArray.Skip(2).Take(paramArray.Length - 2).ToArray()
                        );
                        result = ret.Length > 0 ? (bool)ret[0] : false;
                    } catch (Exception e) {
                        Logger.Error(e);
                        err = true;
                        result = false;
                    }
                    // Logger.Debug(
                    //     $"自定义条件：{array[i]} 判断结果：{GetBoolDesc(result)}; err: {GetBoolDesc(err)}"
                    // );

                    // or模式，出现true则结束判断
                    if (result && isOrMode) {
                        __result = true;
                        return false;
                    }

                    // and模式，出现false则结束判断
                    if (!result && !isOrMode) {
                        __result = false;
                        return false;
                    }
                } else {
                    newArrayList.Add(array[i]);
                }
            }

            if (newArrayList.Count > 0) {
                if (isOrMode) {
                    newArrayList.Insert(0,"or");
                    __instance.condition = string.Join("|",newArrayList);
                    // Logger.Debug($"    or判断失败，生成新Condition：{__instance.condition}");
                    return true;
                } else {
                    __instance.condition = string.Join("|",newArrayList);
                    // Logger.Debug($"    and判断失败，生成新Condition：{__instance.condition}");
                    return true;
                }
            }

            if (isOrMode) {
                // or模式，全部false判断失败
                __result = false;
                return false;
            } else {
                // and模式，全部true判断成功
                __result = true;
                return false;
            }
        }

        public static string GetBoolDesc(bool get) => get ? "√" : "×";
    }
}