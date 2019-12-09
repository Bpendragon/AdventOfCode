$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day13.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

#CODE GOES HERE

$timer.Stop()
Write-Host $timer.Elapsed