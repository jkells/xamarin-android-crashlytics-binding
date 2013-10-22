using System;
using Android.App;
using Android.Widget;
using Android.OS;

namespace Xamarin.Android.Crashlytics.Sample
{
    [Activity(Label = "Xamarin.Android.Crashlytics.Sample", MainLauncher = true, Icon = "@drawable/icon")]
    public class Activity1 : Activity
    {
        protected override void OnCreate(Bundle bundle)
        {
            base.OnCreate(bundle);
            SetContentView(Resource.Layout.Main);
            var button1 = FindViewById<Button>(Resource.Id.Crash1);
            var button2 = FindViewById<Button>(Resource.Id.Crash2);

            button1.Click += (sender, args) =>
                             {
                                 throw new InvalidOperationException("This is a .NET exception!");
                             };

            // Should crash in Java
            button2.Click += (sender, args) => SetContentView(888888);
        }
    }
}

