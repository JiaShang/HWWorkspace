<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="xqycq_qxhc_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title>xqycq_index</title>
<script type="text/javascript" src="js/global2.js"></script>
<script type="text/javascript" src="js/showList.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript">

iPanel.eventFrame.initPage(window); 
var menuData = [
			{"name":"���þ�����","img":"img/post_01.png","url":"http://192.168.42.60/jiulp/index.html"},
			{"name":"ĸ������","img":"img/post_02.png","url":"http://125.62.26.149/yuzhong/index.html"},
			{"name":"ƽ������","img":"img/post_03.png","url":"http://192.168.42.60/wanzh/index.html"},
			{"name":"Ʒλ����","img":"img/post_04.png","url":"http://192.168.42.60/zhongx/index.html"},
			{"name":"�����ɽ","img":"img/post_05.png","url":"http://192.168.42.60/bishan/index.html"},
			{"name":"��������","img":"img/post_06.png","url":"http://192.168.42.60/tongnan/index.html"},
			{"name":"��������","img":"img/post_07.png","url":"http://192.168.42.60/kaizh/index.html"},
			{"name":"�Ҹ�����","img":"img/post_08.png","url":"http://192.168.42.60/danx/index.html"},
			{"name":"��̬����","img":"img/post_09.png","url":"http://192.168.42.60/beibei/index.html"},
			{"name":"�ٿ��山","img":"img/post_10.png","url":"http://192.168.42.60/yubei/index.html"},
			{"name":"�ݳ�����","img":"img/post_11.png","url":"http://192.168.42.60/yuny/index.html"},
			{"name":"�Ҹ���ʢ","img":"img/post_12.png","url":"http://192.168.42.60/wansh/index.html"},
			{"name":"������¡","img":"img/post_13.png","url":"http://192.168.42.60/wulong/index.html"},
			{"name":"����ͭ��","img":"img/post_14.png","url":"http://192.168.42.60/tongl/index.html"},
			{"name":"��������","img":"img/post_15.png","url":"http://192.168.42.60/yongch/index.html"},
			{"name":"������ˮ","img":"img/post_16.png","url":"http://192.168.42.60/pengsh/index.html"},
			{"name":"�����ϴ�","img":"img/post_18.png","url":"http://192.168.42.60/nanch/index.html"},
			{"name":"������ɽ","img":"img/post_19.png","url":"http://192.168.42.60/wushan/index.html"},
			{"name":"ʫ�ȷ��","img":"img/post_20.png","url":"http://192.168.42.60/fengjie/index.html"},
			{"name":"��ʳǿ�","img":"img/post_21.jpg","url":"http://192.168.42.60/chengkou/index.html"},
			{"name":"�����뽭","img":"img/post_22.jpg","url":"http://192.168.42.60/qijiang/index.html"},
			{"name":"��԰��ƽ","img":"img/post_23.png","url":"http://192.168.42.60/liangping/index.html"},
			{"name":"�Ҹ��ϰ�","img":"img/post_24.png","url":"http://192.168.42.60/nanan/index.html"},
			{"name":"���Ǻϴ�","img":"img/post_25.png","url":"http://192.168.42.60/hechuan/index.html"},
			{"name":"���ٲ�ʢ","img":"img/post_26.png","url":"http://192.168.42.60/rongchang/index.html"},
			{"name":"���Ľ���","img":"img/post_27.png","url":"http://192.168.42.60/jiangjin/index.html"},
			{"name":"������","img":"img/post_28.png","url":"http://125.62.26.149/dazu/index.html"}
			];
var listBox = null;
var listPos = 0;
var focusArea = 0;

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
	initDatas();
	showMenuData();
	
}

//��ʼ������
function initDatas() {
	focusArea = <%= focusArea%>;
	listPos = <%= listPos%>;
	
	var tmpStr1 = window.location.search.split("?")[1];//tmpPos=1,0;
	if(tmpStr1.indexOf("tmpPos") > -1 && tmpStr1.indexOf("PREFOUCS") == -1){
		var tmpStr2 = tmpStr1.split("=")[1];
		focusArea = parseInt(tmpStr2.split(",")[0]);
		listPos = parseInt(tmpStr2.split(",")[1]);
	}
}
/*function showPageInfo(){
	$("currPageTxt").innerText = listBox.currPage;	
	$("totalPageTxt").innerText = listBox.listPage;	
}*/


function udMove(_num){
	if(focusArea == 0){
		changeListUD(_num);
	}
}

function lrMove(_num){
	if(focusArea == 0){
		changeListLR(_num);
	}else if(focusArea ==1){
		if(_num <0){
			focusArea = 0;
			loseGoTopFocus();
			getListFocus();	
		}
	}	
}


function changeListUD(_num){
	//if(_num <0 && listBox.position<5) return;
	//if(_num >0 && ((listBox.position+5) >(menuData.length-1))) return;
	//loseListFocus();
	/*if(listBox.focusPos <5&&_num <0){
		listBox.changePage(_num);
		//showPageInfo();		
		getListFocus();		
		return;	
	}*/
	
	if((listBox.focusPos>14&&listBox.focusPos<20)&&_num >0){
		listBox.changePage(_num);
		//showPageInfo();		
		//listBox.focusPos==listBox.focusPos-15;
		getListFocus();		
		return;
	}
	
	if(_num <0){
		_num = -5;
	}else if(_num>0){
		_num = 5;
	}
	listBox.changeList(_num);	
	getListFocus();
}



function changeListLR(_num){
	if(_num <0 &&(listBox.focusPos==0||listBox.focusPos ==5||listBox.focusPos ==10||listBox.focusPos ==15)) return;
	if(_num >0 &&(listBox.focusPos==4||listBox.focusPos ==9||listBox.focusPos ==14||listBox.position ==(menuData.length-1))){
		focusArea = 1;
		loseListFocus();
		getGoTopFocus();
		return;		
	}
	loseListFocus();
	listBox.changeList(_num);	
	getListFocus();
}


function showMenuData(){
	listBox = new showList(20, menuData.length, listPos, 69, window);
	listBox.listHigh = 204;
	listBox.showType  = 0;
	listBox.haveData = function(List){
		$("listName" + List.idPos).style.visibility = "visible";
		$("listName" + List.idPos).innerText = menuData[List.dataPos].name;	
		$("listImg" + List.idPos).src = menuData[List.dataPos].img;
	};
	listBox.notData = function(List){
		$("listName" + List.idPos).style.visibility = "hidden";
		$("listImg" + List.idPos).src = "";
	};
	listBox.startShow();	
	initScroll();
	getListFocus();
}

function getListFocus(){
	$("listFocus").style.visibility = "visible";
	if(listBox.focusPos>=0&&listBox.focusPos<5){
		$("listFocus").style.top = "101px";
		$("listFocus").style.left = 47+(listBox.focusPos*227)+"px";	
	}else if(listBox.focusPos>4&&listBox.focusPos<10){
		$("listFocus").style.top = "250px";
		$("listFocus").style.left = 47+((listBox.focusPos-5)*227)+"px";		
	}else if(listBox.focusPos>9&&listBox.focusPos<15){
		$("listFocus").style.top = "399px";
		$("listFocus").style.left = 47+((listBox.focusPos-10)*227)+"px";		
	}else if(listBox.focusPos>14&&listBox.focusPos<20){
		$("listFocus").style.top = "549px";
		$("listFocus").style.left = 47+((listBox.focusPos-15)*227)+"px";		
	}	
	scrollChange();
	setListStyle(true);
}

function loseListFocus(){
	$("listFocus").style.visibility = "hidden";	
	setListStyle(false);
}

function getGoTopFocus(){
	$("topBtn").src= "img/btn_top02.jpg";	
}


function loseGoTopFocus(){
	$("topBtn").src = "img/btn_top01.jpg";	
}



//������
function initScroll(){
	scrollBar = new ScrollBar("scrollBar");
	scrollBar.init(Math.ceil(listBox.dataSize/listBox.listSize),1, 410, 0);
		if(listBox.dataSize == 0){
		}else{
		scrollChange();
	}
}

function scrollChange(){	//��ʾ��ǰҳ�������ܹ�ҳ����
	scrollBar.scroll(listBox.currPage-1);
	$("scrollBar").innerHTML = listBox.currPage+'<br/>'+listBox.listPage;
}


function doSelect(){
	if(focusArea ==0){
		var tmpUrl =  E.pre_epg_url+"/defaultHD/en/hddb/new_qycq/xqycq_qxhc.jsp?tmpPos="+focusArea+","+listBox.position;
		//alert("tmpUrl ="+tmpUrl);
		//window.location.href = menuData[menuBox.position].url+"?backUrl="+tmpUrl;
		window.location.href = menuData[listBox.position].url+"?backUrl="+tmpUrl;
	}else if(focusArea ==1){
		focusArea = 0;
		listPos = 0;
		loseGoTopFocus();
		showMenuData();
		getListFocus();	
	}	
}

function doMenu() {
	if(iPanel.eventFrame.systemId == 1){
        iPanel.eventFrame.exitToHomePage();
    }else{
        //ԭ���뷵����ҳ
        E.marqueeText = null;
    	iPanel.mainFrame.location.href = E.portal_url;
    }
}

//ɾ��
function doBack() {
     //window.location.href = "//=turnPage.go(-1)%>";
	 window.location.href =E.pre_epg_url+"/defaultHD/en/hddb/new_qycq/xqycq_index.jsp?tmpPos=4";
}

function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs="+focusArea+","+listBox.position+"&url=";
    return baseurl;
}
</script>
</head>
<body style="background: url(img/bg_02.jpg) no-repeat;" onLoad="init()">
	<!--������Ϣ-->
	<div style="position: absolute; top: 54px; left: 50px; font-size: 30px; color: #ffffff;">ȫ���������������</div>
	<!--��һ��-->
	<div style="position: absolute; top: 105px; left: 50px; width: 219px; height: 122px;">
	<img id="listImg0"/>
		<div  id="listName0" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 105px; left: 278px; width: 219px; height: 122px;">
	<img id="listImg1"/>
		<div  id="listName1" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 105px; left: 505px; width: 219px; height: 122px;">
	<img id="listImg2"/>
		<div  id="listName2" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 105px; left: 732px; width: 219px; height: 122px;">
	<img id="listImg3"/>
		<div  id="listName3" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 105px; left: 959px; width: 219px; height: 122px;">
	<img id="listImg4"/>
		<div  id="listName4" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<!--�ڶ���-->
	<div style="position: absolute; top: 254px; left: 50px; width: 219px; height: 122px;">
	<img id="listImg5"/>
		<div  id="listName5" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
</div>
	<div style="position: absolute; top: 254px; left: 278px; width: 219px; height: 122px;">
	<img id="listImg6"/>
		<div  id="listName6" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 254px; left: 505px; width: 219px; height: 122px;">
	<img id="listImg7"/>
		<div  id="listName7" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 254px; left: 732px; width: 219px; height: 122px;">
	<img id="listImg8"/>
		<div  id="listName8" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 254px; left: 959px; width: 219px; height: 122px;">
	<img id="listImg9"/>
		<div  id="listName9" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<!--������-->
	<div style="position: absolute; top: 403px; left: 50px; width: 219px; height: 122px;">
	<img id="listImg10"/>
	<div  id="listName10" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
</div>
	<div style="position: absolute; top: 403px; left: 278px; width: 219px; height: 122px;">
	<img id="listImg11"/>
		<div  id="listName11" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 403px; left: 505px; width: 219px; height: 122px;">
	<img id="listImg12"/>
		<div  id="listName12" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 403px; left: 732px; width: 219px; height: 122px;">
	<img id="listImg13"/>
		<div  id="listName13" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 403px; left: 959px; width: 219px; height: 122px;">
	<img id="listImg14"/>
		<div  id="listName14" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<!--������-->
	<div style="position: absolute; top: 552px; left: 50px; width: 219px; height: 122px;">
	<img id="listImg15"/>
		<div  id="listName15" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
</div>
	<div style="position: absolute; top: 552px; left: 278px; width: 219px; height: 122px;">
	<img id="listImg16"/>
		<div  id="listName16" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 552px; left: 505px; width: 219px; height: 122px;">
	<img id="listImg17"/>
		<div  id="listName17" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 552px; left: 732px; width: 219px; height: 122px;">
	<img id="listImg18"/>
		<div  id="listName18" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<div style="position: absolute; top: 552px; left: 959px; width: 219px; height: 122px;">
	<img id="listImg19"/>
		<div  id="listName19" style="position: absolute; height:30px; line-height:30px; text-align:center;color:#FFFFFF;top: 90px; left: 3px; background: url(img/post_cover.png); width: 214px; height: 30px;"></div>
	</div>
	<!--ҳ����Ϣ-->
	<div style="position:absolute;left:1218px;top:106px; width:1px; height:495px; background:#c8c8c8;">
  <div id="scrollBar" style="position:absolute;left:-13px;top:-29px; width:26px; height:56px; background:url(img/qycq_top.png); font-size:21px; color:#fff; text-align:center; line-height:28px;"><span>1</span><br/>
  <span>1</span></div>
    <div style="position:absolute;left:-14px;top:475px; width:30px; height:80px; "><img id="topBtn" src="img/btn_top01.jpg" width="30" height="80"></div>
</div>
<!--����-->
<div id="listFocus" style="position: absolute; left: 47px; top: 101px; width: 226px; height: 130px;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="4" height="4" style="background:#fff000;"></td>
		<td style=" background:#fff000;"></td>
		<td width="4" style=" background:#fff000;"></td>
	</tr>
	<tr>
		<td style=" background:#fff000;"></td>
		<td></td>
		<td style=" background:#fff000;"></td>
	</tr>
	<tr>
		<td height="4" style="background:#fff000;"></td>
		<td style=" background:#fff000;"></td>
		<td style=" background:#fff000;"></td>
	</tr>
</table>
</div>
</body>
</html>
