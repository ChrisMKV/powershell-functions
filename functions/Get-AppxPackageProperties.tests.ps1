BeforeAll { . $PSScriptRoot/Get-AppxPackageProperties.ps1 }
Describe 'Get-AppxPackageProperties' {
	Context 'Fails parameter validation' {
		It 'should fail parameter validation if -Path is not a valid path' {
			{ Get-AppxPackageProperties -Path 'WRONG' } | Should -Throw
		}
	}
}