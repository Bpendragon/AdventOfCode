$inputPath = ""
[int[]]$data = (Get-Content $inputPath).Split(" ") 

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

function recurseHere {
    param(
        [int]$curPoint
    )
    $nodeValue = 0
    $ChildValues = @()
    $numChildNodes = $data[$curPoint++]
    $numMetaData = $data[$curPoint++]

    for ($i = 0; $i -lt $numChildNodes; $i++) {
        $returnVals = recurseHere -curPoint $curPoint
        $ChildValues += $returnVals[0]
        $curPoint = $returnVals[1]
    }

    if ($numChildNodes -eq 0) {
        for ($j = 0; $j -lt $numMetaData; $j++) {
            $NodeValue += $data[$curPoint++]
        }
    } else {
        for ($j = 0; $j -lt $numMetaData; $j++) {
            $childNum = $data[$curPoint] - 1
            if($null -ne $childvalues[$childNum]) {
                $nodeValue += $childvalues[$childNum]
            }

            $curPoint++
        }
    }
    
    return @($nodeValue, $curPoint)
}

$result = recurseHere -curPoint 0

Write-Host $result[0]
$timer.Stop()
Write-Host $timer.Elapsed