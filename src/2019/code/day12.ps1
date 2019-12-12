class Moon {
    [long]$x
    [long]$y
    [long]$z
    [long]$Vx
    [long]$Vy
    [long]$Vz
}

function Get-Velocities
{
    param ([Moon]$h, [Moon]$k)
    if($h.x -gt $k.x)
    {
        $h.Vx--
        $k.Vx++
    } elseif ($h.x -lt $k.x) {
        $h.Vx++
        $k.Vx--
    }

    if($h.y -gt $k.y)
    {
        $h.Vy--
        $k.Vy++
    } elseif ($h.y -lt $k.y) {
        $h.Vy++
        $k.Vy--
    }

    if($h.z -gt $k.z)
    {
        $h.Vz--
        $k.Vz++
    } elseif ($h.z -lt $k.z) {
        $h.Vz++
        $k.Vz--
    }
}

function Clear-Velocities
{
    param ([Moon]$l)
    $l.x = 0
    $l.y = 0 
    $l.z = 0
}

function Update-Position
{
    param([moon]$m)
    $m.x += $m.Vx
    $m.y += $m.Vy
    $m.z += $m.Vz
}

function Get-Energy([moon]$n)
{
    if($n.x -lt 0) { $n.x *= -1 }
    if($n.y -lt 0) { $n.y *= -1 }
    if($n.z -lt 0) { $n.z *= -1 }
    if($n.Vx -lt 0) { $n.Vx *= -1 }
    if($n.Vy -lt 0) { $n.Vy *= -1 }
    if($n.Vz -lt 0) { $n.Vz *= -1 }
    [long]$potential = $n.x + $n.y + $n.z
    [long]$kinetic = $n.Vx+ $n.Vy+ $n.Vz
    return $potential * $kinetic
}

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

#CODE GOES HERE
[Moon]$a = [Moon]::new()
[Moon]$b = [Moon]::new()
[Moon]$c = [Moon]::new()
[Moon]$d = [Moon]::new()

#just hardcode it is faster
$a.x = 0
$a.y = 4
$a.z = 0

$b.x = -10
$b.y = -6
$b.z = -14

$c.x = 9
$c.y = -16
$c.z = -3

$d.x = 6
$d.y = -1
$d.z = 2


#testData
# $a.x = -1
# $a.y = 0
# $a.z = 2

# $b.x = 2
# $b.y = -10
# $b.z = -7

# $c.x = 4
# $c.y = -8
# $c.z = 8

# $d.x = 3
# $d.y = 5
# $d.z = -1


foreach($i in (0..999))
{
    Get-Velocities -h $a -k $b
    Get-Velocities -h $a -k $c
    Get-Velocities -h $a -k $d
    Get-Velocities -h $b -k $c
    Get-Velocities -h $b -k $d
    Get-Velocities -h $c -k $d

    Update-Position -m $a
    Update-Position -m $b
    Update-Position -m $c
    Update-Position -m $d
}

[long]$totalEnergy = 0
$totalEnergy += Get-Energy -n $a
$totalEnergy += Get-Energy -n $b
$totalEnergy += Get-Energy -n $c
$totalEnergy += Get-Energy -n $d

Write-Host "Part 1: $totalEnergy"
Write-Host "Part 2: "
$timer.Stop()
Write-Host "Runtime:"
Write-Host $timer.Elapsed