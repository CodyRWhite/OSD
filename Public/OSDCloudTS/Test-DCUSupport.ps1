function Test-DCUSupport {
    $SystemSKUNumber = (Get-CimInstance -ClassName Win32_ComputerSystem).SystemSKUNumber
    $CabPathIndex = "$env:temp\DellCabDownloads\CatalogIndexPC.cab"
    $DellCabExtractPath = "$env:temp\DellCabDownloads\DellCabExtract"
    # Pull down Dell XML CAB used in Dell Command Update ,extract and Load
    if (!(Test-Path $DellCabExtractPath)){New-Item -Path $DellCabExtractPath -ItemType Directory -Force | Out-Null}
    Invoke-WebRequest -Uri "https://downloads.dell.com/catalog/CatalogIndexPC.cab" -OutFile $CabPathIndex -UseBasicParsing -ErrorAction SilentlyContinue
    New-Item -Path $DellCabExtractPath -ItemType Directory -Force | Out-Null
    $Expand = expand $CabPathIndex $DellCabExtractPath\CatalogIndexPC.xml
    [xml]$XMLIndex = Get-Content "$DellCabExtractPath\CatalogIndexPC.xml" -ErrorAction SilentlyContinue
    #Dig Through Dell XML to find Model of THIS Computer (Based on System SKU)
    $XMLModel = $XMLIndex.ManifestIndex.GroupManifest | Where-Object {$_.SupportedSystems.Brand.Model.systemID -match $SystemSKUNumber}
    if ($XMLModel){$DCUSupportedDevice = $true}
    else {$DCUSupportedDevice = $false}
    Return $DCUSupportedDevice
    }