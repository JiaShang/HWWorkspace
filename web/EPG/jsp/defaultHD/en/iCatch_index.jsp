<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="datajspHD/iCatchNew_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<meta name="page-view-size" content="1280*720">
<title></title>
<link href="iCatch_image/main.css" rel="stylesheet" type="text/css"/>
<script language="javascript" type="text/javascript">
<!--
iPanel.eventFrame.initPage(window);

var focusArea = 1;	//������������0�������棬1�ڲ˵���2������б�3���м��ͼ��4���ұ�ͼƬ�б�5�����水ť
var topButton = {
    searchInputObj: null,
    focusPos: 0,
    buttons: [
        {
            id: "search",
            name: "������",
        },
        {
            id: "btnMovie",
            name: "ӰƬ",
            url: "",
            num: 2
        },
        {
            id: "btnActor",
            name: "��Ա",
            url: "",
            num: 1
        },
        {
            id: "btnDirector",
            name: "����",
            url: "",
            num: 0
        }
    ],
    focusImg: "iCatch_image/search_btn1.png",
    loseFocusImg: "iCatch_image/search_btn0.png"
};	//������������
var menuData = [
    {name: "�� �� Ƭ", url: "iCatch_kandianying.jsp?charVodId=10000100000000090000000000100880&imgVodId=10000100000000090000000000100889&bigImgVodId=10000100000000090000000000101001"},
    {name: "׷ �� ��", url: "iCatch_zhuireju.jsp?charVodId=10000100000000090000000000100881&imgVodId=10000100000000090000000000100890&bigImgVodId=10000100000000090000000000101002"},
    {name: "ר �� ��", url: "iCatch_zhuantihui.jsp?listTypeId=10000100000000090000000000100882&recommendTypeId=10000100000000090000000000100891"},
    {name: "�� �� ��", url: "iCatch_zcq.jsp?typeId=10000100000000090000000000101285&imgVodId=10000100000000090000000000101286&imgVodLen=3&imgTypeId=10000100000000090000000000101287&imgTypeLen=1"},
    {name: "�� �� Ȧ", url: "iCatch_yuleq.jsp?typeId=10000100000000090000000000100883&imgVodId=10000100000000090000000000100893&imgVodLen=2&imgTypeId=10000100000000090000000000100892&imgTypeLen=3"}
];	//�˵�����
var menuObj = null;	//�˵�����
var menuFocusPos = 0;
var listData = [];
var listObj = null;
var listFocusPos = 0;
var bigData = {};	//�м��ͼƬ����
var picData = [];
var picObj = null;
var picFocusPos = 0;
var bottomButton = {
    id: "home",
    focusImg: "iCatch_image/footbtn1_01.png",
    loseFocusImg: "iCatch_image/footbtn0_01.png"
};
var marqueeText = "�������� ���������ƿ� �������ʽ�Ŀ��Ӱ�Ӵ�Ƭ���������㲥������72Сʱ�Ŀɻؿ�   �����㲥";	//���������
var parames = location.search;


var markArray = ["iCatch_image/icon_mark12.png", "iCatch_image/icon_mark11.png", "iCatch_image/icon_mark10.png",
    "iCatch_image/icon_mark12.png", "iCatch_image/icon_mark11.png", "iCatch_image/icon_mark10.png",
    "iCatch_image/icon_mark12.png", "iCatch_image/icon_mark11.png"
];

var typeId = "";
var vodId = 0;

/*
 if (parames != "") {
 var parArray = function(str){
 var tempArray = str.split("&");
 var par = {};
 var len = tempArray.length;

 for (var i = 0; i < len; i ++) {
 var tempPar = tempArray[i].split("=");

 par[tempPar[0]] = tempPar[1];
 }

 return par;

 }(parames.substr(1));

 if (typeof(parArray.indexmainfocus) != "undefiend" && !isNaN(parseInt(parArray.indexmainfocus,10))) {
 focusArea = parseInt(parArray.indexmainfocus,10);

 if (typeof(parArray.indexfocus) != "undefined" && !isNaN(parseInt(parArray.indexfocus,10))) {
 var focusPos = parseInt(parArray.indexfocus,10);

 switch (focusArea) {
 case 0:
 topButton.focusPos = focusPos;
 break;
 case 1:
 menuFocusPos = focusPos;
 break;
 case 2:
 listFocusPos = focusPos;
 break;
 case 4:
 picFocusPos = focusPos;
 break;
 }
 }
 }
 }
 */
function eventHandler(eventObj, type) {

    if (type == 1 && key_flag == 2) {//�㲥���ţ�ȥ���н�Ŀ��Ȩ
        return 0;
    } else if (type == 1 && key_flag == 1) {//����ʾ�򵯳���
        return tipkeypress(eventObj.code);
    } else {
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
                doInput(eventObj.args.value);
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
}

function init() {

    //��ʼ������
    initDatas();

    //��ʼ������

    focusArea = icatchFocusArea;
    topButton.focusPos = icatchTopButtonFocusPos;
    menuFocusPos = icatchMenuFocusPos;
    listFocusPos = icatchListFocusPos;
    picFocusPos = icatchPicFocusPos;

    initInputBox();
    initTopButton();
    initMenu();
    initList();
    showBigPic();
    initPicList();
    showBottomButton();
    showMarquee();
}

function delayInit() {
    setTimeout("init()", 30);
}

//��ʼ������
function initDatas() {
    //����б�����
    if (leftTypeArray.length > 0) {
        listData[0] = leftTypeArray[0];
        listData = listData.concat(vodCharArray);
    }
    //listData = vodCharArray;
    //�м��ͼ����
    bigData = vodBigImgArray[0];

    //���ͼƬ���ݣ���һ������Ŀ�����漸����vod
    if (typeArray.length > 0 && vodSmallImgArray.length > 0) {
        picData = [];
        picData[0] = vodSmallImgArray[0];
        picData[1] = typeArray[0];
    }
    marqueeText = content;
    E.marqueeText = content;
}

//��ʼ�������
function initInputBox() {
    topButton.searchInputObj = new E.input_obj(topButton.buttons[0].id, "normal", $(topButton.buttons[0].id).innerText, window, 7, "iCatch_image/focus.gif", "iCatch_image/global_tm.gif", 20);

    if (focusArea == 0 && topButton.focusPos == 0) {
        topButton.searchInputObj.show_cursor();
    }
}

//��ʼ��������ť
function initTopButton() {
    var len = topButton.buttons.length;

    for (var i = 1; i < len; i++) {
        var button = topButton.buttons[i];

        $(button.id).innerText = button.name;
        $(button.id).style.backgroundImage = "url(" + ((focusArea == 0 && topButton.focusPos == i) ? topButton.focusImg : topButton.loseFocusImg) + ")";
    }
}

//��ʼ���˵�
function initMenu() {
    menuObj = new E.showList(5, menuData.length, menuFocusPos, 70, window);
    menuObj.listHigh = 180;
    menuObj.listSign = 1;
    menuObj.focusDiv = "menuFocus";
    menuObj.haveData = setMenu;
    menuObj.notData = clearMenu;
    menuObj.startShow();
    $(menuObj.focusDiv).style.webkitTransitionDuration = "100ms";

    if (focusArea == 1) {
        $(menuObj.focusDiv).style.visibility = "visible";
        showMeunText();
    }
}

function showMeunText() {
    $("mainName").innerText = menuData[menuObj.position].name;
}

//���ò˵�����
function setMenu(list) {
    $("menu" + list.idPos).innerText = menuData[list.dataPos].name;
}

//����˵�����
function clearMenu(list) {
    $("menu" + list.idPos).innerText = "";
}

//��ʼ���б�
function initList() {
    listObj = new E.showList(8, listData.length, listFocusPos, 195, window);
    listObj.listHigh = 50;
    listObj.focusDiv = "listFocus";
    listObj.haveData = setList;
    listObj.notData = clearList;
    listObj.startShow();

    if (focusArea == 2) {
        setListStyle(true);
        $(listObj.focusDiv).style.visibility = "visible";
    }
}

//�����б�����
function setList(list) {
    var tempListData = listData[list.dataPos];
    var idPos = list.idPos;

    if (tempListData.type != "") {
        $("type" + idPos).innerText = tempListData.type;
        $("type" + idPos).style.visibility = "visible";
    }
    $("list" + idPos).innerText = iPanel.misc.interceptString(tempListData.name, 20);
    $("list" + idPos).style.backgroundImage = "url(iCatch_image/btm0_0.png)";
}

//����б�����
function clearList(list) {
    var idPos = list.idPos;

    $("type" + idPos).style.visibility = "hidden";
    $("list" + idPos).innerText = "";
    $("list" + idPos).style.backgroundImage = "url(iCatch_image/global_tm.gif)";
}

//�����б���ʽ
function setListStyle(flag) {
    var name = listData[listObj.position].name;
    var focusPos = listObj.focusPos;
    var tempName = iPanel.misc.interceptString(name, 20);
    var type = listData[listObj.position].type;

    //$("list" + focusPos).style.backgroundImage = flag ? "url(iCatch_image/btm0_1.png)" : "url(iCatch_image/btm0_0.png)";
    //$("list" + focusPos).style.color = flag ? "#fefefe" : "#6a6868";

    if (name != tempName) {
        /*
         if (flag) {
         $("list" + focusPos).innerHTML = "<marquee style=\"width:260px;height:48px;\">" + name + "</marquee>";
         }
         else {
         $("list" + focusPos).innerText = tempName;
         }
         */
        $("listfocuslist").innerHTML = "<marquee style=\"width:260px;height:47px;\">" + name + "</marquee>";
    }
    else {
        $("listfocuslist").innerText = tempName;
    }
    $("listtype").innerText = type;

    if (type != "") {
        $("listtype").style.backgroundImage = "url(" + markArray[listObj.position] + ")";
    }
    else {
        $("listtype").style.backgroundImage = "url(iCatch_image/global_tm.gif)";
    }
}

//��ʾ��ͼƬ
function showBigPic() {
    $(bigData.id).style.backgroundImage = "url(" + bigData.img + ")";
    $('bigIcon').src = bigData.iconPath;
    if (focusArea == 3) {
        $("bigPicFocus").style.visibility = "visible";
    }
}

//��ʼ��ͼƬ�б�
function initPicList() {
    picObj = new E.showList(2, picData.length, picFocusPos, 119, window);
    picObj.listHigh = 243;
    picObj.focusDiv = "picFocus";
    picObj.haveData = setPic;
    picObj.notData = clearPic;
    picObj.startShow();

    if (focusArea == 4) {
        setPicListStyle(true);
        $(picObj.focusDiv).style.visibility = "visible";
    }
}

//����ͼƬ�б�����
function setPic(list) {
    var pic = picData[list.dataPos];
    var idPos = list.idPos;

    $("picbg" + idPos).style.backgroundImage = "url(iCatch_image/SmallPic_bg0.png)";
    $("pic" + idPos).src = pic.img;
    $("picname" + idPos).innerText = iPanel.misc.interceptString(pic.name, 16);
}

//���ͼƬ�б�����
function clearPic(list) {
    var idPos = list.idPos;

    $("picbg" + idPos).style.backgroundImage = "url(iCatch_image/global_tm.gif)";
    $("pic" + idPos).src = "iCatch_image/global_tm.gif";
    $("picname" + idPos).innerText = "";
}

//��ʾ�ײ���ť
function showBottomButton() {
    $(bottomButton.id).src = focusArea == 5 ? bottomButton.focusImg : bottomButton.loseFocusImg;
}

//����ͼƬ�б���ʽ
function setPicListStyle(flag) {
    var pic = picData[picObj.position];
    var name = pic.name;
    var tempName = iPanel.misc.interceptString(name, 16);
    var focusPos = picObj.focusPos;

    if (name != tempName) {
        if (flag) {
            $("picname" + focusPos).innerHTML = "<marquee style=\"width:219px;height:34px;\">" + name + "</marquee>";
        }
        else {
            $("picname" + focusPos).innerText = tempName;
        }
    }
}

//�����ƶ�
function udMove(num) {
    switch (focusArea) {
        case 0:	//�����ڶ�����ť��
            if (num > 0) {
                if (topButton.focusPos == 0) {
                    topButton.searchInputObj.lose_focus();
                }
                else {
                    $(topButton.buttons[topButton.focusPos].id).style.backgroundImage = "url(" + topButton.loseFocusImg + ")";
                }

                if (picObj.dataSize > 0) {
                    $(picObj.focusDiv).style.webkitTransitionDuration = "0ms";
                    picObj.changeList(-1 * picObj.focusPos);
                    $(picObj.focusDiv).style.webkitTransitionDuration = "50ms";
                    setPicListStyle(true);
                    $(picObj.focusDiv).style.visibility = "visible";
                    focusArea = 4;
                }
                else {	//����ұ�ͼƬ�б�û�����ݵĻ����Ǿͽ������Ƶ��˵���
                    $("menuFocus").style.visibility = "visible";
                    focusArea = 1;
                    showMeunText();
                }
            }
            break;
        case 1:	//�����ڲ˵���
            $("menuFocus").style.visibility = "hidden";

            if (num > 0) {
                if (listObj.dataSize > 0) {
                    listObj.changeList(-1 * listObj.focusPos);
                    setListStyle(true);
                    focusArea = 2;
                    $(listObj.focusDiv).style.visibility = "visible";
                }
                else {	//�������б�û�����ݣ��򽫽����Ƶ��м��ͼ��
                    $("bigPicFocus").style.visibility = "visible";
                    focusArea = 3;
                }
            }
            else {
                if (topButton.focusPos == 0) {
                    topButton.searchInputObj.show_cursor();
                }
                else {
                    $(topButton.buttons[topButton.focusPos].id).style.backgroundImage = "url(" + topButton.focusImg + ")";
                }
                focusArea = 0;
            }
            break;
        case 2:	//����������б���
            setListStyle(false);

            if (listObj.position == 0 && num < 0) {
                $(listObj.focusDiv).style.visibility = "hidden";
                $("menuFocus").style.visibility = "visible";
                focusArea = 1;
                showMeunText();
            }
            else if (listObj.position == listObj.dataSize - 1 && num > 0) {
                $(listObj.focusDiv).style.visibility = "hidden";
                $(bottomButton.id).src = bottomButton.focusImg;
                focusArea = 5;
            }
            else {
                listObj.changeList(num);
                setListStyle(true);
            }
            break;
        case 3:	//�������м��ͼ��
            $("bigPicFocus").style.visibility = "hidden";
            if (num > 0) {
                $(bottomButton.id).src = bottomButton.focusImg;
                focusArea = 5;
            }
            else {
                $("menuFocus").style.visibility = "visible";
                focusArea = 1;
                showMeunText();
            }
            break;
        case 4:	//������ͼƬ�б���
            setPicListStyle(false);
            if (picObj.position == 0 && num < 0) {
                $(picObj.focusDiv).style.visibility = "hidden";
                if (topButton.focusPos == 0) {
                    topButton.searchInputObj.show_cursor();
                }
                else {
                    $(topButton.buttons[topButton.focusPos].id).style.backgroundImage = "url(" + topButton.focusImg + ")";
                }
                focusArea = 0;
            }
            else if (picObj.position == picObj.dataSize - 1 && num > 0) {
                $(picObj.focusDiv).style.visibility = "hidden";
                $(bottomButton.id).src = bottomButton.focusImg;
                focusArea = 5;
            }
            else {
                picObj.changeList(num);
                setPicListStyle(true);
            }
            break;
        case 5:	//�����ڵײ���ť��
            if (num < 0) {
                $(bottomButton.id).src = bottomButton.loseFocusImg;

                if (listObj.dataSize > 0) {
                    listObj.changeList(listObj.listSize - listObj.focusPos - 1);
                    setListStyle(true);
                    focusArea = 2;
                    $(listObj.focusDiv).style.visibility = "visible";
                }
                else {	//����б�û�����ݣ��򽫽����Ƶ��м��ͼ��
                    $("bigPicFocus").style.visibility = "visible";
                    focusArea = 3;
                }
            }
            break;
    }
}

//�����ƶ�
function lrMove(num) {
    switch (focusArea) {
        case 0:	//�����ڶ�����ť��
            if (topButton.focusPos == 0) {
                if (topButton.searchInputObj.cursor_pos == topButton.searchInputObj.input_str.length && num > 0) {
                    topButton.searchInputObj.lose_focus();
                }
                else {
                    topButton.searchInputObj.move_input(num);
                    return;
                }
            }
            else {
                $(topButton.buttons[topButton.focusPos].id).style.backgroundImage = "url(" + topButton.loseFocusImg + ")";
            }
            topButton.focusPos += num;

            if (topButton.focusPos > topButton.buttons.length - 1) {
                topButton.focusPos = topButton.buttons.length - 1;
            }
            else if (topButton.focusPos < 0) {
                topButton.focusPos = 0;
            }

            if (topButton.focusPos == 0) {
                topButton.searchInputObj.show_cursor();
            }
            else {
                $(topButton.buttons[topButton.focusPos].id).style.backgroundImage = "url(" + topButton.focusImg + ")";
            }
            break;
        case 1:	//�����ڲ˵���
            if (menuObj.position == menuObj.dataSize - 1 && num > 0) {
                $("menuFocus").style.visibility = "hidden";
                $(picObj.focusDiv).style.webkitTransitionDuration = "0ms";
                picObj.changeList(-1 * picObj.focusPos);
                setPicListStyle(true);
                $(picObj.focusDiv).style.visibility = "visible";
                $(picObj.focusDiv).style.webkitTransitionDuration = "50ms";
                focusArea = 4;
            }
            else {
                menuObj.changeList(num);
                showMeunText();

            }
            break;
        case 2:	//����������б���
            if (num > 0) {
                $(listObj.focusDiv).style.visibility = "hidden";
                setListStyle(false);
                $("bigPicFocus").style.visibility = "visible";
                focusArea = 3;
            }
            break;
        case 3:	//�������м��ͼ��
            $("bigPicFocus").style.visibility = "hidden";
            if (num > 0) {
                setPicListStyle(true);
                $(picObj.focusDiv).style.visibility = "visible";
                focusArea = 4;
            }
            else {
                setListStyle(true);
                focusArea = 2;
                $(listObj.focusDiv).style.visibility = "visible";
            }
            break;
        case 4:	//������ͼƬ�б���
            if (num < 0) {
                $(picObj.focusDiv).style.visibility = "hidden";
                setPicListStyle(false);
                $("bigPicFocus").style.visibility = "visible";
                focusArea = 3;
            }
            break;
    }
}

function doSelect() {
    switch (focusArea) {
        case 0:	//�����ڶ�����ť��
            if (topButton.focusPos > 0) {
                var searchKeyWord = topButton.searchInputObj.input_str;

                var url = focusURL();
                window.location.href = url + "myTV_search.jsp?typeId=" + imgSmallTypeId + "&keyWord=" + searchKeyWord + "&searchType=" + topButton.buttons[topButton.focusPos].num + "&from=icatch";
            }
            break;
        case 1:	//�����ڲ˵���
            var url = menuData[menuObj.position].url;
            var baseURL = focusURL();
            window.location.href = baseURL + url;
            break;
        case 2:	//�������б���
            if (listObj.dataSize > 0) {
                //��һ������Ŀ����������Ӧ��Ŀҳ��
                if (listObj.position == 0) {
                    var baseURL = focusURL();
                    var typeObj0 = listData[listObj.position];
                    iPanel.eventFrame.showType = 0;//��ʾ�Ǹ�ͼƬ
                    if (typeObj0.name == '��������ս����') {// �������Ӣ�۷��� 2013-11-28
                        window.location.href = baseURL + "/EPG/jsp/neirong/S20160325.jsp";
                    } else {//������Ĭ��ҳ��
                        window.location.href = baseURL + "iCatch_yulq_list.jsp?typeId=" + typeObj0.typeId + "&pageLength=8";
                    }
                } else {//ΪӰƬ
                    typeId = charTypeId;
                    vodId = listData[listObj.position].vodId;
                    var playType = listData[listObj.position].playType;
                    if (typeId != '' && vodId != 0) {
                        play_movie(playType);
                    }
                }
            }
            break;
        case 3:	//�������м��ͼ��
            typeId = imgBigTypeId;
            vodId = bigData.vodId;
            var playType = bigData.playType;
            if (bigData.blockName == '2015���������������') {// �й���ģ 2015-6-11
                window.location.href = focusURL() + "cqlama3_index.jsp?typeId=10000100000000090000000000105402&pageSize=50&startIndex=0";
            } else if (typeId != '' && vodId != 0) {
                play_movie(playType);
            }
            break;
        case 4:	//������ͼƬ�б���
            if (picObj.dataSize > 0) {
                var index = picObj.position;
                var baseurl = focusURL();
                if (index == 1) { //������ר���ַ
                    var typeObj0 = picData[picObj.position];
                    iPanel.eventFrame.showType = 0;//��ʾ�Ǹ�ͼƬ�ϸ��
                    if (typeObj0.name == '�㱬���������ʱȫ��') { // �������Ӣ�۷��� 2013-11-28
                        window.location.href = baseurl + "/EPG/jsp/neirong/S20160322.jsp";
                    } else {//������Ĭ��ҳ��
                        window.location.href = baseurl + "iCatch_yulq_list.jsp?typeId=" + typeObj0.typeId + "&pageLength=8";
                    }
                } else {//vodֱ�Ӳ���
                    typeId = imgSmallTypeId;
                    vodId = picData[picObj.position].vodId;
                    var playType = picData[picObj.position].playType;
                    if (typeId != '' && vodId != 0) {
                        play_movie(playType);
                    }
                }
            }
            break;
        case 5:	//�����ڵײ㰴ť��
            doMenu();
            break;
    }
}

//���潹��λ��
function saveFocusPos() {
    E.icatchFocusArea = focusArea;
    E.icatchTopButtonFocusPos = topButton.focusPos;
    E.icatchMenuFocusPos = menuObj.position;
    E.icatchListFocusPos = listObj.position;
    E.icatchPicFocusPos = picObj.position;
}


function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + topButton.focusPos + "," + menuObj.position + "," + listObj.position + "," + picObj.position + "&url=";
    return baseurl;
}

//�򿪲˵�
function doMenu() {
    E.marqueeText = null;
    iPanel.mainFrame.location.href = E.portal_url;
}

//����
function doInput(num) {
    if (focusArea == 0 && topButton.focusPos == 0) {
        topButton.searchInputObj.get_input(num);
    }
}

//ɾ��
function doBack() {
    if (focusArea == 0 && topButton.focusPos == 0) {
        topButton.searchInputObj.del_input();
    } else {
        doMenu();
    }
}

//��ʾ�����
function showMarquee() {
    $("marquee").innerText = marqueeText;
}


/**��Ŀ���ţ�������Ȩҳ��  */
function play_movie(playType) {
    if (playType == 1) {
        //����ǵ��Ӿ�
        window.location.href = focusURL() + "iCatch_TV_detail.jsp?vodId=" + vodId + "&typeId=" + typeId;
    } else {
        //��Ӱֱ�Ӳ���
        getAuthUrl(vodId);
    }
}

/**����ǩ������ */
function tip_fromBookmarkPlay() {
    var tempTime = domark(vodId);
    var baseurl = focusURL();
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&contentType=0&startTime=" + tempTime + "&business=1";
}

/* tipsWindow.jsp��getAuthUrl()�������ã��ӿ�ʼ������ */
function tip_fromBeginPlay() {
    var baseurl = focusURL();
    $("data_ifm").src = baseurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
            + "&progId=" + vodId + "&contentType=0&business=1";
}


//-->
</script>
</head>

<body background="iCatch_image/index_bg.jpg" leftmargin="0" topmargin="0" onLoad="javascript:delayInit();">

<!--Logo-->
<div style="position:absolute; left:330px; top:45px; width:100px; height:50px;"><img src="iCatch_image/logo.png"
                                                                                     width="100" height="50"/></div>
<div style="position:absolute; left:408px; top:61px; width:158px; height:36px;"><img src="iCatch_image/logo_title0.png"
                                                                                     width="158" height="36"/></div>


<!--Search-->
<div style="position:absolute; left:872px; top:74px; width:342px; height:42px; background: url(iCatch_image/search_btm.png) no-repeat;">
    <table width="100%" height="42px" border="0" cellspacing="0" cellpadding="0"
           style="color:#fff; font-size:15px; line-height:42px; text-align:center;">
        <tr>
            <td width="218" height="33" style="vertical-align:middle;"><span id="search"
                                                                             style="font-size:20px; font-weight:bold; width:217px; padding-left:25px; height:33px; text-align:left;"></span>
            </td>
            <td width="42" class="searchbtn0" id="btnMovie"></td>
            <td width="41" class="searchbtn0" id="btnActor"></td>
            <td width="41" class="searchbtn0" id="btnDirector"></td>
        </tr>
    </table>
</div>

<!--First Menu-->
<div style="position:absolute; left:70px; top:115px; width:187px; height:69px; background:url(iCatch_image/focus00.png) center no-repeat; visibility:hidden;"
     id="menuFocus">
    <table width="100%" height="100%" align="center">
        <tr>
            <td align="center" style="font-size:24px; color:#fff; line-height:50px; font-weight:bold;"
                id="mainName"></td>
        </tr>
    </table>
</div>
<div style="position:absolute; left:73px; top:130px; width:900px; height:50px; z-index:10;">
    <table width="900" height="50" border="0" cellspacing="0" cellpadding="0"
           style="font-size:24px; color:#fff; line-height:50px; font-weight:bold; ">
        <tr>
            <td width="180" height="50" align="center" id="menu0"></td>
            <td width="180" align="center" id="menu1"></td>
            <td width="180" align="center" id="menu2"></td>
            <td width="180" align="center" id="menu3"></td>
            <td width="180" align="center" id="menu4"></td>
        </tr>
    </table>
</div>

<!--Left List-->
<div style="position:absolute;left:73px; top:195px; width:340px; height:49px; background:url(iCatch_image/btm0_1.png) no-repeat left center; color:#fefefe;-webkit-transition-duration:50ms; visibility:hidden;"
     id="listFocus">
    <table width="340" height="49" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="70"
                style="width:70px; height:49px; background:url(iCatch_image/icon_mark0.png) 15px top no-repeat; font-size:14px; color:#ffffff; text-align:center; line-height:30px; padding-left:10px; padding-top:-10px;"
                id="listtype"></td>
            <td width="270" style="font-size:24px; color:#fefefe; height:49px; line-height:49px; text-align:left;"
                id="listfocuslist"></td>
        </tr>
    </table>
</div>

<div style="position:absolute; left:73px; top:195px; width:340px; height:400px;">
    <table width="340" height="400" border="0" cellspacing="0" cellpadding="0" class="btm0_0">
        <tr>
            <td width="340" height="50" style="background:url() no-repeat left center; color:#6a6868;" id="list0"></td>
        </tr>
        <tr>
            <td height="50" style="background:url() no-repeat left center; color:#6a6868;" id="list1"></td>
        </tr>
        <tr>
            <td height="50" style="background:url() no-repeat left center; color:#6a6868;" id="list2"></td>
        </tr>
        <tr>
            <td height="50" style="background:url() no-repeat left center; color:#6a6868;" id="list3"></td>
        </tr>
        <tr>
            <td height="50" style="background:url() no-repeat left center; color:#6a6868;" id="list4"></td>
        </tr>
        <tr>
            <td height="50" style="background:url() no-repeat left center; color:#6a6868;" id="list5"></td>
        </tr>
        <tr>
            <td height="50" style="background:url() no-repeat left center; color:#6a6868;" id="list6"></td>
        </tr>
        <tr>
            <td height="50" style="background:url() no-repeat left center; color:#6a6868;" id="list7"></td>
        </tr>
    </table>
</div>
<div class="icon_mark0"
     style="position:absolute; left:89px; top:195px; visibility:hidden;background:url(iCatch_image/icon_mark12.png) left top no-repeat;"
     id="type0"></div>
<div class="icon_mark0"
     style="position:absolute; left:89px; top:245px; visibility:hidden;background:url(iCatch_image/icon_mark11.png) left top no-repeat;"
     id="type1"></div>
<div class="icon_mark0"
     style="position:absolute; left:89px; top:295px; visibility:hidden;background:url(iCatch_image/icon_mark10.png) left top no-repeat;"
     id="type2"></div>
<div class="icon_mark0"
     style="position:absolute; left:89px; top:345px; visibility:hidden;background:url(iCatch_image/icon_mark12.png) left top no-repeat;"
     id="type3"></div>
<div class="icon_mark0"
     style="position:absolute; left:89px; top:395px; visibility:hidden;background:url(iCatch_image/icon_mark11.png) left top no-repeat;"
     id="type4"></div>
<div class="icon_mark0"
     style="position:absolute; left:89px; top:445px; visibility:hidden;background:url(iCatch_image/icon_mark10.png) left top no-repeat;"
     id="type5"></div>
<div class="icon_mark0"
     style="position:absolute; left:89px; top:495px; visibility:hidden;background:url(iCatch_image/icon_mark12.png) left top no-repeat;"
     id="type6"></div>
<div class="icon_mark0"
     style="position:absolute; left:89px; top:545px; visibility:hidden;background:url(iCatch_image/icon_mark11.png) left top no-repeat;"
     id="type7"></div>

<!--Middle BigPic-->
<div style="position:absolute; left:430px; top:186px; width:556px; height:417px; background:url(iCatch_image/focus01.png) center no-repeat; visibility:hidden;"
     id="bigPicFocus"></div>
<div style="position:absolute; left:440px; top:197px; width:536px; height:395px; background:url() no-repeat;"
     id="bigPic">
    <div style="position:absolute; left:425px; top:-11px; width:120px; height:121px; z-index:10;"><img id="bigIcon"
                                                                                                       src="iCatch_image/icon_zbtj.png"
                                                                                                       width="120"
                                                                                                       height="121"/>
    </div>
    <div style="position:absolute; left:380px; top:340px; width:134px; height:47px;"><img
            src="iCatch_image/icon_play.png" width="134" height="47"/></div>
</div>

<div style="position:absolute; left:988px; top:123px; width:231px; height:239px; background:url(iCatch_image/SmallPic_bg.png) no-repeat;"
     id="picbg0">
    <div style="position:absolute; left:6px; top:5px; width:220px; height:229px;"><img src="" width="220" height="229"
                                                                                       id="pic0"/></div>
    <div class="SmallPic_shade0" style="position:absolute; left:6px; top:198px;" id="picname0"></div>
</div>
<div style="position:absolute; left:988px; top:363px; width:231px; height:239px; background:url(iCatch_image/SmallPic_bg.png) no-repeat;"
     id="picbg1">
    <div style="position:absolute; left:6px; top:5px; width:220px; height:229px;"><img src="" width="220" height="229"
                                                                                       id="pic1"/></div>
    <div class="SmallPic_shade0" style="position:absolute; left:6px; top:198px;" id="picname1"></div>
</div>
<div id="picFocus"
     style="position:absolute; left:985px; top:119px; width:235px; height:243px;-webkit-transition-duration:50ms; visibility:hidden;">
    <img src="iCatch_image/focus22.png" width="235" height="243"/></div>


<!--Bottom-->
<div style="position:absolute; left:70px; top:625px; width:250px; height:45px;">
    <div style="position:absolute; top:1px; left:0px; width:58px; height:44px;"><img src="iCatch_image/footicon.png"
                                                                                     width="58" height="44"/></div>
    <div style="position:absolute; top:3px; left:60px; width:90px; height:42px;"><img src="iCatch_image/footbtn0_01.png"
                                                                                      width="90" height="42" id="home"/>
    </div>
    <div style="position:absolute; top:3px; left:133px; width:90px; height:42px; visibility:hidden;"><img
            src="iCatch_image/footbtn1_02.png" width="90" height="42"/></div>
</div>
<div style="position:absolute; left:352px; top:630px; width:856px; height:40px; font-size:18px; color:#fff; line-height:40px;">
    <marquee id="marquee">
    </marquee>
</div>
<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="showtip.jsp"></jsp:include>
</body>
</html>

