# Xamarin.Android.Crashlytics.Binding #

## About ##

This project provides bindings for the Crashlytics library. You need to set your API key in your AndroidManifest.xml as per the Crashlytics eclipse plugin. 

---

## Getting Started ##

* **Build the project by running psake.cmd**
* **Install the nuget package into your project**

Either from the command line run:
`nuget.exe install -Source <PackageDirectory> Xamarin.Android.Crashlytics.Binding`

Or alternativly you can add the directory containing the nupkg file to your sources in Visual Studio under *Tools -> Options -> Package Manager -> Sources* and then install the package using the Visual Studio GUI

* **Add the crashlytics targets to your project file**

Place the following line:

`<Import Project="packages\Xamarin.Android.Crashlytics.Binding.1.1.1.1\support\crashlytics.targets" />`

Immediately after this line

`<Import Project="$(MSBuildExtensionsPath)\Xamarin\Android\Xamarin.Android.CSharp.targets" />`

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

## Updating this binding to use the latest version of the library.

* Run psake Latest-Version to find out the latest version number.
* Update default.ps1, set $version to the latest version.
* Run psake Update-Version
* Run psake clean to delete the local copies of crashlytics*.jar
* Run psake
* Fix any mapping errors due to obfuscated class names changing

## Links ##

* [https://www.crashlytics.com/](https://www.crashlytics.com/)