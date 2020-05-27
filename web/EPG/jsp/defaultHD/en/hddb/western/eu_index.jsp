<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="eu_index_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title>eu_index</title>
<style>
.border td{ border-bottom: 1px solid #beb9cc;}
</style>

<script type="application/javascript" src="js/showList.js"></script>
<script type="application/javascript" src="js/tool.js"></script>
<script type="application/javascript" src="js/ajax.js"></script>
<script>
iPanel.eventFrame.initPage(window);
E.is_HD_vod = true;


var focusArea = 1;  // 0���ϵ��� 1���������� 2�����л�����  3�ұ�top���а� 4�����Ƽ��б�
var topButtonPos = 0;   //���Ͻǵ�����Ŀ�Ľ���
var columnPos = 0;   //����������
var loopBigImgPos = 0; //�ұߺ�������
var topListPos = 0;    //�ұ����а񽹵�
var recPos = 0 ;   //�����Ƽ����ֽ���

var columnUrl= ["eu_index.jsp",
				"eu_HBO.jsp?typeId=10000100000000090000000000105547",
				"eu_BBC.jsp?typeId=10000100000000090000000000105556",
				"eu_EA.jsp?typeId=10000100000000090000000000105559",
				"eu_classic.jsp?typeId=10000100000000090000000000105552"
				];
				
var posterData = [];
//���а�
var topListData = [];
var topListBox = null;
//�Ƽ��б�
var recListData = [];
var recListBox = null;

var typeId = "";
var vodId = 0;

var topButtonPic = [["img/search01.png","img/search02.png"],["img/btn01_1.jpg","img/btn01_2.jpg"],["img/btn02_1.jpg","img/btn02_2.jpg"],["img/btn03_1.jpg","img/btn03_2.jpg"]];

var searchInputObj = null;
var loopBigImgTimeout = -1;
var tipsShowFlag = false;
var reminderTimeout = -1;

var backUrl = "";
E.currCustId = "";
E.currPasswd = -3;
E.comboInfoObj = {};

var topicList = [];

function eventHandler(eventObj, type) {
	if (type == 1 && key_flag == 2) {//�㲥���ţ�ȥ���н�Ŀ��Ȩ
        return 0;
    } else if (type == 1 && key_flag == 1) {//����ʾ�򵯳���
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
				doSelect();
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
			default:
				return 1;
				break;				
		}
	}
	return 0;
}		

function init(){
	getTopicList();
	initDatas();
	initTopPic();
	initInputBox();  //������
	initTopData();
	initRecData();
	initPicData();
	initFocus();
	//initPageWidget();
	
	var url = window.location.href;
    var tmpRerturnUrl = getUrlParams("backURL",url);
	if(tmpRerturnUrl)backUrl = decodeURIComponent(tmpRerturnUrl);
	queryUserInfo();
	getValidComboInfo();
}

function getUrlParams(_key, _url) {
	//alert(window.location.href);
/*
 * ��ȡ��׼URL�Ĳ���
 * @_key���ַ�������֧����������������ͬ��key��
 * @_url���ַ�������window��.location.href��ʹ��ʱ������window����
 * ע�⣺
 * 	1���粻����ָ���������ؿ��ַ���������ֱ����ʾ��ʹ��ʱע���ж�
 * 	2���Ǳ�׼URL����
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


//��ʼ������
function initDatas() {
	topListData = vodTextArray;
	recListData = vodSmallImgArray;
	/*picData = vodSmallImgArray;*/
	posterData = vodImgArray;
	//��ʼ������
	focusArea = <%= focusArea%>;
	topButtonPos = <%= topButtonPos%>;
	columnPos = <%= columnPos%>;
	loopBigImgPos = <%= loopBigImgPos%>;
	topListPos = <%= topListPos%>;
	recPos = <%= recPos%>;
}

function getTopicList(){
	var url = E.pre_epg_url+"/defaultHD/en/hddb/hddb_topic.txt";
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		iPanel.debug("getValidComboInfo requestStr="+requestStr);
		if(requestStr != ""){
			eval("var tmpObj = "+requestStr);
			if(tmpObj.code == 200){
				topicList = tmpObj.data;
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
			getPosterFocus();
			break;
		case 3:
			getTopTitleFocus();
			break;
		case 4:
			getRecFocus();
			break;	
	}
}


//��ʼ�������
function initInputBox() {
    searchInputObj = new E.input_obj("search", "normal", $("search").innerText, window, 7, "img/focus.gif", "img/global_tm.gif", 20);
}

function initTopPic(){
	for(var i = 0; i < 4; i++){
		$("topBtn"+i).style.background = "url("+topButtonPic[i][0]+")";
	}
}

function initPicData(){
	$("posterId").src = posterData[0].img;
	$("posterInfo").innerText = posterData[0].name;
	$("posterIcon").style.background = "url("+posterData[0].iconPath+")";
	//$("posterIcon").innerText = posterData[0].type;
	loopBigImgTimeout = setTimeout("loopBigImg();",5000);
}

function loopBigImg(){
	$("countNum"+ loopBigImgPos).src = "img/lunbo_01.png";
	loopBigImgPos = (loopBigImgPos+1)%3;
	$("countNum"+ loopBigImgPos).src = "img/lunbo_02.png";
	$("posterId").src = posterData[loopBigImgPos].img;
	$("posterInfo").innerText = posterData[loopBigImgPos].name;
	$("posterIcon").style.background = "url("+posterData[loopBigImgPos].iconPath+")";
	//$("posterIcon").innerText = posterData[loopBigImgPos].type;
	clearTimeout(loopBigImgTimeout);
	loopBigImgTimeout = setTimeout("loopBigImg();",5000);

}

//�м������б���ʾ
function initTopData() {
    topListBox = new E.showList(5, topListData.length, topListPos, 70, window);
   	topListBox.focusDiv = "topTitleFocus";
	topListBox.listHigh = 53;
	topListBox.showType = 1;
    topListBox.haveData = function(list){
		$("topTitle" + list.idPos).innerText = iPanel.misc.interceptString(topListData[list.dataPos].name,24);
		$("topIcon" + list.idPos).innerText = topListData[list.dataPos].type;	
	};
    topListBox.notData = function(list){
		$("topTitle" + list.idPos).innerText = "";
		$("topIcon" + list.idPos).innerText = "";	
	};
    topListBox.startShow();
}




//�ײ��Ƽ���Ŀ����ʾ
function initRecData() {
    recListBox = new E.showList(5, recListData.length, recPos, 0, window);
    //recListBox.focusDiv = "recFocus";
	//recListBox.listHigh = 236;
	recListBox.listSign = 1;
	recListBox.showType = 0;
    recListBox.haveData = function(list){
		$("recImg" + list.idPos).src = recListData[list.dataPos].img;
		$("recInfo" +list.idPos).innerText = iPanel.misc.interceptString(recListData[list.dataPos].name,16);
		//$("recIcon" +list.idPos).innerText = recListData[list.dataPos].type;	
		//$("recIcon" +list.idPos).style.background = "url("+recListData[list.dataPos].iconPath+")";
		
	};
    recListBox.notData =  function(list){
		$("recImg" + list.idPos).src = "";
		$("recInfo" +list.idPos).innerText = "";
	};
    recListBox.startShow();
}


//�����ƶ�����   // 0���ϵ��� 1�����Ŀ 2�м��б� 3����ҳ 4���½���
function udMove(__num) {
    switch (focusArea) {
		case 0:	//���ϵ�������	
			if(__num > 0){
				focusArea = 1;
				loseTopFocus();
				getColumnFocus();	
			}
        	break;
		case 1: //�ϱ���Ŀ�б�
			if(__num < 0){
				focusArea = 0;
				loseColumnFocus();
				getTopFocus();
			}else if(__num > 0){
				focusArea = 2;
				getPosterFocus();
				loseColumnFocus();		
			}
            break;
        case 2:	//���Ϻ���
			if(__num < 0){
				focusArea = 1;
				losePosterFocus();
				getColumnFocus();
			}else if(__num > 0){
				focusArea = 4;
				losePosterFocus();
				getRecFocus();
			}
            break;
		case 3:	//top�Ȳ���
			changeTopTitleUD(__num);
            break;
		case 4://�ײ��Ƽ�
			if(__num < 0){
				if(recListBox.focusPos < 3){
					focusArea = 2;
					loseRecFocus();
					getPosterFocus();	
				}else if(recListBox.focusPos > 2){
					focusArea = 3;
					loseRecFocus();
					getTopTitleFocus();		
				}	
			}
			break;
	}
}

//�����ƶ�����   // 0���ϵ��� 1�����Ŀ 2�м��б� 3����ҳ 4���½���
function lrMove(__num){
	switch (focusArea){
		case 0:	//���ϵ�������
			changeTopFocus(__num);
			break;
		case 1: //�ϱ���Ŀ�б�
			changeColumnLR(__num);
            break;
        case 2:	//���Ϻ���
			changePosterLR(__num);
            break;
		case 3:	//top�Ȳ���
			if(__num<0){
				focusArea = 2;
				loseTopTitleFocus();
				getPosterFocus();	
			}
            break;
		case 4://�ײ��Ƽ�
			changeRecListLR(__num);
			break;	
	}
}

/* ----- ���浼����Ŀ����ز���  start -----*/
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
/* ----- ���浼����Ŀ����ز���  end -----*/

//����������
function changeColumnLR(__num){
	loseColumnFocus();
	columnPos = (columnPos + __num +5)%5;
	getColumnFocus();
}

function getColumnFocus(){
	$("menuName"+ columnPos).style.background = "#fff000";
	$("menuName"+ columnPos).style.color = "#000000";
}

function loseColumnFocus(){
	$("menuName"+ columnPos).style.background = "transparent";
	$("menuName"+ columnPos).style.color = "#ffffff";
}

//�м亣������
function changePosterLR(__num){
	if(__num > 0){
		focusArea = 3;
		losePosterFocus();
		getTopTitleFocus();
	}
}

function getPosterFocus(){
	$("posterFocus").style.visibility = "visible";
	$("posterFocus").style.left = "9px";	
	$("posterFocus").style.top = "119px";	
	$("posterFocus").style.width = "803px";	
	$("posterFocus").style.height = "441px";	
}

function losePosterFocus(){
	$("posterFocus").style.visibility = "hidden";
}

//�ұ�top���а�����
function changeTopTitleUD(_num){
	if(topListBox.focusPos ==0 && _num <0){
		focusArea = 1;
		getColumnFocus();
		loseTopTitleFocus();
		return;	
	}
	if(topListBox.focusPos ==4 && _num >0){
		focusArea = 4;
		loseTopTitleFocus();
		getRecFocus();
		return;	
	}
	setTopListStyle(false);
	topListBox.changeList(_num);
	setTopListStyle(true);	
}

function getTopTitleFocus(){
	setTopListStyle(true);
	$("topTitleFocus").style.visibility = "visible";
}

function loseTopTitleFocus(){
	setTopListStyle(false);
	$("topTitleFocus").style.visibility = "hidden";
}


//�������Ƽ��б�
function changeRecListLR(_num){
	loseRecFocus();
	recListBox.changeList(_num);	
	getRecFocus();
}

function getRecFocus(){
	setListStyle(true);
	$("posterFocus").style.visibility = "visible";
	$("posterFocus").style.left = 9+(recListBox.focusPos*237)+"px";	
	$("posterFocus").style.top = "471px";	
	$("posterFocus").style.width = "326px";
	$("posterFocus").style.height = "249px";
}

function loseRecFocus(){
	setListStyle(false);
	$("posterFocus").style.visibility = "hidden";
}

function setListStyle(flag) {
	var tempVod = recListData[recListBox.position];
	var name = tempVod.name;
	var tempName = iPanel.misc.interceptString(name,16);
	//$("posterName"+recListBox.position).style.color = flag?"#000000":"#f0f0f0";
	if(flag && name != tempName){
		$("recInfo"+recListBox.position).innerHTML = "<marquee style=\"width:220px;height:20px;\">" + name + "</marquee>";
	}else{
		$("recInfo"+recListBox.position).innerText = tempName;
	}
}

function setTopListStyle(flag) {
	var tempVod = topListData[topListBox.position];
	var name = tempVod.name;
	var tempName = iPanel.misc.interceptString(name,24);
	$("topTitle"+topListBox.focusPos).style.color = flag?"#000000":"#f0f0f0";
	if(flag && name != tempName){
		$("topTitle"+topListBox.focusPos).innerHTML = "<marquee style=\"width:380px;height:20px;\">" + name + "</marquee>";
	}else{
		$("topTitle"+topListBox.focusPos).innerText = tempName;
	}
}

function showReminder(__text){
	clearTimeout(reminderTimeout);
	tipsShowFlag = true;
	$("resultReminderText0").innerText = __text;
	$("resultReminderTips").style.visibility = "visible";
	reminderTimeout = setTimeout(hideReminder,2000);
	//focusArea = 2;
}		

function hideReminder(){
	clearTimeout(reminderTimeout);
	tipsShowFlag = false;
	$("resultReminderTips").style.visibility = "hidden";
	$("resultReminderText0").innerText = "";	
	$("resultReminderText1").innerText = "";
}

//�򿪲˵�
function doMenu() {
    E.marqueeText = null;
    iPanel.mainFrame.location.href = E.portal_url;
}

//����
function doInput(__num) {
    if (focusArea == 0 && topButtonPos == 0) {
        searchInputObj.get_input(__num);
    }
}

//ɾ��
function doBack() {
    if (focusArea == 0 && topButtonPos == 0) {
        searchInputObj.del_input();
    } else {
        doMenu();
		//iPanel.mainFrame.history.back();
    }
}


function doSelect(){
	if(tipsShowFlag){		
		hideReminder();
	}else{
		switch(focusArea){
			case 0:
				var baseurl = focusURL();
				switch(topButtonPos){
					case 0:
						window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp?keyword="
							+searchInputObj.input_str+"&epgBackurl=" + E.pre_epg_url + "/defaultHD/en/hddb/western/eu_index.jsp";
						break;
					case 1:
						showReminder("�ù��ܽ�����");
						//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/recordList.jsp";
						break;
					case 2:
						//showReminder("�ù��ܽ�����");
						//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/favoriteList.jsp";
						window.location.href = baseurl + "/EPG/jsp/defaultHD/en/Category.jsp?url=saveList.jsp";
						break;
					case 3:
						showTipWindow(0,1);
						break;
				}
				break;
			case 1:   //������Ŀ
				if(columnPos > 0){   //��ҳ���ý�ȥ ���ε�
					var baseurl = focusURL();
					window.location.href = baseurl + "western/"+columnUrl[columnPos];	
				}			
				break;
			case 2:  //�����б�����
				var baseurl = focusURL();
				var pos = loopBigImgPos;
				if(posterData[pos].playType != 1){
					typeId = posterData[pos].typeId;
					vodId = posterData[pos].vodId;
					var playType = posterData[pos].playType;
					if (typeId != '' && vodId != 0) {
						play_movie(playType);
					}
					//iPanel.overlayFrame.location.href = baseurl+"western/eu_filmDetail.jsp?vodId="+posterData[pos].vodId+"&typeId="+posterData[pos].typeId;
				}else if(posterData[pos].playType == 1){
					iPanel.overlayFrame.location.href = baseurl+"western/eu_tvDetail.jsp?vodId="+posterData[pos].vodId+"&typeId="+posterData[pos].typeId;
				}	
				break;
			case 3:
				var baseurl = focusURL();
				var pos = topListBox.position;
				if(topListData[pos].playType != 1){
					typeId = topListData[pos].typeId;
					vodId = topListData[pos].vodId;
					var playType = topListData[pos].playType;
					if (typeId != '' && vodId != 0) {
						play_movie(playType);
					}
					//iPanel.overlayFrame.location.href = baseurl+"western/eu_filmDetail.jsp?vodId="+topListData[pos].vodId+"&typeId="+topListData[pos].typeId;
				}else if(topListData[pos].playType == 1){
					iPanel.overlayFrame.location.href = baseurl+"western/eu_tvDetail.jsp?vodId="+topListData[pos].vodId+"&typeId="+topListData[pos].typeId;
				}	
				break;
			case 4:
				var baseurl = focusURL();
				var currName = 	recListData[recListBox.position].name;
				for(var i=0;i<topicList.length;i++){
					if(currName == topicList[i].name){
						if(topicList[i].url.indexOf("http") == -1){
							window.location.href = baseurl + topicList[i].url;
						}else{
							var backURL= encodeURIComponent(window.location.href);
							if(topicList[i].url.indexOf("?") == -1){
								window.location.href = baseurl + topicList[i].url+"?backURL="+backURL;
							}else{
								window.location.href = baseurl + topicList[i].url+"&backURL="+backURL;
							}
						}
						return;
					}
				}
				switch(recListBox.position){
					case 0:
						window.location.href = baseurl + "western/eu_weekList.jsp?typeId=10000100000000090000000000105546";
						break;
					case 1:
					case 2:
					case 3:
					case 4:
						//ΪӰƬ
						var pos = recListBox.position;
						if(recListData[pos].playType != 1){
							typeId = recListData[pos].typeId;
							vodId = recListData[pos].vodId;
							var playType = recListData[pos].playType;
							if (typeId != '' && vodId != 0) {
								play_movie(playType);
							}
						}else if(recListData[pos].playType == 1){
							loseRecFocus();
							iPanel.overlayFrame.location.href = baseurl+"western/eu_tvDetail.jsp?vodId="+recListData[pos].vodId+"&typeId="+recListData[pos].typeId;
						}
						break;
				}
				break;				
		}
	}
}



function focusURL() {
    var baseurl = "../SaveCurrFocus.jsp?currFoucs="+focusArea+","+topButtonPos+","+columnPos+","+loopBigImgPos+","+topListBox.position+","+recListBox.position+"&url=";
    return baseurl;
}

/**��Ŀ���ţ�������Ȩҳ��  */
function play_movie(playType) {
    if (playType == 1) {
        //����ǵ��Ӿ�
        window.location.href = focusURL() + "western/eu_tvDetail.jsp?vodId=" + vodId + "&typeId=" + typeId;
    } else {
        //��Ӱֱ�Ӳ���
        getAuthUrl(vodId);
    }
}

/**����ǩ������ */
function tip_fromBookmarkPlay() {
    var tempTime = domark(vodId);
    var baseurl = focusURL();
	iPanel.debug("index_ifeng baseurl=="+baseurl);
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&contentType=0&startTime=" + tempTime + "&business=1";
}

/* tipsWindow.jsp��getAuthUrl()�������ã��ӿ�ʼ������ */
function tip_fromBeginPlay() {
    var baseurl = focusURL();
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&contentType=0&business=1";
}


</script>
</head>

<body background="img/bg02.jpg" leftmargin="0" topmargin="0" onLoad="init();">
<!--title-->
<div style="position:absolute; left:52px; top:48px; width:207px; height:45px; "><img src="img/title01.png" /></div>

<!--������ť-->
<div  style="position:absolute; left:672px; top:44px; width:545px; height:36px; ">
	<!--����-->
	<div id="topBtn0" style="position:absolute; left:97px; top:0px; width:230px; height:36px;">		
		<div id="search" style="position:absolute; left:10px; top:7px; width:140px; height:22px; font-size:22px; "></div>
	</div>
	<!--��ʷ-->
	<div id="topBtn1" style="position:absolute; left:329px; top:0px; width:70px; height:36px;"></div>
	<!--�ղ�-->
	<div id="topBtn2" style="position:absolute; left:401px; top:0px; width:70px; height:36px;"></div>
	<!--����-->
	<div id="topBtn3" style="position:absolute; left:473px; top:0px; width:70px; height:36px;"></div>
</div>

<!--menu-->
<div style="position:absolute; left:55px; top:102px; width:1160px; height:54px; ">
	<div id="menuName0" style="position:absolute; left:50px; top:0px; width:155px; height:54px; text-align:center; line-height:54px; font-size:28px; color:#ffffff; ">��ҳ</div>
	<div id="menuName1" style="position:absolute; left:240px; top:0px; width:155px; height:54px; text-align:center; line-height:54px; font-size:28px; color:#ffffff; ">����</div>
	<div id="menuName2" style="position:absolute; left:477px; top:0px; width:155px; height:54px; text-align:center; line-height:54px; font-size:28px; color:#ffffff; ">Ӣ��</div>
	<div id="menuName3" style="position:absolute; left:713px; top:0px; width:155px; height:54px; text-align:center; line-height:54px; font-size:28px; color:#ffffff; ">ŷ��Ȧ</div>
	<div id="menuName4" style="position:absolute; left:955px; top:0px; width:155px; height:54px; text-align:center; line-height:54px; font-size:28px; color:#ffffff; ">���䡤�ڱ�</div>
</div>

<!--�ֲ�-->
<!--<div id="posterFocus" style="position:absolute; left:50px; top:157px; width:708px; height:345px; background:url(img/lunb0_posterFocus.png) no-repeat; visibility:hidden;"></div>-->
<div style="position:absolute; left:55px; top:162px; width:698px; height:335px; ">
	<img id="posterId" src="img/lunbo_poster01.gif" width="698" height="335" style="position:absolute; left:0px; top:0px;" />
  <!--��������-->
	<div id="posterInfo" style="position:absolute; left:0px; top:285px; width:698px; height:50px; background:url(img/text_shade.png) no-repeat; padding-left:15px; color:#ffffff; line-height:50px; font-size:26px; ">[Ȩ������Ϸ]</div>
	<!--�ֲ�����-->
    <div style="position:absolute; left:602px; top:302px; text-align:center; height:15px;">
        <table width="75" border="0" cellspacing="0" cellpadding="0" >
          <tr>
            <td height="15" width="25"><img id="countNum0" src="img/lunbo_02.png" /></td>
            <td width="25"><img id="countNum1" src="img/lunbo_01.png" width="15" height="15" /></td>
            <td width="25"><img id="countNum2" src="img/lunbo_01.png" /></td>
          </tr>
      	</table>
  	</div>
  <!--�Ǳ�-->
  <div id="posterIcon" style="position:absolute; left:0px; top:0px; width:67px; height:68px; background:url() no-repeat;">
  </div>
</div>

<!--Top�Ȳ���-->
<div style="position:absolute; left:765px; top:163px; width:459px; height:335px; background:url(img/topHot_btm.png) no-repeat;">
	<!--����-->
	<div id="topTitleFocus" style="position:absolute; left:0px; top:66px; width:459px; height:53px; background:#fff000; visibility:hidden;"></div>
    <div style="position:absolute; left:0px; top:65px; width:459px; height:270px;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:25px; color:#f0f0f0;">
              <tr>
                <td width="5" height="54"></td>
                <td id="topIcon0" width="73" style="background:url(img/label01.png) no-repeat center left; font-size:18px"></td>
                <td id="topTitle0">[����] Ȩ������Ϸ��һ��</td>
              </tr>
              <tr>
                <td height="54"></td>
                <td id="topIcon1" style="background:url(img/label02.png) no-repeat center left; font-size:18px"></td>
                <td id="topTitle1">[BBCӢ��]�����ֲ����µ��ļ�</td>
              </tr>
              <tr>
                <td height="54"></td>
                <td id="topIcon2" style="background:url(img/label03.png) no-repeat center left; font-size:18px"></td>
                <td id="topTitle2">[�ƻö���]������ӵڶ���</td>
              </tr>
              <tr>
                <td height="54"></td>
                <td id="topIcon3" style="background:url(img/label01.png) no-repeat center left; font-size:18px"></td>
                <td id="topTitle3">[HBO����]��������˵�һ��</td>
              </tr>
              <tr>
                <td height="54"></td>
                <td id="topIcon4" style="background:url(img/label02.png) no-repeat center left; font-size:18px"></td>
                <td id="topTitle4">[��������]С�����Ƶ�һ��</td>
              </tr>
      </table>
    </div>
</div>

<!--�Ƽ���Ŀ-->
<div style="position:absolute; left:55px; top:514px; width:1180px; height:143px; ">
  <div style="position:absolute; left:0px; top:0px; width:222px; height:143px; ">
		<img id="recImg0" src="img/recImg01.jpg" width="222" height="143" style="position:absolute; left:0px; top:0px;" />
		<div style="position:absolute; left:0px; top:107px; width:222px; height:36px; background:url(img/text_shade.png) no-repeat; padding-left:5px; color:#ffffff; line-height:36px; font-size:23px; ">һ��׷��</div>
		<div id="recInfo0" style="position:absolute; left:0px; top:107px; width:222px; height:36px; background:url(img/text_shade.png) no-repeat; padding-left:5px; color:#ffffff; line-height:36px; font-size:23px; visibility:hidden">һ��׷��һ��׷��</div>
		<div id="recIcon0" style="position:absolute; left:0px; top:0px; width:67px; height:68px; background:url(img/label_zj.png) no-repeat;"></div>
	  	<!--<img id="recIcon0" src="img/label_latest.png" width="67" height="68" style="position:absolute; left:0px; top:0px;" />	-->
  </div>
   <div style="position:absolute; left:237px; top:0px; width:222px; height:143px; ">
		<img id="recImg1" src="img/recImg01.jpg" width="222" height="143" style="position:absolute; left:0px; top:0px;" />
		<div id="recInfo1" style="position:absolute; left:0px; top:107px; width:222px; height:36px; background:url(img/text_shade.png) no-repeat; padding-left:5px; color:#ffffff; line-height:36px; font-size:23px; ">һ��׷��</div>
	  	<div id="recIcon1" style="position:absolute; left:0px; top:0px; width:67px; height:68px; background:url(img/label_yl.png) no-repeat;">
		</div>	
  </div>
   <div style="position:absolute; left:474px; top:0px; width:222px; height:143px; ">
		<img id="recImg2" src="img/recImg01.jpg" width="222" height="143" style="position:absolute; left:0px; top:0px;" />
		<div id="recInfo2" style="position:absolute; left:0px; top:107px; width:222px; height:36px; background:url(img/text_shade.png) no-repeat; padding-left:5px; color:#ffffff; line-height:36px; font-size:23px; ">һ��׷��</div>
	  	<div id="recIcon2" style="position:absolute; left:0px; top:0px; width:67px; height:68px; background:url(img/label_ch.png) no-repeat;">
		</div>	
  </div>
   <div style="position:absolute; left:711px; top:0px; width:222px; height:143px; ">
		<img id="recImg3" src="img/recImg01.jpg" width="222" height="143" style="position:absolute; left:0px; top:0px;" />
		<div id="recInfo3" style="position:absolute; left:0px; top:107px; width:222px; height:36px; background:url(img/text_shade.png) no-repeat; padding-left:5px; color:#ffffff; line-height:36px; font-size:23px; ">һ��׷��</div>
		<div id="recIcon3" style="position:absolute; left:0px; top:0px; width:67px; height:68px;">
		</div>
</div>
   <div style="position:absolute; left:948px; top:0px; width:222px; height:143px; ">
		<img id="recImg4" src="img/recImg01.jpg" width="222" height="143" style="position:absolute; left:0px; top:0px;" />
		<div id="recInfo4" style="position:absolute; left:0px; top:107px; width:222px; height:36px; background:url(img/text_shade.png) no-repeat; padding-left:5px; color:#ffffff; line-height:36px; font-size:23px; ">һ��׷��</div>
		<div id="recIcon4" style="position:absolute; left:0px; top:0px; width:67px; height:68px;">
		</div>
</div>
		
	<!--����-->
	<!--<div id="recFocus" style="position:absolute; left:-5px; top:-5px; width:232px; height:153px; background:url(img/rec_focus.png) no-repeat; visibility:hidden;"></div>-->
</div>

<div id="posterFocus" style="position:absolute; left:9px; top:471px; width:326px; height:249px; visibility:hidden;">
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
<!--  ��ť�����ĵ�����ʾ��  -->
<div id="resultReminderTips" style="position:absolute; left:441px; top:200px; width:396px; height:156px; background:url(img/notice01.png) no-repeat; visibility:hidden; ">
    <div id="resultReminderText0" style="position:absolute; left:32px; top:40px; width:320px; height:30px; font-size:30px; color:#af2837; text-align:center; ">�ù��ܽ�����</div>
    <div id="resultReminderText1" style="position:absolute; left:32px; top:76px; width:320px; height:22px; font-size:22px; color:#333333; text-align:center; "></div>
</div>

<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="showtip.jsp"></jsp:include>

</body>
</html>
