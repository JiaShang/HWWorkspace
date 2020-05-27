var isP60 = typeof sysmisc != "undefined"?true:false;//是否是P60盒子
iDebug("[config.js] isP60="+isP60);

var cardId = typeof CA != "undefined" ? CA.card.serialNumber : (typeof sysmisc != "undefined" ? sysmisc.getChipId():"9950000002197670");
iDebug("config.js cardId="+cardId);

var pre_epg_url = typeof iPanel!="undefined"&&iPanel.eventFrame?iPanel.eventFrame.pre_epg_url:(typeof sysmisc != "undefined" ? sysmisc.getEnv('epg_address', '') + "/EPG/jsp":"");

var browserType = getBrowserType();	//浏览器类型
var IPANEL30 = checkIPANEL30();	//是否为ipanel 3.0的浏览器
//控制消息流向 截止：EVENT.STOP  同层：EVENT.ADVECTED  下一层：EVENT.DOWN
var EVENT = {STOP:false, DOWN:true, ADVECTED:true};
if(IPANEL30){
	EVENT = {STOP:0, DOWN:1, ADVECTED:2};	
}

function $(_id){
	return document.getElementById(_id);
}

function iDebug(_str){
	if(navigator.appName.indexOf("iPanel")>-1){
		iPanel.debug(_str);
	}else if(navigator.appName.indexOf("Netscape")>-1 || navigator.appName.indexOf("Google")>-1){
		console.log(_str);
	}else if(navigator.appName.indexOf("Opera")>-1){
		opera.postError(_str);
	}
}
//获取浏览器版本
function getBrowserType(){
	var ua = navigator.userAgent.toLowerCase();
	return /ipanel/.test(ua) ? 'iPanel'
		: /enrich/.test(ua) ? 'EVM'
		: /wobox/.test(ua) ? 'Inspur'
		: window.ActiveXObject ? 'IE'
		: document.getBoxObjectFor || /firefox/.test(ua) ? 'FireFox'
		: window.openDatabase && !/chrome/.test(ua) ? 'Safari'
		: /opr/.test(ua) ? 'Opera'
		: window.MessageEvent && !document.getBoxObjectFor ? 'Chrome'
		: ''
		;	
}
function getUrlParams(_key, _url) {
	//alert(window.location.href);
/*
 * 获取标准URL的参数
 * @_key：字符串，不支持数组参数（多个相同的key）
 * @_url：字符串，（window）.location.href，使用时别误传入window对象
 * 注意：
 * 	1、如不存在指定键，返回空字符串，方便直接显示，使用时注意判断
 * 	2、非标准URL勿用
 */
	if (typeof(_url) == "object") {
		url = _url.location.href;
	} else {
		_url = (typeof(_url) == "undefined" || _url == null || _url == "") ? window.location.href : _url;
	}
	if (_url.indexOf("?") == -1) {
		return "";
	}
	var params = [];
	_url = _url.split("?")[1].split("&");
	for (var i = 0, len = _url.length; i < len; i++) {
		params = _url[i].split("=");
		if (params[0] == _key) {
			return params[1];
		}
	}
	return "";
}

function getStrParams(_key, _str){
	var params = [];
	_url = _str.split("&");
	for (var i = 0, len = _url.length; i < len; i++) {
		params = _url[i].split("=");
		if (params[0] == _key) {
			return params[1];
		}
	}
	return "";	
}


/*
**根据传入的字符串和长度对比
*当str长度超过len时，直接返回len长度的str
*当str长度没超过len时，type为1的话直接返回str，否则返回""
*/
function getDisplayString(str,len,type){
    var totalLength=0;
    var toMarqueeFlag = false;
    var position=0;
    for(var i=0;i<str.length;i++){
        var intCode=str.charCodeAt(i);
        if((intCode >= 0x0001 && intCode <= 0x007e) || (0xff60<=intCode && intCode<=0xff9f)){
            totalLength+=1;//非中文单个字符长度加1
        }else{
            totalLength+=2;//中文字符长度则加2
        }
        if(totalLength > len){
            position = i;//不正确的判断，中文需*2
            toMarqueeFlag = true;
            break;
        }
    }
    if(toMarqueeFlag)
        return str.substring(0,position);
    if(type == 1) return str;
	return "";
}

function checkStrNull(_str){
	var tmpStr = "";
	if(typeof(_str) == "undefined" || _str == "null" || _str == "undefined"){
		tmpStr = "";
	}else{
		tmpStr = _str;
	}	
	return tmpStr;
}

function subStr(str,len,suffix){
	var tmpStr = checkStrNull(str);
	if(tmpStr == "") return tmpStr;
	var arr = str.split("");
	var n = arr.length;
	var i = 0;
	for(i = n - 1; i >= 0; i--){
		if(arr[i] != " " && arr[i] != "\t" && arr[i] != "\n"){
			break;
		}
		arr.pop();
	}
	n = i + 1;
	str = arr.join("");
	var c;
	var w = 0;
	var flag0 = 0;//上上个字符是否是双字节
	var flag1 = 0;//上个字符是否是双字节
	var flag2 = 0;//当前字符是否是双字节
	for (i=0; i<n; i++) {
		c = arr[i].charCodeAt(0);
		flag0 = flag1;
		flag1 = flag2;
		if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
			w++;
			flag2 = 0;
		}else {
			w+=2;
			flag2 = 1;
		}
		if(parseInt((w+1)/2)>len){
			if(typeof(suffix) == "undefined"){
				return str.substring(0,i);
			}
			else if(suffix.length == 1){
				return str.substring(0,i-1)+suffix;
			}
			else if(suffix.length == 2){
				if (flag1 == 1)return str.substring(0,i-1)+suffix;
				else return str.substring(0,i-2)+suffix;
			}
			else{
				if (flag1 == 1)return str.substring(0,i-2)+suffix;
				else{
					var num = flag0 == 1 ? 2 : 3;
					return str.substring(0,i-num)+suffix;
				}
			}
			break;
		}		 
	} 
	return str;
}

//iPanel.getDisplayString();
function getStrChineseLength(str){
	str = str.replace(/[ ]*$/g,"");
	var w = 0;
	for (var i=0; i<str.length; i++) {
     var c = str.charCodeAt(i);
     //单字节加1
     if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
       w++;
     }else {
       w+=2;
     }
    } 	
	var length = w % 2 == 0 ? (w/2) : (parseInt(w/2)+1) ;
	return length;
}


//检测当前是否为iPanel30浏览器
function checkIPANEL30(){
	var userAgent = navigator.userAgent.toLowerCase();
	var flag = false;	
	if(userAgent.indexOf("ipanel") != -1 && userAgent.indexOf("advanced") == -1){//ipanel3.0
		flag = true;
	}
	return flag;
}
/*全局变量封装（兼容ipanel3.0和其它浏览器）*/
var mySessionStorage = new globalVar();
function globalVar(){
	this.getItem = function(_str){
		var val = "";
		if(IPANEL30){
			val = iPanel.getGlobalVar(_str);
		}else{
			val = sessionStorage.getItem(_str);	
		}
		if(val == "" || val == null || val == "undefined" ) val = "";
		return val;
	};
	this.removeItem = function(_str){
		if(IPANEL30){
			iPanel.delGlobalVar(_str);
		}else{
			sessionStorage.removeItem(_str);	
		}
	}
	this.setItem = function(_key, _val){
		if(IPANEL30){
			iPanel.setGlobalVar(_key, _val);
		}else{
			sessionStorage.setItem(_key, _val);	
		}
	}
}




var util = {
	/**
	 * util.date对象，用来放置与Date有关的工具
	 */
	date: {
		/**
		 * util.date.format方法，将传入的日期对象d格式化为formatter指定的格式
		 * @param {object} d 传入要进行格式化的date对象
		 * @param {string} formatter 传入需要的格式，如“yyyy-MM-dd hh:mm:ss”
		 * @return {string} 格式化后的日期字符串，如“2008-09-01 14:00:00”
		 */
		format: function(d, formatter) {
		    if(!formatter || formatter == "")
		    {
		        formatter = "yyyy-MM-dd";
		    }

			var weekdays = {
				chi: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
				eng: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
			};
		    var year = d.getYear().toString();
		    var month = (d.getMonth() + 1).toString();
		    var date = d.getDate().toString();
		    var day = d.getDay();
			var hour = d.getHours().toString();
			var minute = d.getMinutes().toString();
			var second = d.getSeconds().toString();

		    var yearMarker = formatter.replace(/[^y|Y]/g,'');
		    if(yearMarker.length == 2) {
		        year = year.substring(2,4);
		    }

		    var monthMarker = formatter.replace(/[^M]/g,'');
		    if(monthMarker.length > 1) {
		        if(month.length == 1) {
		            month = "0" + month;
		        }
		    }

		    var dateMarker = formatter.replace(/[^d]/g,'');
		    if(dateMarker.length > 1) {
		        if(date.length == 1) {
		            date = "0" + date;
		        }
		    }

			var hourMarker = formatter.replace(/[^h]/g, '');
		    if(hourMarker.length > 1) {
				if(hour.length == 1) {
					hour = "0" + hour;
				}
		    }

			var minuteMarker = formatter.replace(/[^m]/g, '');
		    if(minuteMarker.length > 1) {
				if(minute.length == 1) {
					minute = "0" + minute;
				}
		    }

			var secondMarker = formatter.replace(/[^s]/g, '');
		    if(secondMarker.length > 1) {
				if(second.length == 1) {
					second = "0" + second;
				}
		    }

		    var dayMarker = formatter.replace(/[^w]/g, '');
		  //  var lang = user.UILanguage;
		  var lang = 1;
		    var result = formatter.replace(yearMarker,year).replace(monthMarker,month).replace(dateMarker,date).replace(hourMarker,hour).replace(minuteMarker,minute).replace(secondMarker,second);
			
		    return result;
		},

        getDate: function(offset) {
            var d = new Date();
            var year = d.getYear();
            var month = d.getMonth();
            var date = d.getDate();
            var hour = d.getHours();
            var minute = d.getMinutes();
            var second = d.getSeconds();
            var dd = new Date(year, month, (date+offset), hour, minute, second);
            return dd;
        }
	},
	str: {
		addZero: function(__str, __num){
			__str = __str.toString();
			for(var i = __str.length; i < __num; i++){
				__str = "0"+__str;
			}
			return __str;
		},

		getDuration: function(__t1, __t2){
			var t1 = __t1.split(":");
			var t2 = __t2.split(":");
			var duration = 0;
			duration = (Math.floor(t2[0])*60+Math.floor(t2[1])) - (Math.floor(t1[0])*60+Math.floor(t1[1]));
			if(t1[0] > t2[0]) duration = duration + 1440;
			return duration;
		},
		secondToStringTime: function(__sec){
			var hour = Math.floor(__sec/3600);
			var minute = Math.floor((__sec - hour*3600)/60);
			var second = __sec - hour*3600 - minute*60;
			hour = hour>9?hour:"0"+hour;
			minute = minute>9?minute:"0"+minute;
			second = second>9?second:"0"+second;
			return hour+":"+minute+":"+second;
		},
		getDateTime : function (year,month,date,hour,minute,second) {
            var d = new Date(year, month-1, date, hour, minute, second);
            return d.getTime();
 		},
		getCurrTime:function(){
			 var d = new Date();
			 return d.getTime();
		}
	}
};

//滚动条
function ScrollBar(id, barId, f) {
	this.obj = null;
	this.barObj = null;
	if (typeof(f) == "object"){
		this.obj = f.document.getElementById(id);
		if(typeof(barId) != "undefined"){
			this.barObj = f.document.getElementById(barId);
		}
	} else {
		this.obj = document.getElementById(id);
		if(typeof(barId) != "undefined"){
			this.barObj = document.getElementById(barId);
		}
	}
}

ScrollBar.prototype.init = function(totalNum, pageSize, maxBarLength, startPos, type) {
	this.startPos = startPos;
	var percent = 1;
	if (totalNum > pageSize) {
		percent = pageSize / totalNum;
	}
	var barLength = percent * maxBarLength;
	if(typeof(type) != "undefined"){
		if(this.barObj != null){
			this.barObj.style.height = Math.round(barLength) + "px";
		}
		else{
			this.obj.style.height = Math.round(barLength) + "px";
		}
		this.endPos = this.startPos + (maxBarLength - barLength);//2008-10-16
	}
	else{
		this.endPos = this.startPos + maxBarLength;
	}
	if(totalNum > 1){
		this.footStep = (this.endPos - this.startPos) / (totalNum - 1);
	}
	else{
		this.footStep = 0;
	}
};

ScrollBar.prototype.scroll = function(currPos) {
	var tempPos = this.startPos + this.footStep * currPos;
	this.obj.style.top = Math.round(tempPos) + "px";
};

var navigatorFlag = navigator.userAgent.toLowerCase().indexOf("ipanel") > -1 ?"iPanel":"other";
var returnFalseFlag = false;			//事件截止
var returnTrueFlag = true;				//事件流向下一层
var user = null;

if(navigatorFlag == "iPanel"){
	var isAdvanceFlag = navigator.userAgent.toLowerCase().indexOf("advanced") > -1 ?true:false;
 	returnFalseFlag = isAdvanceFlag?false:0;
	returnTrueFlag = isAdvanceFlag?true:1;
	user		= users.currentUser;
}

var Event = {
	mapping: function(__event){
		__event=__event||event;
		var keycode = __event.which||__event.keyCode || __event.charCode;
		var p2 = __event.modifiers || __event.userInt;
		//iDebug("mapping url="+window.location.href + ";keycode="+keycode+";modifiers="+p2);		
		var code = "";
		var name = "";
		var args = {};
		if(keycode < 58 && keycode > 47){//数字键
			args = {modifiers: __event.modifiers, value: (keycode - 48), type:returnFalseFlag, isGlobal: false};
			code = "KEY_NUMERIC";
			name = "数字";
		} else {
			var args = {modifiers: __event.modifiers, value: keycode, type:returnFalseFlag, isGlobal: false};
			switch(keycode){
				case 1://up
				case 38:
					code = "KEY_UP";
					name = "上";
					break;
				case 2://down
				case 40:
					code = "KEY_DOWN";
					name = "下";
					break;
				case 3://left
				case 37:
					code = "KEY_LEFT";
					name = "左";
					break;
				case 4://right
				case 39:
					code = "KEY_RIGHT";
					name = "右";
					break;
				case 13://enter
					code = "KEY_SELECT";
					name = "确定";
					break;
				case 339://exit
				case 27:
					code = "KEY_EXIT";
					name = "退出";
					args.type = returnTrueFlag;
					break;
				case 258:
				case 4106://advanced键值
				case 1123://川网待机
					code="KEY_STANDBY";
					name = "待机";
					args.type = returnTrueFlag;
					break;
				case 340://back
				case 8:
				case 640:
				case 283:   //重庆的返回键值
					code = "KEY_BACK";
					name = "返回";
					break;
				case 372://page up
				case 33:	
					code = "KEY_PAGE_UP";
					name = "上页";
					break;
				case 373://page down
				case 34:
					code = "KEY_PAGE_DOWN";
					name = "下页";
					break;
				case 512:		
				case 4098:
					code = "KEY_HOMEPAGE";
					name = "首页";
					args.type = returnFalseFlag;
					break;
					
				case 513://iPanel标志的键
				case 4097:
				case 468://Coship
					code = "KEY_MENU";
					name = "菜单";
					args.type = returnTrueFlag;
					break;
				case 514://EPG
				case 4192:
				case 458://Coship
					code = "KEY_EPG";
					name = "导视";
					break;
				case 4194:
					code = "KEY_RECOMMEND";
					name = "推荐"
					break;
				case 518:
				case 4211:
				case 645://Coship
					code = "KEY_NVOD";
					name = "点播";
					break;
				case 520:
				case 4218:
				case 3884://Coship
					code = "KEY_STOCK";
					name = "股票";
					break;
				case 768:
					code = "KEY_F1";
					break;
				case 769:
					code = "KEY_F2";
					break;
				case 770:
					code = "KEY_F3";
					break;
				case 771:
					code = "KEY_F4";
					break;
				case 515:
					code = "KEY_HELP";
					break;
				case 521:
					code="KEY_MAIL";
					break;
				case 561://输入法 FN
					code = "KEY_IME";
					name = "输入法";
					break;
				case 563://tv
				case 4209://tv
				case 481://Coship
					code = "KEY_TV";
					name = "电视";
					break;
				case 564://audio
				case 4210:
				case 482://Coship
					code = "KEY_AUDIO";
					name = "广播";
					break;
				case 567://info
				case 4100:
					code = "KEY_INFO";
					name = "信息";
					args.type = returnTrueFlag;
					break;
				case 570://喜爱键
				case 4102:
				case 480://Coship
					code = "EIS_IRKEY_PLAYLIST";
					name = "喜爱";
					break;
				case 595://音量+
				case 4109:
				case 447://Coship
					code="KEY_VOLUME_UP";
					name = "音量+";
					args.type = returnTrueFlag;
					break;
				case 596://音量-
				case 4110:
				case 448://Coship
					code="KEY_VOLUME_DOWN";
					name = "音量-";
					args.type = returnTrueFlag;
					break;
				case 593:	//频道加
				case 4111:
				case 427://Coship
					code = "KEY_CHANNEL_UP";		
					name = "频道+";
					args.type = returnTrueFlag;
					break;
				case 594://频道减
				case 4112:
				case 428://Coship
					code = "KEY_CHANNEL_DOWN";		
					name = "频道-";
					args.type = returnTrueFlag;
					break;
				case 597://静音键
				case 4108:
				case 449://Coship
					code = "KEY_MUTE";
					name = "静音";
					args.type = returnTrueFlag;
					break;
				case 598:
				case 4104:
				case 407://Coship
					code = "KEY_AUDIO_MODE";
					name = "声道";
					args.type = returnTrueFlag;
					break;
				case 832://red
				case 82: //r
				case 2305:
				case 403:
				case 96://Coship
					code = "KEY_RED";
					name = "红";
					break;
				case 833://green
				case 2306://绿键
				case 404:
				case 97://Coship
					code = "KEY_GREEN";
					name = "绿";
					break;
				case 834://yellow
				case 2307:
				case 405:
				case 98://Coship
					code = "KEY_YELLOW";
					name = "黄";
					break;
				case 835://blue
				case 2308:
				case 406:
				case 99://Coship
					code = "KEY_BLUE";
					name = "蓝";
					break;
				case 849://#键
				case 519://对应老版设置新版#键
					code="KEY_SET";
					args.type = 1;
					break;
				case 848://*键
				case 562://对应老资讯新版*键作为pushmail应用使用
					code = "KEY_BROADCAST";
					args.type = 1;
					break;
				
				case 1027://VOD 或DVD录制键 
					code = "EIS_IRKEY_RECORD";
					name = "蓝";
					break;
				case 4021://域名本身不存在
					code = "EIS_STD_DOMAIN_NOT_FOUND";
					break;
				case 4022://找不到DNS server
					code = "EIS_STD_NO_DNS_SERVER";
					break;
				/*--------------------vod-------------*/
				case 5202://EIS_VOD_PREPAREPLAY_SUCCESS
					code = "EIS_VOD_PREPAREPLAY_SUCCESS";
					break;
				case 5203:
					code = "EIS_VOD_CONNECT_FAILED";
					break;
				case 5205:
					code = "EIS_VOD_PLAY_SUCCESS";
					break;
				case 5206:
					code = "EIS_VOD_PLAY_FAILED";
					break;
				case 5209:
					code = "EIS_VOD_PROGRAM_BEGIN";
					break;
				case 5210:
					code = "EIS_VOD_PROGRAM_END";
					break;
				case 5222:
					code = "EIS_VOD_START_BUFF";
					break;
				case 5225:
					code = "EIS_VOD_USER_EXCEPTION";
					break;
				case 5226:
					code = "EIS_VOD_GET_PARAMETER_SUCCESS";
					break;
				case 5227:
					code = "EIS_VOD_GET_PARAMETER_FAILED";
					break;
				case 6256:
					code = "EIS_APP_DOWNLOADMGR_PRESS";
					break;
				/*----------vod---------end---------*/
				case 5500:
					code = "EIS_IP_NETWORK_CONNECT";
					args.type = returnTrueFlag;
					break;
				case 5501:
					code = "EIS_IP_NETWORK_DISCONNECT";
					args.type = returnTrueFlag;
					break;
				case 5502:
					code = "EIS_IP_NETWORK_READY";
					args.type = returnTrueFlag;
					break;
				case 5503:
					code = "EIS_IP_NETWORK_FAILED";
					args.type = returnTrueFlag;
					break;
				case 5504:
					code = "IP_NETWORK_DHCP_MODE";//当前已经是DHCP模式
					break;
				/*--------------------ntp-------------*/	
				case 5512://EIS_IP_NETWORK_SET_NTP_SERVER_NOTIFY
					code = "EIS_IP_NETWORK_SET_NTP_SERVER_NOTIFY";
					break;
				case 5510://EIS_IP_NETWORK_NTP_READY
					code = "EIS_IP_NETWORK_NTP_READY";
					break;
				case 5511:
					code = "EIS_IP_NETWORK_NTP_TIMEOUT";
					break;	
				case 5550:
					code = "DVB_CABLE_CONNECT_SUCCESS";
					args.type = returnTrueFlag;
					break;
				case 5551:
					code = "DVB_CABLE_CONNECT_FAILED";
					args.type = returnTrueFlag;
					break;
				case 5560://CM已断开连接
					code = "EIS_CABLE_NETWORK_CM_DISCONNECTED ";
					args.type = returnTrueFlag;
					break;
				case 5561://CM已连接上
					code = "EIS_CABLE_NETWORK_CM_CONNECTED";
					args.type = returnTrueFlag;
					break;
				case 40070:
				case 5300://插入智能卡
					code = "CA_INSERT_SMARTCARD";
					args.type = returnTrueFlag;
					break;
				case 40071:
				case 5301://拔出智能卡
					code = "CA_EVULSION_SMARTCARD";
					args.type = returnTrueFlag;
					break;
				case 5350://Ca_message_open
					code = "CA_MESSAGE_OPEN";
					args.type = returnTrueFlag;
					break;
				case 5351://Ca_message_close
					code = "CA_MESSAGE_CLOSE";
					args.type = returnTrueFlag;
					break;
				case 5974:
					code = "EIS_MISC_HTML_OPEN_FINISHED";
					args.type = returnTrueFlag;
					break;
				case 5785:
					code="EIS_OTHER_APP_MESSAGE_PAUSE";
					args.type = returnTrueFlag;
					break;
				case 5975:
					code = "EIS_MISC_HTML_OPEN_START";
					args.type = returnTrueFlag;
					break;
				case 4404:
					code = "EIS_STDMESSAGE_NOT_FOUND";
					break;
				case 4408:
					code = "EIS_STDMESSAGE_REQUEST_TIMEOUT";
					break;
				case 40023: //播放信号丢失
					code = "DVB_TUNE_FAILED"; 					
					break;
				case 40024: //播放信号锁定
					code = "DVB_TUNE_SUCCESS";
					break;
				/*********************应用自定义系统消息******************/
				case 9001:
					code = "CHANNEL_LIST_REFRESH";
					break;
				case 9002:
					code = "CHANNEL_NOT_FOUND";
					args.type = returnTrueFlag;
					break;
				case 9003:
					code = "SHOW_APP_NOTE_MESSAGE";
					args.type = returnTrueFlag;
					break;
				case 9004:
					code = "HIDE_APP_NOTE_MESSAGE";
					args.type = returnTrueFlag;
					break;
				case 9005:
					code = "MANUAL_CHECK_APP_NOTE";
					args.type = returnTrueFlag;
					break;
				default:
					args.type = returnTrueFlag;
					break;
			}
		}
		return {code: code, args: args, name: name,keycode:keycode};
	}
};

/*function initPage(f) {
	//这个方法没有实际用处--方法下面重新定义了
	 f.$ = function(id) {
		 return f.document.getElementById(id);
	 }

	if(navigatorFlag == "iPanel"){
		f.user = user;
		f.lang = (user.UILanguage == 'eng') ? 1:0;
		f.E = iPanel.eventFrame;
	}

}*/

document.onkeydown = function (event) {return eventHandler(Event.mapping(event), 1);};
document.onsystemevent = function (event) {return eventHandler(Event.mapping(event), 2);};

var ISPC = 1; //0 stb，1 pc
var IMG_URL = ["http://192.168.18.74:8080/mgtv/","http://125.62.26.169:8080/mgtv/"][ISPC];
var USER_ID = cardId;
var SERVER_URL = ["http://192.168.18.74:8080/mg_app/","http://125.62.26.169:8080/mg_app/"][ISPC];
var debugMode= 0; //1 调试，0 正式
//test url
/*********
取首页推荐数据
http://125.62.26.169:8080/mg_app/recommends.do?userid=123456
取首页一级栏目
http://125.62.26.169:8080/mg_app/columns.do?userid=123456
取按一级栏目id取子栏目和里面数据
http://125.62.26.169:8080/mg_app/column_level2_data.do?userid=123456&id=mgtv_zct
按vodid取详情
http://125.62.26.169:8080/mg_app/details.do?userid=123456&id=201908000013


*/

var rtsp = "";	
var getMovieRtspUrl = "";

function fullScreen(__id) {
	if(typeof sysmisc != 'undefined'){
		getRTSP(infoObj.program.title, __id, 1);
	}else{
		var reUrl = window.location.href;
		reUrl = encodeURIComponent(reUrl);
		$("data_ifm").src = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/hidden_detail.jsp?typeId=-1&playType=1"
            + "&vodId=" + __id + "&baseFlag=0&idType=FSN&appBackUrl="+reUrl;
	}
}

function smallScreen(__id,__name,__left,__top,__width,___height){
	if(typeof sysmisc != 'undefined'){
		mediaPlayer = mixplayer.create(__left,__top,__width,___height);
		rtspurl = getNewRTSP(__name, __id, 1, 0, 0);
	}else{
		media.video.setPosition(__left,__top,__width,___height);
		 play_ajax(__id);
	}
	
}

function play_ajax(freeVodId){
	getMovieRtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?typeId=-1&playType=1&progId="+freeVodId+"&contentType=0&business=1&idType=FSN";
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function (){
		if(XHR.readyState == 4){
			if(XHR.status == 200){
				var json = eval("(" + XHR.responseText + ")");
				rtsp =json.playUrl.split("^")[4];
				play();
			}
			else{//AJAX没有获取到数据
				XHR.abort();
			}
		}
	}
	XHR.open("GET", getMovieRtspUrl, true);
	XHR.send(null);
}
function play(){
	//VOD.changeServer("huawei_v2","dvb");
	media.AV.open(rtsp,"VOD");
}



function getNewRTSP(name, vod_id, flag, index, time, _parentVodId) {
   iDebug(">>>p60box getNewRTSP-epg_address===" + sysmisc.getEnv('epg_address', ''));
    if (sysmisc.getEnv('epg_address', '') != '') {
        var url = urlJoin(sysmisc.getEnv('epg_address', '') + '/EPG/jsp/defaultHD/en/go_authorization.jsp', joinStr(getObject(vod_id, flag, _parentVodId)));
        iDebug(">>>p60box getNewRTSP-url===" + url);
        var cookie = '[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid', '') + '"}]';
        bridge.ajax('post', url, 'text/xml', cookie, '', function(resp) {
            iDebug(">>>p60box getNewRTSP-success-resp===" + resp);
            var jsonStr = resp.trim().replace(/[\r\n]/g, "");
            iDebug(">>>p60box getNewRTSP-success-jsonstr===" + jsonStr);
            var json = eval("(" + jsonStr + ")");
            if (json.playUrl) {
            	iDebug(">>>p60box getNewRTSP-success-json.playUrl===" + json.playUrl);
                var rtsp = json.playUrl;
                var _playUrl = rtsp.split("^")[4];
				iDebug(">>>p60box getNewRTSP-success-_playUrl===" + _playUrl);
				
				//if(mediaPlayer)mixplayer.stop(mediaPlayer);
				iDebug(">>>p60box getNewRTSP-success-222222==");
                playVideo(_playUrl);
                return rtsp;
            }
        }, function(resp) {
            iDebug(">>>p60box getNewRTSP-fail");
        })
    }
}

// 播放视频
function playVideo(_url) {
	iDebug(">>>p60box playVideo _url="+_url+" seekTime="+seekTime);
    sysmisc.bringToForeground("web");//设置需要显示在最前的图层,video为视频层，其它为web层
	mixplayer.playUrl(mediaPlayer, _url, seekTime+"");

}









