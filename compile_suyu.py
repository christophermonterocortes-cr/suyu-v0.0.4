import subprocess, os, sys

bat = r"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
cmake = r"C:\Users\CHRISTOPHER\AppData\Local\Microsoft\WinGet\Packages\Kitware.CMake_Microsoft.Winget.Source_8wekyb3d8bbwe\cmake-4.4.3-windows-x86_64\bin\cmake.exe"
ninja = r"C:\Users\CHRISTOPHER\AppData\Local\Microsoft\WinGet\Packages\Ninja-build.Ninja_Microsoft.Winget.Source_8wekyb3d8bbwe\ninja.exe"
vulkan = r"C:\VulkanSDK\1.4.357.0"
qt_bin = r"C:\Users\CHRISTOPHER\Qt\6.7.0\msvc2019_64\bin"

path_dirs = [
    rf"{vulkan}\Bin",
    r"C:\Users\CHRISTOPHER\tools\git\cmd",
    r"C:\Users\CHRISTOPHER\tools\git\usr\bin",
    qt_bin,
    r"C:\Users\CHRISTOPHER\AppData\Local\Microsoft\WinGet\Packages\Ninja-build.Ninja_Microsoft.Winget.Source_8wekyb3d8bbwe",
]
os.environ["PATH"] = ";".join(path_dirs) + ";" + os.environ.get("PATH", "")
os.environ["VULKAN_SDK"] = vulkan

target = sys.argv[1] if len(sys.argv) > 1 else "suyu"
cmd = f'call "{bat}" && cd /d "C:\\Users\\CHRISTOPHER\\Downloads\\suyu-v0.0.4" && "{cmake}" --build build --target {target} -j8'
print(f"Building target: {target}...")
res = subprocess.run(cmd, shell=True)
sys.exit(res.returncode)
