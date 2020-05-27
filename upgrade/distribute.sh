#/usr/bin/sh
PATH=$PATH:'/home/cqcnt/.onekey/'
export PATH;


# Server:192.168.65.20
exec.sh 'spawn scp -r /home/cqcnt/.onekey/upgrade/neirong root@192.168.65.20:/home/iptv/epg/epg-tomcat/tomcat-6.0.18/webapps/EPG/jsp/' 'huawei';