Add-Type -AssemblyName System.IO.Compression.FileSystem
$cd = $PSScriptRoot

function CompressJSONs($Paths) {
   $results = ""
   ForEach ($Path in $Paths) {
      if ([bool](Test-Path -Path "$Path") -eq $True) {
         $results = (Get-ChildItem -ErrorAction Continue -Recurse -Path "$Path" -Filter *.json).FullName
         Foreach ($result in $results) {
            (Get-Content -ErrorAction Continue -Force -Path "$result") -join ' ' | % {$_.replace(" ","")} | % {$_.replace("`t","")} | % {$_.replace("`n","")} | Set-Content -ErrorAction Continue -Force -Path "$result"
         }
      }
   }
}

function BuildPack($Folders) {
   if ([bool](Test-Path -Path "$cd\temp") -eq $False) {
      mkdir -Force "$cd\temp" | Out-Null
   }
   ForEach ($Folder in $Folders) {
      Write-Host "Adding Folder: `"$Folder`" to `"$cd\Discontinued.Feature.Tweaks.$Folder.mcpack`""
      Copy-Item -Recurse -Force -Path "$Folder" -Destination "$cd\temp"
      CompressJSONs "$cd\temp\$Folder\attachables", "$cd\temp\$Folder\entity", "$cd\temp\$Folder\items", "$cd\temp\$Folder\models\entity", "$cd\temp\$Folder\render_controllers"
      if ([bool](Test-Path -Path "$cd\Discontinued.Feature.Tweaks.$Folder.mcpack") -eq $True) {
         Remove-Item -Force -Path "$cd\Discontinued.Feature.Tweaks.$Folder.mcpack"
      }
      [System.IO.Compression.ZipFile]::CreateFromDirectory("$cd\temp\$Folder", "$cd\temp\Discontinued.Feature.Tweaks.$Folder.zip")
      Rename-Item -ErrorAction Continue -Force "$cd\temp\Discontinued.Feature.Tweaks.$Folder.zip" "$cd\temp\Discontinued.Feature.Tweaks.$Folder.mcpack"
   }
   Move-Item -Path "$cd\temp\*.mcpack" -Destination "$cd"
   Remove-Item -Recurse -Force -Path "$cd\temp"
}

BuildPack "1.16.40", "1.18.10"
