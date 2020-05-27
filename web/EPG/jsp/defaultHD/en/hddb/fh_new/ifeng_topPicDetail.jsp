<%@ page contentType="text/html; charset=GBK" language="java" %>

<%@ include file="ifeng_topPicDetail_data.jsp" %>

<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>

<meta name="page-view-size" content="1280*720">

<title>tvDetail</title>



<script type="application/javascript" src="js/showList.js"></script>

<script type="application/javascript" src="js/ajax.js"></script>

<script type="application/javascript" src="js/global.js"></script>

<script>

iPanel.eventFrame.initPage(window);



var focusArea = 1;   // 0 按钮操作区  1推荐列表

var listFocusPos = 1;

var buttonPic = [["img/btn_zan01.png","img/btn_zan02.png"],  ["img/btn_zan_ok01.png","img/btn_zan_ok02.png"]];

var commentType = 0;//1点赞操作，3 取消点赞操作



var tipsShowFlag = false;

var reminderTimeout = -1;

var typeId = "";

var vodId = 0;



var vodList = [{vodID:1,name:"1200",img:"img/index_poster01.jpg"},

	{vodID:1,name:"1300",img:"img/index_poster02.jpg"},

	{vodID:1,name:"1400",img:"img/index_poster03.jpg"},

	{vodID:1,name:"1500",img:"img/index_poster01.jpg"},

	{vodID:1,name:"1600",img:"img/index_poster02.jpg"},

	{vodID:1,name:"1700",img:"img/index_poster03.jpg"},

	{vodID:1,name:"1800",img:"img/index_poster01.jpg"},

	{vodID:1,name:"1900",img:"img/index_poster02.jpg"},

	{vodID:1,name:"1700",img:"img/index_poster03.jpg"},

	{vodID:1,name:"1100",img:"img/index_poster01.jpg"},

	{vodID:1,name:"1200dierye",img:"img/index_poster01.jpg"},

	{vodID:1,name:"1300",img:"img/index_poster02.jpg"},

	{vodID:1,name:"1400",img:"img/index_poster03.jpg"},

	{vodID:1,name:"1100",img:"img/index_poster01.jpg"},

	{vodID:1,name:"1500",img:"img/index_poster02.jpg"},

	{vodID:1,name:"1100",img:"img/index_poster03.jpg"},

	{vodID:1,name:"1600",img:"img/index_poster01.jpg"},

	{vodID:1,name:"1100",img:"img/index_poster02.jpg"},

	{vodID:1,name:"1700",img:"img/index_poster03.jpg"},

	{vodID:1,name:"1100",img:"img/index_poster01.jpg"}];

var listBox = null;

var listData = [{vodID:1,name:"1200",img:"img/tu01.png"},

	{vodID:1,name:"1300",img:"img/tu02.png"},

	{vodID:1,name:"1400",img:"img/tu03.png"},

	{vodID:1,name:"1500",img:"img/tu04.png"},

	{vodID:1,name:"1600",img:"img/tu01.png"},

	{vodID:1,name:"1700",img:"img/tu02.png"},

	{vodID:1,name:"1800",img:"img/tu03.png"},

	{vodID:1,name:"1900",img:"img/tu04.png"},

	{vodID:1,name:"1700",img:"img/tu01.png"},

	{vodID:1,name:"1100",img:"img/tu02.png"},

	{vodID:1,name:"1200dierye",img:"img/tu03.png"}];









function eventHandler(eventObj, type) {

	if (type == 1 && key_flag == 2) {//点播播放，去进行节目授权

        return 0;

    } else if (type == 1 && key_flag == 1) {//有提示框弹出来

        return tipkeypress(eventObj);

    } else {	

		switch(eventObj.code){

			case "KEY_UP": //up

				//udMove(-1);			

				break;

			case "KEY_DOWN": //down

				//udMove(1);	 	

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

	//initTopObj()

	initPosterList();

	initFocus();

	//initButtonPic();

	initMovieInfo();

}



//初始化数据

function initDatas(){

	listData = vodImgArray;

	

	focusArea = <%= focusArea%>;

	listFocusPos = <%= listFocusPos%>;

}



function initFocus(){

	switch(focusArea){

		case 0:

			//$("zanButton").src=buttonPic[commentType][1]

			break;

		case 1:

			showPostorFocus();

			break;

	

	}

	

}



function initMovieInfo(){

	$("posterName").innerText = typeInfoData[0].name;//iPanel.misc.interceptString(typeInfoData[0].name,16);

//	$("des").innerText = typeInfoData[0].intr;

	$("posterBg").style.background = typeInfoData[0].img; /*海报路径*/

	

}





function initButtonPic(){

	

}





function initTopObj(){

	for(var i = 0 ; i < 5;i++){

		$("divMenu"+i).style.webkitTransitionDuration = "200ms";

	}

}

function initPosterList(){

	listData.unshift({vodID:"",name:"",img:""})

	listData.push({vodID:"",name:"",img:""})

	listBox = new showList(6,listData.length,listFocusPos,0,window);//把0改成E.menuPos_dx

	listBox.focusPos=1;

	listBox.pageType=2;

	listBox.showType=1;

	listBox.haveData = haveData ;

	listBox.notData=function(list){

		$("postor"+list.idPos).src = "img/global_tm.gif";

		$("name"+list.idPos).innerText = "";

		$("textFocus"+list.idPos).innerText = "";

		//$("divMenu"+list.idPos).style.backgroundImage = "none";

		$("imgFocus"+list.idPos).style.background = "url(img/global_tm.gif)";

	}

	listBox.showLoop=false;

	listBox.startShow();

}

function showPostorFocus(){

	if(listBox.position > 4){

		$("firstLine").style.visibility = "visible";

	}

	//$("divMenu"+listBox.focusPos).style.backgroundImage = "url(img/starRec_btm02.png)";

	$("imgFocus"+listBox.focusPos).style.background = "url(img/dian-fous.png)";

	$("name"+listBox.focusPos).style.color = "#fff000";

	$("textFocus"+listBox.focusPos).style.color = "#fff000";

}

function hidePostorFocus(){

	//$("divMenu"+listBox.focusPos).style.backgroundImage = "url(img/starRec_btm01.png)";

	$("imgFocus"+listBox.focusPos).style.background = "url(img/dian.png)";

	$("name"+listBox.focusPos).style.color = "#999999";

	$("textFocus"+listBox.focusPos).style.color = "#999999";

}

function haveData(list){

	if(list.dataPos==0){

		$("firstLine").style.visibility = "hidden";

		$("name"+list.idPos).innerText = "";

		$("textFocus"+list.idPos).innerText = "";

		$("postor"+list.idPos).src = "img/global_tm.gif";

		$("imgFocus"+list.idPos).style.background = "url(img/global_tm.gif)";

	}else if(list.dataPos == listData.length-1){

		//$("firstLine").style.visibility = "visible";

		$("lastLine").style.visibility = "hidden";

		$("name"+list.idPos).innerText = "";

		$("textFocus"+list.idPos).innerText = "";

		$("postor"+list.idPos).src = "img/global_tm.gif";

		$("imgFocus"+list.idPos).style.background = "url(img/global_tm.gif)";

		//$("divMenu"+list.idPos).style.backgroundImage = "none";

	}else{

		$("lastLine").style.visibility = "visible";

		$("imgFocus"+list.idPos).style.background = "url(img/dian.png)";

		$("postor"+list.idPos).src = listData[list.dataPos].img;

		$("name"+list.idPos).innerText = listData[list.dataPos].name;

		$("textFocus"+list.idPos).innerText = listData[list.dataPos].intr;

		//$("divMenu"+list.idPos).style.backgroundImage = "url(img/starRec_btm01.png)";

	}

}









function changePostorList(__num){

	if(listBox.position == 1 && __num < 0) {

		return;

	}else if(listBox.position==listData.length-2&&__num>0) {

		return;

	}else if(listBox.focusPos==1&&listBox.position>0&&__num<0) {

		//alert(1);

		listBox.position+=__num;

		listBox.focusPos=1;

		listBox.changeFocus(0);

		listBox.startShow();

	}else if(listBox.focusPos==4&&listBox.position<listData.length-2&&__num>0) {

		//alert(1);

		listBox.position+=__num;

		listBox.focusPos=4;

		listBox.changeFocus(0);

		listBox.startShow();

	}else{

		hidePostorFocus();

		listBox.changeList(__num);

	}

	showPostorFocus();	

}

function lrMove(__num){

	switch(focusArea){

		case 1:

			changePostorList(__num);	

			break;

		case 2:

			changeBottomButton();

			break;

	}	

}



/*function udMove(__num){

	switch(focusArea){

		case 0:

			if(__num>0){

				focusArea=1;

				$("zanButton").src=buttonPic[commentType][0]

				showPostorFocus()

			}

			break;

		case 1:

			if(__num<0){

				focusArea=0;

				hidePostorFocus()	

				$("zanButton").src=buttonPic[commentType][1];

			}else{

				focusArea=2;

				hidePostorFocus()	

				showButton();

			}

			break;

		case 2:

			if(__num<0){

				focusArea=1;

				showPostorFocus()

				hideButton();

			}

			break;

	}

}*/

/*var buttonBottomPic=[["img/btn_return11.png","img/btn_return12.png"],["img/btn_index11.png","img/btn_index12.png"]];

var buttonBottomPos=0;

function changeBottomButton(){

	$("button"+buttonBottomPos).src=buttonBottomPic[buttonBottomPos][0];

	buttonBottomPos=buttonBottomPos^1;

	$("button"+buttonBottomPos).src=buttonBottomPic[buttonBottomPos][1];

}

function showButton(){

	$("button"+buttonBottomPos).src=buttonBottomPic[buttonBottomPos][1];

}

function hideButton(){

	$("button"+buttonBottomPos).src=buttonBottomPic[buttonBottomPos][0];

}*/

function doSelect(){

	if(focusArea == 0){

		//commentType=commentType^1;

		//$("zanButton").src=buttonPic[commentType][1]

	}else if(focusArea==1){

		var baseurl = focusURL();

		var pos = listBox.position;

		if(listData[pos].playType != 1){

			typeId = listData[pos].typeId;

			vodId = listData[pos].vodId;

			var playType = listData[pos].playType;

			if (typeId != '' && vodId != 0) {

				play_movie(playType);

			}

		}else if(listData[pos].playType == 1){

			window.location.href = baseurl+"ifeng_tvDetail.jsp?vodId="+listData[pos].vodId+"&typeId="+listData[pos].typeId;

		}	

	}else{

		if(buttonBottomPos == 0){

			doBack();

		}else{

			doMenu();

		}

	}

}







/*------按钮操作部分 start -----*/







//打开菜单

function doMenu() {

    E.marqueeText = null;

    iPanel.mainFrame.location.href = "ifeng_index.jsp";

}





//删除

function doBack() {	
		window.location.href = "<%=turnPage.go(-1)%>";
}



function focusURL() {

    var baseurl = "SaveCurrFocus.jsp?currFoucs="+focusArea+","+listBox.position+"&url=";

    return baseurl;

}

function exit_page(){

}



/**节目播放，跳到授权页面  */

function play_movie(playType) {

    if (playType == 1) {

        //如果是电视剧

       // window.location.href = focusURL() + "western/eu_tvDetail.jsp?vodId=" + vodId + "&typeId=" + typeId;

    } else {

        //电影直接播放

        getAuthUrl(vodId);

    }

}



/**从书签处播放 */

function tip_fromBookmarkPlay() {

    var tempTime = domark(vodId);

    var baseurl = focusURL();

	iPanel.debug("hj_clubIndex baseurl=="+baseurl);

    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"

            + "&progId=" + vodId + "&contentType=0&startTime=" + tempTime + "&business=1";

}



/* tipsWindow.jsp中getAuthUrl()方法调用，从开始处播放 */

function tip_fromBeginPlay() {

    var baseurl = focusURL();

    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"

            + "&progId=" + vodId + "&contentType=0&business=1";

}



</script>

</head>



<body leftmargin="0" topmargin="0" onLoad="init()">

<!--top-->

<div id="posterBg" style="position:absolute;left:0px;top:0px;background:url(img/top01_bg.png);width:1280px;height:180px;">

	<div id="posterName" style="position:absolute;left:86px;top:80px;width:632px;height:40px; color:#ffffff; font-size:32px;"></div>

</div>



<div style="position:absolute;top:180px;background:url(img/foot_bg.png);width:1280px;height:540px;">

	<div style="position:absolute;left:90px;top:35px;width:1190px;height:322px;overflow:hidden;">

		<div id="divMenu0" style="position:absolute;left:-265px;width:230px;height:288px;color:#999;font-size:20px;">  		

		    <img id="postor0" src="img/tu01.png" width="220" height="230" style="position:absolute; left:5px; top:5px;"/>

	        <div id="name0" style="position:absolute;left:0px;top:260px;width:230px; height:59px;">海洋核动力平台示范工程</div>

		</div>

		<div id="divMenu1" style="position:absolute;left:0px; width:230px;height:310px;color:#999;font-size:20px;">  		

		    <img id="postor1" src="img/tu01.png" width="220" height="230" style="position:absolute; left:5px; top:5px;"/>

	        <div id="name1" style="position:absolute;left:0px;top:250px;width:230px; height:59px;">海洋核动力平台示范工程</div>

		</div>

		

		<div id="divMenu2" style="position:absolute;left:265px;width:230px;height:310px;color:#999;font-size:20px;">  		

		    <img id="postor2" src="img/tu02.png" width="220" height="230" style="position:absolute; left:5px; top:5px;"/>

	        <div id="name2" style="position:absolute;left:0px;top:250px;width:230px; height:59px;">申报的海洋核动力平台</div>

		</div>

		

		<div id="divMenu3" style="position:absolute;left:538px;width:230px;height:310px;color:#999;font-size:20px;">  		

		    <img id="postor3" src="img/tu03.png" width="220" height="230" style="position:absolute; left:5px; top:5px;"/>

	        <div id="name3" style="position:absolute;left:0px;top:250px;width:230px; height:59px;">实现中国海洋核动力平台</div>

		</div>

		

		<div id="divMenu4" style="position:absolute;left:809px;width:230px;height:310px;color:#999;font-size:20px;">  		

		    <img id="postor4" src="img/tu04.png" width="220" height="230" style="position:absolute; left:5px; top:5px;"/>

	        <div id="name4" style="position:absolute;left:0px;top:250px;width:230px; height:59px;">海洋核动力平台示范项目</div>

		</div>

		

		<div id="divMenu5" style="position:absolute;left:1082px;width:230px;height:310px;color:#999;font-size:20px;">  		

		    <img id="postor5" src="img/tu05.png" width="108" height="231" style="position:absolute; left:5px; top:5px;"/>

	        <div id="name5" style="position:absolute;left:0px;top:250px;width:230px; height:59px;">申报的海洋</div>

		</div>

  </div>	

	<!--滑轮-->

</div><!--底部背景结束-->

<div style="position:absolute;left:0px;top:550px;width:1280px;height:117px; color:#999999; font-size:20px;">

	<div style="position:absolute;left:213px;top:23px;width:809px;height:1px;background:#e7dcd8;"></div>

	<div id="firstLine" style="position:absolute;left:0px;top:23px;width:209px;height:1px;background:#e7dcd8;"></div>

	<div id="lastLine" style="position:absolute;left:1020px;top:23px;width:257px;height:1px;background:#e7dcd8;"></div>

	<div id="imgFocus0" style="position:absolute;left:-36px;top:1px;width:39px;height:43px;background:url(img/dian.png) center no-repeat;"></div>

	<div id="imgFocus1" style="position:absolute;left:190px;top:1px;width:39px;height:43px;background:url(img/dian.png) center no-repeat;"></div>

	<div id="imgFocus2" style="position:absolute;left:451px;top:1px;width:39px;height:43px;background:url(img/dian.png) center no-repeat;"></div>

	<div id="imgFocus3" style="position:absolute;left:729px;top:1px;width:39px;height:43px;background:url(img/dian.png) center no-repeat;"></div>

	<div id="imgFocus4" style="position:absolute;left:997px;top:1px;width:39px;height:43px;background:url(img/dian.png) center no-repeat;"></div>

	<div id="imgFocus5" style="position:absolute;left:1261px;top:1px;width:39px;height:43px;background:url(img/dian.png) center no-repeat;"></div>

	

	<div id="textFocus0" style="position:absolute;left:-36px;top:50px;width:30px;height:43px; text-align:center;"></div>

	<div id="textFocus1" style="position:absolute;left:88px;top:50px;width:230px;height:43px; text-align:center;"></div>

	<div id="textFocus2" style="position:absolute;left:354px;top:50px;width:230px;height:43px; text-align:center;"></div>

	<div id="textFocus3" style="position:absolute;left:629px;top:50px;width:230px;height:43px; text-align:center;"></div>

	<div id="textFocus4" style="position:absolute;left:899px;top:50px;width:230px;height:43px; text-align:center;"></div>

	<div id="textFocus5" style="position:absolute;left:1261px;top:50px;width:230px;height:43px; text-align:center;"></div>

	

	<!--<img id="imgFocus5" src="img/dian.png" style="position:absolute;top:10px;"/>

	<img id="imgFocus1" src="img/dian.png" style="position:absolute;left:262px;top:10px;"/>

	<img id="imgFocus2" src="img/dian.png" style="position:absolute;left:522px;top:1px; "/>

	<img id="imgFocus3" src="img/dian.png" style="position:absolute;left:807px;top:10px;"/>

	<img id="imgFocus4" src="img/dian.png" style="position:absolute;left:1077px;top:10px;"/>-->

</div>

<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>

<jsp:include page="showtip.jsp"></jsp:include>

</body>

</html>

