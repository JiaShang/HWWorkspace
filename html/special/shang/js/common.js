﻿var configFlag = false;			//是否在页面显示打印


/**************键值映射 begin****************/
var tmpAgent = navigator.userAgent.toLowerCase();
if (tmpAgent.indexOf("android") > -1) {
	tmpAgent = "android";       //android
} else if (tmpAgent.indexOf("coship") > -1) {
	tmpAgent = 'coship';		//同洲
} else if (tmpAgent.indexOf('hi3110') > -1 || tmpAgent.indexOf('i686') > -1) {
	tmpAgent = 'huawei';		//华为
} else if (tmpAgent.indexOf('ipad') > -1) {
	tmpAgent = 'suma_vision';	//数码视讯
} else if (tmpAgent.indexOf('gefo') > -1) {
	tmpAgent = 'cntv';		//CNTV
} else if (tmpAgent.indexOf('ipanel') > -1) {
	tmpAgent = 'ipanel';		//茁壮
} else if (tmpAgent.indexOf('firefox') > -1) {
	tmpAgent = 'dvn';			//天柏
} else if(tmpAgent.indexOf('wasu') > -1) {
	tmpAgent = 'EnRich';		//英立视
}else {
	tmpAgent = 'suma_vision';	//默认数码视讯
}

switch (tmpAgent) {
	case 'coship':
	case 'huawei':
		document.onkeypress = function (event) {return eventHandler(Event.mapping(event), 1);};
		break;
	case 'ipanel':
	case 'EnRich':
	case 'suma_vision'://用google浏览器跑，获取到的是suma_vision
		document.onkeydown = function (event) {return eventHandler(Event.mapping(event), 1);};
		document.onirkeypress = function (event) {return eventHandler(Event.mapping(event), 1);};
		document.onsystemevent = function (event) {return eventHandler(Event.mapping(event), 2);};
		break;
	case 'cntv':
	case 'dvn':
		document.onkeydown = function (event) {return eventHandler(Event.mapping(event), 1);};
		break;
	default:
		document.onkeydown = function (event) {return eventHandler(Event.mapping(event), 1);};
		document.onsystemevent = function (event) {return eventHandler(Event.mapping(event), 2);};
		break;
}
 
var Event = {
	mapping: function(__event){
		__event=__event||event;
		var keycode = __event.which||__event.keyCode || __event.charCode;
		iDebug("common.js keycode = "+keycode);
		var code = "";
		var args = {};
		//if(keycode < 327 && keycode > 336){//数码盒子的键值
		if(keycode < 58 && keycode > 47){//数字键
			args = {modifiers: __event.modifiers, value: (keycode - 48), type: 0, isGlobal: false};
			code = "KEY_NUMERIC";
		} else {
			var args = {modifiers: __event.modifiers, value: keycode, type: 0, isGlobal: false};
			switch(keycode){
				case 1:
				case 38:
				case 87:
					code = "KEY_UP";
					break;
				case 2:
				case 40:
				case 83:
					code = "KEY_DOWN";
					break;
				case 3:
				case 37:
				case 65:
				case 97:
					code = "KEY_LEFT";
					break;
				case 4:
				case 39:
				case 68:
				case 100:
					code = "KEY_RIGHT";
					break;
				case 13:
					code = "KEY_SELECT";
					break;
				case 27:
				case 339://默认流下去给UI中的eventpage处理退出双向，在本应用中，如果要用到则需要return 0;截掉
					code = "KEY_EXIT";
					args.type = 1;
					break;
				case 8:
				case 32:
				case 283:
				case 340://默认流下去，在本应用中，如果要用到则需要return 0;截掉
				case 640:
					code = "KEY_BACK";
					break;
				case 832:
				case 320:
					code = "KEY_RED";
					args.type = 1;
					break;
				case 45://音量减
				case 595:
				case 4110:
					code = "KEY_VOLUME_UP";
					break;
				case 61://音量加
				case 596:
				case 4109:
					code = "KEY_VOLUME_DOWN";
					break;
				case 597://静音建
				case 4108:
					code = "KEY_VOLUME_MUTE";
					break;
				case 835://blue
				case 323:
					code = "KEY_BLUE";
					break;
				case 322:
					code = "KEY_YELLOW";
					args.type = 1;
					break;
				case 833:
					code = "KEY_GREEN";
					break;
				case 372:
				case 290:
				case 306:
				case 33:
					code = "KEY_PAGE_UP";
					break;
				case 373:
				case 291:
				case 307:
				case 34:
					code = "KEY_PAGE_DOWN";
					break;
				case 67:
				case 77:
				case 99:
				case 597:
					code = "KEY_MUTE";
					break;
				case 263://暂停播放按键
				case 4160:
					code = "KEY_PAUSE";
					break;
				case 72://默认流下去，在本应用中，如果要用到则需要return 0;截掉
				case 104:
					code = "KEY_HOMEPAGE";
					args.type = 1;
					break;
				case 513://默认流下去，在本应用中，如果要用到则需要return 0;截掉
				case 104:	
				case 4098:
				case 4097:	
					code = "KEY_MENU";
					args.type = 1;
					break;
				case 5202://英立视----播放准备完成
					code = "EIS_VOD_PREPAREPLAY_SUCCESS";
					break;
				case 5203://英立视----连接服务器失败,建立会话失败或者服务器返回超时
					code = "EIS_VOD_CONNECT_FAILED";
					break;
				case 5205://英立视----播放成功
					code = "EIS_VOD_PLAY_SUCCESS";
					break;
				case 5206://英立视----播放失败
					code = "EIS_VOD_PLAY_FAILED";
					break;
				case 5209://时移频道或VOD影片播放到了点播开始的位置
					code = "EIS_VOD_PROGRAM_BEGIN";
					break;
				case 5210://时移频道或VOD影片播放到了点播结束的位置
					code = "EIS_VOD_PROGRAM_END";
					break;
				case 5211://拆链成功,一般是调用close接口后，SSP释放连接成功后发给页面的消息
					code = "EIS_VOD_RELEASE_SUCCESS";
					break;
				case 5220://VOD启动成功,服务数据已更新
					code = "EIS_VOD_CHANGE_SUCCESS";
					break;
				case 5221://VOD启动失败
					code = "EIS_VOD_START_FAILED";
					break;
				case 5222://底层开始缓冲数据，等待播放
					code = "EIS_VOD_START_BUFF";
					break;
				case 5223://缓冲数据结束，已开始播放
					code = "EIS_VOD_STOP_BUFF";
					break;
				case 5224://传入的时间超出有效范围
					code = "EIS_VOD_OUT_OF_RANGE";
					break;
				case 5226://收取自发现数据成功
					code = "EIS_VOD_GET_PARAMETER_SUCCESS";
					break;
				case 5227://收取自发现数据失败
					code = "EIS_VOD_GET_PARAMETER_FAILED";
					break;
				case 5225://英立视----播放出错
				case 40202://同洲----播放异常
					code = "EIS_VOD_USER_EXCEPTION";
					break;
				case 10909:
					code = "NGOD_C1_ANNOUNCE";
					break;
				case 5500:
				case 12057:	
					code = "IP_NETWORK_CONNECT";
					break;
				case 5501:
				case 12056:
					code = "IP_NETWORK_DISCONNECT";
					break;
				case 5502:
				case 12059:
					code = "IP_NETWORK_READY";
					break;
				case 5503:
				case 12058:
					code = "IP_NETWORK_FAILED";
					break;
				case 5551:
				case 10002:
					code = "CABLE_CONNECT_FAILED";
					break;
				case 5550:
				case 10001:	
					code = "CABLE_CONNECT_SUCCESS";
					break;
				case 13001:	//媒体源路径有效
					code = "MSG_MEDIA_URL_VALID";
					break;
				case 13002:	//媒体源路径无效
					code = "MSG_MEDIA_URL_INVALID";	
					break;
				case 13003:	//开始播放成功
				case 40201://同洲--当媒体播放器中的媒体播放到起始端时触发
					code = "MSG_MEDIA_PLAY_SUCCESS";
					break;
				case 13004:	//开始播放失败
					code = "MSG_MEDIA_PLAY_FAILED";	
					break;
				case 13005:	//步长设置成功
					code = "MSG_MEDIA_SETPACE_SUCCESS";
					break;
				case 13006:	//步长设置失败
					code = "MSG_MEDIA_SETPACE_FAILED";
					break;
				case 13007:	//设置播放时间点成功
					code = "MSG_MEDIA_SEEK_SUCCESS";
					break;
				case 13008:	//设置播放时间点失败
					code = "MSG_MEDIA_SEEK_FAILED";	
					break;
				case 13009:	//暂停播放成功
					code = "MSG_MEDIA_PAUSE_SUCCESS";
					break;
				case 13010:	//暂停播放失败
					code = "MSG_MEDIA_PAUSE_FAILED";
					break;
				case 13011:	//恢复播放成功
					code = "MSG_MEDIA_RESUME_SUCCESS";
					break;
				case 13012:	//恢复播放失败
					code = "MSG_MEDIA_RESUME_FAILED";			
					break;
				case 13013:	//停止播放成功
					code = "MSG_MEDIA_STOP_SUCCESS";			
					break;
				case 13014:	//停止播放失败
					code = "MSG_MEDIA_STOP_FAILED";
					break;
				case 13015:// 播放结束
					code = "MSG_MEDIA_END_OF_STREAM";
					break;
				case 13199://播放背景视频成功
					code = "MSG_BACKGROUND_VIDEO_PLAY_SUCCESS";
					args.type = returnTrueFlag;	
					break;
				case 13120://播放背景视频失败
					code = "MSG_BACKGROUND_VIDEO_PLAY_FAILED";
					args.type = returnTrueFlag;	
					break;
				default:
					code = "OTHER_EVENT";
					args.type = 1;
					break;
			}
		}
		return {code: code, args: args};
	}
}
/**************键值映射 end****************/

/**************showList封装 begin****************/
/*
 * showList对象的作用就是控制在页面列表数据信息上下滚动切换以及翻页；
 * @__listSize    列表显示的长度；
 * @__dataSize    所有数据的长度；
 * @__position    数据焦点的位置；
 * @__startplace  列表焦点Div开始位置的值；
 */
function showList(__listSize, __dataSize, __position, __startplace, __f){
	this.currWindow = typeof(__f)     =="undefined" ? window : __f;
	this.listSize = typeof(__listSize)=="undefined" ? 0 : __listSize;  //列表显示的长度；
	this.dataSize = typeof(__dataSize)=="undefined" ? 0 : __dataSize;  //所有数据的长度；
	this.position = typeof(__position)=="undefined" ? 0 : __position;  //当前数据焦点的位置；
	this.focusPos = 0;      //当前列表焦点的位置；
	this.lastPosition = 0;  //前一个数据焦点的位置；
	this.lastFocusPos = 0;  //前一个列表焦点的位置；
	this.tempSize = 0;  //实际显示的长度；
	this.infinite = 0; //记录数值，用来获取数据焦点的位置；
	
	this.pageStyle  = 0;  //翻页时焦点的定位，0表示不变，1表示移到列表首部；
	this.pageLoop   = null;  //是否循环翻页, true表示是，false表示否；
	this.showLoop   = null;  //是否循环显示内容,this.showLoop如果定义为true,则自动打开焦点首尾循环与循环翻页；
	this.focusLoop  = null;  //焦点是否首尾循环切换；
	this.focusFixed = null;  //焦点是否固定，this.focusFixed如果定义为true,则自动打开循环显示内容；
	this.focusVary  = 1;  //当焦点发生改变时，如果前后焦点差的绝对值大于此值时，焦点再根据this.focusStyle的值做表现处理，此值必需大于0，否则默认为1；
	this.focusStyle = 0;  //切换焦点时，列表焦点的表现样式，0是跳动，1表示滑动；
	
	this.showType = 1; //呈现的类型，0表示老的呈现方式，1表示新的滚屏呈现方式；	
	this.listSign = 0; //0表示top属性，1表示left属性, 也可以直接用"top"或"left"；
	this.listHigh = 30;  //列表中每个行的高度，可以是数据或者数组，例如：40 或 [40,41,41,40,42];
	this.listPage = 1;  //列表的总页数量；
	this.currPage = 1;  //当前焦点所在页数；
	
	this.focusDiv = -1;  //列表焦点的ID名称或者定义为滑动对象，例如："focusDiv" 或 new showSlip("focusDiv",0,3,40);
	this.focusPlace = new Array();  //记录每行列表焦点的位置值；
	this.startPlace = typeof(__startplace)=="undefined" ? 0 : __startplace;	 //列表焦点Div开始位置的值；
	
	this.haveData = function(){}; //在显示列表信息时，有数据信息就会调用该方法；
	this.notData = function(){}; //在显示列表信息时，无数据信息就会调用该方法；
	//调用以上两个方法都会收到参数为{idPos:Num, dataPos:Num}的对象，该对象属性idPos为列表焦点的值，属性dataPos为数据焦点的值；
	
	this.focusUp  = function(){this.changeList(-1);}; //焦点向上移动；
	this.focusDown= function(){this.changeList(1); }; //焦点向下移动；
	this.pageUp   = function(){this.changePage(-1);}; //列表向上鄱页；
	this.pageDown = function(){this.changePage(1); }; //列表向下鄱页；
	
	//开始显示列表信息
	this.startShow = function(){
		this.initAttrib();
		this.setFocus();
		this.showList();
	}
	//初始化所有属性；
	this.initAttrib = function(){	
		if(typeof(this.listSign)=="number") this.listSign = this.listSign==0 ? "top":"left";  //把数值转换成字符串；
		if(typeof(this.focusDiv)=="object") this.focusDiv.moveSign = this.listSign;  //设置滑动对象的方向值;
				
		if(this.focusFixed==null||(this.focusFixed&&this.showType==0)) this.focusFixed = false;  //初始化焦点是否固定，如果用户没有定义，则默认为false，如果当前showType是0，那么设置固定是无效的；
		if(this.showLoop  ==null) this.showLoop   = this.focusFixed ? true : false;  //初始化是否循环显示内容，如果用户没有定义并且焦点为固定，就会自动打开为true，否则为false, 需要注意的是焦点为固定时，不要强制定义为false;
		if(this.pageLoop  ==null) this.pageLoop   = this.showLoop ? true : false;	//初始化是否循环翻页，如果用户没有定义并且循环显示内容，就会自动打开为true，否则为false, 需要注意的是循环显示内容时，不要强制定义为false;
		if(this.focusLoop ==null) this.focusLoop  = this.showLoop ? true : false;   //初始化焦点是否首尾循环切换，如果用户没有定义并且循环显示内容，就会自动打开为true，否则为false, 需要注意的是循环显示内容时，不要强制定义为false;
		if(!this.focusFixed&&this.dataSize<this.listSize) this.showLoop = false;   //如果焦点不固定，并且数据长度小于列表显示长度，则强制设置循环显示内容为否；
		
		if(this.focusVary<1) this.focusVary = 1;
		if(this.focusPos>=this.listSize) this.focusPos = this.listSize-1;
		if(this.focusPos<0) this.focusPos = 0;
		if(this.position>=this.dataSize) this.position = this.dataSize-1;
		if(this.position<0) this.position = 0;
		this.lastPosition = this.infinite = this.position;
		
		this.initPlace();
		this.initFocus();
		this.lastFocusPos = this.focusPos;
	}
	//初始化焦点位置；
	this.initFocus = function(){
		this.tempSize = this.dataSize<this.listSize?this.dataSize:this.listSize;
		if(this.showType == 0){  //当前showType为0时，用户定义列表焦点是无效的，都会通过数据焦点来获取；
			this.focusPos = this.position%this.listSize;
		}else if(!this.focusFixed&&!this.showLoop){  //当前showType为1，焦点不固定并且不循环显示内容时，判断当前用户定义的列表焦点是否超出范围，如果是则重新定义；
			var tempNum = this.position-this.focusPos;
			if(tempNum<0||tempNum>this.dataSize-this.tempSize) this.focusPos = this.position<this.tempSize ? this.position : this.tempSize-(this.dataSize-this.position);
		}
	}
	//处理每行(列)所在的位置，并保存在数组里；
	this.initPlace = function(){
		var tmph = this.listHigh;
		var tmpp = [this.startPlace];		
		for(var i=1; i<this.listSize; i++) tmpp[i] = typeof(tmph)=="object" ? (typeof(tmph[i-1])=="undefined" ? tmph[tmph.length-1]+tmpp[i-1] : tmph[i-1]+tmpp[i-1]) : tmph*i+tmpp[0];
		this.focusPlace = tmpp;
	}
	//切换焦点的位置
	this.changeList = function(__num){
		if(this.dataSize==0) return;
		if((this.position+__num<0||this.position+__num>this.dataSize-1)&&!this.focusLoop) return;
		this.changePosition(__num);
		this.checkFocusPos(__num);
	}
	//切换数据焦点的值
	this.changePosition = function(__num){
		this.infinite += __num;
		this.lastPosition = this.position;	
		this.position = this.getPos(this.infinite, this.dataSize);
	}
	//调整列表焦点并刷新列表；
	this.checkFocusPos = function(__num){
		if(this.showType==0){	
			var tempNum  = this.showLoop ? this.infinite : this.position;
			var tempPage = Math.ceil((tempNum+1)/this.listSize);
			this.changeFocus(this.getPos(tempNum, this.listSize)-this.focusPos);
			if(this.currPage!=tempPage){ this.currPage = tempPage;this.showList(); }		
		}else{
			if((this.lastPosition+__num<0||this.lastPosition+__num>this.dataSize-1)&&!this.showLoop&&!this.focusFixed){
				this.changeFocus(__num*(this.tempSize-1)*-1);
				this.showList();
				return;
			}
			if(this.focusPos+__num<0||this.focusPos+__num>this.listSize-1||this.focusFixed){				
				this.showList();
			}else{
				this.changeFocus(__num);
			}
		}		
	}
	//切换列表焦点的位置
	this.changeFocus = function(__num){
		this.lastFocusPos = this.focusPos;
		this.focusPos += __num;
		this.setFocus(__num);
	}
	//设置调整当前焦点的位置；
	this.setFocus = function(__num){
		if(typeof(this.focusDiv)=="number") return;  //如果没定义焦点DIV，则不进行设置操作；
		var tempBool = this.focusStyle==0&&(Math.abs(this.focusPos-this.lastFocusPos)>this.focusVary||(Math.abs(this.position-this.lastPosition)>1&&!this.showLoop));  //当焦点发生改变时，根所前后焦点差的绝对值与focusStyle的值判断焦点表现效果；
		if(typeof(this.focusDiv)=="string"){  //直接设置焦点位置；
			this.$(this.focusDiv).style[this.listSign] = this.focusPlace[this.focusPos] + "px";
		}else if(typeof(__num)=="undefined"||tempBool){  //直接定位焦点；
			this.focusDiv.tunePlace(this.focusPlace[this.focusPos]);
		}else if(__num!=0){  //滑动焦点；
			this.focusDiv.moveStart(__num/Math.abs(__num), Math.abs(this.focusPlace[this.focusPos]-this.focusPlace[this.lastFocusPos]));
		}
	}	
	//切换页面列表翻页
	this.changePage = function(__num){	
		if(this.dataSize==0) return;
		var isBeginOrEnd = this.currPage+__num<1||this.currPage+__num>this.listPage;  //判断当前是否首页跳转尾页或尾页跳转首页;
		if(this.showLoop){   //如果内容是循环显示，则执行下面的翻页代码；
			if(isBeginOrEnd&&!this.pageLoop) return;
			var tempNum = this.listSize*__num;
			if(!this.focusFixed&&this.pageStyle!=0&&this.focusPos!=0){
				this.changePosition(this.focusPos*-1);
				this.checkFocusPos(this.focusPos*-1);
			}
			this.changePosition(tempNum);
			this.checkFocusPos(tempNum);
		}else{
			if(this.dataSize<=this.listSize) return;  //如果数据长度小长或等于列表显示长度，则不进行翻页；
			if(this.showType==0){
				if(isBeginOrEnd&&!this.pageLoop) return;   //如果是首页跳转尾页或尾页跳转首页, this.pageLoop为否，则不进行翻页；
				var endPageNum = this.dataSize%this.listSize;  //获取尾页个数;
				var isEndPages = (this.getPos(this.currPage-1+__num, this.listPage)+1)*this.listSize>this.dataSize;  //判断目标页是否为尾页;
				var overNum = isEndPages && this.focusPos >= endPageNum ? this.focusPos+1-endPageNum : 0;	  //判断目标页是否为尾页，如果是并且当前列表焦点大于或等于尾页个数，则获取它们之间的差；		
				var tempNum = isBeginOrEnd && endPageNum != 0 ? endPageNum : this.listSize;  //判断当前是否首页跳转尾页或尾页跳转首页，如果是并且尾页小于this.listSize，则获取当前页焦点与目标页焦点的差值，否则为默认页面显示行数；
				overNum = this.pageStyle==0 ? overNum : this.focusPos;  //判断当前翻页时焦点的style, 0表示不变，1表示移到列表首部；
				tempNum = tempNum*__num-overNum;				
				this.changePosition(tempNum);
				this.checkFocusPos(tempNum);
			}else{
				var tempPos   = this.position-this.focusPos;  //获取当前页列表首部的数据焦点；
				var tempFirst = this.dataSize-this.tempSize;  //获取尾页第一个数据焦点的位置；
				if(tempPos+__num<0||tempPos+__num>tempFirst){
					if(!this.pageLoop) return;  //不循环翻页时跳出，否则获取翻页后的数据焦点;
					tempPos = __num<0 ? tempFirst : 0;
				}else{
					tempPos += this.tempSize*__num;
					if(tempPos<0||tempPos>tempFirst) tempPos = __num<0 ? 0 : tempFirst;
				}		
				var tempNum = this.pageStyle==0||this.focusFixed ? this.focusPos : 0;  //判断当前翻页时焦点的style, 取得列表焦点位置；
				if(!this.focusFixed&&this.pageStyle!=0&&this.focusPos!=0) this.changeFocus(this.focusPos*-1);  //如果this.focusPos不为0，则移动列表焦点到列表首部；
				this.changePosition(tempPos-this.position+tempNum); 
				this.showList();
			}
		}
	}
	//显示列表信息
	this.showList = function(){
		var tempPos = this.position-this.focusPos;	 //获取当前页列表首部的数据焦点；
		for(var i=tempPos; i<tempPos+this.listSize; i++){		
			var tempObj = { idPos:i-tempPos, dataPos:this.getPos(i, this.dataSize) };  //定义一个对象，设置当前列表焦点和数据焦点值；
			( i >= 0 && i < this.dataSize)||(this.showLoop && this.dataSize !=0 ) ? this.haveData(tempObj) : this.notData(tempObj);  //当i的值在this.dataSize的范围内或内容循环显示时，调用显示数据的函数，否则调用清除的函数；
		}
		this.currPage = Math.ceil((this.position+1)/this.listSize);
		this.listPage = Math.ceil(this.dataSize/this.listSize);
	}
	//清除列表信息
	this.clearList = function(){
		for(var i=0; i<this.listSize; i++) this.notData( { idPos:i, dataPos:this.getPos(i, this.dataSize) } );
	}
	this.getPos = function(__num, __size){
		return __size==0 ? 0 : (__num%__size+__size)%__size;
	}
	this.$ = function(__id){
		return this.currWindow.document.getElementById(__id);
	}
}
/**************showList封装 end****************/

/**************滑动对象ScrollBar封装 begin****************/
/**
 * 滑动对象，用来显示当前位置占总位置的比例
 * @param id 可以滑动的模块
 * @param barId 控制滑动范围的模块
 */
/*滚动条封装*/
function ScrollBar(id, barId, f) {
	this.obj = null;
	this.barObj = null;
	if (typeof(f) == "object"){
		this.obj = f.document.getElementById(id);
		if(typeof(barId) != "undefined"){
			this.barObj = f.document.getElementById(barId);
		}
	} else {
		this.obj = iPanel.mainFrame.document.getElementById(id);
		if(typeof(barId) != "undefined"){
			this.barObj = iPanel.mainFrame.document.getElementById(barId);
		}
	}
	
	this.init = function(totalNum, pageSize, maxBarLength, startPos, type) {//最后一个参数表示固定滚动条的长度，如果要动态计算就不要传
		this.startPos = startPos;
		var percent = 1;
		if (totalNum > pageSize) {
			percent = pageSize / totalNum;
		}
		var barLength = percent * maxBarLength;
		if(typeof(type) != "undefined"){
			if(this.barObj != null){
				this.barObj.style.height = Math.round(barLength) + "px";
			}else{
				this.obj.style.height = Math.round(barLength) + "px";
			}
			this.endPos = this.startPos + (maxBarLength - barLength);
		}else{
			this.endPos = this.startPos + maxBarLength;
		}
		if(totalNum > 1){
			this.footStep = (this.endPos - this.startPos) / (totalNum - 1);
		}else{
			this.footStep = 0;
		}
	},
	
	this.scroll = function(currPos) {
		var tempPos = this.startPos + this.footStep * currPos;
		this.obj.style.top = Math.round(tempPos) + "px";
	}
}
/**************滑动对象ScrollBar封装 end****************/

/**************ajax请求封装 begin****************/
function ajaxClass(_url, _successCallback, _failureCallback, _urlParameters, _callbackParams, _async, _charset, _timeout, _frequency, _requestTimes, _frame) {
	/**
	 * AJAX通过GET或POST的方式进行异步或同步请求数据
	 * 注意：
	 * 	1、服务器240 No Content是被HTTP标准视为请求成功的
	 * 	2、要使用responseXML就不能设置_charset，需要直接传入null
	 * 	3、_frame，就是实例化本对象的页面对象，请尽量保证准确，避免出现难以解释的异常
	 */
	/**
	 * @param{string} _url: 请求路径
	 * @param{function} _successCallback: 请求成功后执行的回调函数，带一个参数（可扩展一个）：new XMLHttpRequest()的返回值
	 * @param{function} _failureCallback: 请求失败/超时后执行的回调函数，参数同成功回调，常用.status，.statusText
	 * @param{string} _urlParameters: 请求路径所需要传递的url参数/数据
	 * @param{*} _callbackParams: 请求结束时在回调函数中传入的参数，自定义内容
	 * @param{boolean} _async: 是否异步调用，默认为true：异步，false：同步
	 * @param{string} _charset: 请求返回的数据的编码格式，部分iPanel浏览器和IE6不支持，需要返回XML对象时不能使用
	 * @param{number} _timeout: 每次发出请求后多长时间内没有成功返回数据视为请求失败而结束请求（超时）
	 * @param{number} _frequency: 请求失败后隔多长时间重新请求一次
	 * @param{number} _requestTimes: 请求失败后重新请求多少次
	 * @param{object} _frame: 窗体对象，需要严格控制，否则会有可能出现页面已经被销毁，回调还执行的情况
	 */
	this.url = _url || "";
	this.successCallback = _successCallback || function(_xmlHttp, _params) {
		//iDebug("[xmlHttp] responseText: " + _xmlHttp.responseText);
	};
	this.failureCallback = _failureCallback || function(_xmlHttp, _params) {
		//iDebug("[xmlHttp] status: " + _xmlHttp.status + ", statusText: " + _xmlHttp.statusText);
	};
	this.urlParameters = _urlParameters || "";
	this.callbackParams = _callbackParams || null;
	this.async = typeof(_async) == "undefined" ? true : _async;
	this.charset = _charset || null;
	this.timeout = _timeout || 30000; //30s
	this.frequency = _frequency || 10000; //10s
	this.requestTimes = _requestTimes || 0;
	this.frame = _frame || window;

	this.timer = -1;
	this.counter = 0;

	this.method = "GET";
	this.headers = null;
	this.username = "";
	this.password = "";

	this.checkTimeout = 500;
	this.checkTimer = -1;
	this.checkCount = -1;

	this.createXmlHttpRequest = function() {
		var xmlHttp = null;
		try { //Standard
			xmlHttp = new XMLHttpRequest();
		} catch (exception) { //Internet Explorer
			try {
				xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (exception) {
				try {
					xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (exception) {
					return false;
				}
			}
		}
		return xmlHttp;
	};
	
	this.xmlHttp = this.createXmlHttpRequest();

	this.requestData = function(_method, _headers, _username, _password) {
		/**
		 * @param{string} _method: 传递数据的方式，POST/GET
		 * @param{string} _headers: 传递数据的头信息，json格式
		 * @param{string} _username: 服务器需要认证时的用户名
		 * @param{string} _password: 服务器需要认证时的用户密码
		 */
		this.xmlHttp = this.createXmlHttpRequest();
		this.frame.clearTimeout(this.timer);
		this.method = typeof(_method) == "undefined" ? "GET" : (_method.toLowerCase() == "post") ? "POST" : "GET";
		this.headers = typeof(_headers) == "undefined" ? null : _headers;
		this.username = typeof(_username) == "undefined" ? "" : _username;
		this.password = typeof(_password) == "undefined" ? "" : _password;

		var target = this;
		this.xmlHttp.onreadystatechange = function() {
			target.stateChanged();
		};
		if (this.method == "POST") { //encodeURIComponent
			var url = encodeURI(this.url);
			var data = this.urlParameters;
		} else {
			var url = this.url;
			var data = null;
		}
		if (this.username != "") {
			this.xmlHttp.open(this.method, url, this.async, this.username, this.password);
		} else {
			this.xmlHttp.open(this.method, url, this.async);
		}
		var contentType = false;
		if (this.headers != null) {
			for (var key in this.headers) {
				if (key.toLowerCase() == "content-type") {
					contentType = true;
				}
				this.xmlHttp.setRequestHeader(key, this.headers[key]);
			}
		}
		if (!contentType) {
			this.xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		}
		// 要使用responseXML就不能设置此属性，3.0盒子不支持此属性
		var ua = navigator.userAgent.toLowerCase();
		if (this.charset != null&&(!/ipanel/.test(ua)||/advanced/.test(ua))) {
			this.xmlHttp.overrideMimeType("text/html; charset=" + this.charset);
		}
		this.xmlHttp.send(data);
		this.checkReadyState();
		this.timer = this.frame.setTimeout(function(){
			target.checkStatus();
		}, this.timeout);
	};
	this.checkReadyState = function(){
		var target = this;
		this.frame.clearTimeout(this.checkTimer);
		this.checkTimer = this.frame.setTimeout(function() {
			if(target.xmlHttp.readyState == 4 && (target.xmlHttp.status == 200 || target.xmlHttp.status == 204 || target.xmlHttp.status == 0)){
				target.stateChanged();
			}else{
				target.checkCount++;
				if((target.checkCount * target.checkTimeout) >= target.timeout){
					target.checkStatus();
				}else {
					target.checkReadyState();
				}
			}
        }, this.checkTimeout);
	};
	this.stateChanged = function() { //状态处理
		//iDebug("[xmlHttp] readyState=" + this.xmlHttp.readyState);
		var target = this;
		if (this.xmlHttp.readyState > 2) {
			//iDebug("[xmlHttp] status="+this.xmlHttp.status);
		}
		if (this.xmlHttp.readyState == 3) {
			if (this.xmlHttp.status == 401) {
				//iDebug("[xmlHttp] Authentication, need correct username and pasword");
			}
		} else if (this.xmlHttp.readyState == 4) {
			this.frame.clearTimeout(this.timer);
			this.frame.clearTimeout(this.checkTimer);
			if (this.xmlHttp.status == 200 || this.xmlHttp.status == 204 ||this.xmlHttp.status == 0){
				this.success();
			}else {
				this.failed();
			}
		}
	};
	this.success = function() {
		this.checkCount = -1;
		this.frame.clearTimeout(this.checkTimer);
		if (this.callbackParams == null) {
			this.successCallback(this.xmlHttp);
		} else {
			this.successCallback(this.xmlHttp, this.callbackParams);
		}
		this.counter = 0;
	};
	this.failed = function() {
		this.checkCount = -1;
		this.frame.clearTimeout(this.checkTimer);
		if (this.callbackParams == null) {
			this.failureCallback(this.xmlHttp);
		} else {
			this.failureCallback(this.xmlHttp, this.callbackParams);
		}
		this.counter = 0;
	};
	this.checkStatus = function() { //超时处理，指定时间内没有成功返回信息按照失败处理
		if (this.xmlHttp.readyState != 4) {
			if (this.counter < this.requestTimes) {
				this.requestAgain();
			} else {
				this.failed();
				this.requestAbort();
			}
		}
	};
	this.requestAgain = function() {
		this.requestAbort();
		var target = this;
		this.frame.clearTimeout(this.timer);
		this.timer = this.frame.setTimeout(function() {
			target.counter++;
			target.requestData(target.method, target.headers, target.username, target.password);
		}, this.frequency);
	};
	this.requestAbort = function() {
		this.checkCount = -1;
		this.frame.clearTimeout(this.timer);
		this.frame.clearTimeout(this.checkTimer);
		////iDebug("[xmlHttp] call abort typeof this.xmlHttp="+typeof this.xmlHttp);
		////iDebug("[xmlHttp] call abort typeof this.xmlHttp.abort="+typeof this.xmlHttp.abort);
		//abort()方法可以停止一个XMLHttpRequest对象对HTTP的请求，把该对象恢复到初始状态
		this.xmlHttp.abort();
	};
	this.addParameter = function(_json) {
		/**
		 * @param{object} _json: 传递的参数数据处理，只支持json格式
		 */
		var url = this.url;
		var str = this.urlParameters;
		for (var key in _json) {
			if (url.indexOf("?") != -1) {
				url = "";
				if (str == "") {
					str = "&" + key + "=" + _json[key];
				} else {
					str += "&" + key + "=" + _json[key];
				}
				continue;
			}
			if (str == "") {
				// str += "?";
			} else {
				str += "&";
			}
			str += key + "=" + _json[key];
		}
		this.urlParameters = str;
		return str;
	};
	this.getResponseXML = function() { //reponseXML of AJAX is null when response header 'Content-Type' is not include string 'xml', not like 'text/xml', 'application/xml' or 'application/xhtml+xml'
		if (this.xmlHttp.responseXML != null) {
			return this.xmlHttp.responseXML;
		} else if (this.xmlHttp.responseText.indexOf("<?xml") != -1) {
			return typeof(DOMParser) == "function" ? (new DOMParser()).parseFromString(this.xmlHttp.responseText, "text/xml") : (new ActivexObject("MSXML2.DOMDocument")).loadXML(this.xmlHttp.responseText);
		}
		return null;
	};
}
/**************ajax请求封装 end****************/

/**************返回字符串汉字长度 英文或特殊字符两个相当于一个汉字 begin****************/
/*
 *str:传入的字符串
 *len:字符串的最大长度
 *返回截取的字符串
 */
function getStrChineseLen(str, len) {
	var w = 0,flag = 0,c;
	str = str.replace(/[ ]*$/g, "");
	if (getStrChineseLength(str) > len) {
		for (var i = 0; i < str.length; i++) {
			c = str.charCodeAt(i);
			//单字节加1
			if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
				w++;
				flag = 0;
			} else {
				w += 2;
				flag = 1;
			}
			if (parseInt((w + 1) / 2) > len) {
				if (flag == 1) return str.substring(0, i - 1) + "...";
				else return str.substring(0, i - 2) + "...";
				break;
			}

		}
	}
	return str;
}

function getStrChineseLength(str) {
	str = str.replace(/[ ]*$/g, "");
	var w = 0;
	for (var i = 0; i < str.length; i++) {
		var c = str.charCodeAt(i);
		//单字节加1
		if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
			w++;
		} else {
			w += 2;
		}
	}
	var length = w % 2 == 0 ? (w / 2) : (parseInt(w / 2) + 1);
	return length;
}
/**************返回字符串汉字长度 英文或特殊字符两个相当于一个汉字 end****************/

/**************检查字符串是否为有效值 begin****************/
function checkStrNull(_str){
	var tmpStr = "";
	if(typeof(_str) == "undefined" || _str == null || _str == "undefined" || _str == "null"){
		tmpStr = "";
	}else{
		tmpStr = _str;
	}	
	return tmpStr;
}
/**************检查字符串是否为有效值 end****************/

/**************将json对象转化为json串 begin****************/
function jsonToString(_obj) {
	if (typeof(JSON) == "object" && typeof(JSON.stringify) == "function") {
		return JSON.stringify(_obj);
	}
	var THIS = this;
	switch (typeof(_obj)) {
	case "string":
		return "\"" + _obj.replace(/(["\\])/g, "\\$1") + "\"";
	case "array":
		return "[" + _obj.map(THIS.jsonToString).join(",") + "]";
	case "object":
		if (_obj instanceof Array) {
			var strArr = [];
			var len = _obj.length;
			for (var i = 0; i < len; i++) {
				strArr.push(THIS.jsonToString(_obj[i]));
			}
			return "[" + strArr.join(",") + "]";
		} else if (_obj == null) {
			return "null";
		} else {
			var string = [];
			for (var property in _obj) {
				string.push(THIS.jsonToString(property) + ":" + THIS.jsonToString(_obj[property]));
			}
			return "{" + string.join(",") + "}";
		}
	case "number":
		return _obj;
	default:
		return _obj;
	}
}
/**************将json对象转化为json串 end****************/

function isValid(arg) {
	if(arg != null && arg != "" && arg != "undefined" && typeof arg != "undefined" && !isNaN(arg)) {
		return true;
	} 
	return false;
}

/**************获取url中携带参数 begin****************/
function getParam(_type,_url){
	var url = _url || window.location.search;
	if(new RegExp(".*\\b"+_type+"\\b(\\s*=([^&]+)).*", "gi").test(_url)){
		return RegExp.$2;
	}else{
		return null;
	}
}
/**************获取url中携带参数 end****************/

/**************滚动字符串,长度为汉字的长度 begin****************/
function marqueeStr(_str,_len,_flag){
	var tmpStr = checkStrNull(_str);
	if(tmpStr == "") return tmpStr;
	var marqStr = _str;
	var len = getStrChineseLength(_str);
	if(len > _len){
		if(typeof(_flag) != "undefined"){//传参数表示需要设置marquee的width属性
			if(_flag.indexOf("px") != -1 || _flag.indexOf("%") != -1){
				marqStr = "<marquee scrollAmount='3' width='" + _flag + "' >" + _str + "</marquee>";	
			}else{
				marqStr = "<marquee scrollAmount='3'>" + _str + "</marquee>";
			}
		}else{
			marqStr = "<marquee scrollAmount='3'>" + _str + "</marquee>";	
		}
	}
	return marqStr;
}
/**************滚动字符串,长度为汉字的长度 end****************/

/**************设置、获取、移除全局变量 begin****************/
function setGlobalVar(sName,sValue) {
	try {
		if(typeof GlobalVarManager != "undefined") {
			if(typeof sValue == "string") {
				GlobalVarManager.setItemStr(sName,sValue);
			} else {
				GlobalVarManager.setItemValue(sName, sValue);
			}
		} else if(typeof iPanel != "undefined") {
			iPanel.setGlobalVar(sName, sValue);
		} else if(typeof Utility != "undefined"){//同洲
			Utility.setEnv(sName, sValue);
		} else {
			sessionStorage.setItem(sName, sValue);
		}
	} catch(e) {
		document.cookie = escape(sName) + "=" + escape(sValue);
	}
}

function getGlobalVar(sName) {
	var result = null;
	try {
		if(typeof GlobalVarManager != "undefined") {
			result = GlobalVarManager.getItemValue(sName);
			if(!isValid(result)) {
				result = GlobalVarManager.getItemStr(sName);
			}
		} else if(typeof iPanel != "undefined") {
			result = iPanel.getGlobalVar(sName);
		} else if(typeof Utility != "undefined"){
			result = Utility.getEnv(sName)
		} else {
			result = sessionStorage.getItem(sName);
		}
	} catch(e) {
		var aCookie = document.cookie.split("; ");
		for (var i = 0,num=aCookie.length; i < num; i++) {
			var aCrumb = aCookie[i].split("=");
			if(escape(sName) == aCrumb[0]) {
				result = unescape(aCrumb[1]);
				break;
			}
		}
	}
	return result;
}

function delGlobalVar(sName) {
	try {
		if(typeof(GlobalVarManager) != "undefined") {
			GlobalVarManager.removeItem(sName);
		} else if(typeof iPanel != "undefined") {
			iPanel.delGlobalVar(sName);
		} else if(typeof Utility != "undefined"){//同洲
			Utility.setEnv(sName,"");
		} else {
			sessionStorage.removeItem(sName);
		}
	} catch(e) {
		var exp = new Date();
		exp.setTime(exp.getTime() - 1);
		var cval = getGlobalVar(sName);
		document.cookie = sName + "=" + cval + "; expires=" + exp.toGMTString();
	}
}
/**************设置、获取、移除全局变量 end****************/

/**************给Date对象添加Format方法***************/
Date.prototype.Format = function (fmt) {
    var Week = ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'];  
    var o = {
        "y+": this.getYear(),
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
		"w":this.getDay()
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o){
		if(new RegExp("(" + k + ")").test(fmt)){
			if(k == "w" || k == "W"){
				fmt = fmt.replace(RegExp.$1,Week[this.getDay()]);
			}else{
				fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
			}
		}
	}
    return fmt;
};
/**************Date对象封装 end****************/

function iDebug(str){
	if(configFlag == true && $("logDebug")){
		$("logTxt").innerHTML += "<p>"+str+"</p>";
		$("logDebug").style.visibility = "visible";
		if($("logTxt").offsetHeight > 1200){
			$("logTxt").innerHTML = "";
		}
	}else{
		if(navigator.appName.indexOf("iPanel") != -1){
			iPanel.debug(str);	
		}else if(navigator.appName.indexOf("Opera") != -1){
			opera.postError(str);
		}else if(typeof rocmeSTB!="undefined"){//内蒙古省网数码
			rocmeSTB.event.debug(str);
		}else if(navigator.appName.indexOf("Netscape") != -1 || navigator.appName.indexOf("Google") != -1){
			console.log(str);
		}else if(typeof MediaPlayer != "undefined"&&typeof Search != "undefined"){//同洲
			Utility.println("JSPrint", "0x3FFFFFFF", str)
		}else if(typeof DRMPlayer != "undefined"){
			DRMPlayer.log(str);
		}else{
			console.log(str);
		}
	}
}

function $(id){
	return document.getElementById(id);
}

/**注册安卓盒子的返回按键问题**/
function keyCallback(json){
	iDebug("keyCallback json="+json);
  	var jsonObj = eval ("("+json+")");
  	if(jsonObj.code == 4 && jsonObj.action == "1"){
    	goBack();
    	return;
  	}
}

function registerKeyEvent(){
	iDebug("typeof DRMPlayer="+typeof DRMPlayer+" typeof iPanel="+typeof iPanel);
	if(typeof DRMPlayer != "undefined"){//如果是安卓apk跑的，需要支持回调
		DRMPlayer.setKeyEventCallback('keyCallback');
		if(typeof eventCallback != "undefined"){
			DRMPlayer.setCallback('eventCallback');
		}
	}else if(typeof iSTB != "undefined"){
		iSTB.evt.set_event_callback("eventCallback");
	}
}

function getPlayUrlByType(_urlArr,_keyWords,_nokeyWords){//_nokeyWords为不能包含的关键字
	if(typeof _urlArr == "undefined"||_urlArr.length == 0) return null;//没有播放地址的情况下
	for(var i=0;i<_urlArr.length;i++){
		if(_urlArr[i].indexOf(_keyWords) > -1){
			if(typeof(_nokeyWords) != "undefined" && _urlArr[i].indexOf(_nokeyWords)>-1) continue;
			if (_urlArr[i].indexOf("rtsp://") > -1) {
				
				iDebug("[common.js]-----_urlArr[i]-----"+_urlArr[i]);
			}else if (_urlArr[i].indexOf("iad://") > -1) {
				_urlArr[i] += "?qamname="+(iPanel.eventFrame.area_code?iPanel.eventFrame.area_code:"123");
				iDebug("[common.js]-----_urlArr[i]-----"+_urlArr[i]);
			}
			return _urlArr[i];
		}
	}
	return null;//如果没有匹配的话，就不播放
}