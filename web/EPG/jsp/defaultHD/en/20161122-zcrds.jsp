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

var vodId = 0;
var caid = CA.card.serialNumber;
var listPos = boxFos? boxFos : 0;
 
var listBox = null;
var imgData= [
{id:"zj",name:"ղ�(����)",img:"image/love214/20161122-zcrds-img10.jpg",playType:0},
{id:"mjh",name:"�Ͻ�(����)",img:"image/love214/20161122-zcrds-img11.jpg",playType:0},
{id:"hx",name:"����(����)",img:"image/love214/20161122-zcrds-img12.jpg",playType:0},
{id:"zhb",name:"�ܺ鲨(����)",img:"image/love214/20161122-zcrds-img13.jpg",playType:0},
{id:"jwy",name:"������(����)",img:"image/love214/20161122-zcrds-img14.jpg",playType:0},
{id:"qln",name:"������(����)",img:"image/love214/20161122-zcrds-img15.jpg",playType:0},
{id:"ymt",name:"������(�山)",img:"image/love214/20161122-zcrds-img16.jpg",playType:0},
{id:"wyy",name:"������(�山)",img:"image/love214/20161122-zcrds-img17.jpg",playType:0},
{id:"wy",name:"����(����)",img:"image/love214/20161122-zcrds-img20.jpg",playType:0},
{id:"hr",name:"����(����)",img:"image/love214/20161122-zcrds-img21.jpg",playType:0},
{id:"cy",name:"����(����)",img:"image/love214/20161122-zcrds-img22.jpg",playType:0},
{id:"xj",name:"��(����)",img:"image/love214/20161122-zcrds-img23.jpg",playType:0},
{id:"jh",name:"����(��¡)",img:"image/love214/20161122-zcrds-img24.jpg",playType:0},
{id:"tlz",name:"����(��Ϫ)",img:"image/love214/20161122-zcrds-img25.jpg",playType:0},
{id:"yz",name:"����(�ǿ�)",img:"image/love214/20161122-zcrds-img26.jpg",playType:0},
{id:"pw",name:"��Ω(����)",img:"image/love214/20161122-zcrds-img27.jpg",playType:0},
{id:"ls",name:"��˴(����)",img:"image/love214/20161122-zcrds-img30.jpg",playType:0},
{id:"wy",name:"����(����)",img:"image/love214/20161122-zcrds-img31.jpg",playType:0},
{id:"ymw",name:"������(�ϰ�)",img:"image/love214/20161122-zcrds-img32.jpg",playType:0},
{id:"ssl",name:"������(����)",img:"image/love214/20161122-zcrds-img33.jpg",playType:0},
{id:"xpx",name:"������(�뽭)",img:"image/love214/20161122-zcrds-img34.jpg",playType:0},
{id:"jy",name:"�ɽ�Դ(ɳƺ��)",img:"image/love214/20161122-zcrds-img35.jpg",playType:0},
{id:"tt",name:"����(����)",img:"image/love214/20161122-zcrds-img36.jpg",playType:0},
{id:"wwh",name:"��Ρ��(����)",img:"image/love214/20161122-zcrds-img37.jpg",playType:0},
{id:"le",name:"¬��(���)",img:"image/love214/20161122-zcrds-img40.jpg",playType:0},
{id:"txk",name:"��С��(��Ϫ)",img:"image/love214/20161122-zcrds-img41.jpg",playType:0},
{id:"hgg",name:"�Ƹ��(��ɽ)",img:"image/love214/20161122-zcrds-img42.jpg",playType:0},
{id:"xyh",name:"���Ӻ�(����)",img:"image/love214/20161122-zcrds-img43.jpg",playType:0},
{id:"ly",name:"����(ͭ��)",img:"image/love214/20161122-zcrds-img44.jpg",playType:0},
{id:"cky",name:"�¿���(ͭ��)",img:"image/love214/20161122-zcrds-img45.jpg",playType:0},
{id:"ax",name:"��ܰ(����)",img:"image/love214/20161122-zcrds-img46.jpg",playType:0},
{id:"xqr",name:"лٻ��(����)",img:"image/love214/20161122-zcrds-img47.jpg",playType:0},
{id:"gss",name:"��˫˫(��ɽ)",img:"image/love214/20161122-zcrds-img50.jpg",playType:0},
{id:"zh",name:"���(�ٲ�)",img:"image/love214/20161122-zcrds-img51.jpg",playType:0},
{id:"clj",name:"���ܽ�(�ϴ�)",img:"image/love214/20161122-zcrds-img52.jpg",playType:0},
{id:"ngt",name:"ţ����(��ʢ)",img:"image/love214/20161122-zcrds-img53.jpg",playType:0},
{id:"liy",name:"��Ң(ʯ��)",img:"image/love214/20161122-zcrds-img54.jpg",playType:0},
{id:"lcf",name:"���(�ɽ)",img:"image/love214/20161122-zcrds-img55.jpg",playType:0},
{id:"ylei",name:"����(�ϴ�)",img:"image/love214/20161122-zcrds-img56.jpg",playType:0},
{id:"zc",name:"֣��(�ɽ)",img:"image/love214/20161122-zcrds-img57.jpg",playType:0}
];

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
	listBox = new showList(8, listData.length, listPos, 156, window);
	listBox.listHigh = 52;
	listBox.showType  = 0;
	listBox.haveData = function(List){
		$("listDiv"+ List.idPos).style.visibility = "visible";
		$("listImg"+ List.idPos).src = imgData[List.dataPos].img;
		$("listName"+List.idPos).innerText = imgData[List.dataPos].name;
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
	
}


function getZanNumByName(__idPos,__dataPos){
	var str = imgData[__dataPos].id;
	var wrapContent = str;
	var url = "http://192.168.49.56:8989/VoteStatistics/getVoteSum?content="+wrapContent+"&classifyID=375";
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
		if(listBox.focusPos<4){
			listBox.changePage(-1);
		}else{
			listBox.changeList(-4);
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
	if(listBox.focusPos==7&&_num>0){
		focusArea = 2;
		loseListFocus();
		$("topBtn").src = "image/love214/btn_top02.jpg";
		return;	
	}
	loseListFocus();
	listBox.changeList(_num);	
	getListFocus();
}

function changeZanUD(_num){
	if(_num > 0){
		if(listBox.focusPos < 4){
			loseZanFocus();
			listBox.changeList(4);
			focusArea = 0;
			getListFocus();	
		}else{
			listBox.changePage(1);	
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
	if(listBox.focusPos==7&&_num>0){
		focusArea = 2;
		loseZanFocus();
		$("topBtn").src = "image/love214/btn_top02.jpg";
		 scrollChange();
		return;	
	}
	loseZanFocus();
	listBox.changeList(_num);
	getZanFocus();	
}


function getListFocus(){
	$("listFocus").style.visibility = "visible";
	if(listBox.focusPos<4){
		$("listFocus").style.top = "224px";
		$("listFocus").style.left = 165+(listBox.focusPos*290)+"px";
	}else{
		$("listFocus").style.top = "464px";
		$("listFocus").style.left = 165+((listBox.focusPos-4)*290)+"px";
	}
}	


function loseListFocus(){
	$("listFocus").style.visibility = "hidden";
}


function getZanFocus(){
	$("zanBtn"+listBox.focusPos).src = "image/love214/20161122-zcrds-btn0_1.png";
}


function loseZanFocus(){
	$("zanBtn"+listBox.focusPos).src ="image/love214/20161122-zcrds-btn0_0.png";
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
     window.location.href = "<%=turnPage.go(-1)%>";
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
	var str = imgData[listBox.position].id;
	var wrapContent = str;
	
	var url = "http://192.168.49.56:8080/voteNew/external/addVote4.ipanel?icid="+caid+"&phone="+inputNum+"&classifyID=375&content="+wrapContent+"&voteCount=5";
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
					if(zanCount>3){
						showTipText("���޳ɹ������ĵ��޴����ѵ�5�Σ������������");
						showSeneryData();
						return;	
					}
					var str = "���޳ɹ�!";
					showTipText(str);
					zanCount++;
					showSeneryData();
				}else{
					//�Ѿ��������
					var str = "���ĵ��޴�����5����!��������";
					showTipText(str);
					//showSeneryData();
				}
			}else{
				//�齱ʧ��
				var str = "ͶƱʧ��!";
					showTipText(str);
			}
			isComplete = true;
		},
 		onError:function(){
			
		}
	});
}

/*  �����ֻ��������ʾ�� ��ش��� fuying end */


</script>




<body background="image/love214/20161122-zcrds-bg0.jpg" topmargin="0" leftmargin="0" onLoad="init()">

<!--ͶƱ����-->
<div style="position:absolute; left:55px; top:171px; width:267px; height:242px; overflow:hidden">
    <div id="listDiv0" style="position:absolute;top:0px; width:267px; height:172px; background:url(image/love214/20161122-zcrds-focus.png);">
        <img id="listImg0" src="" width="261" height="167" style="position:absolute;left:3px;top:2px;">
        <div style="position:absolute;left:2px;top:140px; width:261px; height:29px; background:url(image/love214/20161122-zcrds-pop_cover.png); color:#fff; line-height:29px;font-size:24px; text-align:center">
            <div id="listName0" style="position: absolute; left: 0px; width: 160px;"></div>
            <div id="zanNum0" style="position: absolute; left: 170px; width: 90px;"></div>
        </div>
    </div>
    <div style="position:absolute; left:82px; top:190px; width:88px; height: 61px;"><img id="zanBtn0" src="image/love214/20161122-zcrds-btn0_0.png" width="88" height="61"></div>
</div>

<div style="position:absolute; left:345px; top:171px; width:267px; height:242px;">
    <div id="listDiv1" style="position:absolute;top:0px; width:267px; height:172px; background:url(image/love214/20161122-zcrds-focus.png);">
        <img id="listImg1" src="" width="261" height="167" style="position:absolute;left:3px;top:2px;">
        <div style="position:absolute;left:2px;top:140px; width:261px; height:29px; background:url(image/love214/20161122-zcrds-pop_cover.png); color:#fff; line-height:29px;font-size:24px; text-align:center">
            <div id="listName1" style="position: absolute; left: 0px; width: 160px;"></div>
            <div id="zanNum1" style="position: absolute; left: 170px; width: 90px;"></div>
        </div>
    </div>
    <div style="position: absolute; left: 82px; top: 190px; width: 88px; height: 61px;"><img id="zanBtn1" src="image/love214/20161122-zcrds-btn0_0.png" width="88" height="61"></div>
</div>

<div style="position:absolute;left:633px;top:171px; width:267px; height:242px;">
    <div id="listDiv2" style="position:absolute;top:0px; width:267px; height:172px; background:url(image/love214/20161122-zcrds-focus.png);">
        <img id="listImg2" src="" width="261" height="167" style="position:absolute;left:3px;top:2px;">
        <div style="position:absolute;left:2px;top:140px; width:261px; height:29px; background:url(image/love214/20161122-zcrds-pop_cover.png); color:#fff; line-height:29px;font-size:24px; text-align:center">
            <div id="listName2" style="position: absolute; left: 0px; width: 160px;"></div>
            <div id="zanNum2" style="position: absolute; left: 170px; width: 90px;"></div>
        </div>
    </div>
    <div style="position: absolute; left: 82px; top: 190px; width: 88px; height: 61px;"><img id="zanBtn2" src="image/love214/20161122-zcrds-btn0_0.png" width="88" height="61"></div>
</div>
    
<div style="position:absolute;left:921px;top:171px; width:267px; height:242px;">
    <div id="listDiv3" style="position:absolute;top:0px; width:267px; height:172px; background:url(image/love214/20161122-zcrds-focus.png);">
        <img id="listImg3" src="" width="261" height="167" style="position:absolute;left:3px;top:2px;">
        <div style="position:absolute;left:2px;top:140px; width:261px; height:29px; background:url(image/love214/20161122-zcrds-pop_cover.png); color:#fff; line-height:29px;font-size:24px; text-align:center">
            <div id="listName3" style="position: absolute; left: 0px; width: 160px;"></div>
            <div id="zanNum3" style="position: absolute; left: 170px; width: 90px;"></div>
        </div>
    </div>
    <div style="position: absolute; left: 82px; top: 190px; width: 88px; height: 61px;"><img id="zanBtn3" src="image/love214/20161122-zcrds-btn0_0.png" width="88" height="61"></div>
</div>

<!--�ڶ���-->
<div style="position:absolute;left:55px;top:413px; width:267px; height:242px;">
    <div id="listDiv4" style="position:absolute;top:0px; width:267px; height:172px; background:url(image/love214/20161122-zcrds-focus.png);">
        <img id="listImg4" src="" width="261" height="167" style="position:absolute;left:3px;top:2px;">
        <div style="position:absolute;left:2px;top:140px; width:261px; height:29px; background:url(image/love214/20161122-zcrds-pop_cover.png); color:#fff; line-height:29px;font-size:24px; text-align:center">
            <div id="listName4" style="position: absolute; left: 0px; width: 160px;"></div>
            <div id="zanNum4" style="position: absolute; left: 170px; width: 90px;"></div>
        </div>
    </div>
    <div style="position: absolute; left: 82px; top: 190px; width: 88px; height: 61px;"><img id="zanBtn4" src="image/love214/20161122-zcrds-btn0_0.png" width="88" height="61"></div>
</div>

<div style="position:absolute;left:345px;top:413px; width:267px; height:242px;">
    <div id="listDiv5" style="position:absolute;top:0px; width:267px; height:172px; background:url(image/love214/20161122-zcrds-focus.png);">
        <img id="listImg5" src="" width="261" height="167" style="position:absolute;left:3px;top:2px;">
        <div style="position:absolute;left:2px;top:140px; width:261px; height:29px; background:url(image/love214/20161122-zcrds-pop_cover.png); color:#fff; line-height:29px;font-size:24px; text-align:center">
            <div id="listName5" style="position: absolute; left: 0px; width: 160px;"></div>
            <div id="zanNum5" style="position: absolute; left: 170px; width: 90px;"></div>
        </div>
    </div>
    <div style="position: absolute; left: 82px; top: 190px; width: 88px; height: 61px;"><img id="zanBtn5" src="image/love214/20161122-zcrds-btn0_0.png" width="88" height="61"></div>
</div>

<div style="position:absolute;left:633px;top:413px; width:267px; height:242px;">
    <div id="listDiv6" style="position:absolute;top:0px; width:267px; height:172px; background:url(image/love214/20161122-zcrds-focus.png);">
        <img id="listImg6" src="" width="261" height="167" style="position:absolute;left:3px;top:2px;">
        <div style="position:absolute;left:2px;top:140px; width:261px; height:29px; background:url(image/love214/20161122-zcrds-pop_cover.png); color:#fff; line-height:29px;font-size:24px; text-align:center">
            <div id="listName6" style="position: absolute; left: 0px; width: 160px;"></div>
            <div id="zanNum6" style="position: absolute; left: 170px; width: 90px;"></div>
        </div>
    </div>
    <div style="position: absolute; left: 82px; top: 190px; width: 88px; height: 61px;"><img id="zanBtn6" src="image/love214/20161122-zcrds-btn0_0.png" width="88" height="61"></div>
</div>
    
<div style="position:absolute;left:921px;top:413px; width:267px; height:242px;">
    <div id="listDiv7" style="position:absolute;top:0px; width:267px; height:172px; background:url(image/love214/20161122-zcrds-focus.png);">
        <img id="listImg7" src="" width="261" height="167" style="position:absolute;left:3px;top:2px;">
        <div style="position:absolute;left:2px;top:140px; width:261px; height:29px; background:url(image/love214/20161122-zcrds-pop_cover.png); color:#fff; line-height:29px;font-size:24px; text-align:center">
            <div id="listName7" style="position: absolute; left: 0px; width: 160px;"></div>
            <div id="zanNum7" style="position: absolute; left: 170px; width: 90px;"></div>
        </div>
    </div>
    <div style="position: absolute; left: 82px; top: 190px; width: 88px; height: 61px;"><img id="zanBtn7" src="image/love214/20161122-zcrds-btn0_0.png" width="88" height="61"></div>
</div>

<!--  �б���� ���֮�󲥷Ŷ�Ӧ��Ƶ -->

<div id="listFocus" style="position:absolute; left:162px; top:476px; width:52px; height:57px; background: url(image/love214/20161122-zcrds-icon_play.png) no-repeat center; visibility: visible"></div>
	
<!--������-->
<div style="position:absolute;left:1222px;top:90px; width:2px; height:424px; background:#c8c8c8;">
    <div id="scrollBar" style="position:absolute;left:-12px;top:0px; width:26px; height:56px; background:url(image/love214/20161122-zcrds-pageBg.png); font-size:21px; color:#fff; text-align:center; line-height:28px;">
	<span>1</span><br/>
  <span>5</span></div>
    <div style="position:absolute;left:-15px;top:410px; width:30px; height:80px; "><img id="topBtn" src="image/love214/btn_top01.jpg" width="30" height="80"></div>
</div>
<div style="position:absolute; left:60px; top:668px; width:300px; font-size:17px; color:#fff; ">* ע����������λ�����Ⱥ�</div>

<!-- title  ���������� ��Ȼ���ױ���ס-->
<div style="position:absolute; left:114px; top:28px; width:1084px; height:161px;"><img src="image/love214/20161122-zcrds-title.png" width="1084" height="161"></div>
	 
     
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
