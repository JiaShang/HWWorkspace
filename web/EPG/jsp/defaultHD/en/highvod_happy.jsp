<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="datajspHD/highvod_happy_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<title>高清娱乐</title>
<style>
    .btn0 td {
        background: url(images/hd_vod/btn0_1.png) no-repeat center;
        width: 226px;
        text-align: center;
        font-family: "Adobe 黑体 Std R";
        font-size: 20pt;
        color: #414141;
        line-height: 45px;
    }
</style>
<script language="javascript" type="text/javascript">
<!--
iPanel.eventFrame.initPage(window);

var fosArea = 0;  //0:顶部，1：图片区域vod，2：图片区域栏目，3：按钮区域
//顶部栏目数据
var typeList = [];
var typelistObj = null;

var vodList = [];
var vodlistObj = null;

var vodtypeList = [];
var vodtypeListObj = null;

var typelistFos = 0;
var vodListFos = 0;
var vodtypeListFos = 0;
var buttonIndex = 1;

//最大页数
var needPage = 2;
var currPage = 1;

var buttonData = [
    {name: "首页", focusImg: "images/hd_vod/footbtn1_01.png", lostFocusImg: "images/hd_vod/footbtn0_01.png"},
    {name: "返回", focusImg: "images/hd_vod/footbtn1_02.png", lostFocusImg: "images/hd_vod/footbtn0_02.png"}
];

var picPath = 'images/hd_vod/';

var preUpArea = 1;
var preDownArea = 1;

//滑动
var mainPOS = [
    {left: -120, top: 109},
    {left: 0, top: 163},
    {left: 1400, top: 163}
];


var vodId = '';
var typeId = '';

//是否滑动翻页
var isShadow = true;

function eventHandler(eventObj, type) {
    if (type == 1 && key_flag == 1) {//有提示框弹出来
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

                break;
            case "KEY_MENU":
                doMenu();
                break;
            case "KEY_BACK":
                doMenu();
                break;
            default:
                return 1;
                break;
        }
        return 0;
    }
}


//数据准备
function initData() {
    fosArea = highvodFosArea;
    typelistFos = highvodTypelistFos;
    vodListFos = highvodVodListFos;
    vodtypeListFos = highvodVodtypeListFos;
    currPage = highvodCurrPage;
    needPage = javaNeedPage;

    typeList = topTypeArray;
    vodList = vodArray;
    vodtypeList = imgTypeArray;

}

//初始化顶部栏目列表
function initTypeList() {
    typelistObj = new E.showList(5, typeList.length, typelistFos, 0, window);
    typelistObj.showType = 0;
    typelistObj.haveData = setTypeList;
    typelistObj.notData = clearTypeList;
    typelistObj.startShow();
}

function setTypeList(list) {
    var idPos = list.idPos;
    var tempData = typeList[list.dataPos];
    if (tempData.name != '') {
        $('nav_' + idPos).innerText = tempData.name;
    }
}

function clearTypeList(list) {
    var idPos = list.idPos;
    $('nav_' + idPos).innerText = '';
}

//初始化图片区域vod
function initVodList() {
    vodlistObj = new E.showList(5, vodList.length, vodListFos, 0, window);
    vodlistObj.showType = 0;
    vodlistObj.haveData = setVodList;
    vodlistObj.notData = clearVodList;
    vodlistObj.startShow();
}

function setVodList(list) {
    var idPos = list.idPos;
    var tempData = vodList[list.dataPos];
    if (tempData.img != '') {
        //初始化无焦点时的图片
        $('vod_' + idPos).src = tempData.img;
        //初始化焦点放大图片
        $('vod_f_' + idPos).src = tempData.img;
    }
}

function clearVodList(list) {
    var idPos = list.idPos;
    $('vod_' + idPos).src = picPath + 'global_tm.gif';
    $('vod_f_' + idPos).src = picPath + 'global_tm.gif';
}

//初始化图片区域栏目数据
function initVodtypeList() {
    vodtypeListObj = new E.showList(2, vodtypeList.length, vodtypeListFos, 0, window);
    vodtypeListObj.showType = 0;
    vodtypeListObj.haveData = setVodtypeList;
    vodtypeListObj.notData = clearVodtypeList;
    vodtypeListObj.startShow();
}
function setVodtypeList(list) {
    var idPos = list.idPos;
    var tempData = vodtypeList[list.dataPos];
    if (tempData.img != '') {
        //初始化无焦点时的图片
        $('type_' + idPos).src = tempData.img;
        //初始化焦点放大图片
        $('type_f_' + idPos).src = tempData.img;
    }
}

function clearVodtypeList(list) {
    var idPos = list.idPos;
    $('type_f_' + idPos).src = picPath + 'global_tm.gif';
    $('type_f_' + idPos).src = picPath + 'global_tm.gif';
}

function showCharMarquee(length, isShow) {
    if (fosArea == 1) {
        var index = vodlistObj.position % vodlistObj.listSize;
        var vodName = vodList[vodlistObj.position].name;
        var tempName = iPanel.misc.interceptString(vodName, length);
        if (isShow) {
            if (vodName != tempName) {
                $('vod_name_' + index).innerHTML = "<marquee style=\"width:230px; height:38px;\">" + vodName + "</marquee>";
            }
            else {
                $('vod_name_' + index).innerText = tempName;
            }
        } else {
            $('vod_name_' + index).innerHTML = '&nbsp;';
        }


    } else if (fosArea == 2) {
        var index = vodtypeListObj.position % vodtypeListObj.listSize;
        var typeName = vodtypeList[vodtypeListObj.position].name;
        var tempName = iPanel.misc.interceptString(typeName, length);
        if (isShow) {
            if (typeName != tempName) {
                $('type_name_' + index).innerHTML = "<marquee style=\"width:450px; height:38px;\">" + typeName + "</marquee>";
            }
            else {
                $('type_name_' + index).innerText = tempName;
            }
        } else {
            $('type_name_' + index).innerHTML = '&nbsp;';
        }
    }
}

function setStyle(flag) {
    if (fosArea == 0) {//焦点在顶部
        var index = typelistObj.focusPos;
        if (flag == true) {
            $('nav_' + index).style.background = 'url(' + picPath + '/btn0_2.png) no-repeat center';
            $('nav_' + index).style.color = '#ffffff';
        } else {
            $('nav_' + index).style.background = 'url(' + picPath + '/btn0_1.png) no-repeat center';
            $('nav_' + index).style.color = '#414141';
        }
    } else if (fosArea == 1) {//焦点在图片区域vod上
        var index = vodlistObj.position % vodlistObj.listSize;
        if (flag == true) {
            $('shadow2_' + index).style.visibility = 'visible';
            $('shadow_' + index).style.visibility = 'visible';
        } else {
            $('shadow2_' + index).style.visibility = 'hidden';
            $('shadow_' + index).style.visibility = 'hidden';
        }
        showCharMarquee(24, flag);
    } else if (fosArea == 2) {//焦点在图片区域栏目上
        var index = vodtypeListObj.position % vodtypeListObj.listSize;
        if (flag == true) {
            $('shadow_type2_' + index).style.visibility = 'visible';
            $('shadow_type_' + index).style.visibility = 'visible';
        } else {
            $('shadow_type2_' + index).style.visibility = 'hidden';
            $('shadow_type_' + index).style.visibility = 'hidden';
        }
        showCharMarquee(48, flag);
    } else if (fosArea == 3) {//焦点在按钮区域
        $('foot_' + buttonIndex).src = (flag == true) ? buttonData[buttonIndex].focusImg : buttonData[buttonIndex].lostFocusImg;
    }
}


function setStyleArrow(currPage) {
    $('arrowLeft').style.visibility = currPage <= 1 ? 'hidden' : 'visible';
    $('arrowRight').style.visibility = currPage < needPage ? 'visible' : 'hidden';
}

//计算出元素下标为0的数据下标
function getDataPosByidPos(idPos, currPage, size) {
    var startIndex = currPage * size - size;
    var endIndex = currPage * size - 1;
    var result = startIndex;
    for (var i = startIndex; i <= endIndex; i++) {
        if (i % size == idPos) {
            result = i;
            break;
        }
    }
    return result;
}


//分页处理
function page(num) {
    if (currPage < needPage && num > 0) {
        vodlistObj.changePage(num);
        vodtypeListObj.changePage(num);
        var temp = (vodlistObj.currPage <= vodtypeListObj.currPage) ? vodlistObj.currPage : vodtypeListObj.currPage;
        currPage = temp;
        setStyleArrow(currPage);
    } else if (currPage > 1 && num < 0) {
        vodlistObj.changePage(num);
        vodtypeListObj.changePage(num);
        var temp = (vodlistObj.currPage <= vodtypeListObj.currPage) ? vodlistObj.currPage : vodtypeListObj.currPage;
        currPage = temp;
        setStyleArrow(currPage);
    }
}


//滑动效果
function shadow(num) {
    if (num > 0) {
        $('panel').style.visibility = 'visible';
        $('panel').style.webkitTransitionDuration = "100ms";
        $('panel').style.left = mainPOS[0].left;
        var tempTimer = setTimeout(function () {
            $('panel').style.visibility = 'hidden';
            page(num);
            $('panel').style.webkitTransitionDuration = "0ms";
            $('panel').style.left = mainPOS[2].left;
            $('panel').style.webkitTransitionDuration = "100ms";
            var tempTimer2 = setTimeout(function () {
                $('panel').style.visibility = 'visible';
                $('panel').style.left = mainPOS[1].left;
                clearTimeout(tempTimer2);
            }, 100);

            clearTimeout(tempTimer);
        }, 100);

        //transition-delay
    } else {
        $('panel').style.visibility = 'visible';
        $('panel').style.webkitTransitionDuration = "100ms";
        $('panel').style.left = mainPOS[2].left;
        var tempTimer = setTimeout(function () {
            $('panel').style.visibility = 'hidden';
            page(num);
            $('panel').style.webkitTransitionDuration = "0ms";
            $('panel').style.left = mainPOS[0].left;
            $('panel').style.webkitTransitionDuration = "100ms";
            var tempTimer2 = setTimeout(function () {
                $('panel').style.visibility = 'visible';
                $('panel').style.left = mainPOS[1].left;
                clearTimeout(tempTimer2);
            }, 100);

            clearTimeout(tempTimer);
        }, 100);
    }
}

//上下移动
function udMove(num) {
    setStyle(false);
    switch (fosArea) {
        case 0: //焦点在顶部区域
            if (num > 0) {
                fosArea = preUpArea;
            }
            break;
        case 1: //焦点在图片区域vod

            var dataPos = vodlistObj.position;
            var vodIndex = dataPos % vodlistObj.listSize;
            var vodPage = vodlistObj.currPage;

            var typePos = vodtypeListObj.position;
            var typeIndex = typePos % vodtypeListObj.listSize;
            var typePage = vodtypeListObj.currPage;
            if (num > 0) {
                if (vodIndex == 0 || vodIndex == 3 || vodIndex == 4) {
                    preDownArea = fosArea;
                    fosArea = 3;
                } else if (vodIndex >= 1 && vodIndex <= 2) {
                    fosArea = 2;
                    var temp = getDataPosByidPos(1, typePage, vodtypeListObj.listSize);
                    vodtypeListObj.changeList(temp - typePos);
                }
            } else {
                if (vodIndex >= 0 && vodIndex <= 2) {
                    preUpArea = fosArea;
                    fosArea = 0;
                } else if (vodIndex >= 3 && vodIndex <= 4) {
                    fosArea = 2;
                    var temp = getDataPosByidPos(0, typePage, vodtypeListObj.listSize);
                    vodtypeListObj.changeList(temp - typePos);
                }
            }
            break;
        case 2: //焦点在图片区域栏目
            var dataPos = vodlistObj.position;
            var vodIndex = dataPos % vodlistObj.listSize;
            var vodPage = vodlistObj.currPage;

            var typePos = vodtypeListObj.position;
            var typeIndex = typePos % vodtypeListObj.listSize;
            var typePage = vodtypeListObj.currPage;
            if (num > 0) {
                if (typeIndex == 0) {
                    fosArea = 1;
                    var temp = getDataPosByidPos(4, vodPage, vodlistObj.listSize);
                    vodlistObj.changeList(temp - dataPos);
                } else if (typeIndex == 1) {
                    preDownArea = fosArea;
                    fosArea = 3;
                }
            } else {
                if (typeIndex == 0) {
                    preUpArea = fosArea;
                    fosArea = 0;
                } else if (typeIndex == 1) {
                    fosArea = 1;
                    var temp = getDataPosByidPos(1, vodPage, vodlistObj.listSize);
                    vodlistObj.changeList(temp - dataPos);
                }
            }
            break;
        case 3: //焦点在底部按钮区域
            if (num < 0) {
                fosArea = preDownArea;
            }
            break;
    }
    setStyle(true);
}

//左右移动
function lrMove(num) {
    setStyle(false);
    switch (fosArea) {
        case 0: //焦点在顶部区域
            var index = typelistObj.focusPos;
            if (num > 0 && index <= typelistObj.listSize - 2) {
                typelistObj.changeList(num);
            } else if (num < 0 && (index > 0 && index <= typelistObj.listSize - 1)) {
                typelistObj.changeList(num);
            }
            break;
        case 1: //焦点在图片区域vod
            var dataPos = vodlistObj.position;
            var vodIndex = dataPos % vodlistObj.listSize;
            var vodPage = vodlistObj.currPage;

            var typePos = vodtypeListObj.position;
            var typeIndex = typePos % vodtypeListObj.listSize;
            var typePage = vodtypeListObj.currPage;

            if (num > 0) {
                if (vodIndex <= 1 || vodIndex == 3) {
                    vodlistObj.changeList(num);
                } else if (vodIndex == 2) {
                    fosArea = 2;
                    //计算出元素下标为0的数据下标
                    var temp = getDataPosByidPos(0, typePage, vodtypeListObj.listSize);
                    vodtypeListObj.changeList(temp - typePos);
                } else if (vodIndex == 4) {
                    //翻页处理
                    if (isShadow) {
                        if (currPage < needPage && num > 0) {
                            shadow(num);
                        }
                    } else {
                        page(num);
                    }


                }
            } else {
                if ((vodIndex <= 2 && vodIndex > 0) || vodIndex == 4) {
                    vodlistObj.changeList(num);
                } else if (vodIndex == 3) {
                    fosArea = 2;
                    var temp = getDataPosByidPos(1, typePage, vodtypeListObj.listSize);
                    vodtypeListObj.changeList(temp - typePos);
                } else if (vodIndex == 0) {
                    //翻页处理
                    //page(num);
                    if (isShadow) {
                        if (currPage > 1 && num < 0) {
                            shadow(num);
                        }
                    } else {
                        page(num);
                    }

                }
            }
            break;
        case 2: //焦点在图片区域栏目
            var dataPos = vodlistObj.position;
            var vodIndex = dataPos % vodlistObj.listSize;
            var vodPage = vodlistObj.currPage;

            var typePos = vodtypeListObj.position;
            var typeIndex = typePos % vodtypeListObj.listSize;
            var typePage = vodtypeListObj.currPage;

            if (num > 0) {
                if (typeIndex == 0) {
                    //翻页处理
                    if (isShadow) {
                        if (currPage < needPage && num > 0) {
                            shadow(num);
                        }
                    } else {
                        page(num);
                    }

                } else if (typeIndex == 1) {
                    fosArea = 1;
                    var temp = getDataPosByidPos(3, vodPage, vodlistObj.listSize);
                    vodlistObj.changeList(temp - dataPos);
                }

            } else {
                if (typeIndex == 0) {
                    fosArea = 1;
                    var temp = getDataPosByidPos(2, vodPage, vodlistObj.listSize);
                    vodlistObj.changeList(temp - dataPos);
                } else if (typeIndex == 1) {
                    fosArea = 1;
                    var temp = getDataPosByidPos(0, vodPage, vodlistObj.listSize);
                    vodlistObj.changeList(temp - dataPos);
                }
            }

            break;
        case 3: //焦点在底部按钮区域
            buttonIndex = num > 0 ? 1 : 0;
            break;
    }
    setStyle(true);
}


function doSelect() {
    switch (fosArea) {
        case 0://焦点在顶部
            if (typelistObj.dataSize > 0) {
                var dataObj = typeList[typelistObj.position];
                if (dataObj.name == '爸爸去哪儿第二季') {
                    window.location.href = focusURL() + "wheredad02.jsp?typeId=" + dataObj.typeId + "&pageLength=8";
                    return;
                }
                if (dataObj.name == '中国好声音第三季') {
                    window.location.href = focusURL() + "GoodVoice3.jsp?typeId=10000100000000090000000000104382&pageSize=50&&startIndex=0";
                    return;
                }
                if (dataObj.typeId != '') {
                    // window.location.href = focusURL()+'highvod_happy_classify.jsp?typeId='+dataObj.typeId+'&pageSize=100&startIndex=0';
                    window.location.href = focusURL() + "highvod_classify_defaultlist.jsp?typeId=" + dataObj.typeId + "&pageLength=8";
                    return;
                }
            }
            break;
        case 1://焦点在图片vod
            if (vodlistObj.dataSize > 0) {
                var dataObj = vodList[vodlistObj.position];
                vodId = dataObj.vodId;
                typeId = vodTypeID;
                play_movie(dataObj.playType);
            }
            break;
        case 2://焦点在图片栏目
            if (vodtypeListObj.dataSize > 0) {
                var dataObj = vodtypeList[vodtypeListObj.position];
                if (dataObj.name == "《我是歌手》中韩PK") {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/A20141008.jsp?pageSize=50&startIndex=0";
                } else if (dataObj.name == "Running Man经典游戏盘点") {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/A20141121.jsp";
                } else if (dataObj.name == "圣诞，天使降临") {
                    window.location.href = focusURL() + "MerryChristmas.jsp?typeId=" + dataObj.typeId + "&pageSize=50&startIndex=0";
                } else if (dataObj.name == '美人写江山影视金曲专题') {
                    window.location.href = focusURL() + "http://192.168.48.217:8085/iptv/entrance.jsp?gpid=119";
                }  else if (dataObj.name == '湘江音乐节') {
                    window.location.href = focusURL() + "http://192.168.48.217:8085/iptv/entrance.jsp?gpid=135";
                } else if (dataObj.name == '最强综艺全收录') {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/S20150611.jsp";
                } else if (dataObj.name == 'TFBOYS少年正当红') {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/S20151106.jsp";
                } else if (dataObj.name == '中国好声音第四季') {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/S20150723.jsp";
                } else if (dataObj.name == '看春晚抽红包活动细则') {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/S20150213.jsp";
                }  else if (dataObj.name == '看春晚抽红包') {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/S20150219.jsp";
                } else if (dataObj.name == '1516跨年演唱会') {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/S20151231.jsp";
                } else if (dataObj.name == '我是歌手第四季') {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/S20160116.jsp";
                } else if (dataObj.name == '2016春节联欢晚会') {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/S20160207.jsp";
                }  else if (dataObj.name == 'Get It Beauty一起变美吧') {
                    window.location.href = focusURL() + "/EPG/jsp/neirong/S20160205.jsp";
                } else if (dataObj.name == "1314跨年演唱会") {
                    window.location.href = focusURL() + "1314NewYear.jsp?typeId=" + dataObj.typeId + "&pageSize=50&startIndex=0";
                } else if (dataObj.name == "百变大咖秀笑点精选") {
                    window.location.href = focusURL() + "bbdkx.jsp?typeId=" + dataObj.typeId + "&pageSize=50&startIndex=0";
                } else if (dataObj.name == "陋室大变身") {
                    window.location.href = focusURL() + "humbleRoom.jsp?typeId=" + dataObj.typeId + "&pageSize=50&startIndex=0";
                } else if (dataObj.name == "时尚圈土豪事件薄") {
                    window.location.href = focusURL() + "luxury.jsp?typeId=" + dataObj.typeId + "&pageSize=50&startIndex=0";
                } else if (dataObj.name == "千女神大牌穿衣经") {
                    window.location.href = focusURL() + "goddess.jsp?typeId=" + dataObj.typeId + "&pageSize=50&startIndex=0";
                } else if (dataObj.name == "爸爸去哪儿第二季") {
                    window.location.href = focusURL() + "wheredad02.jsp?typeId=" + dataObj.typeId + "&pageSize=50&startIndex=0";
                } else if (dataObj.name == "大开眼界！韩星精致私房菜") {
                    window.location.href = focusURL() + "hanxingsfc.jsp?typeId=" + dataObj.typeId + "&pageSize=50&startIndex=0";
                } else {//跳转到到默认页面
                    window.location.href = focusURL() + 'highvod_happy_classify.jsp?typeId=' + dataObj.typeId + '&pageSize=100&startIndex=0';
                }
            }
            break;
        case 3://焦点底部按钮区域
            doMenu();
            break;

    }
}

function init() {

    //初始化数据
    initData();

    initTypeList();
    initVodList();
    initVodtypeList();
    setStyle(true);
    setStyleArrow(currPage);
}


function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs=" + fosArea + "," + typelistObj.position + "," + vodlistObj.position + "," + vodtypeListObj.position + "," + currPage + "&url=";
    return baseurl;
}

//打开菜单
function doMenu() {
    iPanel.mainFrame.location.href = E.portal_url;
}

//播放部分
/* tipsWindow.jsp中getAuthUrl()方法调用，从开始处播放 */
function tip_fromBeginPlay() {
    var url = focusURL() + "Authorization.jsp?typeId="+typeId+"&playType=1"
            + "&progId=" + vodId + "&contentType=0&business=1&isHd=1";
    iPanel.debug("url == " + url);
    $("data_ifm").src = url;
}

/**从书签处播放 */
function tip_fromBookmarkPlay() {
    var tempTime = domark(vodId);
    $("data_ifm").src = focusURL() + "Authorization.jsp?typeId="+typeId+"&playType=1"
            + "&progId=" + vodId + "&contentType=0&startTime=" + tempTime + "&business=1&isHd=1";
}

/**节目播放，跳到授权页面  */
function play_movie(playType) {
    if (playType == 1) {
        //如果是电视剧
        window.location.href = focusURL() + "high_TV_detail.jsp?vodId=" + vodId + "&typeId=" + typeId;
    } else {
        //电影直接播放
        getAuthUrl(vodId);
    }
}
//-->
</script>
</head>

<body background="images/hd_vod/bg0.jpg" leftmargin="0" topmargin="0" onLoad="init();">

<!--顶部：标题及搜索-->
<div style="position:absolute; left:102px; top:45px; width:165px; height:40px;"><img src="images/hd_vod/title_3.png"
                                                                                     width="165" height="40"/></div>

<div style="position:absolute; left:80px; top:104px; width:1130px; height:45px;">
    <table width="100%" height="45" border="0" cellspacing="0" cellpadding="0" class="btn0">
        <tr>
            <td id="nav_0"></td>
            <td id="nav_1"></td>
            <td id="nav_2"></td>
            <td id="nav_3"></td>
            <td id="nav_4"></td>
        </tr>
    </table>
</div>

<!--高清娱乐海报-->
<div id="panel" style="position:absolute; left:0px; top:0px; width:1250px; height:720px; overflow:visible; ">

    <div style="position:absolute; left:82px; top:163px; width:221px; height:447px;"><img id="vod_0"
                                                                                          src="images/hd_vod/global_tm.gif"
                                                                                          width="221" height="447"/>
    </div>
    <div style="position:absolute; left:308px; top:163px; width:221px; height:221px;"><img id="vod_1"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="221" height="221"/>
    </div>
    <div style="position:absolute; left:534px; top:163px; width:221px; height:221px;"><img id="vod_2"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="221" height="221"/>
    </div>
    <div style="position:absolute; left:760px; top:163px; width:447px; height:221px;"><img id="type_0"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="447" height="221"/>
    </div>
    <div style="position:absolute; left:308px; top:389px; width:447px; height:221px;"><img id="type_1"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="447" height="221"/>
    </div>
    <div style="position:absolute; left:760px; top:389px; width:221px; height:221px;"><img id="vod_3"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="221" height="221"/>
    </div>
    <div style="position:absolute; left:986px; top:389px; width:221px; height:221px;"><img id="vod_4"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="221" height="221"/>
    </div>


    <!--焦点区域-->
    <div id="shadow_0" style="position:absolute; left:34px; top:109px; width:322px; height:556px; visibility:hidden;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="60" height="60"><img src="images/hd_vod/focus1_1.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_2.png"></td>
                <td width="60"><img src="images/hd_vod/focus1_3.png" width="60" height="60"/></td>
            </tr>
            <tr>
                <td background="images/hd_vod/focus1_4.png"></td>
                <td>&nbsp;</td>
                <td background="images/hd_vod/focus1_5.png"></td>
            </tr>
            <tr>
                <td height="60"><img src="images/hd_vod/focus1_6.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_7.png"></td>
                <td><img src="images/hd_vod/focus1_8.png" width="60" height="60"/></td>
            </tr>
        </table>
    </div>
    <div id="shadow2_0" style="position:absolute; left:74px; top:150px; width:242px; height:471px; visibility:hidden;">
        <div style="position:absolute; left:0px; top:0px; width:242px; height:475px;"><img id="vod_f_0"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="242" height="475"/>
        </div>
        <div id="vod_name_0"
             style="position:absolute; left:0px; top:437px; width:242px; height:38px; background: url(images/hd_vod/shade1.png) repeat-x; font-family:'Adobe 黑体 Std R'; font-size:18pt; color:#fff; text-align:center; line-height:38px;"></div>
        <div style="position:absolute; left:85px; top:198px; width:72px; height:72px; background:url(images/hd_vod/ico_play.png) no-repeat;"></div>
    </div>

    <div id="shadow_1" style="position:absolute; left:264px; top:108px; width:322px; height:323px; visibility:hidden;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="60" height="60"><img src="images/hd_vod/focus1_1.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_2.png"></td>
                <td width="60"><img src="images/hd_vod/focus1_3.png" width="60" height="60"/></td>
            </tr>
            <tr>
                <td background="images/hd_vod/focus1_4.png"></td>
                <td>&nbsp;</td>
                <td background="images/hd_vod/focus1_5.png"></td>
            </tr>
            <tr>
                <td height="60"><img src="images/hd_vod/focus1_6.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_7.png"></td>
                <td><img src="images/hd_vod/focus1_8.png" width="60" height="60"/></td>
            </tr>
        </table>
    </div>
    <div id="shadow2_1"
         style="position:absolute;   left:305px; top:148px; width:242px; height:242px; visibility:hidden;">
        <div style="position:absolute; left:0px; top:0px; width:242px; height:242px;"><img id="vod_f_1"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="242" height="242"/>
        </div>
        <div id="vod_name_1"
             style="position:absolute; left:-1px; top:204px; width:243px; height:38px; background: url(images/hd_vod//shade1.png) repeat-x; font-family:'Adobe 黑体 Std R'; font-size:18pt; color:#fff; text-align:center; line-height:38px;"></div>
        <div style="position:absolute; left:85px; top:85px; width:72px; height:72px; background:url(images/hd_vod/ico_play.png) no-repeat;"></div>
    </div>

    <div id="shadow_2" style="position:absolute; left:487px; top:108px; width:322px; height:323px; visibility:hidden;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="60" height="60"><img src="images/hd_vod/focus1_1.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_2.png"></td>
                <td width="60"><img src="images/hd_vod/focus1_3.png" width="60" height="60"/></td>
            </tr>
            <tr>
                <td background="images/hd_vod/focus1_4.png"></td>
                <td>&nbsp;</td>
                <td background="images/hd_vod/focus1_5.png"></td>
            </tr>
            <tr>
                <td height="60"><img src="images/hd_vod/focus1_6.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_7.png"></td>
                <td><img src="images/hd_vod/focus1_8.png" width="60" height="60"/></td>
            </tr>
        </table>
    </div>
    <div id="shadow2_2"
         style="position:absolute;   left:527px; top:148px; width:242px; height:242px; visibility:hidden;">
        <div style="position:absolute; left:0px; top:0px; width:242px; height:242px;"><img id="vod_f_2"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="242" height="242"/>
        </div>
        <div id="vod_name_2"
             style="position:absolute; left:0px; top:204px; width:242px; height:38px; background: url(images/hd_vod/shade1.png) repeat-x; font-family:'Adobe 黑体 Std R'; font-size:18pt; color:#fff; text-align:center; line-height:38px;"></div>
        <div style="position:absolute; left:85px; top:85px; width:72px; height:72px; background:url(images/hd_vod/ico_play.png) no-repeat;"></div>
    </div>

    <div id="shadow_type_0"
         style="position:absolute; left:720px; top:108px; width:527px; height:323px; visibility:hidden;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="60" height="60"><img src="images/hd_vod/focus1_1.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_2.png"></td>
                <td width="60"><img src="images/hd_vod/focus1_3.png" width="60" height="60"/></td>
            </tr>
            <tr>
                <td background="images/hd_vod/focus1_4.png"></td>
                <td>&nbsp;</td>
                <td background="images/hd_vod/focus1_5.png"></td>
            </tr>
            <tr>
                <td height="60"><img src="images/hd_vod/focus1_6.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_7.png"></td>
                <td><img src="images/hd_vod/focus1_8.png" width="60" height="60"/></td>
            </tr>
        </table>
    </div>
    <div id="shadow_type2_0"
         style="position:absolute; left:750px; top:148px; width:456px; height:242px; visibility:hidden;">
        <div style="position:absolute; left:-1px; top:0px; width:468px; height:242px;"><img id="type_f_0"
                                                                                            src="images/hd_vod/global_tm.gif"
                                                                                            width="468" height="242"/>
        </div>
        <div id="type_name_0"
             style="position:absolute; left:-1px; top:204px; width:468px; height:38px; background: url(images/hd_vod/shade1.png) repeat-x; font-family:'Adobe 黑体 Std R'; font-size:18pt; color:#fff; text-align:center; line-height:38px;"></div>
        <div style="position:absolute; left:191px; top:85px; width:72px; height:72px; background:url(images/hd_vod/ico_play.png) no-repeat;"></div>
    </div>

    <div id="shadow_type_1"
         style="position:absolute; left:268px; top:343px; width:527px; height:323px; visibility:hidden;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="60" height="60"><img src="images/hd_vod/focus1_1.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_2.png"></td>
                <td width="60"><img src="images/hd_vod/focus1_3.png" width="60" height="60"/></td>
            </tr>
            <tr>
                <td background="images/hd_vod/focus1_4.png"></td>
                <td>&nbsp;</td>
                <td background="images/hd_vod/focus1_5.png"></td>
            </tr>
            <tr>
                <td height="60"><img src="images/hd_vod/focus1_6.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_7.png"></td>
                <td><img src="images/hd_vod/focus1_8.png" width="60" height="60"/></td>
            </tr>
        </table>
    </div>
    <div id="shadow_type2_1"
         style="position:absolute; left:301px; top:383px; width:468px; height:242px; visibility:hidden;">
        <div style="position:absolute; left:-1px; top:0px; width:468px; height:242px;"><img id="type_f_1"
                                                                                            src="images/hd_vod/global_tm.gif"
                                                                                            width="468" height="242"/>
        </div>
        <div id="type_name_1"
             style="position:absolute; left:-1px; top:204px; width:468px; height:38px; background: url(images/hd_vod/shade1.png) repeat-x; font-family:'Adobe 黑体 Std R'; font-size:18pt; color:#fff; text-align:center; line-height:38px;"></div>
        <div style="position:absolute; left:191px; top:85px; width:72px; height:72px; background:url(images/hd_vod/ico_play.png) no-repeat;"></div>
    </div>

    <div id="shadow_3" style="position:absolute; left:713px; top:343px; width:322px; height:323px; visibility:hidden;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="60" height="60"><img src="images/hd_vod/focus1_1.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_2.png"></td>
                <td width="60"><img src="images/hd_vod/focus1_3.png" width="60" height="60"/></td>
            </tr>
            <tr>
                <td background="images/hd_vod/focus1_4.png"></td>
                <td>&nbsp;</td>
                <td background="images/hd_vod/focus1_5.png"></td>
            </tr>
            <tr>
                <td height="60"><img src="images/hd_vod/focus1_6.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_7.png"></td>
                <td><img src="images/hd_vod/focus1_8.png" width="60" height="60"/></td>
            </tr>
        </table>
    </div>
    <div id="shadow2_3" style="position:absolute; left:754px; top:383px; width:242px; height:242px; visibility:hidden;">
        <div style="position:absolute; left:0px; top:0px; width:242px; height:242px;"><img id="vod_f_3"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="242" height="242"/>
        </div>
        <div id="vod_name_3"
             style="position:absolute; left:-1px; top:204px; width:244px; height:38px; background: url(images/hd_vod/shade1.png) repeat-x; font-family:'Adobe 黑体 Std R'; font-size:18pt; color:#fff; text-align:center; line-height:38px;"></div>
        <div style="position:absolute; left:85px; top:85px; width:72px; height:72px; background:url(images/hd_vod/ico_play.png) no-repeat;"></div>
    </div>

    <div id="shadow_4" style="position:absolute; left:939px; top:343px; width:322px; height:323px; visibility:hidden;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="60" height="60"><img src="images/hd_vod/focus1_1.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_2.png"></td>
                <td width="60"><img src="images/hd_vod/focus1_3.png" width="60" height="60"/></td>
            </tr>
            <tr>
                <td background="images/hd_vod/focus1_4.png"></td>
                <td>&nbsp;</td>
                <td background="images/hd_vod/focus1_5.png"></td>
            </tr>
            <tr>
                <td height="60"><img src="images/hd_vod/focus1_6.png" width="60" height="60"/></td>
                <td background="images/hd_vod/focus1_7.png"></td>
                <td><img src="images/hd_vod/focus1_8.png" width="60" height="60"/></td>
            </tr>
        </table>
    </div>
    <div id="shadow2_4"
         style="position:absolute; left:980px; top:383px; width:242px; height:242px; visibility:hidden; z-index:1;">
        <div style="position:absolute; left:0px; top:0px; width:242px; height:242px;"><img id="vod_f_4"
                                                                                           src="images/hd_vod/global_tm.gif"
                                                                                           width="242" height="242"/>
        </div>
        <div id="vod_name_4"
             style="position:absolute; left:-1px; top:204px; width:243px; height:38px; background: url(images/hd_vod/shade1.png) repeat-x; font-family:'Adobe 黑体 Std R'; font-size:18pt; color:#fff; text-align:center; line-height:38px;"></div>
        <div style="position:absolute; left:85px; top:85px; width:72px; height:72px; background:url(images/hd_vod/ico_play.png) no-repeat;"></div>
    </div>

</div>


<!--左右翻页箭头-->
<div id="arrowLeft"
     style="position:absolute; left:35px; top:366px; width:46px; height:46px; background:url(images/hd_vod/arrow_left3.png); visibility:hidden;"></div>
<div id="arrowRight"
     style="position:absolute; left:1207px; top:366px; width:46px; height:46px; background:url(images/hd_vod/arrow_right3.png); visibility:hidden; z-index:-100;"></div>

<!--
<div id="arrowLeft" style="position:absolute; left:43px; top:366px; width:24px; height:40px; background:url(images/hd_vod/arrow_left3.png) ; visibility:hidden;"></div>
<div id="arrowRight" style="position:absolute; left:1221px; top:366px; width:24px; height:40px; background:url(images/hd_vod/arrow_right3.png); visibility:hidden;">
-->
</div>


<!--Bottom-->
<div style="position:absolute; left:55px; top:625px; width:250px; height:45px;">
    <div style="position:absolute; top:1px; left:0px; width:58px; height:44px;"><img src="images/hd_vod/footicon.png"
                                                                                     width="58" height="44"/></div>
    <div style="position:absolute; top:3px; left:60px; width:90px; height:42px;"><img id="foot_0"
                                                                                      src="images/hd_vod/footbtn0_01.png"
                                                                                      width="90" height="42"/></div>
    <div style="position:absolute; top:3px; left:133px; width:90px; height:42px;"><img id="foot_1"
                                                                                       src="images/hd_vod/footbtn0_02.png"
                                                                                       width="90" height="42"/></div>
</div>

<iframe id="data_ifm" width="0" height="0" style="display:none;"></iframe>
<jsp:include page="high_tips.jsp"></jsp:include>
</body>
</html>
