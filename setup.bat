@echo off

SET DEV_DIR=C:\Users\Lenovo\dev
SET JDK_ZIP=%DEV_DIR%\jdk8.zip
SET TOMCAT_ZIP=%DEV_DIR%\tomcat9.zip
SET JDK_HOME=%DEV_DIR%\jdk8
SET TOMCAT_HOME=%DEV_DIR%\tomcat9

echo.
echo ====================================================
echo  Student Management System — One-Time Setup
echo ====================================================
echo.

IF NOT EXIST "%DEV_DIR%" mkdir "%DEV_DIR%"

IF EXIST "%JDK_HOME%\bin\javac.exe" (
    echo [JDK] Already extracted — skipping.
) ELSE (
    IF NOT EXIST "%JDK_ZIP%" (
        echo [JDK] Downloading JDK 8...
        powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u422-b05/OpenJDK8U-jdk_x64_windows_hotspot_8u422b05.zip' -OutFile '%JDK_ZIP%' -UseBasicParsing"
        IF ERRORLEVEL 1 ( echo [ERROR] JDK download failed. & pause & exit /b 1 )
        echo [JDK] Download complete.
    )
    echo [JDK] Extracting...
    powershell -Command "Expand-Archive -Path '%JDK_ZIP%' -DestinationPath '%DEV_DIR%\jdk8_tmp' -Force"
    FOR /D %%i IN ("%DEV_DIR%\jdk8_tmp\*") DO (
        move "%%i" "%JDK_HOME%" >nul
    )
    rmdir /s /q "%DEV_DIR%\jdk8_tmp" 2>nul
    echo [JDK] Extracted to %JDK_HOME%
)

IF EXIST "%TOMCAT_HOME%\bin\startup.bat" (
    echo [Tomcat] Already extracted — skipping.
) ELSE (
    IF NOT EXIST "%TOMCAT_ZIP%" (
        echo [Tomcat] Downloading Apache Tomcat 9...
        powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98-windows-x64.zip' -OutFile '%TOMCAT_ZIP%' -UseBasicParsing"
        IF ERRORLEVEL 1 ( echo [ERROR] Tomcat download failed. & pause & exit /b 1 )
        echo [Tomcat] Download complete.
    )
    echo [Tomcat] Extracting...
    powershell -Command "Expand-Archive -Path '%TOMCAT_ZIP%' -DestinationPath '%DEV_DIR%\tomcat9_tmp' -Force"
    FOR /D %%i IN ("%DEV_DIR%\tomcat9_tmp\*") DO (
        move "%%i" "%TOMCAT_HOME%" >nul
    )
    rmdir /s /q "%DEV_DIR%\tomcat9_tmp" 2>nul
    echo [Tomcat] Extracted to %TOMCAT_HOME%
)

SET JAVA_HOME=%JDK_HOME%

echo.
echo ====================================================
echo  Setup complete!
echo  Now run:  build-and-run.bat
echo ====================================================
echo.
pause
