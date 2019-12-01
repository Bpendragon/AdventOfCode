$inputPath = "D:\Users\Bpendragon\Documents\Advent of Code\2019\code\2019\input\day1.txt"
$data = Get-Content $inputPath

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$sum = 0
$sum2 = 0

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
}
Write-Host "Part 1: $sum"
Write-Host "Part 2: $sum2"

$timer.Stop()
Write-Host $timer.Elapsed
