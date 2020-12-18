cat -T ./access.log | grep 'GET /html/special/2020/QquareDance/index.html' | awk '{split($4,array,"[");if(array[2]>="25/Oct/2020:00:00:00" && array[2]<="01/Nov/2020:23:59:00"){print $1$4}}' | wc -l
cat -T ./access.log | grep 'GET /html/special/2020/QquareDance/index.html' | awk '{split($4,array,"[");if(array[2]>="30/Oct/2020:13:30:00" && array[2]<="30/Oct/2020:21:00:00"){print $1$4}}' > ~/2020.10.13.access.live.log




cat -T ./access.log | grep 'GET /html/special/2020/OnLineSales/index.html' | awk '{split($4,array,"[");if(array[2]>="20/Nov/2020:17:00:00" && array[2]<="20/Nov/2020:20:30:00"){print $1$4}}' | wc -l
cat -T ./access.log | grep 'GET /html/special/2020/Journalists/index.html' | awk '{split($4,array,"[");{print $1$4}}' | wc -l













使用以下命令打开共享：
sudo  /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -clientopts -setvnclegacy -vnclegacy yes -clientopts -setvncpw -vncpw "Have Something." -restart -agent -privs -all

使用以下命令关闭共享：
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off