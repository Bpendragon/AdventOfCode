$inputPath = ""
$timer = New-Object System.Diagnostics.Stopwatch
$timer.start()

Write-Host "Parse Input, Prep Work"

$coord = gc $inputPath
$regionThreshold = 10000

$i = 0
$spots = $coord | % {
    $x = ($_ -split ", ")[0]
    $y = ($_ -split ", ")[1]

    [pscustomobject]@{
        point = $i
        x = +$x
        y = +$y
    }

    $i++
}

$leftBound = ($spots | sort x)[0].x
$rightBound = ($spots | sort x)[-1].x
$topBound = ($spots | sort y)[0].y
$bottomBound = ($spots | sort y)[-1].y

$grid = @{}
$borderSet = @{}
$regionCount = 0

Write-Host "Grid Loop"

$leftBound..$rightBound | % {
    $cx = $_
    if($cx -eq $leftBound -or $cx -eq $rightBound){
        $colBorder = $true
    }else{
        $colBorder = $false
    }

    #Write Every 10th Col to keep an eye on the program
    if($cx % 10 -eq 0){
        Write-Host $cx
    }


    $grid.add($cx,@{})

    $topBound..$bottomBound |% {
        $cy = $_

        if($cy -eq $topBound -or $cy -eq $bottomBound){
            $rowBorder = $true
        }else{
            $rowBorder = $false
        }

        $grid[$cx].add($cy,0)

        $totalDist = 0
        $closestDist = ($bottomBound-$topBound)+($rightBound-$leftBound) #max possible distance is opposite corners of grid
        $tieCount = 0
        $closestPoint = ""
        $spots | %{
            $curDist = [math]::abs($cx - $_.x)+[math]::abs($cy-$_.y)

            if($curDist -eq $closestDist){
                $tieCount++
                $closestPoint = "_"
            }elseif($curDist -lt $closestDist){
                $closestDist = $curDist
                $closestPoint = $_.point
            }

            $totalDist += $curDist
        }

        $grid[$cx][$cy] = $closestPoint

        if($rowBorder -or $colBorder){
            $borderSet[$closestPoint]++
        }

        if($totalDist -lt $regionThreshold){
            $regionCount++
        }
    }
}

Write-Host "Final Calculations"

$infinitePoints = $borderSet.keys
Write-Host "Part 1"
$grid.values.values | ? {$_ -notin $infinitePoints} | group | sort {+$_.count} -descending | select -first 1 | select -expandproperty count
Write-Host "Part 2"
$regionCount

$timer.stop()
Write-Host $timer.Elapsed