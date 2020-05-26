<%@ page contentType="text/html; charset=GBK" language="java"%>
<%@ include file = "datajspHD/koreanZone_index_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title>韩剧专区-首页</title>
<style>
.shadeS { background: url(images/hj_zone/shade0.png); font-size:18px; color:#ffffff; line-height:30px; text-align:center;  }
.shadeL { background:url(images/hj_zone/shade0.png); font-size:20px; color:#fff; line-height:40px; text-align:center; }
</style>
<script language="javascript" type="text/javascript">
<!--
iPanel.eventFrame.initPage(window);

var fosArea = 0;  //0:中间，1：左边菜单，2：图片区域，3：按钮区域


var leftMenuFocusPos = [209,293,375,461];
var downFocusPos = [55,246,437,628,819];

//左边菜单
var leftMenuList = [
{name:'最新上线',url:'hj_newFilm.jsp?typeId=10000100000000090000000000102285&pageLength=10'},
{name:'人气排行',url:'hj_hotList.jsp?typeId=10000100000000090000000000102286&pageLength=10'},
{name:'经典重温',url:'hj_jind.jsp?typeId=10000100000000090000000000102287&pageLength=8'},//10000100000000090000000000102287
{name:'即将下线',url:'hj_newFilm.jsp?typeId=10000100000000090000000000102288&pageLength=10'}
];
var leftMenuListObj = null;

var downVodList = [];
var downVodListObj = null;


var middleMenuList = [];

//中间滚动海报数据索引
var currMidIndex = 0;  //max 14
var preMidIndex = 0;
var nextMidInex = 0;

var buttonData = [
	{name : "首页",focusImg : "images/hj_zone/footbtn1_01.png",lostFocusImg : "images/hj_zone/footbtn0_01.png"},
	{name : "返回",focusImg : "images/hj_zone/footbtn1_02.png",lostFocusImg : "images/hj_zone/footbtn0_02.png"}
];
var buttonIndex = 0;

var leftMenuListFos = 0;
var downVodListFos = 0;

//记忆上一次焦点位置
var preUpOrDownFocus = 2;
var preLOrRFocus = 0;

var vodId='';
var typeId='';

function eventHandler(eventObj,type) {
    if(type == 1 && key_flag == 1){//有提示框弹出来
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
			case "KEY_SELECT":
				doSelect();
				break;
			case "KEY_NUMERIC":
				break;
			case "KEY_MENU":
				doMenu();
				break;
			case "KEY_BACK":
				doMenu();
				break;
			default:
				return 1;
				break;
		}
		return 0;
	}
	
}



//数据准备
function initData(){
	fosArea = parseInt(kzFosArea,10);
	currMidIndex = parseInt(kzCurrMidIndex,10);
	leftMenuListFos = parseInt(kzLeftMenuListFos,10);
	downVodListFos = parseInt(kzDownVodListFos,10);
	middleMenuList = scrollArray;
	downVodList = downArray;
}

//初始化左边菜单
function initLeftMenuList() {

	leftMenuListObj = new E.showList(4,4,leftMenuListFos,0,window);
	leftMenuListObj.showType = 0;
	leftMenuListObj.haveData = setLeftMenuList;
	leftMenuListObj.notData = clearLeftMenuList;
	leftMenuListObj.startShow();
}
function setLeftMenuList(list){
	
}
function clearLeftMenuList(list){
	
}

//初始化下面5幅推影片
function initDownVodList() {
	downVodListObj = new E.showList(5,downVodList.length,downVodListFos,0,window);
	downVodListObj.showType = 1;
	downVodListObj.haveData = setDownVodList;
	downVodListObj.notData = clearDownVodList;
	downVodListObj.startShow();
	
	
}

function setDownVodList(list){
	var idPos = list.idPos;
	var tempData = downVodList[list.dataPos];
	$('downDiv_'+idPos).style.visibility = 'visible';
	$('down_'+idPos).src = tempData.img;
	$('down_txt_'+idPos).innerText = iPanel.misc.interceptString(tempData.name,14);
}

function clearDownVodList(list){
	var idPos = list.idPos;
	$('downDiv_'+idPos).style.visibility = 'hidden';
}

//初始化滚动数据
function showMiddleData(num){
	calculateMidIndex(num);
	$('m_l').src = middleMenuList[preMidIndex].img;
	$('m_m').src = middleMenuList[currMidIndex].img;
	$('m_r').src = middleMenuList[nextMidInex].img;
	$('middleFocusImg').src = middleMenuList[currMidIndex].img;
	$('ico').src = middleMenuList[currMidIndex].ico;
	$('middleFocusTxt').innerText = iPanel.misc.interceptString(middleMenuList[currMidIndex].name,32);
}

function calculateMidIndex(num){
   if(num == 0){//表示页面在加载中
	   preMidIndex = currMidIndex-1;
	   nextMidInex = currMidIndex+1;
   }else if(num > 0){
	   currMidIndex=currMidIndex+1;
	   currMidIndex = (currMidIndex > (middleMenuList.length - 1))? middleMenuList.length - 1:currMidIndex;
	   preMidIndex = currMidIndex-1;
	   nextMidInex = currMidIndex+1;
   }else if(num < 0){
	   currMidIndex=currMidIndex-1;
	   currMidIndex  = currMidIndex < 0 ? 0 : currMidIndex;
	   preMidIndex = currMidIndex-1;
	   nextMidInex = currMidIndex+1;  
   }
   preMidIndex = preMidIndex < 0? middleMenuList.length -1:preMidIndex;
   nextMidInex = (nextMidInex > (middleMenuList.length - 1))? 0:nextMidInex;
}


function createMiddleFocusTip(){
	var html = "";
	for(var i = 0; i < middleMenuList.length; i++){
		html+="<span style='width:27px;'><img id='m_"+i+"' src='images/hj_zone/dot0.png' width='13' height='13' /></span>";
	}
	$('middleFocusTip').innerHTML = html;
}

function showCharMarquee(length,isShow){
	if(fosArea == 0){
		var vodName = middleMenuList[currMidIndex].name;
		var tempName = iPanel.misc.interceptString(vodName,length);
	    if(isShow){
		   if (vodName != tempName) {
				$('middleFocusTxt').innerHTML = "<marquee style=\"width:380px; height:42px;\">" + vodName + "</marquee>";
			}
			else {
				$('middleFocusTxt').innerText = tempName;
			}
	    }else{
			$('middleFocusTxt').innerHTML = '&nbsp;';
		}
		
		
	}else if(fosArea == 2){
		var index = downVodListObj.position % downVodListObj.listSize;
		var vodName = downVodList[downVodListObj.position].name;
		var tempName = iPanel.misc.interceptString(vodName,length);
	    if(isShow){
		   if (vodName != tempName) {
				$('downFocusTxt').innerHTML = "<marquee style=\"width:180px; height:40px;\">" + vodName + "</marquee>";
			}
			else {
				$('downFocusTxt').innerText = tempName;
			}
	    }else{
			$('downFocusTxt').innerHTML = '&nbsp;';
		}
	}
}



function setStyle(flag){
	if(fosArea == 0){
		$("topPos").style.backgroundImage =flag?"url(images/hj_zone/ico_playPos.png)":"url()";
		//$('middleFocus').style.visibility = (flag == true) ? 'visible':'hidden';
		$('arrowLeft').style.visibility = (flag == true) ? 'visible':'hidden';
		$('arrowRight').style.visibility = (flag == true) ? 'visible':'hidden';
		if(flag == true){
			showCharMarquee(32,true);
			setStyleArrow();
			
			//下标提示
			var timer = setTimeout(function(){
				$('m_'+currMidIndex).src = "images/hj_zone/dot1.png";
				clearTimeout(timer);
			},200);
			//$('m_'+currMidIndex).src = "images/hj_zone/dot1.png";
		}else{
			$('m_'+currMidIndex).src = "images/hj_zone/dot0.png";
			showCharMarquee(32,false);
		}
	}else if(fosArea == 1){
		var index = leftMenuListObj.position;
		if(flag == true){
			 $('leftFocus').innerText = leftMenuList[index].name;
			 $('leftFocus').style.top =leftMenuFocusPos[index]; 
			 $('leftFocus').style.visibility = 'visible'; 
		}else{
			 $('leftFocus').style.visibility = 'hidden';
		}
	}else if(fosArea == 2){
		var index = downVodListObj.focusPos;//downVodListObj.position % downVodListObj.listSize;
	    if(flag === true){
			$('downFocusImg').src = downVodList[downVodListObj.position].img;
			$('downFocusTxt').innerText = iPanel.misc.interceptString(downVodList[downVodListObj.position].name,14);
			showCharMarquee(14,true);
			
			$('downFocus').style.visibility = "visible";
		    $('downFocus').style.left = downFocusPos[index];
			
			/*
			$('downDiv_'+index).style.visibility = "hidden";
			$('downFocus').style.visibility = "visible";
			$('downFocus').style.left = $('downDiv_'+index).style.left;
			$('downFocus').style.top = $('downDiv_'+index).style.top;
			$('downFocus').style.width = $('downDiv_'+index).style.width;
			$('downFocus').style.height = $('downDiv_'+index).style.height;
			
			var timer = setTimeout(function(){
				$('downFocus').style.left = downFocusPos[index];
			    $('downFocus').style.top = 355;
			    $('downFocus').style.width = 247;
			    $('downFocus').style.height = 241;
				clearTimeout(timmer);
			},200);
			*/
		}else{
			//$('downDiv_'+index).style.visibility = "visible";
			
			$('downFocus').style.visibility = "hidden";
			showCharMarquee(14,false);
		}
	}else if(fosArea == 3){
		  $('foot_'+buttonIndex).src = (flag==true) ? buttonData[buttonIndex].focusImg:buttonData[buttonIndex].lostFocusImg;
	}
}


function setStyleArrow(){
	if(currMidIndex == 0){
		
		$('arrowLeft').style.backgroundImage = "url(images/hj_zone/arrow_left0.png)";
		$('arrowLeft').style.backgroundRepeat = "no-repeat";
		
		$('arrowRight').style.backgroundImage = "url(images/hj_zone/arrow_right1.png)";
		$('arrowRight').style.backgroundRepeat = "no-repeat";
	}else if(currMidIndex == middleMenuList.length - 1){
		$('arrowLeft').style.backgroundImage = "url(images/hj_zone/arrow_left1.png)";
		$('arrowLeft').style.backgroundRepeat = "no-repeat";
		
		$('arrowRight').style.backgroundImage = "url(images/hj_zone/arrow_right0.png)";
		$('arrowRight').style.backgroundRepeat = "no-repeat";
	}else{
		$('arrowLeft').style.backgroundImage = "url(images/hj_zone/arrow_left1.png)";
		$('arrowLeft').style.backgroundRepeat = "no-repeat";
		
		$('arrowRight').style.backgroundImage = "url(images/hj_zone/arrow_right1.png)";
		$('arrowRight').style.backgroundRepeat = "no-repeat";
	}
}

//上下移动
function udMove(num) {
	setStyle(false);
    switch(fosArea){
		case 0:
		 if(num > 0){
			 fosArea = 2;
		 }
		 break;
	    case 1:
		  if((leftMenuListObj.position == leftMenuListObj.dataSize -1) && num > 0){
		       preUpOrDownFocus = fosArea;
		       fosArea = 3;
		  }else{
			   leftMenuListObj.changeList(num);
		  }
		 break;
		case 2:
		  if(num > 0){
			  preUpOrDownFocus = fosArea;
			  fosArea = 3;
		  }else{
			 fosArea = 0;  
		  }
		 break;
		case 3:
		  if(num < 0){
			  fosArea = preUpOrDownFocus;
		  }
		 break;
		
	}
	setStyle(true);
}

//左右移动
function lrMove(num) {
	setStyle(false);
    switch(fosArea){
		case 0:
		  if(num < 0 && currMidIndex == 0){
			 preLOrRFocus = fosArea;
			 fosArea = 1; 
		  }else{
			 showMiddleData(num);
		  }
		 break;
	    case 1:
		 if(num > 0){
			fosArea = preLOrRFocus;
		 }
		 break;
		case 2:
		 if(num < 0 && downVodListObj.position == 0){
			 preLOrRFocus = fosArea;
			 fosArea = 1;
	     }else if(num > 0 && downVodListObj.position == downVodListObj.dataSize - 1){
			
		 }else{
			  downVodListObj.changeList(num);
		 }
		 break;
		case 3:
		  buttonIndex = num > 0 ? 1:0;
		 break;
		
	}
	setStyle(true);
}


function doSelect() {
	switch(fosArea){
		case 0://在滚动vod上
		  if(middleMenuList.length > 0){
			  var dataObj = middleMenuList[currMidIndex];
			  if(dataObj.name =='当“国民弟弟”撞上“帝国之子”'){//恋爱中的那些事
                  window.location.href = focusURL()+"gm.jsp?typeId=10000100000000090000000000104667&pageSize=50&startIndex=0";
			  }else if(dataObj.name =="恋爱中的那些事儿"){//恋爱中的那些事
                  window.location.href = focusURL()+"love.jsp?typeId=10000100000000090000000000104584&pageSize=50&startIndex=0";
              }else if(dataObj.name =="不“羁”的少年没人爱"){//年度好韩剧 投票有好礼
				  window.location.href = focusURL()+"20150731_koreaYoungs.jsp?typeId=10000100000000090000000000105360&pageSize=50&startIndex=0";
			  }else if(dataObj.name =="年度好韩剧 投票有好礼"){//年度好韩剧 投票有好礼
                  window.location.href = focusURL()+"ktv.jsp?typeId=10000100000000090000000000104798&pageSize=50&startIndex=0";
              }else if(dataObj.name =="“韩剧专区今秋特别企划”第一弹"){//让你一次“虐”个够！
				  window.location.href = focusURL()+"/EPG/jsp/neirong/S20150908.jsp";
			  }else if(dataObj.name =="中韩男星撩妹技能大比武"){//让你一次“虐”个够！
				  window.location.href = focusURL()+"/EPG/jsp/neirong/STemplate2.jsp?typeId=10000100000000090000000000105782";
			  }else if(dataObj.name =="寒假补剧班之韩流追新剧"){//让你一次“虐”个够！
				  window.location.href = focusURL()+"/EPG/jsp/neirong/S20160127.jsp";
			  }else if(dataObj.name =="“韩剧专区今秋特别企划”第二弹"){//让你一次“虐”个够！
				  window.location.href = focusURL()+"/EPG/jsp/neirong/S20150917.jsp";
			  }else if(dataObj.name =="韩剧专区“先生”夺人"){//让你一次“虐”个够！
				  window.location.href = focusURL()+"/EPG/jsp/neirong/S20150417.jsp";
			  }else if(dataObj.name =="寒假补剧班之青春欧巴"){//让你一次“虐”个够！
				  window.location.href = focusURL()+"/EPG/jsp/neirong/S20150204.jsp";
			  }else if(dataObj.name =="让你一次“虐”个够！"){//让你一次“虐”个够！
                  window.location.href = focusURL()+"/EPG/jsp/neirong/A20140901-2.jsp?typeId=10000100000000090000000000104481";
              }else if(dataObj.name =="百集长剧看不够"){//国民妹妹恋爱了
			      window.location.href = focusURL()+"cjkbg.jsp?typeId=10000100000000090000000000103733&pageSize=30&startIndex=0";  
			  }else if(dataObj.name =="国民妹妹恋爱了"){//国民妹妹恋爱了
				  window.location.href = focusURL()+"gmmm.jsp?typeId=10000100000000090000000000102621&pageSize=30&startIndex=0";
			  }else if(dataObj.name =="暑假看啥？由你做主！"){//国民妹妹恋爱了
				  window.location.href = focusURL()+"lookWhat2.jsp?typeId=10000100000000090000000000104360&pageSize=30&startIndex=0";
			  }else if(dataObj.name =="韩剧土豪大盘点"){
			      window.location.href = focusURL()+"2013hjth.jsp?typeId=10000100000000090000000000103020&pageSize=50&startIndex=0";
			  }else if(dataObj.name =="都教授进化论"){
			      window.location.href = focusURL()+"djsjhl.jsp?typeId=10000100000000090000000000103020&pageSize=50&startIndex=0";
			  }else if(dataObj.name =="韩流男神，谁是你的菜"){
			      window.location.href = focusURL()+"hanliuns.jsp?typeId=10000100000000090000000000103561&pageSize=50&startIndex=0";
			  }else if(dataObj.name =="男神都是穿越来的"){
			      window.location.href = focusURL()+"ManGod.jsp?typeId=10000100000000090000000000103822&pageSize=50&startIndex=0";
			  }else if(dataObj.name =="韩医柳叶刀"){
			      window.location.href = focusURL()+"hxlyd.jsp?typeId=10000100000000090000000000104080&pageSize=50&startIndex=0";
			  }else if(dataObj.name =="致最强高校思密达"){
			      window.location.href = focusURL()+"simida.jsp?typeId=10000100000000090000000000104121&pageSize=50&startIndex=0";
			  }else if(dataObj.name =="盛夏带你过“韩”假"){
			      window.location.href = focusURL()+"hanjiayou.jsp?typeId=10000100000000090000000000104246&pageSize=50&startIndex=0";
			  }else if(dataObj.name =="“杯剧”大战一触即发"){
			      window.location.href = focusURL()+"beiJu.jsp?typeId=10000100000000090000000000104246&pageSize=50&startIndex=0";
			  }else{
				  //播放
				  vodId = dataObj.vodId;
				  typeId = scrollTypeID;
				  play_movie(dataObj.playType);
			  }
		  }
		 break;
		case 1://焦点在左边菜单上
		     window.location.href = focusURL()+leftMenuList[leftMenuListObj.position].url
		 break;
		case 2://焦点在图片栏目
		 if(downVodList.length > 0){
			   var dataObj = downVodList[downVodListObj.position];
			   if(1 != 1){
				   //策划活动时需要从新定义的连接在这里写
			   }else{
				  vodId = dataObj.vodId;
			      typeId = downTypeID;
			      play_movie(dataObj.playType); 
			   }
			   
		  }
		 break;
		case 3://焦点底部按钮区域
		   doMenu();
		 break;
		 
	}
}


function showMarquee() {
	$("marquee").innerText = content;
	E.koreanZone = content;
}

function init(){
	//准备数据
	initData();
	
    initLeftMenuList();
	showMiddleData(0);
	createMiddleFocusTip();
	initDownVodList();
	setStyle(true);
	showMarquee();
}


function focusURL(){
	var baseurl = "SaveCurrFocus.jsp?currFoucs=" + fosArea + "," + currMidIndex + "," + leftMenuListObj.position + "," + downVodListObj.position+"&url=";
	return baseurl;
}

//打开菜单
function doMenu() {
	iPanel.mainFrame.location.href = E.portal_url;
}


//播放部分
/* tipsWindow.jsp中getAuthUrl()方法调用，从开始处播放 */
function tip_fromBeginPlay(){
	var url =focusURL()+"Authorization.jsp?typeId=-1&playType=1" 
					+"&progId="+vodId +"&contentType=0&business=1&isHd=1";
	iPanel.debug("url == "+url);
	$("data_ifm").src = url;
}

/**从书签处播放 */
function tip_fromBookmarkPlay(){
	var tempTime = domark(vodId);
	$("data_ifm").src = focusURL()+"Authorization.jsp?typeId=-1&playType=1" 
					+"&progId="+vodId + "&contentType=0&startTime="+tempTime+ "&business=1&isHd=1";
}

/**节目播放，跳到授权页面  */
function play_movie(playType){
	if(playType == 1){
		//如果是电视剧
		window.location.href = focusURL()+"hj_TV_detail.jsp?vodId="+vodId+"&typeId="+typeId;
	}else{
		//电影直接播放
	   getAuthUrl(vodId);
	}
}
//-->
</script>
</head>

<body background="images/hj_zone/index_bg.jpg" leftmargin="0" topmargin="0" onLoad="init();">

<div id="leftFocus" style="position:absolute; left:0px; top:209px; width:251px; height:71px; background:url(images/hj_zone/focus00.png); visibility:hidden;
font-size:25pt; color:#ffffff; padding-left:52px;letter-spacing:2px; font-family:Adobe 黑体 Std; line-height:71px;-webkit-transition-duration:200ms;"></div>
<div style="position:absolute; left:52px; top:225px; width:148px; height:290px; background:url(images/hj_zone/leftmenu.png) no-repeat;"></div>

<div style="position:absolute; left:175px; top:40px; width:1105px; height:610px;">

  <div style="position:absolute; left:89px; top:73px; width:304px; height:261px; background:url(images/hj_zone/mainP_btm0.png) no-repeat; ">
    <div style="position:absolute; left:5px; top:5px; width:292px; height:251px; "><img id="m_l" src="images/hj_zone/global_tm.gif" width="292" height="251"  /></div>
    <div style="position:absolute; left:5px; top:5px; width:292px; height:251px; background:url(images/hj_zone/mainP_cover.png) no-repeat; "></div>    
  </div> 
  <div style="position:absolute; left:408px; top:73px; width:304px; height:261px; background:url(images/hj_zone/mainP_btm0.png) no-repeat; ">
    <div style="position:absolute; left:5px; top:5px; width:292px; height:251px; "><img id="m_m" src="images/hj_zone/global_tm.gif" width="292" height="251"  /></div>
    <div style="position:absolute; left:5px; top:5px; width:292px; height:251px; background:url(images/hj_zone/mainP_cover.png) no-repeat; "></div>    
  </div>
  <div style="position:absolute; left:727px; top:73px; width:304px; height:261px; background:url(images/hj_zone/mainP_btm0.png) no-repeat; ">
    <div style="position:absolute; left:5px; top:5px; width:292px; height:251px; "><img id="m_r" src="images/hj_zoneglobal_tm.gif" width="292" height="251"  /></div>
    <div style="position:absolute; left:5px; top:5px; width:292px; height:251px; background:url(images/hj_zone/mainP_cover.png) no-repeat; "></div>    
  </div>  
  
   <div id="middleFocus" style="position:absolute; left:320px; top:10px; width:481px; height:374px; background:url(images/hj_zone/mainP_btm2.png) no-repeat;">
    <div style="position:absolute; left:32px; top:28px; width:418px; height:310px;"><img id="middleFocusImg" src="images/hj_zone/global_tm.gif" width="418" height="310" /></div>
    <div style="position:absolute; left:32px; top:296px; width:418px; height:42px; background:url(images/hj_zone/shade0.png); font-size:23px; color:#fff; line-height:42px; text-align:center; " id="middleFocusTxt"></div>
    <div style="position:absolute; left:205px; top:155px; width:72px; height:72px; background: url() no-repeat; " id="topPos"></div>
    <div style="position:absolute; left: 332px; top: 20px; width:125px; height:130px;"><img src="" width="125" height="130" id="ico"></div>
  </div>   
  
  <div  id="downDiv_0" style="position:absolute; left:89px; top:389px; width:178px; height:172px; background:url(images/hj_zone/mainP_btm1.png) no-repeat; visibility:hidden;">
    <div style="position:absolute; left:1px; top:1px; width:175px; height:170px;"><img id="down_0" src="images/hj_zone/global_tm.gif" width="175" height="170" /></div>
    <div class="shadeS" style="position:absolute; left:1px; top:141px; width:175px; height:30px;" id="down_txt_0"></div>
  </div>
  <div id="downDiv_1" style="position:absolute; left:280px; top:389px; width:178px; height:172px; background:url(images/hj_zone/mainP_btm1.png) no-repeat;visibility:hidden ">
    <div style="position:absolute; left:1px; top:1px; width:175px; height:170px;"><img id="down_1" src="images/hj_zone/global_tm.gif" width="175" height="170" /></div>
    <div class="shadeS" style="position:absolute; left:1px; top:141px; width:175px; height:30px;" id="down_txt_1"></div>
  </div>
  <div id="downDiv_2" style="position:absolute; left:471px; top:389px; width:178px; height:172px; background:url(images/hj_zone/mainP_btm1.png) no-repeat;visibility:hidden ">
    <div style="position:absolute; left:1px; top:1px; width:175px; height:170px;"><img id="down_2" src="images/hj_zone/global_tm.gif" width="175" height="170" /></div>
    <div class="shadeS" style="position:absolute; left:1px; top:141px; width:175px; height:30px;" id="down_txt_2"></div>
  </div>
  <div id="downDiv_3" style="position:absolute; left:662px; top:389px; width:178px; height:172px; background:url(images/hj_zone/mainP_btm1.png) no-repeat;visibility:hidden ">
    <div style="position:absolute; left:1px; top:1px; width:175px; height:170px;"><img id="down_3" src="images/hj_zone/global_tm.gif" width="175" height="170" /></div>
    <div class="shadeS" style="position:absolute; left:1px; top:141px; width:175px; height:30px;" id="down_txt_3"></div>
  </div>
  <div id="downDiv_4" style="position:absolute; left:853px; top:389px; width:178px; height:172px; background:url(images/hj_zone/mainP_btm1.png) no-repeat; visibility:hidden">
    <div style="position:absolute; left:1px; top:1px; width:175px; height:170px;"><img id="down_4" src="images/hj_zone/global_tm.gif" width="175" height="170" /></div>
    <div class="shadeS" style="position:absolute; left:1px; top:141px; width:175px; height:30px;" id="down_txt_4"></div>
  </div> 
  
  <div  id="downFocus" style="position:absolute; left:55px; top:355px; width:247px; height:241px; background: url(images/hj_zone/mainP_btm3.png) no-repeat;visibility:hidden;-webkit-transition-duration:200ms;">
    <div style="position:absolute; left:19px; top:17px; width:209px; height:203px;"><img id="downFocusImg" src="images/hj_zone/global_tm.gif" width="209" height="203" /></div>
    <div class="shadeL" style="position:absolute; left:19px; top:180px; width:209px; height:40px; " id="downFocusTxt"></div>
    <div style="position:absolute; left:85px; top:75px; width:72px; height:72px; background: url(images/hj_zone/ico_playPos.png) no-repeat;"></div>
  </div>  
   
  <div id="middleFocusTip" style="position:absolute; left:363px; top:358px; width:400px; height:15px; z-index:-1; text-align:center;">
    
  </div>   
  
  <div id="arrowLeft" style="position:absolute; left:95px; top:190px; width:49px; height:64px; background:url(images/hj_zone/arrow_left0.png) no-repeat; visibility: hidden;"></div> 
  <div id="arrowRight" style="position:absolute; left:975px; top:190px; width:49px; height:64px; background:url(images/hj_zone/arrow_right0.png) no-repeat; visibility: hidden;"></div> 

</div>

<!--Bottom-->
<div style="position:absolute; left:55px; top:642px; width:250px; height:45px;">
  <div style="position:absolute; top:1px; left:0px; width:58px; height:44px;"><img src="images/hj_zone/footicon.png" width="58" height="44" /></div>
  <div style="position:absolute; top:3px; left:60px; width:90px; height:42px;"><img id="foot_0" src="images/hj_zone/footbtn0_01.png" width="90" height="42" /></div>
  <div style="position:absolute; top:3px; left:133px; width:90px; height:42px;"><img id="foot_1" src="images/hj_zone/footbtn0_02.png" width="90" height="42" /></div>  
</div>
<div style="position:absolute; left:400px; top:645px; width:800px; height:40px; font-size:18px; color:#fff; line-height:40px;"><marquee id="marquee">互动电视 精彩随心掌控 海量精彩节目、影视大片，任由您点播；长达72小时的可回看由您点播</marquee></div>

<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="high_tips.jsp"></jsp:include>
</body>
</html>
