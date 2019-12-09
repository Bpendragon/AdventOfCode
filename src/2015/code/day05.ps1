$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day05.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

#CODE GOES HERE

Write-Host "Part 1: "
Write-Host "Part 2: "
$timer.Stop()
Write-Host "Runtime:"
Write-Host $timer.Elapsed