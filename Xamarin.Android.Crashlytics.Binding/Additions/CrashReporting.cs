using System;
using Android.Content;
using Android.Runtime;
using Java.Lang;

using JavaException = Java.Lang.Exception;
// ReSharper disable once CheckNamespace
namespace Xamarin.Android.Crashlytics.Binding.Additions
{
    public class CrashReporting
    {
        private static void AndroidEnvironmentOnUnhandledExceptionRaiser(RaiseThrowableEventArgs eventArgs, bool callJavaDefaultUncaughtExceptionHandler)
        {
            JavaException exception = MonoException.Create(eventArgs.Exception);

            if (callJavaDefaultUncaughtExceptionHandler && Thread.DefaultUncaughtExceptionHandler != null)
                Thread.DefaultUncaughtExceptionHandler.UncaughtException(Thread.CurrentThread(), exception);
            else
                Com.Crashlytics.Android.Crashlytics.LogException(exception);
        }
        
        public static void StartWithMonoHook(Context context, bool callJavaDefaultUncaughtExceptionHandler)
        {
            if(context == null)
                throw new ArgumentNullException("context");

            Com.Crashlytics.Android.Crashlytics.Start(context);
            AndroidEnvironment.UnhandledExceptionRaiser += (sender, args) => { AndroidEnvironmentOnUnhandledExceptionRaiser(args, callJavaDefaultUncaughtExceptionHandler); };
        }
    }
}
