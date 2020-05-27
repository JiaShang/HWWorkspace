<%@ page language="java" pageEncoding="GBK"%>
<%@ include file = "datajspHD/newYear_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<title>�����˴���</title>
<script type="text/javascript" src="js/showList.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/global.js"></script>
<script>
iPanel.eventFrame.initPage(window);

var focusArea = 0; //  0 ͼƬ�б���  1�������ֽ���    2 �ض����Ľ���
var rankData = [];   //�ұ�ǰ5���а�

var vodId = 0;
var caid = CA.card.serialNumber;
var listPos = boxFos? boxFos : 0;
 
var listBox = null;
var footBtnPos = 0;    //��ҳ���ؽ���

var zanCount = 0;    // ���޴���ͳ��  

var isError = true;    //�Ƿ��������
var isComplete = true;    //�Ƿ��Ѿ�ͶƱ�ɹ�
var inputNum = "";
var tipBtnPos = 0;  //��ʾ�� ȷ�� ȡ�� �����
var showPhoneFlag = false;   //�ֻ�����������Ƿ񵯳� false Ϊû�� trueΪ��ʾ
var tipTextFlag = false;    //��ʾ�� �ֻ����벻��ȷ����ʾ


function eventHandler(eventObj,type) { 
    if(type == 1 && key_flag == 1){//����ʾ�򵯳���
����	return tipkeypress(eventObj.code);
����}else{
	iPanel.debug("20161122-zcrds.htm  eventHandler  eventObj.code ===" + eventObj.code);
        switch (eventObj.code) {
            case "KEY_UP":
				if(!showPhoneFlag&&!tipTextFlag){
					udMove(-1);						
				} 
				return false;		
				break;
			case "KEY_DOWN":
				if(!showPhoneFlag&&!tipTextFlag){
					udMove(1);						
				} 
				return false; 		
				break;
			case "KEY_LEFT":
				if(showPhoneFlag){
					changeTipBtn(-1);
				}else{
					if(!tipTextFlag){
						lrMove(-1);
					}					
				}   	
				return false;	
				break;
			case "KEY_RIGHT":
				if(showPhoneFlag){
					changeTipBtn(1);
				}else{
					if(!tipTextFlag){
						lrMove(1);
					}					
				}   
				return false;	
				break;
			case "KEY_SELECT":
				doSelect();
				return false;
				break;
			case "KEY_BACK":
				if(showPhoneFlag){ 
					deleteNum();
				}else{
					if(!tipTextFlag){
						doBack();
					}					
				}   
				return false;
				break;
			case "KEY_MENU":
			case "KEY_EXIT":
				if(!tipTextFlag){
					doMenu();	
				}
				return false;
				break;
			case "KEY_NUMERIC"://���ּ�
				if(showPhoneFlag){
				   insertNum(eventObj.args.value);
				}
				return false;
				break;							
		}
	}
}		


function init(){
    initScroll();
    listData = vodList;
	showSeneryData();
	getRankList();   //��ȡ���а�
}


function getRankList(){
	var url = "http://192.168.49.56:8989/VoteStatistics/getVoteInfo?classifyID=376";
	isComplete = false;	
	ajax({
		url: url,
		type: "GET",
		dataType: "html",
		onSuccess: function(html){
			 rankData = eval('('+html+')');
			if(rankData.length >0){
				showRankList();
			}else{
				//�齱ʧ��
				
			}
			isComplete = true;
		},
 		onError:function(){
			
		}
	});	
}

function showRankList(){
	for(var i = 0; i< 5; i++){
		$("rankName"+i).innerText = rankData[i].name;
		$("rankScore"+i).innerText = rankData[i].num;	
	}	
}


//�����ƶ�����Ĳ���
function udMove(_num){
	iPanel.debug("zcrds.htm udMove focusArea===" + focusArea +"----_num ===" + _num);
	if(focusArea ==0){
		changeImgUD(_num);
		scrollChange();
	}else if(focusArea ==1){
		changeZanUD(_num);
		scrollChange();
	}
}

//�����ƶ�����Ĳ���
function lrMove(_num){
	if(focusArea ==0){
		changeImgLR(_num);	
	}else if(focusArea==1){
		changeZanLR(_num);	
	}else if(focusArea ==2){
		if(_num <0){
			focusArea = 1;
			$("topBtn").src = "image/love214/btn_top01.jpg";
			getZanFocus();	
		}	
	}
}


function showSeneryData(){
	listBox = new showList(9, vodList.length, listPos, 156, window);
	listBox.listHigh = 52;
	listBox.showType  = 0;
	listBox.focusLoop = false;
	listBox.pageLoop = false;
	listBox.haveData = function(List){
		$("listDiv"+ List.idPos).style.visibility = "visible";
		$("listImg"+ List.idPos).src = vodList[List.dataPos].picPath;
		$("listName"+List.idPos).innerText = vodList[List.dataPos].vodName;
		getZanNumByName(List.idPos,List.dataPos);
	};
	listBox.notData = function(List){
		$("listDiv"+ List.idPos).style.visibility = "hidden";
		$("listImg"+ List.idPos).src = "";
		$("listName"+List.idPos).innerText = "";
	};
	listBox.startShow();
	initScroll();
	getListFocus();
	showPageInfo();
}


function getZanNumByName(__idPos,__dataPos){
	var str = vodList[__dataPos].vodName;
	var wrapContent = encodeURIComponent(str);
	var url = "http://192.168.49.56:8989/VoteStatistics/getVoteSum?content="+wrapContent+"&classifyID=376";
	iPanel.debug("fighting.html getZanNum url ===" + url);
	isComplete = false;
	ajax({
		url: url,
		type: "POST",
		dataType: "html",
		onSuccess: function(html){
			iPanel.debug("fighting.html onSuccess  voteAction html ===" + html);
			var res = eval('('+html+')');
			$("zanNum"+__idPos).innerText = res;
			isComplete = true;
		},
 		onError:function(){
			iPanel.debug("fighting.html onError  voteAction  ");
		}
	});
}


function changeImgUD(_num){
	if(_num<0){
		if(listBox.focusPos<3){
			listBox.changePage(-1);
		}else{
			listBox.changeList(-3);
			focusArea = 1;
			loseListFocus();
			getZanFocus();
		}		
	}else if(_num >0){
		focusArea = 1;
		loseListFocus();
		getZanFocus();
	}
	showPageInfo();
}

function changeImgLR(_num){
	if(listBox.focusPos==8&&_num>0){
		focusArea = 2;
		loseListFocus();
		$("topBtn").src = "image/love214/btn_top02.jpg";
		scrollChange();
		return;	
	}
	loseListFocus();
	listBox.changeList(_num);	
	getListFocus();
}

function changeZanUD(_num){
	if(_num > 0){
		if(listBox.focusPos < 6){
			loseZanFocus();
			listBox.changeList(3);
			focusArea = 0;
			getListFocus();	
		}else{
			loseZanFocus();
			listBox.changePage(1);
			iPanel.debug("goodVoice.htm listBox.focusPos==" + listBox.focusPos);
			getZanFocus();
		}	
	}else if(_num<0){
		focusArea = 0;
		loseZanFocus();
		getListFocus();		
	}
	showPageInfo();
}

/*function showPageInfo(){
	$("currNum").innerText = listBox.currPage;	
	$("totalNum").innerText = listBox.listPage;	
}*/

//������
function initScroll(){
	scrollBar = new ScrollBar("scrollBar");
	scrollBar.init(Math.ceil(listBox.dataSize/listBox.listSize),1, 350, 0);
	if(subMenuBox.dataSize == 0){
	}else{
		scrollChange();
	}
}

function scrollChange(){	//��ʾ��ǰҳ�������ܹ�ҳ����
	scrollBar.scroll(listBox.currPage-1);
	$("scrollBar").innerHTML = listBox.currPage+'<br/>'+listBox.listPage;
}


function changeZanLR(_num){
	if(listBox.focusPos==8&&_num>0){
		focusArea = 2;
		loseZanFocus();
		$("topBtn").src = "image/love214/btn_top02.jpg";
		return;	
	}
	loseZanFocus();
	listBox.changeList(_num);
	getZanFocus();	
}


function getListFocus(){
	$("listFocus").style.visibility = "visible";
	if(listBox.focusPos<3){
		$("listFocus").style.top = "127px";
		$("listFocus").style.left = 153+(listBox.focusPos*300)+"px";
	}else if(listBox.focusPos>2&&listBox.focusPos<6){
		$("listFocus").style.top = "350px";
		$("listFocus").style.left = 153+((listBox.focusPos-3)*300)+"px";
	}else if(listBox.focusPos>5&&listBox.focusPos<9){
		$("listFocus").style.top = "550px";
		$("listFocus").style.left = 153+((listBox.focusPos-6)*300)+"px";
	}
}	


function loseListFocus(){
	$("listFocus").style.visibility = "hidden";
}


function getZanFocus(){
	$("zanBtn"+listBox.focusPos).style.background = "url(image/love214/20161124-GoodVoice-zan00.png)";
}


function loseZanFocus(){
	$("zanBtn"+listBox.focusPos).style.background = "url(image/love214/20161124-GoodVoice-zan01.png)";
}

function doSelect(){
	if(focusArea ==0){		
		vodId = vodList[listBox.position].vodId;
        play_movie(vodList[listBox.position].playType);
	}else if(focusArea ==1){
		if(showPhoneFlag){
			phoneDoselect();	
		}else if(tipTextFlag){
			TipTextDoselect();
		}else{							
			showPhoneText();												
		}   
	}else if(focusArea ==2){
		focusArea = 0;
		listBox.focusPos = 0;
		showSeneryData();
		scrollChange();
		$("topBtn").src = "image/love214/btn_top01.jpg";
	}
}

//���ò���
function doMenu(){
	window.location.href = iPanel.eventFrame.portalUrl;
}

//��ʷ����һ��
function doBack(){

}

//��¼ҳ����תǰ�Ľ���λ��
function focusURL(){
  var baseurl = "SaveCurrFocus.jsp?currFoucs=" + 20 + "," +listBox.position + "," + 30+"&url=";
  return baseurl;
}

/**��Ŀ���ţ�������Ȩҳ��  */    // ����
function play_movie(playType){
����if(playType == 1){
����	//����ǵ��Ӿ�
����	window.location.href = focusURL()+"high_TV_detail.jsp?vodId="+vodList[listBox.position].vodId+"&typeId="+typeId;
����}else{
����	//��Ӱֱ�Ӳ���
����	getAuthUrl(vodId);
����}
}

/**����ǩ������ */
function tip_fromBookmarkPlay(){
  var tempTime = domark(vodId);
  var baseurl = focusURL();
  $("data_ifm").src =  baseurl+"/EPG/jsp/defaultHD/en/Authorization.jsp?typeId="+typeId + "&playType=1" 
            +"&progId="+vodId + "&contentType=0&startTime="+tempTime+ "&business=1";
}

/* tipsWindow.jsp��getAuthUrl()�������ã��ӿ�ʼ������ */
function tip_fromBeginPlay(){
   var baseurl = focusURL();
   $("data_ifm").src = baseurl+"/EPG/jsp/defaultHD/en/Authorization.jsp?typeId="+typeId + "&playType=1" 
            +"&progId="+vodId +"&contentType=0&business=1";
}





/*  �����ֻ��������ʾ�� ��ش��� fuying add start*/

//��ʾ��ʾ�� �����ֻ�����
function showPhoneText(){
	showPhoneFlag = true;
	$("phoneDiv").style.visibility = "visible";
}

//������ʾ�� �ֻ�����
function hidePhoneText(){
	showPhoneFlag = false;
	$("phoneDiv").style.visibility = "hidden";	
}

//��ʾ��ʾ��
function showTipText(_text){
	tipTextFlag = true;
	$("tipDiv").style.visibility = "visible";
	$("tipText").innerText = _text;
	$("btn_ok").innerText = "ȷ  ��";
}

//������ʾ��
function hideTipText(){
	tipTextFlag = false;
	$("tipDiv").style.visibility = "hidden";
	$("tipText").innerText = "";
	$("btn_ok").innerText = "";	
}

function insertNum(num){
	if(inputNum.length >=11){
		return;
	}
	inputNum +=num;
	$("telNum").innerText =inputNum;
}

function deleteNum(){
	if(inputNum.length==0){
		return;
	}
	inputNum = inputNum.substr(0,inputNum.length-1);
	$("telNum").innerText =inputNum;
}

function changeTipBtn(_num){
	$("ok_"+tipBtnPos).style.background = "url(image/love214/ld_btn2_01.png) no-repeat center";
	$("ok_"+tipBtnPos).style.color = "#242424";
	tipBtnPos = (tipBtnPos+_num+2)%2;
	$("ok_"+tipBtnPos).style.background = "url(image/love214/ld_btn2_02.png) no-repeat center";
	$("ok_"+tipBtnPos).style.color = "#ffffff";	
}

function phoneDoselect(){
	if(tipBtnPos ==0){
		//��֤����
		if(checkInput() == false){
			voteAction();
		}
	}else{
		hidePhoneText();	
		clearPhoneText();
	}	
}

function TipTextDoselect(){
	if(isError == true){
		showPhoneText();
		hideTipText();
	}else{
		hideTipText();
	}	
}

function checkInput(){
	isError = true;
    if(inputNum.length == 0 || inputNum == ""){
	   hidePhoneText();
	   clearPhoneText();
	   var str = "Ϊ�˷���������ϵ�����������ĵ绰����!";
	  showTipText(str);
   }else if(!isTelephone(inputNum)){
	   hidePhoneText();
	   clearPhoneText();
	   var str = "�Բ���,�������ֻ���������,����������!";
	   showTipText(str);
   }else{
	   isError = false;
   }
   return isError;
}

function isTelephone(obj){  
	if((/^1[3|4|5|7|8]\d{9}$/.test(obj))){ 
	   return true; 
	}else { 
	   return false; 
	}
}


function clearPhoneText(){
	$("ok_"+1).style.background = "url(image/love214/ld_btn2_01.png) no-repeat center";
	$("ok_"+1).style.color = "#242424";
	$("ok_"+0).style.background = "url(image/love214/ld_btn2_02.png) no-repeat center";
	$("ok_"+0).style.color = "#ffffff";
	tipBtnPos = 0;
	$("telNum").innerText ="";
	inputNum = "";
}

//����ͶƱ
function voteAction(){
	hidePhoneText();
	var str = vodList[listBox.position].vodName;
	var wrapContent = encodeURIComponent(str);
	var url = "http://192.168.49.56:8080/voteNew/external/addVote4.ipanel?icid="+caid+"&phone="+inputNum+"&classifyID=376&content="+wrapContent+"&voteCount=3";
	isComplete = false;	
	ajax({
		url: url,
		type: "GET",
		dataType: "html",
		onSuccess: function(html){
			var res = eval('('+html+')');
			if(res.recode == "002"){
				 hidePhoneText();
				 clearPhoneText();
				if(res.result == true){
					if(zanCount>2){
						showTipText("���Ľ���ͶƱ���������꣬�����������");
						return;	
					}
					var str = "ͶƱ�ɹ�!";
					showTipText(str);
					zanCount++;
				}else{
					//�Ѿ��������
					var str = "����ͶƱ�����ѵ�3����!������������";
					showTipText(str);
				}
			}else{
				//�齱ʧ��
				
			}
			isComplete = true;
		},
 		onError:function(){
			
		}
	});
}

/*  �����ֻ��������ʾ�� ��ش��� fuying end */


</script>


</head>
<body background="image/love214/20161124-GoodVoice-bg.jpg" topmargin="0" leftmargin="0" onLoad="init()">

<!--logo-->
<div style="position:absolute; top:30px; left:34px; width:252px; height:46px; background:url(image/love214/20161124-GoodVoice-logo.png);"></div>

<!--������Ϣ-->
<div id="listDiv0" style="position:absolute; top:87px; left:34px; width:290px; height:178px;">
    <img id="listImg0" src="" width="290" height="178" style="position:absolute; left:0px; top:0px;">
    <!--cover-->
    <div style="position:absolute;top:146px; left:0px; width:290px; height:32px; background:url(image/love214/20161124-GoodVoice-cover.png);">
        <div id="listName0" style="position: absolute; left: 0px; top: 0px; width: 211px; height: 32px; text-align:center; font-size:14px; line-height:32px; color:#ffffff;">���зֹ�˾</div>
        <!--ͶƱ-->
      <div id="zanBtn0" style="position:absolute; top:0px; right:0px; background:url(image/love214/20161124-GoodVoice-zan01.png); width:77px; height:32px; font-size:18px; text-align:center; line-height:32px; color:#ffffff;">ͶƱ</div>
    </div>
</div>


<div id="listDiv1" style="position:absolute; top:87px; left:346px; width:290px; height:178px;">
    <img id="listImg1" src="" width="290" height="178" style="position:absolute; left:0px; top:0px;">
    <!--cover-->
    <div style="position:absolute;top:146px; left:0px; width:290px; height:32px; background:url(image/love214/20161124-GoodVoice-cover.png);">
        <div id="listName1" style="position: absolute; left: 0px; top: 0px; width: 211px; height: 32px; text-align:center; font-size:14px; line-height:32px; color:#ffffff;">���зֹ�˾</div>
        <!--ͶƱ-->
      <div id="zanBtn1" style="position:absolute; top:0px; right:0px; background:url(image/love214/20161124-GoodVoice-zan01.png); width:77px; height:32px; font-size:18px; text-align:center; line-height:32px; color:#ffffff;">ͶƱ</div>
    </div>
</div>


<div id="listDiv2" style="position:absolute; top:87px; left:657px; width:290px; height:178px;">
    <img id="listImg2" src="" width="290" height="178" style="position:absolute; left:0px; top:0px;">
    <!--cover-->
    <div style="position:absolute;top:146px; left:0px; width:290px; height:32px; background:url(image/love214/20161124-GoodVoice-cover.png);">
        <div id="listName2" style="position: absolute; left: 0px; top: 0px; width: 211px; height: 32px; text-align:center; font-size:14px; line-height:32px; color:#ffffff;">���зֹ�˾</div>
        <!--ͶƱ-->
      <div id="zanBtn2" style="position:absolute; top:0px; right:0px; background:url(image/love214/20161124-GoodVoice-zan01.png); width:77px; height:32px; font-size:18px; text-align:center; line-height:32px; color:#ffffff;">ͶƱ</div>
    </div>
</div>

<div id="listDiv3" style="position:absolute; top:292px; left:34px; width:290px; height:178px;">
    <img id="listImg3" src="" width="290" height="178" style="position:absolute; left:0px; top:0px;">
    <!--cover-->
    <div style="position:absolute;top:146px; left:0px; width:290px; height:32px; background:url(image/love214/20161124-GoodVoice-cover.png);">
        <div id="listName3" style="position: absolute; left: 0px; top: 0px; width: 211px; height: 32px; text-align:center; font-size:14px; line-height:32px; color:#ffffff;">���зֹ�˾</div>
        <!--ͶƱ-->
      <div id="zanBtn3" style="position:absolute; top:0px; right:0px; background:url(image/love214/20161124-GoodVoice-zan01.png); width:77px; height:32px; font-size:18px; text-align:center; line-height:32px; color:#ffffff;">ͶƱ</div>
    </div>
</div>


<div id="listDiv4" style="position:absolute; top:292px; left:346px; width:290px; height:178px;">
    <img id="listImg4" src="" width="290" height="178" style="position:absolute; left:0px; top:0px;">
    <!--cover-->
    <div style="position:absolute;top:146px; left:0px; width:290px; height:32px; background:url(image/love214/20161124-GoodVoice-cover.png);">
        <div id="listName4" style="position: absolute; left: 0px; top: 0px; width: 211px; height: 32px; text-align:center; font-size:14px; line-height:32px; color:#ffffff;">���зֹ�˾</div>
        <!--ͶƱ-->
      <div id="zanBtn4" style="position:absolute; top:0px; right:0px; background:url(image/love214/20161124-GoodVoice-zan01.png); width:77px; height:32px; font-size:18px; text-align:center; line-height:32px; color:#ffffff;">ͶƱ</div>
    </div>
</div>


<div id="listDiv5" style="position:absolute; top:292px; left:657px; width:290px; height:178px;">
    <img id="listImg5" src="" width="290" height="178" style="position:absolute; left:0px; top:0px;">
    <!--cover-->
    <div style="position:absolute;top:146px; left:0px; width:290px; height:32px; background:url(image/love214/20161124-GoodVoice-cover.png);">
        <div id="listName5" style="position: absolute; left: 0px; top: 0px; width: 211px; height: 32px; text-align:center; font-size:14px; line-height:32px; color:#ffffff;">���зֹ�˾</div>
        <!--ͶƱ-->
      <div id="zanBtn5" style="position:absolute; top:0px; right:0px; background:url(image/love214/20161124-GoodVoice-zan01.png); width:77px; height:32px; font-size:18px; text-align:center; line-height:32px; color:#ffffff;">ͶƱ</div>
    </div>
</div>

<div id="listDiv6" style="position:absolute; top:496px; left:34px; width:290px; height:178px;">
    <img id="listImg6" src="" width="290" height="178" style="position:absolute; left:0px; top:0px;">
    <!--cover-->
    <div style="position:absolute;top:146px; left:0px; width:290px; height:32px; background:url(image/love214/20161124-GoodVoice-cover.png);">
        <div id="listName6" style="position: absolute; left: 0px; top: 0px; width: 211px; height: 32px; text-align:center; font-size:14px; line-height:32px; color:#ffffff;">���зֹ�˾</div>
        <!--ͶƱ-->
      <div id="zanBtn6" style="position:absolute; top:0px; right:0px; background:url(image/love214/20161124-GoodVoice-zan01.png); width:77px; height:32px; font-size:18px; text-align:center; line-height:32px; color:#ffffff;">ͶƱ</div>
    </div>
</div>


<div id="listDiv7" style="position:absolute; top:496px; left:346px; width:290px; height:178px;">
    <img id="listImg7" src="" width="290" height="178" style="position:absolute; left:0px; top:0px;">
    <!--cover-->
    <div style="position:absolute;top:146px; left:0px; width:290px; height:32px; background:url(image/love214/20161124-GoodVoice-cover.png);">
        <div id="listName7" style="position: absolute; left: 0px; top: 0px; width: 211px; height: 32px; text-align:center; font-size:14px; line-height:32px; color:#ffffff;">���зֹ�˾</div>
        <!--ͶƱ-->
      <div id="zanBtn7" style="position:absolute; top:0px; right:0px; background:url(image/love214/20161124-GoodVoice-zan01.png); width:77px; height:32px; font-size:18px; text-align:center; line-height:32px; color:#ffffff;">ͶƱ</div>
    </div>
</div>


<div id="listDiv8" style="position:absolute; top:496px; left:657px; width:290px; height:178px;">
    <img id="listImg8" src="" width="290" height="178" style="position:absolute; left:0px; top:0px;">
    <!--cover-->
    <div style="position:absolute;top:146px; left:0px; width:290px; height:32px; background:url(image/love214/20161124-GoodVoice-cover.png);">
        <div id="listName8" style="position: absolute; left: 0px; top: 0px; width: 211px; height: 32px; text-align:center; font-size:14px; line-height:32px; color:#ffffff;">���зֹ�˾</div>
        <!--ͶƱ-->
      <div id="zanBtn8" style="position:absolute; top:0px; right:0px; background:url(image/love214/20161124-GoodVoice-zan01.png); width:77px; height:32px; font-size:18px; text-align:center; line-height:32px; color:#ffffff;">ͶƱ</div>
    </div>
</div>

<!-- �б���� -->
<div id="listFocus" style="position: absolute; left: 153px; top: 127px; width: 52px; height: 57px; background: url(image/love214/20161124-GoodVoice-playIcon.png) no-repeat center; visibility: visible"></div>
	

<!--������-->
<div style="position:absolute;left:970px;top:177px; width:2px; height:424px; background:#c8c8c8;">
  <div id="scrollBar" style="position:absolute;left:-12px;top:0px; width:26px; height:56px; background:url(image/love214/20161124-GoodVoice-page.png); font-size:21px; color:#fff; text-align:center; line-height:28px;"><span>1</span><br/>
  <span>4</span></div>
    <div style="position:absolute;left:-15px;top:410px; width:30px; height:80px; "><img id="topBtn" src="image/love214/btn_top01.jpg" width="30" height="80"></div>
</div>

<!-- �Ҳ���Ϣ -->
	<span style="position:absolute; top:273px; left:1062px; width: 159px; font-size:30px; letter-spacing:5px; color:#ffffff;">���а�</span>
	<img src="image/love214/20161124-GoodVoice-line01.png" style="position:absolute; top:318px; left:1013px;">
	<div style="position:absolute; top:324px; left:1003px; width:244px; height:220px; font-size:21px; color:#ffffff;">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" style="text-align:center;  font-size:21px; color:#ffffff; line-height:44px;">
			<tr>
				<td id="rankName0" width="190" height="44">&nbsp;</td>
				<td id="rankScore0" width="54" height="44">&nbsp;</td>
			</tr>
			<tr>
				<td id="rankName1">&nbsp;</td>
				<td id="rankScore1">&nbsp;</td>
			</tr>
			<tr>
				<td id="rankName2">&nbsp;</td>
				<td id="rankScore2">&nbsp;</td>
			</tr>
			<tr>
				<td id="rankName3">&nbsp;</td>
				<td id="rankScore3">&nbsp;</td>
			</tr>
			<tr>
				<td id="rankName4">&nbsp;</td>
				<td id="rankScore4">&nbsp;</td>
			</tr>
		</table>
	</div>
	<!--�����-->
	<img src="image/love214/20161124-GoodVoice-active.png" style="position:absolute; top:571px; left:1012px;">
	<div style="position:absolute; top:608px; left:1008px; width:239px; height:56px; font-size:17px; color:#ffffff;">ÿ��ÿ̨��������Ͷ3Ʊ��ͶƱ�����ޡ�</div>
    
    
 
<!-- ͶƱ�� �����ֻ����� -->
<div style="position:absolute;left:365px;top:195px;width:590px; height:299px; background:url(image/love214/ld_pop.png) no-repeat center; visibility:hidden;" id="phoneDiv">
  <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="40" width="90">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
      <td width="90">&nbsp;</td>
    </tr>
    <tr>
      <td width="90">&nbsp;</td>    
      <td height="55" colspan="2" style="font-size:30px; color:#ffffff; text-align:center; letter-spacing:8px; font-weight:100;">�������ֻ�����:</td>
      <td width="90">&nbsp;</td>      
    </tr>
    <tr>
      <td width="90">&nbsp;</td>      
      <td height="70" colspan="2" style="background:url(image/love214/ld_input_box1.png) no-repeat center; font-size:24px; color:#ffffff; text-align:center; letter-spacing:5px; line-height:70px;" id="telNum"></td>
      <td width="90">&nbsp;</td>      
    </tr>
    <tr style="font-size:19px; text-align:center;">
      <td width="90">&nbsp;</td>    
      <td style="background:url(image/love214/ld_btn2_02.png) no-repeat center; color:#ffffff; font-size:22px; font-weight:bold;" id="ok_0">ȷ ��</td>
      <td style="background:url(image/love214/ld_btn2_01.png) no-repeat center; color:#242424;font-size:22px; font-weight:bold;" id="ok_1">ȡ ��</td>
      <td width="90">&nbsp;</td>
    </tr>
    <tr>
      <td height="60">&nbsp;</td>
    </tr>    
  </table>
</div>


<!-- ��Ʊ״̬����ʾ��Ϣ  -->
<div style="position:absolute;left:365px;top:195px;width:590px; height:299px; background:url(image/love214/ld_pop.png) no-repeat center; visibility: hidden;" id="tipDiv">
  <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="60" colspan="2">&nbsp;</td>
    </tr>    
    <tr>
      <td width="100" height="100" align="right"><img src="image/love214/ld_icon_caution.png" width="41" height="40"  style="padding-:10px; padding-right:10px;"/></td>
      <td  style="line-height:50px; padding-top:2px;"><div style="position: absolute; left: 110px; top: 86px; width: 445px; height: 55px; font-size: 24px; color: #ffffff; text-align: left; font-weight: 100;" id="tipText">�ܱ�Ǹ�����Ѿ�Ͷ��Ʊ�ˣ�</div></td>
    </tr>
    <tr style="font-size:19px; text-align:center;">
      <td colspan="2"id="btn_ok" style="background:url(image/love214/ld_btn2_02.png) no-repeat center; color:#ffffff;">ȷ  ��</td>
    </tr>
    <tr>
      <td height="60" colspan="2">&nbsp;</td>
    </tr>
  </table>
</div>		
</body>


<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="high_tips.jsp"></jsp:include> 
</html>
