$inputPath = ""
$data = Get-Content $inputPath


function Copy-Object {
    # http://stackoverflow.com/questions/7468707/deep-copy-a-dictionary-hashtable-in-powershell
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [object]$InputObject
    )

    $memStream = New-Object -TypeName IO.MemoryStream
    $formatter = New-Object -TypeName Runtime.Serialization.Formatters.Binary.BinaryFormatter
    $formatter.Serialize($memStream, $InputObject)
    $memStream.Position = 0
    $formatter.Deserialize($memStream)
}

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$cells = @{}
$rules = @{}
$initialState = "#.#.#...#..##..###.##.#...#.##.#....#..#.#....##.#.##...###.#...#######.....##.###.####.#....#.#..##"

foreach ($i in (0..($initialState.Length - 1))) {
    $cells[$i] = $initialState[$i]
}

foreach ($i in (2..($data.Length - 1))) {
    $t = $data[$i].split(' => ')
    $rules[$t[0]] = $t[4]
}

$prevDiff = -100
$prevCount = -100

for ($i = 0; $i -lt 200; $i++) {
    $pots = $cells.Keys.GetEnumerator() | Sort-Object
    $cells[$pots[0] - 1] = '.'
    $cells[$pots[0] - 2] = '.'
    $cells[$pots[-1] + 1] = '.'
    $cells[$pots[-1] + 2] = '.'
    $nextIteration = Copy-Object $cells
    foreach ($c in $cells.Keys) {
        $comp = ''
        foreach ($j in (-2..2)) {
            if ($null -eq $cells[$c + $j]) {
                $comp += '.'
            }
            else {
                $comp += $cells[$c + $j]
            } 
        }
        $nextIteration[$c] = $rules[$comp]
    }
    $cells = Copy-Object $nextIteration
    $count = 0
    foreach ($j in  ($cells.Keys)) {
        if ($cells[$j] -eq '#') {
            $count += $j
        }
    }
    write-host $count
    if($prevDiff -eq $count - $prevCount) {
        write-host "pattern seen at $i"
        break
    } else {
        $prevdiff = $count - $prevCount
        $prevCount = $count
    }
}



$count = 0
foreach ($i in  ($cells.Keys)) {
    if ($cells[$i] -eq '#') {
        $count += $i
    }
}
write-host $count
$timer.Stop()
Write-Host $timer.Elapsed