<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="tv_detail_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title>tvDetail</title>
<style>
.posterDiv {position:absolute; top:15px; width:140px; height:222px;}
.posterDiv div {position:absolute; left:5px; top:190px; width:130px; height:20px; font-size:18px; text-align:center; color:#333333;}
.posterDiv img {position:absolute; left:5px; top:5px; width:130; height:176;}
</style>
<script type="application/javascript" src="js/showList.js"></script>
<script type="application/javascript" src="js/ajax.js"></script>
<script type="application/javascript" src="js/global.js"></script>
<script>
iPanel.eventFrame.initPage(window);

//var dramaData = {name:"人类消失后的世界",director:"扎克·施奈德",currPlay:4,currNew:30,totalNum:122, zanFlag:true, shuaiFlag:false, favFlag:false,  introdution:"本片是超人电影的重启之作，用全新的故事和方式展现超人的身世和他对自我身份，的认知前所未有的挖掘这位美漫史上首位超级英雄的人性一面。"};

var focusArea = 1;   // 0 按钮操作区  1 集数选择 2段落选择区

//var totalPages = 0;   //总共集数 ，方便分段落
//var partBox = null;   //段数选择区
//var programLen = 0;

//点赞 点衰 收藏判断

var bestvflag = "上海文广" ;
var getBesTvname = "";

var buttonPic = [	
					[["img/btn_xuanji01.png","img/btn_xuanji02.png"],  ["img/btn_xuanji03.png","img/btn_xuanji02.png"]],
					[["img/btn_fav01.png","img/btn_fav02.png"],  ["img/btn_fav_ok01.png","img/btn_fav_ok02.png"]],
					[["img/btn_zan01.png","img/btn_zan02.png"],["img/btn_zan_ok01.png","img/btn_zan_ok02.png"]],
					[["img/btn_shuai01.png","img/btn_shuai02.png"],["img/btn_shuai_ok01.png","img/btn_shuai_ok02.png"]]
				];

var topButtonPos = 0;   //按钮选择去区焦点
//点赞 点衰 收藏判断
//var isLike = 0;
//var isDislike = 0;
var favFlag = 0;
var xjFlag = 1;
var commentType = 0;//1点赞操作，3 取消点赞操作

var tipsShowFlag = false;
var reminderTimeout = -1;

var associNumber = 14;//关联推荐数
var sihuaContentId = "";

var totalnum = 0;
//dataArea为栏目的位置，jsNo是栏目的具体焦点位置
/*jsNo = (jsNo?jsNo:0);
var areaFocus = dataArea?dataArea:0;//0：分享 1：集数范围  2：某个集数  3：海报  4追剧  5是点赞点衰
*/

var pageNum = 20;//每一栏显示的集数的个数
var jishuItemLen = 0;//集数有多少个栏目
var jishuButtonPos = 0;//当前所在集数的区块焦点
var jishuListBox = null;
var jishulistFocusPos = 0;

var listBox = null;
var listData = [];
var listFocusPos = 0;
var favData = [];


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
	initButtonPic();
	initMovieInfo();
	initJishuInfo();
	initJishuList();
	initFocus();
	showPosterList();
	getFavList();
	/*var returnFlag = scspUUIDLogin();
	var waitTime = 0;
	if(!returnFlag) waitTime = 4000;
	setTimeout(function(){	
		getSihuaContentId();//先进行ID转换
	},waitTime);*/
	
}

//初始化数据
function initDatas(){
	E.sitcom_subList = subList;
	totalnum = subList.length;
	for(var i = 0; i< 7;i++){
		var tmpNum = Math.ceil(Math.random()*vodList.length);
		listData.push(vodList[tmpNum]);
	}
	//初始化焦点
	focusArea = <%=focusArea%>;
	topButtonPos = <%=topButtonPos%>;
	jishuButtonPos = <%=jishuButtonPos%>;
	jishulistFocusPos = <%=jishulistFocusPos%>;
	//getAssociationMediaResources(typeId,parentId,doAssociationMedia);
	//if(focusArea == 2)focusArea = 0;
}

function getBesTvflag(){
	//alert(getBesTvname);
	if(getBesTvname==bestvflag){		
		$("bestv").style.visibility = "visible";
	}
}

function getFavList(){
	var url = E.pre_epg_url+"/defaultHD/en/datajspHD/getFavList_data.jsp";
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		iPanel.debug("getFavList requestStr="+requestStr);
		if(requestStr != ""){
			eval("var tmpObj = "+requestStr);
			favData = tmpObj.array;
			for(var i = 0;i < favData.length; i++){
				if(favData[i].vodId == saveId){
					favFlag = 1;
					initButtonPic();
					break;
				}
			}
		}
	},
	function(__errorCode){
		iPanel.debug("getFavList __errorCode="+__errorCode);
	},
	20000);	
	requestAjaxObj.requestData("post");
}

function initFocus(){
	switch(focusArea){
		case 0:
			getBtnFocus();
			break;
		case 1:
			getJishuFocus();
			break;
		case 2:
			getPartFocus();
			break;
	}
	initJishuColor();
}

function initMovieInfo(){
	$("tvName").innerText = iPanel.misc.interceptString(vodname,24);
	$("directorName").innerText = director;
	$("actorName").innerText = actor;
	$("proInfo").innerText = intr;
	$("poster").src = picPath; /*海报路径*/
	getBesTvname = tagname;
	if(code.indexOf("WASU") > -1){
		$("icon0").src = "img/wasulogo.png";
	}
	getBesTvflag();
}

function initButtonPic(){
	for(var i=0; i<buttonPic.length;i++){
		switch(i){
			case 0:
				$("doBtn"+i).src = buttonPic[i][xjFlag][0];
				break;
			case 1:
				$("doBtn"+i).src = buttonPic[i][favFlag][0];
				break;
			/*case 2:
				$("doBtn"+i).src = buttonPic[i][isLike][0];
				break;	
			case 3:
				$("doBtn"+i).src = buttonPic[i][isDislike][0];
				break;*/					
		}	
	}
	if(focusArea == 0)getBtnFocus();
}

function initJishuInfo(){
	jishuItemLen = Math.ceil(totalnum/pageNum);
	for(var i=0;i<jishuItemLen;i++){
		if(jishuItemLen > 1){
			var pagesize = pageNum*i+1+"-"+(pageNum*i+pageNum);
			$("jishuButton"+i).innerText = pagesize;
			$("jishuButtonBack"+i).style.background = "url(img/xuanji_btn033.png) center no-repeat";
		}else{
			var pagesize = 1+"-"+totalnum;
			$("jishuButton0").innerText = pagesize;
			$("jishuButtonBack"+i).style.background = "url(img/xuanji_btn033.png) center no-repeat";
		}
	}
	$("gengxin").innerText = "更新至"+totalnum+"集,共"+jstotal+"集";
}

function initJishuColor(){
	for(var i = 0;i < jishuItemLen; i++){
		if(i == (jishuListBox.currPage-1) && focusArea !=2){
			jishuButtonPos = i;
			$("jishuButton" + i).style.color = "#af2837";
		}else{
			$("jishuButton" + i).style.color = "#333333";
		}
	}
}

function initJishuList(){
	jishuListBox = new showList(pageNum,totalnum,jishulistFocusPos,0,window);//要记录焦点的话，这里改为对应取到的焦点
	jishuListBox.haveData = function(List){
		$("jishuNum"+List.idPos).innerText = List.dataPos+1;
		$("jishuNum"+List.idPos).style.color = subList[List.dataPos].isplayed==1?subList[List.dataPos].scolor:"#333333";
		$("jishuNumBack"+List.idPos).style.background = "url(img/xuanji_btn011.png) center no-repeat";
	};
	jishuListBox.notData = function(List){
		$("jishuNum"+List.idPos).innerText = "";
		$("jishuNum"+List.idPos).style.color = "#333333";
		$("jishuNumBack"+List.idPos).style.background = "none";
	};
	jishuListBox.startShow();
}

function showPosterList(){
	listBox = new showList(7, listData.length, 0, 0, window);
	listBox.listHigh = 155;
	listBox.listSign = 1;
	listBox.focusDiv = "listFocus";	
	listBox.showType  = 0;
	listBox.haveData = function(List){
		//$("posterDiv"+List.idPos).style.visibility = "visible";
		$("posterName"+List.idPos).innerText = iPanel.misc.interceptString(listData[List.dataPos].name,12);
		//getDisplayString(listData[List.dataPos].name,12,1);
		$("posterImg"+List.idPos).src = listData[List.dataPos].img;
	};
	listBox.notData = function(List){
		//$("posterDiv"+List.idPos).style.visibility = "hidden";
		$("posterName"+List.idPos).innerText = "";
		$("posterImg"+List.idPos).src = "img/tvp_imgNone.jpg";
	};
	listBox.startShow(); 
	if(focusArea == 1 && xjFlag == 0){
		$("listFocus").style.visibility = "visible";
		//setFocusStyle(1);
		setListStyle(true);
	}
}

//设置列表样式
function setListStyle(flag) {
	var tempVod = listData[listBox.position];
	var name = tempVod.name;
	var tempName = iPanel.misc.interceptString(name,12);
	$("posterName"+listBox.focusPos).style.color = flag?"#f0f0f0":"#333333";
	if(flag && name != tempName){
		$("posterName"+listBox.focusPos).innerHTML = "<marquee style=\"width:130px;height:20px;\">" + name + "</marquee>";
	}else{
		$("posterName"+listBox.focusPos).innerText = tempName;
	}
}

function showReminder(__text){
	clearTimeout(reminderTimeout);
	tipsShowFlag = true;
	$("resultReminderText0").innerText = __text;
	$("resultReminderTips").style.visibility = "visible";
	reminderTimeout = setTimeout(hideReminder,3000);
	//focusArea = 2;
}		

function hideReminder(){
	clearTimeout(reminderTimeout);
	tipsShowFlag = false;
	$("resultReminderTips").style.visibility = "hidden";
	$("resultReminderText0").innerText = "";	
	$("resultReminderText1").innerText = "";
}


function udMove(__num){
	if(xjFlag == 0){
		switch(focusArea){
			case 0:
				if(__num > 0){	
					focusArea = 1;
					loseBtnFocus();
					$("listFocus").style.visibility ="visible";
					setListStyle(true);
				}
				break;
			case 1:
				if(__num < 0){
					focusArea = 0;
					getBtnFocus();
					$("listFocus").style.visibility ="hidden";	
					setListStyle(false);
				}
				break;
		}
	}else {
		switch(focusArea){
			case 0:
				if(__num > 0){	
					focusArea =1;
					loseBtnFocus();
					getJishuFocus();
					//getPartFocus();
				}
				break;
			case 1:	
				changeJishuList(__num*10);
				break;
			case 2:
				if(__num < 0){
					focusArea = 1;
					getJishuFocus();
					losePartFocus();
				}/*else{
					focusArea = 2;
					losePartFocus();
					getJishuFocus();	
				}*/
				break;	
		}	
	}
}

function lrMove(__num){
	if(xjFlag == 0){
		switch(focusArea){
			case 0:
				changeBtnFocus(__num);
				break;
			case 1:
				changeGuessList(__num);	
				break;
		}	
	}else {
		switch(focusArea){
			case 0:
				changeBtnFocus(__num);
				break;
			case 1:
				changeJishuList(__num);	
				break;	
			case 2:
				changePartList(__num);
				break;	
				
		}
	}	
}

function changePage(__num,__type){
	if(focusArea == 2 || __type){
		//setFocusStyle(0);
		jishuListBox.changePage(__num);
		//setFocusStyle(1);
	}
}

function refreshJishuShow(){
	if((jishuButtonPos+1)  == jishuListBox.currPage) return;//当前已经是当前页的内容的话，不需要刷新
	changePage((jishuButtonPos+1) -  jishuListBox.currPage,1);
	initJishuColor();
	getPartFocus();
}

function doSelect(){
	if(tipsShowFlag){		
		hideReminder();
	}else{
		if(xjFlag == 0){
			if(focusArea == 0){
				btnDoselect();	
			}else if(focusArea == 1){
				var baseurl = focusURL();
				var pos = listBox.position;
				if(listData[pos].playType == 0){//电影
					window.location.href = baseurl+"film_detail.jsp?vodId="+listData[pos].vodId +"&typeId="+listData[pos].typeId+"&ifcor=cor";
				}else if(listData[pos].playType == 1){//电视剧 
					window.location.href = baseurl+"tv_detail.jsp?vodId="+listData[pos].vodId +"&typeId="+listData[pos].typeId+"&ifcor=cor";
				}
			}
		}else{
			if(focusArea == 0){
				btnDoselect();	
			}else if(focusArea == 1){
				saveHistory();
			}else if(focusArea == 2){
				//keywordConvertSub();
				refreshJishuShow();
			}
		}
	}
}



/*------按钮操作部分 start -----*/




function changeBtnFocus(__num){
	loseBtnFocus();
	topButtonPos = (topButtonPos + __num + 2)%2;
	getBtnFocus();	
}



function getBtnFocus(){	
	switch(topButtonPos){
		/*case 0:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][0][1];
			$("currplay").style.color = "#ffffff";
			break;*/
		case 0:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][xjFlag][1];
			break;
		case 1:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][favFlag][1];
			break;	
		/*case 2:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][isLike][1];
			break;
		case 3:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][isDislike][1];
			break;*/				
	}	
}

function loseBtnFocus(){
	switch(topButtonPos){
		/*case 0:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][0][0];
			$("currplay").style.color = "#333333";
			break;*/
		case 0:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][xjFlag][0];
			break;
		case 1:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][favFlag][0];
			break;	
		/*case 2:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][isLike][0];
			break;		
		case 3:
			$("doBtn"+topButtonPos).src = buttonPic[topButtonPos][isDislike][0];
			break;*/			
	}	
}


function btnDoselect(){
	switch(topButtonPos){
		/*case 0://播放视频
			//keywordConvertSub();
			sihuaRecordList(sihuaContentId);
			gotoPlay();
			break;	*/
		case 0: //选集
			xjFlag = (xjFlag + 1)%2;
			if(xjFlag == 0){
				$("guanlianDiv").style.visibility = "visible";
				$("jishuDiv").style.visibility = "hidden";
			}else{
				$("guanlianDiv").style.visibility = "hidden";
				$("jishuDiv").style.visibility = "visible";
			}
			break;
		case 1://追剧
			ajax();
			/*if(favFlag == 1){
				deleteOneFavorite(sihuaContentId);
			}else{
				sihuaAddFavorite(sihuaContentId);
			}*/
			break;
		case 2://点赞
			showReminder("该功能建设中");
			/*if(isLike == 1){
				commentType = 3;
				setLikeOrNolike(3);
			}else{//如果点衰了 要先取消点衰
				commentType = 1;
				if(isDislike == 1)setLikeOrNolike(4);
				setLikeOrNolike(1);
			}*/
			break;
		case 3://点衰
			showReminder("该功能建设中");
			/*if(isDislike == 1){
				commentType = 4;
				setLikeOrNolike(4);
			}else{//如果点赞了 要先取消点赞
				commentType = 2;
				if(isLike == 1)setLikeOrNolike(3);
				setLikeOrNolike(2);
			}*/
			break;		
	}
	//getBtnFocus();
	//showTips(str);	
	//saveSignFlag();	
}


/*------按钮操作部分 end -----*/

/*--------中间段落区域选择  start ---------*/

/*function showPart(){
	var partTotal =Math.ceil(dramaData.totalNum/20,10);
	iPanel.debug("showPart  partTotal==== " + partTotal);	
		
	partBox = new showList(partTotal, partTotal, 0,0, window);
	partBox.listHigh = 111;
	partBox.listSign = 1;
	partBox.showType  = 0;
	partBox.haveData = function(List){
		var tempTotal = (List.dataPos+1)*20;
		if(tempTotal > parseInt(dramaData.totalNum,10)){
			iPanel.debug("showPart  partTotal==== " + tempTotal);
			$("partNum"+List.idPos).innerText = (List.dataPos*20)+1 + "-"+parseInt(dramaData.totalNum,10) ;
		}else{
			$("partNum"+List.idPos).innerText = (List.dataPos*20)+1 + "-" + (List.dataPos+1)*20 ;
		}
		
	};
	partBox.notData = function(List){
		$("partNum"+List.idPos).innerText = "";
	};
	partBox.startShow();	 	
}*/

/*------ 猜你喜欢部分 start ----*/

function changeGuessList(__num){
	setListStyle(false);
	listBox.changeList(__num);	
	setListStyle(true);
}



/*------ 猜你喜欢部分 end ----*/

function changePartList(__num){
	if((jishuButtonPos == jishuItemLen-1 && __num > 0 )||(jishuButtonPos == 0 && __num < 0)) return;
	losePartFocus();
	jishuButtonPos += __num;
	getPartFocus();	
	//showProgram();
}

function losePartFocus(){
	if(jishuButtonPos == (jishuListBox.currPage-1)){
		$("jishuButton" + jishuButtonPos).style.color = "#af2837";
	}else{
		$("jishuButton" + jishuButtonPos).style.color = "#333333";
	}
	//$("jishuButton" + jishuButtonPos).style.background = "transparent";
	$("xjFocus").style.visibility = "hidden";
}

function getPartFocus(){
	//$("jishuButton" + jishuButtonPos).style.background = "#af2837";
	$("xjFocus").style.visibility = "visible";
	$("xjFocus").style.left = 41+jishuButtonPos*222+"px";
	$("jishuButton" + jishuButtonPos).style.color = "#f0f0f0";	
}

/*--------中间段落区域选择  end ---------*/

/*----- 最下面列表选择区域  start ----*/
/*function showProgram(){
	var str = $("partNum" + partBox.focusPos).innerText;
	var tempArr = str.split("-");
	programLen = parseInt(tempArr[1])- parseInt(tempArr[0]);
	programBox = new showList(20, programLen+1, 0, 70, window);
	programBox.listHigh = 111;
	programBox.listSign = 1;
	//partBox.focusDiv = "imgDivFocus";	
	programBox.showType  = 0;
	programBox.haveData = function(List){
		$("jishuNum"+List.idPos).innerText = List.dataPos+(partBox.focusPos*20)+1 ;
	};
	programBox.notData = function(List){
		$("jishuNum"+List.idPos).innerText = "";
	};
	programBox.startShow();	
}*/

function changeJishuList(__num){
	var tmpPosition = jishuListBox.position%20;
	if(tmpPosition < 10 && __num == -10){//第一行 上键
		loseJishuFocus();
		focusArea = 0;
		getBtnFocus();
		return;	
	}else if((tmpPosition >= 10 || jishuListBox.dataSize <= 10 || (tmpPosition < 10 && jishuListBox.dataSize%20<11&&jishuListBox.currPage==jishuListBox.listPage&&jishuListBox.dataSize>20)) && __num == 10){
		//第二行 下键  和当前区块最前一集或最后一集 不用翻页
		loseJishuFocus();
		focusArea = 2;
		getPartFocus();
		return;
	}else{
		loseJishuFocus();
		jishuListBox.changeList(__num);
		getJishuFocus();
		initJishuColor();
	}
}

function getJishuFocus(){
	//$("jishuNum" + jishuListBox.focusPos).background = "#af2837";
	$("jishuFocus").style.visibility = "visible";
	$("jishuFocus").style.left = 39+(jishuListBox.focusPos%10)*111+"px";
	$("jishuFocus").style.top = 8+(jishuListBox.focusPos>9?64:0)+"px";
	$("jishuNum" + jishuListBox.focusPos).style.color = "#f0f0f0";
	//var tmpPos = jishuListBox.position + 1;
	//$("currJishuText").innerText = (tmpPos<10?("0"+tmpPos):tmpPos)+" "+vodname.substr(0,15)+"-"+subList[jishuListBox.position].name;
}

function loseJishuFocus(){
	$("jishuFocus").style.visibility = "hidden";
	$("jishuNum" + jishuListBox.focusPos).style.color = subList[jishuListBox.position].isplayed==1?subList[jishuListBox.position].scolor:"#333333";	
	//$("jishuNum" + jishuListBox.focusPos).style.color = "#333333";
	//$("currJishuText").innerText = "";
}

function ajax(__num){
	var url = E.pre_epg_url +"/defaultHD/en/datajspHD/save_data.jsp?vodId="+saveId;
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function (){
		if(XHR.readyState == 4){
			if(XHR.status == 200){
				result = XHR.responseText;
				showtip = 1;
				if(result == 2){
					showReminder("收藏成功");
				}else{
					showReminder("该影片已经收藏");
				}
				favFlag = 1;
				initButtonPic();
			}
			else{//AJAX没有获取到数据
				XHR.abort();
			}
		}
	}
	XHR.open("GET", url, true);
	XHR.send(null);
}

/*----- 最下面列表选择区域  end ----*/


//打开菜单
function doMenu() {
    E.marqueeText = null;
    iPanel.mainFrame.location.href = E.portal_url;
}


//删除
function doBack() {
	window.location.href = "<%=turnPage.go(-1)%>";
}


function focusURL() {
    var tmpurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + topButtonPos + "," + jishuButtonPos + "," + jishuListBox.position + "," + "&url=";
    return tmpurl;
}

function gotoPlay(){//选择电视剧某一集的播放，现场补充
	getAuthUrl(subList[jishuListBox.position].vodId);
}

function saveHistory(){
	var currId = subList[jishuListBox.position].vodId;
	var url = E.pre_epg_url +"/defaultHD/en/datajspHD/saveViewData.jsp?vodId="+currId+"&supVodId="+saveId;
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function (){
		if(XHR.readyState == 4){
			if(XHR.status == 200){
				gotoPlay();
			}else{//AJAX没有获取到数据
				XHR.abort();
			}
		}
	}
	XHR.open("GET", url, true);
	XHR.send(null);
}

/**节目播放，跳到授权页面  */
/*function play_movie(playType) {
    if (playType == 1) {
        //如果是电视剧
       window.location.href = focusURL() + "tv_detail.jsp?vodId=" + parentId + "&typeId=" + typeId;
    } else {
        //电影直接播放
        getAuthUrl(vodId);
    }
}*/

/**从书签处播放 */
function tip_fromBookmarkPlay() {
    var tempTime = domark(subList[jishuListBox.position].vodId);
    var baseurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + topButtonPos + "," + jishuButtonPos + "," + jishuListBox.position + "," + "&url=";
	E.sitcom_infos = typeId+",14,"+parentId+","+jishuListBox.position;
	iPanel.debug("ifeng_tvDetail baseurl=="+baseurl);
	$("data_ifm").src = baseurl+ "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId="+typeId + "&playType=14&parentVodId="+parentId
						+"&progId="+subList[jishuListBox.position].vodId + "&contentType=0&startTime="+tempTime+"&business=1";
}

/* tipsWindow.jsp中getAuthUrl()方法调用，从开始处播放 */
function tip_fromBeginPlay() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + topButtonPos + "," + jishuButtonPos + "," + jishuListBox.position + "," + "&url=";
	E.sitcom_infos = typeId+",11,"+parentId+","+jishuListBox.position;
	$("data_ifm").src = baseurl+"/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=11&parentVodId="+parentId
			+"&progId="+subList[jishuListBox.position].vodId + "&contentType=0&startTime=0&business=1";			
			

}

function exit_page(){
}
</script>
</head>

<body background="img/bg_detail.jpg" leftmargin="0" topmargin="0" onLoad="init();">
<!--大海报-->
<img id="bestv" src="img/bestv-en.png" style="position: absolute; left: 1106px; top: 63px; width: 120px; height: 31px; visibility:hidden" />
<img id="poster" src="img/poster_detail.jpg" width="250" height="350" style="position: absolute; left: 75px; top: 59px;" />
<img id="icon0" src="img/global_tm.gif" width="57" height="63" style="position: absolute; left: 268px; top: 59px;" />
<!--详情-->
<div style="position: absolute; left: 348px; top: 61px; width: 886px; height: 373px;">
	<!--节目名-->
	<div id="tvName" style="position: absolute; left: 0px; top: 0px; width: 600px; height: 36px; font-size: 36px; color:#000000;"></div>
	<!--<div id="playedCount" style="position:absolute; left: 652px; top: 20px; width: 114px; height: 18px; background:url(img/num_play.png) no-repeat; padding-left:20px;color: #000000;font-size:18px;"></div>
	<div id="totalLikeNum" style="position:absolute; left: 769px; top: 20px; width: 114px; height: 18px; background:url(img/num_zan.png) no-repeat; padding-left:20px;color: #000000;font-size:18px;"></div>-->
	
	<!--<img src="img/line.png" width="882" height="1" style="position:absolute; left:0px; top:52px;" />-->
	<!--简介-->
	<div style="position:absolute; left:0px; top:63px; width:879px; height:200px; line-height:26px; font-size:22px;color: #000000; ">
		<span style="color:#333333">导演：</span><span id="directorName"></span><br />
		<span style="color:#333333">主演：</span><span id="actorName"></span><br />
		<span style="color:#333333">集数：</span><span id="gengxin"></span><br /><br />
		<span style="color:#333333">剧情简介：</span><br /><span id="proInfo"></span>
	</div>

	<!--btn-->
	<!--<img id="doBtn0" src="img/btn_play11.png" width="80" height="80" style="position:absolute; left:0px; top:280px;" />-->
	<img id="doBtn0" src="img/btn_xuanji01.png" width="232" height="162" style="position:absolute; left:-51px; top:245px;" />
	<img id="doBtn1" src="img/btn_fav01.png" width="232" height="162" style="position:absolute; left:93px; top:245px;" />
	<!--<img id="doBtn2" src="img/btn_zan01.png" width="80" height="80" style="position:absolute; left:200px; top:280px;" />
	<img id="doBtn3" src="img/btn_shuai01.png" width="80" height="80" style="position:absolute; left:300px; top:280px;" />-->
	<!--<img id="doBtn3" src="img/btn_shuai01.png" width="80" height="80" style="position:absolute; left:400px; top:280px;" />-->
	<!--<div id="currplay" style="position:absolute; left:0px; top:328px; width:80px; height:22px; color:#333333; text-align:center; font-size:22px;">播放</div>-->
</div>

<!--选集-->

<div id="jishuDiv" style="position:absolute; left:0px; top:410px; width:1280px; height:310px; background:url(img/xuanji_btm1.png) no-repeat;">
    <!--段数-->
    <div style="position: absolute; left: 85px; width: 1110px; top: 183px; text-align: center; font-size: 30px;">
        <table width="100%" height="50" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr>
            <td id="jishuButtonBack0" width="222" height="50" style="background:url() center no-repeat">&nbsp;</td>
            <!--已看颜色为白色-->
            <td id="jishuButtonBack1" width="222" style="background:url() center no-repeat">&nbsp;</td>
            <td id="jishuButtonBack2" width="222" style="background:url() center no-repeat">&nbsp;</td>
            <td id="jishuButtonBack3" width="222" style="background:url() center no-repeat">&nbsp;</td>
            <td id="jishuButtonBack4" width="222" style="background:url() center no-repeat">&nbsp;</td>
          </tr>
      </table>
  </div>
    <div id="xjFocus" style="position: absolute; left: 41px; top: 136px; width: 309px; height: 152px; background: url(img/xuanji_btn04.png);visibility:hidden;"></div>
    <div style="position: absolute; left: 85px; width: 1110px; top: 183px; text-align: center; font-size: 30px;">
        <table width="100%" height="50" border="0" cellspacing="0" cellpadding="0" align="center" style="text-align:center; font-size:25px; color:#000; line-height:50px;">
          <tr>
            <td id="jishuButton0" width="222" height="50" align="center">&nbsp;</td>
            <!--已看颜色为白色-->
            <td id="jishuButton1" width="222" align="center">&nbsp;</td>
            <td id="jishuButton2" width="222" align="center">&nbsp;</td>
            <td id="jishuButton3" width="222" align="center">&nbsp;</td>
            <td id="jishuButton4" width="222" align="center">&nbsp;</td>
          </tr>
      </table>
  </div>
    
<!-- 集数列表区域 -->
  
  <div style="position:absolute; left:85px; top:50px; width:1111px; height:124px;">
        <table width="100%" height="128" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td id="jishuNumBack0" width="111" height="64" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack1" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
          	<td id="jishuNumBack2" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack3" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack4" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack5" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack6" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack7" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack8" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack9" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
          </tr>
          <tr>
            <td id="jishuNumBack10" width="111" height="64" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack11" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack12" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack13" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack14" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack15" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack16" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack17" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack18" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
            <td id="jishuNumBack19" width="111" style="background:url(img/xuanji_btn011.png) center no-repeat"></td>
          </tr>
        </table>
    </div>
    <div id="jishuFocus" style="position: absolute; left: 39px; top: 8px; width: 202px; height: 162px; background: url(img/xuanji_btn02.png);"></div>
	<div style="position:absolute; left:85px; top:50px; width:1111px; height:124px;">
        <table width="100%" height="128" border="0" cellspacing="0" cellpadding="0" style="ext-align:center; font-size:30px;">
          <tr>
            <td id="jishuNum0" width="111" height="64" align="center"></td>
            <td id="jishuNum1" width="111" align="center"></td>
            <td id="jishuNum2" width="111" align="center"></td>
            <td id="jishuNum3" width="111" align="center"></td>
            <td id="jishuNum4" width="111" align="center"></td>
            <td id="jishuNum5" width="111" align="center"></td>
            <td id="jishuNum6" width="111" align="center"></td>
            <td id="jishuNum7" width="111" align="center"></td>
            <td id="jishuNum8" width="111" align="center"></td>
            <td id="jishuNum9" width="111" align="center"></td>
          </tr>
          <tr>
            <td id="jishuNum10" width="111" height="64" align="center"></td>
            <td id="jishuNum11" width="111" align="center"></td>
            <td id="jishuNum12" width="111" align="center"></td>
            <td id="jishuNum13" width="111" align="center"></td>
            <td id="jishuNum14" width="111" align="center"></td>
            <td id="jishuNum15" width="111" align="center"></td>
            <td id="jishuNum16" width="111" align="center"></td>
            <td id="jishuNum17" width="111" align="center"></td>
            <td id="jishuNum18" width="111" align="center"></td>
            <td id="jishuNum19" width="111" align="center"></td>
          </tr>
        </table>
    </div>
</div>

<div id="guanlianDiv" style="position:absolute; left:130px; top:450px; width:1073px; height:238px; visibility:hidden;">
	<div style="position: absolute; left: 0px; top: -22px; width: 141px; height: 29px; font-size: 26px; color: #000000;">热门推荐</div>
	<!--<img src="img/guess.png" width="33" height="144" style="position:absolute; left:68px; top:33px;" />-->
  <div id="listFocus" style="position: absolute; left: 0px; top: 14px; width: 140px; height: 222px; background: #af2837; visibility: hidden;"></div>
	<div class="posterDiv" id="posterDiv0" style="position:absolute; left:0px;">
		<img id="posterImg0" src=""/>
		<div id="posterName0"></div>
	</div>
	<div class="posterDiv" id="posterDiv1" style="position:absolute; left:155px;">
		<img id="posterImg1" src=""/>
		<div id="posterName1"></div>
	</div>
	<div class="posterDiv" id="posterDiv2" style="position:absolute; left:310px;">
		<img id="posterImg2" src=""/>
		<div id="posterName2"></div>
	</div>
	<div class="posterDiv" id="posterDiv3" style="position:absolute; left:465px;">
		<img id="posterImg3" src=""/>
		<div id="posterName3"></div>
	</div>
	<div class="posterDiv" id="posterDiv4" style="position:absolute; left:620px;">
		<img id="posterImg4" src=""/>
		<div id="posterName4"></div>
	</div>
	<div class="posterDiv" id="posterDiv5" style="position:absolute; left:775px;">
		<img id="posterImg5" src=""/>
		<div id="posterName5"></div>
	</div>
	<div class="posterDiv" id="posterDiv6" style="position:absolute; left:930px;">
		<img id="posterImg6" src=""/>
		<div id="posterName6"></div>
	</div>
</div>
<!--弹出框-->
<div id="playTips" style="position:absolute; left:362px; top:207px; width:556px; height:326px; background:url(img/notice02.png) no-repeat; visibility:hidden; ">
<div style="position:absolute; left:67px; top:60px; width:410px; height:120px; line-height:40px; font-size:30px; color:#333333;  ">您尚未订购【凤凰专区】套餐,可免费试看5分钟，现在就前往电视营业厅订购吧！</div>
<div style="position:absolute; left:32px; top:220px; width:240px; height:60px; font-size:28px; color:#f0f0f0; text-align:center; line-height:60px; background:#af2837; no-repeat;">去试看</div>
<div style="position:absolute; left:272px; top:220px; width:240px; height:60px; font-size:28px; color:#333333; text-align:center; line-height:60px; ">去订购</div>
</div>

<!--  按钮操作的弹出提示框  -->
<div id="resultReminderTips" style="position:absolute; left:441px; top:200px; width:396px; height:156px; background:url(img/notice01.png) no-repeat; visibility:hidden; ">
    <div id="resultReminderText0" style="position:absolute; left:32px; top:50px; width:320px; height:30px; font-size:30px; color:#af2837; text-align:center; ">收藏成功</div>
    <div id="resultReminderText1" style="position:absolute; left:32px; top:76px; width:320px; height:22px; font-size:22px; color:#333333; text-align:center; "></div>
</div>

<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="../showtip.jsp"></jsp:include>
</body>
</html>
