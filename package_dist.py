import os, shutil, subprocess

src_dir = r"C:\Users\CHRISTOPHER\Downloads\suyu-v0.0.4\build\bin"
dist_dir = r"C:\Users\CHRISTOPHER\Downloads\suyu-v0.0.4\dist_bin"
windeployqt = r"C:\Users\CHRISTOPHER\Qt\6.7.0\msvc2019_64\bin\windeployqt.exe"

os.makedirs(dist_dir, exist_ok=True)

# Copy executables
for exe_name in ["suyu.exe", "suyu-cmd.exe"]:
    src_exe = os.path.join(src_dir, exe_name)
    if os.path.exists(src_exe):
        shutil.copy2(src_exe, os.path.join(dist_dir, exe_name))
        print(f"Copied {exe_name} ({os.path.getsize(src_exe)} bytes) to {dist_dir}")

# Run windeployqt
print("Running windeployqt...")
res = subprocess.run([windeployqt, "--release", "--no-translations", os.path.join(dist_dir, "suyu.exe")], capture_output=True, text=True)
print("windeployqt return code:", res.returncode)
print("windeployqt output:\n", res.stdout[:1000])

print("Contents of dist_bin:")
for item in os.listdir(dist_dir):
    print(" ", item)
