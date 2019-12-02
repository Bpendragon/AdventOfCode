$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day01.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

[long[]]$nums = $data -split ''

[long]$sum = 0
foreach($i in (0..($nums.Count)))
{
    if($nums[$i] -eq $nums[$i-1]) {$sum += $nums[$i]}
}

[long]$sum2 = 0
foreach($i in (0..($nums.Count)))
{
    if($nums[$i] -eq $nums[$i-$($nums.Count / 2)]) { $sum2 += $nums[$i] }
}

$timer.Stop()
Write-Host "Part 1: $sum"
Write-Host "Part 2: $sum2"
Write-Host $timer.Elapsed