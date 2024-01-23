:: https://pureinfotech.com/exclude-files-folders-robocopy-windows-10/

@echo off

SET SOURCE="%cd%\A"
SET DESTINATION="%cd%\B"

:: Clone directory including files
:: robocopy %SOURCE% %DESTINATION% /e

:: Clone directory
:: robocopy %SOURCE% %DESTINATION% /e /xf *

:: Exclude folders
:: robocopy %SOURCE% %DESTINATION% /e /xf * /xd folder1* folder2*

:: Exclude a file extension
:: robocopy %SOURCE% %DESTINATION% /e /xf *.json

:: Exclude a filename
:: robocopy %SOURCE% %DESTINATION% /e /xf filename*

:: Copy and paste a file to a directory
:: robocopy %SOURCE% %DESTINATION% copy_this.txt

pause