# Copy-SpotlightWallpapers
## Introduction
   This is my first Powershell script. 
   I wanted to save a permanent copy of Microsoft Spotlight wallpapers. 
   Spotlight wallpapers are temporarily saved in the folder `$env:USERPROFILE\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets` without an extension and with other images which I don't bother about (e.g. icons, vertical wallpapers, ...). This script copies the valid wallpapers to another folder, renaming them with `.jpg` extension. The destination path can be specified by the user, otherwise the default folder is located in desktop and named `spotlight wallpapers`. Duplicate files are recognized comparing their hashes and they're are not copied.

## Description
   Copies Microsoft Spotlight wallpapers to another folder.

   This script will look for Microsoft Spotlight wallpapers and copy them to another folder.
   If the destination folder is not specified than the images will be copied to desktop.
   
## Usage
**Parameter:** `-DestinationPath`

  Specifies the path where Spotlight wallpapers must be copied.

## Examples
-  `C:\PS> .\Copy-Spotlight-Wallpapers.ps1`

Starts copying Spotlight wallpapers to a folder named `spotlight wallpapers` located in desktop.

-  `C:\PS> .\Copy-Spotlight-Wallpapers.ps1 -DestinationPath C:\Wallpapers`

Starts copying Spotlight wallpapers to the specified destination path `C:\Wallpapers`.
`-DestinationPath` is not required, as you can see in the next example.
 
-  `C:\PS> .\Copy-Spotlight-Wallpapers.ps1 "$env:USERPROFILE\Pictures\Wallpapers"`

Starts copying Spotlight wallpapers to the specified destination path without specifieng `-DestinationPath`.
The path is given using environment variable `$env:USERPROFILE` which is the path of current user.
