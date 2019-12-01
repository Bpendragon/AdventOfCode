$inputPath = ""
$data = Get-Content $inputPath


function getdistance {
    param([string] $first, [string] $second)
    $len1 = 26
    $len2 = 26

    $dist = new-object -type 'int[,]' 27,27

    for($i = 0; $i -le $len1; $i++) 
    {  $dist[$i,0] = $i }
    for($j = 0; $j -le $len2; $j++) 
    {  $dist[0,$j] = $j }
    
    $cost = 0
    
    for($i = 1; $i -le $len1;$i++)
    {
      for($j = 1; $j -le $len2;$j++)
      {
        if($second[$j-1] -ceq $first[$i-1])
        {
          $cost = 0
        }
        else   
        {
          $cost = 1
        }
        
        $tempmin = [System.Math]::Min(([int]$dist[($i-1),$j]+1) , ([int]$dist[$i,($j-1)]+1))
        $dist[$i,$j] = [System.Math]::Min($tempmin, ([int]$dist[($i-1),($j-1)] + $cost))
      }
    }
    
    # the actual distance is stored in the bottom right cell
    return $dist[$len1, $len2];
}

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
$hasbroken = $false
for($i = 0; $i -lt $data.Length; $i++) {
    for($j = $i+1; $j -lt $data.Length; $j++) {
        $dist = getdistance -first $data[$i] -second $data[$j]

        if($dist -eq 1) {
            Write-Host $data[$i] 
            Write-Host $data[$j]
            $hasbroken = $true
        }
    }

    if($hasbroken) {
        break
    }
    Write-Host "Finished comparing round $i"
}

$timer.Stop()
Write-Host $timer.Elapsed


