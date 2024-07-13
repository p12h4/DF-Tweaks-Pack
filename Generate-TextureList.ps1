$JSON = (((Get-ChildItem -Recurse -Include *.png, *.jpg, *.jpeg, *.tga).FullName | ForEach-Object {
   $PSItem -replace '.*?textures\\', 'textures/' `
           -replace '\.[^.]+$',      ''          `
           -replace '\\',            '/'
}) | Sort-Object | ConvertTo-Json -Depth 1).Replace('    ', '  ');


Set-Content -Force -NoNewline -Path '.\textures_list.json' -Value $JSON;