param (
    [bool]$CreateBoth = $false,
    [int]$Year = 0,
    [int]$Day = 0
)
$now = [DateTime]::UtcNow #If it's midnight in London, it's midnight on the US East Coast
if($Year -lt 2015 -or $Day -lt 1 -or $Day -gt 25) #Basic params. if out of spec just get the most recent
{
     $Year = $now.Year
     $Day = $now.Day
}

$config = Get-Content (Join-Path $PSScriptRoot -ChildPath "config.json") | ConvertFrom-Json

$Inputpath = Join-Path $PSScriptRoot -ChildPath "$Year\input\day$("{0:00}" -f $Day).txt" 
$InputURI = "https://adventofcode.com/$Year/day/$Day/input"
$CodePath1 = Join-Path $PSScriptRoot -ChildPath "$Year\code\day$("{0:00}" -f $Day).ps1" #Pads a leading 0 if needed
$CodePath2 = Join-Path $PSScriptRoot -ChildPath "$Year\code\day$("{0:00}" -f $Day)-2.ps1"

if (!(Test-Path $InputPath)) {
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
`$data = Get-Content (Join-Path `$PSScriptRoot -ChildPath "$Year\input\day$("{0:00}" -f $Day).txt")

`$timer = New-Object System.Diagnostics.Stopwatch
`$timer.Start()

#CODE GOES HERE

`$timer.Stop()
Write-Host `$timer.Elapsed
"@

if(!(Test-Path $CodePath1)) {
    New-Item $CodePath1 -ItemType "file" -Value $basiclayout -Force
}

if(!(Test-Path $CodePath2) -and $CreateBoth) {
    New-Item $CodePath2 -ItemType "file" -Value $basiclayout -Force
}
