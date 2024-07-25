function New-SymLink ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target -Force
}

Get-ChildItem -file -recurse "C:\Program Files\Notepad Next\" | Where-Object -FilterScript {-not $_.Extension.Contains("exe")} | ForEach-Object {
    $filepath = ("C:\Windows\"+$_.FullName.Replace("C:\Program Files\Notepad Next\",""))
    $folder = Split-Path -parent $filepath
    if(-not (Test-Path -Path $folder))
    {
        New-Item -ItemType Directory -Path $folder
    }
    takeown /F "$filepath" /A
    New-SymLink $_.FullName $filepath
}

Get-ChildItem -file -recurse "C:\Program Files\Notepad Next\" | Where-Object -FilterScript {-not $_.Extension.Contains("exe")} | ForEach-Object {
    $filepath = ("C:\Windows\System32\"+$_.FullName.Replace("C:\Program Files\Notepad Next\",""))
    $folder = Split-Path -parent $filepath
    if(-not (Test-Path -Path $folder))
    {
        New-Item -ItemType Directory -Path $folder
    }
    takeown /F "$filepath" /A
    New-SymLink $_.FullName $filepath
}

takeown /F "C:\Windows\notepad.exe" /A
takeown /F "C:\Windows\System32\notepad.exe" /A
$tempfile = New-TemporaryFile
Get-Acl -Path $tempfile.FullName | Set-Acl -Path "C:\Windows\notepad.exe"
Get-Acl -Path $tempfile.FullName | Set-Acl -Path "C:\Windows\System32\notepad.exe"
Move-Item "C:\Windows\notepad.exe" "C:\notepad.exe.bak" -Force
Move-Item "C:\Windows\System32\notepad.exe" "C:\notepad.exe.bak" -Force
New-SymLink "C:\Program Files\Notepad Next\NotepadNextWrapper.exe" "C:\Windows\notepad.exe"
New-SymLink "C:\Program Files\Notepad Next\NotepadNextWrapper.exe" "C:\Windows\System32\notepad.exe"