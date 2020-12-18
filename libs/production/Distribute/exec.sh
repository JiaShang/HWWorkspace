#/usr/bin/sh
#参数说明：
# ./exec.sh 'spawn scp /home/admin/Desktop/exec.sh root@192.168.13.27:/home/cqcnt/.onekey/' 'huawei'
# $1 要执行的命令  spawn scp /home/admin/Desktop/exec.sh root@192.168.13.27:/home/cqcnt/.onekey/
# $2 服务器密码 huawei
expect -c "
set timeout 3;
set flag 0;
$1;
expect {
  \"*assword*\" { send \"$2\r\"; };
  \"yes\/no\" { set flag 1;send \"yes\r\";};
  \"welcome\" { };
};
if { \$flag == 1 } {
  expect {
    \"*assword*\" { send \"$2\r\"; };
  };
};
expect {
  \"*assword*\" { puts \"INVALID PASSWD, passwd=$2 \";exit 1;};
  \"#\ \" {} \"$\ \" {} \">\ \" {};
};"