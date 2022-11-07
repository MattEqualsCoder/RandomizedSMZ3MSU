$map = @{}
$global:randomizedMsuFolder = "RandomizedSMZ3MSU"
$global:randomizedMsuName = "randomized-smz3"

function AddPCMFile {

    [CmdletBinding()]
    Param
    (
        $map,
        $number,
        $file
    )

    if (-not $map.ContainsKey($number)) {
        $map.Add($number, @());
    }
    $map[$number] += $file
}

function CopyPCMEntry {

    [CmdletBinding()]
    Param
    (
        $map,
        $newNumber,
        $oldNumber,
        $msuFiles
    )

    if (-not $msuFiles.ContainsKey($oldNumber)) {
        return;
    }

    AddPCMFile $map $newNumber $msuFiles[$oldNumber]
}

function CreatePCMLink {

    [CmdletBinding()]
    Param
    (
        $pcmNumber,
        $originalPCMFile
    )

    $randomizedMsuFolder = $global:randomizedMsuFolder
    $randomizedMsuName = $global:randomizedMsuName

    Write-Host $originalPCMFile " => " "$randomizedMsuFolder\$randomizedMsuName-$pcmNumber.pcm"
    New-Item -ItemType HardLink -Name "$randomizedMsuFolder\$randomizedMsuName-$pcmNumber.pcm" -Value $originalPCMFile | Out-Null
}

$includeExtra = Read-Host "Copy unused tracks as possible candidates for used tracks? For example, the GT climb music is can be included as an option for GT. (y/n)"

Write-Host "Available MSUs:"

# Loop through all folders in the current directory
foreach ($folder in Get-ChildItem -Path .) {
    if (-not $folder.PSIsContainer) { continue; }
    if ($folder.BaseName -eq $randomizedMsuFolder) { continue; }

    # Loop through all MSU files in the current directory
    foreach ($msuFile in Get-ChildItem -Path $folder.FullName -Filter *.msu) {

        # Make sure this is an SMZ3 compatible MSU based on the number of tracks
        $numFiles = (Get-ChildItem -Path $folder.FullName -Filter "$($msuFile.BaseName)-*.pcm").Length
        if ($numFiles -lt 63 -or $numFiles -gt 120) { continue; }

        Write-Host "  $($msuFile.BaseName)\$($msuFile.BaseName) ($numFiles songs)"

        $msuFiles = @{}

        foreach ($pcmFile in Get-ChildItem -Path $folder.FullName -Filter "$($msuFile.BaseName)*.pcm") {
            $number = ($pcmFile.BaseName -replace $msuFile.BaseName, "").Substring(1)

            if($number -match "^\d+$") {
                AddPCMFile $map $number $pcmFile.FullName
                $msuFiles[$number] += $pcmFile.FullName
            }
        }

        # If this MSU doesn't have extended msu support, map generic music instead
        if ($msuFiles.ContainsKey("117") -and -not $msuFiles.ContainsKey("135")) {
            # Map pendant dungeon music
            CopyPCMEntry $map "135" "117" $msuFiles # Eastern Palace
            CopyPCMEntry $map "136" "117" $msuFiles # Desert Palace
            CopyPCMEntry $map "138" "117" $msuFiles # Swamp Palace
            CopyPCMEntry $map "139" "117" $msuFiles # Palace of Darkness
            CopyPCMEntry $map "140" "117" $msuFiles # Misery Mire

            # Map crystal dungeon music
            CopyPCMEntry $map "141" "122" $msuFiles # Skull Woods
            CopyPCMEntry $map "142" "122" $msuFiles # Ice Palace
            CopyPCMEntry $map "143" "122" $msuFiles # Tower of Hera
            CopyPCMEntry $map "144" "122" $msuFiles # Thieves' Town
            CopyPCMEntry $map "145" "122" $msuFiles # Turtle Rock
        }

        # Copy extra Z3 songs that SMZ3 doesn't use into slots that it does use
        if ($includeExtra.toLower() -eq "y") {
            CopyPCMEntry $map "121" "147" $msuFiles # Armos Knights
            CopyPCMEntry $map "121" "148" $msuFiles # Lanmolas
            CopyPCMEntry $map "121" "149" $msuFiles # Agahnim 1
            CopyPCMEntry $map "121" "150" $msuFiles # Arrghus
            CopyPCMEntry $map "121" "151" $msuFiles # Helmasaur King
            CopyPCMEntry $map "121" "152" $msuFiles # Vitreous
            CopyPCMEntry $map "121" "153" $msuFiles # Mothula
            CopyPCMEntry $map "121" "154" $msuFiles # Kholdstare
            CopyPCMEntry $map "121" "155" $msuFiles # Moldorm
            CopyPCMEntry $map "121" "156" $msuFiles # Blind
            CopyPCMEntry $map "121" "157" $msuFiles # Trinexx
            CopyPCMEntry $map "121" "158" $msuFiles # Agahnim 2

            CopyPCMEntry $map "116" "137" $msuFiles # Castle Tower => Hyrule Castle
            CopyPCMEntry $map "146" "159" $msuFiles # GT Ascent => Ganons Tower
            CopyPCMEntry $map "102" "160" $msuFiles # Light World Post Pedestal => Light World
            CopyPCMEntry $map "109" "161" $msuFiles # Dark World All Crystals => Dark World
            CopyPCMEntry $map "113" "115" $msuFiles # Dark Woors => Dark Death Mountain
        }
    }
}

$continue = Read-Host "Continue? (y/n)"

if ($continue.ToLower() -ne "y") { exit; }

# Create folder and MSU pack
if (!(Test-Path $randomizedMsuFolder -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $randomizedMsuFolder | Out-Null
}
Remove-Item $randomizedMsuFolder\* -Recurse -Force | Out-Null
New-Item -Name $randomizedMsuFolder\randomized-smz3.msu -ItemType File | Out-Null

$keys = @()
foreach ($key in $msuFiles.Keys) {
    $keys += [convert]::ToInt32($key)
}
$keys = $keys | Sort-Object

$usedPCMs = @()

foreach ($key in $keys) {

    if ($key -eq 5) {
        continue;
    }

    $oldPCMFile = $map[$key.ToString()] | Get-Random;

    # Make an attempt to avoid duplicate songs
    if ($usedPCMs.Contains($oldPCMFile)) {
        $oldPCMFile = $map[$key.ToString()] | Get-Random;
    }

    CreatePCMLink $key $oldPCMFile

    # Use matching title songs
    if ($key -eq 4) {
        CreatePCMLink 5 $oldPCMFile.replace("-4.pcm", "-5.pcm")
    }

    $usedPCMs += $oldPCMFile
}
