<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="ifeng_topicList_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title>ifeng list</title>
<script type="application/javascript" src="js/showList.js"></script>
<script type="application/javascript" src="js/tool.js"></script>
<script>
iPanel.eventFrame.initPage(window);
var focusArea =2;     //0�ұ��б�������   1���浼��������  2 ��ߺ�����ͼƬ����  3 �ض���
var listFocusPos = 0;   //�ұ���Ŀ����
var topButtonPos = 0;   //���Ͻǵ�����Ŀ�Ľ���
var picPos = 0;   //���ͼƬ����
var menuPos = 0;

var menuData = [">��¼",">��Ѷ",">����",">��ʷ����",">����̸",">����ʱ��",">�ƾ�"];
var topButtonPic = [["img/search01.png","img/search02.png"],["img/btn01_1.jpg","img/btn01_2.jpg"],["img/btn02_1.jpg","img/btn02_2.jpg"],["img/btn03_1.jpg","img/btn03_2.jpg"]];

var listBox = null;
var listData = [];
var tipsShowFlag = false;
var reminderTimeout = -1;

var typeId = "";
//listData = [{vodId:1,name:"1200���ž�սʿ���Խ��"},{vodId:1,name:"1300���ž�սʿ���Խ��"},{vodId:1,name:"1400���ž�սʿ���Խ��"},{vodId:1,name:"1100���ž�սʿ���Խ��"},{vodId:1,name:"1500���ž�սʿ���Խ��"},{vodId:1,name:"1100���ž�սʿ���Խ��"},{vodId:1,name:"1600���ž�սʿ���Խ��"},{vodId:1,name:"1100���ž�սʿ���Խ��"},{vodId:1,name:"1700���ž�սʿ���Խ��"},{vodId:1,name:"1100���ž�սʿ���Խ��"},{vodId:1,name:"1800���ž�սʿ���Խ��"},{vodId:1,name:"1100���ž�սʿ���Խ��"},{vodId:1,name:"1900���ž�սʿ���Խ��"},{vodId:1,name:"1100���ž�սʿ���Խ��"},{vodId:1,name:"1000���ž�սʿ���Խ��"},{vodId:1,name:"1100���ž�սʿ���Խ��"},{vodId:1,name:"1101���ž�սʿ���Խ��"},{vodId:1,name:"1100���ž�սʿ���Խ��"},{vodId:1,name:"1102���ž�սʿ���Խ��"}];

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
			case "KEY_PAGE_UP":
				changeTitlePage(-1);
				break;
			case "KEY_PAGE_DOWN":
				changeTitlePage(1);
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
	initDatas();
	initMenuText();
	initInputBox()
	initTopPic();
	initPicData();
	initList();
	initFocus();
}
//��ʼ������
function initDatas() {
	typeId = charTypeId;
	listData = vodTextArray.slice(3);
	picData = vodSmallImgArray;
	//��ʼ������
	focusArea = <%= focusArea%>;
	topButtonPos = <%= topButtonPos%>;
	picPos = <%= picPos%>;
	listFocusPos = <%= listFocusPos%>;
}

function initFocus(){
	switch(focusArea){
		case 0:
			$("listFocus").style.visibility = "visible";
			break;
		case 1:
			getTopFocus();
			break;
		case 2:
			getVedioFocus();
			break;
	}
}

function initMenuText(){
	$("menuText").innerText = ">���ʷ���";
}

function initTopPic(){
	for(var i = 0; i < 4; i++){
		$("topBtn"+i).style.background = "url("+topButtonPic[i][0]+")";
	}
}

//��ʼ�������
function initInputBox() {
    searchInputObj = new E.input_obj("search", "normal", $("search").innerText, window, 7, "img/focus.gif", "img/global_tm.gif", 20);
    if (focusArea == 1 && topButtonPos == 0) {
        searchInputObj.show_cursor();
    }
}

function initPicData(){
	for(var i = 0; i < 3; i++){
		$("pic"+i).src = picData[i].img;
		if(i>0){
			$("picName"+i).innerText = picData[i].name;
		}
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




/* ----- �ұ��б����  start -----*/

//��ʾ�ұ��б�
function initList(){
	listBox = new showList(10, listData.length, listFocusPos, 30, window);
	listBox.listHigh = 50;	
	listBox.showType  = 0;
	listBox.focusDiv = "listFocus";
	listBox.haveData = function(List){
		$("titleName"+List.idPos).innerText = listData[List.dataPos].name;	
		$("playIcon"+List.idPos).src ="img/play02.png";
	};
	listBox.notData = function(List){
		$("titleName"+List.idPos).innerText = "";
		$("playIcon"+List.idPos).src ="";
	};
	listBox.startShow();	
	initScroll();
}

//�ұ��б��л�����
function changeTitleList(__num){
	if(listBox.position == 0 && __num <0){
		focusArea =1;
		getTopFocus();
		$("listFocus").style.visibility ="hidden";	
		return;	
	}
	listBox.changeList(__num);	
	scrollChange();
}

function changeTitlePage(__num){
	listBox.changePage(__num);
	scrollChange();	
}
/* ----- �ұ��б����  end -----*/


//�����ƶ�����  //0�ұ��б�������   1���浼��������  2 ��ߺ�����ͼƬ����  3 �ض���
function udMove(__num) {
    switch (focusArea) {
		case 0: //�����Ŀ����
            changeTitleList(__num); 
            break;
        case 1:	//���ϵ�������	
			if(__num > 0){
          		focusArea = 0;
				loseTopFocus();
				$("listFocus").style.visibility ="visible";
			}
        	break;
        case 2:	//�м���ƵͼƬ����
			changeVedioUD(__num);
            break;
    }
}

//�����ƶ�����
function lrMove(__num) {
	switch (focusArea) {
		case 0:	//�ұ���Ŀ����
			if(__num > 0){
				focusArea = 3;
				$("listFocus").style.visibility ="hidden";
				getGoTopFocus();
			}else{
				focusArea = 2;
				$("listFocus").style.visibility ="hidden";
				getVedioFocus();	
			}
			break;
		case 1:	//���ϵ�������
			changeTopFocus(__num);
			break;
		case 2:	//���ͼƬ����
			changeVedioLR(__num);
			break;
		case 3:	//�ض���
			if(__num < 0){
				focusArea = 0;
				loseGoTopFocus();
				$("listFocus").style.visibility ="visible";
			}
			break;
	}
}


/*---- �����Ƶ�������   start -----*/

//����
function changeVedioUD(__num){
	if(__num<0){   //��
		if(picPos==0){
			focusArea = 1;
			loseVedioFocus();
			getTopFocus();
			return;	
		}
		loseVedioFocus();
		picPos = 0;
	}else if(__num>0){    //��
		if(picPos>0){
			return;
		}
		loseVedioFocus();
		picPos = 1;
	}
	getVedioFocus();
}

//����
function changeVedioLR(__num){
	if(__num<0){   //��
		if(picPos<2){
			return;	
		}
		loseVedioFocus();
		picPos = 1;
	}else if(__num>0){    //��		
		if(picPos==0||picPos==2){
			focusArea = 0;
			loseVedioFocus();
			$("listFocus").style.visibility ="visible";	
			return;
		}
		loseVedioFocus();
		picPos =2;
	}
	getVedioFocus();
}

function getVedioFocus(){
	$("vedioImg" + picPos).style.backgroundColor = "#ffa000";
}

function loseVedioFocus(){
	$("vedioImg" + picPos).style.backgroundColor = "transparent";
}

/*---- �����Ƶ�������   end -----*/

/*----  �������Լ��ض����� ���� start  ----*/

//������
function initScroll(){
	scrollBar = new ScrollBar("scrollBar");
	scrollBar.init(Math.ceil(listBox.dataSize/listBox.listSize),1, 335, 0);
	if(listBox.dataSize == 0){
		$("scrollBar").innerHTML = '0<br />/<br />0';	
	}else{
		scrollChange();
	}
}

function scrollChange(){	//��ʾ��ǰҳ�������ܹ�ҳ����
	scrollBar.scroll(listBox.currPage-1);
	$("scrollBar").innerHTML = listBox.currPage+'<br />/<br />'+listBox.listPage;	
}



function getGoTopFocus(){
	$("goTopBtn").style.background = "url(img/goToTop02.png) no-repeat";
}

function loseGoTopFocus(){
	$("goTopBtn").style.background = "url(img/goToTop01.png) no-repeat";
}
/*----   �������Լ��ض����� ���� end  ----*/


//0���ϵ������� 1�����Ŀ���� 2 �м���ƵͼƬ����   3 �����Ƽ�����  4���½���
function doSelect(){
	iPanel.debug("list_ifeng focusArea=="+focusArea);
	switch (focusArea) {
		case 0:	//�ұ��б�
			if(listBox.dataSize>0){
				vodId = listData[listBox.position].vodId;
				var playType = listData[listBox.position].playType;
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
			}
			break;
		case 1:	//����
			var baseurl = focusURL();
			switch(topButtonPos){
				case 0:
					window.location.href = baseurl + "/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp?keyword="+searchInputObj.input_str;
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
		case 2:	//���ͼƬ����
			if(picData.length > 0){
				vodId = picData[picPos].vodId;
				var playType = picData[picPos].playType;
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
			}
			break;
		case 3:	//�ض���
			focusArea = 0;
			loseGoTopFocus();
			initList();
			$("listFocus").style.visibility = "visible";
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
    if (focusArea == 1 && topButtonPos == 0) {
        searchInputObj.get_input(__num);
    }
}

//ɾ��
function doBack() {
    if (focusArea == 1 && topButtonPos == 0) {
        searchInputObj.del_input();
    } else {
		window.location.href = "<%=turnPage.go(-1)%>";
		//iPanel.mainFrame.history.back();
    }
}

//��ʾ�����
function showMarquee() {
    $("marquee").innerText = marqueeText;
}

function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + topButtonPos + "," + picPos + "," + listBox.position + "&url=";
    return baseurl;
}

/**��Ŀ���ţ�������Ȩҳ��  */
function play_movie(playType) {
    if (playType == 1) {
        //����ǵ��Ӿ�
        window.location.href = focusURL() + "../iCatch_TV_detail.jsp?vodId=" + vodId + "&typeId=" + typeId;
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

</script>


</head>

<body background="img/bg.jpg" leftmargin="0" topmargin="0" onLoad="init();">
<!--����ɫ��#ffa000����̬ɫ��#945c4f��-->
<!--logo-->
<img src="img/logo.png" width="166" height="43" style=" position:absolute; left:65px;  top:39px;" />
<div id="menuText" style="position:absolute; left:240px; top:47px; width:200px; height:24px; font-size:24px; color:#ffcf87; ">>��Ѷ</div>


<!--��ť-->
<div  style="position:absolute; left:672px; top:44px; width:545px; height:36px; ">
	<!--����-->
	<div id="topBtn0" style="position:absolute; left:97px; top:0px; width:230px; height:36px;">		
		<div id="search" style="position:absolute; left:10px; top:7px; width:140px; height:22px; font-size:22px;"></div>
	</div>
	<!--��ʷ-->
	<div id="topBtn1" style="position:absolute; left:329px; top:0px; width:70px; height:36px;"></div>
	<!--�ղ�-->
	<div id="topBtn2" style="position:absolute; left:401px; top:0px; width:70px; height:36px;"></div>
	<!--����-->
	<div id="topBtn3" style="position:absolute; left:473px; top:0px; width:70px; height:36px;"></div>
</div>

<!--����+�б�-->
<div style="position:absolute; left:65px; top:105px; width:1150px; height:560px; background:url(img/btm01.png) no-repeat; ">
	<div id="vedioImg0" style="position:absolute; left:0px; top:0px; width:560px; height:275px;">
		<img id="pic0" src="img/poster01.jpg" width="550" height="265" style="position:absolute; left:5px; top:5px;"/>
		<!--<div id="picName0" style="position:absolute; left:5px; top:239px; width:550px; height:30px; line-height:30px; font-size:24px; background-color:#CCCCCC ">�绪���֡���������������ݵ�ʮ���ɱ��</div>-->
	</div>
	<div id="vedioImg1" style="position:absolute; left:0px; top:285px; width:275px; height:275px;">
		<img id="pic1" src="img/poster02.jpg" width="265" height="180" style="position:absolute; left:5px; top:5px;"/>
		<div id="picName1" style="position:absolute; left:5px; top:200px; width:265px; height:60px; line-height:30px; font-size:24px; ">�绪���֡���������������ݵ�ʮ���ɱ��</div>
	</div>

<div id="vedioImg2" style="position:absolute; left:285px; top:285px; width:275px; height:275px;">
	<img id="pic2" src="img/poster03.jpg" width="265" height="180" style="position:absolute; left:5px; top:5px;"/>
	<div id="picName2" style="position:absolute; left:5px; top:200px; width:265px; height:60px; line-height:30px; font-size:24px; ">���ݣ�Ǯ�������֡��������֡��칫¥</div>
</div>

<!--�б�-->
<div style="position:absolute; left:579px; top:0px; width:575px; height:560px; ">
<!--focus-->
<div id="listFocus" style="position: absolute; left: 1px; top: 30px; width: 530px; height: 50px; background:#ffa000; visibility:hidden;"></div>

<div style="position: absolute; left: 3px; top: 30px; width: 530px; height: 500px;">
    <table width="530" height="500" border="0" cellspacing="0" cellpadding="0" style="font-size:24px; color:#000000;">
      <tr>
        <td width="15" height="50"></td>
        <td width="40"><img id="playIcon0" src="img/play02.png" width="25" height="26" /></td>
        <td id="titleName0">1100���ž�սʿ���Խ��</td>
      </tr>
      <tr>
        <td height="50"></td>
        <td><img id="playIcon1" src="img/play01.png" width="25" height="26" /></td>
        <td id="titleName1">1100���ž�սʿ���Խ��</td>
      </tr>
      <tr>
        <td height="50"></td>
        <td><img id="playIcon2" src="img/play01.png" width="25" height="26" /></td>
        <td id="titleName2">1100���ž�սʿ���Խ��</td>
      </tr>
      <tr>
        <td height="50"></td>
        <td><img id="playIcon3" src="img/play01.png" width="25" height="26" /></td>
        <td id="titleName3">1100���ž�սʿ���Խ��</td>
      </tr>
      <tr>
        <td height="50"></td>
        <td><img id="playIcon4" src="img/play01.png" width="25" height="26" /></td>
        <td id="titleName4">1100���ž�սʿ���Խ��</td>
      </tr>
      <tr>
        <td height="50"></td>
        <td><img id="playIcon5" src="img/play01.png" width="25" height="26" /></td>
        <td id="titleName5">1100���ž�սʿ���Խ��</td>
      </tr>
      <tr>
        <td height="50"></td>
       <td><img id="playIcon6" src="img/play01.png" width="25" height="26" /></td>
        <td id="titleName6">1100���ž�սʿ���Խ��</td>
      </tr>
      <tr>
        <td height="50"></td>
        <td><img id="playIcon7" src="img/play01.png" width="25" height="26" /></td>
        <td id="titleName7">1100���ž�սʿ���Խ��</td>
      </tr>
      <tr>
        <td height="50"></td>
        <td><img id="playIcon8" src="img/play01.png" width="25" height="26" /></td>
        <td id="titleName8">1100���ž�սʿ���Խ��</td>
      </tr>
      <tr>
        <td height="50"></td>
        <td><img id="playIcon9" src="img/play01.png" width="25" height="26" /></td>
        <td id="titleName9">1100���ž�սʿ���Խ��</td>
      </tr>
	</table>
</div>
<!--��ͷ-->
<img src="img/arrow_up.png" width="20" height="12" style="position:absolute; left:230px; top:9px;" />
<img src="img/arrow_down.png" width="20" height="12" style="position:absolute; left:230px; top:540px;" />


<!--������-->
<div style="position:absolute; left:550px; top:30px; width:4px; height:410px; background:#b28a82; ">
<div id="scrollBar" style="position:absolute; left:-13px; top:0px; width:30px; height:70px; background:#877570; font-size:22px; color:#ffffff; text-align:center; vertical-align:middle; padding-top:5px;">0<br />
	/<br />0</div>
</div>

<!--�ص�����-->
<div id="goTopBtn" style="position:absolute; left:537px; top:445px; width:30px; height:80px; background:url(img/goToTop01.png) no-repeat; "></div>

</div>
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
