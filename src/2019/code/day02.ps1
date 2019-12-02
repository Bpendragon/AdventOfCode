$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day02.txt")
[long[]]$Cleanram = $data.Split(',')


function Invoke-Program
{
    [CmdletBinding()]
    param (
        [long[]]$ram,
        [long]$noun,
        [long]$verb
    )

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

    return $ram[0]
}

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$ram = $Cleanram.Clone() #Non-value types are always passed by reference, so lets just create a copy to work on
$part1 = Invoke-Program -ram $ram -noun 12 -verb 2

Write-Host "Part 1: $part1"

$noun = 0
$verb = 0
:base for($noun = 0; $noun -le 99; $noun++) {
    for ($verb = 0; $verb -le 99; $verb++) {
        $ram = $Cleanram.Clone()
        $res = Invoke-Program -ram $ram -noun $noun -verb $verb
        if ($res -eq 19690720) 
        {
            break base  #all the way out of both loop please
        }
    }
}

Write-Host "Part 2: $(100 * $noun + $verb)"
$timer.Stop()
Write-Host $timer.Elapsed
