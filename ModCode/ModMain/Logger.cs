using System;
using System.IO;
using MelonLoader;
using UnityEngine;

namespace MOD_LuaEnv
{
    public static class Logger
    {
        public static bool EnableDebugLog = false;

        // for lua export
        public static void PrintWithColor(ConsoleColor color, string obj) {
            MelonLogger.Msg(color, obj);
        }

        public static void Debug(object obj) {
            if (EnableDebugLog) {
                MelonLogger.Msg($"[LuaEnv] {obj}");
            }
        }

        public static void Info(object obj) {
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