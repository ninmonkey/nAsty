try {
    Goto . # alias ensures loaded
    New-lie -Name 'sa.Position' -TypeInfo ([Microsoft.Windows.PowerShell.ScriptAnalyzer.Position])
    New-lie -Name 'PSTokenType' -TypeInfo ([System.Management.Automation.PSTokenType])
    New-lie -Name 'PSParser' -TypeInfo ([System.Management.Automation.PSParser])
} catch {
    throw "MissingLies: $PSCommandPath"
}

function Nasty.Find.SingleParent {
    <#
    .SYNOPSIS
        Find the name of a single parent of a Nin.Ast
    #>
    param(
        $ScriptContents,
        [switch]$PassThru
    )
    $err_parse = $null
    $tokens = [System.Management.Automation.PSParser]::Tokenize($ScriptContents, [ref]$err_parse)

    [string]$Label? = [string]::Empty

    # "assert" type
    $Label? = $tokens
    | Select-Object -First 1
    | Where-Object Type -EQ 'variable'
    | ForEach-Object Content

    if ($err_parse) {
        'Failed Parsing: {0}' -f @( $ScriptContents ) | Write-Error
    }

    if ($PassThru) {
        return [PSCustomObject]@{
            RawSource = $ScriptContents
            Label     = $label? ?? ''
            Tokens    = $Tokens
            Errors    = $err_parse | Select-Object -ExpandProperty Token -Property Message
        }
    }

    $Label?
}
