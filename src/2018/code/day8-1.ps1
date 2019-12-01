$inputPath = ""
[int[]]$data = (Get-Content $inputPath).Split(" ") 

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

function recurseHere {
    param(
        [int]$curPoint
    )
    $metaSum = 0
    $numChildNodes = $data[$curPoint++]
    $numMetaData = $data[$curPoint++]

    for($i = 0; $i -lt $numChildNodes; $i++) {
        $returnVals = recurseHere -curPoint $curPoint
        $metaSum += $returnVals[0]
        $curPoint = $returnVals[1]
    }

    for($j = 0; $j -lt $numMetaData; $j++) {
        $metaSum += $data[$curPoint++]
    }
    
    return @($metaSum, $curPoint)
}

$result = recurseHere -curPoint 0

Write-Host $result[0]
$timer.Stop()
Write-Host $timer.Elapsed