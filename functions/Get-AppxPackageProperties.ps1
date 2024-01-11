function Get-AppxPackageProperties {
	<#
	.Synopsis
	   Gets the properties of a specified Appx (.msix) package.
	.DESCRIPTION
	   The Get-AppxPackageProperties cmdlet reads the properties (Name, Version, Publisher and Processor Architecture) of an Appx package (.msix) file.
	.EXAMPLE
	   PS C:\> Get-AppxPackageProperties -Path C:\MSTeams-x64.msix

		Name	Version					Publisher					ProcessorArchitecture
		----	-------					---------					---------------------
		MSTeams	23320.3021.2567.4799	CN=Microsoft Corporation	x64

	.INPUTS
	   [System.IO.FileInfo]
	.OUTPUTS
	   [PSCustomObject]
	.NOTES
	   Author: ChrisMKV
	   v1.0 2024-01-11 Initial version
	#>

	[CmdletBinding()]
	param(
		#Specifies the path to an AppX (.msix) file for which the package details should be retrieved.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({ (Test-Path $_ -ErrorAction Stop) -and ($_.Extension -eq '.msix') })]
		[System.IO.FileInfo]$Path
	)

	BEGIN { Add-Type -Assembly 'System.IO.Compression.FileSystem' }
	PROCESS {
		try {
			#Precreate a temporary file for the AppxManifest we'll extract
			[string]$TempFile = (New-TemporaryFile).FullName

			#Open the .msix file and extract the AppxManifest.xml file
			$MsixFile = [System.IO.Compression.ZipFile]::OpenRead($Path)
			$AppxManifestArchiveEntry = $MsixFile.Entries | Where-Object { $_.Name -eq 'AppxManifest.xml' } | Select-Object -First 1
			if ($null -eq $AppxManifestArchiveEntry) { Throw [System.ApplicationException]::New("The package '{0}' does not contain an AppxManifest.xml file." -f $Path.FullName) }
			$AppxManifestArchiveEntry | ForEach-Object { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $TempFile, $true) }

			#Convert the extracted AppxManifest back to an .xml object for easy access to properties
			[xml]$AppxManifest = Get-Content -Path $TempFile -ErrorAction Stop

			#Output the package information as PSCustomObject
			[PSCustomObject]@{
				PSTypeName            = 'AppXManifestProperties'
				Name                  = $AppXManifest.Package.Identity.Name
				Version               = $AppXManifest.Package.Identity.Version
				Publisher             = $AppXManifest.Package.Identity.Publisher
				ProcessorArchitecture = $AppXManifest.Package.Identity.ProcessorArchitecture
			}
		} catch {
			Write-Error $PSItem
		} finally {
			Remove-Item $TempFile -ErrorAction SilentlyContinue
			if ($MsixFile -is [System.IO.Compression.ZipArchive]) { $MsixFile.Dispose() }
		}
	}
}
