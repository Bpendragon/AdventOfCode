$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day11.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()


[string[]]$moves = $data.Split(',')

# Kept for posterity (and cleverness) this is my original part 1 solution
#$reducedmoves = $moves | Group-Object | % { $h = @{} } { $h[$_.Name] = $_.Count } { $h }
# $north = $reducedmoves["n"] - $reducedmoves["s"]
# $northEast = $reducedmoves["ne"] - $reducedmoves["sw"]
# $northWest = $reducedmoves["nw"] - $reducedmoves["se"]
# $res = [System.Math]::Abs($north + $northEast + ($northWest - $northEast))
#Write-Host $res

$highest = 0
$x = 0
$y = 0
foreach($dir in $moves)
{
    switch($dir)
    {
        "n"
        {
            $y++
            break
        }
        "s"
        {
            $y--
            break
        }
        "ne"
        {
            $x++
            $y++
            break
        }
        "se"
        {
            $x++
            break
        }
        "nw"
        {
            $x--
            break
        }
        "sw"
        {
            $x--
            $y--
            $break
        }
    }
    $highest = (@([math]::Abs($x),[math]::Abs($x),[math]::Abs($x-$y),$highest) | Measure-Object -Maximum).Maximum
}
Write-Host (@([math]::Abs($x),[math]::Abs($x),[math]::Abs($x-$y)) | Measure-Object -Maximum).Maximum
Write-Host $highest
$timer.Stop()
Write-Host $timer.Elapsed