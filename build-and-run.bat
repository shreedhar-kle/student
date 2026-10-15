@echo off
setlocal

REM ====================================================
REM Student Management System - Build and Deploy
REM Java 8 + Apache Tomcat 9
REM ====================================================

REM Project configuration
set "PROJECT_DIR=%~dp0"
set "JDK_HOME=C:\Users\Lenovo\dev\jdk8"
set "TOMCAT_HOME=C:\Users\Lenovo\dev\tomcat9"

set "SRC_DIR=%PROJECT_DIR%src"
set "WEB_DIR=%PROJECT_DIR%WebContent"
set "BUILD_DIR=%PROJECT_DIR%build"
set "CLASSES_DIR=%BUILD_DIR%\WEB-INF\classes"

set "SERVLET_JAR=%TOMCAT_HOME%\lib\servlet-api.jar"
set "DEPLOY_DIR=%TOMCAT_HOME%\webapps\StudentManagementSystem"

REM ====================================================
REM Configure Java and Tomcat
REM ====================================================

set "JAVA_HOME=%JDK_HOME%"
set "JRE_HOME=%JDK_HOME%\jre"
set "CATALINA_HOME=%TOMCAT_HOME%"
set "CATALINA_BASE=%TOMCAT_HOME%"

echo.
echo ====================================================
echo   Student Management System - Build and Deploy
echo ====================================================
echo.

REM ====================================================
REM Step 1: Check Java installation
REM ====================================================

echo [CHECK] Checking Java installation...

if not exist "%JDK_HOME%\bin\javac.exe" (
    echo [ERROR] javac.exe not found:
    echo %JDK_HOME%\bin\javac.exe
    pause
    exit /b 1
)

if not exist "%JRE_HOME%\bin\java.exe" (
    echo [ERROR] java.exe not found:
    echo %JRE_HOME%\bin\java.exe
    pause
    exit /b 1
)

REM ====================================================
REM Step 2: Check Tomcat installation
REM ====================================================

echo [CHECK] Checking Tomcat installation...

if not exist "%TOMCAT_HOME%\bin\catalina.bat" (
    echo [ERROR] catalina.bat not found:
    echo %TOMCAT_HOME%\bin\catalina.bat
    pause
    exit /b 1
)

if not exist "%SERVLET_JAR%" (
    echo [ERROR] servlet-api.jar not found:
    echo %SERVLET_JAR%
    pause
    exit /b 1
)

if not exist "%WEB_DIR%\WEB-INF\web.xml" (
    echo [ERROR] WebContent\WEB-INF\web.xml not found.
    pause
    exit /b 1
)

REM ====================================================
REM Step 3: Clean previous build
REM ====================================================

echo.
echo [1/4] Cleaning previous build...

if exist "%BUILD_DIR%" (
    rmdir /s /q "%BUILD_DIR%"
)

if exist "%BUILD_DIR%" (
    echo [ERROR] Could not clean the build directory.
    pause
    exit /b 1
)

mkdir "%CLASSES_DIR%"

if errorlevel 1 (
    echo [ERROR] Could not create build directories.
    pause
    exit /b 1
)

REM ====================================================
REM Step 4: Compile Java source files
REM ====================================================

echo.
echo [2/4] Compiling Java sources...

"%JDK_HOME%\bin\javac.exe" -encoding UTF-8 -cp "%SERVLET_JAR%" -d "%CLASSES_DIR%" -sourcepath "%SRC_DIR%" ^
    "%SRC_DIR%\com\studentmanagement\beans\StudentBean.java" ^
    "%SRC_DIR%\com\studentmanagement\beans\UserBean.java" ^
    "%SRC_DIR%\com\studentmanagement\dao\StudentRepository.java" ^
    "%SRC_DIR%\com\studentmanagement\servlets\LoginServlet.java" ^
    "%SRC_DIR%\com\studentmanagement\servlets\LogoutServlet.java" ^
    "%SRC_DIR%\com\studentmanagement\servlets\DashboardServlet.java" ^
    "%SRC_DIR%\com\studentmanagement\servlets\ViewStudentsServlet.java" ^
    "%SRC_DIR%\com\studentmanagement\servlets\AddStudentServlet.java" ^
    "%SRC_DIR%\com\studentmanagement\servlets\EditStudentServlet.java" ^
    "%SRC_DIR%\com\studentmanagement\servlets\UpdateStudentServlet.java" ^
    "%SRC_DIR%\com\studentmanagement\servlets\DeleteStudentServlet.java" ^
    "%SRC_DIR%\com\studentmanagement\servlets\SearchStudentServlet.java"

if errorlevel 1 (
    echo.
    echo [ERROR] Java compilation failed.
    pause
    exit /b 1
)

echo Compilation successful.

REM ====================================================
REM Step 5: Copy web resources
REM ====================================================

echo.
echo [3/4] Copying web resources...

xcopy "%WEB_DIR%\*" "%BUILD_DIR%\" /E /I /Y /Q

if errorlevel 1 (
    echo [ERROR] Failed to copy web resources.
    pause
    exit /b 1
)

REM Verify web.xml exists in the build
if not exist "%BUILD_DIR%\WEB-INF\web.xml" (
    echo [ERROR] web.xml missing from build.
    pause
    exit /b 1
)

REM ====================================================
REM Step 6: Deploy application to Tomcat
REM ====================================================

echo.
echo [4/4] Deploying application to Tomcat...

if exist "%DEPLOY_DIR%" (
    echo Removing previous deployment...
    rmdir /s /q "%DEPLOY_DIR%"
)

if exist "%DEPLOY_DIR%" (
    echo [ERROR] Could not remove previous deployment.
    echo Check whether another process is using the directory.
    pause
    exit /b 1
)

xcopy "%BUILD_DIR%\*" "%DEPLOY_DIR%\" /E /I /Y /Q

if errorlevel 1 (
    echo [ERROR] Deployment failed.
    pause
    exit /b 1
)

if not exist "%DEPLOY_DIR%\WEB-INF\web.xml" (
    echo [ERROR] Deployment verification failed.
    pause
    exit /b 1
)

echo.
echo ====================================================
echo   BUILD AND DEPLOYMENT SUCCESSFUL
echo ====================================================
echo.
echo   Application:
echo   http://localhost:8080/StudentManagementSystem/
echo.
echo   Login: admin / admin123
echo.
echo ====================================================

REM ====================================================
REM Step 7: Check whether Tomcat is already running
REM ====================================================

echo.
echo Checking Tomcat port...

netstat -ano | findstr /R /C:":8080 .*LISTENING" >nul

if not errorlevel 1 (
    echo.
    echo WARNING: Port 8080 is already in use.
    echo Tomcat may already be running.
    echo Check the existing server before starting another.
    echo.
    echo Open:
    echo http://localhost:8080/StudentManagementSystem/
    echo.
    pause
    exit /b 0
)

REM ====================================================
REM Step 8: Start Tomcat in a separate window
REM ====================================================

echo.
echo Starting Apache Tomcat 9...
echo.
echo CATALINA_HOME=%CATALINA_HOME%
echo CATALINA_BASE=%CATALINA_BASE%
echo JAVA_HOME=%JAVA_HOME%
echo JRE_HOME=%JRE_HOME%
echo.

REM Create a temporary startup script so nested quotation
REM marks cannot break the Windows start command.

set "STARTUP_SCRIPT=%TEMP%\student-management-tomcat-start.bat"

(
    echo @echo off
    echo set "JAVA_HOME=%JDK_HOME%"
    echo set "JRE_HOME=%JDK_HOME%\jre"
    echo set "CATALINA_HOME=%TOMCAT_HOME%"
    echo set "CATALINA_BASE=%TOMCAT_HOME%"
    echo call "%TOMCAT_HOME%\bin\catalina.bat" run
    echo echo.
    echo echo Tomcat has stopped or exited with an error.
    echo pause
) > "%STARTUP_SCRIPT%"

if not exist "%STARTUP_SCRIPT%" (
    echo [ERROR] Could not create the Tomcat startup script.
    pause
    exit /b 1
)

start "Student Management System - Tomcat" "%COMSPEC%" /k ""%STARTUP_SCRIPT%"

echo.
echo Tomcat is launching in a separate window.
echo Wait for:
echo Server startup in [...] milliseconds
echo.
echo Then open:
echo http://localhost:8080/StudentManagementSystem/
echo.
echo Keep the Tomcat window open while using the application.
echo.

pause

endlocal