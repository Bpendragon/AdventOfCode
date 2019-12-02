$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day01.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$sum = 0
$sum2 = 0
$shavings = 0
$addFuel = 0

foreach($i in $data)
{
    $i = [int]$i

    $i = [Math]::Floor($i/3)
    $i -= 2 
    $sum += $i
    $sum2 += $i

    while($i -ge 9)
    {
        $i = [Math]::Floor($i/3)
        $i -= 2 
        $sum2 += $i
    }
    if($i -gt 0) { $shavings += $i }
}

while($shavings -ge 9)
{
    $shavings = [Math]::Floor($shavings/3)
    $shavings -= 2 
    $addFuel += $shavings
}

Write-Host "Part 1: $sum"
Write-Host "Part 2: $sum2"
Write-Host "Additional fuel from all additional mass that was missed: $addFuel"

$timer.Stop()
Write-Host $timer.Elapsed
