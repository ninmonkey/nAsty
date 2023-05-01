impo './' -Force -PassThru -Verbose

function PipeWithLabel {
    [Alias('nameIt')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject
    )
    begin {
        $InformationPreference = 'continue'
        $stack = Get-PSCallStack
        $source = $stack[1].Position.Text

        $maybeLabel = Nasty.Find.SingleParent -ScriptContents $Source

        'info: "{0}"' -f @( $MaybeLabel )
        | New-Text -fg 'gray40' -bg 'gray15'
        | Write-Information

        #$one | iot2
    }
    process {
        $InputObject

    }
    end {}

}

$Sample = @'
$employee | PipeWithLabel -Infa 'Continue'
'@

Nasty.Find.SingleParent -ScriptContents $Sample -PassThru
Hr
Nasty.Find.SingleParent -ScriptContents $Sample

# return

$nums = 0..10
$even = $nums | Where-Object { $_ % 2 -eq 0 } | s -first 3
$odd = $nums | Where-Object -Not { $_ % 2 -eq 0 } | s -first 3
# Hr
$even | nameIt | CountOf
# Hr
$odd | nameIt | CountOf
# Hr
$odd | nameIt | CountOf
