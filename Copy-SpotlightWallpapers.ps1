<#
.SYNOPSIS
   Copies Microsoft Spotlight wallpapers to another folder.

.DESCRIPTION
   This script will look for Microsoft Spotlight wallpapers and copy them to another folder.
   If the destination folder is not specified than the images will be copied to desktop.

.PARAMETER -DestinationPath
  Specifies the path where Spotlight wallpapers must be copied.

.INPUTS
  None. You cannot pipe objects to Copy-Spotlight-Wallpapers.ps1.

.OUTPUTS
  None. Copy-Spotlight-Wallpapers.ps1 does not generate any output.

.EXAMPLE
  C:\PS> .\Copy-Spotlight-Wallpapers.ps1

.EXAMPLE
  C:\PS> .\Copy-Spotlight-Wallpapers.ps1 -DestinationPath C:\Wallpapers

.EXAMPLE
  C:\PS> .\Copy-Spotlight-Wallpapers.ps1 "$env:USERPROFILE\Pictures\Wallpapers"
#>
# destination path parameter
Param([string]$DestinationPath = "$env:USERPROFILE\desktop\spotlight wallpapers")

# create destination folder if it doesn't exist
New-Item -Force -Path $DestinationPath -ItemType "directory" | Out-Null

# hastable of image hashes (and names)
$hashes = @{}
# list of valid image paths
$paths = New-Object Collections.Generic.List[string]

# for each image in destination directory get the hash and add it to hashes list
dir $DestinationPath | foreach {
    $hashes.Add((Get-FileHash $($_.FullName)).hash, $($_.Name))
}


# import
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO

# path of spotlight directory: it contains not only wallpapers but also some other kind of pictures
$spotlightPath = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"

# counters
$copied = $invalid = $existing = 0

# copy images from $spotlightPath to $DestinationPath only if they are wallpapers and not already in $DestinationPath
dir $spotlightPath | foreach {
    $srcImagePath = $_.FullName
	
	Try # check if current file is an image
	{
		$image = New-Object System.Drawing.Bitmap $srcImagePath
	}
	Catch # if not, restart from next iteration
	{
		$invalid++
        Write-Host "The file is not an image!" -ForegroundColor Red 
		return # use 'return' in ForEach-Object loop instead of 'continue' (it would behaves like a 'break')
	}
	
	$width = $image.Width
	$height = $image.Height
	
	# if width > height than it is a wallpaper
	if (($width -gt $height)) {
		# hash of current image
		$hash = (Get-FileHash $srcImagePath).hash
		
		# if hashes dictionary doesn't contain the hash of current image than copy the image to $DestinationPath
		if (-not $hashes.ContainsKey($hash)) {
			# set image name in destination folder to current image name (with .jpg extension if no other extension is specified)
			$dstImageName = "$($_.Name)"
			if ([System.IO.Path]::GetExtension($dstImageName) -eq "") {
				$dstImageName += ".jpg"
			}
			# set path of current image in destination folder
			$dstImagePath = "$DestinationPath\$dstImageName"
			# add hash (and name) of current image to hashes dictionary and destination path to path list
			$hashes.Add($hash, $dstImageName)
			$paths.Add($dstImagePath)
			# copy current image
			Copy-Item -Path $srcImagePath -Destination $dstImagePath          

			$copied++
			Write-Host "Image copied successfully to destination folder! [$dstImageName]" -ForegroundColor Green
		}
		# else it means that current image is already in $DestinationPath
		else {
			$existing++
			Write-Host "Image already in the destination folder... [$($hashes[$hash])]" -ForegroundColor Gray 
		}
		
	}
	# else the current image is not a valid wallpaper
	else {
		$invalid++
		Write-Host "The image is not a wallpaper!" -ForegroundColor Red 
	}  
}

Write-Host
Write-Host ">> $copied images copied in $DestinationPath." -ForegroundColor Green
Write-Host ">> $existing images already in $DestinationPath." -ForegroundColor Gray
Write-Host ">> $invalid invalid images." -ForegroundColor Red
Write-Host

if ($copied -eq 0) {
    Write-Host "Press any key to exit: " -NoNewLine
    $host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown") | Out-Null
}
else {
    Write-Host "Do you want to view the copied images? (y/N): " -NoNewLine
    $show = [Char]::ToLower($host.UI.RawUI.ReadKey().Character)
    if ($show -eq 'y') {
        foreach ($path in $paths) {
            Start-Process $path
        }
    }
}
