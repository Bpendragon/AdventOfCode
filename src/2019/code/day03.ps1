$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day03.txt")


$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

function Get-Points {
    param(
        $path
    )

    $x = 0 
    $y = 0
    $points = @{@(0, 0) = 0 }
    $DX = @{'L' = -1; 'R' = 1; 'U' = 0; 'D' = 0 }
    $DY = @{'L' = 0; 'R' = 0; 'U' = 1; 'D' = -1 }

    foreach ($dir in $path) {
        $dist = [int](-join $dir[1..($dir.Length - 1)] )
        [string]$direction = $dir[0]
        foreach ($i in (0..$dist)) {
            $x += $DX[$direction]
            $y += $DY[$direction]
            $length++

            if (!$points.ContainsKey(@($x, $y))) {
                $points[@($x, $y)] = $length
            }

        }
        
    }

    return $points
}

[string[]]$path1 = $data[0] -split ','
[string[]]$path2 = $data[1] -split ','

$points1 = Get-Points $path1
$points2 = Get-Points $path2

$ints = $points1.Keys | Where-Object { $points2.Keys -contains $_}  

$sums = @()

foreach($i in $ints)
{
    $sums+= $i[0]+ $i[1]
}

write-host $($sums | measure -Minimum).Minimum

$timer.Stop()
Write-Host $timer.Elapsed