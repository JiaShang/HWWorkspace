<%@ page contentType="text/html; charset=GBK" language="java" pageEncoding="GBK" %>
<%@ include file="ifeng_topicList_data.jsp" %>
<html>
<head>
<meta name="page-view-size" content="1280*720">
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title>ifeng_topicList</title>
<script type="application/javascript" src="js/showList.js"></script>
<script type="application/javascript" src="js/tool.js"></script>

<script>
iPanel.eventFrame.initPage(window);
var focusArea = 0;     //0 列表区域处理  1回顶部
var listFocusPos = 0;   //右边栏目焦点
var menuPos = -1

var listBox = null;
var listData = [];
var topicList = [];	

/*listData=[
	{vodID:1,name:"1200",img:"img/akch_img01.jpg"},
	{vodID:1,name:"1300",img:"img/akch_img02.jpg"},
	{vodID:1,name:"1400",img:"img/akch_img03.jpg"},
	{vodID:1,name:"1100",img:"img/akch_img01.jpg"},
	{vodID:1,name:"1500",img:"img/akch_img01.jpg"},
	{vodID:1,name:"1100",img:"img/akch_img01.jpg"},
	{vodID:1,name:"1600",img:"img/akch_img03.jpg"},
	{vodID:1,name:"1100",img:"img/akch_img02.jpg"},
	{vodID:1,name:"1700",img:"img/akch_img01.jpg"},
	{vodID:1,name:"1100",img:"img/akch_img03.jpg"},
	{vodID:1,name:"1800",img:"img/akch_img02.jpg"},
	{vodID:1,name:"1100",img:"img/akch_img03.jpg"},
	{vodID:1,name:"1900",img:"img/akch_img01.jpg"},
	{vodID:1,name:"1100",img:"img/akch_img02.jpg"},
	{vodID:1,name:"1000",img:"img/akch_img01.jpg"},
	{vodID:1,name:"1100",img:"img/akch_img01.jpg"},
	{vodID:1,name:"1101",img:"img/akch_img02.jpg"},
	{vodID:1,name:"1100",img:"img/akch_img03.jpg"},
	{vodID:1,name:"1102",img:"img/akch_img01.jpg"}
];
*/


function eventHandler(eventObj, type) {
	iPanel.debug("index_ifeng eventObj.code="+eventObj.code+",,type="+type);
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
		case "KEY_PAGE_UP": //上翻页
			changeTitlePage(-1);
			break;
		case "KEY_PAGE_DOWN": //下翻页
			changeTitlePage(1);
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
		default:
			return 1;
			break;				
	}
	return 0;
}
		

function init(){
	//getTopicList();
	initDatas();
	initList();	
	initFocus();
}
//初始化数据
function initDatas() {
	listData = vodImgArray;
	//picData = vodSmallImgArray;
	menuPos = 	<%= menuPos%>;
	//初始化焦点
	focusArea = <%= focusArea%>;
	listFocusPos = <%= subMenuPos%>;
	if(menuPos != -1)listFocusPos = menuPos;
}

/*function getTopicList(){
	//var url = "http://192.168.9.124/dvbottapp/topictest.txt";E.pre_epg_url+"/defaultHD/en/hddb/vod/film_index.jsp
	var url = E.pre_epg_url+"/defaultHD/en/hddb/hddb_topic.txt";
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		iPanel.debug("getTopicList requestStr="+requestStr);
		if(requestStr != ""){
			eval("var tmpObj = "+requestStr);
			if(tmpObj.code == 200){
				topicList = tmpObj.data;
				//alert("topicList.length=="+topicList.length);
			}else {
				//$("comboInfo").innerText = tmpObj.msg;
				//$("comboPrice").innerText = "";
			}
		}
	},
	function(__errorCode){
		iPanel.debug("checkIfOrdered __errorCode="+__errorCode);
	},
	20000);	
	requestAjaxObj.requestData("post");
}*/

function initFocus(){
	switch(focusArea){
		case 0:
			getListFocus();
			break;
		case 1:
			getGoTopFocus();
			break;
	}
}


function udMove(__num){
	switch(focusArea){
		case 0:
			if(__num < 0 && listBox.position > 2){
				changeTitleList(-3); 
			}else if(__num > 0 && listBox.dataSize-listBox.position > 3){
				changeTitleList(3); 
			}
			break;	
		case 1:
			break;	
	}		
}

//左右移动焦点
function lrMove(__num){
	switch(focusArea){
		case 0:
			changeTitleList(__num);
			break;	
		case 1:
			if(__num < 0){
				focusArea = 0;
				loseGoTopFocus();
				getListFocus();
			}
			break;	
	}	
}


/* ----- 右边列表操作  start -----*/

//显示右边列表
function initList(){
	listBox = new showList(6, listData.length, listFocusPos, 106, window);
	listBox.listHigh = 50;
	listBox.showType = 0;
	listBox.haveData = function(List){
		$("imgDiv"+List.idPos).style.visibility = "visible";
		$("listName"+List.idPos).innerText = iPanel.misc.interceptString(listData[List.dataPos].name,24);	
		$("listImg"+List.idPos).src = listData[List.dataPos].img;
		$("listIcon"+List.idPos).src= listData[List.dataPos].iconPath;
	};
	listBox.notData = function(List){
		$("listName"+List.idPos).innerText = "";
		$("listImg"+List.idPos).src = "img/global_tm.gif";
		$("listIcon"+List.idPos).src = "img/global_tm.gif";
		$("imgDiv"+List.idPos).style.visibility = "hidden";
	};
	listBox.startShow();	
	initScroll();
}

//设置列表样式
function setListStyle(flag) {
	var tempVod = listData[listBox.position];
	var name = tempVod.name;
	var tempName = iPanel.misc.interceptString(name,24);
	if (name != tempName && flag) {
		$("listName"+listBox.focusPos).innerHTML = "<marquee style=\"width:328px;height:22px;\">" + name + "</marquee>";
	}else {
		$("listName"+listBox.focusPos).innerText = tempName;
	}
}	

//右边列表切换操作
function changeTitleList(_num){
	loseListFocus();
	var subMenuSize = listData.length;	
	if(_num == 1){
		if(parseInt((listBox.position + _num)%3,10) == 0||(listBox.position ==(subMenuSize-1))){//在最右边的位置, 右键 翻页
			focusArea = 1;
			loseListFocus();
			getGoTopFocus();
			return;
		}else{
			listBox.changeList(1);
		}
	}else if(_num == -1){
		if(parseInt(listBox.position%3,10) == 0){//在坐左边的位置, 左键 翻页
			listBox.changePage(-1);
		}else{			
			listBox.changeList(-1);
		}
	}else if(_num ==3){		
		if(parseInt(listBox.position%6,10) < 3){//在第一行
			if((parseInt((listBox.position + subMenuSize%6),10) >= subMenuSize ) && (parseInt((subMenuSize%6 <=3),10) || ( (subMenuSize - listBox.position) <=3))){//最后一页 && 第二行没有图标 || 当前位置的下一行没图标
				return;
			}else{
				listBox.changeList(3);
			}
		}else if(parseInt(listBox.position%6,10) > 2){//在第二行
			listBox.changePage(1);
		}
	}else if(_num == -3){
		if(listBox.position <3){
			focusArea = 0;
			getTopFocus();
			loseListFocus();
			return;	
		}
		if(parseInt(listBox.position%6,10)<3){
			listBox.changePage(-1);
		}else if(parseInt(listBox.position%6,10) >2){			
			listBox.changeList(-3);
		}		
	}	
	getListFocus();
	scrollChange();
}

//left: 18px; top: 91px; width: 466px; height: 351px;
function getListFocus(){
	$("menuFocus").style.visibility = "visible";
	if(listBox.focusPos<3){
		$("menuFocus").style.left = 20 + (listBox.focusPos*379)+"px";
		$("menuFocus").style.top = "91px";
	}else if(listBox.focusPos >2 &&listBox.focusPos <6){
		$("menuFocus").style.left = 20 + ((listBox.focusPos-3)*379)+"px";	
		$("menuFocus").style.top = "374px";
	}
	setListStyle(true);
}

function loseListFocus(){
	$("menuFocus").style.visibility = "hidden";
	setListStyle(false);
}

function changeTitlePage(__num){
	listBox.changePage(__num);
	scrollChange();	
}
/* ----- 右边列表操作  end -----*/

/*----  滚动条以及回顶部的 操作 start  ----*/

//滚动条
function initScroll(){
	scrollBar = new ScrollBar("scrollBar");
	scrollBar.init(Math.ceil(listBox.dataSize/listBox.listSize),1, 380, 0);
	if(listBox.dataSize == 0){
		$("scrollBar").innerHTML = '0<br />/<br />0';	
	}else{
		scrollChange();
	}
}

function scrollChange(){	//显示当前页码数和总共页码数
	scrollBar.scroll(listBox.currPage-1);
	$("scrollBar").innerHTML = listBox.currPage+'<br />/<br />'+listBox.listPage;	
}



function getGoTopFocus(){
	$("goTopBtn").src = "img/btn_top02.png";
}

function loseGoTopFocus(){
	$("goTopBtn").src = "img/btn_top01.png";
}
/*----   滚动条以及回顶部的 操作 end  ----*/



function doSelect(){
	if(focusArea == 0){
		var baseurl = focusURL();
		window.location.href = baseurl + "ifeng_topPicDetail.jsp?typeId="+listData[listBox.position].typeId;	
	}else if(focusArea ==1){
		focusArea = 0;
		listFocusPos = 0;
		loseGoTopFocus();
		initList();
		getListFocus();	
	}	
}

//打开菜单
function doMenu() {
    E.marqueeText = null;
    iPanel.mainFrame.location.href = E.portal_url;
}

//删除
function doBack() {
	window.location.href =E.pre_epg_url+"/defaultHD/en/hddb/fh_new/fh_index.jsp"; 
		//window.location.href = "<//%=turnPage.go(-1)%>";
	
}

function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs="+focusArea+","+listBox.position+"&url=";
    return baseurl;
}



</script>
</head>

<body  leftmargin="0" topmargin="0" onLoad="init();">
<!--logo-->
<div style="position:absolute;left:0px;top:0px;background:url(img/logo1_bg.png);width:1280px;height:92px;color:#fff;font-size:22px;">
		<!--logo-->
		<div style="position:absolute;left:68px;top:32px;width:100px;height:50px;"><img src="img/logo.png" width="177" height="52"></div>
		<div style="position:absolute; left:245px; top:43px; width:200px; height:24px; font-size:24px; color:#fefeff; ">>专题</div>
</div>


<!--列表-->
<div style="position:absolute;top:92px;background:url(img/bufen_bg.jpg);width:1280px;height:628px;"></div>

<!--  列表焦点框 -->
<div id="menuFocus" style="position: absolute; left: 20px; top: 374px; width: 466px; height: 351px;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="70" height="70" style="background:url(img/focus01.png) no-repeat;"></td>
    <td style="background:url(img/focus02.png) repeat-x;"></td>
    <td width="70" style="background:url(img/focus03.png) no-repeat;"></td>
  </tr>
  <tr>
    <td style="background:url(img/focus04.png) repeat-y;"></td>
    <td></td>
    <td style="background:url(img/focus05.png) repeat-y;"></td>
  </tr>
  <tr>
    <td height="70" style="background:url(img/focus06.png) no-repeat;"></td>
    <td style="background:url(img/focus07.png) repeat-x;"></td>
    <td style="background:url(img/focus08.png) no-repeat;"></td>
  </tr>
</table>
</div>

<div style="position:absolute; left:66px; top:134px; width:1130px; height:540px;color:#fff; ">
<!--上排-->

<div id="imgDiv0" style="position:absolute; left:0px; top:0px; width:362px; height:245px;">
	<img id="listImg0" src="img/z01.png" width="362" height="204" />
	<img id="listIcon0" src="img/new.png" width="66" height="71" style="position:absolute;left:0;top:0;z-index:9;" />
	<div id="listName0" style="position:absolute;top:206px; width:362px; height:41px;background:#000;padding-left:30px;font-size:24px;line-height:38px;">霸气女神范冰冰</div>
</div>

<div id="imgDiv1" style="position:absolute; left:379px; width:362px; height:245px;">
	<img id="listImg1" src="img/z02.png" width="362" height="204" />
	<img id="listIcon1" src="img/new.png" width="66" height="71" style="position:absolute;left:0;top:0;z-index:9;" />
	<div id="listName1" style="position:absolute;top:206px; width:362px; height:41px; background:#000;padding-left:30px;font-size:24px;line-height:38px;">奔跑吧兄弟</div>
</div>

<div id="imgDiv2" style="position:absolute; left:757px; width:362px; height:245px;">
	<img id="listImg2" src="img/z03.png" width="362" height="204" />
	<img id="listIcon2" src="img/new.png" width="66" height="71" style="position:absolute;left:0;top:0;z-index:9;" />
	<div id="listName2" style="position:absolute;top:206px; width:362px; height:41px; background:#000;padding-left:30px;font-size:24px;line-height:38px;">爸爸去哪儿</div>
</div>

<!--第二排--->
<div id="imgDiv3" style="position:absolute;top:283px; width:362px; height:245px;">
	<img id="listImg3"  src="img/z04.png" width="362" height="204" />
	<img id="listIcon3" src="img/new.png" width="66" height="71" style="position:absolute;left:0;top:0;z-index:9;" />
	<div id="listName3" style="position:absolute;top:206px; width:362px; height:41px; background:#000;padding-left:30px;font-size:24px;line-height:38px;">六一亲子合家欢</div>
</div>

<div id="imgDiv4" style="position:absolute;left:379px;top:283px; width:362px; height:245px;">
	<img id="listImg4" src="img/z05.png" width="362" height="204" />
	<img id="listIcon4" src="img/new.png" width="66" height="71" style="position:absolute;left:0;top:0;z-index:9;" />
	<div id="listName4" style="position:absolute;top:206px; width:362px; height:41px; background:#000;padding-left:30px;font-size:24px;line-height:38px;">家庭必备科学急救常识</div>
</div>

<div id="imgDiv5" style="position:absolute;left:757px;top:283px; width:362px; height:245px;">
	<img id="listImg5" src="img/z06.png" width="362" height="204" />
	<img id="listIcon5" src="img/new.png" width="66" height="71" style="position:absolute;left:0;top:0;z-index:9;" />
	<div id="listName5" style="position:absolute;top:206px; width:362px; height:41px; background:#000;padding-left:30px;font-size:24px;line-height:38px;">我的上班路</div>
</div>


</div><!--内容背景图-->


<!--滚动条-->

<!-- 页码 -->
<div style="position:absolute; left:1224px; top:134px; width:2px; height:450px; background:#c4c4c6; ">
	<div id="scrollBar" style="position:absolute; left:-14px; top:22px; width:30px; height:70px; background:#7d7d7d; font-size:20px; color:#fff; text-align:center; "><span>3</span><br />
  /<br /><span>38</span></div>
</div>

<!--回到顶部-->
<img id="goTopBtn" src="img/btn_top01.png" width="30" height="80" style="position:absolute; left:1210px; top:584px;" />
</body>
</html>
