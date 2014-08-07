# Xamarin.Android.Crashlytics.Binding #

## About ##

This project provides bindings for the Crashlytics library. You need to set your API key in your AndroidManifest.xml as per the Crashlytics eclipse plugin. 

---

## LICENSE ##

This project is released under the MIT license.

**The license only covers the bindings in this project.**
Your usage of the Crashlytics SDK will be bound by your agreement with Crashlytics. Their terms can be found here: http://try.crashlytics.com/terms/

---

## Getting Started ##
* **Place crashlytics.jar and crashlytics-devtools.jar into the ThirdParty directory**
* **Make sure the javac.exe in your path is the same version used by Xamarin Android. Currently 1.6**
* **Build the project by running psake.cmd**
* **Install the nuget package into your project**

You can add the directory containing the nupkg file to your sources in Visual Studio under *Tools -> Options -> Package Manager -> Sources* and then install the package using the Visual Studio GUI
Adding the package from the command line is not recommended because the targets file won't be added to your csproj file.

* **Add your Crashlytics API Key**

Add the Crashlytics API key to your AndroidManifest.xml. The easiest way is to use the Crashlytics plugin in either Eclipse or IntelliJ to configure a project and then copy the lines out of the manifest file.

*It's important that the package name matches the package name you use to set up the application with crashlytics exactly*

* **Start crashlytics by adding the following to your application start up:**

`using Xamarin.Android.Crashlytics.Binding.Additions;`

`CrashReporting.StartWithMonoHook(this, true);`

* **Add Resources\Values\com_crashlytics_export_strings.xml to your project.**

It is generated automatically during the build


---

## Running the Sample ##

* Build the binding project by running psake.cmd
* Update the AndroidManifest.xml file in the sample project with your API key and package name.

## Links ##

* [https://www.crashlytics.com/](https://www.crashlytics.com/)
