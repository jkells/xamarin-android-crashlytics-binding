properties {
  $base_dir = resolve-path .
  $nuget_bin = "$base_dir\tools\.nuget\nuget.exe"
  $7zip_bin = "$base_dir\tools\7zip\7za.exe"
}

Framework "4.0"

task default -depends Clean, Download, Package

task Clean {
  remove-item -force "$base_dir\crashlytics-devtools.zip" -ErrorAction SilentlyContinue
  remove-item -Force -Recurse "$base_dir\AntPlugin" -ErrorAction SilentlyContinue
}

task Download {
  iwr https://fabric.io/download/ant -OutFile "$base_dir\crashlytics-devtools.zip"
	exec{
        & "$7zip_bin" x -y -o"$base_dir\AntPlugin" "$base_dir\crashlytics-devtools.zip"
    }
}

task Package {
    exec{
        & $nuget_bin pack "$base_dir\Package.nuspec"
    }
}

