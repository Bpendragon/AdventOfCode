$inputPath = ""
$data = Get-Content $inputPath

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$grid = New-Object 'int[,]' 1000,1000 
$commandNumber = 0
foreach($command in $data) {
    $commandNumber++
    $tokens = $command.Replace(':','').split(' ')

    [int]$StartX, [int]$StartY = $tokens[2].split(',')
    [int]$width, [int]$height = $tokens[3].split('x')

    for([int]$i = 0; $i -lt $width; $i++) {
        for([int]$j = 0; $j -lt $height; $j++) {
            $grid[($i + $StartX),($j + $height)]++
        }
    }

    Write-Host "Completed $commandNumber"
}
$count = 0
for($i = 0; $i -lt 1000; $i++) {
    for($j = 0; $j -lt 1000; $j++) {
        if($grid[$i,$j] -gt 1) {
            $count++
        }
    }
}
Write-Host $count
$timer.Stop()
Write-Host $timer.Elapsed