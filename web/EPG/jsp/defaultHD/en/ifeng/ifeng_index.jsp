<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="ifeng_index_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title>���ר��</title>

<script type="application/javascript" src="js/showList.js"></script>
<script type="application/javascript" src="js/tool.js"></script>
<script>
iPanel.eventFrame.initPage(window);
E.is_HD_vod = true;

var focusArea = 1;  // 0���ϵ������� 1�����Ŀ���� 2 �м���Ƶ 3�м�ͼƬ����  4�����Ƽ����� 5�ұߺ��� 6���½���
var topButtonPos = 0;   //���Ͻǵ�����Ŀ�Ľ���
var columnPos = 0;   //�����Ŀ�Ľ���
var videoPos = 0;   //�м���Ƶ����
var picPos = 0; //�м�ͼƬ����
var listFocusPos = 0;     //�����Ƽ�����
var loopBigImgPos = 0; //�ұߺ�������

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

//��߲˵�����
var menuData = [
    {name: "��¼", 		url: "ifeng_imgList.jsp?typeId=10000100000000090000000000105585&pageSize=20&menuPos=0"},
    {name: "��Ѷ", 		url: "ifeng_list.jsp?typeId=10000100000000090000000000105586&pageSize=20&menuPos=1"},
    {name: "����", 		url: "ifeng_list.jsp?typeId=10000100000000090000000000105587&pageSize=20&menuPos=2"},
    {name: "��ʷ����",  url: "ifeng_imgList.jsp?typeId=10000100000000090000000000105588&pageSize=20&menuPos=3"},
    {name: "����̸", 	url: "ifeng_list.jsp?typeId=10000100000000090000000000105590&pageSize=20&menuPos=4"},
    {name: "����ʱ��",  url: "ifeng_imgList.jsp?typeId=10000100000000090000000000105589&pageSize=20&menuPos=5"},
	{name: "�ƾ�", 		url: "ifeng_list.jsp?typeId=10000100000000090000000000105591&pageSize=20&menuPos=6"}
];

var marqueeText = "�����ר����ǿ�����ߣ�ÿ��25Ԫ��Ϊ��������ḻ����ʷ�Ļ�������ص������ӽǣ���Ϭ����ʱ�����ۣ�����������Ŷ��졣";

//test data
listData =[ {type:"��Ѷ", name:"����\"�����������\"�����߲���\"�Ҳ�"},
			{type:"����", name:"���콭����Ȧ·������ ����¶20ƽ�״�"},
			{type:"�ƾ�", name:"��ý���й����о����ʵ�徭�ó������"}
			];
picData =[{name:"2������ʷ",img:"img/tj_img01.jpg"},{name:"���߿�ͨ",img:"img/tj_img02.jpg"}];

var backUrl = "";

function eventHandler(eventObj, type) {
	iPanel.debug("index_ifeng eventObj.code="+eventObj.code+",,type="+type);
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
	picData = vodSmallImgArray.slice(0,2);
	listData = vodSmallImgArray.slice(2);
	posterData = vodImgArray;
	
	//��ʼ������
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
	if(typeof(currEvent)=="undefined") return "���޽�Ŀ��Ϣ";
	else return currEvent.name;
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

//�����б�����
function setList(list) {
	$("text" + list.idPos).innerText = listData[list.dataPos].type;
    $("name" + list.idPos).innerText = iPanel.misc.interceptString(listData[list.dataPos].name, 38);
}

//����б�����
function clearList(list) {
	$("text" + list.idPos).innerText = "";
    $("name" + list.idPos).innerText = "";
}

//�����б���ʽ
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




//�����ƶ�����  0���ϵ������� 1�����Ŀ���� 2 �м���ƵͼƬ����   3 �����Ƽ�����  4���½���
function udMove(__num) {
    switch (focusArea) {
		case 0:	//���ϵ�������	
			if(__num > 0){
          		focusArea = 2;
				loseTopFocus();
				getVideoFocus();
			}
        	break;
		case 1: //�����Ŀ����
			changeColumnUD(__num); 
            break;
        case 2:	//�м���Ƶ����
			changeVideoUD(__num);
            break;
		case 3:	//�м���Ƶ����
			changePicUD(__num);
            break;
		case 4://�����Ƽ�����
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
		case 5://�ұߺ���
			changePosterUD(__num);
            break;
		case 6://���½���
			if(__num < 0){
				focusArea = 5;
				loseFootFocus();
				getPosterFocus();
			}
            break;
    }
}

//�����ƶ�����
function lrMove(__num) {
	switch (focusArea) {
		case 0:	//���ϵ�������
			changeTopFocus(__num);
			break;
		case 1:	//�����Ŀ����
			changeColumnLR(__num);
			break;
		case 2:	//�м���Ƶ����
			changeVideoLR(__num);
			break;
		case 3:	//�м�ͼƬ����
			changePicLR(__num);
			break;
		case 4:	//�����Ƽ�����
			setListStyle(false);
			if(__num > 0){
				focusArea = 5;
				getPosterFocus();
			}else{
				focusArea = 1;
				getColumnFocus();
			}
			break;
		case 5:	//�ұߺ���
			changePosterLR(__num);
			break;
		case 6:	//���½���
			if(__num < 0){
				focusArea = 4;
				loseFootFocus();
				setListStyle(true);
			}
			break;
	}
}


/*  �����Ŀ����Ľ����л� start  */
function changeColumnUD(__num){
	loseColumnFocus();
	if(__num < 0 && columnPos == 0){  //��
		focusArea = 0;
		getTopFocus();
	}else if(__num > 0 && (columnPos == 5 || columnPos == 6)){   //��
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

//�����л�����
function changeColumnLR(__num){
	if(__num < 0 && (columnPos==0||columnPos==1||columnPos ==3||columnPos==5)){    //��    
		return;	
	}else{
		loseColumnFocus();
		if(__num > 0 && (columnPos==0||columnPos==2||columnPos==4)){  //��
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

/*----- �����Ŀ����Ľ����л� end  ----*/


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


/* ----- �м���Ƶ���������� start  -----*/
//�����л�����
function changeVideoUD(__num){
	loseVideoFocus();
	if(__num < 0 && (videoPos == 0 || videoPos == 1)){		//��
		focusArea = 0;
		getTopFocus();
	}else if(__num > 0 &&(videoPos == 0 || videoPos == 2)){		//��
		focusArea = 3;
		getPicFocus();
	}else{
		videoPos += __num;
		getVideoFocus();
	}
}

//�����л�����
function changeVideoLR(__num){
	loseVideoFocus();
	if(__num < 0 && videoPos == 0){		//��
		focusArea = 1;
		getColumnFocus();
	}else if(__num > 0 && (videoPos == 1 || videoPos == 2)){
		focusArea = 5;
		getPosterFocus();
	}else{		//��
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

//�м�СͼƬ����

function changePicUD(_num){
	losePicFocus();
	if(_num < 0){		//��
		focusArea = 2;
		getVideoFocus();
	}else if(_num > 0){		//��
		focusArea = 4;
		setListStyle(true);
	}
}

//�����л�����
function changePicLR(_num){
	losePicFocus();
	if(_num < 0 && picPos == 0){		//��
		focusArea = 1;
		getColumnFocus();
	}else if(_num>0 && picPos == 1){		//��
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

//�ұߺ���
function changePosterUD(__num){
	losePosterFocus();
	if(__num < 0){		//��
		focusArea = 0;
		getTopFocus();
	}else if(__num > 0){		//��
		focusArea = 6;
		getFootFocus();
	}
}

//�����л�����
function changePosterLR(__num){
	if(__num < 0){		//��
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
/* ----- �м�ͼƬ���������� end  -----*/


/* -----�����Ƽ������Ĳ��� start  -----*/


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
		case 0:	//���ϵ�������
			var baseurl = focusURL();
			switch(topButtonPos){
				case 0:
					window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp?keyword="
						+searchInputObj.input_str+"&epgBackurl=" + E.pre_epg_url + "/defaultHD/en/ifeng/ifeng_index.jsp";
					break;
				case 1:
					showReminder("�ù��ܽ�����");
					//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/recordList.jsp";
					break;
				case 2:
					showReminder("�ù��ܽ�����");
					//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/favoriteList.jsp";
					break;
				case 3:
					showTipWindow(0,1);
					break;
			}
			break;
		case 1:	//�����Ŀ����
			var url = menuData[columnPos].url;
            var baseurl = focusURL();
			iPanel.debug("index_ifeng baseurl=="+baseurl);
            //window.location.href = baseurl + "/EPG/jsp/defaultHD/en/ifeng/"+url;
			window.location.href = baseurl + url;
			break;
		case 2:	//�м���Ƶ����
			if(videoPos == 1){
				var currCha = user.channels.getChannelByNum(177);
			}else{
				var currCha = user.channels.getChannelByNum(178);
			}
			toDVBFlag = true;
			currCha.open();
			break;
		case 3:	//�м�ͼƬ����
			if (picData.length > 0) {
				typeId = picData[picPos].typeId;
				vodId = picData[picPos].vodId;
				var playType = picData[picPos].playType;
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
			}
			break;
		case 4:	//�����Ƽ�����
			if (listBox.dataSize > 0) {
				//ΪӰƬ
				typeId = listData[listBox.position].typeId;
				vodId = listData[listBox.position].vodId;
				var playType = listData[listBox.position].playType;
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
			}
			break;
		case 5:	//�ұߺ��� //ΪӰƬ
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
		case 6:	//���½���
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

//��ʾ�����
function showMarquee() {
    $("marquee").innerText = marqueeText;
}

function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs="+focusArea+","+topButtonPos+","+columnPos+","+videoPos+","+picPos+","+listBox.position+","+loopBigImgPos+"&url=";
    return baseurl;
}

/**��Ŀ���ţ�������Ȩҳ��  */
function play_movie(playType) {
    if (playType == 1) {
        //����ǵ��Ӿ�
        window.location.href = focusURL() + "ifeng_tvDetail.jsp?vodId=" + vodId + "&typeId=" + typeId;
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
            + "&progId=" + vodId + "&baseFlag=0&contentType=0&startTime=" + tempTime + "&business=1";
}

/* tipsWindow.jsp��getAuthUrl()�������ã��ӿ�ʼ������ */
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
<!--����ɫ��#ffa000����̬ɫ��#945c4f��-->
<!--logo-->
<img src="img/logo.png" width="166" height="43" style=" position:absolute; left:65px;  top:39px;" />

<!--��ť-->
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

<!--�м�����-->
<div style="position:absolute; left:0px; top:105px; width:1280px; height:515px; ">
	<!--���-->
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
	
	<!--��Ƶ����-->
	<div id="middleImg0" style="position:absolute; left:365px; top:5px; width:370px; height:290px; background:url(img/video_focus.png) no-repeat; visibility:hidden;"></div>	
	<div id="middleImg1" style="position:absolute; left:740px; top:0px; width:160px; height:150px;">
		<div style="position:absolute; left:5px; top:5px; width:150px; height:140px; background-color:#ffbb77;"></div>
		<!--<img src="img/enter_chanel_ch.jpg" width="150" height="140" style=" position:absolute; left:5px; top:5px;" />-->
		<div id="evntName0" style="position:absolute; left:10px; top:62px; width:140px; height:22px; text-align:left; font-size:22px; line-height:22px; color:#ffffff;">����Ƶ��һ</div>
	</div>
	<div id="middleImg2" style="position:absolute; left:740px; top:150px; width:160px; height:150px;">
		<div style="position:absolute; left:5px; top:5px; width:150px; height:140px; background-color:#ffbb77;"></div>
		<!--<img src="img/enter_chanel_news.jpg" width="150" height="140" style=" position:absolute; left:5px; top:5px;" />	-->
		<div id="evntName1" style="position:absolute; left:10px; top:64px; width:140px; height:22px; text-align:left; font-size:22px; line-height:22px; color:#ffffff;">����Ƶ����</div>
	</div>	
	
	<!--�Ƽ�-->
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
	
	<!--�����Ƽ�-->
	<div style="position:absolute; left:365px; top:395px; width:530px; height:120px; background:#e4c2b9; z-index:10 ">
		<table width="530" border="0" cellspacing="0" cellpadding="0" style="font-size:22px; z-index:5;">
			  <tr>
				<td id="text0" width="58" height="40" align="center" style="background:#ab41bf; color:#fff;">��Ѷ</td>
				<td id="name0" style="padding-left:10px;"></td>
			  </tr>
			  <tr>
				<td id="text1" height="40" align="center" style="background:#54a28a; color:#fff;">����</td>
				<td id="name1" style="padding-left:10px; background:#edd5cf;"></td>
			  </tr>
			  <tr>
				<td id="text2" height="40" align="center" style="background:#6690e6; color:#fff;">�ƾ�</td>
				<td id="name2" style="padding-left:10px;"></td>
			  </tr>
		</table>
	</div>
</div>

<!--news-->
<!--<div style="position:absolute; left:124px; top:651px; width:910px; height:24px; color:#f0f0f0; font-size:24px; overflow:hidden; ">��ָ�Ƿ�����6%����1200����ͣ����ʯ�͡��й����еȸ��𳬼�Ȩ�ع�β�г�С������ָ����</div>-->
<div style="position:absolute; left:124px; top:651px; width:910px; height:24px; color:#f0f0f0; font-size:24px;">
	<marquee id="marquee"></marquee>
</div>	

<!--��ҳ-->
<div id="footBtn" style="position:absolute; left:1045px; top:640px; width:170px; height:50px; background:#945c4f; text-align:center; font-size:28px; line-height:50px; color:#fff; ">��ҳ</div>

<!--  ��ť�����ĵ�����ʾ��  -->
<div id="resultReminderTips" style="position:absolute; left:441px; top:200px; width:396px; height:156px; background:url(img/notice01.png) no-repeat; visibility:hidden; ">
    <div id="resultReminderText0" style="position:absolute; left:32px; top:40px; width:320px; height:30px; font-size:30px; color:#af2837; text-align:center; ">�ù��ܽ�����</div>
    <div id="resultReminderText1" style="position:absolute; left:32px; top:76px; width:320px; height:22px; font-size:22px; color:#333333; text-align:center; "></div>
</div>
	
<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="showtip.jsp"></jsp:include>
</body>
</html>
