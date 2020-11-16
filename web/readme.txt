sudo lsof -nP -iTCP:5037 -sTCP:LISTEN
爱看策划 10000100000000090000000000103261


"(/EPG/jsp|http://125.62.26.152|http://192.168.89.23)[\s\S]*?2020-10-.*?"


//这条命令相当于按了设备的Backkey键
adb shell input keyevent 4
adb shell screenrecord /sdcard/aa.mp4  (屏幕录相)

 //可以解锁屏幕
adb shell input keyevent  82
 //截屏
adb shell input keyevent  120
input keyevent  49 数字键1

KEYCODE_ENTER       回车键            66
KEYCODE_ESCAPE      ESC键            111
KEYCODE_DPAD_CENTER 导航键 确定键      23
KEYCODE_DPAD_UP     导航键 向上        19
KEYCODE_DPAD_DOWN   导航键 向下        20
KEYCODE_DPAD_LEFT   导航键 向左        21
KEYCODE_DPAD_RIGHT  导航键 向右        22
KEYCODE_MOVE_HOME   光标移动到开始键    122
KEYCODE_MOVE_END    光标移动到末尾键    123
KEYCODE_PAGE_UP     向上翻页键         92
KEYCODE_PAGE_DOWN   向下翻页键         93
KEYCODE_DEL         退格键            67
KEYCODE_FORWARD_DEL 删除键            112
KEYCODE_INSERT      插入键            124
KEYCODE_TAB         Tab键            61
KEYCODE_NUM_LOCK    小键盘锁          143
KEYCODE_CAPS_LOCK   大写锁定键        115
KEYCODE_BREAK       Break/Pause键   121
KEYCODE_SCROLL_LOCK 滚动锁定键        116
KEYCODE_ZOOM_IN     放大键           168
KEYCODE_ZOOM_OUT    缩小键           169
KEYCODE_CALL        拨号键           5
KEYCODE_ENDCALL     挂机键           6
KEYCODE_HOME        按键Home         3
KEYCODE_MENU        菜单键           82
KEYCODE_BACK        返回键           4
KEYCODE_SEARCH      搜索键           84
KEYCODE_CAMERA      拍照键           27
KEYCODE_FOCUS       拍照对焦键       80
KEYCODE_POWER       电源键          26
KEYCODE_NOTIFICATION通知键         83
KEYCODE_MUTE        话筒静音键	    91
KEYCODE_VOLUME_MUTE	扬声器静音键	    164
KEYCODE_VOLUME_UP	音量增加键	    24
KEYCODE_VOLUME_DOWN	音量减小键	    25

./adb shell setprop epg_address 'http://192.168.14.102:8082'


setprop NTID 06558860000000069
setprop sessionid 10F0E3C11AA9086DE8DBA4759969FC55
setprop usertoken 0D91ADEA6F346A05D1515DD106327C36
setprop ntvuseraccount 42742350
setprop ServiceGroupID 34376

#专题页面
am start -a com.cw.webapp.start --es url "http://192.168.14.102:8082/EPG/jsp/neirong/S20191108.jsp?typeId=10000100000000090000000000113180"
#模板专题
am start -a com.cw.webapp.start --es url "http://192.168.17.235/newTGO/prefecture.html?prefectNo=224&backUrl=others&sp_code=0001&qycq=1&HWSCache=0&backURL=http://125.62.26.96/front/common/portal.html?&currFoucs=4,3,0,2,0,4,0,0,0,0#|#http://192.168.42.60/indexCQNews.html"
am start -a com.cw.webapp.start --es url "http://192.168.18.75/dyyx_p60/search_content.htm?backURL=http%3A%2F%2F192.168.14.102%3A8082%2FEPG%2Fjsp%2Fneirong%2FS20190424.jsp%3FtypeId%3D10000100000000090000000000111525%26%26media%3DP60%26currFoucs%3D0%2C0%2C0#|#http%3A%2F%2Faoh5.cqccn.com%2FcqccnVideo%2FspecialTopic%2FspecialTopic.html%3Farea%3D0%26listIndex%3D3%26pageNo%3D12"
# 关闭进程
am force-stop com.cw.webapp.start
# 打开世界杯的界面
am force-stop com.cw.webapp.start;am start -a com.cw.webapp.start --es url "http://192.168.14.102:8082/EPG/jsp/neirong/edu/v2/player.jsp?id=5485480&typeId=10000100000000090000000000108859&EPGflag=EPGflag";
# 打开免费专区的界面
am start -a com.cw.webapp.start --es url "http://192.168.42.60/indexTop.html";

http://192.168.115.112:8082/EPG/jsp/neirong/free/v1/free.jsp
# 党教
am start -a com.cw.webapp.start --es url "http://192.168.14.102:8082/EPG/jsp/neirong/edu/v2/index.jsp";
am start -a com.cw.webapp.start --es url "http://192.168.42.60:800/tongnan/index.html";
am start -a com.cw.webapp.start --es url "http://192.168.14.102:8082/EPG/jsp/neirong/S20190528.jsp";
# 精读
am force-stop com.cw.webapp.start; am start -a com.cw.webapp.start --es url "http://192.168.14.102:8082/EPG/jsp/neirong/edu/v2/list1.jsp?parentId=10000100000000090000000000109312&index=0&typeId=10000100000000090000000000109314&EPGflag=EPGflag";
am start -a com.cw.webapp.start --es url "http://192.168.14.102:8082/EPG/jsp/neirong/edu/v2/list.jsp?parentId=10000100000000090000000000108861&index=0&typeId=10000100000000090000000000109300";
am start -a com.cw.webapp.start --es url "http://192.168.14.102:8082/EPG/jsp/neirong/edu/v2/list.jsp?parentId=10000100000000090000000000111806&index=0&typeId=10000100000000090000000000111806&EPGflag=EPGflag";

# 打开测试界面
am force-stop com.cw.webapp.start;am start -a com.cw.webapp.start --es url "http://192.168.42.60/indexTop.html";
am force-stop com.cw.webapp.start;am start -a com.cw.webapp.start --es url "http://192.168.89.23/mediaTop/index.html";
./adb shell am force-stop com.cw.webapp.start && ./adb shell setprop epg_address 'http://192.168.14.102:8082' && ./adb shell am start -a com.cw.webapp.start --es url "http://192.168.89.23/CQNews/v1/index.html";
am force-stop com.cw.webapp.start;am start -a com.cw.webapp.start --es url "http://192.168.89.23/CQNews/v1/countryList.html";
am force-stop com.cw.webapp.start;am start -a com.cw.webapp.start --es url "http://192.168.89.23/CQNews/v1/columnList.html?typeId=10000100000000090000000000106184";
am force-stop com.cw.webapp.start;am start -a com.cw.webapp.start --es url "http://192.168.89.23/extra.html?frequency=427000&serviceId=1104";
am start -a com.cw.webapp.start --es url "http://192.168.18.14:8080";

# 查看日志
./adb logcat -s webapp | grep --color=auto -i "COMMONJS\|Uncaught"
./adb logcat -s webapp | grep -v "AdsDownLoadService\|sleep\|progress"
am start -a com.cw.webapp.start --es url "http://192.168.18.14:8080";






./adb -s '10.237.65.0:5555' shell am start -n com.ipanel.dtv.chongqing/com.ipanel.dtv.chongqing.IPanel30PortalActivity --es url "http://192.168.14.102:8082/EPG/jsp/neirong/edu/v2/index.jsp"
./adb -s '10.237.65.0:5555' shell am start -n com.ipanel.dtv.chongqing/com.ipanel.dtv.chongqing.IPanel30PortalActivity --es url "http://192.168.14.102:8082/EPG/jsp/neirong/edu/v2/list.jsp?parentId=10000100000000090000000000108861&index=0&typeId=10000100000000090000000000109300"
./adb -s '10.237.65.0:5555' shell am start -n com.ipanel.dtv.chongqing/com.ipanel.dtv.chongqing.IPanel30PortalActivity --es url "http://192.168.14.102:8082/EPG/jsp/neirong/edu/v2/player.jsp?id=5704043&typeId=10000100000000090000000000108860"
./adb -s '10.237.65.0:5555' shell input keyevent 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
./adb -s '10.237.65.0:5555' shell input keyevent 66



#专题页面
am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url "http://192.168.14.102:8082/EPG/jsp/neirong/S20190911.jsp?typeId=10000100000000090000000000112660"

# 网关相关
# 直播频道调用链接（示例）
http://192.168.1.202:18080/D_40992_41_4104

# 授权地址
am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url "http://192.168.14.156:8082/EPG/jsp/CheckUser.jsp?User=&pwd=&ip=10.194.72.1&NTID=78-8D-F7-6F-82-6A&CARDID=9950000002102846&Version=1.0&lang=1&supportnet=Cable&decodemode=H.264HD;MPEG-2HD&CA=1&ServiceGroupID=34376&encrypt=0"

# 全域重庆
am force-stop com.ipanel.android_webview.shell;am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url http://192.168.110.218:8082/EPG/jsp/defaultHD/en/hddb/new_qycq/xqycq_index.jsp
am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url http://192.168.14.156:8082/EPG/jsp/defaultHD/en/hddb/new_qycq/xqycq_index.jsp

#免费专区
am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url http://192.168.110.218:8082/EPG/jsp/neirong/free/v1/free.jsp
am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url http://192.168.14.156:8082/EPG/jsp/neirong/free/v1/free.jsp

#退出浏览器
am force-stop com.ipanel.android_webview.shell;am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url "http://192.168.42.60/teste/small.html"


am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url http://192.168.14.156:8082/EPG/jsp/neirong/WorldCup2018/WorldCup.jsp

am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url "http://192.168.14.156:8082/EPG/jsp/neirong/edu/v2/index.jsp"
am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url "http://192.168.110.218:8082/EPG/jsp/neirong/edu/v2/index.jsp"
am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url "http://192.168.42.60/teste/small.html"
am force-stop com.ipanel.android_webview.shell;am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url "http://192.168.89.23/front/choice.html"




am force-stop com.ipanel.android_webview.shell;am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url  "http://192.168.89.23/mediaTop/index.html";
am force-stop com.ipanel.android_webview.shell;am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url  "http://192.168.42.60:800/beibei/index.html";
am force-stop com.ipanel.android_webview.shell;am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url  "http://192.168.89.23/CQNews/v1/index.html";
am force-stop com.ipanel.android_webview.shell;am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url  "http://192.168.89.23/CQNews/v1/countryList.html";
am force-stop com.ipanel.android_webview.shell;am start -n com.ipanel.android_webview.shell/com.ipanel.webapp.BrowserActivity -e url  "http://192.168.89.23/CQNews/v1/columnList.html?typeId=10000100000000090000000000106184";
播放： VOD点播
var url = iPanelGatewayHelper.getPlayUrl(vodId);
//iPanel.debug("wangwang 播放地址是： "+url);
media.AV.open(url,"HTTP");
iPanelGatewayHelper.playLive("303"，true);

iPanelGatewayHelper.launchApk("要启动应用的包名","要启动应用的类名","key1;value1;key2;value2;不需要时传空");

//外部id转内部id接口
//epg_url+"jsp/defaultHD/en/getContentId.jsp?vodId="+vodId

./adb logcat -s webapp | grep --color=auto -i "COMMONJS"

//设置
setprop persist.sys.epg.address "http://192.168.14.102:8082"



IPTV(设置ADB，在工程菜单里面  上下左右音量+音量-)

浏览器 Cookies 不能跨域
chrome://flags/#same-site-by-default-cookies， 设置为 Disabled
chrome://flags/#cookies-without-same-site-must-be-secure， 设置为 Disabled， 后重启浏览器



