# Run inside a clone of https://github.com/soyeon74/test
# powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-volume.ps1
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$path = Join-Path $root "evidence\volume-verification-actual.txt"
$volume = "workstation-evaluation-data"
$first = "workstation-volume-first"
$second = "workstation-volume-second"
$lines = [System.Collections.Generic.List[string]]::new()
function Invoke-DockerLogged([string[]]$ArgsList) {
  $command = "docker " + ($ArgsList -join " ")
  $lines.Add("PS> $command")
  Write-Host "PS> $command"
  $out = & docker @ArgsList 2>&1 | Out-String
  $lines.Add($out.TrimEnd())
  Write-Host $out.TrimEnd()
  if ($LASTEXITCODE -ne 0) { throw "Failed: $command" }
  return $out
}
try {
  $lines.Add("Actual volume verification: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
  Invoke-DockerLogged @("info","--format","{{.ServerVersion}}") | Out-Null
  $existing = & docker ps -a --format "{{.Names}}"
  if (($existing -contains $first) -or ($existing -contains $second)) {
     throw "A test container already exists; inspect before retrying."
  }
  Invoke-DockerLogged @("volume","create",$volume) | Out-Null
  Invoke-DockerLogged @("run","--name",$first,"-v",($volume + ":/data"),"ubuntu:24.04","sh","-c","echo volume-data-verified > /data/proof.txt; cat /data/proof.txt") | Out-Null
  Invoke-DockerLogged @("rm",$first) | Out-Null
  $result = Invoke-DockerLogged @("run","--name",$second,"-v",($volume + ":/data"),"ubuntu:24.04","cat","/data/proof.txt")
  if ($result.Trim() -ne "volume-data-verified") { throw "Data verification did not match" }
  Invoke-DockerLogged @("rm",$second) | Out-Null
  Invoke-DockerLogged @("volume","inspect",$volume) | Out-Null
  $lines.Add("RESULT: PASS — persisted after container recreation")
  Write-Host "RESULT: PASS — persisted after container recreation"
} catch {
  $lines.Add("RESULT: FAIL — " + $_.Exception.Message)
  Write-Host "RESULT: FAIL — $($_.Exception.Message)"
} finally {
  [System.IO.File]::WriteAllLines($path,$lines,[System.Text.UTF8Encoding]::new($false))
  Write-Host "Saved actual log: $path"
}
