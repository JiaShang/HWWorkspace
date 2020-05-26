<%@ page language="java" pageEncoding="GBK"%>
<%@ include file = "datajspHD/newYear_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>中西合璧看好戏</title>
<script type="text/javascript" src="js/showList.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/global.js"></script>
<script type="text/javascript">
iPanel.eventFrame.initPage(window);
E.is_HD_vod = true;
var focusArea = 0;
var listPos = 0;
var vodId = 0;
var listBox = null;
var btnPos = 0;
function eventHandler(eventObj,type){
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
	//initDatas();
	initList();
}

function initDatas() {
	//listBox = vodList;
	
}

function udMove(__num){
	switch(focusArea){
		case 0:
			if(__num>0&&listBox.position<5){
				loseListFocus();
				listBox.position+=1;	
				getListFocus();	
				if(listBox.position==5){
					focusArea=1;
					loseListFocus();
					$('btn'+btnPos).src = 'image/love214/footbtn1_0'+(btnPos+1)+'.png';
				}
			}else{
				if(listBox.position==0) return;
				loseListFocus();
				listBox.position-=1;	
				getListFocus();	
			}
			
		case 1:
			if(__num<0&&listBox.position==5){
			    focusArea=0;
				$('btn'+btnPos).src = 'image/love214/footbtn0_0'+(btnPos+1)+'.png';
				listBox.position-=1;	
				getListFocus();	
			}else{
			    return;
			}
			break;	
	}		
}

//左右移动焦点
function lrMove(__num){
	switch(focusArea){
		case 0:
		case 1:
			$('btn'+btnPos).src = 'image/love214/footbtn0_0'+(btnPos+1)+'.png';
				btnPos += __num;
				if (btnPos > 1) {
					btnPos = 1;
				}else if (btnPos < 0) {
					btnPos = 0;
				}
				$('btn'+btnPos).src = 'image/love214/footbtn1_0'+(btnPos+1)+'.png';
			break;	
	   
	}	
}

//10000100000000090000000000107100
function initList() {
	listBox = new showList(5,vodList.length,listPos, 106, window);
	listBox.listHigh = 50;
	listBox.showType  = 0;
	listBox.haveData = function(List){
	
		$("ListFocus"+List.idPos).innerText = iPanel.misc.interceptString(listData[List.dataPos].name,24);	
	};
	listBox.notData = function(List){
		$("ListFocus"+List.idPos).innerText = "";
	};
	listBox.startShow();
	getListFocus();
}

function getListFocus(){
	$("ListFocus"+ listBox.position).style.color = "#f53a33";	
}

function loseListFocus(){
	$("ListFocus"+ listBox.position).style.color = "#f7e4b8";	
}

function doSelect(){
	if (focusArea == 0) {
		vodId = vodList[listBox.position].vodId;
		play_movie(vodList[listBox.position].playType);
	}else if (focusArea == 1) {
		if (btnPos == 0) {
			doMenu();
		}else {
			doBack();
		}
	}
}
		
function doMenu(){
	 //支持应用在andriod盒子返回首页
    if(iPanel.eventFrame.systemId == 1){
        iPanel.eventFrame.exitToHomePage();
    }else{
        //原代码返回首页
        iPanel.mainFrame.location.href = iPanel.eventFrame.portal_url;
    }
}

function doBack(){
	window.location.href ="<%=turnPage.go(-1)%>";
}

function focusURL(){
	var baseurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + listPos +"&url=";
	return baseurl;
}

function play_movie(playType){
　　if(playType == 1){
　　	// TV Series
　　	window.location.href = focusURL()+"hddb/western/eu_tvDetail.jsp?vodId="+vodId+"&typeId="+typeId;
　　}else{
　　	// movie
　　	getAuthUrl(vodId);
　　}
}

function tip_fromBookmarkPlay(){
	var tempTime = domark(vodId);
	var baseurl = focusURL();
	$("data_ifm").src =  baseurl+"/EPG/jsp/defaultHD/en/Authorization.jsp?typeId="+typeId + "&playType=1" 
	+"&progId="+vodId + "&contentType=0&startTime="+tempTime+ "&business=1";
}
		
function tip_fromBeginPlay(){
	var baseurl = focusURL();
	$("data_ifm").src = baseurl+"/EPG/jsp/defaultHD/en/Authorization.jsp?typeId="+typeId + "&playType=1" 
	+"&progId="+vodId +"&contentType=0&business=1";
}
</script>




<body background="image/love214/20161229-zxhb-bg.jpg" topmargin="0" leftmargin="0" onLoad="init()">
	<div  id="ListFocus0" style=" position:absolute;left:1005px;top:34px; width:245px;font-size:21px; color:#f7e4b8; line-height:32px;">
    	《长城》预告片    </div>
	<div id="ListFocus1" style=" position:absolute;left:1005px;top:74px; width:245px; font-size:21px; color:#f7e4b8; line-height:32px;">
		《福尔摩斯基本演绎法》    </div>
	<div id="ListFocus2" style=" position:absolute;left:1005px;top:114px; width:245px; font-size:21px; color:#f7e4b8; line-height:32px;">
		《木乃伊3：龙帝之墓》
    </div>
	<div id="ListFocus3" style=" position:absolute;left:1005px;top:154px; width:245px; font-size:21px; color:#f7e4b8; line-height:32px;">
		《功夫之王》
    </div>
	<div id="ListFocus4" style=" position:absolute;left:1005px;top:194px; width:245px; font-size:21px; color:#f7e4b8; line-height:32px;">
		《功夫梦》
    </div>
	<div style="position:absolute;left:1018px;top:632px; width:230px; height:53px;">
		<img src="image/love214/footicon.png" width="63" height="53" style="position:absolute;left:0px;top:0px;">
		<img src="image/love214/footbtn0_01.png" width="90" height="42" style="position:absolute;left:61px;top:8px;" id="btn0">
		<img src="image/love214/footbtn0_02.png" width="90" height="42" style="position:absolute;left:133px;top:8px;" id="btn1">
	</div>

</body>
<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="high_tips.jsp"></jsp:include> 
</html>
