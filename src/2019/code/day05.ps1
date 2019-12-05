$data = Get-Content (Join-Path $PSScriptRoot -ChildPath "..\input\day05.txt")

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()


function Invoke-Program {
    param (
        [long[]]$ram,
        [long]$module
    )

    
    $pc = 0

    while ($true) {
        $op = $ram[$pc] % 100

        [string]$modes = "{0:000}" -f [Math]::Floor($ram[$pc] / 100)  #pads leading zeroes to three units

        switch ($op) {
            1 {
                #add two and store
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
            2 {
                #mult two and store  
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
            3 {
                #take input and write to disk
                $ram[$ram[$pc + 1]] = $module
                $pc += 2
                break
            } 
            4 {
                #out to screen
                if ($modes[-1] -eq '0') {
                    
                    Write-Host $ram[$ram[$pc + 1]]
                } 
                else {
                    Write-Host $ram[$pc + 1]
                }

                $pc += 2
                break
            } 
            5 {
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
            6 {
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
            7 {
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
            8 {
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

[long[]]$baseRam = $data.Split(',') 
Write-Host "Part1: "
[long[]]$cleanRam = $baseRam.Clone()
$testInput = 1
Invoke-Program -ram $cleanRam  -module $testInput

Write-Host "Part 2:"
[long[]]$cleanRam = $baseRam.Clone()
$testInput = 5
Invoke-Program -ram $cleanRam -module $testInput

$timer.Stop()
Write-Host $timer.Elapsed