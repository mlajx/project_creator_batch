@echo off
setlocal enabledelayedexpansion

call :GET_PARAMS "%~f1" "%~f2" PROJECTS_DIR TEMPLATE_DIR
call :DEFINE_FOLDER "%PROJECTS_DIR%" PROJECT_DIR_SELECTED
call :DEFINE_PROJECT_NAME PROJECT_NAME
call :CREATE_FOLDER "%PROJECTS_DIR%" "%PROJECT_DIR_SELECTED%" "%PROJECT_NAME%"
call :COPY_TEMPLATE_FILES "%PROJECTS_DIR%" "%TEMPLATE_DIR%" "%PROJECT_DIR_SELECTED%" "%PROJECT_NAME%"

endlocal
goto :EOF

:GET_PARAMS
    setlocal
    set PARAMS_FAIL=0
    if [%~1] EQU [] (
       set PARAMS_FAIL=1
    )
    if [%~2] EQU [] (
       set PARAMS_FAIL=1
    )
    if %PARAMS_FAIL% EQU 1 (
        call :SHOW_ERROR
    )
    endlocal & (set %~3=%~1) & (set %~4=%~2)
goto :EOF

:SHOW_ERROR
    echo.
    echo.
    echo Por favor defina o caminho dos projetos no atalho do programa
    echo.
    echo Ex. "...project_creator.bar\" ".\projects" ".\templates"
    echo.
    echo.
exit

:DEFINE_FOLDER
    setlocal
    :DEFINE_FOLDER_INIT
    cls
    set PROJECTS_COUNTER=1
    echo "%~1"
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
    set year=%datetime:~0,4%
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