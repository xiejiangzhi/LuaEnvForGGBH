using System;
using System.IO;
using System.Text;
using System.Reflection;
using System.Runtime.InteropServices;
using HarmonyLib;
using MelonLoader;
using UnhollowerBaseLib;
using UnityEngine;
using XLua;

using Logger = MOD_LuaEnv.Logger;
using MOD_LuaEnv.GameHook;


/// <summary>
/// 当你手动修改了此命名空间，需要去模组编辑器修改对应的新命名空间，程序集也需要修改命名空间，否则DLL将加载失败！！！
/// </summary>
namespace MOD_LuaEnv
{


    /// <summary>
    /// 此类是模组的主类
    /// </summary>
    public class ModMain {
        [DllImport("kernel32.dll", CharSet=CharSet.Auto)]
        private static extern void SetDllDirectory(string lpPathName);


        public static LuaEnv LuaState;

        public static string ModID = "WjCh9C";
        public static Lazy<string> ModHomePath { get; } =
            new Lazy<string>(() => g.mod.GetModPathRoot(ModID));
        public static Lazy<string> DefaultScriptDir { get; } =
            new Lazy<string>(() => Path.Combine(ModHomePath.Value, "ModAssets", "Scripts"));
        public static Lazy<string> InitLuaEnvPath { get; } =
            new Lazy<string>(() => Path.Combine(DefaultScriptDir.Value, "lua_env.lua"));

        private static HarmonyLib.Harmony harmony;

        /// <summary>
        /// MOD初始化，进入游戏时会调用此函数
        /// </summary>
        public void Init()
        {
            var dll_dir = Path.Combine(ModHomePath.Value, "ModAssets");
            SetDllDirectory(dll_dir);
            InitLuaEnv();
            LoadAllModScripts();

            //使用了Harmony补丁功能的，需要手动启用补丁。
            //启动当前程序集的所有补丁
            if (harmony != null)
            {
              harmony.UnpatchSelf();
              harmony = null;
            }
            if (harmony == null)
            {
              harmony = new HarmonyLib.Harmony("MOD_LuaEnv");
            }
            harmony.PatchAll(Assembly.GetExecutingAssembly());
        }

        /// <summary>
        /// MOD销毁，回到主界面，会调用此函数并重新初始化MOD
        /// </summary>
        public void Destroy()
        {
            LuaState = null;
        }

        private void InitLuaEnv() {
            LuaState = new LuaEnv();
            // var res = LuaState.DoString("return 10 + 3*(5 + 2)")[0];
            // Logger.Msg($"---------test lua DoString result {res}");

            Logger.Msg("Init lua env...");

            var dir = DefaultScriptDir.Value.Replace("\\", "/");
            var pkg_path_code = $"package.path = '{dir}'..'/?.lua;'..'{dir}'..'/?/init.lua;'..package.path";
            LuaState.Global.Set("LuaEnvModID", ModID);
            LuaState.Global.Set("LuaEnvModDir", dir);
            LuaState.DoString(pkg_path_code);
            LuaState.DoString(@"dofile(LuaEnvModDir..'/lua_env.lua')");
        }

        private void LoadAllModScripts() {
            LuaFunction load_mod_fn = LuaState.Global.Get<LuaFunction>("LoadMod");
            foreach (DataStruct<string, string> info in g.mod.allModPaths) {
                if (g.mod.IsLoadMod(info.t1)) {
                    var script_dir = Path.Combine(info.t2, "ModAssets", "Scripts");
                    var main_path = Path.Combine(script_dir, $"main.lua");
                    if (File.Exists(main_path)) {
                        MelonLogger.Msg($"Load mod script {main_path}");
                        load_mod_fn.TryCall(info.t1, script_dir, main_path);
                    }
                }
            }
        }

    }


}
