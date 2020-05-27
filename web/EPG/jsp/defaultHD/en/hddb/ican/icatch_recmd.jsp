<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="icatch_recmd_data.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gbk" />
    <meta name="page-view-size" content="1280*720"/>
    <title>icatch_recommend</title>
    <script type="application/javascript" src="js/ajax.js"></script>
    <script type="application/javascript" src="js/common.js"></script>
    <script type="application/javascript" src="js/showList.js"></script>
    <script type="application/javascript" src="js/global.js"></script>
    <script type="text/javascript">
		iPanel.eventFrame.initPage(window);
		E.is_HD_vod = true;
        var IS_DEBUG = 0;  //0表示给到现场版本   1表示调试
        var menuData = [];  //数据
        var menuPos = 0;  //焦点位置
        var listData = [];  //视频头条的数据(视频头条 部分要显示这里的的第一条数据)
		var topicList = [];
        var focusObj = [
            {"up":0,"down":2,"left":0,"right":1},
            {"up":1,"down":4,"left":0,"right":1},
            {"up":0,"down":5,"left":2,"right":3},
            {"up":0,"down":6,"left":2,"right":4},
            {"up":1,"down":7,"left":3,"right":4},
            {"up":2,"down":5,"left":5,"right":6},
            {"up":3,"down":6,"left":5,"right":7},
            {"up":4,"down":7,"left":6,"right":7},
        ];  //记录每个位置上、下、左、右移动时的目标位置
        if( IS_DEBUG ) {
            //test data
            menuData = [
                {vodID:1, img:"img/pic1_02.jpg"},
                {vodID:1, img:"img/pic1_03.jpg"},
                {vodID:1, img:"img/pic1_04.jpg"},
                {vodID:1, img:"img/pic1_05.jpg"},
                {vodID:1, img:"img/pic1_06.jpg"},
                {vodID:1, img:"img/pic1_07.jpg"},
                {vodID:1, img:"img/pic1_08.jpg"},
                {vodID:1, img:"img/pic1_09.jpg"},
            ];
            listData =[
                {type:"资讯", name:"今起市区中雨侵袭全市 酉阳秀山小心暴雨袭", vodID:1},
                {type:"评论", name:"重庆江北商圈路面塌陷 地面露20平米大洞", vodID:1},
                {type:"财经", name:"外媒：中国股市巨震对实体经济冲击有限", vodID:1},
                {type:"评论", name:"重庆江北商圈路面塌陷 地面露20平米大洞", vodID:1},
                {type:"财经", name:"外媒：中国股市巨震对实体经济冲击有限", vodID:1}
            ];
            document.onkeydown = function(e) {
                var kcode = e.which || e.keyCode || e.charCode;
                switch( kcode ) {
                    case 38:
                        udMove(-1);
                        break;
                    case 40:
                        udMove(1);
                        break;
                    case 37:
                        lrMove(-1);
                        break;
                    case 39:
                        lrMove(1);
                        break;
                    case 13:
                        doSelect();
                        break;
                    case 8:
                        doBack();
                        break;
                }
                return 0;
            }
        }
        else {
            iPanel.eventFrame.initPage(window);
        }

        function eventHandler(eventObj, type) {
			if (type == 1 && key_flag == 2) {//点播播放，去进行节目授权
       		return 0;
   		 } else if (type == 1 && key_flag == 1) {//有提示框弹出来
        		return tipkeypress(eventObj.code);
   		 } else {
            iDebug('icatch_recmd.htm--eventHandler--eventObj.code='+eventObj.code);
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

        function doMenu() {
            iPanel.mainFrame.location.href = E.portal_url;
        }

        function doBack() {
            window.location.href = "<%=turnPage.go(-1)%>";
        }

        //上下移动焦点
        function udMove(__num) {
            var __dir = __num > 0 ? 'down' : 'up';
            changeMenuPos( __dir );
        }

        //左右移动焦点
        function lrMove(__num){
            var __dir = __num > 0 ? 'right' : 'left';
            changeMenuPos( __dir );
        }

        function changeMenuPos( __dir ) {
            menuPos = focusObj[menuPos][__dir];
            initFocus();
        }

        //确定键处理
        function doSelect() {
            setGlobalVar("RECMDPOS",menuPos);  //记录焦点位置
            if( menuPos == 7 ) {  
				var baseurl = focusURL();
				//alert(baseurl);
				//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/hddb/new_qycq/xqycq_index_shangxian.jsp";
				window.location.href = baseurl + "/EPG/jsp/defaultHD/en/hddb/icatchHD/Category.jsp?url=icatchHD_chimgList.jsp?typeId=10000100000000090000000000103261&menuPos=1";
				//window.location.href = "http://192.168.65.22:8082/EPG/jsp/defaultHD/en/hddb/icatchHD/Category.jsp?url=icatchHD_chimgList.jsp?typeId=10000100000000090000000000103261";//专题推荐位
            }
            else if( menuPos == 5 ) {  //视频头条
				//var baseurl = focusURL();
				//window.location.href = baseurl + "/EPG/jsp/defaultHD/en/hddb/ican/icatch_list.jsp&back";
               window.location.href = 'icatch_list.jsp';
            }
			 else if( menuPos == 6 ) {  //视频头条
			 	var baseurl = focusURL();
				var currName = menuData[menuPos-1].name;
				//alert(currName);
				for(var i=0;i<topicList.length;i++){
				if(currName == topicList[i].name){
					//alert(currName);
					if(topicList[i].url.indexOf("code") == -1){
						if(topicList[i].url.indexOf("http") == -1){
							//alert(topicList[i].url);
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
				typeId = menuData[menuPos-1].typeId;
				vodId = menuData[menuPos-1].vodId;
				var playType = menuData[menuPos-1].playType;
				//alert(playType);
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
            }
            else {  //图片推荐位
				var baseurl = focusURL();
				var currName = menuData[menuPos].name;
				//alert(topicList.length);
				for(var i=0;i<topicList.length;i++){
				if(currName == topicList[i].name){
					if(topicList[i].url.indexOf("code") == -1){
						if(topicList[i].url.indexOf("http") == -1){
							//alert(topicList[i].url);
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
			if (menuData.length > 0) {
				typeId = menuData[menuPos].typeId;
				vodId = menuData[menuPos].vodId;
				var playType = menuData[menuPos].playType;
				if (typeId != '' && vodId != 0) {
					play_movie(playType);
				}
			}
				break;
            }
        }
		
		/**节目播放，跳到授权页面  */
function play_movie(playType) {
	//alert(play_movie);
	if (playType == 1) {
		//如果是电视剧
		window.location.href = focusURL() + "vod/tv_detail.jsp?vodId=" + vodId + "&typeId=" + typeId;
	} else {
		//电影直接播放
		//alert(vodId);
		getAuthUrl(vodId);
	}
}

        function init(){
            iDebug('icatch_recmd.htm--init--20180428 09:50');
			getTopicList();
            initParams();
            initDatas();
			initPicData();
			//alert("init");
			initTextData();
            initFocus();
        }

        function initParams() {
            //var _pos = getGlobalVar('RECMDPOS');
			var _pos = 0;
            if( typeof _pos != 'undefined' && _pos != null && _pos != '' ) {
                menuPos = parseInt( _pos );
            }
            iDebug('icatch_recmd.htm--initParams--menuPos='+menuPos);
        }

        //初始化数据
        function initDatas() {
			//alert("initDatas")
            menuData = vodImgArray;
			//alert(menuData.length);
            //menuPos = <= menuPos%>;
            listData = vodTextArray;
        }
		
		function initPicData(){
			for(var i = 0; i < menuData.length; i++){
				$("recmdImg"+i).src = menuData[i].img;
				//alert(menuData[i].name);
			}
		}
		
		function initTextData(){
			//alert("initTextData");
			//alert(listData[0].name); //显示第一条的数据
			var firstTitle = listData[0].name;
			//alert(firstTitle);
			var Kuohao = firstTitle.indexOf("（");
			//alert(Kuohao);
			//var cccc   = firstTitle.substring(0,Kuohao):
			//alert(cccc);
			if(firstTitle.indexOf("（") > -1){
				$("videoTitle").innerText = firstTitle.substring(0,Kuohao);
			}else{
				$("videoTitle").innerText = firstTitle;
			}
			
		}
		
		function getTopicList(){
			var url = E.pre_epg_url+"/defaultHD/en/hddb/hddb_topic.txt";
			var requestAjaxObj = new AJAX_OBJ(url,function(__ajaxObj){
				var requestStr = __ajaxObj.responseText;
				iPanel.debug("getValidComboInfo requestStr="+requestStr);
					if(requestStr != ""){
					eval("var tmpObj = "+requestStr);
					if(tmpObj.code == 200){
						topicList = tmpObj.data;
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


        //初始化焦点
        function initFocus() {
            //iDebug('icatch_recmd.htm--initFocus--menuPos='+menuPos+', top='+$('recmd'+menuPos).style.top+', left='+$('recmd'+menuPos).style.left+', width='+$('recmd'+menuPos).style.width+', height='+$('recmd'+menuPos).style.height);
            var _top = parseInt( $('recmdBox').style.top );
            if( menuPos >= 5 && _top == 0 ) {
                $('recmdBox').style.top = "-170px";
            }
            else if( menuPos <= 1 && _top < 0 ) {
                $('recmdBox').style.top = "0px";
            }
            //iDebug('icatch_recmd.htm--initFocus--$("recmdBox").style.top='+$('recmdBox').style.top);
            $('menuFocus').style.top = parseInt( $('recmd'+menuPos).style.top ) + 74 + parseInt($('recmdBox').style.top)  + 'px';  //还要加上recmdBox滚动的距离
            $('menuFocus').style.left = parseInt( $('recmd'+menuPos).style.left ) - 39 + 'px';
            $('menuFocus').style.width = parseInt( $('recmd'+menuPos).style.width ) + 88 + 'px';
            $('menuFocus').style.height = parseInt( $('recmd'+menuPos).style.height ) + 88 + 'px';
            $('menuFocus').style.visibility = 'visible';
        }
		
		/**从书签处播放 */
	function tip_fromBookmarkPlay(){
   		var tempTime = domark(vodId);
   	 	var baseurl = focusURL();
		iPanel.debug("index_ifeng baseurl=="+baseurl);
    	$("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&contentType=0&startTime=" + tempTime + "&business=1";
	}

/* tipsWindow.jsp中getAuthUrl()方法调用，从开始处播放 */
	function tip_fromBeginPlay(){
    	var baseurl = focusURL();
    	$("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&contentType=0&business=1";
	}
		
		function focusURL() {
    		var baseurl = "../SaveCurrFocus.jsp?currFoucs="+menuPos+"&url=";
   			return baseurl;
}
		
    </script>
</head>

<body background="img/bg.jpg" leftmargin="0" topmargin="0" onLoad="init();">
    <div style="position:absolute; left:77px; top:21px;"><img src="img/logo.png" width="200" height="80" /></div>
    <%--<div style="position:absolute; left:186px; top:49px; font-size:36px; color:#fff;">推荐</div>--%>

    <!--可见区域-->
  	<div style="position:absolute; top:108px; left:0px; width:1280px; height:612px; overflow: hidden;">
    	<div id="recmdBox" style="position:absolute; top:0px; left:0px; width:1280px; height:auto;top; -webkit-transition-duration: 240ms;">
            <div id="recmd0" style="position:absolute; left:77px; top:0px; width:746px; height:249px;"><img id="recmdImg0" src="img/pic1_02.jpg" width="746" height="249"/></div>
            <!--专题推荐位-->
            <div id="recmd1" style="position:absolute; left:849px; top:0px; width:360px; height:249px;"><img id="recmdImg1" src="img/pic1_03.jpg" width="360" height="249"/></div>
            <div id="recmd2" style="position:absolute; left:77px; top:276px; width:360px; height:249px;"><img id="recmdImg2" src="img/pic1_04.jpg" width="360" height="249"/></div>
            <div id="recmd3" style="position:absolute; left:463px; top:276px; width:360px; height:249px;"><img id="recmdImg3" src="img/pic1_05.jpg" width="360" height="249"/></div>
            <div id="recmd4" style="position:absolute; left:849px; top:276px; width:360px; height:249px;"><img id="recmdImg4" src="img/pic1_06.jpg" width="360" height="249"/></div>
            <!--视频头条-->
            <div id="recmd5" style="position:absolute; left:77px; top:551px; width:360px; height:194px;">
                <img src="img/pic1_07.jpg"/>
                <div id="videoTitle" style="position:absolute; left:14px; top:34px; width:326px; font-size:24px; color:#fff; height:30px">第一条数据</div>
                <div style="position:absolute; left:14px; top:131px; width:326px; font-size:37px; color:#fff;">视频头条</div>
            </div>
            <div id="recmd6" style="position:absolute; left:463px; top:551px; width:360px; height:194px;"><img id="recmdImg5" src="img/pic1_08.jpg" width="360" height="194"/></div>
            <div id="recmd7" style="position:absolute; left:849px; top:551px; width:360px; height:194px;"><img id="recmdImg6" src="img/pic1_09.jpg" width="360" height="194"/></div>
       </div>
      </div>
    <!--焦点-->
    <div id="menuFocus" style="position: absolute; top: 75px; left:811px; width: auto; height: auto; visibility: hidden;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="">
            <tr>
                <td width="105" height="112"><img src="img/jd1_01.png" width="105" height="112" /></td>
                <td background="img/jd1_02.png">&nbsp;</td>
                <td width="105" height="112"><img src="img/jd1_03.png" width="105" height="112" /></td>
            </tr>
            <tr>
                <td background="img/jd1_04.png">&nbsp;</td>
                <td>&nbsp;</td>
                <td background="img/jd1_05.png">&nbsp;</td>
            </tr>
            <tr>
                <td width="105" height="112"><img src="img/jd1_06.png" width="105" height="112" /></td>
                <td background="img/jd1_07.png">&nbsp;</td>
                <td width="105" height="112"><img src="img/jd1_08.png" width="105" height="112" /></td>
            </tr>
        </table>
    </div>

    <iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
    <jsp:include page="showtip.jsp"></jsp:include>
</body>
</html>
