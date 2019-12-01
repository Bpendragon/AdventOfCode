Class LinkedListNode {
    [uint64]$val
    [LinkedListNode]$next
    [LinkedListNode]$previous
    LinkedListNode([uint64] $val) {
        $this.val = $val
    }

}

Class CircularLinkedList {
    [LinkedListNode]$Head  #a convention so we can find our way around starting at 0
    [uint64] $Count


    CircularLinkedList([uint64]$start) {
        $this.Head = [LinkedListNode]::new($start)
        $this.Head.next = $this.Head
        $this.Head.previous = $this.Head
        $this.count = 1
    }

    InsertAfter([LinkedListNode]$node, [uint64]$val) {
        $newNode = [LinkedListNode]::new($val) 
        $tmp = $node.next
        $node.next = $newNode
        $newNode.previous = $node
        $newNode.next = $tmp
        $tmp.previous = $newNode
        $this.count++
    }

    Delete([LinkedListNode]$node) {
        $prev = $node.previous
        $nex = $node.next

        $prev.next = $nex
        $nex.previous = $prev
        $this.Count--
    }
}

$numplayers = 411
$finalMarble = 7105800



$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$circle = [CircularLinkedList]::new(0)
$playerScores = New-Object 'uint64[]' $numPlayers

$cur = $circle.Head
$curPlayer = 0
foreach($i in (1..$finalMarble)) {
    if(($i % 23) -eq 0) {
        $playerScores[$curPlayer % $numplayers] += [uint64]$i #I don't think the cast on this or the next line are strictly needed, but I'm  doing it for safety.
        $playerScores[$curPlayer % $numplayers] += [uint64]$cur.previous.previous.previous.previous.previous.previous.previous.val
        $cur = $cur.previous.previous.previous.previous.previous.previous
        $circle.Delete($cur.previous)
    } else {
        $circle.InsertAfter($cur.next, $i)
        $cur = $cur.next.next
    }
    $curplayer++
}

$max = $playerScores | Measure -Maximum
Write-host $max.Maximum
$timer.Stop()
Write-Host $timer.Elapsed