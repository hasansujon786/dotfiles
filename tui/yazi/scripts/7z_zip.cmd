@ECHO OFF
REM
REM Yazi Archive Create script
REM
REM Use 7zip to create zip archive
REM
REM Creates a zip file with the same name as the selected file/folder
REM

7z a -tzip "%~n1.zip" "%~1"
timeout /t 2 /nobreak >nul
