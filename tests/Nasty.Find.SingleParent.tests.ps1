BeforeAll {
    # Import-Module '../Nasty.psm1' -passThru -Force
    # remove-module 'nAsty' -ea 'ignore'
    # goto .
    #
    Import-Module ../nAsty.psm1 -Force -Verbose -PassThru
}

Describe 'Nasty.Find.SingleParent' {
    it 'FromEmpty' {
        Nasty.Find.SingleParent -ScriptContents ''
        | Should -BeLike ''
    }
    Context 'FromPipeline-as-SingleToken' {
        It 'SingleVarible.FromScriptBlock' {
            $AstSample = { $employee | PipeWithLabel -Infa 'Continue' }.Ast
            $AstStr = $AstSample.EndBlock.Extent.Text

            Nasty.Find.SingleParent -ScriptContents $AstStr
            | Should -BeExactly 'employee'
        }
        It 'SingleVarible.FromText' {
            $AstStr = '$users | PipeWithLabel -Infa "Continue"'
            Nasty.Find.SingleParent -ScriptContents $AstStr
            | Should -BeExactly 'users'
        }
    }
    Context 'FromPipeline-as-VariableTokenList' {
        It 'SingleVarible.FromScriptBlock' {
            $AstSample = { $employee, $dates | PipeWithLabel -Infa 'Continue' }.Ast
            $AstStr = $AstSample.EndBlock.Extent.Text

            Nasty.Find.SingleParent -ScriptContents $AstStr
            | Should -beIn 'employee', 'dates'
        }
    }
}