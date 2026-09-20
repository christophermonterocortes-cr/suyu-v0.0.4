; Inno Setup Script for suyu v0.0.4
; Compatible with Inno Setup 6.x

#define MyAppName "suyu"
#define MyAppVersion "0.0.4"
#define MyAppPublisher "suyu team"
#define MyAppURL "https://github.com/suyu-emu/suyu-v0.0.4"
#define MyAppExeName "suyu.exe"
#define SourceDir "dist_bin"

[Setup]
AppId={{D37F38F1-4B9E-436C-81F1-1D7A7010C35F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=LICENSE.txt
OutputDir=installers\windows
OutputBaseFilename=suyu-v0.0.4-windows-x64-setup
SetupIconFile=dist\suyu.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ChangesAssociations=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "assoc_nsp"; Description: "Associate .nsp files (Nintendo Switch Package)"; GroupDescription: "File associations:"
Name: "assoc_xci"; Description: "Associate .xci files (Nintendo Switch Game Card)"; GroupDescription: "File associations:"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Excludes: "*.old,*.tmp,*.pdb"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "dist\suyu.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\suyu.ico"
Name: "{group}\{#MyAppName} (Command Line)"; Filename: "{app}\suyu-cmd.exe"; IconFilename: "{app}\suyu.ico"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\suyu.ico"; Tasks: desktopicon

[Registry]
; .nsp file association
Root: HKA; Subkey: "Software\Classes\.nsp"; ValueType: string; ValueName: ""; ValueData: "suyu.nsp"; Flags: uninsdeletevalue; Tasks: assoc_nsp
Root: HKA; Subkey: "Software\Classes\suyu.nsp"; ValueType: string; ValueName: ""; ValueData: "Nintendo Switch Package"; Flags: uninsdeletekey; Tasks: assoc_nsp
Root: HKA; Subkey: "Software\Classes\suyu.nsp\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\suyu.ico,0"; Tasks: assoc_nsp
Root: HKA; Subkey: "Software\Classes\suyu.nsp\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Tasks: assoc_nsp

; .xci file association
Root: HKA; Subkey: "Software\Classes\.xci"; ValueType: string; ValueName: ""; ValueData: "suyu.xci"; Flags: uninsdeletevalue; Tasks: assoc_xci
Root: HKA; Subkey: "Software\Classes\suyu.xci"; ValueType: string; ValueName: ""; ValueData: "Nintendo Switch Game Card"; Flags: uninsdeletekey; Tasks: assoc_xci
Root: HKA; Subkey: "Software\Classes\suyu.xci\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\suyu.ico,0"; Tasks: assoc_xci
Root: HKA; Subkey: "Software\Classes\suyu.xci\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Tasks: assoc_xci

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent runasoriginaluser
