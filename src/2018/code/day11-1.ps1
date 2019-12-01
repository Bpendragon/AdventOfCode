$inputPath = ""
[int]$serial = Get-Content $inputPath
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$grid = New-object 'int[,]' 301, 301  #so I don't have to do any extra maths with the indices

#calculate every cells initial state

foreach($x in (1..300)) {
    foreach($y in (1..300)) {
        $rackID = $x+10
        $powerlevel = $rackID * $y
        $powerlevel += $serial
        $powerlevel *= $rackID
        if($powerlevel -ge 100) {
            [int]$powerlevel = [math]::floor([decimal]($powerlevel / 100))
        } else {
            $powerlevel = 0
        } 
        $powerlevel = $powerlevel % 10
        $powerlevel -= 5
        $grid[$x,$y] = $powerlevel
    }
}


$curBestCell = @(0, 0)
$curBestVal = -100

foreach ($x in (1..297)) {
    foreach ($y in (1..297)) {
        $testVal = 0
        $testVal += $grid[$x, $y]
        $testVal += $grid[($x + 1), $y]
        $testVal += $grid[($x + 2), $y]
        $testVal += $grid[$x, ($y + 1)]
        $testVal += $grid[($x + 1), ($y + 1)]
        $testVal += $grid[($x + 2), ($y + 1)]
        $testVal += $grid[$x, ($y + 2)]
        $testVal += $grid[($x + 1), ($y + 2)]
        $testVal += $grid[($x + 2), ($y + 2)]

        if ($testVal -gt $curBestVal) {
            $curbestVal = $testVal
            $curBestCell = @($x, $y)
        }
    }
}
write-host "Best Energy $curbestVal"
Write-Host "At Location $curBestCell"
$timer.Stop()
Write-Host $timer.Elapsed