import subprocess, sys, time, os, re

gh = r"C:\Users\CHRISTOPHER\AppData\Local\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin\gh.exe"
git = r"C:\Users\CHRISTOPHER\tools\git\cmd\git.exe"
repo_dir = r"C:\Users\CHRISTOPHER\Downloads\suyu-v0.0.4"

# Check if already authenticated
res = subprocess.run([gh, "auth", "status"], capture_output=True, text=True)
if res.returncode != 0:
    print("====================================================================", flush=True)
    print(" GitHub Authentication Required", flush=True)
    print("====================================================================", flush=True)
    
    proc = subprocess.Popen(
        [gh, "auth", "login", "--hostname", "github.com", "--git-protocol", "https", "--web"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        cwd=repo_dir
    )
    
    code = None
    url = "https://github.com/login/device"
    start_time = time.time()
    
    while time.time() - start_time < 15:
        line = proc.stderr.readline()
        if line:
            print(line.strip(), flush=True)
            m = re.search(r'\(([A-Z0-9]{4}-[A-Z0-9]{4})\)', line)
            if m:
                code = m.group(1)
        if code:
            break
        time.sleep(0.5)
        
    print("\n--------------------------------------------------------------------", flush=True)
    print(f"[*] Enter this code in your browser:  {code}", flush=True)
    print(f"[*] Authorization URL:                {url}", flush=True)
    print("--------------------------------------------------------------------\n", flush=True)
    print("Waiting for browser authorization (up to 300s)...", flush=True)
    
    try:
        proc.wait(timeout=300)
    except subprocess.TimeoutExpired:
        proc.kill()
        print("Error: Authentication timed out.", flush=True)
        sys.exit(1)

print("\n====================================================================", flush=True)
print(" GitHub authenticated successfully!", flush=True)
print("====================================================================", flush=True)

# Check user identity
res = subprocess.run([gh, "api", "user", "-q", ".login"], capture_output=True, text=True)
username = res.stdout.strip()
print(f"Logged in as: {username}", flush=True)

# Fork repository
print(f"Forking suyu-emu/suyu-v0.0.4 to {username}...", flush=True)
res = subprocess.run([gh, "repo", "fork", "suyu-emu/suyu-v0.0.4", "--clone=false", "--remote=true"], capture_output=True, text=True, cwd=repo_dir)
print(res.stdout, flush=True)
print(res.stderr, flush=True)

# Commit new tools and installers
print("Preparing commit with build tools, installers, and documentation...", flush=True)
gitignore_path = os.path.join(repo_dir, ".gitignore")
with open(gitignore_path, "r", encoding="utf-8", errors="ignore") as f:
    gi_content = f.read()
if "!/installers/**" not in gi_content:
    with open(gitignore_path, "a", encoding="utf-8") as f:
        f.write("\n!/installers/**\n")

# Add files
subprocess.run([git, "add", "build_suyu.bat", "compile_suyu.py", "package_dist.py", "suyu_installer.iss", "build_linux_installer.py", "installers/", ".gitignore"], cwd=repo_dir)
subprocess.run([git, "commit", "-m", "Add multiplatform build scripts and installers for Windows, Linux, and Android"], cwd=repo_dir)

# Set remote and push
print(f"Pushing to fork: https://github.com/{username}/suyu-v0.0.4.git...", flush=True)
subprocess.run([git, "remote", "set-url", "origin", f"https://github.com/{username}/suyu-v0.0.4.git"], cwd=repo_dir)
res = subprocess.run([git, "push", "-u", "origin", "main"], capture_output=True, text=True, cwd=repo_dir)
print(res.stdout, flush=True)
print(res.stderr, flush=True)

if res.returncode == 0:
    print("\nRepository forked and pushed successfully!", flush=True)
    print(f"URL: https://github.com/{username}/suyu-v0.0.4", flush=True)
else:
    print("\nPush had issues. Please check error output above.", flush=True)
