function ConvertFrom-ByteQuantifiedSizeString {
	<#
.SYNOPSIS
Converts strings containing "byte-quantified size" values into a numerical value
.DESCRIPTION
Many Exchange commands return size information using the "byte-quantified size" type, for example: "(Get-MailboxDatabase).ProhibitSendQuota" returns "20 GB (21,474,836,480 bytes)".
In Exchange Management Shell, it is possible to use .ToMB() and similar methods to obtain the actual numerical value. When in an Exchange Remote PowerShell session, the value is a simple string and cannot be directly used in calculations.
This function converts a string representing a BQS into a numerical value of the specified size unit (Default is Megabytes) which can be used for calculations.
.EXAMPLE
C:\> (Get-MailboxDatabase DB01).ProhibitSendQuota | ConvertFrom-ByteQuantifiedSizeString
Converts the "ProhibitSendQuota" value from "20 GB (21,474,836,480 bytes)" to "20480" (Value represented in Megabytes)
.EXAMPLE
C:\> ConvertFrom-ByteQuantifiedSizeString -InputObject (Get-MailboxDatabase DB01).ProhibitSendQuota -Unit GB
Converts the "ProhibitSendQuota" value from "20 GB (21,474,836,480 bytes)" to "20" (Value represented in Gigabytes)
.NOTES
Author: ChrisMKV
2023-05-17 v1.0 Initial version
#>

	[CmdletBinding()]
	[OutputType([Int64])]

	param(
		#A string with a "byte-quantified size" type value. Example: "20 GB (21,474,836,480 bytes)"
		[parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[validatepattern('^\d+\s{1}(KB|MB|GB|TB)\s{1}\([0-9,]+\w{1} bytes\)$')]
		[string[]]$InputObject,

		#Size unit to apply for the conversion. Default is MB - Megabytes.
		[parameter(Position = 1)]
		[validateset('KB', 'MB', 'GB', 'TB')]
		[string]$Unit = 'MB'
	)

	Process {
		$InputObject | ForEach-Object {
			[int](($_ -replace '.*\(| bytes\).*|,') / ([string]$Unit = '1' + $Unit))
		}
	}
}