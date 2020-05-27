<%@ page language="java" pageEncoding="GBK"%>
<%@ include file = "datajspHD/snnx_data.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta name="page-view-size" content="1280*720">
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
		<title>tvn十年</title>
		<style>
			.underline{text-decoration: underline; color:#ffdca7;}
			.noUnderLine{color: #FFF;}
		</style>
		<script src="js/global.js"></script>
		<script src="js/showList.js"></script>
		<script>
			iPanel.eventFrame.initPage(window);

			var area = 0;	// focusArea  0: nav  1: list  2: footBtn
			var navPos = 0;
			var footPos = 0;

			var listBox = null;
			var scrollObj = null;

			var focusPicArr = ['image/love214/footbtn1_01.png','image/love214/footbtn1_02.png'];
			var blurPicArr = ['image/love214/footbtn0_01.png','image/love214/footbtn0_02.png'];

			var vodId = "";

			/*var vodList = [
				{"vodId":"vodId0","picPath":"image/love214/20161018-cqhsy-pic.png","vodName":"list0","playType":0},
				{"vodId":"vodId1","picPath":"image/love214/20161018-cqhsy-pic.png","vodName":"list1","playType":0},
				{"vodId":"vodId2","picPath":"image/love214/20161018-cqhsy-pic.png","vodName":"list2","playType":0},
				{"vodId":"vodId3","picPath":"image/love214/20161018-cqhsy-pic.png","vodName":"list3","playType":0},
				{"vodId":"vodId4","picPath":"image/love214/20161018-cqhsy-pic.png","vodName":"list4","playType":0},
				{"vodId":"vodId5","picPath":"image/love214/20161018-cqhsy-pic.png","vodName":"list5","playType":0},
				{"vodId":"vodId6","picPath":"image/love214/20161018-cqhsy-pic.png","vodName":"list6","playType":0},
				{"vodId":"vodId7","picPath":"image/love214/20161018-cqhsy-pic.png","vodName":"list7","playType":0}
			];*/

			function eventHandler(eventObj, type) {
				switch(eventObj.code) {
					case "KEY_UP":
						changeUD(-1);
						return 0;
						break;
					case "KEY_DOWN":
						changeUD(1);
						return 0;
						break;
					case "KEY_LEFT":
						changeLR(-1);
						return 0;
						break;
					case "KEY_RIGHT":
						changeLR(1);	
						return 0;
						break;
					case "KEY_SELECT":
						doSelect(listBox.position);
						return 0;
						break;
					case "KEY_EXIT":
					    doMenu();
					    return 0;
					    break;
					case "KEY_BACK":
					    doBack();
					    return 0;
					    break;
					default:
					    return 1;
					    break;
				}
			}

			function init() {
				navPos = <%= navPos%>;
				$('nav'+navPos).style.color = '#ffffff';
				initListBox();
			}

			function initListBox() {
				listBox = new showList(6, vodList.length, 0, 350, window);
				// listBox.focusDiv = 'focus';
				listBox.listHigh = 45;
				listBox.focusLoop = false;
				listBox.pageLoop = false;
				listBox.haveData = function(List){
					$('list'+List.idPos).innerText = vodList[List.dataPos].name;
				};
				listBox.notData = function(List){
					$('list'+List.idPos).innerText = '';
				};
				listBox.startShow();
				$("scroll").style.visibility = "visible";
				scrollObj = new ScrollBar("slider", null, window);
				scrollObj.init(vodList.length, 3, 197, 0);
				scrollObj.scroll(listBox.position);
			}

			function changeUD(_num) {
				if (area == 0) {
					if (_num > 0) {
						area = 1;
						$('list'+listBox.focusPos).className = 'underline';
					}
				}else if (area == 1) {
					if (listBox.position == 0 && _num < 0) {
						area = 0;
						$('list'+listBox.focusPos).style.textDecoration = 'none';
					}else if ((listBox.position == vodList.length - 1) && _num > 0) {
						area = 2;
						$('list'+listBox.focusPos).style.textDecoration = 'none';
						$('footBtn'+footPos).style.background = 'url('+focusPicArr[footPos]+')';
					}else {
						changeMenuList(_num);
					}
				}else if (area == 2) {
					if (_num < 0) {
						area = 1;
						$('footBtn'+footPos).style.background = 'url('+blurPicArr[footPos]+')';
						$('list'+listBox.focusPos).className = 'underline';
					}
				}
			}

			function changeLR(_num) {
				if (area == 0) {
					$('nav'+navPos).style.color = '#3471D1';
					navPos += _num;
					if (navPos < 0) {
						navPos = 1;
					}else if (navPos>0) {
						navPos = 1;
					}
					$('nav'+navPos).style.color = '#ffffff';
						setTimeout(reGoUrl,100);
				}else if (area == 2) {
					$('footBtn'+footPos).style.background = 'url('+blurPicArr[footPos]+')';
					footPos += _num;
					if (footPos > 1) {
						footPos = 1;
					}else if (footPos < 0) {
						footPos = 0;
					}
					$('footBtn'+footPos).style.background = 'url('+focusPicArr[footPos]+')';
				}
			}

			function changeMenuList(_num) {
				$('list'+listBox.focusPos).style.textDecoration = 'none';
				$('list'+listBox.focusPos).style.color = '#FFFFFF';
				listBox.changeList(_num);
				$('list'+listBox.focusPos).className = 'underline';
				if(scrollObj) {
					scrollObj.scroll(listBox.position);
				}
			}

			// 设置url参数 typeId
			function reGoUrl(){
				window.location.href = "20161102snnx.jsp?typeId=10000100000000090000000000106821&navPos="+navPos+"&ifcor=1";
			}

			function doSelect(index) {
				if (area == 0) {
					//
				}else if (area == 1) {
					vodId = vodList[listBox.position].vodId;
					play_movie(vodList[listBox.position].playType);
				}else if (area == 2) {
					if (footPos == 0) {
						doMenu();
					}else {
						doBack();
					}
				}
			}
			
			function doMenu(){
			  window.location.href = iPanel.eventFrame.portalUrl;
			}

			function doBack(){
			  window.location.href ="<%=turnPage.go(-1)%>";
			}

			function focusURL(){
				// var baseurl = "SaveCurrFocus.jsp?currFoucs=" + area + "," + listBox.position +"&url=";
				var baseurl = "SaveCurrFocus.jsp?currFoucs=" + area + "," + navPos + "," + listBox.position+"&url=";
				return baseurl;
			}

			function play_movie(playType){
			　　if(playType == 1){
			　　	// TV Series
			　　	window.location.href = focusURL()+"hddb/hjzq/hj_tvDetail.jsp?vodId="+vodId+"&typeId="+typeId;
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
	</head>
	<body style="background:url(image/love214/20161102-snnx-bg.jpg) no-repeat;" onLoad="init()">
		<!-- logo -->
		<img src="image/love214/20161102-snnx-icon.png" style="position:absolute;left:43px;top:37px;" >
		<span style="position:absolute;left:105px;top:50px;color:#fff;font-size:25px;">出品</span>
		<span style="position:absolute;left:46px;top:81px;color:#fff;font-size:16px;">策划：周枢   设计：羊羽</span>

		<!-- nav -->
		<div id="nav0" style="position:absolute;top:234px;left:660px;width:198px;height:41px;font-size:24px;line-height:41px;text-align:center;color:#3471D1;background:url(image/love214/20161102-snnx-btn_01.png);">
			人气韩剧
		</div>
		<div id="nav1" style="position:absolute;top:234px;left:861px;width:198px;height:41px;font-size:24px;line-height:41px;text-align:center;color:#3471D1;background:url(image/love214/20161102-snnx-btn_01.png);">
			最佳综艺
		</div>

		<!-- scroll -->
		<div style="position:absolute; top:352px; left:730px; width:3px; height:267px; background:url(image/love214/20161102-snnx-slide_01.png); visibility:hidden;" id="scroll">
			<div style="position:absolute; top:0px; left:0px; width:3px; height:70px; background:url(image/love214/20161102-snnx-slide_02.png);" id="slider"></div>
		</div>id="nav0" 

		<!-- list -->
		<div style="position:absolute;top:350px;left:758px;width:290px;height:274px;font-size:24px;color:#ffffff;">
			<table border="0" cellpadding="0" cellspacing="0" width="290" height="274">
				<tr>
					<td id="list0"></td>
				</tr>
				<tr>
					<td id="list1"></td>
				</tr>
				<tr>
					<td id="list2"></td>
				</tr>
				<tr>
					<td id="list3"></td>
				</tr>
				<tr>
					<td id="list4"></td>
				</tr>
				<tr>
					<td id="list5"></td>
				</tr>
			</table>
		</div>

		<!-- footBtn -->
		<div style="position: absolute; left: 1000px; top: 612px;">
			<div style="position: absolute; left: 0px; top: 0px; width: 66px; height: 53px; background: url(image/love214/footicon.png);"></div>
			<div id="footBtn0" style="position: absolute; left: 60px; top: 9px; width: 90px; height: 42px; background: url(image/love214/footbtn0_01.png);"></div>
			<div id="footBtn1" style="position: absolute; left: 130px; top: 9px; width: 90px; height: 42px; background: url(image/love214/footbtn0_02.png);"></div>
		</div>

		<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
		<jsp:include page="high_tips.jsp"></jsp:include> 
	</body>
</html>
