--
--	Created by: Christopher Rodriguez
--	Created on: 12/11/17
--

use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

global destFolder

on run
	try
		--We prompt the user to use a PNG file.
		set thePNG to (choose file with prompt "Choose a PNG file of any size:" of type "png")
		--We create the working folder.
		my createFolder()
		--We set the image sizes needed for the iconset
		my setImages(thePNG)
		--We actually create the iconset
		my createICNS()
		--Cleaning up
		my cleanupFolder()
		--Making a flounder.icns
	on error
		--Something went wrong!
		my errorDialog()
		return
	end try
	--Great job!
	my successDialog()
	return
end run


--Creates a new iconset folder where we will place all sizes needed for the iconset
on createFolder()
	tell application "Finder"
		if exists folder "applet.iconset" of desktop then
			display dialog "A applet.iconset folder already exists" buttons {"Cancel", "Overwrite"} default button "Cancel"
			delete folder "applet.iconset" of desktop
		end if
		set destFolder to (make new folder at desktop with properties {name:"applet.iconset"}) as text
	end tell
end createFolder

--Runs the iconutil tool to create the iconset
on createICNS()
	do shell script "/usr/bin/iconutil -c icns " & (quoted form of text 1 through -2 of POSIX path of destFolder)
end createICNS

--Removes the iconset folder that was used to create the iconset
on cleanupFolder()
	tell application "Finder" to delete destFolder
end cleanupFolder


--Sets the image sizes and calls scaleImage()
on setImages(thePNG)
	set newImage to my scaleImage(thePNG, 1024, "icon_512x512@2x.png")
	set newImage to my scaleImage(thePNG, 512, "icon_512x512.png")
	set newImage to my scaleImage(thePNG, 512, "icon_256x256@2x.png")
	set newImage to my scaleImage(thePNG, 256, "icon_256x256.png")
	set newImage to my scaleImage(thePNG, 256, "icon_128x128@2x.png")
	set newImage to my scaleImage(thePNG, 128, "icon_128x128.png")
	set newImage to my scaleImage(thePNG, 64, "icon_32x32@2x.png")
	set newImage to my scaleImage(thePNG, 32, "icon_32x32.png")
	set newImage to my scaleImage(thePNG, 32, "icon_16x16@2x.png")
	set newImage to my scaleImage(thePNG, 16, "icon_16x16.png")
end setImages

--Actually resizes and sets the name that is defined in setImages()
on scaleImage(thePNG, newSize, name)
	tell application "Image Events"
		set sourceImage to open thePNG
		scale sourceImage to size newSize
		save sourceImage in file ((destFolder as text) & name)
	end tell
end scaleImage

--Displays a success dialog with the output path
on successDialog()
	display dialog "New icon successfully created at: " & (path to desktop as text) & "! " & "If you'd like to use this for an application, copy this to the resource directory."
end successDialog


--Displays an error dialog in case something goes wrong
on errorDialog()
	display dialog "Error creating iconset! I have no idea what happened!"
end errorDialog
