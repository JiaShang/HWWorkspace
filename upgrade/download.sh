#/usr/bin/sh
PATH=$PATH:'/home/cqcnt/.onekey/'
export PATH;


# Server:192.168.13.215
exec.sh 'spawn scp root@192.168.13.215:/home/iptv/epg/epg-tomcat/tomcat-6.0.18/webapps/EPG/jsp/EPG/jsp/defaultHD/en/geninfo_ad.jsp /home/cqcnt/.onekey/update/EPG/jsp/defaultHD/en/geninfo_ad.jsp' 'Cqccn@123';