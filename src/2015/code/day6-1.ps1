$inputPath = ""
$data = Get-Content $inputPath

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

#CODE GOES HERE
$grid = New-Object 'int[,]' 1000,1000 
$commandNumber = 0
foreach($command in $data) {
    $tokens = $command.Split(' ')
    [int]$startX = 0
    [int]$startY = 0
    [int]$endX = 0
    [int]$endY = 0
    $command = $null
    $commandNumber++

    if($tokens[0] -eq 'turn') {
        if($tokens[1] -eq 'on') {
            $command = 'on'
        } else {
            $command = 'off'
        }
        $startX, $startY = $tokens[2].Split(',')
        $endX, $endY = $tokens[4].Split(',')
    } else {
        $command = 'toggle'
        $startX, $startY = $tokens[1].Split(',')
        $endX, $endY = $tokens[3].Split(',')
    }

    for($i = $startX; $i -le $endX; $i++) {
        for($j = $startY; $j -le $endY; $j++) {
            switch ($command) {
                'on' { $grid[$i,$j] = 1 }
                'off' { $grid[$i,$j] = 0}
                'toggle' { 
                    if($grid[$i,$j] -eq 1) {
                        $grid[$i,$j] = 0
                    } else {
                        $grid[$i,$j] = 1
                    }
                }
                Default {throw}
            }
        }
    }

    Write-Host "Completed Command $commandNumber"
}

$count = 0

for($i = 0; $i -lt 1000; $i++) {
    for($j = 0; $j -lt 1000; $j++) {
        $count+=$grid[$i,$j]
    }
}
Write-Host $count
$timer.Stop()
Write-Host $timer.Elapsed