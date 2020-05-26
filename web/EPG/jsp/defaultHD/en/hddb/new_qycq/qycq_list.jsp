<%@ page contentType="text/html; charset=GBK" language="java" pageEncoding="GBK" %>
<%@ include file="qycq_list_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title>qycqlist</title>
<script type="application/javascript" src="js/showList.js"></script>
<script type="application/javascript" src="js/tool.js"></script>
<script type="application/javascript" src="js/ajax2.js"></script>
<script type="text/javascript" src="js/global.js"></script>
<script>
iPanel.eventFrame.initPage(window);
E.is_HD_vod = true;

var focusArea = 0; // 0左边栏目 1中间列表  2顶部
var topButtonPos = 0;   //右上角导航栏目的焦点
var columnPos = 0;   //左边栏目焦点
var subMenuPos = 0;   //中间列表焦点


var columnData = [];
var columnBox = null;
var subMenuData = [];
var subMenuBox = null;

var typeId = "";
var vodId = 0;

var toDVBFlag = false;

var menuData = [
		{name:"全域重庆｜文化",typeId:""},
		{name:"全域重庆｜旅游",typeId:""},
		{name:"全域重庆｜便民",typeId:""}
	];

var topButtonPic = [["img/search01.png","img/search02.png"],["img/btn01_1.jpg","img/btn01_2.jpg"],["img/btn02_1.jpg","img/btn02_2.jpg"]];

var searchInputObj = null;

var rtsp = "";
var vodTimeout = -1;

var tipsShowFlag = false;
var reminderTimeout = -1;
//左边列表数据
/*columnData = [
    {name: "推荐", url: "txtList.htm"},
    {name: "人文故事", url: "txtList.htm"},
    {name: "文化活动", url: "txtList.htm"},
];*/


//test data
/*subMenuData = [
	{vodID:1,name:"1100余解放军战士埋骨越南",img:""},
	{vodID:1,name:"1300余解放军战士埋骨越南",img:""},
	{vodID:1,name:"1400余解放军战士埋骨越南",img:""},
	{vodID:1,name:"1100余解放军战士埋骨越南",img:""},
	{vodID:1,name:"1500余解放军战士埋骨越南",img:""},
	{vodID:1,name:"1100余解放军战士埋骨越南",img:""},
	{vodID:1,name:"1600余解放军战士埋骨越南",img:""},
	{vodID:1,name:"1100余解放军战士埋骨越南",img:""},
	{vodID:1,name:"1700余解放军战士埋骨越南",img:""},
	{vodID:1,name:"1100",img:""},
	{vodID:1,name:"1800",img:""},
	{vodID:1,name:"1100",img:""},
	{vodID:1,name:"1900",img:""},
	{vodID:1,name:"1100",img:""},
	{vodID:1,name:"1000",img:""},
	{vodID:1,name:"1100",img:""},
	{vodID:1,name:"1101",img:""},
	{vodID:1,name:"1100",img:""},
	{vodID:1,name:"1102",img:""}
];*/


function eventHandler(eventObj, type) {
	if (type == 1 && key_flag == 2) {//点播播放，去进行节目授权
        return 0;
    } else if (type == 1 && key_flag == 1) {//有提示框弹出来
        return tipkeypress(eventObj.code);
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
				doSelect();
				break;
			case "KEY_NUMERIC":
				doInput(eventObj.args.value);
				break;
			case "KEY_MENU":
				doMenu();
				break;
			case "KEY_BACK":
				doBack();
				break;
			case "VOD_PREPAREPLAY_SUCCESS"://开始播放
				media.AV.play();
				break;
			case "EIS_VOD_PROGRAM_END"://重新播放
				playVOD();
				break;
			default:
				return 1;
				break;				
		}
	}
	return 0;
}		

function init(){
	media.video.setPosition(652,165,569,373);
	initDatas();
	initTopPic();
	initInputBox();  //搜索框
	initMenuText();
	initColumnData();
	initSubData();
	initFocus();
	playVOD();
}

function playVOD(){
	clearTimeout(vodTimeout);
	vodTimeout = setTimeout(function(){getPlayURL(subMenuData[subMenuBox.position].typeId,subMenuData[subMenuBox.position].vodId)},1000);
}

function getPlayURL(__typeId,__vodId){
	var url = E.pre_epg_url+"/defaultHD/en/go_authorization.jsp?typeId=" + __typeId + "&playType=1"
            + "&progId=" + __vodId + "&contentType=0&business=1";
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		iPanel.debug("getPlayURL requestStr="+requestStr);
		var json = eval("(" + requestStr + ")");
		rtsp =json.playUrl.split("^")[4];
		play();
			
	},
	function(__errorCode){
		iPanel.debug("checkIfOrdered __errorCode="+__errorCode);
	},
	20000);	
	requestAjaxObj.requestData("post");
}

function play(){
	exit_page();
	var name = subMenuData[subMenuBox.position].name;
	var tempName = iPanel.misc.interceptString(name,22);
	if (name != tempName) {
		$("playName").innerHTML = "<marquee style=\"width:560px;height:69px; line-height:69px;\">" + name + "</marquee>";
	}
	else {
		$("playName").innerText = tempName;
	}
	media.AV.open(rtsp,"VOD");
}

//初始化数据
function initDatas() {
	columnData = typeListArray;
	subMenuData = vodImgArray;
	menuPos = <%= menuPos%>;
	//初始化焦点
	focusArea = <%= focusArea%>;
	columnPos = <%= leftFocus%>;
	subMenuPos = <%= subMenuPos%>;
}

function initFocus(){
	switch(focusArea){
		case 0:
			getColumnFocus();
			break;
		case 1:
			getColumnFocus();
			getSubFocus();
			break;
		case 2:
			getTopFocus();
			break;
	}
}

//初始化输入框
function initInputBox() {
    searchInputObj = new E.input_obj("search", "normal", $("search").innerText, window, 7, "img/focus.gif", "img/global_tm.gif", 20);
}

function initTopPic(){
	for(var i = 0; i < 3; i++){
		$("topBtn"+i).style.background = "url("+topButtonPic[i][0]+")";
	}
}

function initMenuText(){
	$("menuText").innerText = menuData[menuPos].name;
}



//左边栏目显示
function initColumnData(){
	columnBox = new showList(10, columnData.length, columnPos,126, window);
	columnBox.focusDiv = "columnFocus";
	columnBox.listHigh = 52;
    columnBox.showType = 1;
    columnBox.haveData = function(list) {
  		$("columnName" + list.idPos).innerText = columnData[list.dataPos].name;
	}
    columnBox.notData = function(list){
		$("columnName" + list.idPos).innerText = "";
	}
    columnBox.startShow();
}


//清除列表数据


//中间文字列表显示
function initSubData() {
    subMenuBox = new showList(10, subMenuData.length, subMenuPos,126, window);
	subMenuBox.focusDiv = "subMenuFocus";
	subMenuBox.listHigh = 52;
	subMenuBox.showType = 1;
    subMenuBox.haveData = function(list){
		$("subMenuName"+list.idPos).innerText = iPanel.misc.interceptString(subMenuData[list.dataPos].name,22);
		$("subMenuImg"+list.idPos).src = "img/bar_02.png";
	};
	subMenuBox.notData = function(list){
		$("subMenuName"+list.idPos).innerText = "";
		$("subMenuImg"+list.idPos).src = "";
	};
	subMenuBox.startShow();	
	initScroll();
}

//设置列表样式
function setListStyle(flag) {
	var tempVod = subMenuData[subMenuBox.position];
	var name = tempVod.name;
	var tempName = iPanel.misc.interceptString(name,22);
	if (name != tempName && flag) {
		$("subMenuName"+subMenuBox.focusPos).innerHTML = "<marquee style=\"width:304px;height:40px; line-height:40px;\">" + name + "</marquee>";
	}
	else {
		$("subMenuName"+subMenuBox.focusPos).innerText = tempName;
	}
}

//上下移动焦点   // 0右上导航 1左边栏目 2中间列表 3回首页 4右下焦点
function udMove(__num) {
    switch (focusArea) {
		case 0: //左边栏目列表
			changeColumnUD(__num); 
            break;
        case 1:	//中间文字列表
			changeSubDataUD(__num);
            break;
		case 2:
			if(__num > 0){
				focusArea = 1;
				loseTopFocus();
				getColumnFocus();
				getSubFocus();	
			}
			break;	
	}
}

//左右移动焦点   // 0右导航 1中间列表 2右顶部
function lrMove(__num){
	switch (focusArea){
		case 0: //左边栏目列表
			if(__num>0){   //右移
				focusArea = 1;
				//loseColumnFocus();	
				getSubFocus();
			} 
            break;
        case 1:	//中间列表
			if(__num < 0){   //左移
				focusArea = 0;
				loseSubFocus();
				getColumnFocus();	
			}else{
				focusArea = 3;
				loseSubFocus();
				getGoTopFocus();
			}
            break;
		case 2:	//顶部
			changeTopFocus(__num);//			
            break;
		case 3:
			if(__num < 0){   //左移
				focusArea = 1;
				loseGoTopFocus();
				getSubFocus();	
			}
			break;
	}
}


//左边导航栏操作
function changeColumnUD(__num){
	if(__num < 0 && columnBox.position == 0){
		loseColumnFocus();
		focusArea = 2;
		getTopFocus();	
		return;
	}
	loseColumnFocus();
	columnBox.changeList(__num);
	getColumnFocus();
	window.location.href = "qycq_list.jsp?typeId="+leftTypeId+"&leftFocus="+columnBox.position+"&menuPos="+menuPos+"&ifcor=1";
}


function getColumnFocus(){
	$("columnFocus").style.visibility = "visible";
	$("columnName"+columnBox.focusPos).style.color = "#000000";
	$("columnImg"+columnBox.focusPos).src = "img/icon_play.png";
}


function loseColumnFocus(){
	$("columnFocus").style.visibility = "hidden";
	$("columnName"+columnBox.focusPos).style.color = "#ffffff";
	$("columnImg"+columnBox.focusPos).src = "img/blank_tm.gif";
}




//中间文字列表区域
function changeSubDataUD(__num){
	if(__num < 0 && subMenuBox.position == 0){
		loseSubFocus();
		focusArea = 2;
		$("subMenuFocus").style.visibility = "hidden";
		getTopFocus();	
		return;
	}
	loseSubFocus();
	subMenuBox.changeList(__num);	
	getSubFocus();
	scrollChange();
}

function changeSubMenuLR(__num){
	var subMenuSize = subMenuData.length;
	if(__num>0){
		if(parseInt((subMenuBox.position + __num)%5,10) == 0||(subMenuBox.position ==(subMenuSize-1))){//在最右边的位置, 右键 翻页
			focusArea = 2;
			loseSubFocus();
			getGoTopFocus();
			return;	
		}
		subMenuBox.changeList(1);	
		getSubFocus();
		scrollChange();	
	}else if(__num == -1){
		if(subMenuBox.focusPos==0||subMenuBox.focusPos==5){//在坐左边的位置, 左键 翻页
			focusArea = 0;
			loseSubFocus();
			getColumnFocus();
		}else{			
			subMenuBox.changeList(-1);
			getSubFocus();
			scrollChange();
		}		
	}
}


function changeSubDataPage(__num){
	subMenuBox.changePage(__num);
	scrollChange();	
}

function getSubFocus(){
	setListStyle(true);
	$("subMenuName"+subMenuBox.focusPos).style.color = "#000000";
	$("subMenuFocus").style.visibility = "visible";
	$("subMenuImg"+subMenuBox.focusPos).src = "img/bar_01.png";
	//$("playName").innerText = iPanel.misc.interceptString(subMenuData[subMenuBox.position].name,22);
	playVOD();
}

function loseSubFocus(){
	setListStyle(false);
	$("subMenuName"+subMenuBox.focusPos).style.color = "#ffffff";
	$("subMenuFocus").style.visibility = "hidden";
	$("subMenuImg"+subMenuBox.focusPos).src = "img/bar_02.png";
}

/*----  滚动条以及回顶部的 操作 start  ----*/

//滚动条
function initScroll(){
	scrollBar = new ScrollBar("scrollBar");
	scrollBar.init(Math.ceil(subMenuBox.dataSize/subMenuBox.listSize),1, 365, 0);
	if(subMenuBox.dataSize == 0){
		$("scrollBar").innerHTML = '0<br />/<br />0';	
	}else{
		scrollChange();
	}
}

function scrollChange(){	//显示当前页码数和总共页码数
	scrollBar.scroll(subMenuBox.currPage-1);
	$("scrollBar").innerHTML = subMenuBox.currPage+'<br />/<br />'+subMenuBox.listPage;	
}

function changeTopFocus(__num){
	loseTopFocus();
	topButtonPos = (topButtonPos+ __num +3)%3;
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

function getGoTopFocus(){
	$("goTopBtn").src = "img/btn_top02.jpg";
}

function loseGoTopFocus(){
	$("goTopBtn").src = "img/btn_top01.jpg";
}
/*----   滚动条以及回顶部的 操作 end  ----*/


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
function doMenu(){
	exit_page();
    E.marqueeText = null;
    iPanel.mainFrame.location.href = E.portal_url;
}

//输入
function doInput(__num){
    if(focusArea == 2 && topButtonPos == 0){
        searchInputObj.get_input(__num);
    }
}

//删除
function doBack(){
	if (focusArea == 2 && topButtonPos == 0) {
        searchInputObj.del_input();
    } else {
		exit_page();
		window.location.href = "<%=turnPage.go(-1)%>";
	}
}


function doSelect(){
	switch(focusArea){		
		case 0:   //左边导航栏目
			return;
			break;
		case 1:  //中间列表区域
			exit_page();
			var baseurl = focusURL();
			pos = subMenuBox.position;
			typeId = subMenuData[pos].typeId;
			vodId = subMenuData[pos].vodId;
			var playType = subMenuData[pos].playType;
			if (typeId != '' && vodId != 0) {
				play_movie(playType);
			}
			break;
		case 2:  //顶部
			var baseurl = focusURL();
			switch(topButtonPos){
				case 0:
					exit_page();
					window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp?keyword="
					+searchInputObj.input_str+"&epgBackurl="+E.pre_epg_url+"/defaultHD/en/hddb/qycq/qycq_index.jsp";
					break;
				case 1:
					showReminder("该功能建设中");
					//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/recordList.jsp";
					break;
				case 2:
					showReminder("该功能建设中");
					//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/favoriteList.jsp";
					break;
				/*case 3:
					window.location.href = baseurl + "http://192.168.9.120/chongqing_TV/index.htm";
					break;*/
			}
			
			//initSubData();
			//subMenuPos = 0;
			break;
		case 3:
			subMenuPos = 0;
			initSubData();
			break;		
	}
}


function focusURL(){
    var baseurl = "SaveCurrFocus.jsp?currFoucs="+focusArea+","+columnBox.position+","+subMenuBox.position+"&url=";
    return baseurl;
}

/**节目播放，跳到授权页面  */
function play_movie(playType){
    if(playType == 1){
        //如果是电视剧
        //window.location.href = focusURL() + "../iCatch_TV_detail.jsp?vodId=" + vodId + "&typeId=" + typeId;
    }else{
        //电影直接播放
        getAuthUrl(vodId);
    }
}

/**从书签处播放 */
function tip_fromBookmarkPlay(){
    var tempTime = domark(vodId);
    var baseurl = focusURL();
	iPanel.debug("index_ifeng baseurl=="+baseurl);
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&contentType=0&startTime=" + tempTime + "&business=1";
}

/* tipsWindow.jsp中getAuthUrl()方法调用，从开始处播放 */
function tip_fromBeginPlay(){
    var baseurl = focusURL();
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&contentType=0&business=1";
}

function exit_page(){
	DVB.stopAV(0);
	media.AV.close();
}


</script>
</head>

<body leftmargin="0" topmargin="0" background="img/bg_03.png" onLoad="init();">
<!--位置-->
<div id="menuText" style="position:absolute; left:46px; top:53px; width:400px; height:35px; line-height:35px; color:#fff; font-size:29px;">全域重庆｜文化</div>

<!--顶部按钮-->
<div  style="position:absolute; left:746px; top:44px; width:475px; height:36px; ">
	<!--搜索-->
	<div id="topBtn0" style="position:absolute; left:97px; top:0px; width:230px; height:36px;">		
		<div id="search" style="position:absolute; left:10px; top:7px; width:140px; height:22px; font-size:22px; "></div>
	</div>
	<!--历史-->
	<div id="topBtn1" style="position:absolute; left:329px; top:0px; width:70px; height:36px;"></div>
	<!--收藏-->
	<div id="topBtn2" style="position:absolute; left:401px; top:0px; width:70px; height:36px;"></div>
	<!--订购-->
	<!--<div id="topBtn3" style="position:absolute; left:473px; top:0px; width:70px; height:36px;"></div>-->
</div>
<!--右上按钮-->
<!--<div style="position:absolute; left:1002px; top:38px; width:219px; height:36px;">
	<div style="position: absolute; left: -163px; top: 0px; width: 234px; height: 36px; background: url(btn_search01.png) no-repeat;"></div>
  <img src="img/btn_history01.png" width="71" height="36" style="position:absolute; left:74px; top:0px;" />
  <img src="img/btn_fav01.png" width="71" height="36" style="position:absolute; left:148px; top:0px;" />
</div>-->
<!--左侧-->
<div id="columnFocus" style="position:absolute; left:52px; top:126px; width:195px; height:52px; background:#feef34; visibility:visible;"></div>
<div style="position:absolute; left:52px; top:126px; width:195px; height:520px;">
	<table width="195" border="0" cellspacing="0" cellpadding="0" style="font-size:26px; color:#fff;">
        <tr id="column0">
          <td height="52" width="20"></td>
          <td id="columnName0" width="195"></td>
          <td><img id="columnImg0" width="12" height="15" /></td>
        </tr>
        <tr id="column1">
          <td height="52"></td>
          <td id="columnName1">人文故事</td>
          <td><img id="columnImg1" /></td>
        </tr>
        <tr id="column2">
          <td height="52"></td>
          <td id="columnName2">文化活动</td>
          <td><img id="columnImg2" /></td>
        </tr>
        <tr id="column3">
          <td height="52"></td>
          <td id="columnName3"></td>
          <td><img id="columnImg3" /></td>
        </tr>
        <tr id="column4">
          <td height="52"></td>
          <td id="columnName4"></td>
          <td><img id="columnImg4" /></td>
        </tr>
        <tr id="column5">
          <td height="52"></td>
          <td id="columnName5"></td>
          <td><img id="columnImg5" /></td>
        </tr>
        <tr id="column6">
          <td height="52"></td>
          <td id="columnName6"></td>
          <td><img id="columnImg6" /></td>
        </tr>
        <tr id="column7">
          <td height="52"></td>
          <td id="columnName7"></td>
          <td><img id="columnImg7" /></td>
        </tr>
        <tr id="column8">
          <td height="52"></td>
          <td id="columnName8"></td>
          <td><img id="columnImg8" /></td>
        </tr>
        <tr id="column9">
          <td height="52"></td>
          <td id="columnName9"></td>
          <td><img id="columnImg9" /></td>
        </tr>
  </table>
</div>

<!--列表-->
<div id="subMenuFocus" style="position:absolute; left:247px; top:126px; width:354px; height:52px; background:#feef34; visibility:hidden;"></div>
<div style="position: absolute; left: 247px; top: 101px; width: 354px; height: 570px;">
	<table width="354" border="0" cellspacing="0" cellpadding="0" style="font-size:22px; color:#fff;">
      <tr>
          <td colspan="3" height="25" align="center"><img src="img/att_top.png" width="22" height="13" /></td>
      </tr>
      <tr>
          <td width="10" height="52"></td>
          <td width="35"><img id="subMenuImg0" src="img/bar_02.png" width="26" height="27" /></td>
          <td id="subMenuName0"></td>
      </tr>
      <tr>
          <td height="52"></td>
          <td><img id="subMenuImg1" src="" width="26" height="27" /></td>
          <td id="subMenuName1"></td>
      </tr>
      <tr>
          <td height="52"></td>
          <td><img id="subMenuImg2" src="" width="26" height="27" /></td>
          <td id="subMenuName2"></td>
      </tr>
      <tr>
          <td height="52"></td>
          <td><img id="subMenuImg3" src="" width="26" height="27" /></td>
          <td id="subMenuName3"></td>
      </tr>
      <tr>
          <td height="52"></td>
          <td><img id="subMenuImg4" src="" width="26" height="27" /></td>
          <td id="subMenuName4"></td>
      </tr>
      <tr>
          <td height="52"></td>
          <td><img id="subMenuImg5" src="" width="26" height="27" /></td>
          <td id="subMenuName5">&nbsp;</td>
      </tr>
      <tr>
          <td height="52"></td>
          <td><img id="subMenuImg6" src="" width="26" height="27" /></td>
          <td id="subMenuName6">&nbsp;</td>
      </tr>
      <tr>
          <td height="52"></td>
          <td><img id="subMenuImg7" src="" width="26" height="27" /></td>
          <td id="subMenuName7">&nbsp;</td>
      </tr>
      <tr>
          <td height="52"></td>
          <td><img id="subMenuImg8" src="" width="26" height="27" /></td>
          <td id="subMenuName8">&nbsp;</td>
      </tr>
      <tr>
          <td height="52"></td>
          <td><img id="subMenuImg9" src="" width="26" height="27" /></td>
          <td id="subMenuName9">&nbsp;</td>
      </tr>
        <tr>
          <td height="25" colspan="3" align="center"><img src="img/att_bottom.png" width="22" height="13" /></td>
        </tr>
  </table>
</div>
<!--视频窗口-->
<!--<div style="position:absolute; left:652px; top:165px; width:569px; height:373px;"><img src="img/icon_video.png" width="83" height="83" style="position: absolute; left: 248px; top: 155px;" /></div>-->
<div id="playName" style="position:absolute; left:652px; top:572px; width:569px; height:69px; line-height:69px; text-align:center; font-size:28px; color:#000;"></div>

<!--滚动条-->

<div style="position:absolute; left:624px; top:128px; width:2px; height:435px; background:#c8c8c8; ">
	<div id="scrollBar" style="position:absolute; left:-13px; top:22px; width:30px; height:70px; background:#a50100; font-size:20px; color:#fff; text-align:center; "><span>3</span><br />
  /<br /><span>38</span></div>
</div>
<!--回到顶部-->
<img id="goTopBtn" src="img/btn_top01.jpg" width="30" height="80" style="position:absolute; left:610px; top:563px;" />
<!--<div style="position: absolute; left: 624px; top: 176px; width: 3px; height: 419px; background: #c8c8c8;">
	<div style="position: absolute; width: 30px; height: 63px; background: #a3060d; font-size: 15px; text-align: center; color: #fff; left: -14px; top: -13px;">3<br />/<br />23</div>
    <img id="scroll" src="img/btn_top01.jpg" width="30" height="79" style="position: absolute; left: -13px; top: 393px;" />
</div>-->

<!--  按钮操作的弹出提示框  -->
<div id="resultReminderTips" style="position:absolute; left:441px; top:200px; width:396px; height:156px; background:url(img/notice01.png) no-repeat; visibility:hidden; ">
    <div id="resultReminderText0" style="position:absolute; left:32px; top:40px; width:320px; height:30px; font-size:30px; color:#af2837; text-align:center; ">该功能建设中</div>
    <div id="resultReminderText1" style="position:absolute; left:32px; top:76px; width:320px; height:22px; font-size:22px; color:#333333; text-align:center; "></div>
</div>

<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="../showtip.jsp"></jsp:include>
</body>
</html>
