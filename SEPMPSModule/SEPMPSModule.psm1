# --- Expose each Public and Private function as part of the module
foreach ($PrivateFunction in Get-ChildItem -Path "$($PSScriptRoot)\Functions\Private\*.ps1" -Recurse -Verbose:$VerbosePreference) {

    . $PrivateFunction.FullName
}

foreach ($Publicfunction in Get-ChildItem -Path "$($PSScriptRoot)\Functions\Public\*.ps1" -Recurse -Verbose:$VerbosePreference) {

    . $PublicFunction.FullName
    $BaseName = [System.IO.Path]::GetFileNameWithoutExtension($PublicFunction)
    Export-ModuleMember -Function ($BaseName)
}
