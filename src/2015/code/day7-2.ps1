$inputPath = ""
$data = Get-Content $inputPath

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

#CODE GOES HERE

$timer.Stop()
Write-Host $timer.Elapsed