$inputPath = ""
$data = Get-Content $inputPath

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$grid = New-Object 'int[,]' 1000,1000
$commandNumber = 0
$LastUntouchedCommand = New-Object System.Collections.ArrayList($null)

foreach($command in $data) {
    $commandNumber++
    $commandBroken = $false
    $tokens = $command.Replace(':','').split(' ')

    [int]$StartX, [int]$StartY = $tokens[2].split(',')
    [int]$width, [int]$height = $tokens[3].split('x')

    for([int]$i = 0; $i -lt $width; $i++) {
        for([int]$j = 0; $j -lt $height; $j++) {
            if($grid[($i + $StartX),($j + $StartY)] -eq 0) {
                $grid[($i + $StartX),($j + $StartY)] = $commandNumber
            } else {
                if($LastUntouchedCommand -contains $grid[($i + $StartX),($j + $StartY)]) {
                    $LastUntouchedCommand.Remove(($grid[($i + $StartX),($j + $StartY)])) | Out-Null
                }
                $grid[($i + $StartX),($j + $StartY)] = -2
                $commandBroken = $true
            }
        }
    }

    if(!$commandBroken) {
        $LastUntouchedCommand.Add($commandNumber) | Out-Null
    }
}

Write-Host $LastUntouchedCommand[0]
$timer.Stop()
Write-Host $timer.Elapsed