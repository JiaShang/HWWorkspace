<%@ page contentType="text/html; charset=GBK" language="java" pageEncoding="GBK" %>
<%@ include file="datajspHD/newHd_tv_detail_data.jsp" %>
<html>
<head>
<meta name="page-view-size" content="1280*720">
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title>电视剧详情页</title>
<style>
.tvpName { font-size:18px; color:#000; line-height:40px; text-align:center;  }
</style>
<script type="text/javascript" src="js40/ajax.js"></script>
<script type="text/javascript" src="js40/showList.js"></script>
<script type="text/javascript" src="js40/global.js"></script>

<script>
iPanel.eventFrame.initPage(window);

//document.onkeydown = eventHandler;
//document.onirkeypress = eventHandler;
//document.onsystemevent = eventHandler;

var isLike = 0;//是否点赞过
var isDislike = 0;//是否已经点衰过
var sihuaContentId = "";

var totalnum = subList.length;
//dataArea为栏目的位置，jsNo是栏目的具体焦点位置
jsNo = (jsNo?jsNo:0);
var areaFocus = dataArea?dataArea:0;//0：分享 1：集数范围  2：某个集数  3：海报  4追剧  5是点赞点衰
var bottonPos = (dataArea == 0?jsNo:1);
var bottonTotal = 4;

var pageNum = 20;//每一栏显示的集数的个数
var jishuItem = 0;//集数有多少个栏目
var jishuBottonPos = 0;//当前所在集数的焦点
var jishuShowList = null;
var jishuShowPos = (dataArea == 2?jsNo:0);

var posterBox = null;
var posterPos = (dataArea == 3?jsNo:0);

var associNumber = 14;//关联推荐数
var vodList = [];


/*
function eventHandler(event){//捕获按键
	var keycode = event.which;
	iPanel.debug("tvDetail.htm keycode="+keycode);
	switch(keycode){
		case 3:
		case 37:
			changeListLR(-1);
			return 0;
			break;
		case 4:
		case 39:
			changeListLR(1);
			return 0;
			break;
		case 1:
		case 38:
			changeListUD(-1);
			return 0;
			break;
		case 2:
		case 40:
			changeListUD(1);
			return 0;
			break;
		case 372:
		case 290:
			changePage(-1);
			return 0;
			break;
		case 373:
		case 291:
			changePage(1);
			return 0;
			break;
		case 13:
			doSelect();
			return 0;
			break;
	}
}*/

function eventHandler(eventObj, __type) {
	if (__type == 1 && key_flag == 1) {//有提示框弹出来
        return tipkeypress(eventObj.code);
    } else {
		switch (eventObj.code) {
			case "KEY_UP":
				changeListUD(-1);
				return 0;
				break;
			case "KEY_DOWN":
				changeListUD(1);
				return 0;
				break;
			case "KEY_LEFT":
				changeListLR(-1);
				return 0;
				break;
			case "KEY_RIGHT":
				changeListLR(1);
				return 0;
				break;
			case "KEY_SELECT":
				doSelect();
				return 0;
				break;
			case "KEY_CHANNEL_UP":
			case "KEY_PAGE_UP":
				changePage(-1);
				break;	
			case "KEY_CHANNEL_DOWN":
			case "KEY_PAGE_DOWN":
				changePage(1);
				break;
			case "KEY_BACK":
				do_back();
				break;
			case "KEY_EXIT":
			case "KEY_MENU":
				window.location.href = iPanel.eventFrame.portalUrl;
				break;
		}
		return eventObj.args.type;
	}
	
}


function init(){
	E.sitcom_subList = subList;//cdq 用于实现连续播放的自动播放下一集
	initMovieInfo();
	initJishuInfo();
	initJishuList();
	keywordConvert(1);//先进行ID转换
	getAssociationMediaResources(typeId,parentId,doAssociationMedia);
	setFocusStyle(1);
}


function initMovieInfo(){
	$("movieName").innerText = pname;
	$("actor").innerText = "主演："+actor;
	$("director").innerText ="导演：" +director;
	$("intr").innerHTML = "简介："+intr;
	$("poster").src = posterUrl;
	//$("movieType").innerText = "类型：";//缺少
}

function initJishuInfo(){
	jishuItem = Math.ceil(totalnum/pageNum);
	for(var i=0;i<8;i++){
		if(jishuItem > 1){
			if(i<jishuItem){
				var pagesize = pageNum*i+1+"-"+(pageNum*i+pageNum)
				$("jishuBotton"+i).innerText = pagesize;
			}else{
				$("jishuBotton"+i).style.width = "1px";
			}
		}else{
			$("jishuBotton0").style.width = "1px";
		}
	}
	$("gengxin").innerText = "更新至"+totalnum+"集,共"+jstotal+"集";
}

function initJishuList(){
	jishuShowList = new showList(pageNum,totalnum,jishuShowPos,0,window);//要记录焦点的话，这里改为对应取到的焦点
	jishuShowList.haveData = function(List){
		$("jishuNum"+List.idPos).innerText = List.dataPos+1;
	};
	jishuShowList.notData = function(List){
		$("jishuNum"+List.idPos).innerText = " ";
	};
	jishuShowList.startShow();	
}

/***************查询关联推荐*******************************/
function getAssociationMediaResources(typeID,VODID,callback){
	if(typeID != "-1"){//不是搜索过来的资源
		var url = "http://192.168.4.75/ccqtvRecommend";
		var sendData = "siteCode=HWVOD&vodAssetId="+VODID+"&folderCode="+typeID+"&number="+associNumber;
		url += "?"+sendData;
		var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
			var requestStr = __ajaxObj.responseText;
			iPanel.debug("getAssociationMediaResources requestStr="+requestStr);
			if(requestStr != ""){
			     requestStr = requestStr.replace("<html><body></body></html>","");
				  if(requestStr.length > 0){
					  var shdataArr = requestStr.split("\n");
					  var vodids = ""; 
					  for(var i = 0 ; i < shdataArr.length; i++){
						   var temp = shdataArr[i].split(",");
						   if(i < shdataArr.length - 1){
							   vodids+=temp[2]+";";
						   }else{
							   vodids+=temp[2];
						   }
					   }
					   getVodDetailListByvodIds(vodids,callback); 
				  }
			}
		},
		function(__errorCode){
			iPanel.debug("getAssociationMediaResources __errorCode="+__errorCode);
			showPosterList();
		},
		20000);	
		requestAjaxObj.requestData();
	}else{
		getVodDetailListByvodIds(VODID,getTypeIdCallback);
	}
}

function getVodDetailListByvodIds(vodids,callback){
	var url = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/datajspHD/queryVodListByIDs.jsp";
	var sendData = "imgType=1&defaultImgPath=images/newVodhd/tvp_imgNone.jpg&vodids="+vodids;
	url += "?"+sendData;
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		iPanel.debug("getVodDetailListByvodIds requestStr="+requestStr);
		if(requestStr != ""){
			eval("var tmpList = "+requestStr);
			callback(tmpList);
		}
	},
	function(__errorCode){
		iPanel.debug("getVodDetailListByvodIds __errorCode="+__errorCode);
		showPosterList();
	},
	20000);	
	requestAjaxObj.requestData();
}

function getTypeIdCallback(__vodList){
	var vodObj = __vodList[0];
	if(vodObj.vodID != ""){
		getAssociationMediaResources(vodObj.typeID,vodObj.vodID,doAssociationMedia);
	} 
}
/*******************查询关联推荐结束****************************/
function doAssociationMedia(vodData){
	vodList = new Array();
	for(var i = 0 ; i < vodData.length ; i++){
		if(vodData[i].vodID != ""){
			vodList.push(vodData[i]);
			if(vodList.length >= 7){
				break;
			}
		}
	}
	//确保有7个
	for(var j = 7; j > vodList.length ; j--){
		vodList.push(vodList[vodList.length-1]);
	}
	showPosterList();
}

function showPosterList(){
	posterBox = new showList(7,vodList.length, posterPos, 126, window);	
	posterBox.focusDiv = "posterFocus";
	posterBox.listSign = 1;
	posterBox.listHigh = 155;
	posterBox.haveData=function(List){
		$("posterImg"+List.idPos).src = vodList[List.dataPos].img;
		$("posterName"+List.idPos).innerText = getDisplayString(vodList[List.dataPos].name,16,1);
	}
	posterBox.notData=function(List){
		$("posterImg"+List.idPos).src = "images/newVodhd/poster_default.png";
		$("posterName"+List.idPos).innerText = " ";
	}
	posterBox.startShow();
	if(areaFocus == 3){
		$("posterFocus").style.visibility = "visible";
		setFocusStyle(1);
	}
}


function changeListLR(__num){
	if(areaFocus == 0){
		if((bottonPos == bottonTotal-1 && __num > 0 )||(bottonPos == 1 && __num < 0)) return;
		setFocusStyle(0);
		bottonPos += __num;
		setFocusStyle(1);	
	}else if(areaFocus == 1){
		if((jishuBottonPos == jishuItem-1 && __num > 0 )||(jishuBottonPos == 0 && __num < 0)) return;
		setFocusStyle(0);
		jishuBottonPos += __num;
		setFocusStyle(1);	
	}else if(areaFocus == 2){
		if(subList.length == 0) return;
		setFocusStyle(0);
		jishuShowList.changeList(__num);
		setFocusStyle(1);	
	}else if(areaFocus == 3){
		if(vodList.length == 0) return;
		setFocusStyle(0);
		posterBox.changeList(__num);
		setFocusStyle(1);	
	}
}

function changeListUD(__num){
	if(areaFocus == 0 && __num<0 || areaFocus == 3 && __num > 0) return;
	if(areaFocus == 2){
		if(jishuShowList.focusPos < 10 && __num < 0){
			setFocusStyle(0);
			if(jishuItem < 2) areaFocus = 0;
			else areaFocus = 1;
			setFocusStyle(1);
		}else if((Math.ceil((jishuShowList.position+1)/10)%2==0)&& __num>0 ||(Math.ceil((jishuShowList.position+1)/10)== Math.ceil(totalnum/10)&& __num > 0)){
			if(vodList.length == 0) return;
			setFocusStyle(0);
			areaFocus += __num;
			setFocusStyle(1,1);
		}else{
			setFocusStyle(0);
			if(jishuShowList.position+10 > totalnum-1 && __num <0){
				jishuShowList.changeList(-10);
			}else{
				jishuShowList.changeList(__num*(jishuShowList.position+10 > totalnum-1?(totalnum-1-jishuShowList.position):10));
			}
			
			setFocusStyle(1);
		}
		return;
	}else if(areaFocus == 0 && __num > 0){
		setFocusStyle(0,1);
		if(jishuItem < 2) areaFocus = 2;
		else areaFocus = 1;
		setFocusStyle(1,1);
		return;
	}else if(areaFocus == 2 && __num < 0){
		setFocusStyle(0,1);
		if(jishuItem < 2) areaFocus = 0;
		else areaFocus = 1;
		setFocusStyle(1,1);
		return;
	}
	setFocusStyle(0,1);
	areaFocus += __num;
	setFocusStyle(1,1);
}

function changePage(__num,__type){
	if(areaFocus == 2 || __type){
		setFocusStyle(0);
		jishuShowList.changePage(__num);
		setFocusStyle(1);
	}
}

function refreshJishuShow(){
	if((jishuBottonPos+1)  == jishuShowList.currPage) return;//当前已经是当前页的内容的话，不需要刷新
	changePage((jishuBottonPos+1) -  jishuShowList.currPage,1);
}

function doSelect(){
	if(areaFocus == 0){
		if(bottonPos == 0){//分享
			doShare();
		}else if(bottonPos == 1){//收藏
			keywordConvert(0);
		}else if(bottonPos == 2){//点赞
			commentType = 1;
			likeOrNolike(1);	
		}else if(bottonPos == 3){//点衰
			commentType = 2;
			likeOrNolike(2);	
		}
	}else if(areaFocus == 1){
		refreshJishuShow();
	}else if(areaFocus == 2){
		keywordConvertSub();//子集要先做id转换
	}else if(areaFocus == 3){//海报，现场补充
		var typeurl = "SaveCurrFocus.jsp?currFoucs=" + areaFocus + "," + posterBox.position + ","+0+ ","+0+ "&url=";//现网的写法
		if(vodList[posterBox.position].playType == 0){//电影
			window.location.href = typeurl+"movieDetail.jsp?vodId="+vodList[posterBox.position].vodID +"&typeId="+typeId+"&ifcor=cor";
		}else if(vodList[posterBox.position].playType == 1){//电视剧 
			window.location.href = typeurl+"tvDetail.jsp?vodId="+vodList[posterBox.position].vodID +"&typeId="+typeId+"&ifcor=cor";
		}	
	}else if(areaFocus == 4){//提示框
		hideReminder();	
	}else if(areaFocus == 5){//点赞点衰
		hideCommentReminder();	
	}
}

function doShare(){//微博分享
	//记录相关的一些信息
	var tmpStr = "";
	tmpStr += '"platType":"22"';
	tmpStr += ', "vodAssetid":"'+parentId+'"';
	tmpStr += ', "assetType":"1"';
	tmpStr += ', "foldId":"p_9"';
	tmpStr += ', "contentName":""';
	tmpStr += ', "seriesContentId":""';
	tmpStr += ', "seriesNum":""';
	tmpStr += ', "playTime":""';
	tmpStr += ', "flags":"stb"';
	var tmpAnnotations = "[{"+tmpStr+"}]";
	iPanel.debug("tvDetail doShare tmpAnnotations="+tmpAnnotations);
/*	var tmpObj = {};
	tmpObj.platType = "22";
	tmpObj.vodAssetid = parentId;
	tmpObj.assetType = "1";
	tmpObj.foldId = "p_9";
	tmpObj.contentId = "";
	tmpObj.contentName  = "";
	tmpObj.seriesContentId = "";
	tmpObj.seriesNum = "";
	tmpObj.playTime = "";
	tmpObj.flags = "stb";
	var tmpAnnotations = [tmpObj];*/
	iPanel.setGlobalVar("weiboAnnotations",tmpAnnotations);	
	var typeurl = "SaveCurrFocus.jsp?currFoucs=" + areaFocus + "," + bottonPos+ "," + 0+ ","+ 0 + "&url=";
	window.location.href = typeurl+"userInfo/weiboShare.jsp?movieName="+pname;
}

function keywordConvert(__type){//华为转思华__type 0是提交收藏，，1是豆瓣评分
	//先做ID转换
  	if(sihuaContentId != ""){
		if(__type == 0) sihuaFavorite(sihuaContentId);
		else if(__type == 1){
			getDoubanRating();
			commentType = 0;//进行查询是否已经进行过点赞点衰
			likeOrNolike(0);
		}
		return;
	}
	var url = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/datajspHD/idtokeyWords_data.jsp?vodId="+parentId;//用父级的id
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		iPanel.debug("keywordConvert requestStr="+requestStr);
		if(requestStr != ""){
			eval("var tmpSihuaList = "+requestStr);
			iPanel.debug("keywordConvert typeof(tmpSihuaList)="+typeof(tmpSihuaList)+"tmpSihuaList.length="+tmpSihuaList.length);
			if(typeof(tmpSihuaList) == "object" && tmpSihuaList.length > 0){
				var tmpContentId = tmpSihuaList[0];
				if(tmpContentId.indexOf("-cloudID")){
					tmpContentId = tmpContentId.split("-cloudID")[0];
				}
				sihuaContentId = tmpContentId;
				if(__type == 0)sihuaFavorite(sihuaContentId);
				else if(__type == 1){
					getDoubanRating();
					commentType = 0;//进行查询是否已经进行过点赞点衰
					likeOrNolike(0);
				}
			}else{
				if(__type == 0)showReminder("追剧失败！");
			}
		}
	},
	function(__errorCode){
		iPanel.debug("keywordConvert __errorCode="+__errorCode);
		if(__type == 0)showReminder("追剧失败！");
	},
	20000);	
	requestAjaxObj.requestData();
}

function sihuaFavorite(__contentId){ //思华接口提交追剧
	var url = globalRequestSCSPUrl;
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestXML = __ajaxObj.responseXML;
		iPanel.debug("sihuaFavorite requestStr="+__ajaxObj.responseText);
		if(requestXML){
			var tmpElement = requestXML.getElementsByTagName("body")[0];
			var xmlObj = xmlToJson(tmpElement);
			if(xmlObj.collection["@attributes"].result == 0){
				showReminder("追剧成功！");
			}else{
				showReminder(xmlObj.collection["@attributes"].resultDesc);
			}	
		}
	},
	function(__errorCode){
		iPanel.debug("sihuaFavorite __errorCode="+__errorCode);
		showReminder("追剧失败！");
	},
	20000);	
	var headObj = {"action":"REQUEST","command":"COLLECTION"};
	var bodyXML = '<collection operation="0" systemId="1" userId="'+globalUUID+'" contentId="'+__contentId+'" foldId="p_9" token="'+globalToken+'" />';//contentId和folder做补充
	var sendXML = generateXML("SCSP",headObj,bodyXML);
	iPanel.debug("sihuaFavorite sendXML="+sendXML);
	requestAjaxObj.requestData("post",sendXML);
}


function keywordConvertSub(){//华为转思华 转子集
	var url = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/datajspHD/idtokeyWords_data.jsp?vodId="+subList[jishuShowList.position].vodId;
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		iPanel.debug("keywordConvert requestStr="+requestStr);
		if(requestStr != ""){
			eval("var tmpSihuaList = "+requestStr);
			iPanel.debug("keywordConvert typeof(tmpSihuaList)="+typeof(tmpSihuaList)+"tmpSihuaList.length="+tmpSihuaList.length);
			if(typeof(tmpSihuaList) == "object" && tmpSihuaList.length > 0){
				var tmpContentId = tmpSihuaList[0];
				if(tmpContentId.indexOf("-cloudID")){
					tmpContentId = tmpContentId.split("-cloudID")[0];
				}
				sihuaRecordList(tmpContentId);
			}else{
				
			}
		}
		gotoPlay();
	},
	function(__errorCode){
		iPanel.debug("keywordConvert __errorCode="+__errorCode);
		gotoPlay();
	},
	3000);	
	requestAjaxObj.requestData();
}



/*在点播放的时候提交观看历史*/
function sihuaRecordList(__tmpContentId){
	iPanel.debug("movieDetail sihuaRecordList __tmpContentId="+__tmpContentId);
	var  url = globalRequestSCSPUrl;
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		iPanel.debug("movieDetail sihuaRecordList xmlResponse.responseXML="+__ajaxObj.responseText);
	},
	function(__errorCode){
		iPanel.debug("movieDetail sihuaRecordList __errorCode="+__errorCode);
	},
	10000);
	var __stoptime = "0";
	var sendXML = '<?xml version="1.0" encoding="UTF-8"?><message module="SCSP" version="1.1"><header sequence="" action="REQUEST" command="CONTINUEPLAY" component-id="SYSTEM1" component-type="THIRD_PARTY_SYSTEM" /><body><continuePlay operation="0" userId="'+globalUUID+'" systemId="0" contentId="'+__tmpContentId+'" foldId="p_9" startTime="'+__stoptime+'" token="'+globalToken+'" /></body></message>';
	iPanel.debug("movieDetail sihuaRecordList sendXML="+sendXML);
	requestAjaxObj.requestData("POST",sendXML);
}

function gotoPlay(){//选择电视剧某一集的播放，现场补充
	getAuthUrl(subList[jishuShowList.position].vodId);
}


function getDoubanRating(){
	//var url = globalRequestSCSPUrl;//页面目前转utf-8有困难，改为jsp页面提交转吧
	var ishaveHd = pname.indexOf("(HD)");
	if(ishaveHd > 0){
		pname=pname.substr(0,ishaveHd);
	}
	iPanel.debug("getDoubanRating in pname="+pname);
	var url = "http://192.168.33.67:8989/cloud/Douban?contentId="+sihuaContentId+"&contentName="+pname+"&uuid="+globalUUID+"&token="+globalToken;
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestXML = __ajaxObj.responseXML;
		iPanel.debug("getDoubanRating requestXML="+__ajaxObj.responseText);
		if(requestXML){
			var tmpElement = requestXML.getElementsByTagName("body")[0];
			var xmlObj = xmlToJson(tmpElement);
			var tmpObj = xmlObj.doubanRating["@attributes"];
			if(tmpObj.return_code == 0){
				var score = tmpObj.average;
				/*
				var scoreStr = "";
				if( score%2 == 0){
					var starsNum = score/2;
					for(var i=0;i<starsNum;i++)scoreStr += '<img src="images/newVodhd/star_1.png" width="29" height="25" />';
				}else{
					var starsNum = Math.floor(score/2);
					for(var i=0;i<starsNum;i++) scoreStr += '<img src="images/newVodhd/star_1.png" width="29" height="25" />';
					scoreStr += '<img src="images/newVodhd/star_0.5.png" width="29" height="25" />';
				}
				$("starNum").innerHTML = scoreStr;
				*/
				$("doubanScore").innerText = score+"分";
				$("collectCount").innerText = "观看:"+tmpObj.collect_count+"次";
			}
			
		}
	},
	function(__errorCode){
		iPanel.debug("getDoubanRating __errorCode="+__errorCode);
	},
	20000);
	//var headObj = {"action":"REQUEST","command":"DOUBANRATING"};
	//var bodyXML = '<doubanRating contentId="'+sihuaContentId+'" contentName="'+pname+'" token="'+globalToken+'" uuid="'+globalUUID+'" />';
	//var sendXML = generateXML("SCSP",headObj,bodyXML);
	//iPanel.debug("getDoubanRating sendXML="+sendXML);
	//requestAjaxObj.requestData("post",sendXML);	
	requestAjaxObj.requestData();
}

var commentType = 0;//0是查询判断是否已经点赞点衰 1是点赞， 2是点帅
function likeOrNolike(__type){//0:查询，1:点赞，2:点衰
	iPanel.debug("likeOrNolike __type="+__type+";;;sihuaContentId="+sihuaContentId);
	if(sihuaContentId == ""){
		showReminder(["点赞失败","点衰失败"][__type-1]);
		return;
	}
	if(__type == 1 && isLike == 1){
		showReminder("您已经点过赞");
		return;
	}else if(__type == 2 && isDislike == 1){
		showReminder("您已经点过衰");
		return;
	}
	var url = globalRequestSCSPUrl;
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestXML = __ajaxObj.responseXML;
		iPanel.debug("likeOrNolike requestXML="+__ajaxObj.responseText);
		if(requestXML){
			var tmpElement = requestXML.getElementsByTagName("body")[0];
			var xmlObj = xmlToJson(tmpElement);
			var tmpObj = xmlObj.scspRate["@attributes"];
			if(tmpObj.return_code == 0){
				if(__type == 0){
					iPanel.debug("likeOrNolike commentType="+commentType);
					if(commentType == 0){
						iPanel.debug("likeOrNolike tmpObj.isLike="+tmpObj.isLike+";;tmpObj.isDislike="+tmpObj.isDislike);
						isLike = tmpObj.isLike;
						isDislike = tmpObj.isDislike;
						if(isLike == 0){
						/*	bottonTotal ++;	
							$("botton3").src = "images/newVodhd/pushbtn_zan0.png";
							$("botton3").style.width = "83px"
							$("bottonTd3").style.width = "93px";
							var imgTmpObj = ["images/newVodhd/pushbtn_zan0.png","images/newVodhd/pushbtn_zan1.png"];
							bottonImgs.push(imgTmpObj);*/
						}
						if(isDislike == 0){
							/*bottonTotal ++;	
							$("botton"+(bottonTotal-1)).src = "images/newVodhd/pushbtn_shuai0.png";
							$("botton"+(bottonTotal-1)).style.width = "83px"
							$("bottonTd"+(bottonTotal-1)).style.width = "93px";
							var imgTmpObj2 = ["images/newVodhd/pushbtn_shuai0.png","images/newVodhd/pushbtn_shuai1.png"];
							bottonImgs.push(imgTmpObj2);*/
						}
					}else{
						if(commentType == 1){ 
							var totalNum = tmpObj.likeNum;
							isLike = 1;	
						}else if(commentType == 2){
							var totalNum = tmpObj.dislikeNum;
							isDislike = 2;
						}
						showCommentReminder(totalNum);
					}
				}else{
					likeOrNolike(0);
				}
				return;
			}
		}else{
			showReminder(["点赞失败","点衰失败"][__type-1]);
		}	
	},
	function(__errorCode){
		iPanel.debug("likeOrNolike __errorCode="+__errorCode);
		showReminder(["点赞失败","点衰失败"][__type-1]);
	},
	20000);
	var headObj = {"action":"REQUEST","command":"SCSPRATE"};
	var bodyXML = '<scspRate contentId="'+sihuaContentId+'" operation="'+__type+'" token="'+globalToken+'" uuid="'+globalUUID+'" />';
	var sendXML = generateXML("SCSP",headObj,bodyXML);
	iPanel.debug("likeOrNolike sendXML="+sendXML);
	requestAjaxObj.requestData("post",sendXML);	
}


function showReminder(__text){
	$("resultReminderText").innerText = __text;
	$("resultReminderTips").style.visibility = "visible";
	areaFocus = 4;
}		

function hideReminder(){
	$("resultReminderTips").style.visibility = "hidden";
	areaFocus = 0;	
}

function showCommentReminder(__totalNum){
	$("commentNum").innerText = __totalNum;
	$("commentText").innerText = ["点赞成功","点衰成功"][commentType -1];
	$("commentType").innerText =  ["点赞","点衰"][commentType -1];
	$("commentReminder").style.visibility = "visible";
	areaFocus = 5;
}

function hideCommentReminder(){
	$("commentReminder").style.visibility = "hidden";
	areaFocus = 0;
}

var bottonImgs = [["images/newVodhd/pushbtn_share0.png","images/newVodhd/pushbtn_share1.png"],["images/newVodhd/pushbtn_zuiju0.png","images/newVodhd/pushbtn_zuiju1.png"],["images/newVodhd/pushbtn_zan0.png","images/newVodhd/pushbtn_zan1.png"],["images/newVodhd/pushbtn_shuai0.png","images/newVodhd/pushbtn_shuai1.png"]];
function setFocusStyle(__type,__hideFocus){//type:0是失去焦点，1是获取焦点
	if(__type == 0){
		if(areaFocus == 0){
			$("botton"+bottonPos).src = bottonImgs[bottonPos][0];
		}else if(areaFocus == 1){
			$("jishuBotton"+jishuBottonPos).style.color = "#000000";
			$("jishuBotton"+jishuBottonPos).style.backgroundColor = "transparent";	
		}else if(areaFocus == 2){
			$("jishuNum"+jishuShowList.focusPos).style.backgroundColor = "transparent";	
			$("jishuNum"+jishuShowList.focusPos).style.color = "#000000";
		}else if(areaFocus == 3){
			var tempName = iPanel.misc.interceptString(vodList[posterBox.position].name,12);
			$("posterName"+posterBox.focusPos).innerText = tempName;
			$("posterName"+posterBox.focusPos).style.color = "#000000";
			if(__hideFocus == 1) $("posterFocus").style.visibility = "hidden";
		}
	}else{
		if(areaFocus == 0){
			$("botton"+bottonPos).src = bottonImgs[bottonPos][1];
		}else if(areaFocus == 1){
			$("jishuBotton"+jishuBottonPos).style.color = "#FFFFFF";
			$("jishuBotton"+jishuBottonPos).style.backgroundColor = "#a50100";	
		}else if(areaFocus == 2){
			$("jishuNum"+jishuShowList.focusPos).style.backgroundColor = "#a50100";	
			$("jishuNum"+jishuShowList.focusPos).style.color = "#ffffff";
		}else if(areaFocus == 3){
			setListStyle();
			$("posterName"+posterBox.focusPos).style.color = "#ffffff";
			if(__hideFocus == 1) $("posterFocus").style.visibility = "visible";
		}
	}
}

//设置列表样式
function setListStyle() {
	var tempList = vodList[posterBox.position];
	var name = tempList.name;
	var tempName = iPanel.misc.interceptString(name,12);
	if (name != tempName) {
		$("posterName"+posterBox.position).innerHTML = "<marquee style=\"width:120px;height:47px;\">" + name + "</marquee>";
	}
	else {
		$("posterName"+posterBox.position).innerText = tempName;
	}
}	

function do_back() {
	if(EPGflag == "EPGflag" || proFlag == "proFlag" || newSTBflag == "newSTBflag") {
		window.location.href = iPanel.eventFrame.portalUrl;
	}else{
		window.location.href = "<%=turnPage.go(-1)%>";
	}
}
	

/**从书签处播放 */
function tip_fromBookmarkPlay()
{
	var tempTime = domark(subList[jishuShowList.position].vodId);
	
	E.sitcom_infos = typeId+",14,"+parentId+","+jishuShowList.position;
	var typeurl = "SaveCurrFocus.jsp?currFoucs=" + areaFocus + "," + jishuShowList.position + "," + (jishuShowList.currPage-1) + ","+ 0 + "&url=";
	$("data_ifm").src = typeurl+ "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId="+typeId + "&playType=14&parentVodId="+parentId 
						+"&progId="+subList[jishuShowList.position].vodId + "&contentType=0&startTime="+tempTime+"&business=1";
}
//普通播放
function tip_fromBeginPlay()
{
	var tempTime = domark(subList[jishuShowList.position].vodId);
	
	E.sitcom_infos = typeId+",11,"+parentId+","+jishuShowList.position;
	var typeurl = "SaveCurrFocus.jsp?currFoucs=" + areaFocus + "," + jishuShowList.position + "," + (jishuShowList.currPage-1) + ","+ 0 + "&url=";

	$("data_ifm").src = typeurl+"/EPG/jsp/defaultHD/en/Authorization.jsp?typeId="+typeId + "&playType=11&parentVodId="+parentId 
						+"&progId="+subList[jishuShowList.position].vodId + "&contentType=0&startTime=0&business=1";
}


</script>

</head>

<body background="images/newVodhd/detail_bg.jpg" leftmargin="0" topmargin="0" onLoad="init();">

<div style="position:absolute; left:50px; top:55px; width:268px; height:366px;"><img id="poster" src="" width="268" height="366" /></div>
<div style="position:absolute; left:346px; top:45px; width:934px; height:50px; background:url(images/newVodhd/line1.png) no-repeat left bottom;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td style="font-size:34px; color:#000; padding-left:10px; line-height:50px;"><span id="movieName">&nbsp;</span><span style="font-size:24px; color:#707070; padding-left:15px;" id="collectCount">&nbsp;</span></td>
      <td width="120" style="font-size:24px; color:#707070; ">豆瓣评分：</td>
      <td width="1" id="starNum"></td><!--先不显示星星-->
      <td width="100" style="font-size:24px; color:#ff8200; " id="doubanScore">&nbsp;</td>
      <td>&nbsp;</td><!--先不显示星星-->
    </tr>
  </table>
</div>
<div style="position:absolute; left:891px; top:118px; width:292px; height:84px;">
  <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" >
    <tr>
      <td width="1" ><img id="botton0" src="" width="0" height="0" /></td><!--这个版本先不要分享-->
      <td width="97"><img id="botton1" src="images/newVodhd/pushbtn_zuiju0.png" width="82" height="82" /></td>
      <td width="97"><img id="botton2" src="images/newVodhd/pushbtn_zan0.png" width="82" height="82" /></td>
      <td width="97"><img id="botton3" src="images/newVodhd/pushbtn_shuai0.png" width="82" height="82" /></td>
    </tr>
  </table>
</div>


<div style="position:absolute; left:346px; top:104px; width:833px; height:181px; overflow:hidden;">
  <table width="100%" height="181" border="0" cellspacing="0" cellpadding="0" style="font-size:18px; color:#2d2d2d;">
    <tr>
      <td height="41" style="" id="actor">&nbsp;</td>
    </tr>
    <tr>
      <td height="41" style="" id="director">&nbsp;</td>
    </tr>
    <tr>
      <td height="2" style="" id="movieType">&nbsp;</td>
    </tr>
    <tr>
      <td style="line-height:27px;" id="intr">&nbsp;</td>
    </tr>
  </table>
</div>

<div style="position:absolute; left:343px; top:297px; width:820px; height:32px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:20px; color:#000; line-height:32px; ">
    <tr>
      <td>&nbsp;</td>
      <td width="81" align="center" id="jishuBotton0">&nbsp;</td>
      <td width="81" align="center" id="jishuBotton1"></td>
      <td width="81" align="center" id="jishuBotton2"></td>
      <td width="81" align="center" id="jishuBotton3"></td>
      <td width="81" align="center" id="jishuBotton4"></td>
      <td width="81" align="center" id="jishuBotton5"></td>
      <td width="81" align="center" id="jishuBotton6"></td>
      <td width="81" align="center" id="jishuBotton7"></td>
      <td width="168" align="right" style="font-size:17px;" id="gengxin">更新至36集，共90集</td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:351px; top:339px; width:812px; height:94px;">
  <table width="100%" border="1" cellspacing="0" cellpadding="0" style="border:1px #959ea5 solid; font-size:22px; color:#000; text-align:center; ">
    <tr>
      <td width="10%" height="47" align="center" id="jishuNum0">1</td>
      <td width="10%" align="center" id="jishuNum1">2</td>
      <td width="10%" align="center" id="jishuNum2">3</td>
      <td width="10%" align="center" id="jishuNum3">4</td>
      <td width="10%" align="center" id="jishuNum4">5</td>
      <td width="10%" align="center" id="jishuNum5">6</td>
      <td width="10%" align="center" id="jishuNum6">7</td>
      <td width="10%" align="center" id="jishuNum7">8</td>
      <td width="10%" align="center" id="jishuNum8">9</td>
      <td width="10%" align="center" id="jishuNum9">10</td>
    </tr>
    <tr>
      <td height="47" align="center" id="jishuNum10">11</td>
      <td align="center" id="jishuNum11" >12</td>
      <td align="center" id="jishuNum12">13</td>
      <td align="center" id="jishuNum13">14</td>
      <td align="center" id="jishuNum14">15</td>
      <td align="center" id="jishuNum15">16</td>
      <td align="center" id="jishuNum16">17</td>
      <td align="center" id="jishuNum17">18</td>
      <td align="center" id="jishuNum18">19</td>
      <td align="center" id="jishuNum19">20</td>
    </tr>
  </table>
</div>

<!--猜你喜欢-->

<!--猜你喜欢-->
<div style="position:absolute; left:50px; top:478px; width:33px; height:145px; background:url(images/newVodhd/line3.png) no-repeat right top; font-size:22px; color:#606060; ">猜<br />你<br />喜<br />欢</div>

<div id="posterFocus" style="position:absolute; left:126px; top:456px; width:142px; height:222px; background: url(images/newVodhd/tvplove_focus.png) no-repeat left top; visibility:hidden;"></div>
<div style="position:absolute; left:132px; top:462px; width:130px; height:216px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img id="posterImg0" src="" width="130" height="176" /></td>
    </tr>
    <tr>
      <td height="40" class="tvpName" id="posterName0">&nbsp;</td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:287px; top:462px; width:130px; height:216px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img id="posterImg1" src="" width="130" height="176" /></td>
    </tr>
    <tr>
      <td height="40" class="tvpName" id="posterName1">&nbsp;</td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:442px; top:462px; width:130px; height:216px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img id="posterImg2" src="" width="130" height="176" /></td>
    </tr>
    <tr>
      <td height="40" class="tvpName" id="posterName2">&nbsp;</td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:597px; top:462px; width:130px; height:216px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img id="posterImg3" src="" width="130" height="176" /></td>
    </tr>
    <tr>
      <td height="40" class="tvpName" id="posterName3">&nbsp;</td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:752px; top:462px; width:130px; height:216px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img id="posterImg4" src="" width="130" height="176" /></td>
    </tr>
    <tr>
      <td height="40" class="tvpName" id="posterName4">&nbsp;</td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:907px; top:462px; width:130px; height:216px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img id="posterImg5" src="" width="130" height="176" /></td>
    </tr>
    <tr>
      <td height="40" class="tvpName" id="posterName5">&nbsp;</td>
    </tr>
  </table>
</div>
<div style="position:absolute; left:1062px; top:462px; width:130px; height:216px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img id="posterImg6" src="" width="130" height="176" /></td>
    </tr>
    <tr>
      <td height="40" class="tvpName" id="posterName6">&nbsp;</td>
    </tr>
  </table>
</div>


<!--点赞弹出框-->
<div style="position:absolute; left:388px; top:165px; width:518px; height:357px; background:url(images/newVodhd/popBtm0.png) no-repeat left top; visibility:hidden;" id="commentReminder">
  <div style="position:absolute; left:60px; top:70px; width:390px; height:210px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:28px; color:#4e4e4e; line-height:40px; ">
      <tr>
        <td align="center" style="font-size:40px; line-height:90px; "  id="commentText">点赞成功！</td>
      </tr>
      <tr>
        <td height="40" align="center">已有<span style="background-color:#4c4c4c; font-size:36px; color:#fff; text-align:center;" id="commentNum">68889</span>人<span id="commentType">点赞</span></td>
      </tr>
      <tr>
        <td height="80" align="center" valign="bottom"><img src="images/newVodhd/btn_return1.png" width="129" height="44" /></td>
      </tr>
    </table>
  </div>
</div>

<div id="resultReminderTips" style="position:absolute; left:388px; top:165px; width:518px; height:368px; background:url(images/newVodhd/popBtm0.png) no-repeat left top; visibility: hidden;">
  <div style="position:absolute; left:60px; top:100px; width:390px; height:180px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:28px; color:#4e4e4e; line-height:40px; ">
      <tr>
        <td align="center" style="font-size:40px; line-height:90px;" id="resultReminderText">追剧成功</td>
      </tr>
      <tr>
        <td height="80" align="center"><img src="images/newVodhd/btn_return1.png" width="129" height="44" /></td>
      </tr>
    </table>
  </div>
</div>
<iframe id="data_ifm" width="0" height="0" src=""></iframe>
<jsp:include page="showtip.jsp"></jsp:include>
</body>
</html>
