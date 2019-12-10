$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day10-test.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

Class Asteroid {
    [int]$x
    [int]$y
    [int]$visible
}

function Get-Visible {

    param (
        $HomeAsteroid,
        $otherAsteroids
    )
    $seenAsteroids = @{ }
    foreach ($a in $otherAsteroids) {
        
        $slope = 0
        if ($a.x -eq $HomeAsteroid.x -and $a.y -eq $HomeAsteroid.y) {
            #if we are at home asteroid
            continue
        }
        else {
            $dir = Get-Direction -originAsteroid $HomeAsteroid -SeenAsteroid $a
            $slope = Get-Slope -originAsteroid $HomeAsteroid -SeenAsteroid $a
            $angle = Get-Angle -originAsteroid $HomeAsteroid -SeenAsteroid $a -Direction $dir -Slope $slope

            if($null -eq $seenAsteroids[$angle])
            {
                $seenAsteroids[$angle] = "$($a.x),$($a.y)"
            }
        }
    }
    return $seenAsteroids.Count
}

function Get-Direction #which quadrant is the seen asteroid in relative to the origin asteroid
{
    param(
        $originAsteroid,
        $SeenAsteroid
    )
    if($SeenAsteroid.x -ge $originAsteroid.x -and $SeenAsteroid.y -ge $originAsteroid.y) #y grows downwards
    {
        return 1
    }
    if($SeenAsteroid.x -lt $originAsteroid.x -and $SeenAsteroid.y -ge $originAsteroid.y)
    {
        return 2
    }
    if($SeenAsteroid.x -lt $originAsteroid.x -and $SeenAsteroid.y -lt $originAsteroid.y)
    {
        return 3
    }
    if($SeenAsteroid.x -ge $originAsteroid.x -and $SeenAsteroid.y -lt $originAsteroid.y)
    {
        return 4
    }

}

function Get-Slope #which quadrant is the seen asteroid in relative to the origin asteroid
{
    param(
        $originAsteroid,
        $SeenAsteroid
    )
    if($originAsteroid.x -eq $SeenAsteroid.x){
        return $null
    }

    return [decimal]($SeenAsteroid.y - $originAsteroid.y)/($SeenAsteroid.x - $originAsteroid.x)
}
function Get-Angle
{
    param(
        $originAsteroid,
        $SeenAsteroid,
        $slope,
        $direction
    )

    if($null -eq $slope)
    {
        if($direction -eq 1){return 270} #straight up, remember that our vertical axis grows down instead of up
        return{90} #straight down
    }

    [decimal]$atan = [math]::Atan($slope) * 360 / (2 * [Math]::PI)

    $angle = 0;
    if($direction -eq 1) #I actually had to pull out my old trig book to remember this stuff, it still isn't working
    {
        $angle = $atan
    } elseif ($direction -eq 2 -or $direction -eq 3)
    {
        $angle = $atan + 180
    } else {
        $angle = $atan + 360
    }

    return $angle
}

#CODE GOES HERE
[System.Collections.Generic.List[Asteroid]]$map = @()

for ($i = 0; $i -lt $data.Length; $i++) {
    for ($j = 0; $j -lt $data[$i].Length; $j++) {
        if ($data[$i][$j] -eq '#') {
            $b = [Asteroid]::new()
            $b.x = $j
            $b.y = $i
            $map.Add($b) | Out-Null
        }
    }
}

foreach ($b in $map) {
    $b.visible = Get-Visible -HomeAsteroid $b -otherAsteroids $map
}


$highest = ($map | Measure-Object -Property visible -Maximum).Maximum

Write-Host "Part 1: $highest"
Write-Host "Part 2: "
$timer.Stop()
Write-Host "Runtime:"
Write-Host $timer.Elapsed