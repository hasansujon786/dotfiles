@ECHO OFF
REM
REM Yazi Archive Extract script
REM
REM Use 7zip for extractor
REM
REM Extract archive contents into destination folder
REM with the same name as the archive file
REM

7z x "%~f1" -o"%~n1"
sleep 2
