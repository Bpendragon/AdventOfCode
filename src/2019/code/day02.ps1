$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day02.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()


[long[]]$Cleanram = $data.Split(',')
$ram = $Cleanram.Clone()
$pc = 0
$op = $ram[$pc]
$ram[1] = 12
$ram[2] = 2

while ($op -ne 99) {
    if ($op -eq 1) {
        $ram[$ram[$pc + 3]] = $ram[$ram[$pc + 1]] + $ram[$ram[$pc + 2]]
    } 
    else {
        $ram[$ram[$pc + 3]] = $ram[$ram[$pc + 1]] * $ram[$ram[$pc + 2]]
    }
    $pc += 4
    $op = $ram[$pc]
}

Write-Host "Part 1: $($ram[0])"

$noun = 0
$verb = 0
:base for($noun = 0; $noun -le 99; $noun++) {
    for ($verb = 0; $verb -le 99; $verb++) {

        $ram = $Cleanram.Clone()
        $pc = 0
        $op = $ram[$pc]
        $ram[1] = $noun
        $ram[2] = $verb

        while ($op -ne 99) {
            if ($op -eq 1) {
                $ram[$ram[$pc + 3]] = $ram[$ram[$pc + 1]] + $ram[$ram[$pc + 2]]
            } 
            else {
                $ram[$ram[$pc + 3]] = $ram[$ram[$pc + 1]] * $ram[$ram[$pc + 2]]
            }
            $pc += 4
            $op = $ram[$pc]
        }

        if ($ram[0] -eq 19690720) 
        {
            break base  #YES I KNOW GOTOS IS BAD
        }
    }
}

Write-Host "Part 2: $(100 * $ram[1] + $ram[2])"
$timer.Stop()
Write-Host $timer.Elapsed