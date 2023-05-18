BeforeAll { . $PSScriptRoot/ConvertFrom-ByteQuantifiedSizeString.ps1 }

Describe 'ConvertFrom-ByteQuantifiedSizeString' {
	Context 'Called without Unit parameter' {
		It 'should convert valid BQS to Integer representing MB value' {
			'20 GB (21,474,836,480 bytes)' | ConvertFrom-ByteQuantifiedSizeString | Should -Be 20480
		}
	}
	Context 'Called with Unit parameter' {
		It 'should convert valid BQS to Integer representing Unit value 1' {
			'20 GB (21,474,836,480 bytes)' | ConvertFrom-ByteQuantifiedSizeString -Unit GB | Should -Be 20
		}
		It 'should convert valid BQS to rounded Unit value'{
			'20 GB (21,474,836,480 bytes)' | ConvertFrom-ByteQuantifiedSizeString -Unit TB | Should -Be 0
	}
	Context 'Called with invalid input' {
		It 'should throw non-terminating error on invalid input' {
			{'20' | ConvertFrom-ByteQuantifiedSizeString -ErrorAction Stop} | Should -Throw
		}
	}
	}
}