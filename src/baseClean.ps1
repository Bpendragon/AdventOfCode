param (
    [bool]$CreateBoth = $false
)

$Year = 2019 #edit this yearly
$Day = 1 #EDIT THIS DAILY
$Invocation = (Get-Variable MyInvocation).Value
$Directorypath = Split-Path $Invocation.MyCommand.Path
$Inputpath = Join-Path $Directorypath -ChildPath "$Year\input\day$("{0:00}" -f $Day).txt" #Pads a leading 0 if needed
$InputURI = "https://adventofcode.com/$Year/day/$Day/input"
$CodePath1 = Join-Path $DirectoryPath -ChildPath "$Year\code\day$("{0:00}" -f $Day).ps1"
$CodePath2 = Join-Path $DirectoryPath -ChildPath "$Year\code\day$("{0:00}" -f $Day)-2.ps1"

if (!(Test-Path $InputPath)) {
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $cookie = New-Object System.Net.Cookie
    $cookie.Name = "session"
    $cookie.Value = "YOUR COOKIE HERE" #Edit this as needed.
    $cookie.Domain = "adventofcode.com"
    $session.Cookies.Add($cookie);
    Invoke-WebRequest -Uri $InputURI -WebSession $session -TimeoutSec 900 -Method Get -OutFile $inputPath    
}

$BasicLayout = @"
`$inputPath = $InputPath
`$data = Get-Content `"`$inputPath`"

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
