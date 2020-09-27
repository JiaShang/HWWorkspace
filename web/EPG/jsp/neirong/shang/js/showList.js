var isP60 = typeof sysmisc != 'undefined';
var HD30 = typeof iPanel != 'undefined' && typeof iPanel.eventFrame.systemId == 'undefined';
var isGW = typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 2;
var isP30 = typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 1;

// focusUp();      //焦点向上移动；
// focusDown(); //焦点向下移动；
// pageUp();      //列表向前鄱页；
// pageDown(); //列表向后翻页；
// clearList();     //清除列表信息
// changeList(__num); //焦点移动

function showList(__listSize, __dataSize, __position, __startplace, __f){
	this.currWindow = typeof(__f)     =="undefined" ? window : __f;
	this.listSize = typeof(__listSize)=="undefined" ? 0 : __listSize;  
	this.dataSize = typeof(__dataSize)=="undefined" ? 0 : __dataSize;  
	this.position = typeof(__position)=="undefined" ? 0 : __position; 
	this.focusPos = 0;      
	this.lastPosition = 0;  
	this.lastFocusPos = 0;  
	this.tempSize = 0;  
	this.infinite = 0; 
	
	this.pageStyle  = 0;  
	this.pageLoop   = null; 
	this.showLoop   = null; 
	this.focusLoop  = null;  
	this.focusFixed = null;  
	this.focusVary  = 1; 
	this.focusStyle = 0;  
	
	this.showType = 1; 	
	this.listSign = 0; 
	this.listHigh = 30;  
	this.listPage = 1;  
	this.currPage = 1; 
	
	this.focusDiv = -1;  
	this.focusPlace = new Array(); 
	this.startPlace = typeof(__startplace)=="undefined" ? 0 : __startplace;	
	
	this.haveData = function(){}; 
	this.notData = function(){}; 
	
	
	this.focusUp  = function(){this.changeList(-1);};
	this.focusDown= function(){this.changeList(1); }; 
	this.pageUp   = function(){this.changePage(-1);}; 
	this.pageDown = function(){this.changePage(1); }; 
	

	this.startShow = function(){
		this.initAttrib();
		this.setFocus();
		this.showList();
	}
	
	this.initAttrib = function(){	
		if(typeof(this.listSign)=="number") this.listSign = this.listSign==0 ? "top":"left";  
		if(typeof(this.focusDiv)=="object") this.focusDiv.moveSign = this.listSign;  
				
		if(this.focusFixed==null||(this.focusFixed&&this.showType==0)) this.focusFixed = false; 
		if(this.showLoop  ==null) this.showLoop   = this.focusFixed ? true : false; 
		if(this.pageLoop  ==null) this.pageLoop   = this.showLoop ? true : false;	
		if(this.focusLoop ==null) this.focusLoop  = this.showLoop ? true : false;   
		if(!this.focusFixed&&this.dataSize<this.listSize) this.showLoop = false;   
		
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
	
	this.initFocus = function(){
		this.tempSize = this.dataSize<this.listSize?this.dataSize:this.listSize;
		if(this.showType == 0){
			this.focusPos = this.position%this.listSize;
		}else if(!this.focusFixed&&!this.showLoop){ 
			var tempNum = this.position-this.focusPos;
			if(tempNum<0||tempNum>this.dataSize-this.tempSize) this.focusPos = this.position<this.tempSize ? this.position : this.tempSize-(this.dataSize-this.position);
		}
	}
	
	this.initPlace = function(){
		var tmph = this.listHigh;
		var tmpp = [this.startPlace];		
		for(var i=1; i<this.listSize; i++) tmpp[i] = typeof(tmph)=="object" ? (typeof(tmph[i-1])=="undefined" ? tmph[tmph.length-1]+tmpp[i-1] : tmph[i-1]+tmpp[i-1]) : tmph*i+tmpp[0];
		this.focusPlace = tmpp;
	}
	
	this.changeList = function(__num){
		if(this.dataSize==0) return;
		if((this.position+__num<0||this.position+__num>this.dataSize-1)&&!this.focusLoop) return;
		this.changePosition(__num);
		this.checkFocusPos(__num);
	}
	
	this.changePosition = function(__num){
		this.infinite += __num;
		this.lastPosition = this.position;	
		this.position = this.getPos(this.infinite, this.dataSize);
	}
	
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
	
	this.changeFocus = function(__num){
		this.lastFocusPos = this.focusPos;
		this.focusPos += __num;
		this.setFocus(__num);
	}
	
	this.setFocus = function(__num){
		if(typeof(this.focusDiv)=="number") return;  
		var tempBool = this.focusStyle==0&&(Math.abs(this.focusPos-this.lastFocusPos)>this.focusVary||(Math.abs(this.position-this.lastPosition)>1&&!this.showLoop));  //当焦点发生改变时，根所前后焦点差的绝对值与focusStyle的值判断焦点表现效果；
		if(typeof(this.focusDiv)=="string"){  
			this.$(this.focusDiv).style[this.listSign] = this.focusPlace[this.focusPos] + "px";
		}else if(typeof(__num)=="undefined"||tempBool){  
			this.focusDiv.tunePlace(this.focusPlace[this.focusPos]);
		}else if(__num!=0){  
			this.focusDiv.moveStart(__num/Math.abs(__num), Math.abs(this.focusPlace[this.focusPos]-this.focusPlace[this.lastFocusPos]));
		}
	}	
	
	this.changePage = function(__num){	
		if(this.dataSize==0) return;
		var isBeginOrEnd = this.currPage+__num<1||this.currPage+__num>this.listPage;  
		if(this.showLoop){   
			if(isBeginOrEnd&&!this.pageLoop) return;
			var tempNum = this.listSize*__num;
			if(!this.focusFixed&&this.pageStyle!=0&&this.focusPos!=0){
				this.changePosition(this.focusPos*-1);
				this.checkFocusPos(this.focusPos*-1);
			}
			this.changePosition(tempNum);
			this.checkFocusPos(tempNum);
		}else{
			if(this.dataSize<=this.listSize) return; 
			if(this.showType==0){
				if(isBeginOrEnd&&!this.pageLoop) return;   
				var endPageNum = this.dataSize%this.listSize;  
				var isEndPages = (this.getPos(this.currPage-1+__num, this.listPage)+1)*this.listSize>this.dataSize;  
				var overNum = isEndPages && this.focusPos >= endPageNum ? this.focusPos+1-endPageNum : 0;	
				var tempNum = isBeginOrEnd && endPageNum != 0 ? endPageNum : this.listSize;
				overNum = this.pageStyle==0 ? overNum : this.focusPos;
				tempNum = tempNum*__num-overNum;				
				this.changePosition(tempNum);
				this.checkFocusPos(tempNum);
			}else{
				var tempPos   = this.position-this.focusPos;  
				var tempFirst = this.dataSize-this.tempSize;  
				if(tempPos+__num<0||tempPos+__num>tempFirst){
					if(!this.pageLoop) return; 
					tempPos = __num<0 ? tempFirst : 0;
				}else{
					tempPos += this.tempSize*__num;
					if(tempPos<0||tempPos>tempFirst) tempPos = __num<0 ? 0 : tempFirst;
				}		
				var tempNum = this.pageStyle==0||this.focusFixed ? this.focusPos : 0; 
				if(!this.focusFixed&&this.pageStyle!=0&&this.focusPos!=0) this.changeFocus(this.focusPos*-1); 
				this.changePosition(tempPos-this.position+tempNum); 
				this.showList();
			}
		}
	}
	
	this.showList = function(){
		var tempPos = this.position-this.focusPos;	 
		for(var i=tempPos; i<tempPos+this.listSize; i++){		
			var tempObj = { idPos:i-tempPos, dataPos:this.getPos(i, this.dataSize) };  
			( i >= 0 && i < this.dataSize)||(this.showLoop && this.dataSize !=0 ) ? this.haveData(tempObj) : this.notData(tempObj);  
		}
		this.currPage = Math.ceil((this.position+1)/this.listSize);
		this.listPage = Math.ceil(this.dataSize/this.listSize);
	}
	
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
	
	this.init = function(totalNum, pageSize, maxBarLength, startPos, type) {
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

function getStrChineseLength(str){
	str = str.replace(/[ ]*$/g,"");
	var w = 0;
	for (var i=0; i<str.length; i++) {
		var c = str.charCodeAt(i);

		if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
			w++;
		}else {
			w+=2;
		}
	}
	var length = w % 2 == 0 ? (w/2) : (parseInt(w/2)+1) ;
	return length;
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
	var flag0 = 0;
	var flag1 = 0;
	var flag2 = 0;
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

function checkStrNull(_str){
	var tmpStr = "";
	if(typeof(_str) == "undefined" || _str == "null" || _str == "undefined"){
		tmpStr = "";
	}else{
		tmpStr = _str;
	}
	return tmpStr;
}


// var scrollFlag = 1; //0：不显示滚动条，显示滚动条
// var scrollWay = 2;  //1：按数据个数滑动，按数据页数滑动
// var scrollData = 2; //1：按数据个数显示，按数据页数显示

function initScroll(dataSize,pageCount,listPage){  //总数据长度，每页数据个数，总数据页数
	if(scrollFlag && dataSize>pageCount){
		$("scrollLower").style.visibility= "visible";
		$("scrollUpper").style.visibility= "visible";
		if (typeof scrollData != "undefined") {

            if (scrollData == 1 || scrollData == "1"){
                if(dataSize >= 10){
                    $("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />"+dataSize;
                }else{
                    $("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />&nbsp;"+dataSize;
                }
            }else if (scrollData == 2 || scrollData == "2"){
                if(listPage >= 10){
                    $("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />"+listPage;
                }else{
                    $("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />&nbsp;"+listPage;
                }
            }
        }

		// if(scrollWay=="undefined" || scrollWay==1){
		// 	var barLength=$("lists").offsetHeight-10;
		// 	var barLeft=$("listName0").offsetLeft+$("listName0").offsetWidth+20;
		// 	var scrollHeight=barLength/dataSize.toFixed(2);
		// }else{
		// 	var barLength=$("lists").offsetHeight-10;
		// 	var barLeft=$("listName0").offsetLeft+$("listName0").offsetWidth+leftSpace*(row-1)+20;
		// 	var scrollHeight=barLength/listPage.toFixed(2);
		// }
		// $("scrollLower").style.height=barLength+"px";
		// $("scrollLower").style.left=barLeft+"px";
		// $("scrollUpper").style.height=scrollHeight+"px";
	}else{
		$("scrollLower").style.visibility= "hidden";
		$("scrollUpper").style.visibility= "hidden";
	}
}
function scrollChange(dataSize,position,currPage,listPage){  //总数据长度，数据焦点，当前页数，数据总页数
	var lowerBarLength=$("scrollLower").offsetHeight;
	var upperBarLength=$("scrollUpper").offsetHeight;
	if(typeof scrollWay=="undefined" || scrollWay==1 || scrollWay== "1"){
		var percent = Number( (position/(dataSize-1)).toFixed(2));
		$("scrollUpper").style.top=percent*(lowerBarLength-upperBarLength)+"px";
	}else{
		var percent = Number(((currPage-1)/(listPage-1)).toFixed(2));
		$("scrollUpper").style.top=percent*(lowerBarLength-upperBarLength)+"px";
	}
    if (typeof scrollData != "undefined") {
        if (scrollData == 1 || scrollData == "1"){
            if(listBox.dataSize >= 10){
                if(listBox.position+1 >= 10){
                    $("scrollUpper").innerHTML = (position+1)+"<br />&nbsp;/<br />"+dataSize;
                }else{
                    $("scrollUpper").innerHTML = "&nbsp;"+(position+1)+"<br />&nbsp;/<br />"+dataSize;
                }
            }else {
                $("scrollUpper").innerHTML = "&nbsp;"+(position+1)+"<br />&nbsp;/<br />&nbsp;"+dataSize;
            }
        }else if (scrollData == 2 || scrollData == "2"){
            if(listBox.listPage >= 10){
                if(listBox.currPage+1 >= 10){
                    $("scrollUpper").innerHTML = currPage+"<br />&nbsp;/<br />"+listPage;
                }else{
                    $("scrollUpper").innerHTML = "&nbsp;"+currPage+"<br />&nbsp;/<br />"+listPage;
                }
            }else {
                $("scrollUpper").innerHTML = "&nbsp;"+currPage+"<br />&nbsp;/<br />&nbsp;"+listPage;
            }
        }
    }
}
function compare(key,desc) {
    return function (value1, value2) {
        var val1 = value1.key;
        var val2 = value2.key;
        if (desc == 1){
            return val2 - val1;  //由大到小  降序
        }
        return val1 - val2;    //由小到大   升序
    }
}
function sortByKey(array,key,desc){
    return array.sort(function(a,b){
        var x = a[key];
        var y = b[key];
        if (desc == 1){
            return y - x;  //由大到小  降序
        }
        return x - y;    //由小到大   升序
        // return((x<y)?-1:((x>y)?1:0));
    })
}

///////////////电话号/////////////////
function isTelephone(obj){
	//iPanel.debug("bangdingIndex.htm  isTelephone  obj ==="+obj);
	if((/^1[3|4|5|7|8]\d{9}$/.test(obj))){
		return true;
	}else {
		return false;
	}
}
function checkInput(id1,id2){
	var obj = $(id1).innerText;
	// obj = obj.substring(0,obj.length-1)
    var isPhoneError = true;
	if(obj.length == 0 || obj == ""){
		var str = "请输入您的电话号码!";
		showTipText(str,id2);
	}else if(!isTelephone(obj)){
		var str = "号码有误,请重新输入!";
		showTipText(str,id2);
	}else{
		isPhoneError = false;
	}
	// return true;
	return isPhoneError;
}
function showTipText(str,id) {
	$(id).innerText = str;
}

//输入手机号
function getInputNum(_num,id){  ///输入的数字，手机号显示框id，焦点是否在手机号显示框上
	// var str = (_num - 48).toString();
    var str = _num.toString();
	var tmp = $(id).innerText;
	if(tmp.length  == 12) return;
	// tmp += str;
    tmp = tmp.substring(0,tmp.length-1)+str+"|";
    $(id).innerText = tmp;

}
//回滚手机号
function rollBackInputNum(id){
	var temp = 	$(id).innerText;
	if(temp.length  == 0) return;
	var inputKey = temp.substring(0,temp.length-2)+"|";
	$(id).innerText = inputKey;
}
//删除输入的数据
function delInputNum(id){
	var temp = 	$(id).innerText;
	// if(temp.length  == 0) return;
	// var inputKey = temp.substr(0,temp.length-1);
	$(id).innerText = "请输入您的电话号码!";
}
//获取url字段
function getUrlParams(_key, _url) {
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
//获取字符串字段
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
function timeCount(startTime,timeTable) {
	var currentTime = new Date().getTime();
	if (currentTime < startTime) {
		$("time").style.visibility = "visible";
		var dif = startTime - currentTime;
		var day = Math.floor(dif / (24 * 60 * 60 * 1000));
		var hour = Math.floor((dif / (60 * 60 * 1000) - day * 24));
		var min = Math.floor(((dif / (60 * 1000)) - day * 24 * 60 - hour * 60));
		var sec = Math.floor(((dif / 1000) - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60));
		timeTable[0] = day;
		timeTable[1] = hour;
		timeTable[2] = min;
		timeTable[3] = sec;
	}
	return timeTable;

	// 	if (day == 0 && hour == 0){
	// 		$("time").innerText = min + "分";
	// 	} else if (day == 0 && hour != 0) {
	// 		$("time").innerText = hour + "时" + min + "分";
	// 	}else {
	// 		$("time").innerText = day + "天" + hour + "时" + min + "分";
	// 	}
	// }else if (currentTime < endTime) {
	// 	$("time").innerText = "直播进行中...";
	// }else {
	// 	$("time").style.visibility = "hidden";
	// }
//	<div id="time" style="position: absolute;width: 300px;height: 200px;left: 870px;top: 165px; overflow:hidden; background: transparent no-repeat; color: #ffbf5a;font-size: 50px;visibility: hidden;" ></div>
}
function getWeekday() {
	var d=new Date()
	var weekday=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
	return weekday[d.getDay()];
}
function betweenHour(startHour,startMin,endHour,endMin) {
	var d=new Date();
	if (d.getHours()<endHour && d.getHours()>startHour ) {
		return true;
	}else if (d.getHours() == endHour){
		if (d.getMinutes()< endMin){
			return true;
		}
	}else if (d.getHours() == startHour){
		if (d.getMinutes()> startMin){
			return true;
		}
	}
	return false;
}
function betweenDay(startDay,endDay) {
	var startTime = new Date(startDay).getTime();
	var endTime = new Date(endDay).getTime();  //"2020-08-08 10:0:0"
	var currentTime = new Date().getTime();
	if (currentTime < endTime &&  startTime < currentTime){
		return 0;
	}if (currentTime > endTime){
		return 1;
	}if (startTime > currentTime){
		return -1;
	}
}

