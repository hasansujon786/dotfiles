@ECHO OFF
REM
REM Yazi file reveal script
REM
REM https://superuser.com/questions/489240/how-to-get-filename-only-without-path-in-windows-command-line

REM explorer /select,""%~1""
explorer /select,%~1
