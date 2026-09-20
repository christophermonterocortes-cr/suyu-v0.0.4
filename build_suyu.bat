@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo Locating Visual Studio 2022 64-bit developer environment...
echo ============================================================

set "VCVARS="

:: Check via vswhere first
if exist "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" (
    for /f "usebackq tokens=*" %%i in (`"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -property installationPath`) do (
        if exist "%%i\VC\Auxiliary\Build\vcvars64.bat" (
            set "VCVARS=%%i\VC\Auxiliary\Build\vcvars64.bat"
        )
    )
)

:: Fallback standard search paths
if "%VCVARS%"=="" (
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
        set "VCVARS=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
    ) else if exist "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
        set "VCVARS=C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
    ) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" (
        set "VCVARS=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
    ) else if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" (
        set "VCVARS=C:\Program Files (x86)\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
    ) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" (
        set "VCVARS=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"
    ) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat" (
        set "VCVARS=C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
    )
)

if "%VCVARS%"=="" (
    echo [ERROR] Could not find vcvars64.bat!
    echo Please make sure Visual Studio 2022 C++ Build Tools or Community is installed.
    pause
    exit /b 1
)

echo Initializing MSVC environment via:
echo "%VCVARS%"
call "%VCVARS%"

:: Tools paths auto-detection
where cmake >nul 2>&1 && (set "CMAKE_EXE=cmake") || (
    if exist "C:\Users\CHRISTOPHER\AppData\Local\Microsoft\WinGet\Packages\Kitware.CMake_Microsoft.Winget.Source_8wekyb3d8bbwe\cmake-4.4.3-windows-x86_64\bin\cmake.exe" (
        set "CMAKE_EXE=C:\Users\CHRISTOPHER\AppData\Local\Microsoft\WinGet\Packages\Kitware.CMake_Microsoft.Winget.Source_8wekyb3d8bbwe\cmake-4.4.3-windows-x86_64\bin\cmake.exe"
    ) else (
        set "CMAKE_EXE=cmake.exe"
    )
)

where ninja >nul 2>&1 && (set "NINJA_EXE=ninja") || (
    if exist "C:\Users\CHRISTOPHER\AppData\Local\Microsoft\WinGet\Packages\Ninja-build.Ninja_Microsoft.Winget.Source_8wekyb3d8bbwe\ninja.exe" (
        set "NINJA_EXE=C:\Users\CHRISTOPHER\AppData\Local\Microsoft\WinGet\Packages\Ninja-build.Ninja_Microsoft.Winget.Source_8wekyb3d8bbwe\ninja.exe"
    ) else (
        set "NINJA_EXE=ninja.exe"
    )
)

if "%QT6_DIR%"=="" (
    if exist "C:\Users\CHRISTOPHER\Qt\6.7.0\msvc2019_64\lib\cmake\Qt6" (
        set "QT6_DIR=C:\Users\CHRISTOPHER\Qt\6.7.0\msvc2019_64\lib\cmake\Qt6"
    ) else if exist "C:\Qt\6.7.0\msvc2019_64\lib\cmake\Qt6" (
        set "QT6_DIR=C:\Qt\6.7.0\msvc2019_64\lib\cmake\Qt6"
    )
)

:: Find Vulkan SDK
if "%VULKAN_SDK%"=="" (
    if exist "C:\VulkanSDK\1.4.357.0" (
        set "VULKAN_SDK=C:\VulkanSDK\1.4.357.0"
    ) else (
        for /d %%D in ("C:\VulkanSDK\*") do (
            set "VULKAN_SDK=%%D"
        )
    )
)
echo Using Vulkan SDK at %VULKAN_SDK%

:: Add required tool directories to PATH (excluding git\usr\bin to prevent shell tool conflicts)
if exist "C:\Users\CHRISTOPHER\tools\git\cmd" set "PATH=C:\Users\CHRISTOPHER\tools\git\cmd;%PATH%"
if exist "%VULKAN_SDK%\Bin" set "PATH=%VULKAN_SDK%\Bin;%PATH%"
if exist "C:\Users\CHRISTOPHER\Qt\6.7.0\msvc2019_64\bin" set "PATH=C:\Users\CHRISTOPHER\Qt\6.7.0\msvc2019_64\bin;%PATH%"

cd /d "%~dp0"

echo ============================================================
echo Configuring CMake...
echo ============================================================
"%CMAKE_EXE%" -B build ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DENABLE_QT=ON ^
    -DYUZU_USE_BUNDLED_QT=OFF ^
    -DSUYU_BUILD_PRESET=avx2 ^
    -DQt6_DIR="%QT6_DIR%" ^
    -DCMAKE_MAKE_PROGRAM="%NINJA_EXE%" ^
    -GNinja

if errorlevel 1 (
    echo [ERROR] CMake configuration failed.
    if not defined CI pause
    exit /b %errorlevel%
)

echo ============================================================
echo Building with Ninja...
echo ============================================================
"%NINJA_EXE%" -C build -j%NUMBER_OF_PROCESSORS%

if errorlevel 1 (
    echo [ERROR] Build failed.
    if not defined CI pause
    exit /b %errorlevel%
)

echo ============================================================
echo Packaging binaries with windeployqt into dist_bin...
echo ============================================================
if not exist "dist_bin" mkdir "dist_bin"
copy /y "build\bin\suyu.exe" "dist_bin\"
copy /y "build\bin\suyu-cmd.exe" "dist_bin\"

set "WINDEPLOYQT_EXE="
where windeployqt >nul 2>&1 && set "WINDEPLOYQT_EXE=windeployqt"
if "%WINDEPLOYQT_EXE%"=="" (
    if exist "C:\Users\CHRISTOPHER\Qt\6.7.0\msvc2019_64\bin\windeployqt.exe" (
        set "WINDEPLOYQT_EXE=C:\Users\CHRISTOPHER\Qt\6.7.0\msvc2019_64\bin\windeployqt.exe"
    )
)

if not "%WINDEPLOYQT_EXE%"=="" (
    "%WINDEPLOYQT_EXE%" --release --no-translations "dist_bin\suyu.exe"
)

echo ============================================================
echo BUILD COMPLETED SUCCESSFULLY!
echo Executables are located in:
echo   %~dp0dist_bin\suyu.exe
echo   %~dp0dist_bin\suyu-cmd.exe
echo ============================================================
if not defined CI pause
