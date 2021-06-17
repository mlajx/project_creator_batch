@echo off
setlocal enabledelayedexpansion
call :GET_PARAMS "%~f0" "%~f1" "%~f2"
call :DEFINE_FOLDER "%~f1" PROJECT_DIR_SELECTED
call :DEFINE_PROJECT_NAME PROJECT_NAME
call :CREATE_FOLDER "%~f1" "%PROJECT_DIR_SELECTED%" "%PROJECT_NAME%"
call :COPY_TEMPLATE_FILES "%~f1" "%~f2" "%PROJECT_DIR_SELECTED%" "%PROJECT_NAME%"
endlocal
goto :EOF

:GET_PARAMS
    setlocal
    set PARAMS_FAIL=0
    if "%~2" EQU "" (
       set PARAMS_FAIL=1
    )
    if "%~3" EQU "" (
       set PARAMS_FAIL=1
    )
    if %PARAMS_FAIL% EQU 1 (
        call :CREATE_SHORTCUT "%~1"
    )
    endlocal
goto :EOF

:CREATE_SHORTCUT
    setlocal
    cls
    set /P SHORTCUT_NAME=Nome do atalho (Project Creator): 
    if not defined SHORTCUT_NAME (
       set SHORTCUT_NAME=Project Creator
    )

    set /P SHORTCUT_DIR=Diretorio do atalho (%USERPROFILE%\Desktop): 
	if not defined SHORTCUT_DIR (
       set SHORTCUT_DIR=%USERPROFILE%\Desktop
    )

    :DEFINE_PROJECTS_DIR_INIT
    set /P PROJECTS_DIR=Diretorio dos projetos (Obrigatorio): 
	if not defined PROJECTS_DIR (
       goto :DEFINE_PROJECTS_DIR_INIT
    )

    :DEFINE_TEMPLATE_DIR_INIT
    set /P TEMPLATE_DIR=Diretorio do template (Obrigatorio): 
	if not defined TEMPLATE_DIR (
       goto :DEFINE_TEMPLATE_DIR_INIT
    )
   
    set /P HOTKEY=Defina uma hotkey (Ex. Ctrl+Alt+e): 
    set /P ICON=Defina um icone (.ico): 

    set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
    
    echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
    echo sLinkFile = "%SHORTCUT_DIR%\%SHORTCUT_NAME%.lnk" >> %SCRIPT%
    echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
    echo oLink.TargetPath = "%~1" >> %SCRIPT%
    echo oLink.Arguments = """%PROJECTS_DIR%"" ""%TEMPLATE_DIR%""" >> %SCRIPT%
    if defined HOTKEY (
       echo oLink.Hotkey = "%HOTKEY%" >> %SCRIPT%
    )
    if defined ICON (
       echo oLink.IconLocation = "%ICON%, 0" >> %SCRIPT%
    )
    echo oLink.Save >> %SCRIPT%
    
    cscript /nologo %SCRIPT%
    del %SCRIPT%
    endlocal
exit

:DEFINE_FOLDER
    setlocal
    :DEFINE_FOLDER_INIT
    cls
    set PROJECTS_COUNTER=1
    for /F "delims=" %%a in ('dir /B /AD "%~1"') do (
        echo !PROJECTS_COUNTER!. %%a
        set PROJECT_!PROJECTS_COUNTER!=%%a
        set /A PROJECTS_COUNTER+=1
    )
    set /P PROJECT_COUNTER_SELECTED=Selecione o diretorio: 

    if not defined PROJECT_%PROJECT_COUNTER_SELECTED% (
        goto :DEFINE_FOLDER_INIT
    )

    set PROJECT_DIR_SELECT=!PROJECT_%PROJECT_COUNTER_SELECTED%!
    endlocal & set %~2=%PROJECT_DIR_SELECT%
goto :EOF

:DEFINE_PROJECT_NAME
    setlocal
    set /P PROJECT_NAME=Digite o nome do projeto: 
    call :GET_DATE DATE_FORMAT
    endlocal & set %~1=%DATE_FORMAT% - %PROJECT_NAME%
goto :EOF

:GET_DATE
    setlocal
    for /F "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set datetime=%%a
    set year=%datetime:~2,4%
    set month=%datetime:~4,2%
    set day=%datetime:~6,2%
    endlocal & set %~1=%year% %month% %day%
goto :EOF

:CREATE_FOLDER
    setlocal
    mkdir "%~1\%~2\%~3"
    endlocal
goto :EOF

:COPY_TEMPLATE_FILES
    setlocal
    robocopy /E "%~2" "%~1\%~3\%~4" > NUL
    endlocal
goto :EOF