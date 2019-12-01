$inputPath = ""
$lines = Get-Content $inputPath

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$board=@{}
foreach($i in (0..999)) { 
    $board[$i]=@{}
    foreach ($j in 0..999) {
        $board[$i][$j]=[System.Collections.Generic.List[object]]::new()
    }}

$lines | foreach-object {
    $bits = $_ -split ' '
    $claim = $bits[0]
    [int]$x, [int]$y = $bits[2].trim(':').split(',')
    [int]$w, [int]$h = $bits[3].trim().split('x')

    for ($b=$y; $b -lt ($y+$h); $b++){
        for ($a=$x; $a-lt($x+$w); $a++) {
            $board[$b][$a].Add($claim)
        }}}

$claims = $board.GetEnumerator().foreach{$_.value.getenumerator()}.where{$_.value}
$seen = @{}
foreach($cl in $claims){if($cl.value.count-gt1){foreach($c in $cl.value) { $seen[$c] = 1}}}
foreach($cl in $claims){if($cl.value.count-eq1){foreach($c in $cl.value) { if (-not $seen[$c]) { $c }}}}

$timer.Stop()
Write-Host $timer.Elapsed