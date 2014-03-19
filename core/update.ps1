
########################
# Script Settings
########################

$frameworkURL = "http://github.com/unitedoperations/core-framework/archive/master.zip"
$frameworkRoot = "core-framework-master\core"
$downloadTmp = "$pwd\tmp"

########################
# Script Start
########################

Write-Host "Core Framework update script started."

if (!(Test-Path $downloadTmp)){
	New-Item $downloadTmp -type directory -Force > $null
}

$updateFile = "$downloadTmp\core_update.zip"
$webclient = New-Object System.Net.WebClient

Write-Host "Downloading Core Framework..."
$webclient.DownloadFile($frameworkURL, $updateFile)

Write-Host "Copying Core Framework..."
$shell = new-object -com shell.application
foreach($item in $shell.NameSpace("$updateFile\$frameworkRoot").items())
{
	$shell.Namespace("$pwd").copyhere($item, 0x54)
}
Remove-Item -Recurse -Force $downloadTmp

Write-Host "Core Framework update completed!"

########################
# Script End
########################

Write-Host "Press any key to continue..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
