#.SYNOPSIS
#Sends SMTP email via the Hub Transport server
#
#.EXAMPLE
#.Send-Email.ps1 -To "administrator@exchangeserverpro.net" -Subject "Test email" -Body "This is a test"
#	 
 
param(
[string]$from,
[string]$tostr,
[string]$ccstr,
[string]$subject,
[string]$body
)
 
$smtpServer = "10.238.1.9"

 Try 
 {
	[string[]]$To = $tostr.Split(',')
	[string[]]$Cc = $ccstr.Split(',')
	send-mailmessage -from $from -to $To -subject $subject -body $body -BodyAsHtml -cc $Cc -smtpServer $smtpServer -Encoding ([System.Text.Encoding]::UTF8)
	exit 0
 }
 Catch {
	exit -1
 }