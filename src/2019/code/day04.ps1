$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day04.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

[string[]]$ends = $data -split '-'
$count = 0
$count2 = 0
foreach ($i in ($ends[0]..$ends[1]))
{
   $dig = ($i -split "")[1..6]

    if(
        $dig[0] -le $dig[1] -and 
        $dig[1] -le $dig[2] -and 
        $dig[2] -le $dig[3] -and 
        $dig[3] -le $dig[4] -and 
        $dig[4] -le $dig[5]
    )
    {
        $c = @{}
        foreach($j in $dig)
        {
            if($c.ContainsKey($j))
            {
                $c[$j]++
            } 
            else
            {
                $c[$j] = 1     
            }
        }
        $maxCount = ($c.Values | Measure-Object -Maximum).Maximum

        if($maxCount -ge 2)
        {
            $count++
        } 
        
        if($c.ContainsValue(2))
        {
            $count2++
        }
    }

}

$timer.Stop()
write-host "Part1: $count"
write-host "Part2: $count2"
Write-Host $timer.Elapsed