$freq = 0

foreach ($line in Get-Content "2018/input/day1.txt") {
    [int]$a = $line
    $freq += $a
}

Write-Host $freq