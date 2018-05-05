# Get a list of the included scripts and import them
$ModulePath = Split-Path $MyInvocation.MyCommand.Path -Parent
Get-ChildItem -Path $ModulePath -Filter *.ps1 -Recurse | ForEach-Object {
    if ($_.FullName -notlike '*.Tests.ps1') {
        . $_.FullName
    }
}