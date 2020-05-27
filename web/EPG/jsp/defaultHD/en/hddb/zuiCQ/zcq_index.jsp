<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="zcq_index_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title>zcq_index</title>
<script type="application/javascript" src="js/ajax.js"></script>
<script>
iPanel.eventFrame.initPage(window);
E.is_HD_vod = true;

var focusArea = 1;  // 0���ϵ��� 1������Ѷ 2����� 3�����糡 4��ɽ��΢��Ӱ 5ͼƬ���� 6�����б� 7������ҳ
var topButtonPos = 0;   //���Ͻǵ�����Ŀ�Ľ���
var infoPos = 0;   //������Ѷ����
var lifePos = 0;   //����ｹ��
var hotTVPos = 0; //�糡����
var moviePos = 0;     //��ɽ��΢��Ӱ����
var listFocusPos = 0; //�����б���
var posterPos = 0;  //ͼƬ����λ��


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

var menuData = [{name:"������Ѷ",typeId:"10000100000000090000000000105715"},
				{name:"�����",  typeId:"10000100000000090000000000105716"},
				{name:"�����糡",typeId:"10000100000000090000000000105717"}
			   ];
var KwData = [{name:">���ܿ�",typeId:"10000100000000090000000000105719"},
			  {name:">΢��Ƶ",typeId:"10000100000000090000000000105718"}
			 ];
//��߲˵�����
//������Ѷ
var infoData = [
    {name: "������Ѷ", url: "txtList.htm"},
    {name: "����630", url: "txtList.htm"},
    {name: "����", url: "txtList.htm"},
    {name: "�ƾ�", url: "txtList.htm"}
];

//�����
var lifeData = [
    {name: "�����", url: "txtList.htm"},
    {name: "��ʳ", url: "txtList.htm"},
    {name: "����", url: "txtList.htm"},
    {name: "���", url: "txtList.htm"}
];

//�����糡
var tvData = [
    {name: "�����糡", url: "txtList.htm"},
    {name: "������", url: "txtList.htm"},
    {name: "��ůϵ��", url: "txtList.htm"},
    {name: "ϵ�о�", url: "txtList.htm"}
];

var marqueeText = "��ָ�Ƿ�����6%����1200����ͣ����ʯ�͡��й����еȸ��𳬼�Ȩ�ع�β�г�С������ָ����";

//test data
listData =[ {type:"��Ѷ", name:"��������������Ϯȫ�� ������ɽС�ı���Ϯ"},
			{type:"����", name:"���콭����Ȧ·������ ����¶20ƽ�״�"},
			{type:"�ƾ�", name:"��ý���й����о����ʵ�徭�ó������"},
			{type:"����", name:"���콭����Ȧ·������ ����¶20ƽ�״�"},
			{type:"�ƾ�", name:"��ý���й����о����ʵ�徭�ó������"}
			];
var topicList = [];

var tipsShowFlag = false;
var reminderTimeout = -1;

function eventHandler(eventObj, type) {
	iPanel.debug("index_ifeng eventObj.code="+eventObj.code+",,type="+type+",key_flag="+key_flag);
	if (type == 1 && key_flag == 2) {//�㲥���ţ�ȥ���н�Ŀ��Ȩ
        return 0;
    } else if (type == 1 && key_flag == 1) {//����ʾ�򵯳���
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
	initInputBox();
	initInfoData();
	initLifeData();
	initTVData();
	initList();
	initPicData();
	initFocus();
	showMarquee();
}

//��ʼ������
function initDatas() {
	infoData = typeListArray0;
	lifeData = typeListArray1;
	tvData = typeListArray2;
	listData = vodTextArray;
	//picData = vodSmallImgArray;
	posterData = vodImgArray;
	
	//��ʼ������
	focusArea = <%= focusArea%>;
	topButtonPos = <%= topButtonPos%>;
	infoPos = <%= infoPos%>;
	lifePos = <%= lifePos%>;
	hotTVPos = <%= hotTVPos%>;
	moviePos = <%= moviePos%>;
	listFocusPos = <%= listFocusPos%>;
	posterPos = <%= posterPos%>;
	marqueeText = content;
    E.marqueeText = content;
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


function initPicData(){
	for(var i = 0; i < posterData.length; i++){
		$("picName"+i).src = posterData[i].img;
	}
}

function initFocus(){
	switch(focusArea){
		case 0:
			getTopFocus();
			break;
		case 1:
			getInfoFocus();
			break;
		case 2:
			getLifeFocus();
			break;
		case 3:
			getHotFocus();
			break;
		case 4:
			getMovieFocus();
			break;
		case 5:
			getPosterFocus();
			break;
		case 6:
			getTxtFocus();
			break;
		case 7:
			getGoBackFocus();
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

//������Ѷ
function initInfoData(){
	for(var i=1;i<4;i++){
		$("infoName"+i).innerText = infoData[i-1].name;	
	}	
}

//�����
function initLifeData(){
	for(var i=1;i<4;i++){
		$("lifeName"+i).innerText = lifeData[i-1].name;	
	}	
}

//�����糡
function initTVData(){
	for(var i=1;i<4;i++){
		$("tvName"+i).innerText = tvData[i-1].name;	
	}	
}


//�����Ƽ���������ݼ���
function initList() {
    listBox = new E.showList(5, listData.length, listFocusPos, 0, window);
    listBox.showType = 1;
    listBox.haveData = setList;
    listBox.notData = clearList;
    listBox.startShow();
}

//�����б�����
function setList(list) {
	$("txt" + list.idPos).innerText = listData[list.dataPos].type;
    $("txtTitle" + list.idPos).innerText = listData[list.dataPos].name;
}

//����б�����
function clearList(list) {
	$("txt" + list.idPos).innerText = "";
    $("txtTitle" + list.idPos).innerText = "";
}

//�����б���ʽ
function setListStyle(flag) {
    var name = listData[listBox.position].name;
    var focusPos = listBox.focusPos;
    var tempName = iPanel.misc.interceptString(name, 38);
	$("txtTitle" + focusPos).style.backgroundColor = flag ? "#ffa000" : (focusPos==1)?"#edd5cf":"transparent";
	if (name != tempName && flag) {
		$("txtTitle" + focusPos).innerHTML = "<marquee style=\"width:460px;height:32px;\">" + name + "</marquee>";
	}else {
		$("txtTitle" + focusPos).innerText = tempName;
	}
}




//�����ƶ�����  0���ϵ������� 1�����Ŀ���� 2 �м���ƵͼƬ����   3 �����Ƽ�����  4���½���
function udMove(__num) {
    switch (focusArea) {
		case 0:	//���ϵ�������	
			if(__num > 0){
				if(topButtonPos<2){
					focusArea = 3;
					loseTopFocus();
					getHotFocus();	
				}else{
					focusArea = 4;
					loseTopFocus();
					getMovieFocus();	
				}
          		
			}
        	break;
		case 1: //������Ѷ
			changeInfoUD(__num); 
            break;
        case 2:	//�����
			changeLifeUD(__num);
            break;
		case 3:	//�����糡
			changeTVUD(__num);
            break;
		case 4://��ɽ��΢��Ӱ
			changeMovieFocus(__num);
            break;
		case 5://�ұߺ���
			changePosterUD(__num);
            break;
		case 6://�����Ƽ�����
			changeTxtList(__num);
            break;
		case 7:    //������ҳ
			if(__num<0){
				focusArea = 5;
				posterPos = 5;
				loseGoBackFocus();
				getPosterFocus();
			}			
			break;	
    }
}

//�����ƶ�����
function lrMove(__num){
	switch (focusArea){
		case 0:	//���ϵ�������
			changeTopFocus(__num);
			break;
		case 1: //������Ѷ
			changeInfoLR(__num); 
            break;
        case 2:	//�����
			changeLifeLR(__num);
            break;
		case 3:	//�����糡
			changeTVLR(__num);
            break;
		case 4://��ɽ��΢��Ӱ
			if(__num<0){
				focusArea = 3;
				loseMovieFocus();
				getHotFocus();	
			}
            break;
		case 5://�ұߺ���
			changePosterLR(__num);
            break;
		case 6://�����Ƽ�����
			if(__num<0){
				focusArea =5;
				posterPos =1;
				loseTxtFocus();
				getPosterFocus();	
			}
            break;
		case 7:    //������ҳ
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





//������Ѷ
function changeInfoUD(__num){
	if(__num<0){
		if(infoPos<2){
			focusArea = 0;
			loseInfoFocus();
			getTopFocus();
		}else{
			loseInfoFocus();
			infoPos-=2;
			getInfoFocus();	
		}
	}else if(__num>0){
		if(infoPos<2){
			loseInfoFocus();
			infoPos += 2;
			getInfoFocus();		
		}else if(infoPos==2 || infoPos ==3){
			focusArea = 5;
			loseInfoFocus();
			getPosterFocus();	
		}	
	}	
}

function changeInfoLR(__num){
	if(__num<0){
		if(infoPos == 0||infoPos == 2){
			return;
		}else{
			loseInfoFocus();
			infoPos -= 1;
			getInfoFocus();	
		}
	}else if(__num>0){
		if(infoPos == 1||infoPos == 3){
			focusArea = 2;
			loseInfoFocus();
			getLifeFocus();
		}else if(infoPos == 0 || infoPos == 2){
			loseInfoFocus();
			infoPos += 1;
			getInfoFocus();	
		}	
	}	
}

function getInfoFocus(){
	if(infoPos==0){
		$("infoFocus").style.visibility = "visible";
	}else{
		$("infoName"+infoPos).style.background = "#af2837";
		$("infoName"+infoPos).style.color = "#ffffff";	
	}
		
}

function loseInfoFocus(){
	if(infoPos==0){
		$("infoFocus").style.visibility = "hidden";
	}else{
		$("infoName"+infoPos).style.background = "transparent";
		$("infoName"+infoPos).style.color = "#000000";	
	}
}


//�����
function changeLifeUD(__num){
	if(__num<0){
		if(lifePos<2){
			focusArea = 0;
			loseLifeFocus();
			getTopFocus();
		}else{
			loseLifeFocus();
			lifePos-=2;
			getLifeFocus();	
		}
	}else if(__num>0){
		if(lifePos<2){
			loseLifeFocus();
			lifePos += 2;
			getLifeFocus();		
		}else if(lifePos==2 || lifePos ==3){
			focusArea = 5;
			posterPos = 1; 
			loseLifeFocus();
			getPosterFocus();	
		}	
	}	
}

function changeLifeLR(__num){
	if(__num<0){
		if(lifePos == 0||lifePos == 2){
			focusArea = 1;
			loseLifeFocus();
			getInfoFocus();
		}else{
			loseLifeFocus();
			lifePos -= 1;
			getLifeFocus();	
		}
	}else if(__num>0){
		if(lifePos == 1||lifePos == 3){
			focusArea = 3;
			loseLifeFocus();
			getHotFocus();
		}else if(lifePos == 0 || lifePos == 2){
			loseLifeFocus();
			lifePos += 1;
			getLifeFocus();	
		}	
	}	
}

function getLifeFocus(){
	if(lifePos==0){
		$("lifeFocus").style.visibility = "visible";
	}else{
		$("lifeName"+lifePos).style.background = "#af2837";
		$("lifeName"+lifePos).style.color = "#ffffff";
	}
}

function loseLifeFocus(){
	if(lifePos==0){
		$("lifeFocus").style.visibility = "hidden";
	}else{
		$("lifeName"+lifePos).style.background = "transparent";
		$("lifeName"+lifePos).style.color = "#000000";	
	}
}



//�����糡
function changeTVUD(__num){
	if(__num<0){
		if(hotTVPos<2){
			focusArea = 0;
			loseHotFocus();
			getTopFocus();
		}else{
			loseHotFocus();
			hotTVPos-=2;
			getHotFocus();	
		}
	}else if(__num>0){
		if(hotTVPos<2){
			loseHotFocus();
			hotTVPos += 2;
			getHotFocus();		
		}else if(hotTVPos==2 || hotTVPos ==3){
			focusArea = 6;
			loseHotFocus();
			getTxtFocus();	  //�����б�����
		}	
	}	
}

function changeTVLR(__num){
	if(__num<0){
		if(hotTVPos == 0||hotTVPos == 2){
			focusArea = 2;
			loseHotFocus();
			getLifeFocus();
		}else{
			loseHotFocus();
			hotTVPos -= 1;
			getHotFocus();	
		}
	}else if(__num>0){
		if(hotTVPos == 1||hotTVPos == 3){
			focusArea = 4;
			loseHotFocus();
			getMovieFocus();
		}else if(hotTVPos == 0 || hotTVPos == 2){
			loseHotFocus();
			hotTVPos += 1;
			getHotFocus();	
		}	
	}	
}

function getHotFocus(){
	if(hotTVPos==0){
		$("hotFocus").style.visibility = "visible";
	}else{
		$("tvName"+hotTVPos).style.background = "#af2837";
		$("tvName"+hotTVPos).style.color = "#ffffff";
	}
}

function loseHotFocus(){
	if(hotTVPos==0){
		$("hotFocus").style.visibility = "hidden";
	}else{
		$("tvName"+hotTVPos).style.background = "transparent";
		$("tvName"+hotTVPos).style.color = "#000000";	
	}
}

//��ɽ�� ΢��Ӱ
function changeMovieFocus(_num){
	if(moviePos ==1&&_num>0){
		focusArea = 6;
		loseMovieFocus();
		getTxtFocus();
		return;	
	}
	if(moviePos==0&&_num<0){
		focusArea = 0;
		loseMovieFocus();
		getTopFocus();
		return;	
	}
	loseMovieFocus();
	moviePos = (moviePos+_num+2)%2;	
	getMovieFocus();
}

function getMovieFocus(){
	$("movieName"+moviePos).style.background = "url(img/column_focus02.png) center no-repeat";
}

function loseMovieFocus(){
	$("movieName"+moviePos).style.background = "url() center no-repeat";
}


//ͼƬ����Ĳ�������
function changePosterUD(_num){
	if(_num<0){   //����
		if(posterPos==0){
			focusArea = 1;
			losePosterFocus();
			getInfoFocus();
		}else if(posterPos==1){
			focusArea = 2;
			losePosterFocus();
			getLifeFocus();
		}else if(posterPos==2||posterPos==3){
			losePosterFocus();
			posterPos = 1;	
			getPosterFocus();
		}else if(posterPos==4||posterPos==5){
			focusArea = 6;
			losePosterFocus();
			getTxtFocus();	
		}
	}else if(_num>0){   //����
		if(posterPos==0||(posterPos>=2&&posterPos<5)){
			return;	
		}
		losePosterFocus();
		if(posterPos==1){
			posterPos+=1;
			getPosterFocus();	
		}else if(posterPos==5){
			focusArea = 7;
			losePosterFocus();	
			getGoBackFocus();
		}
	}	
}

function changePosterLR(_num){
	if(_num<0){
		if(posterPos ==0){
			return;	
		}	
		losePosterFocus();	
		if(posterPos ==2){
			posterPos = 0;	
		}else{
			posterPos-=1;	
		}
		getPosterFocus();	
	}else if(_num>0){
		if(posterPos ==5){
			return;
		}
		if(posterPos ==1){
			focusArea = 6;
			losePosterFocus();	
			getTxtFocus();	
		}else{
			losePosterFocus();	
			posterPos+=1;	
			getPosterFocus();	
		}	
	}	
}

function getPosterFocus(){
	//alert("getPosterFocus  posterPos====" + posterPos);
	$("imgDiv"+posterPos).style.background = "#af2837";	
}

function losePosterFocus(){
	$("imgDiv"+posterPos).style.background = "transparent";	
}

//�����Ƽ����� ����
function changeTxtList(_num){
	if(listBox.position==0&&_num<0){
		focusArea = 3;
		loseTxtFocus();
		getHotFocus();
		return;	
	}
	if(listBox.position==4&&_num>0){
		focusArea = 5;
		posterPos = 4;
		loseTxtFocus();
		getPosterFocus();
		return;	
	}
	loseTxtFocus();
	listBox.changeList(_num);	
	getTxtFocus();
}


function getTxtFocus(){
	$("txtTitle"+listBox.focusPos).style.background = "#af2837";
	$("txtTitle"+listBox.focusPos).style.color = "#ffffff";	
}

function loseTxtFocus(){
	$("txtTitle"+listBox.focusPos).style.background = "transparent";
	$("txtTitle"+listBox.focusPos).style.color = "#000000";	
}


//�ײ�������ҳ�Ľ����
function getGoBackFocus(){
	$("footBtn").style.backgroundColor = "#af2837";
	$("footBtn").style.color = "#ffffff";		
}

function loseGoBackFocus(){
	$("footBtn").style.backgroundColor = "#6b6e76";	
	$("footBtn").style.color = "#fffff";		
}

function gotows(__url){
	var returnUrl = encodeURI("ui://portal.htm?"+iPanel.eventFrame.portal_url);
	var net_type = "";
	if(typeof(E.netType) == "undefined"){
		net_type = "Cable;IP";
	}else{
		net_type = E.netType;
	}
	var curr_url = __url;
	if(curr_url.indexOf("http://epgServer") > -1){
		curr_url=curr_url.replace("http://epgServer",iPanel.eventFrame.pre_epg_url);
	}
	curr_url = "ui://portal1.htm?" + curr_url;
	if(curr_url.indexOf("viewSize=SD") == -1) E.is_HD_vod = true;//cdq �������Ӧ������Ϊtrue
	else E.is_HD_vod = false;
	
	curr_url+="&stbid="+hardware.STB.serialNumber+"&preplayurl="+E.prePlayUrl+"&return_url="+returnUrl;//cdq ��Ϊ��VOD��Ҫ�����Щ����
	iPanel.debug("gotows curr_url="+curr_url);
	var auth_str = "User=&pwd=&ip="+network.ethernets[0].IPs[0].address+"&NTID="+network.ethernets[0].MACAddress+"&CARDID="+E.cardId+"&Version=1.0&lang=1&supportnet="+net_type+"&decodemode=H.264HD;MPEG-2HD&CA=1&ServiceGroupID="+E.ServiceGroupID+"&encrypt=0";
	
	curr_url = curr_url.replace("Category.jsp?url=", "Category.jsp?"+auth_str+"&viewSize=HD&url=");
	iPanel.mainFrame.location.href = curr_url;
}

function doSelect(){
	iPanel.debug("index_ifeng focusArea=="+focusArea);
	switch (focusArea) {
		case 0:	//���ϵ�������
			var baseurl = focusURL();
			switch(topButtonPos){
				case 0:
					window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp?keyword="
					+searchInputObj.input_str+"&epgBackurl="+E.pre_epg_url+"/defaultHD/en/hddb/zuiCQ/zcq_index.jsp";
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
					window.location.href = baseurl + "http://192.168.5.75/ccn-tv/2";
					break;
			}
			break;
		case 1:	//������Ѷ
			var baseurl = focusURL();
			window.location.href = baseurl + "zuiCQ/zcq_list.jsp?typeId="+infoData[0].typeId+"&leftTypeId="+menuData[focusArea-1].typeId+"&menuPos="+(focusArea-1)+"&leftFocus="+infoPos;
			break;
		case 2:	//�����
			var baseurl = focusURL();
			window.location.href = baseurl + "zuiCQ/zcq_list.jsp?typeId="+lifeData[0].typeId+"&leftTypeId="+menuData[focusArea-1].typeId+"&menuPos="+(focusArea-1)+"&leftFocus="+lifePos;
			break;
		case 3:	//�����糡
			var baseurl = focusURL();
			window.location.href = baseurl + "zuiCQ/zcq_list.jsp?typeId="+tvData[0].typeId+"&leftTypeId="+menuData[focusArea-1].typeId+"&menuPos="+(focusArea-1)+"&leftFocus="+hotTVPos;
			break;
		case 4:	//��ɽ�� ΢��Ƶ
			var baseurl = focusURL();
			if(moviePos == 0){
				window.location.href = baseurl + "/EPG/jsp/neirong/STemplate1.jsp";
			}else{
				window.location.href = baseurl + "zuiCQ/zcq_microMovie.jsp?typeId="+KwData[moviePos].typeId+"&menuPos="+moviePos;
			}
			break;
		case 5:	//ͼƬ��������
			var baseurl = focusURL();
			var currName = 	posterData[posterPos].name;
			for(var i=0;i<topicList.length;i++){
				if(currName == topicList[i].name){
					if(topicList[i].url.indexOf("code") == -1){
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
					}else{
						gotows(topicList[i].url);
					}
					return;
				}
			}
			if (posterData.length > 0) {
				typeId = posterData[posterPos].typeId;
				vodId = posterData[posterPos].vodId;
				var playType = posterData[posterPos].playType;
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
			}
			break;
		case 6:  //������������
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
		case 7:	//���½���
			doMenu();
			break;
	}
}

/*function testAjax(){
	var url = E.pre_epg_url+"/defaultHD/en/Auth_removeBase_nor.jsp?progId=PACKAGE201506000013-gehua&playType=1&contentType=0&business=1&idType=FSN&baseFlag=2";
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		iPanel.debug("testAjax requestStr="+requestStr);
		if(requestStr != ""){
			eval("var tmpStr = "+requestStr);
		}
	},
	function(__errorCode){
		iPanel.debug("keywordConvert __errorCode="+__errorCode);
	},
	3000);	
	requestAjaxObj.requestData();
}*/

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
    }
}

//��ʾ�����
function showMarquee() {
    $("marquee").innerText = marqueeText;
}

function focusURL() {
    var baseurl = "../SaveCurrFocus.jsp?currFoucs="+focusArea+","+topButtonPos+","+infoPos+","+lifePos+","+hotTVPos+","+moviePos+","+listBox.position+","+posterPos+"&url=";
    return baseurl;
}

/**��Ŀ���ţ�������Ȩҳ��  */
function play_movie(playType) {
	if (playType == 1) {
		//����ǵ��Ӿ�
		window.location.href = focusURL() + "vod/tv_detail.jsp?vodId=" + vodId + "&typeId=" + typeId;
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

function exit_page(){
	iPanel.exitMode();
	if(!toDVBFlag) DVB.stopAV(0);
}
</script>


</head>

<body leftmargin="0" topmargin="0" background="img/bg.jpg" onLoad="init();">
<!--logo-->
<div style="position:absolute; left:66px; top:21px; width:346px; height:80px; background:url(img/logo01.png) no-repeat; "></div>

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

<!--��Ŀ-->
<div style="position: absolute; left: 0px; top: 110px; width: 1226px; height: 100px;">
	<!--��Ŀ1-->
	<div style="position:absolute; left:65px; top:0px; width:320px; height:100px; background:url(img/column_btm.jpg) no-repeat; ">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:center; font-size:26px;">
		  <tr>
			<td id="infoName0"  width="160" height="50"><img src="img/column01.jpg" /></td>
			<td id="infoName1" align="center"></td>
		  </tr>
		  <tr>
			<td id="infoName2" align="center"></td>
			<td id="infoName3" align="center"></td>
		  </tr>
	</table>
	<!--��Ŀ����-->
	<img id="infoFocus" src="img/column_focus.png" width="170" height="60" style="position:absolute; left:-5px; top:-5px; visibility:hidden;" />
	</div>
	
	<!--��Ŀ2-->
  <div style="position:absolute; left:395px; top:0px; width:320px; height:100px; background:url(img/column_btm.jpg) no-repeat; ">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:center; font-size:26px;">
		  <tr>
			<td id="lifeName0" width="160" height="50"><img src="img/column02.jpg" width="160" height="50" /></td>
			<td id="lifeName1" align="center"></td>
		  </tr>
		  <tr>
			<td id="lifeName2" align="center"></td>
			<td id="lifeName3" align="center"></td>
		  </tr>
	</table>
	<!--��Ŀ����-->
	<img id="lifeFocus" src="img/column_focus.png" width="170" height="60" style="position:absolute; left:-5px; top:-5px; visibility: hidden;" />	</div>
	
	<!--��Ŀ3-->
  <div style="position:absolute; left:725px; top:0px; width:320px; height:100px; background:url(img/column_btm.jpg) no-repeat; ">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:center; font-size:26px;">
		  <tr>
			<td id="tvName0" width="160" height="50"><img src="img/column03.jpg" width="160" height="50" /></td>
			<td id="tvName1" align="center"></td>
		  </tr>
		  <tr>
			<td id="tvName2" align="center"></td>
			<td id="tvName3" align="center"></td>
		  </tr>
	</table>
	<!--��Ŀ����-->
	<img id="hotFocus" src="img/column_focus.png" width="170" height="60" style="position:absolute; left:-5px; top:-5px; visibility: hidden;" />	</div>
	<!--��Ŀ4-->
	<div id="movieName0" style="position:absolute; left:1050px; top:-8px; width:170px; height:60px; ">
		<img src="img/column04.png" width="160" height="50" style="position:absolute; left:5px; top:5px;" />	</div>
	
	<!--��Ŀ5-->
	<div  id="movieName1" style="position:absolute; left:1050px; top:48px; width:170px; height:60px;">
		<img src="img/column05.png" width="160" height="50" style="position:absolute; left:5px; top:5px;" />	
	</div>
</div>

<!--�����Ƽ�-->
<div style="position:absolute; left:725px; top:230px; width:490px; height:200px; background:url(img/txtRec_btm.jpg) no-repeat; ">	
	<table width="490" height="199" border="0" cellspacing="0" cellpadding="0" style="font-size:20px;">
		  <tr>
			<td id="txt0" width="58" height="40" align="center" style="color:#ffffff;"></td>
			<td id="txtTitle0" style="padding-left:10px; padding-right:10px;"></td>
		  </tr>
		  <tr>
			<td id="txt1" width="58" height="40" align="center" style="color:#ffffff;"></td>
			<td id="txtTitle1" style="padding-left:10px; padding-right:10px;"></td>
		  </tr>
		  <tr>
			<td id="txt2" width="58" height="40" align="center" style="color:#ffffff;"></td>
			<td id="txtTitle2" style="padding-left:10px; padding-right:10px;"></td>
		  </tr>
		  <tr>
			<td id="txt3" width="58" height="40" align="center" style="color:#ffffff;"></td>
			<td id="txtTitle3" style="padding-left:10px; padding-right:10px;"></td>
		  </tr>
		  <tr>
			<td id="txt4" width="58" height="40" align="center" style="color:#ffffff;"></td>
			<td id="txtTitle4" style="padding-left:10px; padding-right:10px;"></td>
		  </tr>
	</table>
</div>

<!--�����Ƽ�-->
<div style="position: absolute; left: 60px; top: 225px; width: 1169px; height: 400px;">
	<div id="imgDiv0" style="position:absolute; left:0px; top:0px; width:270px; height:400px;"><img id="picName0" src="img/index_poster01.jpg" width="260" height="390" style="position:absolute; left:5px; top:5px;" /></div>
	<div id="imgDiv1" style="position:absolute; left:270px; top:0px; width:390px; height:210px; ">
		<img id="picName1" src="img/index_poster02.jpg" width="380" height="200" style="position:absolute; left:5px; top:5px;" />
		<img src="img/label_zt.png" width="79" height="80" style="position:absolute; left:5px; top:5px;" />
	</div>
	<div id="imgDiv2" style="position:absolute; left:270px; top:210px; width:390px; height:191px; ">
		<img id="picName2" src="img/index_poster03.jpg" width="380" height="180" style="position:absolute; left:5px; top:5px; width: 379px;" />	</div>
  <div id="imgDiv3" style="position:absolute; left:660px; top:210px; width:250px; height:190px; ">
		<img id="picName3" src="img/index_poster04.jpg" width="240" height="180" style="position:absolute; left:5px; top:5px;" />
  </div>
	<div id="imgDiv4" style="position:absolute; left:910px; top:210px; width:250px; height:190px; ">
		<img id="picName4" src="img/index_poster05.jpg" width="240" height="180" style="position:absolute; left:5px; top:5px;" />
	</div>
</div>




<!--news-->
<div style="position:absolute; left:65px; top:640px; width:1150px; height:50px; background:#cbc4d0; ">
	<table width="1150" height="50" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="50" height="50"><img src="img/news.png" width="33" height="27" /></td>
			<td style="font-size:22px;">
				<marquee id="marquee">��ָ�Ƿ�����6%����1200����ͣ����ʯ�͡��й����еȸ��𳬼�Ȩ�ع�β�г�С������ָ����</marquee></td>
			<td id="footBtn" width="170" align="center" style="background:#6b6e76; font-size:28px; color:#fff;"> ��ҳ</td>
		  </tr>
	</table>
</div>

<!--  ��ť�����ĵ�����ʾ��  -->
<div id="resultReminderTips" style="position:absolute; left:441px; top:200px; width:396px; height:156px; background:url(img/notice01.png) no-repeat; visibility:hidden; ">
    <div id="resultReminderText0" style="position:absolute; left:32px; top:40px; width:320px; height:30px; font-size:30px; color:#af2837; text-align:center; ">�ù��ܽ�����</div>
    <div id="resultReminderText1" style="position:absolute; left:32px; top:76px; width:320px; height:22px; font-size:22px; color:#333333; text-align:center; "></div>
</div>

<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="../showtip.jsp"></jsp:include>
</body>
</html>
