using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using MOD_LuaEnv.Helpers;

namespace MOD_LuaEnv
{
    public static class ReflectionExtensions
    {
        public static object Il2CppCast(this object obj, Type castTo)
        {
            return ReflectionHelpers.Il2CppCast(obj, castTo);
        }

        public static IEnumerable<Type> TryGetTypes(this Assembly asm)
        {
            try
            {
                return asm.GetTypes();
            }
            catch (ReflectionTypeLoadException e)
            {
                try
                {
                    return asm.GetExportedTypes();
                }
                catch
                {
                    return e.Types.Where(t => t != null);
                }
            }
            catch
            {
                return Enumerable.Empty<Type>();
            }
        }
    }
}
