using System;
using System.IO;
using System.Text;
using System.Reflection;
using MelonLoader;
using UnityEngine;

namespace MOD_LuaEnv.Helpers {
    public class LuaExportFunc {
        public static void CPrint(params object[] args) {
            if (args == null)
                args = new object[0];

            MelonLogger.Msg(makeString(args));
        }

        private static string makeString(object[] args) {
            if (args.Length == 0 || args[0] == null)
            {
                return string.Empty;
            }

            var sb = new StringBuilder();
            var text = args[0].ToString();

            if (text != null)
                sb.Append(text);

            for (int i = 1; i < args.Length; i++)
            {
                sb.Append("  ");
                if (args[i] != null)
                {
                    if (args[i] is NLua.ProxyType ntype)
                        args[i] = ntype.UnderlyingSystemType;

                    text = args[i].ToString();
                    if (text != null)
                        sb.Append(text);
                }
            }

            return sb.ToString();
        }

        public static string GetTypeName(object obj)
        {
            var type = ReflectionHelpers.GetActualType(obj);

            if (type == null) return null;

            return type.Name;
        }
    }
}
