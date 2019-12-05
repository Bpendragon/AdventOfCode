param (
    [int]$Year = 0,
    [int]$Day = 0,
    [switch]$CreateBoth,
    [switch]$noDownload
)

$now = [DateTime]::UtcNow.AddHours(-5) #EST is UTC -5, this makes it universal for all users. 

if(($Year -lt 2015 -or $Day -lt 1 -or $Day -gt 25 -or $Year -gt $now.Year -or ($Year -eq $now.Year -and $Day -gt $now.Day)) -and !($noDownload.IsPresent)) #Basic params. if out of spec just get the most recent
{
     $Year = $now.Year
     $Day = $now.Day
     if($now.Month -lt 12) #run the script mid year and get the most recent december 25th as a fall back
     {
         $Year = $now.Year - 1
         $Day = 25
     }
}

$config = Get-Content (Join-Path $PSScriptRoot -ChildPath "config.json") | ConvertFrom-Json

$Inputpath = Join-Path $PSScriptRoot -ChildPath "$Year\input\day$("{0:00}" -f $Day).txt" 
$InputURI = "https://adventofcode.com/$Year/day/$Day/input"
$CodePath1 = Join-Path $PSScriptRoot -ChildPath "$Year\code\day$("{0:00}" -f $Day).ps1" #Pads a leading 0 if needed
$CodePath2 = Join-Path $PSScriptRoot -ChildPath "$Year\code\day$("{0:00}" -f $Day)-2.ps1"

if(!(Test-Path (Join-Path $PSScriptRoot -ChildPath "$Year\input"))) 
{
    mkdir (Join-Path $PSScriptRoot -ChildPath "$Year\input") | Out-Null
}

if(!(Test-Path (Join-Path $PSScriptRoot -ChildPath "$Year\code")))
{
    mkdir (Join-Path $PSScriptRoot -ChildPath "$Year\code") | Out-Null
}

if (!(Test-Path $InputPath) -and !($noDownload.IsPresent)) {
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $cookie = New-Object System.Net.Cookie
    $cookie.Name = "session"
    $cookie.Value = $config.cookie #Edit this as needed.
    $cookie.Domain = "adventofcode.com"
    $session.Cookies.Add($cookie);
    Invoke-WebRequest -Uri $InputURI -WebSession $session -TimeoutSec 900 -Method Get -OutFile $inputPath
}

#Repeating the JoinPath here so as not to expose file structure to the world in the rest of the repo
$BasicLayout = @"
`$data = Get-Content (Join-Path `$PSScriptRoot -ChildPath "..\input\day$("{0:00}" -f $Day).txt")

`$timer = New-Object System.Diagnostics.Stopwatch
`$timer.Start()

#CODE GOES HERE

Write-Host "Part 1: "
Write-Host "Part 2: "
`$timer.Stop()
Write-Host "Runtime:"
Write-Host `$timer.Elapsed
"@

if(!(Test-Path $CodePath1)) {
    New-Item $CodePath1 -ItemType "file" -Value $basiclayout -Force | Out-Null
}

if(!(Test-Path $CodePath2) -and $CreateBoth) {
    New-Item $CodePath2 -ItemType "file" -Value $basiclayout -Force | Out-Null
}
