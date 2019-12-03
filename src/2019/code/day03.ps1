$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day03.txt")


$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

function Get-Points {
    param(
        $path
    )

    $x = 0 
    $y = 0
    $points = @{}
    $DX = @{'L' = -1; 'R' = 1; 'U' = 0; 'D' = 0 }
    $DY = @{'L' = 0; 'R' = 0; 'U' = 1; 'D' = -1 }
    $length = 0

    foreach ($dir in $path) {
        $dist = [int](-join $dir[1..($dir.Length)] )
        [string]$direction = $dir[0]
        foreach ($i in (1..$dist)) {
            $x += $DX[$direction]
            $y += $DY[$direction]
            $length++
            $nextPoint = "$x,$y"
            if (!$points.ContainsKey($nextPoint)) {
                $points[$nextPoint] = $length
            }
        }    
    }

    return $points
}

[string[]]$path1 = $data[0] -split ','
[string[]]$path2 = $data[1] -split ','

$points1 = Get-Points $path1
$points2 = Get-Points $path2

$ints = $points1.Keys | Where-Object { $points2.ContainsKey($_) -and $_ -ne "0,0"}  

$sums = @()

foreach($i in $ints)
{
    $h = $i -split ','
    $sums+= [Math]::Abs([int]$h[0]) + [Math]::Abs([int]$h[1])
}

$intWalks = $ints | % {$points1[$_] + $points2[$_]}

$minToCenter = ($sums | Measure-Object -Minimum).Minimum
$minWalkDistance = ($intWalks | Measure-Object -Minimum).Minimum
Write-Host "Part 1: $minToCenter"
Write-Host "Part 2: $minWalkDistance"

$timer.Stop()
Write-Host $timer.Elapsed