<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="ifeng_index_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title>凤凰专区</title>

<script type="application/javascript" src="js/showList.js"></script>
<script type="application/javascript" src="js/tool.js"></script>
<script>
iPanel.eventFrame.initPage(window);
E.is_HD_vod = true;

var focusArea = 1;  // 0右上导航区域 1左边栏目区域 2 中间视频 3中间图片区域  4文字推荐焦点 5右边海报 6右下焦点
var topButtonPos = 0;   //右上角导航栏目的焦点
var columnPos = 0;   //左边栏目的焦点
var videoPos = 0;   //中间视频区域
var picPos = 0; //中间图片焦点
var listFocusPos = 0;     //文字推荐焦点
var loopBigImgPos = 0; //右边海报焦点

var listData = [];
var listBox = null;
var picData = [];
var posterData = [];

var typeId = "";
var vodId = 0;

var topButtonPic = [["img/search01.png","img/search02.png"],["img/btn01_1.jpg","img/btn01_2.jpg"],["img/btn02_1.jpg","img/btn02_2.jpg"],["img/btn03_1.jpg","img/btn03_2.jpg"]];
var searchInputObj = null;

var curr_services = [];
var loopBigImgTimeout = -1;
var toDVBFlag = false;
var tipsShowFlag = false;
var reminderTimeout = -1;
E.currCustId = "";
E.currPasswd = -3;

//左边菜单数据
var menuData = [
    {name: "纪录", 		url: "ifeng_imgList.jsp?typeId=10000100000000090000000000105585&pageSize=20&menuPos=0"},
    {name: "资讯", 		url: "ifeng_list.jsp?typeId=10000100000000090000000000105586&pageSize=20&menuPos=1"},
    {name: "评论", 		url: "ifeng_list.jsp?typeId=10000100000000090000000000105587&pageSize=20&menuPos=2"},
    {name: "历史军事",  url: "ifeng_imgList.jsp?typeId=10000100000000090000000000105588&pageSize=20&menuPos=3"},
    {name: "社会访谈", 	url: "ifeng_list.jsp?typeId=10000100000000090000000000105590&pageSize=20&menuPos=4"},
    {name: "人文时尚",  url: "ifeng_imgList.jsp?typeId=10000100000000090000000000105589&pageSize=20&menuPos=5"},
	{name: "财经", 		url: "ifeng_list.jsp?typeId=10000100000000090000000000105591&pageSize=20&menuPos=6"}
];

var marqueeText = "“凤凰专区”强势上线，每月25元，为您带来最丰富的历史文化，最独特的新闻视角，最犀利的时事评论，最敏锐的新闻洞察。";

//test data
listData =[ {type:"资讯", name:"体验\"重庆最复杂立交\"教你走不怕\"找不"},
			{type:"评论", name:"重庆江北商圈路面塌陷 地面露20平米大洞"},
			{type:"财经", name:"外媒：中国股市巨震对实体经济冲击有限"}
			];
picData =[{name:"2号线历史",img:"img/tj_img01.jpg"},{name:"新线开通",img:"img/tj_img02.jpg"}];

var backUrl = "";

function eventHandler(eventObj, type) {
	iPanel.debug("index_ifeng eventObj.code="+eventObj.code+",,type="+type);
	if (type == 1 && key_flag == 2) {//点播播放，去进行节目授权
        return 0;
    } else if (type == 1 && key_flag == 1) {//有提示框弹出来
        return tipkeypress(eventObj);
    } else {
		switch(eventObj.code){
			case "KEY_UP": //up
				udMove(-1);			
				break;
			case "KEY_DOWN": //down
				udMove(1);	 	
				break;
			case "KEY_LEFT": //left
				lrMove(-1);
				break;
			case "KEY_RIGHT": //right
				lrMove(1);
				break;
			case "KEY_SELECT":
				if(tipsShowFlag){		
					hideReminder();
				}else{
					doSelect();
				}
				break;
			case "KEY_NUMERIC":
				doInput(eventObj.args.value);
				break;
			case "KEY_MENU":
				doMenu();
				break;
			case "KEY_BACK":
			
			    if(backUrl!=""){
					window.location.href = backUrl;
				}else{
					doBack();
				
				}
				break;
			case "DVB_EIT_REQUEST_DATA_FINISHED":	
				//showEvent();
				break;
			default:
				return 1;
				break;				
		}
	}
	return 0;
}		

function init(){
	//iPanel.enterMode("watchTV", 0x01);
	initDatas();
	initTopPic();
	initInputBox()
	initPicData();
	initList();
	initFocus();
	showMarquee();
	media.video.setPosition(365,110,370,290);
	DVB.playAV(4590000,1504);
	//EPG.startDate = 0;
	//requestEvent();
	queryUserInfo();
	//checkOrder();
	
	var url = window.location.href;
    var tmpRerturnUrl = getUrlParams("backURL",url);
	if(tmpRerturnUrl)backUrl = decodeURIComponent(tmpRerturnUrl);
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

//初始化数据
function initDatas() {
	picData = vodSmallImgArray.slice(0,2);
	listData = vodSmallImgArray.slice(2);
	posterData = vodImgArray;
	
	//初始化焦点
	focusArea = <%= focusArea%>;
	topButtonPos = <%= topButtonPos%>;
	columnPos = <%= columnPos%>;
	videoPos = <%= videoPos%>;
	picPos = <%= picPos%>;
	listFocusPos = <%= listFocusPos%>;
	loopBigImgPos = <%= loopBigImgPos%>;
}

function initFocus(){
	switch(focusArea){
		case 0:
			getTopFocus();
			break;
		case 1:
			getColumnFocus();
			break;
		case 2:
			getVideoFocus();
			break;
		case 3:
			getPicFocus();
			break;
		case 4:
			setListStyle(true);
			break;
		case 5:
			getPosterFocus();
			break;
		case 6:
			getFootFocus();
			break;
	}
}

function showEvent(){
	$("evntName0").innerText = getEvent(0);
	$("evntName1").innerText = getEvent(1);
}

function requestEvent(){
	curr_services[0] = getServiceByNum(178);
	curr_services[1] = getServiceByNum(177);
	EPG.requestPrograms(curr_services);
}
function getServiceByNum(__num){
	var currCha = user.channels.getChannelByNum(__num);
	return currCha.getService();
}

function getEvent(__num){
	var currEvent;
	var startPos = curr_services[__num].presentProgramPosition;
	iPanel.debug("getEvent startPos = " + startPos);
	if(startPos >= 0){
		var tempPrograms = curr_services[__num].programs;
		var tempLength = tempPrograms.length;
		for(var i = startPos, j = 0; i < tempLength; i++){
			if(tempPrograms[i].status>=0){
				currEvent = tempPrograms[i];
				break;
			}
		}
	}else{
		currEvent = curr_services[__num].programs[0];
	}
	if(typeof(currEvent)=="undefined") return "暂无节目信息";
	else return currEvent.name;
}


//初始化输入框
function initInputBox() {
    searchInputObj = new E.input_obj("search", "normal", $("search").innerText, window, 7, "img/focus.gif", "img/global_tm.gif", 20);
}

function initTopPic(){
	for(var i = 0; i < 4; i++){
		$("topBtn"+i).style.background = "url("+topButtonPic[i][0]+")";
	}
}

function initPicData(){
	$("pic0").src = picData[0].img;
	$("pic1").src = picData[1].img;
	$("posterId").src = posterData[0].img;
	loopBigImgTimeout = setTimeout("loopBigImg();",3000);
}

function loopBigImg(){
	$("countNum"+ loopBigImgPos).style.backgroundImage = "url(img/dot01.png)";
	loopBigImgPos = (loopBigImgPos+1)%3;
	$("countNum"+ loopBigImgPos).style.backgroundImage = "url(img/dot02.png)";
	$("posterId").src = posterData[loopBigImgPos].img;
	clearTimeout(loopBigImgTimeout);
	loopBigImgTimeout = setTimeout("loopBigImg();",3000);

}

function initList() {
    listBox = new E.showList(3, listData.length, listFocusPos, 0, window);
   	//listBox.listHigh = 45;
    //listBox.focusDiv = "listfocus";
    listBox.showType = 1;
    listBox.haveData = setList;
    listBox.notData = clearList;
    listBox.startShow();
}

//设置列表数据
function setList(list) {
	$("text" + list.idPos).innerText = listData[list.dataPos].type;
    $("name" + list.idPos).innerText = iPanel.misc.interceptString(listData[list.dataPos].name, 38);
}

//清除列表数据
function clearList(list) {
	$("text" + list.idPos).innerText = "";
    $("name" + list.idPos).innerText = "";
}

//设置列表样式
function setListStyle(flag) {
    var name = listData[listBox.position].name;
    var focusPos = listBox.focusPos;
    var tempName = iPanel.misc.interceptString(name, 38);
	$("name" + focusPos).style.backgroundColor = flag ? "#ffa000" : (focusPos==1)?"#edd5cf":"transparent";
	if (name != tempName && flag) {
		$("name" + focusPos).innerHTML = "<marquee style=\"width:460px;height:32px;\">" + name + "</marquee>";
	}else {
		$("name" + focusPos).innerText = tempName;
	}
}




//上下移动焦点  0右上导航区域 1左边栏目区域 2 中间视频图片区域   3 文字推荐焦点  4右下焦点
function udMove(__num) {
    switch (focusArea) {
		case 0:	//右上导航区域	
			if(__num > 0){
          		focusArea = 2;
				loseTopFocus();
				getVideoFocus();
			}
        	break;
		case 1: //左边栏目区域
			changeColumnUD(__num); 
            break;
        case 2:	//中间视频区域
			changeVideoUD(__num);
            break;
		case 3:	//中间视频区域
			changePicUD(__num);
            break;
		case 4://文字推荐焦点
			setListStyle(false);
            if(listBox.position == 0 && __num < 0){
                focusArea = 3;
				getPicFocus();
            }else if(listBox.position == listBox.dataSize - 1 && __num > 0){
               	focusArea = 6;
				getFootFocus();
            }else{
                listBox.changeList(__num);
                setListStyle(true);
            }
            break;
		case 5://右边海报
			changePosterUD(__num);
            break;
		case 6://右下焦点
			if(__num < 0){
				focusArea = 5;
				loseFootFocus();
				getPosterFocus();
			}
            break;
    }
}

//左右移动焦点
function lrMove(__num) {
	switch (focusArea) {
		case 0:	//右上导航区域
			changeTopFocus(__num);
			break;
		case 1:	//左边栏目区域
			changeColumnLR(__num);
			break;
		case 2:	//中间视频区域
			changeVideoLR(__num);
			break;
		case 3:	//中间图片区域
			changePicLR(__num);
			break;
		case 4:	//文字推荐焦点
			setListStyle(false);
			if(__num > 0){
				focusArea = 5;
				getPosterFocus();
			}else{
				focusArea = 1;
				getColumnFocus();
			}
			break;
		case 5:	//右边海报
			changePosterLR(__num);
			break;
		case 6:	//右下焦点
			if(__num < 0){
				focusArea = 4;
				loseFootFocus();
				setListStyle(true);
			}
			break;
	}
}


/*  左边栏目区域的焦点切换 start  */
function changeColumnUD(__num){
	loseColumnFocus();
	if(__num < 0 && columnPos == 0){  //上
		focusArea = 0;
		getTopFocus();
	}else if(__num > 0 && (columnPos == 5 || columnPos == 6)){   //下
		focusArea = 6;
		getFootFocus();
	}else{
		if(__num < 0 && (columnPos == 1 || columnPos == 2)){
			columnPos = 0;
		}else if(__num > 0 && columnPos == 0){
			columnPos += __num;	
		}else{
			columnPos += __num*2;
		}
		getColumnFocus();
	}	
}

//左右切换焦点
function changeColumnLR(__num){
	if(__num < 0 && (columnPos==0||columnPos==1||columnPos ==3||columnPos==5)){    //左    
		return;	
	}else{
		loseColumnFocus();
		if(__num > 0 && (columnPos==0||columnPos==2||columnPos==4)){  //右
			focusArea = 2;
			getVideoFocus();
		}else if(__num > 0 && columnPos == 6){
			focusArea = 4;
			setListStyle(true);
		}else{
			columnPos += __num;	
			getColumnFocus();	
		}
	}
}

function loseColumnFocus(){
	$("columnImg"+columnPos).style.backgroundColor = "transparent";	
} 

function getColumnFocus(){
	$("columnImg"+columnPos).style.backgroundColor = "#ffa000";	
}

/*----- 左边栏目区域的焦点切换 end  ----*/


/* ----- 上面导航栏目的相关操作  start -----*/
function changeTopFocus(__num){
	loseTopFocus();
	topButtonPos = (topButtonPos+ __num +4)%4;
	getTopFocus();	
}


function getTopFocus(){
	if(topButtonPos == 0) searchInputObj.show_cursor();
	$("topBtn"+topButtonPos).style.background = "url("+topButtonPic[topButtonPos][1]+")";
}

function loseTopFocus(){
	if(topButtonPos == 0) {
		searchInputObj.input_str = "";
		searchInputObj.lose_focus();
	}
	$("topBtn"+topButtonPos).style.background = "url("+topButtonPic[topButtonPos][0]+")";	
}
/* ----- 上面导航栏目的相关操作  end -----*/


/* ----- 中间视频块的区域操作 start  -----*/
//上下切换焦点
function changeVideoUD(__num){
	loseVideoFocus();
	if(__num < 0 && (videoPos == 0 || videoPos == 1)){		//上
		focusArea = 0;
		getTopFocus();
	}else if(__num > 0 &&(videoPos == 0 || videoPos == 2)){		//下
		focusArea = 3;
		getPicFocus();
	}else{
		videoPos += __num;
		getVideoFocus();
	}
}

//左右切换焦点
function changeVideoLR(__num){
	loseVideoFocus();
	if(__num < 0 && videoPos == 0){		//左
		focusArea = 1;
		getColumnFocus();
	}else if(__num > 0 && (videoPos == 1 || videoPos == 2)){
		focusArea = 5;
		getPosterFocus();
	}else{		//右
		if(videoPos == 2){
			videoPos += __num*2;
		}else{
			videoPos += __num;
		}
		getVideoFocus();
	}
}

function getVideoFocus(){
	if(videoPos == 0){
		$("middleImg" + videoPos).style.visibility ="visible";
	}else{
		$("middleImg" + videoPos).style.backgroundColor = "#ffa000";	
	}	
}

function loseVideoFocus(){
	if(videoPos == 0){
		$("middleImg" + videoPos).style.visibility ="hidden";
	}else{
		$("middleImg" + videoPos).style.backgroundColor = "transparent";	
	}	
}

//中间小图片焦点

function changePicUD(_num){
	losePicFocus();
	if(_num < 0){		//上
		focusArea = 2;
		getVideoFocus();
	}else if(_num > 0){		//下
		focusArea = 4;
		setListStyle(true);
	}
}

//左右切换焦点
function changePicLR(_num){
	losePicFocus();
	if(_num < 0 && picPos == 0){		//左
		focusArea = 1;
		getColumnFocus();
	}else if(_num>0 && picPos == 1){		//右
		focusArea = 5;
		getPosterFocus();
	}else{
		picPos = (picPos+_num+2)%2;
		getPicFocus();
	}
}

function getPicFocus(){
	$("picFocusImg" + picPos).style.backgroundColor = "#ffa000";	
}

function losePicFocus(){
	$("picFocusImg" + picPos).style.backgroundColor = "transparent";	
}

//右边海报
function changePosterUD(__num){
	losePosterFocus();
	if(__num < 0){		//上
		focusArea = 0;
		getTopFocus();
	}else if(__num > 0){		//下
		focusArea = 6;
		getFootFocus();
	}
}

//左右切换焦点
function changePosterLR(__num){
	if(__num < 0){		//左
		losePosterFocus();
		focusArea = 2;
		getVideoFocus();
	}
}

function getPosterFocus(){
	$("posterFocus").style.backgroundColor = "#ffa000";	
}

function losePosterFocus(){
	$("posterFocus").style.backgroundColor = "transparent";	
}
/* ----- 中间图片块的区域操作 end  -----*/


/* -----文字推荐区域块的操作 start  -----*/


/*function changeTxtFocus(_num){
	if(txtPos ==0 &&_num<0){
		focusArea = 2;
		loseTxtFocus();
		getVideoFocus();
		return;	
	}
	if(txtPos ==2 &&_num >0){
		focusArea = 4;
		loseTxtFocus();
		getFootFocus();
		return;	
	}
	loseTxtFocus();
	txtPos = (txtPos + _num +3)%3;
	getTxtFocus();	
}*/


/*function getTxtFocus(){	
	$("name"+listBox.focusPos).style.backgroundColor = "#ffa000";	
}

function loseTxtFocus(){	
	if(listBox.focusPos ==1){
		$("name"+listBox.focusPos).style.backgroundColor = "#edd5cf";
	}else{
		$("name"+listBox.focusPos).style.backgroundColor = "transparent";	
	}
}
*/
function loseFootFocus(){
	$("footBtn").style.backgroundColor = "#945c4f";
	$("footBtn").style.color = "#ffffff";		
}

function getFootFocus(){
	$("footBtn").style.backgroundColor = "#ffa000";	
	$("footBtn").style.color = "#000000";		
}


function doSelect(){
	//alert("focusArea=="+focusArea);
	iPanel.debug("index_ifeng focusArea=="+focusArea);
	switch (focusArea) {
		case 0:	//右上导航区域
			var baseurl = focusURL();
			switch(topButtonPos){
				case 0:
					window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp?keyword="
						+searchInputObj.input_str+"&epgBackurl=" + E.pre_epg_url + "/defaultHD/en/ifeng/ifeng_index.jsp";
					break;
				case 1:
					showReminder("该功能建设中");
					//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/recordList.jsp";
					break;
				case 2:
					showReminder("该功能建设中");
					//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/favoriteList.jsp";
					break;
				case 3:
					showTipWindow(0,1);
					break;
			}
			break;
		case 1:	//左边栏目区域
			var url = menuData[columnPos].url;
            var baseurl = focusURL();
			iPanel.debug("index_ifeng baseurl=="+baseurl);
            //window.location.href = baseurl + "/EPG/jsp/defaultHD/en/ifeng/"+url;
			window.location.href = baseurl + url;
			break;
		case 2:	//中间视频区域
			if(videoPos == 1){
				var currCha = user.channels.getChannelByNum(177);
			}else{
				var currCha = user.channels.getChannelByNum(178);
			}
			toDVBFlag = true;
			currCha.open();
			break;
		case 3:	//中间图片区域
			if (picData.length > 0) {
				typeId = picData[picPos].typeId;
				vodId = picData[picPos].vodId;
				var playType = picData[picPos].playType;
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
			}
			break;
		case 4:	//文字推荐焦点
			if (listBox.dataSize > 0) {
				//为影片
				typeId = listData[listBox.position].typeId;
				vodId = listData[listBox.position].vodId;
				var playType = listData[listBox.position].playType;
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
			}
			break;
		case 5:	//右边海报 //为影片
			if (posterData.length > 0) {
				if(loopBigImgPos == 0){
					var baseurl = focusURL();
					window.location.href = focusURL()+"ifeng_topicList.jsp?typeId=10000100000000090000000000105924";
				}else{
					typeId = posterData[loopBigImgPos].typeId;
					vodId = posterData[loopBigImgPos].vodId;
					var playType = posterData[loopBigImgPos].playType;
					if (typeId != '' && vodId != 0) {
						play_movie(playType);
					}
				}
			}
			break;
		case 6:	//右下焦点
			doMenu();
			break;
	}
}

function showReminder(__text){
	clearTimeout(reminderTimeout);
	tipsShowFlag = true;
	$("resultReminderText0").innerText = __text;
	$("resultReminderTips").style.visibility = "visible";
	reminderTimeout = setTimeout(hideReminder,2000);
}		

function hideReminder(){
	clearTimeout(reminderTimeout);
	tipsShowFlag = false;
	$("resultReminderTips").style.visibility = "hidden";
	$("resultReminderText0").innerText = "";	
	$("resultReminderText1").innerText = "";
}

//打开菜单
function doMenu() {
    E.marqueeText = null;
    iPanel.mainFrame.location.href = E.portal_url;
}

//输入
function doInput(__num) {
    if (focusArea == 0 && topButtonPos == 0) {
        searchInputObj.get_input(__num);
    }
}

//删除
function doBack() {
    if (focusArea == 0 && topButtonPos == 0) {
        searchInputObj.del_input();
    } else {
        doMenu();
		//iPanel.mainFrame.history.back();
    }
}

//显示跑马灯
function showMarquee() {
    $("marquee").innerText = marqueeText;
}

function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs="+focusArea+","+topButtonPos+","+columnPos+","+videoPos+","+picPos+","+listBox.position+","+loopBigImgPos+"&url=";
    return baseurl;
}

/**节目播放，跳到授权页面  */
function play_movie(playType) {
    if (playType == 1) {
        //如果是电视剧
        window.location.href = focusURL() + "ifeng_tvDetail.jsp?vodId=" + vodId + "&typeId=" + typeId;
    } else {
        //电影直接播放
        getAuthUrl(vodId);
    }
}

/**从书签处播放 */
function tip_fromBookmarkPlay() {
    var tempTime = domark(vodId);
    var baseurl = focusURL();
	iPanel.debug("index_ifeng baseurl=="+baseurl);
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&baseFlag=0&contentType=0&startTime=" + tempTime + "&business=1";
}

/* tipsWindow.jsp中getAuthUrl()方法调用，从开始处播放 */
function tip_fromBeginPlay() {
    var baseurl = focusURL();
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&baseFlag=0&contentType=0&business=1";
}


function exit_page(){
	//iPanel.exitMode();
	//if(enter_type != "channel"){
	if(!toDVBFlag) DVB.stopAV(0);
	//}
}

</script>
</head>

<body background="img/index_bg01.png" leftmargin="0" topmargin="0" onLoad="init();" onUnload="exit_page();">
<!--焦点色：#ffa000；常态色：#945c4f；-->
<!--logo-->
<img src="img/logo.png" width="166" height="43" style=" position:absolute; left:65px;  top:39px;" />

<!--按钮-->
<div  style="position:absolute; left:672px; top:44px; width:545px; height:36px; ">
	<!--搜索-->
	<div id="topBtn0" style="position:absolute; left:97px; top:0px; width:230px; height:36px;">		
		<div id="search" style="position:absolute; left:10px; top:7px; width:140px; height:22px; font-size:22px; "></div>
	</div>
	<!--历史-->
	<div id="topBtn1" style="position:absolute; left:329px; top:0px; width:70px; height:36px;"></div>
	<!--收藏-->
	<div id="topBtn2" style="position:absolute; left:401px; top:0px; width:70px; height:36px;"></div>
	<!--订购-->
	<div id="topBtn3" style="position:absolute; left:473px; top:0px; width:70px; height:36px;"></div>
</div>

<!--中间内容-->
<div style="position:absolute; left:0px; top:105px; width:1280px; height:515px; ">
	<!--入口-->
	<div id="columnImg0" style="position:absolute; left:60px; top:0px; width:290px; height:130px;">
		<img  src="img/enter_record.jpg" width="280" height="120" style=" position:absolute; left:5px; top:5px; " />
	</div>
	<div id="columnImg1" style="position:absolute; left:60px; top:130px; width:145px; height:130px;">
		<img  src="img/enter_news.jpg" width="135" height="120" style=" position:absolute; left:5px; top:5px;" />
	</div>
	<div id="columnImg2" style="position:absolute; left:205px; top:130px; width:145px; height:130px;">
		<img src="img/enter_comment.jpg" width="135" height="120" style=" position:absolute; left:5px; top:5px;" />	
	</div>	
	<div id="columnImg3" style="position:absolute; left:60px; top:260px; width:145px; height:130px;">
		<img src="img/enter_history.jpg" width="135" height="120" style=" position:absolute; left:5px; top:5px;" />	
	</div>
	<div id="columnImg4" style="position:absolute; left:205px; top:260px; width:145px; height:130px;">
		<img id="columnImg4" src="img/enter_interview.jpg" width="135" height="120" style=" position:absolute; left:5px; top:5px;" />	
	</div>
	<div id="columnImg5" style="position:absolute; left:60px; top:390px; width:145px; height:130px;">
		<img id="columnImg5" src="img/enter_social.jpg" width="135" height="120" style=" position:absolute; left:5px; top:5px;" />	
	</div>
	<div id="columnImg6" style="position:absolute; left:205px; top:390px; width:145px; height:130px;">
		<img src="img/enter_finance.jpg" width="135" height="120" style=" position:absolute; left:5px; top:5px;" />	
	</div>
	
	<!--视频窗口-->
	<div id="middleImg0" style="position:absolute; left:365px; top:5px; width:370px; height:290px; background:url(img/video_focus.png) no-repeat; visibility:hidden;"></div>	
	<div id="middleImg1" style="position:absolute; left:740px; top:0px; width:160px; height:150px;">
		<div style="position:absolute; left:5px; top:5px; width:150px; height:140px; background-color:#ffbb77;"></div>
		<!--<img src="img/enter_chanel_ch.jpg" width="150" height="140" style=" position:absolute; left:5px; top:5px;" />-->
		<div id="evntName0" style="position:absolute; left:10px; top:62px; width:140px; height:22px; text-align:left; font-size:22px; line-height:22px; color:#ffffff;">测试频道一</div>
	</div>
	<div id="middleImg2" style="position:absolute; left:740px; top:150px; width:160px; height:150px;">
		<div style="position:absolute; left:5px; top:5px; width:150px; height:140px; background-color:#ffbb77;"></div>
		<!--<img src="img/enter_chanel_news.jpg" width="150" height="140" style=" position:absolute; left:5px; top:5px;" />	-->
		<div id="evntName1" style="position:absolute; left:10px; top:64px; width:140px; height:22px; text-align:left; font-size:22px; line-height:22px; color:#ffffff;">测试频道二</div>
	</div>	
	
	<!--推荐-->
	<div id="picFocusImg0" style="position:absolute; left:360px; top:300px; width:270px; height:90px; ">
		<img id="pic0" src="" width="260" height="80" style=" position:absolute; left:5px; top:5px;" />	
	</div>
	<div id="picFocusImg1" style="position:absolute; left:630px; top:300px; width:270px; height:90px; ">
		<img id="pic1" src="" width="260" height="80" style=" position:absolute; left:5px; top:5px;" />	
	</div>
	<div id="posterFocus" style="position:absolute; left:910px; top:0px; width:310px; height:520px; ">
		<img id="posterId" src="img/tj_img03.jpg" width="300" height="510" style="position:absolute; left:5px; top:5px;" />	
        <div style="position:absolute; left:124px; top:490px; color:#fff; font-size:14px;">	
			<table width="75" height="16" border="0" cellspacing="0" cellpadding="0" style="color:#fff; font-size:14px;">
			  <tr>
				<td id="countNum0" width="25" align="center" style="background:url(img/dot02.png) center center no-repeat;">1</td>
				<td id="countNum1" width="25" align="center" style="background:url(img/dot01.png) center center no-repeat;">2</td>
				<td id="countNum2" width="25" align="center" style="background:url(img/dot01.png) center center no-repeat;">3</td>
			  </tr>
			</table>
	  </div>
  </div>
	
	<!--文字推荐-->
	<div style="position:absolute; left:365px; top:395px; width:530px; height:120px; background:#e4c2b9; z-index:10 ">
		<table width="530" border="0" cellspacing="0" cellpadding="0" style="font-size:22px; z-index:5;">
			  <tr>
				<td id="text0" width="58" height="40" align="center" style="background:#ab41bf; color:#fff;">资讯</td>
				<td id="name0" style="padding-left:10px;"></td>
			  </tr>
			  <tr>
				<td id="text1" height="40" align="center" style="background:#54a28a; color:#fff;">评论</td>
				<td id="name1" style="padding-left:10px; background:#edd5cf;"></td>
			  </tr>
			  <tr>
				<td id="text2" height="40" align="center" style="background:#6690e6; color:#fff;">财经</td>
				<td id="name2" style="padding-left:10px;"></td>
			  </tr>
		</table>
	</div>
</div>

<!--news-->
<!--<div style="position:absolute; left:124px; top:651px; width:910px; height:24px; color:#f0f0f0; font-size:24px; overflow:hidden; ">沪指涨幅缩至6%，超1200股涨停，中石油、中国银行等个别超级权重股尾市场小幅拖累指数。</div>-->
<div style="position:absolute; left:124px; top:651px; width:910px; height:24px; color:#f0f0f0; font-size:24px;">
	<marquee id="marquee"></marquee>
</div>	

<!--首页-->
<div id="footBtn" style="position:absolute; left:1045px; top:640px; width:170px; height:50px; background:#945c4f; text-align:center; font-size:28px; line-height:50px; color:#fff; ">首页</div>

<!--  按钮操作的弹出提示框  -->
<div id="resultReminderTips" style="position:absolute; left:441px; top:200px; width:396px; height:156px; background:url(img/notice01.png) no-repeat; visibility:hidden; ">
    <div id="resultReminderText0" style="position:absolute; left:32px; top:40px; width:320px; height:30px; font-size:30px; color:#af2837; text-align:center; ">该功能建设中</div>
    <div id="resultReminderText1" style="position:absolute; left:32px; top:76px; width:320px; height:22px; font-size:22px; color:#333333; text-align:center; "></div>
</div>
	
<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="showtip.jsp"></jsp:include>
</body>
</html>
