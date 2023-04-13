Add-Type -AssemblyName System.IO.Compression.FileSystem
$cd = $PSScriptRoot

function CompressJSONs($Paths) {
   $results = ""
   ForEach ($Path in $Paths) {
      if (Test-Path "$Path") {
         $results = (Get-ChildItem -ErrorAction Continue -Recurse -Path "$Path" -Filter *.json).FullName
         Foreach ($result in $results) {
            (Get-Content -ErrorAction Continue -Force -Path "$result") -join ' ' | % {$_.replace(" ","")} | % {$_.replace("`t","")} | % {$_.replace("`n","")} | Set-Content -ErrorAction Continue -Force -Path "$result"
         }
      }
   }
}

function BuildPack($Folders) {
   ForEach ($Folder in $Folders) {
      CompressJSONs "$Folder\attachables", "$Folder\entity", "$Folder\items", "$Folder\models\entity", "$Folder\render_controllers"
      [System.IO.Compression.ZipFile]::CreateFromDirectory("$cd\$Folder", "$cd\Discontinued.Feature.Tweaks.$Folder.zip")
      Rename-Item -ErrorAction Continue -Force "$cd\Discontinued.Feature.Tweaks.$Folder.zip" "$cd\Discontinued.Feature.Tweaks.$Folder.mcpack"
   }
}

BuildPack "1.16.40", "1.18.10"