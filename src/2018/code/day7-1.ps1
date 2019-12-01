class node {
    [System.Collections.ArrayList]$prereqs
    [System.Collections.ArrayList]$followers
    [string]$ID

    node([string]$ID) {
        $this.ID = $ID
        $this.prereqs = New-Object System.Collections.ArrayList
        $this.followers = New-Object System.Collections.ArrayList
    }
}

$inputPath = ""
$data = Get-Content $inputPath

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
$nodes = @{}
$readies = New-Object System.Collections.ArrayList
foreach($line in $data) {
    [string]$pre, [string]$post = $line.split(' ')[1], $line.split(' ')[7]
    if($null -eq $nodes[$pre]) {
        $nodes[$pre] = [node]::new($pre)
        $readies.Add($nodes[$pre]) | Out-null
    }
    if($null -eq $nodes[$post]) {
        $nodes[$post] = [node]::new($post)
    }
    $nodes[$pre].followers.Add($nodes[$post]) | Out-Null
    $nodes[$post].prereqs.Add($nodes[$pre]) | Out-Null
    if($readies -contains $nodes[$post]) {
        $readies.Remove($nodes[$post])
    }
}



[System.Text.StringBuilder]$sb = New-Object System.text.StringBuilder
while($readies.Count -gt 0) {
    [System.Collections.ArrayList]$readies = $readies | Sort-Object -Property ID
    $sb.Append($readies[0].ID)
    foreach($node in $readies[0].followers) {
        $node.prereqs.Remove($readies[0])
        if($($node.prereqs.Count) -eq 0) {
            $readies.add($node) | Out-Null
        }
    }
    $readies.RemoveAt(0)
}

write-host $sb.ToString()

$timer.Stop()
Write-Host $timer.Elapsed