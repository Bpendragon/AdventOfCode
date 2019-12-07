$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day07.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$script:perms = @()

function Invoke-Program {
    param (
        [long[]]$ram,
        [long]$phase,
        [long]$power

    )

    
    $pc = 0
    $PhaseApplies = $false
    while ($true) {
        $op = $ram[$pc] % 100

        [string]$modes = "{0:000}" -f [Math]::Floor($ram[$pc] / 100)  #pads leading zeroes to three units

        switch ($op) {
            1 { #add
                $src1, $src2, $out = $ram[($pc + 1)..($pc + 3)]
                if ($modes[-1] -eq '0') {
                    $src1 = $ram[$src1]
                }
                if ($modes[-2] -eq '0') {
                    $src2 = $ram[$src2]
                }
                $ram[$out] = $src1 + $src2

                $pc += 4
                break
            } 
            2 { #multiply
                $src1, $src2, $out = $ram[($pc + 1)..($pc + 3)]
                if ($modes[-1] -eq '0') {
                    $src1 = $ram[$src1]
                }
                if ($modes[-2] -eq '0') {
                    $src2 = $ram[$src2]
                }
                $ram[$out] = $src1 * $src2

                $pc += 4
                break 
            } 
            3 { #take input and write to disk
                if(!$PhaseApplied){
                    $ram[$ram[$pc + 1]] = $phase
                    $phaseApplied = $true
                } 
                else 
                {
                    $ram[$ram[$pc + 1]] = $power
                }
                $pc += 2
                break
            } 
            4 {#output
                if ($modes[-1] -eq '0') {
                    
                    return $ram[$ram[$pc + 1]]
                } 
                else {
                    return $ram[$pc + 1]
                }

                $pc += 2
                break
            } 
            5 { #jump-true
                $tst, $dst = $ram[($pc + 1)..($pc + 2)]
                if ($modes[-1] -eq '0') {
                    $tst = $ram[$tst]
                }
                if ($modes[-2] -eq '0') {
                    $dst = $ram[$dst]
                }

                if ($tst -eq 0) {
                    $pc += 3
                    break
                }

                $pc = $dst
                break
            }
            6 { #jump-false
                $tst, $dst = $ram[($pc + 1)..($pc + 2)]
                if ($modes[-1] -eq '0') {
                    $tst = $ram[$tst]
                }
                if ($modes[-2] -eq '0') {
                    $dst = $ram[$dst]
                }

                if ($tst -ne 0) {
                    $pc += 3
                    break
                }

                $pc = $dst
                break
            }
            7 { #less than
                $src1, $src2, $out = $ram[($pc + 1)..($pc + 3)]
                if ($modes[-1] -eq '0') {
                    $src1 = $ram[$src1]
                }
                if ($modes[-2] -eq '0') {
                    $src2 = $ram[$src2]
                }
                if ($src1 -lt $src2) {
                    $ram[$out] = 1
                }
                else {
                    $ram[$out] = 0
                }
                $pc += 4
                break  
            }
            8 { #equality
                $src1, $src2, $out = $ram[($pc + 1)..($pc + 3)]
                if ($modes[-1] -eq '0') {
                    $src1 = $ram[$src1]
                }
                if ($modes[-2] -eq '0') {
                    $src2 = $ram[$src2]
                }
                if ($src1 -eq $src2) {
                    $ram[$out] = 1
                }
                else {
                    $ram[$out] = 0
                }
                $pc += 4
                break  
            }
            99 { return "HALT" }
            Default { throw "Not a real OpCode" }
        } 
        
    }
}

function Get-Permutations
{
    param(
        $things = @(0,1,2,3,4),
        $curString = @()
    )

    foreach($i in $things)
    {
        $newString = $curString + $i
        $newThings = $things | Where-Object {$_ -ne $i}
        if($newThings.Length -lt 1)
        {
            $script:perms += ,$newString
            return 
        }

        Get-Permutations -things $newThings -curString $newString | % {,$_}

    }

}

#CODE GOES HERE
$cleanRam = $data -split ','

Get-Permutations

$powers = @()

foreach($perm in $perms)
{
    $output = 0
    foreach($i in (0..4))
    {
        $output = Invoke-Program -ram $cleanRam.Clone() -modules @($perm[$i], $output)
    }
    $powers += $output
}

$maxPower = ($powers | measure -Maximum).Maximum

$script:perms = @()
Get-Permutations -things @(5..9)

Write-Host "Part 1: $maxPower"
Write-Host "Part 2: "
$timer.Stop()
Write-Host "Runtime:"
Write-Host $timer.Elapsed