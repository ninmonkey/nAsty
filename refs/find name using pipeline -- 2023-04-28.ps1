Goto .
New-lie -Name 'sa.Position' -TypeInfo ([Microsoft.Windows.PowerShell.ScriptAnalyzer.Position])
New-lie -Name 'PSTokenType' -TypeInfo ([System.Management.Automation.PSTokenType])
New-lie -Name 'PSParser' -TypeInfo ([System.Management.Automation.PSParser])

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

function PipeWithLabel {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject
    )
    begin {
        $stack = Get-PSCallStack
        $source = $stack[1].Position.Text

        $maybeLabel = Nasty.Find.SingleParent -ScriptContents $Source

        'info: "{0}"' -f @( $MaybeLabel )
        | Write-Information

        #$one | iot2
    }
    process {
        $InputObject

    }
    end {}

}

$Sample = @'
$even | PipeWithLabel -Infa 'Continue'
'@

Nasty.Find.SingleParent -ScriptContents $Sample -PassThru
Hr
Nasty.Find.SingleParent -ScriptContents $Sample

return

$nums = 0..10
$even = $nums | Where-Object { $_ % 2 -eq 0 } | s -first 3
$odd = $nums | Where-Object -Not { $_ % 2 -eq 0 } | s -first 3
Hr
$even | PipeWithLabel -Infa 'Continue'
return
Hr
$odd | PipeWithLabel -Infa 'Continue'
