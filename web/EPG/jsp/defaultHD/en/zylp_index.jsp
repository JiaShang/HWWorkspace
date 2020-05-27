<%@ page contentType="text/html; charset=GBK" language="java"%>
<%@ include file = "datajspHD/zylp_index_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<title>无标题文档</title>
</head>
<script type="text/javascript" src="js/showListCss2dClass.js"></script>
<script>
iPanel.eventFrame.initPage(window);
var healthBox = null;
var lifeBox = null;
var topBox = null;
var areaArray = focusArea;

var healthItem = [
					{name:"瑜伽时间",typeId:"10000100000000090000000000101504",img:"image/zylp/colomn_1.png"},
					{name:"中华太极",typeId:"10000100000000090000000000101501",img:"image/zylp/colomn_3.png"},
					{name:"健身塑形",typeId:"10000100000000090000000000101505",img:"image/zylp/colomn_6.png"},
					{name:"体育运动",typeId:"10000100000000090000000000101508",img:"image/zylp/colomn_2.png"},
					{name:"孕产育儿",typeId:"10000100000000090000000000101511",img:"image/zylp/colomn_9.png"},
					{name:"保健养生",typeId:"10000100000000090000000000101502",img:"image/zylp/colomn_5.png"},
					{name:"武道馆",typeId:"10000100000000090000000000101503",img:"image/zylp/colomn_8.png"},
					{name:"美食&营养",typeId:"10000100000000090000000000101510",img:"image/zylp/colomn_4.png"}
];

var lifeItem = [
				   {name:"美颜坊",typeId:"10000100000000090000000000101509",img:"image/zylp/life_1.png"},
				   {name:"艺术课堂",typeId:"10000100000000090000000000101507",img:"image/zylp/life_4.png"},
				   {name:"逸趣休闲",typeId:"10000100000000090000000000101516",img:"image/zylp/life_2.png"},
			       {name:"巧艺手工",typeId:"10000100000000090000000000101514",img:"image/zylp/life_3.png"},
				   {name:"风尚舞会",typeId:"10000100000000090000000000101506",img:"image/zylp/life_9.png"},
				   {name:"时尚家具",typeId:"10000100000000090000000000101513",img:"image/zylp/life_5.png"},
				   {name:"少儿乐园",typeId:"10000100000000090000000000101512",img:"image/zylp/life_8.png"},
				   {name:"职业培训",typeId:"10000100000000090000000000101515",img:"image/zylp/life_6.png"}	
];

var topItem = [
				   {name:"推荐1",leftImg:"image/zylp/poster_imgl_1.gif",rightImg:"image/zylp/poster_imgr_1.gif",img:"image/zylp/life_1.png",url:"1"},
				   {name:"推荐2",leftImg:"image/zylp/poster_imgl_2.gif",rightImg:"image/zylp/poster_imgr_2.gif",img:"image/zylp/life_2.png",url:"2"},
				   {name:"推荐3",leftImg:"image/zylp/poster_imgl_3.gif",rightImg:"image/zylp/poster_imgr_3.gif",img:"image/zylp/life_3.png",url:"3"}
];

var posterImg = new Array();

var showTopImg = ["image/zylp/life_1.png","image/zylp/life_2.png","image/zylp/life_3.png"];
var marqText ="百科学苑开启时尚健康优生活，完美私教请回家。";
var listData = [];

function eventHandler(eventObj, __type){
	switch(eventObj.code){	
		case "KEY_RIGHT":	
			changeLefeRight(1);
			break;
		case "KEY_LEFT":	
			changeLefeRight(-1);
			break;
		case "KEY_DOWN":
			changeUpDown(1);
			break;
		case "KEY_UP":	
			changeUpDown(-1);
			break;
		case "KEY_NUMERIC":
			var num =eventObj.args.value;
			if(num == 0){
				location.href = "http://192.168.48.217:8082/epghd/1.html";
			}
			break;
		case "KEY_SELECT":
			doSelect();
			break;
		case "KEY_BACK":
			doBack();
			break;
		case "KEY_EXIT":
		case "KEY_MENU":
			location.href = iPanel.eventFrame.portalUrl;
			return 0;	
			break;		
	}
	return 	eventObj.args.type;
}

function init(){
	addImg();
	showHealth();
	showLife();
	showTop();
	setStyle(1);
	$("marquee").innerText =marqText;
}

function addImg(){
	var postInfo = new Object();
	postInfo.playType = "";
	postInfo.typeId = "";
	postInfo.vodId ="";
	postInfo.picPath ="image/zylp/poster.jpg";
	postInfo.vodName ="";
	listData[0] =  postInfo;
	
	listData = listData.concat(vodList);	
}

function showHealth(){
	var pos = 0;
	if(areaArray == 1){
		pos = listFocusPos;
	}
	healthBox = new E.showList(5,healthItem.length,pos,56,window);
	healthBox.listSign = 1;
	healthBox.listHigh = 228;
	healthBox.focusDiv = "heal_focus";
	healthBox.showType = 1;
	healthBox.haveData=function(List){
		$("h_img"+List.idPos).src = healthItem[List.dataPos].img;
	}
	healthBox.notData=function(List){
		$("h_img"+List.idPos).src = "";
	}
	healthBox.startShow();
}

function showLife(){
	var pos = 0;
	if(areaArray == 2){
		pos = listFocusPos;
	}
	lifeBox = new E.showList(6,lifeItem.length,pos,56,window);
	lifeBox.listSign = 1;
	lifeBox.listHigh = 193;
	lifeBox.focusDiv = "life_focus";
	lifeBox.showType = 1;
	lifeBox.haveData=function(List){
		$("l_img"+List.idPos).src = lifeItem[List.dataPos].img;
	}
	lifeBox.notData=function(List){
		$("l_img"+List.idPos).src = "";
	}
	lifeBox.startShow();
}
/*
function showTop(){
	topBox = new E.showList(3,topItem.length,0,56,window);
	topBox.showLoop = true;
	topBox.focusFixed = true;
	topBox.haveData=function(List){
		if(List.idPos == 0){
			$("top"+List.idPos).src = topItem[List.dataPos].leftImg;
		}else if(List.idPos == 1){
			$("top"+List.idPos).src = topItem[List.dataPos].img;
		}else if(List.idPos == 2){
			$("top"+List.idPos).src = topItem[List.dataPos].rightImg;
		}
	}
	topBox.notData=function(List){	
	}
	topBox.startShow();
}*/

function showTop(){
	var adStyleList = [{left:"0px",top:"32px",width:"363px",height:"210px"},
				        {left:"348px",top:"12px",width:"470px",height:"250px"},
				        {left:"775px",top:"32px",width:"363px",height:"210px"},
						{left:"1280px",top:"32px",width:"363px",height:"210px"}];
	adSlipObj = new showListCSS2D(3, 4, 1, 1, "300ms", window);
	adSlipObj.arrTop = adStyleList;
	adSlipObj.startTop = {left:"-521px",top:"32px",width:"363px",height:"210px"};
	adSlipObj.endTop = {left:"1280px",top:"32px",width:"363px",height:"210px"};			
	adSlipObj.arrTopObj = $("mainMenu").getElementsByTagName("div");
	adSlipObj.haveData = function(_list){
		if(_list.idPos != adSlipObj.getFocusPos().idPos){
			$("img"+_list.idPos).src = listData[_list.dataPos].picPath;
			
			//$("img"+_list.idPos).src = topItem[_list.dataPos].img;
			
			$("top"+_list.idPos).style.top = "32px";
			$("top"+_list.idPos).style.width = "363px";
			$("top"+_list.idPos).style.height = "210px";
			$("top"+_list.idPos).style.zIndex = "1";
			$("img"+_list.idPos).style.width = "363px";
			$("img"+_list.idPos).style.height = "210px";
		}else{
			$("img"+_list.idPos).src = listData[_list.dataPos].picPath;
			/*if(_list.idPos == 0){
				$("img"+_list.idPos).src = topItem[_list.dataPos].leftImg;
			}else if(List.idPos == 1){
				$("img"+_list.idPos).src = topItem[_list.dataPos].img;
			}else if(List.idPos == 2){
				$("img"+_list.idPos).src = topItem[_list.dataPos].rightImg;
			}else{
				$("img"+_list.idPos).src = topItem[_list.dataPos].img;
			}*/
			$("top"+_list.idPos).style.top = "12px";
			$("top"+_list.idPos).style.width = "470px";
			$("top"+_list.idPos).style.height = "250px";
			$("top"+_list.idPos).style.zIndex = "3";
			$("img"+_list.idPos).style.width = "470px";
			$("img"+_list.idPos).style.height = "250px";
			
		}
	}
	adSlipObj.noData = function(_list){
		$("img"+_list.idPos).src = " ";
	};
	adSlipObj.startShow();	
}

function changeLefeRight(num){
	setStyle(0);
	if(areaArray == 0){
		adSlipObj.changeList(num);
	}else if(areaArray == 1){
		healthBox.changeList(num);
	}else{
		lifeBox.changeList(num);
	}
	setStyle(1);
}

function changeUpDown(num){
	setStyle(0);
	if(areaArray == 0){
		if(num > 0){
			turnArea(1);
		}
	}else if(areaArray == 1){
		if(num > 0){
			turnArea(2);
		}else{
			turnArea(0);	
		}
	}else{
		if(num < 0){
			turnArea(1);
		}
	}
	setStyle(1);
}

function turnArea(num){
	setStyle(0);
	areaArray = num;
	setStyle(1);
}

function setStyle(__type){
	if(areaArray == 0){
		//$("posImg").style.background = __type?"url(image/zylp/focus0.png)":"url(image/zylp/losfocus.png)";
		$("posImg").style.visibility = __type ?"visible":"hidden";
		$("topLeft0").style.visibility = __type ?"visible":"hidden";
		$("topRight0").style.visibility = __type ?"visible":"hidden";
	}else if(areaArray == 1){
		$("topLeft1").style.visibility = __type ?"visible":"hidden";
		$("topRight1").style.visibility = __type ?"visible":"hidden";
		$("heal_focus").style.visibility = __type ?"visible":"hidden";
	}else{
		$("topLeft2").style.visibility = __type ?"visible":"hidden";
		$("topRight2").style.visibility = __type ?"visible":"hidden";
		$("life_focus").style.visibility = __type ?"visible":"hidden";
	}
}

function doSelect(){
	if(areaArray == 0){
		if(adSlipObj.position == 0){
			location.href = "http://192.168.48.217:8082/epghd/1.html";
		}else{
			var typeurl = "SaveCurrFocus.jsp?currFoucs=" + areaArray + "," + adSlipObj.currFocus + "&url=";
			location.href =typeurl+ "/EPG/jsp/defaultHD/en/zylp_detail.jsp?vodId="+listData[adSlipObj.position].vodId+"&typeId="+typeId;
		}
	}else if(areaArray == 1){
		var typeurl = "SaveCurrFocus.jsp?currFoucs=" + areaArray + "," + healthBox.position + "&url=";
		location.href =typeurl+ "/EPG/jsp/defaultHD/en/zylp_list.jsp?typeId="+healthItem[healthBox.position].typeId+"&pageLength=12";
		iPanel.eventFrame.zylpType = 0;
	}else{
		var typeurl = "SaveCurrFocus.jsp?currFoucs=" + areaArray + "," + lifeBox.position + "&url=";
		location.href = typeurl+"/EPG/jsp/defaultHD/en/zylp_list.jsp?typeId="+lifeItem[lifeBox.position].typeId+"&pageLength=12";
		iPanel.eventFrame.zylpType = 1;
	}
}
</script>

<body background="image/zylp/test_bg.jpg" leftmargin="0" topmargin="0" onLoad="init();">

<div style="position:absolute; left:63px; top:26px; width:570px; height:50px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="141"><img src="image/zylp/logo.png" width="135" height="50" /></td>
      <td><img src="image/zylp/logo_txt.png" width="390" height="50" /></td>
    </tr>
  </table>
</div>

<div style="position:absolute; left:638px; top:26px; width:570px; height:50px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="41" height="48"><img src="image/zylp/icon_active.png" width="27" height="29" /></td>
      <td width="529" style="font-size:24px; color:#b5b8c3;"><marquee id="marquee"></marquee></td>
    </tr>
  </table>
</div>

<div style="position:absolute; left:405px; top:86px; width:494px; height:264px; background:url(image/zylp/focus0.png) no-repeat; z-index:10; -webkit-transition-duration:1ms; visibility:hidden;" id="posImg"></div>
<div style="position:absolute; left: 36px; top: 204px; height: 35px; visibility:hidden;" id="topLeft0">
	<img src="image/zylp/arrow_left.png">
</div>
<div style="position:absolute; left: 1213px; top: 204px; height: 35px; visibility:hidden;" id="topRight0">
	<img src="image/zylp/arrow_right.png">
</div>
<div style="position:absolute; left: 36px; top: 446px; height: 35px; visibility:hidden;" id="topLeft1">
	<img src="image/zylp/arrow_left.png">
</div>
<div style="position:absolute; left: 1213px; top: 446px; height: 35px; visibility:hidden;" id="topRight1">
	<img src="image/zylp/arrow_right.png">
</div>
<div style="position:absolute; left: 36px; top: 600px; height: 35px; visibility:hidden;" id="topLeft2">
	<img src="image/zylp/arrow_left.png">
</div>
<div style="position:absolute; left: 1213px; top: 600px; height: 35px; visibility:hidden;" id="topRight2">
	<img src="image/zylp/arrow_right.png">
</div>

<div id="mainMenu" style="position:absolute; left:69px; top:87px; width:1139px; height:267px; overflow:hidden;">
<div id="top0" style="position:absolute; left:0; top:32px; width:363px; height:210px; z-index:1">
		<img id="img0" src="" width="363" height="210" >
	</div>
	<div id="top1" style="position:absolute; left:348px; top:12px;width:470px; height:250px; z-index:3">
		<img id="img1" src="" width="470" height="250" >
	</div>
	<div id="top2" style="position:absolute; left:775px; top:32px; width:363px; height:210px; z-index:1">
		<img id="img2" src="" width="363" height="210" >
</div>
	<div id="top3" style="position:absolute; left:1280px; top:12px; width:360px; height:230px;">
		<img id="img3" src=""  width="360" height="270" />
	</div>	
</div>

<div style="position:absolute; left:68px; top:417px; width:1145px; height:90px;">
  <div style="position:absolute; left:0px; top:0px; width:225px; height:90px;"><img src="image/zylp/colomn_1.png" width="225" height="90" id="h_img0"/></div>
  <div style="position:absolute; left:228px; top:0px; width:225px; height:90px;"><img src="image/zylp/colomn_2.png" width="225" height="90" id="h_img1"/></div>
  <div style="position:absolute; left:456px; top:0px; width:225px; height:90px;"><img src="image/zylp/colomn_3.png" width="225" height="90" id="h_img2"/></div>
  <div style="position:absolute; left:684px; top:0px; width:225px; height:90px;"><img src="image/zylp/colomn_4.png" width="225" height="90" id="h_img3"/></div>
  <div style="position:absolute; left:912px; top:0px; width:225px; height:90px;"><img src="image/zylp/colomn_5.png" width="225" height="90" id="h_img4"/></div>
</div>
<div style="position:absolute; left:56px; top:405px; width:246px; height:112px; background:url(image/zylp/focus2.png) no-repeat;-webkit-transition-duration:200ms; visibility:hidden;" id="heal_focus"></div>

<div style="position:absolute; left:65px; top:372px; width:220px; height:40px; font-size:26px; color:#fff; line-height:40px;">养生健康&nbsp;<span style="font-size:22px; color:#fff; ">HEALTH</span></div>
<div style="position:absolute; left:65px; top:512px; width:220px; height:40px; font-size:26px; color:#fff; line-height:40px;">趣味生活&nbsp;<span style="font-size:22px; color:#fff; ">LIFE</span></div>

<div style="position:absolute; left:68px; top:555px; width:1145px; height:127px; ">
  <div style="position:absolute; left:0px; top:0px; width:172px; height:127px;"><img src="image/zylp/life_1.png" width="172" height="127" id="l_img0"/></div>
  <div style="position:absolute; left:193px; top:0px; width:172px; height:127px;"><img src="image/zylp/life_2.png" width="172" height="127" id="l_img1"/></div>
  <div style="position:absolute; left:386px; top:0px; width:172px; height:127px;"><img src="image/zylp/life_3.png" width="172" height="127" id="l_img2"/></div>
  <div style="position:absolute; left:579px; top:0px; width:172px; height:127px;"><img src="image/zylp/life_4.png" width="172" height="127" id="l_img3"/></div>
  <div style="position:absolute; left:772px; top:0px; width:172px; height:127px;"><img src="image/zylp/life_5.png" width="172" height="127" id="l_img4"/></div>
  <div style="position:absolute; left:965px; top:0px; width:172px; height:127px;"><img src="image/zylp/life_6.png" width="172" height="127" id="l_img5"/></div>
</div>
<div style="position:absolute; left:56px; top:543px; width:194px; height:149px; background:url(image/zylp/focus3.png) no-repeat;-webkit-transition-duration:200ms; visibility:hidden;" id="life_focus"></div>

</body>
</html>
