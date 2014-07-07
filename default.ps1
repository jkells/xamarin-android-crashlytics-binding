properties { 
  $base_dir = resolve-path .  
  $nuget_bin = "$base_dir\tools\.nuget\nuget.exe"
  $7zip_bin = "$base_dir\tools\7zip\7za.exe"
  $project_dir = "$base_dir\Xamarin.Android.Crashlytics.Binding"  
  $sample_project_dir = "$base_dir\Xamarin.Android.Crashlytics.Sample"  
  $sample_project_file = "$sample_project_dir\Xamarin.Android.Crashlytics.Sample.csproj"
  $project_file = "$project_dir\Xamarin.Android.Crashlytics.Binding.csproj"  
  $jar_dir = "$project_dir\jars"
  $config = "Release"
  $version = "1.1.11"
  $packageVersion = "$version.7"
  $third_party_dir = "$base_dir\ThirdParty"
}

Framework "4.0"

task default -depends Update-Sample

if(Test-Path "default.local.ps1"){
	Include ".\default.local.ps1" -ErrorAction Continue
}

task Compile-MonoException{
    javac "$base_dir\MonoException\xamarin\android\crashlytics\MonoException.java"
    cd "$base_dir\MonoException"
    jar cf "$jar_dir\MonoException.jar" ".\xamarin\android\crashlytics\MonoException.class"
    cd "$base_dir"
}

task Clean {  
  remove-item -force "$base_dir\crashlytics-devtools.zip" -ErrorAction SilentlyContinue
  remove-item -force -recurse "$project_dir\obj" -ErrorAction SilentlyContinue
  remove-item -force -recurse "$project_dir\bin" -ErrorAction SilentlyContinue
  remove-item -force -recurse "$jar_dir\bin" -ErrorAction SilentlyContinue
  remove-item -force -recurse "$jar_dir\res" -ErrorAction SilentlyContinue
  remove-item -force "$jar_dir\*.jar" -ErrorAction SilentlyContinue
  remove-item -Force -Recurse "$base_dir\AntPlugin" -ErrorAction SilentlyContinue
  remove-item -Force -Recurse "$base_dir\META-INF" -ErrorAction SilentlyContinue
}

task Compile -depends Compile-MonoException {
    if(-not (Test-Path "$third_party_dir\crashlytics-devtools.zip")){
        Throw "Please place crashlytics-devtools.zip into ThirdParty"
        return
    }
	
	if(-not (Test-Path "$third_party_dir\crashlytics.jar")){
        Throw "Please place crashlytics.jar into ThirdParty"
        return
    }
	
	exec{
        & "$7zip_bin" x -y -o"$base_dir\AntPlugin" "$third_party_dir\crashlytics-devtools.zip"
    }
    Copy-Item "$base_dir\AntPlugin\crashlytics-devtools.jar" "$jar_dir"   
	Copy-Item "$third_party_dir\crashlytics.jar" "$jar_dir"   
	
    msbuild "$project_file" /p:"Configuration=$config"
}

task Package -depends Compile{
    exec{
        & $nuget_bin pack "$base_dir\Package.nuspec"
    }
}

task Update-Sample -depends Package{
    exec{
        & $nuget_bin install Xamarin.Android.Crashlytics.Binding -SolutionDirectory $sample_project_dir -Source $base_dir
    }

    # Update nuget package with the version number
    [sting]$file = (gi $sample_project_file).FullName
    [xml]$doc = gc "$file"
    $doc.Project.Import[1].Project = "packages\Xamarin.Android.Crashlytics.Binding.$packageVersion\build\Xamarin.Android.Crashlytics.Binding.targets"
    $doc.Save("$file")
}

task Update-Version{
    # Update project file with the version number
    $fileName = "$project_dir\Properties\AssemblyInfo.cs"
    $content = gc "$fileName"
    Out-File -Encoding utf8 "$fileName"
    foreach($line in $content){
        if($line -match "assembly: AssemblyVersion"){
            $line = "[assembly: AssemblyVersion(`"$packageVersion`")]"
        }

        if($line -match "assembly: AssemblyFileVersion"){
            $line = "[assembly: AssemblyFileVersion(`"$packageVersion`")]"
        }

        $line | Out-File -Encoding utf8 -Append "$fileName"    
    }

    # Update nuget package with the version number
    [string]$package = (gi "$base_dir\Package.nuspec").FullName
    [xml]$doc = gc "$package"
    $doc.package.metadata.version = $packageVersion
    $doc.Save("$package")
	
	# Update targets file with the version number
	[string]$targets = (gi "$base_dir\Xamarin.Android.Crashlytics.Binding.targets").FullName
	[xml]$doc = gc "$targets"
    $doc.Project.PropertyGroup[0].CrashlyticsVersion = $packageVersion
    $doc.Save("$targets")
}

