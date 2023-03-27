using System;
using System.IO;
using MelonLoader;
using UnityEngine;

namespace MOD_LuaEnv
{
    public static class Logger
    {
        public static bool EnableDebugLog = false;

        public static void SetEnableDebugLog(bool enable) {
            EnableDebugLog = enable;
        }

        public static void Debug(object obj) {
            if (EnableDebugLog) {
                MelonLogger.Msg($"[LuaEnv] {obj}");
            }
        }

        public static void Msg(object obj) {
            MelonLogger.Msg($"[LuaEnv] {obj}");
        }

        public static void Warning(object obj) {
            MelonLogger.Msg(ConsoleColor.Yellow, $"[LuaEnv] {obj}");
        }

        public static void Error(object obj) {
            MelonLogger.Msg(ConsoleColor.Red, $"[LuaEnv] {obj}");
        }
    }
}