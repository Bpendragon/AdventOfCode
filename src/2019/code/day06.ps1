$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day06.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

class Orbit
{
    [string]$Name
    [Orbit]$Parent
    [Orbit[]]$Children
    
}

function Get-OrbitCount
{
    param(
        [Orbit]$curOrbit,
        [int]$curDepth
    )

    $count = 0
    
    if($null -ne $orbits[$curOrbit.Name])
    {
        foreach($child in ($orbits[$curOrbit.Name] -split ','))
        {
            $childOrbit = [Orbit]::new()
            $childOrbit.Name = $child
            $childOrbit.Parent = $curOrbit
            $curOrbit.Children += $childOrbit
            if($child -eq "SAN")
            {
                $script:SANTA = $childOrbit
            }
            if($child -eq "YOU")
            {
                $script:YOU = $childOrbit
            }
            $count += (Get-OrbitCount -curOrbit $ChildOrbit -curDepth ($curDepth + 1))
        }
    }

    return $count + $curDepth
} 

function Get-Distance
{
    param(
        [Orbit]$body1,
        [Orbit]$body2
    )
    $body1Path = Get-PathToCenter -body $Body1
    $body2Path = Get-PathToCenter -body $Body2
    
    [array]::Reverse($body1Path)
    [array]::Reverse($body2Path)

    $max = 0
    if($body1Path.Length -gt $body2Path.Length)
    {
        $max = $body1path.Length
    }
    else
    {
        $max = $body2Path.Length
    }

    for($i = 0; $i -lt $max; $i++)
    {
        if($body1Path[$i] -ne $body2Path[$i])
        {
            return ($body1Path.Length + $body2Path.Length - (2 * $i) - 2)
        }
    }
}

function Get-PathToCenter
{
    param(
    [Orbit]$body
    )
    $bodyPath = @($body.Name)
    [Orbit]$parent = $body.Parent
    while ($null -ne $parent)
    {
        $bodyPath += $parent.Name
        $parent = $parent.Parent
    }

    return $bodyPath
}

#CODE GOES HERE
$orbits = @{}

foreach($check in $data)
{
    $parent,$child = $check -split '\)'
    if($null -ne $orbits[$parent])
    {
        $orbits[$parent] += ",$child"
    } 
    else 
    {
        $orbits[$parent] = $child
    }
}

$OrbitTreeBase = [Orbit]::new()

$OrbitTreeBase.Name = "COM"
$OrbitTreeBase.Parent = $null

$script:SANTA = [Orbit]::new() #Abusing Powershell's scope system for fun and profit.
$script:YOU  = [Orbit]::new()

$res = Get-OrbitCount -curOrbit $OrbitTreeBase -curDepth 0
$res2 = Get-Distance -body1 $SANTA -body2 $YOU

Write-Host "Part 1: $res"
Write-Host "Part 2: $res2"
$timer.Stop()
Write-Host "Runtime:"
Write-Host $timer.Elapsed