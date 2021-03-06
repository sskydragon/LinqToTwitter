# Example command-line:
# > .\build.ps1 4.0.1

&("C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe") LinqToTwitter.proj -p:Version=$args

$DeploymentFolder = "C:\Projects\NuGet\LinqToTwitter-v4\"
$SourceFolderBase = $DeploymentFolder + "v" + $args + "\lib\"

$Date = Get-Date
$FileDate = $Date.ToString("yyyyMMdd")

$FolderNames =
@(
	"net45",
    "uap10.0",
    "xamarin.ios",
    "monotouch",
    "monoandroid",
    "portable-win8+net45+wp8"
)

$ZipFileName = $DeploymentFolder + "LinqToTwitter_" + $FileDate + ".zip"

set-content $ZipFileName ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18)) 
(dir $ZipFileName).IsReadOnly = $false

$ZipFile = (new-object -com Shell.Application).Namespace($ZipFileName)
$activity = 'Zipping file to ' + $ZipFile.Name + ': '

for ($i=0; $i -lt $FolderNames.Length; $i++)
{
	$CurrentFolder = $SourceFolderBase + $FolderNames[$i]
	$SourceFolder = Get-Item $CurrentFolder
	Write-Progress -activity $activity -status $SourceFolder.FullName
	$ZipFile.CopyHere($SourceFolder.FullName)
	Start-sleep -milliseconds 500
}

$SourceFolder = Get-Item $SourceFolderBase
Write-Progress -activity $activity -status $SourceFolder.FullName

Start-sleep -milliseconds 500

$ReadMe = $DeploymentFolder + "ReadMe.txt"
$ReadMeFile = Get-Item $ReadMe
$ZipFile.CopyHere($ReadMeFile.FullName)
Start-sleep -milliseconds 500
