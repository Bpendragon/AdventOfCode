[string]$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day08.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

[string[]]$layers = $data -split '(\w{150})' | ? {$_}

$layerCounts = @{}

for($i = 0; $i -lt $layers.Length; $i++)
{
    [int]$layerCounts[($layers[$i].ToCharArray() | ? {$_ -eq '0'} | measure).Count] = $i
}

[int]$minZeroes = ($layerCounts.Keys | measure -Minimum).Minimum
$LayerOccured = $layerCounts[$minZeroes]
$ones = ($layers[$LayerOccured].ToCharArray() | ? {$_ -eq '1'} | measure).Count
$twos = ($layers[$LayerOccured].ToCharArray() | ? {$_ -eq '2'} | measure).Count

###Part 2

$image = ""
for($i = 0; $i -lt 150; $i++)
{
    foreach($layer in $layers)
    {
        if($layer[$i] -eq '1')
        {
            $image += '*'
            break
        }
        if($layer[$i] -eq '0')
        {
            $image += ' '
            break
        }
    }
}


[string[]]$rows = $image -split '(.{25})' | ? {$_}


Write-Host "Part 1: $($ones * $twos) "
Write-Host "Part 2: "
foreach($row in $rows)
{
    Write-Host $row
}
$timer.Stop()
Write-Host "Runtime:"
Write-Host $timer.Elapsed