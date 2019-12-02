$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day02.txt")
[long[]]$baseRom = $data.Split(',')


function Invoke-Program
{
    [CmdletBinding()]
    param (
        [long[]]$rom,
        [long]$noun,
        [long]$verb
    )

    $ram = $rom.Clone()
    $pc = 0
    $op = $ram[$pc]
    $ram[1] = $noun
    $ram[2] = $verb

    while ($true) {
        $src1,$src2,$res = $ram[($op+1)..($op+3)]
        switch($op){
            1 { $ram[$res] = $ram[$src1] + $ram[$src2]; $pc += 4; break } #Leave the increment as part of the control on the code in case jumps and gotos are added
            2 { $ram[$res] = $ram[$src1] * $ram[$src2]; $pc += 4; break }
            99 { return $ram[0] }
            Default { throw "Not a real OpCode" }
        }
        
        $op = $ram[$pc]
    }

    return $ram[0]
}

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()


$part1 = Invoke-Program -rom $baseRom -noun 12 -verb 2

Write-Host "Part 1: $part1"

$noun = 0
$verb = 0
:base for($noun = 0; $noun -le 99; $noun++) {
    for ($verb = 0; $verb -le 99; $verb++) {
        $res = Invoke-Program -rom $baseRom -noun $noun -verb $verb
        if ($res -eq 19690720) 
        {
            break base  #all the way out of both loops please
        }
    }
}

Write-Host "Part 2: $(100 * $noun + $verb)"
$timer.Stop()
Write-Host $timer.Elapsed
