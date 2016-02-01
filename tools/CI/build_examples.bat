@echo off
set PATH=C:\git\bin;C:\git\usr\bin;%PATH%

bash %~dp0build_examples.sh %* || goto ERROR
exit /b 0

:ERROR
echo Make sure you have bash in path to run this script!
exit /b 1
