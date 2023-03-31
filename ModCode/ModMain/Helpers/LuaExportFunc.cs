using System;
using System.IO;
using System.Text;
using System.Reflection;
using MelonLoader;
using UnityEngine;

namespace MOD_LuaEnv.Helpers {
    public class LuaExportFunc {


        public static string GetTypeName(object obj)
        {
            var type = ReflectionHelpers.GetActualType(obj);

            if (type == null) return null;

            return type.Name;
        }
    }
}
