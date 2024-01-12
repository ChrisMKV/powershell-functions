BeforeAll { . $PSScriptRoot/Get-AppxPackageProperties.ps1 }
Describe 'Get-AppxPackageProperties' {
	Context 'Parameter validation' {
		It 'should fail parameter validation if -Path is not a valid path' {
			{ Get-AppxPackageProperties -Path 'WRONG' } | Should -Throw
		}
		It 'should fail parameter validation if -Path is not an .msix file' {
			{ Get-AppxPackageProperties -Path $PSCommandPath } | Should -Throw
		}
	}
}