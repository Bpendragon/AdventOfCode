$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
$freq = 0

$visitedFreqs = @{}
$visitedFreqs[$freq] = 1 
$dupFound = $false
$lines = Get-Content "2018/input/day1.txt"

while (!$dupFound) {
    foreach ($line in $lines) {
        [int]$a = $line
        $freq += $a
        if ($null -ne $visitedFreqs[$freq]) {
            $dupFound = $true
            break
        }
        else {
            $visitedFreqs[$freq] = 1
        }
    }
}

Write-Host $freq

$timer.Stop()
Write-Host $timer.Elapsed