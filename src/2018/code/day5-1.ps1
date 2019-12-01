$inputPath = ""
[string]$data = Get-Content $inputPath

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()



do {
    $lastLength = $data.Length
    $data = $data.Replace('aA','').Replace('Aa','').Replace('bB','').Replace('Bb','').Replace('cC','').Replace('Cc','').Replace('dD','').Replace('Dd','').Replace('eE','').Replace('Ee','').Replace('fF','').Replace('Ff','').Replace('gG','').Replace('Gg','').Replace('hH','').Replace('Hh','').Replace('iI','').Replace('Ii','').Replace('jJ','').Replace('Jj','').Replace('kK','').Replace('Kk','').Replace('lL','').Replace('Ll','').Replace('mM','').Replace('Mm','').Replace('nN','').Replace('Nn','').Replace('oO','').Replace('Oo','').Replace('pP','').Replace('Pp','').Replace('qQ','').Replace('Qq','').Replace('rR','').Replace('Rr','').Replace('sS','').Replace('Ss','').Replace('tT','').Replace('Tt','').Replace('uU','').Replace('Uu','').Replace('vV','').Replace('Vv','').Replace('wW','').Replace('Ww','').Replace('xX','').Replace('Xx','').Replace('yY','').Replace('Yy','').Replace('zZ','').Replace('Zz','')
} while ($data.Length -lt $lastLength)

Write-Host $data.Length
$timer.Stop()
Write-Host $timer.Elapsed