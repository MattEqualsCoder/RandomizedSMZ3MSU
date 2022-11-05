$map = @{}

$randomizedMsuFolder = "RandomizedSMZ3MSU"
$randomizedMsuName = "randomized-smz3"

Write-Host "Available MSUs:"

foreach ($folder in Get-ChildItem -Path .) {
    if (-not $folder.PSIsContainer) { continue; }
    if ($folder.BaseName -eq $randomizedMsuFolder) { continue; }
    foreach ($msuFile in Get-ChildItem -Path $folder.FullName -Filter *.msu) {

        $numFiles = (Get-ChildItem -Path $folder.FullName -Filter "$($msuFile.BaseName)-*.pcm").Length
        if ($numFiles -lt 63 -or $numFiles -gt 120) { continue; }

        Write-Host "  $($msuFile.BaseName)\$($msuFile.BaseName) ($numFiles songs)"

        foreach ($pcmFile in Get-ChildItem -Path $folder.FullName -Filter "$($msuFile.BaseName)*.pcm") {
            $number = ($pcmFile.BaseName -replace $msuFile.BaseName, "").Substring(1)

            if($number -match "^\d+$") {
                if (-not $map.ContainsKey($number)) {
                    $map.Add($number, @());
                }
                $map[$number] += $pcmFile.FullName
            }
        }
    }
}

$continue = Read-Host "Continue? (y/n)"

if ($continue.ToLower() -ne "y") { exit; }

if (!(Test-Path $randomizedMsuFolder -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $randomizedMsuFolder
}
Remove-Item $randomizedMsuFolder\* -Recurse -Force
New-Item -Name $randomizedMsuFolder\randomized-smz3.msu -ItemType File

foreach ($key in $map.Keys) {
    New-Item -ItemType HardLink -Name "$randomizedMsuFolder\$randomizedMsuName-$key.pcm" -Value ($map[$key] | Get-Random)
}
