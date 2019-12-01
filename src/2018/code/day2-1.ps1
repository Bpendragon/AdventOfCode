$inputPath = ""
$data = Get-Content $inputPath

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
$twosCount = 0
$Threescount = 0
foreach($line in $data) {
    $tmpDict = @{}
    $line = $line.ToCharArray()

    foreach($char in $line) {
        if($null -eq $tmpDict[$char]) {
            $tmpDict[$char] = 1
        } else {
            $tmpDict[$char]++
        }
    }
    if($tmpDict.Values -contains 2) {
        $twosCount++
    }
    if($tmpDict.Values -contains 3) {
        $Threescount++
    }
}
$out = $twosCount * $Threescount

write-host $out

$timer.Stop()
Write-Host $timer.Elapsed