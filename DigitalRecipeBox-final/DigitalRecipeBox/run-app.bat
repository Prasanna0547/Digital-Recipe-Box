@echo off
setlocal
set "JAVA_HOME=C:\Users\vpras\.vscode\extensions\redhat.java-1.58.0-win32-x64\jre\25.0.4.1-win32-x86_64"
set "MAVEN_HOME=C:\Users\vpras\.recipebox-runtime\apache-maven-3.9.16"
set "CATALINA_HOME=C:\Users\vpras\.recipebox-runtime\apache-tomcat-10.1.62"
set "PATH=%JAVA_HOME%\bin;%MAVEN_HOME%\bin;%PATH%"

echo Building DigitalRecipeBox WAR...
cd /d "%~dp0"
call "%MAVEN_HOME%\bin\mvn.cmd" clean package -q
if errorlevel 1 (
    echo Maven build failed!
    exit /b 1
)

echo Deploying WAR to Tomcat...
copy /Y "%~dp0target\DigitalRecipeBox.war" "%CATALINA_HOME%\webapps\DigitalRecipeBox.war" >nul

echo Starting Apache Tomcat on http://localhost:8080/DigitalRecipeBox/ ...
call "%CATALINA_HOME%\bin\catalina.bat" run
