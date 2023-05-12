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
        | Join-String -op (Hr 1)
        | Write-Information

        #$one | iot2
    }
    process {
        $InputObject

    }
    end {}

}

# $AstSample = { $employee, $dates | PipeWithLabel -Infa 'Continue' }.Ast
# $AstStr = $AstSample.EndBlock.Extent.Text

# Nasty.Find.SingleParent -ScriptContents $AstStr
# | Should -BeIn 'employee', 'dates'

throw 'don''t forget to memove this throw'
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

0..4 | join.Md.TableRow | NameIt

$x = 0..4; $y = 'a'..'e'
@($x; $y ) | NameIt | join.Md.TableRow
Hr

@'
examples:

    $x = 0..4; $y = 'a'..'e';
    @($x; $y ) | NameIt | join.Md.TableRow

    ---------------------------------------------
    info: ""
    | ␀ | 1 | 2 | 3 | 4 |

    ---------------------------------------------
    info: "y"
    | ␀ | 1 | 2 | 3 | 4 | a | b | c | d | e |

'@

