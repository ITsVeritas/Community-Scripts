#region Remove Desktop shortcut
## Remove existing Desktop shortcut
$ErrorActionPreference = 'Stop'
Remove-File -Path "$($env:PUBLIC)\desktop\Google Chrome.lnk"
## Prevent creation of the Desktop shortcut
$InstallLocation = Split-Path ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Classes\ChromeHTML\shell\open\command" -Name "(Default)")."(Default)").Split("--")[0].Trim('"',' ') -Parent
$PrefFile = "$($InstallLocation)\master_preferences"
if (Test-Path -Path "$PrefFile" -PathType Leaf) {
    try {
	    $json = Get-Content $PrefFile | ConvertFrom-Json
	    If ($json) {
    	    If ($json.distribution -ne $null) {
        	    $json.distribution | Add-Member -Name "do_not_create_desktop_shortcut" -Value $true -MemberType NoteProperty -Force
    	    }
    	    Else {
        	    $json | Add-Member -Name "distribution" -Value @{"do_not_create_desktop_shortcut"=$true} -MemberType NoteProperty -Force
    	    }
    	    $json | ConvertTo-Json -Depth 100 | Out-File -FilePath $PrefFile -Encoding ASCII
	    }
    }
    catch {
		
	}
}
#endregion
