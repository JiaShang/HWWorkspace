<%@ page language="java" import="java.util.*" pageEncoding="GBK"%>
<%@ include file="datajspHD/iCatch_yulq_data.jsp"%>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<title>�ޱ����ĵ�</title>
<link href="iCatch_image/main.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
<!--
iPanel.eventFrame.initPage(window);
var focusArea = parseInt(areaArry);	//������������0�ڸ��ఴť�ϣ�1������ͼƬ���ϣ�2�ھ�����Ŀ�ϣ�3���б��ϣ�4�ڷ�ҳ�ϣ�5�����水ť��
var picData = [
	{name : "����",img : "iCatch_image/SmallPic_img0.gif",url : ""},
	{name : "����ʱװ��",img : "iCatch_image/SmallPic_img1.gif",url : ""},
	{name : "����ʱװ��",img : "iCatch_image/SmallPic_img2.gif",url : ""},
	{name : "����ʱװ��",img : "iCatch_image/SmallPic_img0.gif",url : ""},
	{name : "����ʱװ��22",img : "iCatch_image/SmallPic_img2.gif",url : ""}
];	//������Ŀ����
var picObj = null;
var picFocusPos = 0;
var columnData = [
	{name : "ͷ������",img : "iCatch_image/programa_L1.gif",url : ""},
	{name : "�����ͻ�ͷ",img : "iCatch_image/programa_L2.gif",url : ""},
	{name : "���մ����",img : "iCatch_image/programa_L3.gif",url : ""},
	{name : "������û",img : "iCatch_image/programa_L4.gif",url : ""}
];	//������Ŀ����
var columnObj = null;
var columnFocusPos = 0;
var listData = [
	{name : "��ţ�ĸ翪��ţ�ĸ翪\"ȳ������\"",type : "ͷ��",url : ""},
	{name : "��Ц������屬Ц�������㲥���",type : "�ȵ�",url : ""},
	{name : "��ţ�ĸ翪��ţ�ĸ翪\"ȳ������\"",type : "��Ц",url : ""},
	{name : "�������˳��������˳�����������",type : "ʱ��",url : ""},
	{name : "��ţ�ĸ翪��ţ�ĸ翪\"ȳ������\"",type : "ѡ��",url : ""}
];	//�б�����
var listObj = null;
var listFocusPos = 0;
var pageFocusPos = 0;	//��ҳ����λ�ã�0����һҳ�ϣ�1����һҳ��
var buttonImg = [
	{focusImg : "iCatch_image/footbtn1_01.png",lostFocusImg : "iCatch_image/footbtn0_01.png"},
	{focusImg : "iCatch_image/footbtn1_02.png",lostFocusImg : "iCatch_image/footbtn0_02.png"}
];	//��ť����ͼƬ����
var buttonFocusPos = 0;	//���水ť����λ�ã�0����ҳ�ϣ�1�ڷ�����
var marqueeText = "�������� ���������ƿ� �������ʽ�Ŀ��Ӱ�Ӵ�Ƭ���������㲥������72Сʱ�Ŀɻؿ�   �����㲥";	//���������
var parames = location.search;
var indexMainFocusPos  = 1;
var indexFocusPos = 0;
var moreUrl = "";	//��������ӵ�ַ
var currfocusPos = 0;

var typeurl ="";//���潹�����
var currVodId = "";
iPanel.eventFrame.showType = 4;

function eventHandler(eventObj,type) {
	if(type == 1 && key_flag == 1){//����ʾ�򵯳���
		return tipkeypress(eventObj.code);
	}else{
		switch (eventObj.code) {
			case "KEY_UP":
				udMove(-1);
				break;
			case "KEY_DOWN":
				udMove(1);
				break;
			case "KEY_LEFT":
				lrMove(-1);
				break;
			case "KEY_RIGHT":
				lrMove(1);
				break;
			case "KEY_CHANNEL_UP":
			case "KEY_PAGE_UP":
				if(focusArea == 3 || focusArea == 4){
					do_page_up(1);
				}
				break;
			case "KEY_CHANNEL_DOWN":
			case "KEY_PAGE_DOWN":
				if(focusArea == 3 || focusArea == 4){
					do_page_down(1);
				}
				break;
			case "KEY_SELECT":
				doSelect();
				break;
			case "KEY_BACK":
				doBack();
				break;
			case "KEY_MENU":
			case "KEY_EXIT":
				doMenu();
				break;
		}
		
		return 0;
	}
}

function init() {
	if(focusArea == 1){
		picFocusPos = currPos;
	}else if(focusArea == 2){
		columnFocusPos = currPos;
	}
	initColumn();
	initPage();
	initPicList();
	showMarquee();
	
	if (focusArea == 0) {
		$("more").style.backgroundImage = "url(iCatch_image/btn_enterHD1.png)";
	}
	changePage(0);
	setColumnFocus();
}

//��ʼ��ͼƬ�б�
function initPicList() {
	picObj = new E.showList(5,5,0,61,window);
	picObj.listHigh = 231;
	picObj.listSign = 1;
	picObj.focusDiv = "picFocus";
	picObj.haveData = setPic;
	picObj.notData = clearPic;
	picObj.startShow();

	showImgList();
	
	if (focusArea == 1) {
		picObj.changeList(picFocusPos);
		setPicListStyle(true);
		setTimeout('$("picFocus").style.visibility = "visible";',10);
	}
}

//����ͼƬ�б�
function setPic(list) {
	
}

function showImgList(){//����5���Ƽ����ݸ�ֵ
	for(var i = 0;i <typeImgArray.length;i++){
		$("tjTypeImg"+i).src = typeImgArray[i].typepicpath;
		$("tjTypeName"+i).innerText = iPanel.misc.interceptString(typeImgArray[i].typeName,17);
	}	
	
	for(var i = 0;i <vodImgArray.length;i++){
		$("tjImg"+i).src = vodImgArray[i].picPath;
		$("tjName"+i).innerText = iPanel.misc.interceptString(vodImgArray[i].blockName,17);
	}	
}

function clearPic(list) {
	var idPos = list.idPos;
	
	$("picbg" + idPos).style.backgroundImage = "url(iCatch_image/global_tm.gif)";
	$("pic" + idPos).src = "iCatch_image/global_tm.gif";
	$("picname" + idPos).innerText = "";
}

//����ͼƬ�б���ʽ
function setPicListStyle(flag) {
	if(picObj.position >= 0 && picObj.position <= 2){
		var name = typeImgArray[picObj.position].typeName;
		var tempName = iPanel.misc.interceptString(name,17);
		if(name != tempName){
			if (flag) {
				$("tjTypeName"+picObj.position).innerHTML = "<marquee style=\"width:219px;height:34px;\">" + typeImgArray[picObj.position].typeName + "</marquee>";
			}else{
				$("tjTypeName"+picObj.position).innerText = tempName;
			}
		}
		
	}else{
		var name = vodImgArray[picObj.position-3].blockName;
		var tempName = iPanel.misc.interceptString(name,17);
		if(name != tempName){
			var pos = picObj.position-3;
			if (flag) {
				$("tjName"+ pos).innerHTML = "<marquee style=\"width:219px;height:36px;\">" + vodImgArray[pos].blockName + "</marquee>";
			}else{
				$("tjName"+pos).innerText = tempName;	
			}
		}
	}	
}

//��ʼ����Ŀ
function initColumn() {
	columnObj = new E.showList(4,jcImgArray.length,0,322,window);
	columnObj.showType = 0;
	columnObj.haveData = setColumn;
	columnObj.notData = clearColumn;
	columnObj.startShow();
	
	if (focusArea == 2) {
		columnObj.changeList(columnFocusPos);
		setTimeout("$('columnFocus').style.visibility = 'visible';",10);
	}else{
		if(columnObj.position == 0 || columnObj.position == 2){
			columnObj.changeList(1);
		}	
	}
}

//������Ŀ����
function setColumn(list) {
	$("column" + list.idPos).src = jcImgArray[list.dataPos].typepicpath; //��ʱ��д��������̬��ȡ	
}

//�����Ŀ����
function clearColumn(list) {
	$("column" + list.idPos).src = "iCatch_image/global_tm.gif";
}

//��ʼ���б�
function initPage() {
	var curr_pos = (pageNo % block) * pageLength + res_index;
	listObj = new E.showList(5,dataList.length,curr_pos,303,window);
	listObj.listHigh = 49;
	listObj.focusDiv = "listFocus";
	listObj.showType = 0;
	listObj.haveData = setList;
	listObj.notData = clearList;
	listObj.startShow();
	
	if (focusArea == 3) {
		res_index = listObj.focusPos;
		setListStyle(true);
		setTimeout("$(listObj.focusDiv).style.visibility = 'visible';",10);
	}
	$("page").innerText = (pageNo + 1)+"/"+pageTotal;
}

//�����б�����
function setList(list) {
	var idPos = list.idPos;
	var tempList = dataList[list.dataPos];
	
	$("listbg" + idPos).style.backgroundImage = "url(iCatch_image/btm1_0.png)";
	//$("type" + idPos).style.backgroundImage = "url(iCatch_image/icon_mark0"+idPos+".png)";
	$("type" + idPos).innerText = tempList.type;
	$("list" + idPos).innerText = iPanel.misc.interceptString(tempList.name,28);
	$("arrow" + idPos).src = "iCatch_image/arrow0_0.png";
}

//����б�����
function clearList(list) {
	var idPos = list.idPos;
	
	$("listbg" + idPos).style.backgroundImage = "url(iCatch_image/global_tm.gif)";
	$("type" + idPos).style.backgroundImage = "url(iCatch_image/global_tm.gif)";
	$("type" + idPos).innerText = "";
	$("list" + idPos).innerText = "";
	$("arrow" + idPos).src = "iCatch_image/global_tm.gif";
}

//�����б���ʽ
function setListStyle(flag) {
	var tempList = dataList[listObj.position];
	var name = tempList.name;
	var tempName = iPanel.misc.interceptString(name,28);

	$("listfocustype").innerText = tempList.type;
	if(listObj.focusPos >= 0 && listObj.focusPos <=2){
		$("listfocustype").style.backgroundImage = "url(iCatch_image/icon_mark02.png)";
	}else{
		$("listfocustype").style.backgroundImage = "url()";
	}
	
	
	if (name != tempName) {
		$("listfocuslist").innerHTML = "<marquee style=\"width:412px;height:47px;\">" + name + "</marquee>";
	}
	else {
		$("listfocuslist").innerText = tempName;
	}
}

//��ʾ���������
function showMarquee() {
	$("marquee").innerText = E.marqueeText;
}

//�����ƶ�����
function udMove(num) {
	switch (focusArea) {
		case 0:	//�����ڸ�������
			if (num > 0) {
				$("more").style.backgroundImage = "url(iCatch_image/btn_enterHD0.png)";
				setPicListStyle(true);
				$("picFocus").style.visibility = "visible";
				focusArea = 1;
			}
			break;
		case 1:	//������ͼƬ�б���
			$("picFocus").style.visibility = "hidden";
			setPicListStyle(false);
			
			if (num > 0) {
				//columnObj.changeList(-1 * columnObj.focusPos);
				//$("columnFocus").style.visibility = "visible";
				//focusArea = 2;
				$("picFocus").style.visibility = "hidden";
				setListStyle(true);
				focusArea = 3;
				$(listObj.focusDiv).style.visibility = "visible";
			}
			else {
				$("more").style.backgroundImage = "url(iCatch_image/btn_enterHD1.png)";
				focusArea = 0;
			}
			break;
		case 2:	//��������Ŀ��
			if(columnObj.position == 0 || columnObj.position == 1){
				if(num > 0){
					columnObj.changeList(2);
				}else{
					$("columnFocus").style.visibility = "hidden";
					setPicListStyle(true);
					$("picFocus").style.visibility = "visible";
					focusArea = 1;
					if(columnObj.position == 0){
						columnObj.changeList(1);
					}
				}
			}else if(columnObj.position == 2 || columnObj.position == 3){
				if( num < 0){
					columnObj.changeList(-2);
				}else{
					$("columnFocus").style.visibility = "hidden";
					$("button" + buttonFocusPos).src = buttonImg[buttonFocusPos].focusImg;
					focusArea = 5;
				}
			}
			setColumnFocus();
			break;
		case 3:	//�������б���
			if (listObj.focusPos == 0 && num < 0) {
				$(listObj.focusDiv).style.visibility = "hidden";
				setListStyle(false);
				setPicListStyle(true);
				$("picFocus").style.visibility = "visible";
				focusArea = 1;
			}
			else if (((listObj.focusPos == listObj.listSize - 1) || (listObj.position == listObj.dataSize - 1)) && num > 0) {
				$(listObj.focusDiv).style.visibility = "hidden";
				setListStyle(false);
				setPageStyle(true);
				focusArea = 4;
			}
			else {
				setListStyle(false);
				listObj.changeList(num);
				res_index = listObj.focusPos;
				setListStyle(true);
			}
			break;
		case 4:	//�����ڷ�ҳ��
			setPageStyle(false);
			
			if (num > 0) {
				$("button" + buttonFocusPos).src = buttonImg[buttonFocusPos].focusImg;
				focusArea = 5;
			}
			else {
				setListStyle(true);
				focusArea = 3;
				$(listObj.focusDiv).style.visibility = "visible";
			}
			break;
		case 5:	//�����ڵײ���ť��
			if (num < 0) {
				$("button" + buttonFocusPos).src = buttonImg[buttonFocusPos].lostFocusImg;
				//$("columnFocus").style.webkitTransitionDuration = "0ms";
				columnObj.changeList(columnObj.listSize - columnObj.focusPos - 1);
				$("columnFocus").style.visibility = "visible";
				//$("columnFocus").style.webkitTransitionDuration = "100ms";
				focusArea = 2;
			}
			break;
	}
}

//�����ƶ�����
function lrMove(num) {
	switch (focusArea) {
		case 1:	//������ͼƬ�б���
			setPicListStyle(false);
			picObj.changeList(num);
			setPicListStyle(true);
			break;
		case 2:	//��������Ŀ��
			if(columnObj.position == 0 || columnObj.position == 2){
				if(num > 0){
					columnObj.changeList(1);
				}
			}else if(columnObj.position == 1 || columnObj.position == 3){
				if(num > 0){
					$("columnFocus").style.visibility = "hidden";
					setListStyle(true);
					focusArea = 3;
					$(listObj.focusDiv).style.visibility = "visible";
				}else{
					columnObj.changeList(-1);
				}
			}
			setColumnFocus();
			break;
		case 3:	//�������б���
			if (num < 0) {
				$(listObj.focusDiv).style.visibility = "hidden";
				setListStyle(false);
				$("columnFocus").style.visibility = "visible";
				focusArea = 2;
				setColumnFocus();
			}
			break;
		case 4:	//�����ڷ�ҳ��
			setPageStyle(false);
			
			if (pageFocusPos == 0 && num < 0) {
				$("columnFocus").style.visibility = "visible";
				focusArea = 2;
			}
			else {
				pageFocusPos += num;
				
				if (pageFocusPos > 1) {
					pageFocusPos = 1;
				}
				else if (pageFocusPos < 0) {
					pageFocusPos = 0;
				}
				setPageStyle(true);
			}
			break;
		case 5:	//�����ڵײ���ť��
			$("button" + buttonFocusPos).src = buttonImg[buttonFocusPos].lostFocusImg;
			buttonFocusPos += num;
			
			if (buttonFocusPos > 1) {
				buttonFocusPos = 1;
			}
			else if (buttonFocusPos < 0) {
				buttonFocusPos = 0;
			}
			$("button" + buttonFocusPos).src = buttonImg[buttonFocusPos].focusImg;
			break;
	}
}

function setColumnFocus(){
	var columnLeft = [79,252];
	var lolumnTop = [318,444];
	if(columnObj.position == 0 || columnObj.position == 1){
		$("columnFocus").style.top = lolumnTop[0]+"px";
		$("columnFocus").style.left = columnLeft[columnObj.position]+"px";
	}else{
		$("columnFocus").style.top = lolumnTop[1]+"px";
		$("columnFocus").style.left = columnLeft[columnObj.position-2]+"px";	
	}	
}

//���÷�ҳ��ʽ
function setPageStyle(flag) {
	$("pageButton" + pageFocusPos).style.backgroundImage = flag ? "url(iCatch_image/page_focus.png)" : "url(iCatch_image/global_tm.gif)";
	$("pageButton" + pageFocusPos).style.color = flag ? "#ffffff" : "#000000";
}

function doSelect() {
	if(focusArea == 1){
		currfocusPos =picObj.position;
	}else if(focusArea == 2){
		currfocusPos =columnObj.position;
	}
	typeurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + res_index + "," + pageNo+ "," + currfocusPos+"&url=";
	switch (focusArea) {
		case 0:	//�����ڸ�������
			var returnUrl = encodeURI("ui://portal.htm?"+iPanel.eventFrame.portal_url);
		
		var net_type = "";
		if(typeof(E.netType) == "undefined"){
			net_type = "Cable;IP";
		}else{
			net_type = E.netType;
		}
		
		var curr_url = "http://epgServer/defaultHD/en/Category.jsp?url=http://chongqing.wasu.cn/yigou_chongqing/jump_chongqing.jsp?code=amu&viewSize=SD";

		if(curr_url.indexOf("http://epgServer") > -1){
			curr_url=curr_url.replace("http://epgServer",iPanel.eventFrame.pre_epg_url);
		}
		
		curr_url = "ui://portal1.htm?" + curr_url;
		
		if(curr_url.indexOf("viewSize=SD") == -1) E.is_HD_vod = true;//cdq �������Ӧ������Ϊtrue
		else E.is_HD_vod = false;

		curr_url+="&stbid="+hardware.STB.serialNumber+"&preplayurl="+E.prePlayUrl+"&return_url="+returnUrl;//cdq ��Ϊ��VOD��Ҫ�����Щ����
		iPanel.debug("zenglt curr_url22222="+curr_url);
		
		var auth_str = "User=&pwd=&ip="+network.ethernets[0].IPs[0].address+"&NTID="+network.ethernets[0].MACAddress+"&CARDID="+E.cardId+"&Version=1.0&lang=1&supportnet="+net_type+"&decodemode=H.264HD;MPEG-2HD&CA=1&ServiceGroupID="+E.ServiceGroupID+"&encrypt=0";
		
	    curr_url = curr_url.replace("Category.jsp?url=", "Category.jsp?"+auth_str+"&viewSize=SD&url=");
		
		iPanel.mainFrame.location.href = curr_url;			
			break;
		case 1:	//������ͼƬ�б���
			if(picObj.position >= 0 && picObj.position <=2){
				if(typeImgArray[picObj.position].typeName =="�ٱ��������䴮��"){
					window.location.href = typeurl+"bbwujdsc.jsp?typeId=" + typeImgArray[picObj.position].typeId+ "&pageSize=30&startIndex=0";
				}else if(typeImgArray[picObj.position].typeName =="�й���ģ"){
					window.location.href = typeurl+"20150609superModelIndex.jsp?typeId=10000100000000090000000000105206&pageSize=30&startIndex=0";
				}else if(typeImgArray[picObj.position].typeName =="�ռ�����ս"){
					window.location.href = typeurl+"zjgwz.jsp?typeId=" + typeImgArray[picObj.position].typeId+ "&pageSize=30&startIndex=0";
				}else if(typeImgArray[picObj.position].typeName =="�ټ�������"){
					window.location.href = typeurl+"iCatch_yulq_list.jsp?typeId=" + typeImgArray[picObj.position].typeId+ "&pageLength=8";
				}else if(typeImgArray[picObj.position].typeName =="�漣�ι���"){
					window.location.href = typeurl+"qj2.jsp?typeId=" + typeImgArray[picObj.position].typeId+ "&pageLength=8";
				}else if(typeImgArray[picObj.position].typeName =="Ц������"){
					window.location.href = typeurl+"xlzb.jsp?typeId=" + typeImgArray[picObj.position].typeId+ "&pageLength=8";
				}else if(typeImgArray[picObj.position].typeName =="��������Ʊ�����"){
					window.location.href = typeurl+"http://192.168.48.217:8085/iptv/entrance.jsp?gpid=118";
				}else if(typeImgArray[picObj.position].typeName =="����Ӣ�ݳ���Ʊ�����"){
					window.location.href = typeurl+"http://192.168.48.217:8085/iptv/entrance.jsp?gpid=142";
				}else if(typeImgArray[picObj.position].typeName =="�潭���ֽ�"){
					window.location.href = typeurl+"http://192.168.48.217:8085/iptv/entrance.jsp?gpid=135";
				}else if(typeImgArray[picObj.position].typeName =="ȼ�հ�����"){
					window.location.href = typeurl+"http://192.168.48.217:8085/iptv/entrance.jsp?gpid=111";
				}else if(typeImgArray[picObj.position].typeName =="���������˷���"){
					window.location.href = typeurl+"http://192.168.48.217:8082/epghd/1.html?pid=19";
				}else if(typeImgArray[picObj.position].typeName =="���������ݳ�����Ʊ"){
					window.location.href = typeurl+"http://192.168.48.217:8082/epghd/1.html?pid=17";
				}else if(typeImgArray[picObj.position].typeName =="�й����������ļ�"){
					window.location.href = typeurl+"/EPG/jsp/neirong/S20150723.jsp";
				}else if(typeImgArray[picObj.position].typeName =="��ǿ����ȫ��¼"){
					window.location.href = typeurl+"/EPG/jsp/neirong/S20150611.jsp";
				}else if(typeImgArray[picObj.position].typeName =="���������ݳ�����Ʊ"){
					window.location.href = typeurl+"http://192.168.48.217:8082/epghd/1.html?pid=16";
				}else if(typeImgArray[picObj.position].typeName =="�������������ݳ�����Ʊ"){
					window.location.href = typeurl+"http://192.168.48.217:8082/epghd/1.html?pid=12";
				}else if(typeImgArray[picObj.position].typeName =="���Ǹ��ֵ��ļ�"){
					window.location.href = typeurl+"/EPG/jsp/neirong/S20160116.jsp";
				}else{
					window.location.href = typeurl+"iCatch_yulq_list.jsp?typeId=" + typeImgArray[picObj.position].typeId+ "&pageLength=8";
				}
			}else if(picObj.position == 3){
				currVodId = vodImgArray[0].vodId;
				getAuthUrl(vodImgArray[0].vodId);	
			}else{
				currVodId = vodImgArray[1].vodId;
				getAuthUrl(vodImgArray[1].vodId);
			}
			break;
		case 2:	//��������Ŀ��
			if(jcImgArray[columnObj.position].typeName =="ȼ�հ�����"){
				window.location.href = typeurl + "http://192.168.48.217:8085/iptv/entrance.jsp?gpid=111";
			} else {
				window.location.href = typeurl + "iCatch_yulq_list.jsp?typeId=" + jcImgArray[columnObj.position].typeId+ "&pageLength=8";
			}
			break;
		case 3:	//�������б���
			if (listObj.dataSize > 0) {
				currVodId = dataList[listObj.position].vodId;
				getAuthUrl(dataList[listObj.position].vodId);
			}
			break;
		case 4:	//�����ڷ�ҳ��
			if(pageFocusPos == 0){
				if(focusArea == 3 || focusArea == 4){
					do_page_up(1);
				}
			}else{
				if(focusArea == 3 || focusArea == 4){
					do_page_down(1);
				}
			}
			res_index = listObj.focusPos;s
			break;
		case 5:	//�����ڵײ���ť��
			if (buttonFocusPos == 0) {
				doMenu();
			}
			else {
				doBack();
			}
			break;
	}
}

/* tipsWindow.jsp��getAuthUrl()�������ã��ӿ�ʼ������ */
function tip_fromBeginPlay(){
	typeurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + res_index + "," + pageNo+ "," + currfocusPos+"&url=";
	var url =typeurl+"/EPG/jsp/defaultHD/en/Authorization.jsp?typeId="+typeId + "&playType=1" 
						+"&progId="+currVodId +"&contentType=0&business=1";
	$("data_ifm").src = url;
}

/**����ǩ������ */
function tip_fromBookmarkPlay(){
	typeurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + res_index + "," + pageNo+ "," + currfocusPos+"&url=";
	var tempTime = domark(dataList[listObj.position].vodId);
	var url =typeurl+"/EPG/jsp/defaultHD/en/Authorization.jsp?typeId="+typeId + "&playType=1" 
						+"&progId="+currVodId + "&contentType=0&startTime="+tempTime+ "&business=1";
	$("data_ifm").src = url;
}

function do_page_up(__type){
	if(pageNo <= 0) return 0;
	if(pageNo % block != 0){
		pageNo--;
		changePage(-1);
		res_index = listObj.focusPos;
	}
	else{
		res_index = (pageLength - 1);//���Ϸ�ҳ��������ʱ�������õ���ǰҳ�����һ��
		data_ifm(pageNo - 1);
	}
}

function do_page_down(__type){
	if(pageNo >= pageTotal - 1) return 0;
	if(pageNo % block != (block-1)){
		pageNo++;
		changePage(1);
		res_index = listObj.focusPos;
	}
	else{
		res_index = 0;//���·�ҳ��������ʱ�������õ���ǰҳ�ĵ�һ��
		data_ifm(pageNo + 1);
	}
}

function changePage(__num){
	listObj.changePage(__num);
	$("page").innerText = (pageNo + 1)+"/"+pageTotal;
	setListStyle(true);
}

/**IFRAME�������� */
function data_ifm(tempPage){
	$("data_ifm").src = "/EPG/jsp/defaultHD/en/datajspHD/iCatch_vod_back_data.jsp?typeId="+typeId+"&pageNo="+tempPage+"&block=6"+"&showLength=5";
}

//����ҳ
function doMenu() {
	iPanel.mainFrame.location.href = iPanel.eventFrame.portalUrl;
}

//����
function doBack() {
	window.location.href = "<%=turnPage.go(-1)%>";
}
//-->
</script>
</head>

<body background="iCatch_image/nr_bg0.jpg" leftmargin="0" topmargin="0" onLoad="javascript:init();">

<!--Logo-->
<div style="position:absolute; left:141px; top:56px; width:158px; height:36px;"><img src="iCatch_image/logo_title1.png" width="158" height="36" /></div>
<div style="position:absolute; left:1008px; top:44px; width:210px; height:39px; line-height:39px; font-size:18px; color:#FFFFFF; padding-left:46px; background:url(iCatch_image/btn_enterHD0.png) no-repeat;" id="more">����������Ѷ</div>

<!--Right SmallPic-->
<div style="position: absolute; left: 61px; top: 126px; width: 231px; background:url(iCatch_image/focus02.png) center no-repeat; height: 159px; visibility:hidden;-webkit-transition-duration:100ms;" id="picFocus"></div>

<div style="position:absolute; left:61px; top:129px; width:231px; height:159px; background:url() no-repeat;" id="picbg0">
  <div style="position:absolute; left:7px; top:5px; width:219px; height:148px;"><img src="" width="219" height="148" id="tjTypeImg0" /></div>
  <div class="SmallPic_shade" id="tjTypeName0"></div>
</div>
<div style="position:absolute; left:292px; top:129px; width:231px; height:159px; background:url() no-repeat;" id="picbg1">
  <div style="position:absolute; left:7px; top:5px; width:219px; height:148px;"><img src="" width="219" height="148" id="tjTypeImg1" /></div>
  <div class="SmallPic_shade" id="tjTypeName1"></div>
</div>
<div style="position:absolute; left:523px; top:129px; width:231px; height:159px; background:url() no-repeat;" id="picbg2">
  <div style="position:absolute; left:7px; top:5px; width:219px; height:148px;"><img src="" width="219" height="148" id="tjTypeImg2" /></div>
  <div class="SmallPic_shade" id="tjTypeName2"></div>
</div>
<div style="position:absolute; left:754px; top:129px; width:231px; height:159px; background:url() no-repeat;" id="picbg3">
  <div style="position:absolute; left:7px; top:5px; width:219px; height:148px;"><img src="" width="219" height="148" id="tjImg0" /></div>
  <div class="SmallPic_shade" id="tjName0"></div>
</div>
<div style="position:absolute; left:985px; top:129px; width:231px; height:159px; background:url() no-repeat;" id="picbg4">
  <div style="position:absolute; left:7px; top:5px; width:219px; height:148px;"><img src="" width="219" height="148" id="tjImg1" /></div>
  <div class="SmallPic_shade" id="tjName1"></div>
</div>

<!--Middle Conntent-->
<!-- 5.7��ǰ
<div style="position: absolute; left: 193px; top: 281px; width: 197px; background:url(iCatch_image/focus03.png) center no-repeat; height: 81px; visibility:hidden;-webkit-transition-duration:100ms;" id="columnFocus"></div>
<div style="position:absolute; left:60px; top:310px; width:108px; height:223px;"><img src="iCatch_image/icon_mark2.png" width="108" height="223" /></div>
<div style="position:absolute; left:200px; top:285px; width:182px; height:288px;">
  <table width="182" height="288" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="182" height="72"><img src="" width="182" height="67" id="column0" /></td>
    </tr>
    <tr>
      <td height="72"><img src="" width="182" height="67" id="column1" /></td>
    </tr>
    <tr>
      <td height="72"><img src="" width="182" height="67" id="column2" /></td>
    </tr>
    <tr>
      <td height="72"><img src="" width="182" height="67" id="column3" /></td>
    </tr>
  </table>
</div>
-->
<div style="position: absolute; left: 252px; top: 318px; width: 183px; height: 139px; visibility: hidden; -webkit-transition-duration:100ms;" id="columnFocus"><img src="iCatch_image/focus03.png" height="152" width="188"></div>

<div style="position:absolute; left:88px; top:330px; width:340px; height:256px;">
<table width="100%" height="100%">
	<tr>
    	<td height="123"><img src="iCatch_image/ylmht.jpg" width="170" height="123" id="column0" /></td>
        <td><img src="iCatch_image/zydzb.jpg" width="170" height="123" id="column1" /></td>
    </tr>
    <tr>
    	<td height="123"><img src="iCatch_image/thrw.jpg" width="170" height="123" id="column2" /></td>
        <td><img src="iCatch_image/ppb.jpg" width="170" height="123" id="column3" /></td>
    </tr>
</table>
</div>


<div style="position:absolute; left:524px; top:303px; line-height:49px; width:632px; height:49px; visibility: hidden; -webkit-transition-duration:100ms; background:url(iCatch_image/btm1_1.png) no-repeat left center;" id="listFocus">
<table width="631" height="49" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="98"  height="49" style="background:url() no-repeat left center; " class="icon_mark3" id="listfocustype"></td>
      <td width="14">&nbsp;</td>
      <td width="459" class="btm1_1txt" id="listfocuslist"></td>
      <td width="60"><img src="iCatch_image/arrow0_1.png" width="15" height="18" /></td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:524px; top:303px; line-height:49px; width:631px; height:49px;" id="listbg0">
  <table width="631" height="49" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="98"  height="49" style="background:url(iCatch_image/icon_mark02.png) no-repeat left center; " class="icon_mark3" id="type0"></td>
      <td width="14">&nbsp;</td>
      <td width="459" class="btm1_0txt" id="list0">&nbsp;</td>
      <td width="60"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="arrow0" /></td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:524px; top:352px; line-height:49px; width:631px; height:49px;" id="listbg1">
  <table width="631" height="49" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="98"  height="49" style="background:url(iCatch_image/icon_mark02.png) no-repeat left center; " class="icon_mark3" id="type1">&nbsp;</td>
      <td width="14">&nbsp;</td>
      <td width="459" class="btm1_0txt" id="list1"></td>
      <td width="60"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="arrow1" /></td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:524px; top:401px; line-height:49px; width:631px; height:49px;" id="listbg2">
  <table width="631" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="98"  height="49" style="background:url(iCatch_image/icon_mark02.png) no-repeat left center; " class="icon_mark3" id="type2">&nbsp;</td>
      <td width="14">&nbsp;</td>
      <td width="459" class="btm1_0txt" id="list2"></td>
      <td width="60"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="arrow2" /></td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:524px; top:450px; line-height:49px; width:631px; height:49px;" id="listbg3">
  <table width="631" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="98"  height="49" style="background:url() no-repeat left center; " class="icon_mark3" id="type3"></td>
      <td width="14">&nbsp;</td>
      <td width="459" class="btm1_0txt" id="list3"></td>
      <td width="60"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="arrow3" /></td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:524px; top:499px; line-height:49px; width:631px; height:49px;" id="listbg4">
  <table width="631" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="98"  height="49" style="background:url() no-repeat left center; " class="icon_mark3" id="type4"></td>
      <td width="14">&nbsp;</td>
      <td width="459" class="btm1_0txt" id="list4"></td>
      <td width="60"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="arrow4" /></td>
    </tr>
  </table>
</div>

<!--Page-->
<div class="pagetxt" style="position:absolute; left:953px; top:553px;" id="page"></div>
<div style="position:absolute; left:1014px; top:553px; width:137px; height:35px; background:url(iCatch_image/page_btm0.png) no-repeat left center;">
  <table width="130" height="35" border="0" align="center" cellpadding="0" cellspacing="0" class="pagetxt1">
    <tr>
      <td width="65" height="35" style="background:url() no-repeat center; color:#000000;" id="pageButton0">��һҳ</td>
      <td width="65" style="background:url() no-repeat center; color:#000000;" id="pageButton1">��һҳ</td>
    </tr>
  </table>
</div>

<!--Bottom-->
<div style="position:absolute; left:60px; top:625px; width:250px; height:45px;">
  <div style="position:absolute; top:1px; left:0px; width:58px; height:44px;"><img src="iCatch_image/footicon.png" width="58" height="44" /></div>
  <div style="position:absolute; top:3px; left:60px; width:90px; height:42px;"><img src="iCatch_image/footbtn0_01.png" width="90" height="42" id="button0" /></div>
  <div style="position:absolute; top:3px; left:133px; width:90px; height:42px;"><img src="iCatch_image/footbtn0_02.png" width="90" height="42" id="button1" /></div>
</div>
<div style="position: absolute; left: 394px; top: 630px; width: 806px; height: 40px; font-size: 18px; color: #fff; line-height: 40px;">
  <marquee id="marquee">
  </marquee>
</div>

<iframe id="data_ifm" width="0px" height="0px" style="display:none;"></iframe>
<jsp:include page="showtip.jsp"></jsp:include>
</body>
</html>
