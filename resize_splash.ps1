
Add-Type -AssemblyName System.Drawing

$sourcePath = "D:\Heru\Android\sysdosKasir\assets\images\splash.png"
$destPath = "D:\Heru\Android\sysdosKasir\assets\images\splash_padded.png"
$paddingFactor = 1.6 # Increased to 1.6 to prevent cropping (was 1.3) 

try {
    # Load image
    if (-not (Test-Path $sourcePath)) {
        Write-Error "Source file not found: $sourcePath"
        exit 1
    }

    $img = [System.Drawing.Image]::FromFile($sourcePath)
    $width = $img.Width
    $height = $img.Height
    
    Write-Host "Original Size: $width x $height"

    # Calculate new size (Square)
    $maxDim = [Math]::Max($width, $height)
    $newSize = [int][Math]::Round($maxDim * $paddingFactor)
    
    Write-Host "New Size: $newSize x $newSize"

    # Create new empty bitmap
    $bmp = New-Object System.Drawing.Bitmap($newSize, $newSize)
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    
    # Clear with white (Android 12 splash usually has solid bg) or Transparent if needed
    # Using white because the splash background is white. Transparent is safer if bg changes.
    $gfx.Clear([System.Drawing.Color]::White) 

    # Calculate center position
    $x = [int](($newSize - $width) / 2)
    $y = [int](($newSize - $height) / 2)

    # Draw original image in center
    $gfx.DrawImage($img, $x, $y, $width, $height)

    # Save
    $bmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)

    Write-Host "Created padded image at $destPath"
}
catch {
    Write-Error $_
}
finally {
    if ($gfx) { $gfx.Dispose() }
    if ($bmp) { $bmp.Dispose() }
    if ($img) { $img.Dispose() }
}
