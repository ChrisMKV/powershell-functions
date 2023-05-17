BeforeAll { ./ConvertFrom-ByteQuantifiedSizeString.ps1 }

Describe 'ConvertFrom-ByteQuantifiedSizeString' {
	Context 'Valid input without parameters' {
		It 'should convert BQS to Integer representing MB value' {
			'20 GB (21,474,836,480 bytes)' | ConvertFrom-ByteQuantifiedSizeString | Should -Be 20480
		}
	}
	Context 'Valid input with parameters' {
		It 'should convert BQS to Integer representing GB value' {
				'20 GB (21,474,836,480 bytes)' | ConvertFrom-ByteQuantifiedSizeString -Unit GB | Should -Be 20
		}
	}
}