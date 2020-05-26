<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="xqycq_index_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title>zcq_index</title>
<script type="text/javascript" src="js/global.js"></script>
<script type="text/javascript" src="js/showList.js"></script>
<script type="text/javascript" src="js/ajax2.js"></script>
<script type="text/javascript">

iPanel.eventFrame.initPage(window);
E.is_HD_vod = true;
var focusArea = 7;   //焦点所在位置 
var caid = CA.card.serialNumber;
var regionNum = "";
//left: 716px; top: 441px; width: 168px; height: 167px;

var focusXYs = [[30,456,190,181],[212,456,190,181],[396,456,193,183],[582,456,190,181],[767,456,197,181],[958,294,280,344],[637,293,327,167],[637,92,327,206],[958,92,280,206],[958,92,280,206]];    //焦点框所在的坐标	,[1033,442,166,166]		

var posterData=[];
var marqueeList = [];
var topicList = [];
var typeId = "";
var vodId = 0;
var leftVodId = "";
var isComplete = true;
var svodList = [];
var videoPos = 0;

function eventHandler(eventObj,type){
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
		case "VOD_PREPAREPLAY_SUCCESS":
				media.AV.play();
				break;	
		case "EIS_VOD_PLAY_SUCCESS"	:
				break;
		case "EIS_VOD_PROGRAM_END":
		     	videoPos++;
				if(videoPos == svodList.length){
					videoPos = 0;
				}
				vodId = svodList[videoPos].vodId;
				exit_page();
				playIndexVideo();
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
	getregionNum();
	initPicData();
	media.video.setPosition(39,103,596,351);
	playIndexVideo();
	getTopicList();
	//getMarqueeList();
	getIndexFocus();
	//showMarquee();
}
//初始化数据
function initDatas(){
	svodList = vodArray;
	posterData = vodImgArray;
	//alert(posterData.length);
	focusArea = <%= focusArea%>;
	//alert("focusArea="+focusArea);
	//marqueeText = content;
//    E.marqueeText = content;
	vodId = svodList[videoPos].vodId;
	/*var tmpStr1 = window.location.search.split("?")[1];//tmpPos=3;
	if(typeof(tmpStr1)!="undefined" && tmpStr1.indexOf("tmpPos") > -1 && tmpStr1.indexOf("PREFOUCS") == -1){
		focusArea = parseInt(tmpStr1.split("=")[1]);
	}*/	
	var tmpStr1 = window.location.search.split("?")[1];//tmpPos=1,0;
	if(tmpStr1.indexOf("tmpPos") > -1 && tmpStr1.indexOf("PREFOUCS") == -1){
		//var tmpStr2 = tmpStr1.split("=")[1];
		//alert(tmpStr1);
		//focusArea = parseInt(tmpStr2.split(",")[0]);
		focusArea = parseInt(tmpStr1.split("=")[1]);
		//listPos = parseInt(tmpStr2.split(",")[1]);
	}
}

function playIndexVideo(){
	//播放选中的视频
	var url = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?typeId=-1&playType=1&progId="+vodId+"&contentType=0&business=1";
	isComplete = false;
	ajax({
		url: url,
		type: "POST",
		dataType: "html",
		onSuccess: function(html){
			var json = eval("("+html+")");
			var rtsp =json.playUrl.split("^")[4];
			media.AV.open(rtsp,"VOD");
			isComplete = true;
		},
 		onError:function(){
			iPanel.debug("index.html onError  voteAction  ");
		}
	});	
}

//江津试点
var menuData = [
			{"name":"美好九龙坡","qy":"14","url":"http://192.168.42.60/jiulp/index.html","img":"qxImg/post_01.jpg"},
			{"name":"幸福渝中","qy":"11","url":"http://192.168.33.92/tv_xfyz/","img":"qxImg/post_02.jpg"},
			{"name":"平湖万州","qy":"30","url":"http://192.168.42.60/wanzh/index.html","img":"qxImg/post_03.jpg"},
			{"name":"品位忠州","qy":"24","url":"http://192.168.42.60/zhongx/index.html","img":"qxImg/post_04.jpg"},
			{"name":"清新璧山","qy":"40","url":"http://192.168.42.60/bishan/index.html","img":"qxImg/post_05.jpg"},
			{"name":"和美潼南","qy":"22","url":"http://192.168.42.60/tongnan/index.html","img":"qxImg/post_06.jpg"},
			{"name":"滨湖开州","qy":"48","url":"http://192.168.42.60/kaizh/index.html","img":"qxImg/post_07.jpg"},
			{"name":"幸福丹乡","qy":"33","url":"http://192.168.42.60/danx/index.html","img":"qxImg/post_08.jpg"},
			{"name":"生态北碚","qy":"37","url":"http://192.168.42.60/beibei/index.html","img":"qxImg/post_09.jpg"},
			{"name":"临空渝北","qy":"12","url":"http://192.168.42.60/yubei/index.html","img":"qxImg/post_10.jpg"},
			{"name":"梯城云阳","qy":"27","url":"http://192.168.42.60/yuny/index.html","img":"qxImg/post_11.jpg"},
			{"name":"幸福万盛","qy":"18","url":"http://192.168.42.60/wansh/index.html","img":"qxImg/post_12.jpg"},
			{"name":"神奇武隆","qy":"29","url":"http://192.168.42.60/wulong/index.html","img":"qxImg/post_13.jpg"},
			{"name":"龙乡铜梁","qy":"21","url":"http://192.168.42.60/tongl/index.html","img":"qxImg/post_14.jpg"},
			{"name":"今日永川","qy":"25","url":"http://192.168.42.60/yongch/index.html","img":"qxImg/post_15.jpg"},
			{"name":"风情彭水","qy":"44","url":"http://192.168.42.60/pengsh/index.html","img":"qxImg/post_16.jpg"},
			{"name":"大美南川","qy":"42","url":"http://192.168.42.60/nanch/index.html","img":"qxImg/post_18.jpg"},
			{"name":"灵秀巫山","qy":"28","url":"http://192.168.42.60/wushan/index.html","img":"qxImg/post_19.jpg"},
			{"name":"诗橙奉节","qy":"41","url":"http://192.168.42.60/fengjie/index.html","img":"qxImg/post_20.jpg"},
			{"name":"多彩城口","qy":"39","url":"http://192.168.42.60/chengkou/index.html","img":"qxImg/post_21.jpg"},
			{"name":"和融綦江","qy":"45","url":"http://192.168.42.60/qijiang/index.html","img":"qxImg/post_22.jpg"},
			{"name":"田园梁平","qy":"43","url":"http://192.168.42.60/liangping/index.html","img":"qxImg/post_23.jpg"},
			{"name":"幸福南岸","qy":"17","url":"http://192.168.42.60/nanan/index.html","img":"qxImg/post_24.jpg"},
			{"name":"江城合川","qy":"46","url":"http://192.168.42.60/hechuan/index.html","img":"qxImg/post_25.jpg"},
			{"name":"繁荣昌盛","qy":"19","url":"http://192.168.42.60/rongchang/index.html","img":"qxImg/post_26.jpg"},
			{"name":"人文江津","qy":"49","url":"http://192.168.42.60/jiangjin/index.html","img":"qxImg/post_27.jpg"},
			{"name":"大丰大足","qy":"36","url":"http://125.62.26.149/dazu/index.html","img":"qxImg/post_28.jpg"}
			];

function getregionNum(){
	var url = "http://192.168.108.65:8080/CQSDP/user/region?cardNo="+caid;
	//http://192.168.108.65:8080/CQSDP/user/region?cardNo=9950000002581849
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		if(requestStr != ""){
			res = eval('('+requestStr+')');
			if(res.return_code == 0){
				regionNum = res.region;
				//alert("menuData.qy="+menuData.length);
				for(var i=0;i<menuData.length;i++){
					if(menuData[i].qy==regionNum){
						//if(regionNum == menuData[i].qy){
						//window.location.href = menuData[i].url;
						$("posterImg"+0).src = menuData[i].img;
						//window.location.href = menuData[i].url;
						return;
					}
			  	}
				initPicData();
			}else{
				initPicData();
			}	    
		}
	},
	function(__errorCode){
		initPicData();
	},
	5000);	
	requestAjaxObj.requestData("get");
	
}






function getTopicList(){
	//var url = "http://ipanel.vod.cqcnt.com/dvbottapp/marquee.txt";
	var url = E.pre_epg_url+"/defaultHD/en/hddb/hddb_topic.txt";
	var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
		var requestStr = __ajaxObj.responseText;
		iPanel.debug("getValidComboInfo requestStr="+requestStr);
		if(requestStr != ""){
		//alert(requestStr);
			eval("var tmpObj = "+requestStr);
			if(tmpObj.code == 200){
				topicList = tmpObj.data;
				//alert(topicList.length);
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
		$("posterImg"+i).src = posterData[i].img;
		//alert(posterData[i].name);
	}
}

//显示跑马灯
function showMarquee() {
    $("marquee").innerText = marqueeText.name;
}

function udMove(_num){
	if(_num <0){   //上
		if(focusArea==7||focusArea ==8) return;
		if(focusArea<5){
			focusArea = 6;	
		}else if(focusArea==5){
		    loseGoBackFocus();
			focusArea = 8;	
		}else if(focusArea==6){
			focusArea = 7;	
		}else if(focusArea==9){
		    loseGoBackFocus();
			$("indexFocus").style.visibility = "visible";
			focusArea = 8;	
		}
		getIndexFocus();		
	}else if(_num >0){   //下
		if(focusArea<6){
			getGoBackFocus();
			loseIndexFocus();
			focusArea = 9;
		}
		if(focusArea == 6){
			focusArea = 4;	
		}else if(focusArea==7){
			focusArea = 6;	
		}else if(focusArea==8){
			getGoBackFocus();
			loseIndexFocus();
			focusArea = 9;	
		}
		getIndexFocus();
	}
}

function lrMove(_num){
	if(_num <0){   //左
		if(focusArea ==0||focusArea ==6||focusArea ==7) return;
		if(focusArea ==1){
			focusArea = 0;	
		}else if(focusArea==2){
			focusArea = 1;	
		}else if(focusArea==3){
			focusArea = 2;	
		}else if(focusArea==4){
			focusArea =3;	
		}else if(focusArea==5){
			focusArea = 6;	
		}else if(focusArea==8){
			focusArea = 7;	
		}
		getIndexFocus();
	}else if(_num >0){   //右
		if(focusArea ==5 ||focusArea==8) return;
		if(focusArea==0){
			focusArea = 1;	
		}else if(focusArea==1){
			focusArea = 2;	
		}else if(focusArea==2){
			focusArea = 3;	
		}else if(focusArea ==3){
			focusArea = 4;	
		}else if(focusArea ==4){
			//focusArea = 5;	
		}else if(focusArea ==6){
			//focusArea =5;	
		}else if(focusArea ==7){
			focusArea =8;	
		}
		getIndexFocus();
	}		
}

function getIndexFocus(){
	$("indexFocus").style.left =  focusXYs[focusArea][0]+"px";
	$("indexFocus").style.top =  focusXYs[focusArea][1]+"px";	
	$("indexFocus").style.width =  focusXYs[focusArea][2]+"px";	
	$("indexFocus").style.height =  focusXYs[focusArea][3]+"px";		
}

function loseIndexFocus(){
	$("indexFocus").style.visibility = "hidden";
}

//底部返回首页的焦点框
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
	if(curr_url.indexOf("viewSize=SD") == -1) E.is_HD_vod = true;//cdq 进入高清应用设置为true
	else E.is_HD_vod = false;
	curr_url+="&stbid="+hardware.STB.serialNumber+"&preplayurl="+E.prePlayUrl+"&return_url="+returnUrl;//cdq 华为的VOD需要添加这些参数
	iPanel.debug("gotows curr_url="+curr_url);
	var auth_str = "User=&pwd=&ip="+network.ethernets[0].IPs[0].address+"&NTID="+network.ethernets[0].MACAddress+"&CARDID="+E.cardId+"&Version=1.0&lang=1&supportnet="+net_type+"&decodemode=H.264HD;MPEG-2HD&CA=1&ServiceGroupID="+E.ServiceGroupID+"&encrypt=0";
	curr_url = curr_url.replace("Category.jsp?url=", "Category.jsp?"+auth_str+"&viewSize=HD&url=");
	iPanel.mainFrame.location.href = curr_url;
}

function doSelect(){
	switch(focusArea){
		case 7:
				for(var i=0;i<menuData.length;i++){
					if(menuData[i].qy==regionNum){
						//if(regionNum == menuData[i].qy){
						//window.location.href = menuData[i].url;
						//$("posterImg"+0).src = menuData[i].img;
						var tmpUrl =  E.pre_epg_url+"/defaultHD/en/hddb/new_qycq/xqycq_index.jsp?tmpPos="+focusArea;
						//alert("tmpUrl ="+tmpUrl);
						//alert( menuData[i].url+"?backUrl="+tmpUrl);
						window.location.href = menuData[i].url+"?backUrl="+tmpUrl;
						return;
					}
			  	}
				//alert(topicList.length);
				var baseurl = focusURL();
				var pos = focusArea == 4?4:(focusArea == 5?3:(focusArea == 6?2:(focusArea == 7?0:(focusArea == 8?1:4))));
				var currName = 	posterData[pos].name;
				for(var i=0;i<topicList.length;i++){
					if(currName == topicList[i].name){
						//alert(currName);
						if(topicList[i].url.indexOf("wasu") == -1){
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
				typeId = posterData[pos].typeId;
				vodId = posterData[pos].vodId;
				var playType = posterData[pos].playType;
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
				break;
		
		
		case 5:
		
		case 6:	
		
		case 8:
			var baseurl = focusURL();
			var pos = focusArea == 4?4:(focusArea == 5?3:(focusArea == 6?2:(focusArea == 7?0:(focusArea == 8?1:4))));
			var currName = 	posterData[pos].name;
			for(var i=0;i<topicList.length;i++){
				if(currName == topicList[i].name){
					if(topicList[i].url.indexOf("wasu") == -1){
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
			typeId = posterData[pos].typeId;
			vodId = posterData[pos].vodId;
			var playType = posterData[pos].playType;
			if (typeId != '' && vodId != 0) {
				play_movie(playType);
			}
			break;
		case 0:
			var baseurl = focusURL();
			window.location.href = baseurl + "qycq_list.jsp?typeId=10000100000000090000000000106175&menuPos=0";
			break;
		case 1:  
			var baseurl = focusURL();
			window.location.href = baseurl + "qycq_list.jsp?typeId=10000100000000090000000000106179&menuPos=1"; 
			break;
		case 2:  
			var rfbackUrl =  E.pre_epg_url+"/defaultHD/en/hddb/new_qycq/xqycq_index.jsp?tmpPos="+focusArea;
			window.location.href = "http://125.62.26.149/renfang/index.html?backUrl="+rfbackUrl;
			break;
		case 3:
			var baseurl = focusURL();
			window.location.href = baseurl + "qycq_list.jsp?typeId=10000100000000090000000000106184&menuPos=2"; 
			break;
		case 4:	
			var baseurl = focusURL();
			window.location.href = baseurl + "xqycq_qxhc.jsp";
			//window.location.href = baseurl + columnData[columnPos-1].url
			break;
		case 9:
			doMenu();
			break;
	}
}
//打开菜单
function doMenu(){
//支持应用在andriod盒子返回首页
    if(iPanel.eventFrame.systemId == 1){
        iPanel.eventFrame.exitToHomePage();
    }else{
        //原代码返回首页
        iPanel.mainFrame.location.href = iPanel.eventFrame.portal_url;
    }
}
//返回
function doBack() {
	doMenu();
}
/**节目播放，跳到授权页面  */
function play_movie(playType) {
    if (playType == 1) {
        //如果是电视剧
        window.location.href = focusURL() + "../hjzq/hj_tvDetail.jsp?vodId="+vodId+"&typeId="+typeId;
    } else {
        //电影直接播放
        getAuthUrl(vodId);
    }
}

function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs="+focusArea+"&url=";
    return baseurl;
}

function exit_page() {
	DVB.stopAV(0);
	media.AV.close();
}
/**从书签处播放 */
function tip_fromBookmarkPlay() {
    var tempTime = domark(vodId);
    var baseurl = focusURL();
	iPanel.debug("index_ifeng baseurl=="+baseurl);
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&baseFlag=0&contentType=0&startTime=" + tempTime + "&business=1";
}
/* tipsWindow.jsp中getAuthUrl()方法调用，从开始处播放 */
function tip_fromBeginPlay() {
    var baseurl = focusURL();
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&baseFlag=0&contentType=0&business=1";
}
</script>
</head>
<body style="background: url(img/bg.png) no-repeat;" onLoad="init()" onUnload="exit_page()";>
	<div style="position: absolute; top: 54px; left: 50px; font-size: 30px; color: #ffffff; width: 143px; height: 31px;">全域重庆</div>
	<div style="position: absolute; top: 101px; left: 39px; width: 596px; height: 351px; id="video"> </div>
	<div style="position:absolute; left:645px; top:100px; width:311px; height:190px;"><img id="posterImg0" src="" width="311" height="190" /></div>
	<img src="" style="position: absolute; top: 100px; left: 645px;"/>
	<div style="position:absolute; left:966px; top:100px; width:264px; height:190px;"><img id="posterImg1" src="" width="264" height="190" /></div>
	<div style="position:absolute; left:645px; top:301px; width:311px; height:151px;"><img id="posterImg2" src="" width="311" height="151" /></div>
	<img src="" style="position: absolute; top: 301px; left: 645px;"/>
	<div style="position:absolute; left:966px; top:301px; width:264px; height:328px;"><img id="posterImg3" src="" width="264" height="328" /></div>
	<div id="indexFocus" style="position: absolute; left: 30px; top: 457px; width: 189px; height: 180px;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="8" height="8" style="background:#ffbb00;"></td>
            <td style=" background:#ffbb00;"></td>
            <td width="8" style=" background:#ffbb00;"></td>
          </tr>
          <tr>
            <td style="background:#ffbb00;"></td>
            <td></td>
            <td style="background:#ffbb00;"></td>
          </tr>
          <tr>
            <td height="8" style="background:#ffbb00;"></td>
            <td style="background:#ffbb00;"></td>
            <td style="background:#ffbb00;"></td>
          </tr>
       </table>
  </div>
	<img src="img/pic_06.png" width="174" height="165" style="position: absolute; top: 464px; left: 38px;">
	<img src="img/pic_07.png" width="174" height="165" style="position: absolute; top: 464px; left: 220px;">
	<img src="img/renfang.jpg" width="174" height="165" style="position: absolute; top: 464px; left: 405px;">
	<img src="img/pic_08.png" width="174" height="165" style="position: absolute; top: 464px; left: 590px;">
	<div style="position:absolute; left:775px; top:464px; width:181px; height:165px;"><img src="img/pic_09.png" width="181" height="165" /></div>
<!--news-->
<div style="position:absolute; left:2px; top:648px; width:1228px; height:40px;background:url(img/bg_bottom.png); ">
  <table width="1225" height="40" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="66" height="40"><span style="font-size:22px;"><img src="img/volumm.png" width="27" height="27" style="position: absolute; left: 30px; top: -9px; width: 33px;"/></span></td>
			<td width="1012" style="font-size:22px;">
			<marquee id="marquee" style="color:#e7e4e4";>尊敬的用户，即日起可通过301直播快捷键进入全域重庆点播平台首页，通过302直播快捷键或全域重庆点播平台首页进入各区县点播平台。由此给您带来的不便，敬请谅解 ，详询96868</marquee></td>
			<td id="footBtn" width="147" align="center" style="background:#6b6e76; font-size:28px; color:#fff;"> 首页</td>
		  </tr>
  </table>
</div>
<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="../showtip.jsp"></jsp:include>
</body>
</html>