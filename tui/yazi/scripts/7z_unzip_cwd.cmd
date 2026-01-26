@ECHO OFF
REM
REM Yazi Archive Extract script
REM
REM Use 7zip for extractor
REM
REM Extract archive contents into destination folder

7z x "%~1"
timeout /t 2 /nobreak >nul
