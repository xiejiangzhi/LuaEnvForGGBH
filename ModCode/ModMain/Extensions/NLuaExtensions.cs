using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MelonLoader;
using NLua;

namespace MOD_LuaEnv
{
    public static class NLuaExtensions
    {
        public static object[] TryCall(this LuaFunction function, params object[] args)
        {
            try {
                return function.Call(args);
            } catch (Exception e) {
                Logger.Error(e);
            }

            return null;
        }
    }
}
