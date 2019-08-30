# Copy-SpotlightWallpapers
   Copies Microsoft Spotlight wallpapers to another folder.

   This script will look for Microsoft Spotlight wallpapers and copy them to another folder.
   If the destination folder is not specified than the images will be copied to desktop.
   
## Usage
**Parameter:** `-DestinationPath`

  Specifies the path where Spotlight wallpapers must be copied.

## Examples
-  `C:\PS> .\Copy-Spotlight-Wallpapers.ps1`

Start copying Spotlight wallpapers to Desktop.

-  `C:\PS> .\Copy-Spotlight-Wallpapers.ps1 -DestinationPath C:\Wallpapers`

Start copying Spotlight wallpapers to the specified destination path `C:\Wallpapers`.
`-DestinationPath` is not required, as you can see in the next example.
 
-  `C:\PS> .\Copy-Spotlight-Wallpapers.ps1 "$env:USERPROFILE\Pictures\Wallpapers"`

Start copying Spotlight wallpapers to the specified destination path without specifieng `-DestinationPath`.
The path is given using environment variable `$env:USERPROFILE` which is the path of current user.
