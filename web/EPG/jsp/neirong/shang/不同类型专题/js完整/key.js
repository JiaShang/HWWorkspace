

////////////////////////////////////按键信息/////////////////////////


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
				case 340://back
				case 8:
				case 640:
				case 283:   
					code = "KEY_BACK";
					name = "返回";
					break;
				/*--------------------vod-------------*/
				case 5202:
					code = "EIS_VOD_PREPAREPLAY_SUCCESS";
					name = "连接成功，开始播放";
					break;
				case 5203:
					code = "EIS_VOD_CONNECT_FAILED";
					name = "连接失败";
					break;
				case 5205:
					code = "EIS_VOD_PLAY_SUCCESS";
					name = "视频播放成功";
					break;
				case 5206:
					code = "EIS_VOD_PLAY_FAILED";
					name = "视频播放失败";
					break;
				/*----------vod---------end---------*/
				case 5210:
					code = "EIS_VOD_PROGRAM_END";
					name = "视频播放结束";
					break;
				default:
					args.type = returnTrueFlag;
					break;
			}
		}
		return {code: code, args: args, name: name,keycode:keycode};
	}
};

document.onkeydown = function (event) {return eventHandler(Event.mapping(event), 1);};
document.onsystemevent = function (event) {return eventHandler(Event.mapping(event), 2);};


/////////////////////////////////////



















