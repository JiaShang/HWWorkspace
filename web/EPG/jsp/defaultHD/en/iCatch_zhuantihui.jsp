<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="datajspHD/iCatchNew_zhuantihui_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<title>专题汇</title>
<link href="iCatch_image/main.css" rel="stylesheet" type="text/css"/>
<script language="javascript" type="text/javascript">
<!--
iPanel.eventFrame.initPage(window);
var listData = [];	//列表数据
var listObj = null;
var listFocusPos = 0;
var bigImgData = {};	//大图数据
var buttonData = [
    {name: "首页", focusImg: "iCatch_image/footbtn1_01.png", lostFocusImg: "iCatch_image/footbtn0_01.png"},
    {name: "返回", focusImg: "iCatch_image/footbtn1_02.png", lostFocusImg: "iCatch_image/footbtn0_02.png"}
];
var focusArea = 0;	//0焦点在列表上，1焦点在大图上，2焦点在按钮上
var buttonFocusPos = 0;	//0焦点在首页上，1焦点在返回上


var marqueeText = "互动电视 精彩随心掌控 海量精彩节目、影视大片，任由您点播；长达72小时的可回看   由您点播";	//跑马灯内容

function eventHandler(eventObj, type) {
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
        case "KEY_BACK":
            doBack();
            break;
        case "KEY_MENU":
            doMenu();
            break;
        default:
            return 1;
            break;
    }

    return 0;
}

function init() {

    //初始化数据
    initDatas();

    initList();
    $(bigImgData.id).src = bigImgData.img;

    if (focusArea == 1) {
        $("bigimgfocus").style.visibility = "visible";
    }
    else if (focusArea == 2) {
        $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
    }

    showMarquee();
}

//初始化数据
function initDatas() {
    focusArea = icatchFocusArea;
    listFocusPos = icatchListFocusPos;
    listData = listTypeArray;
    bigImgData = recommendArray[0];
}


function delayInit() {
    init();
}

//显示跑马灯
function showMarquee() {
    $("marquee").innerText = E.marqueeText;
}

//初始化列表
function initList() {
    listObj = new E.showList(8, listData.length, listFocusPos, 170, window);
    listObj.listHigh = 44;
    listObj.focusDiv = "listfocus";
    listObj.showType = 1;
    listObj.haveData = setList;
    listObj.notData = clearList;
    listObj.startShow();
    setArrowStyle();
    setListStyle();
    if (focusArea == 0) {
        $(listObj.focusDiv).style.visibility = "visible";
    }
}

//设置列表数据
function setList(list) {
    $("list" + list.idPos).innerText = iPanel.misc.interceptString(listData[list.dataPos].name, 20);
}

//清除列表数据
function clearList(list) {
    $("list" + list.idPos).innerText = "";
}

//设置列表样式
function setListStyle() {
    if (listObj.dataSize > 0) {
        var name = listData[listObj.position].name;
        var tempName = iPanel.misc.interceptString(name, 20);

        if (name != tempName) {
            $(listObj.focusDiv).innerHTML = "<marquee style=\"width:325px; height:42px;\">" + name + "</marquee>";
        }
        else {
            $(listObj.focusDiv).innerText = tempName;
        }
    }
}

//上下移动焦点
function udMove(num) {
    switch (focusArea) {
        case 0:	//焦点在列表上
            if (listObj.position == 0 && num < 0) {
            }
            else if (listObj.position == listObj.dataSize - 1 && num > 0) {
                $(listObj.focusDiv).style.visibility = "hidden";
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
                focusArea = 2;
            }
            else {
                listObj.changeList(num);
                setListStyle();
                setArrowStyle();
            }
            break;
        case 1:	//焦点在大图上
            if (num > 0) {
                $("bigimgfocus").style.visibility = "hidden";
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
                focusArea = 2;
            }
            break;
        case 2:	//焦点在按钮上
            if (num < 0) {
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].lostFocusImg;
                $(listObj.focusDiv).style.webkitTransitionDuration = "0ms";
                listObj.changeList(listObj.listSize - listObj.focusPos - 1);
                $(listObj.focusDiv).style.visibility = "visible";
                $(listObj.focusDiv).style.webkitTransitionDuration = "100ms";
                focusArea = 0;
                setListStyle();
            }
            break;
    }
}

//左右移动焦点
function lrMove(num) {
    switch (focusArea) {
        case 0:	//焦点在列表上
            if (num > 0) {
                $(listObj.focusDiv).style.visibility = "hidden";
                $("bigimgfocus").style.visibility = "visible";
                focusArea = 1;
            }
            break;
        case 1:	//焦点在大图上
            if (num < 0) {
                $("bigimgfocus").style.visibility = "hidden";
                $(listObj.focusDiv).style.visibility = "visible";
                focusArea = 0;
            }
            break;
        case 2:	//焦点在按钮上
            if (buttonFocusPos == 0 && num > 0) {
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].lostFocusImg;
                buttonFocusPos = 1;
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
            }
            else if (buttonFocusPos == 1 && num < 0) {
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].lostFocusImg;
                buttonFocusPos = 0;
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
            }
            break;
    }
}

function doSelect() {
    switch (focusArea) {
        case 0:	//焦点在列表上
            if (listObj.dataSize > 0) {
                /*
                 * 新增专题请在这里添加和修改URL
                 */
                var data = listData[listObj.position];
                var typeurl = focusURL();
                if (data.name == '直击女子半程马拉松赛') {
                    window.location.href = typeurl + "20151019girlMarathon.jsp?typeId=10000100000000090000000000105600&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '票选爱看电影年度TOP10') {
                    window.location.href = typeurl + "20151215Film.jsp?typeId=10000100000000090000000000105764&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '女医明妃教你不生病的中医调养') {
                    window.location.href = typeurl + "http://192.168.35.153:8080/huoDong_MingFei.jsp?lcn=mingfei";
                    return;
                }
                if (data.name == '刘若英演唱门票免费送') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/entrance.jsp?gpid=142";
                    return;
                }
                if (data.name == '抢草莓音乐节门票') {
                    window.location.href = typeurl + "http://192.168.48.217:8082/epghd/1.html?pid=20";
                    return;
                }
                if (data.name == '第30届飞天奖优秀电视剧') {
                    window.location.href = typeurl + "highvod_happy_classify.jsp?typeId=10000100000000090000000000105805&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == '630帮帮忙') {
                    window.location.href = typeurl + "20151014help.jsp";
                    return;
                }
                if (data.name == '防秋燥 吃螃蟹') {
                    window.location.href = typeurl + "2015autumn.jsp?typeId=10000100000000090000000000105554&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '2015年重庆辣妈第三季') {
                    window.location.href = typeurl + "cqlama3_index.jsp?typeId=10000100000000090000000000105402&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '重庆言子闹山城') {
                    window.location.href = typeurl + "20150818_cqyz.jsp?typeId=10000100000000090000000000105402&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '白百何大战王珞丹') {
                    window.location.href = typeurl + "20150814_girlspk.jsp?typeId=10000100000000090000000000105388&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '快乐暑期 安全不放假') {
                    window.location.href = typeurl + "2015_summerSafety.jsp?typeId=10000100000000090000000000105347&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '中高考实用宝典') {
                    window.location.href = typeurl + "2015gaoKao.jsp?typeId=10000100000000090000000000105178&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '酷爸俏妈养成记') {
                    window.location.href = typeurl + "FatherAndMother.jsp?typeId=10000100000000090000000000105148&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '炒股VS买房 你想好了吗') {
                    window.location.href = typeurl + "StockOrEstate.jsp?typeId=10000100000000090000000000105126&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '永不消逝的巨星') {
                    window.location.href = typeurl + "2015superStar.jsp?typeId=10000100000000090000000000105035&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '情牵女人心') {
                    window.location.href = typeurl + "2015women.jsp?typeId=10000100000000090000000000105006&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '失孤') {
                    window.location.href = typeurl + "sg.jsp?typeId=10000100000000090000000000105003&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '春季养生好时节') {
                    window.location.href = typeurl + "2015spring.jsp?typeId=10000100000000090000000000104987&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '最美“贤妻”刘涛') {
                    window.location.href = typeurl + "goodwife.jsp?typeId=10000100000000090000000000104981&pageSize=50&startIndex=0";
                    return;
                }
				if (data.name == '2014年“最”榜单') {
                    window.location.href = typeurl + "listIndex.jsp?typeId=001000&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '看TVB，重庆有线就够了！') {
                    window.location.href = typeurl +  "tvb2.jsp?typeId=10000100000000090000000000104849&pageSize=50&startIndex=0";
                    return;
                }
				if (data.name == '内养外护巧过冬') {
                    window.location.href = typeurl + "winterIndex.jsp?typeId=10000100000000090000000000104745&pageSize=100&startIndex=0";
                    return;
                }
				if (data.name == '热血男儿 青春有梦') {
                    window.location.href = typeurl + "boyDream.jsp?typeId=10000100000000090000000000104677&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '我的少女时代') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/hdzq_wdsnsd.jsp?src=akzq";
                    return;
                }
                if (data.name == '抢莫文蔚演唱会门票') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/hdzq_mww.jsp?src=akzq";
                    return;
                }
                if (data.name == '抢田馥甄演唱会门票') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/hdzq_tfz.jsp?src=25";
                    return;
                }
                if (data.name == '抢萧敬腾演唱会门票') {
                    window.location.href = typeurl + "http://192.168.48.217:8082/epghd/1.html?pid=17";
                    return;
                }
                if (data.name == '抢儿童新年音乐会门票') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/entrance.jsp?gpid=126";
                    return;
                }
                if (data.name == '好有年味 新春庙会') {
                    window.location.href = typeurl + "http://192.168.9.77/index.html?page=1";
                    return;
                }
                if (data.name == '中韩男星撩妹技能大比武') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/STemplate2.jsp?typeId=10000100000000090000000000105782";
                    return;
                }
                if (data.name == '莱昂纳多问鼎奥斯卡') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/STemplate2.jsp?typeId=10000100000000090000000000105923&voteId=100";
                    return;
                }
                if (data.name == '挑战阿尔法狗') {
                    window.location.href = typeurl + "http://192.168.35.153:8080/weiqi.jsp?lcn=weiqi";
                    return;
                }
                if (data.name == '点爆“冰与火”限时全免') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160322.jsp";
                    return;
                }
                if (data.name == '3.15在行动') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160315.jsp";
                    return;
                }
                if (data.name == '天天向上') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160310.jsp";
                    return;
                }
                if (data.name == '我要美美美') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160308.jsp";
                    return;
                }
                if (data.name == '2016全国两会') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160307.jsp";
                    return;
                }
                if (data.name == '开学第一课') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160303.jsp";
                    return;
                }
                if (data.name == 'TFBOYS陪你开学啦') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160222.jsp";
                    return;
                }
                if (data.name == '抗击节后综合症') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160221.jsp";
                    return;
                }
                if (data.name == '2016春节联欢晚会') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160207.jsp";
                    return;
                }
                if (data.name == '喜剧之王培训班') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160206.jsp";
                    return;
                }
                if (data.name == '小编教你买年货') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160201.jsp";
                    return;
                }
                if (data.name == '有爱 有家') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160202.jsp";
                    return;
                }
                if (data.name == 'Hold住2016吉猴闹春之爱回家') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160202-1.jsp";
                    return;
                }
                if (data.name == 'Hold住2016吉猴闹春之快乐寒假') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160128.jsp";
                    return;
                }
                if (data.name == '寒假补剧班之韩流追新剧') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160127.jsp";
                    return;
                }
                if (data.name == '2016年贺岁档观影指南') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160120.jsp";
                    return;
                }
                if (data.name == '期末备考帮你赢') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160115.jsp";
                    return;
                }
                if (data.name == '2016广播电视报读者新春大联欢') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160114.jsp";
                    return;
                }
                if (data.name == '电影界最伟大的科幻系列：星球大战') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160105.jsp";
                    return;
                }
                if (data.name == '金姐来了') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151230.jsp";
                    return;
                }
                if (data.name == '职场不相信眼泪') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151224.jsp";
                    return;
                }
                if (data.name == '2015感动重庆年度人物') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151223.jsp";
                    return;
                }
                if (data.name == '家年华 齐欢享') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151218.jsp";
                    return;
                }
                if (data.name == '十二月观影指南') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151203.jsp";
                    return;
                }
                if (data.name == '十大妙招助你过暖冬') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151215.jsp";
                    return;
                }
                if (data.name == '火星救援：艰难生存法则') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151125.jsp";
                    return;
                }
                if (data.name == '网购达人必看这十条') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151105.jsp";
                    return;
                }
                if (data.name == '十一月观影指南') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151103.jsp";
                    return;
                }
                if (data.name == '抢A-lin演唱会门票') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/hdzq_alin.jsp?src=24";
                    return;
                }
                if (data.name == '山河故人 贾樟柯') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151027.jsp";
                    return;
                }
                if (data.name == '国庆之后电影看什么') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151009.jsp";
                    return;
                }
                if (data.name == '吃遍重庆旮旮旯旯') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150930.jsp";
                    return;
                }
                if (data.name == '国庆七天乐') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150929.jsp";
                    return;
                }
                if (data.name == '港囧来袭 囧囧有神') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150925.jsp";
                    return;
                }
                if (data.name == '抗战胜利70周年') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150814.jsp";
                    return;
                }
                if (data.name == '浓情金秋送好礼') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150918.jsp";
                    return;
                }
                if (data.name == '金婚祝福礼') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150916.jsp";
                    return;
                }
                if (data.name == '抢蔡依林演唱会门票') {
                    window.location.href = typeurl + "http://192.168.48.217:8082/epghd/1.html?pid=16";
                    return;
                }
                if (data.name == '抢邓丽君纪念演唱会门票') {
                    window.location.href = typeurl + "http://192.168.48.217:8082/epghd/1.html?pid=12";
                    return;
                }
                if (data.name == "007大长腿系列之幽灵党") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151112.jsp";
                    return;
                }
                if (data.name == "九月观影指南") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150912.jsp";
                    return;
                }
                if (data.name == "师者如诗") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150910.jsp";
                    return;
                }
                if (data.name == "迎开学！校园电影补心伤") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150902.jsp";
                    return;
                }
                if (data.name == "暑假动画也疯狂") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150825.jsp";
                    return;
                }
                if (data.name == "七夕表白圣地") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150819.jsp";
                    return;
                }
                if (data.name == "国产动画巅峰代表") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150807.jsp";
                    return;
                }
                if (data.name == "青春 奋斗山城故事") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150730.jsp";
                    return;
                }
                if (data.name == "疯狂暑期 电影看啥哟") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150717.jsp";
                    return;
                }
                if (data.name == "逐梦他乡重庆人") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150714.jsp";
                    return;
                }
                if (data.name == "火辣女人疯狂夏日") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150708.jsp";
                    return;
                }
                if (data.name == "TVB明星见面会") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150624.jsp";
                    return;
                }
                if (data.name == "六月观影指南") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150602.jsp";
                    return;
                }
                if (data.name == '儿童安全行为手册') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150529.jsp";
                    return;
                }
                if (data.name == '我家有房要装修') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150522.jsp";
                    return;
                }
                if (data.name == '二战风云录') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150511.jsp";
                    return;
                }
                if (data.name == '5月观影指南') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150430.jsp";
                    return;
                }
                if (data.name == '直击尼泊尔强烈地震') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150429.jsp";
                    return;
                }
                if (data.name == '灰姑娘逆袭记') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150422.jsp";
                    return;
                }
                if (data.name == '速度与激情的前世今生') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150413.jsp";
                    return;
                }
                if (data.name == '4月观影指南') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150408.jsp";
                    return;
                }
                if (data.name == '家庭必备科学急救常识') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150330.jsp";
                    return;
                }
                if (data.name == '吻戏女王唐嫣') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150325.jsp";
                    return;
                }
                if (data.name == '年夜饭家乡味') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150217.jsp";
                    return;
                }
                if (data.name == '开年看好戏') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150215.jsp";
                    return;
                }
                if (data.name == '看春晚抽红包中奖名单') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150305.jsp";
                    return;
                }
                if (data.name == '看春晚抽红包') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150219.jsp";
                    return;
                }
                if (data.name == '看春晚抽红包活动细则') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150213.jsp";
                    return;
                }
                if (data.name == '有一个地方只有我们知道') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150209.jsp";
                    return;
                }
                if (data.name == '三月观影指南') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160309.jsp";
                    return;
                }
                if (data.name == '二月观影指南') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150129.jsp";
                    return;
                }
                if (data.name == '小儿不再“难养”') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150127.jsp";
                    return;
                }
                if (data.name == '霍比特人3：五军之战') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150123.jsp";
                    return;
                }
                if (data.name == '盘点2014年超人气点播热剧') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141225.jsp";
                    return;
                }
                if (data.name == '多面暖男钟汉良') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150112.jsp";
                    return;
                }
                if (data.name == '动漫贺岁欢乐来袭') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150107.jsp";
                    return;
                }
                if (data.name == '2014电影点播岁末盘点') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141229.jsp";
                    return;
                }
                if (data.name == '贺岁头炮戏一步之遥') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141222.jsp";
                    return;
                }
                if (data.name == '我们一起过暖冬') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141215.jsp";
                    return;
                }
                if (data.name == '十一月观影指南') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141104.jsp";
                    return;
                }
                if (data.name == '贺岁片哪家强') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141201.jsp";
                    return;
                }
                if (data.name == '冬季酷游记') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141127.jsp";
                    return;
                }
                if (data.name == '大片重映年') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141024.jsp";
                    return;
                }
                if (data.name == '喜剧铁三角') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140929.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == '国际穿越大奖赛') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141114.jsp";
                    return;
                }
                if (data.name == '麻辣言子儿逗山城第二季') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141113.jsp";
                    return;
                }
                if (data.name == "骗术大揭秘") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "cheat.jsp?typeId=10000100000000090000000000104664&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "吃货玩家嗨翻山城") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "chihuo.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "混战国庆档之十月观影指南") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "OctmovieSeason.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "重庆辣妈第二季") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "cqlama2_index.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "做好七件事舒服过金秋") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "qiuys.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '我的上班路') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140920.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == '暑假太短不想停') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140905.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == '巧用带薪假环球走一个') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140828.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == '9月观影指南') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140901.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == "电影旅行笔记") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "oneFilm.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "无牙仔再度来袭") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "wuyazai.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "你家电视已被我承包了") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "ceo.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '青春不老，“闺蜜”永在') {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "ladybro.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '另类大师显神通') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140805.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "8月观影指南") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "AugmovieSeason.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "暑假看啥？由你做主！") {//寻找最美校服Style 2014-07-28
                    window.location.href = typeurl + "lookWhat.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "决战！韩寒PK郭小四") {//寻找最美校服Style 2014-05-28
                    window.location.href = typeurl + "JuezhanPK.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "分手大师：笑多了会怀孕") {//寻找最美校服Style 2014-05-28
                    window.location.href = typeurl + "fenshouDaShi.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "智能手机那些事儿") {//寻找最美校服Style 2014-05-28
                    window.location.href = typeurl + "mobilePhone.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "暑期科幻大乱战") {//暑期科幻大乱战 2014-05-28
                    window.location.href = typeurl + "summerMovie.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "高考实用宝典") {//寻找最美校服Style 2014-05-28
                    window.location.href = typeurl + "entrance.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "寻找最美校服Style") {//寻找最美校服Style 2014-05-28
                    window.location.href = typeurl + "beautyUniform.htm?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "阳光亲子嘉年华") {//阳光亲子嘉年华 2014-05-28
                    window.location.href = typeurl + "childAct.htm?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "就是这个英雄范儿") {//就是这个英雄范儿 2013-08-21
                    window.location.href = typeurl + "hero.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "杜琪峰专业陪跑十几年") {//杜琪峰专业陪跑十几年 2013-08-21
                    window.location.href = typeurl + "JohnnyTo.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "张艺谋归来") {//张艺谋归来 2013-08-21
                    window.location.href = typeurl + "zhang.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "路过我青春的你") {//第33届香港电影金像奖 2013-08-21
                    window.location.href = typeurl + "lgqc.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "吃货们必追的美食剧") {//第33届香港电影金像奖 2013-08-21
                    window.location.href = typeurl + "meisiju.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "好吃不怕晚 舌尖解春馋") {//第33届香港电影金像奖 2013-08-21
                    window.location.href = typeurl + "delicious.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "五月观影指南") {//第33届香港电影金像奖 2013-08-21
                    window.location.href = typeurl + "maytide.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "第33届香港电影金像奖") {//第33届香港电影金像奖 2013-08-21
                    window.location.href = typeurl + "hongKongFilmAward.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "麻辣言子儿逗山城") {//四月观影指南 2013-08-21
                    window.location.href = typeurl + "spicy.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "TICO玩具总动员") {//四月观影指南 2013-08-21
                    window.location.href = typeurl + "toyStory.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "美国队长：冬日战士") {//四月观影指南 2013-08-21
                    window.location.href = typeurl + "CaptainAmerica.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "四月观影指南") {//四月观影指南 2013-08-21
                    window.location.href = typeurl + "th_ganyin.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "杰森斯坦森·激战人生") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "JasonStatham.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "下一站，去哪儿") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "TheNextStation.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "笑林争霸") {//笑林争霸 2013-08-21
                    window.location.href = typeurl + "xlzb.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "生活智慧猜猜猜第三季") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "guess3.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "三月遇见桃花劫") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "PeachBlossom.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "廖凡：龙套到影帝") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "liaofan.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "女人，我最美") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "lvwzm.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "奥斯卡女王诞生记") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "OOQ.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "3月观影指南") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "MarchMovieSeason.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "难缠王志文") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "ncwzw.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "元宵恋上情人节") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "yxqrj.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "时间都去哪儿了") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "sjqne.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "2014春节联欢晚会") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "cjlh.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "传奇萝莉秀兰邓波儿") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "Shirley.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "颁奖季大战") {//颁奖季大战 2013-08-21
                    window.location.href = typeurl + "bjjdz.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "快乐彩虹岛") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "klchd.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "二月观影指南") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "eygy.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "春节煲剧看啥哟") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "cjbj.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "寒假补剧班") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "hjbjb.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "寒假动漫补习班") {//寒假动漫补习班 2013-08-21
                    window.location.href = typeurl + "hjbxb.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "我是歌手第二季") {//我是歌手第二季 2013-08-21
                    window.location.href = typeurl + "iamsinger.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "1月观影指南") {//1月观影指南 2013-08-21
                    window.location.href = typeurl + "JanuaryMovieSeason01.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "盛女大作战") {//1月观影指南 2013-08-21
                    window.location.href = typeurl + "sndzz.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "内养外护巧过冬") {//内养外护巧过冬 2013-08-21
                    window.location.href = typeurl + "nywhgd.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "2013人气电影盘点") {//2013人气电影盘点 2013-08-21
                    window.location.href = typeurl + "2013repd1.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "2013不可错过的电视剧") {//2013人气电影盘点 2013-08-21
                    window.location.href = typeurl + "2013hktv.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "圣诞狂飙夜") {//圣诞狂飙夜 2013-08-21
                    window.location.href = typeurl + "ChristmasNightHurricane.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "中国式养老") {//中国式养老 2013-08-21
                    window.location.href = typeurl + "zgsyl.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "12月观影指南") {//12月观影指南 2013-08-21
                    window.location.href = typeurl + "summerMovieSeason.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "奇迹梦工厂") {//奇迹梦工厂 2013-08-21
                    window.location.href = typeurl + "qj2.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "金马奔腾 经典50") {// 金马奔腾 经典50 2013-08-21
                    window.location.href = typeurl + "jmbt50.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "生活智慧猜猜猜第二季") {// 生活智慧猜猜猜第二季 2013-08-21
                    window.location.href = typeurl + "lifeWisdom2.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "爸爸去哪儿") {// 爸爸去哪儿 2013-08-21
                    window.location.href = typeurl + "wheredad01.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "咱们结婚吧") {// 咱们结婚吧 2013-08-21
                    window.location.href = typeurl + "wegetmarried.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "全球性感动作男星TOP10") {// 全球性感动作男星TOP10 2013-08-21
                    window.location.href = typeurl + "glableSexTop10.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "因戏生情的银幕情侣") {// 因戏生情的银幕情侣 2013-08-21
                    window.location.href = typeurl + "yxsq_bg.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "11月观影指南") {// 11月观影指南 2013-08-21
                    window.location.href = typeurl + "viewingGuide11.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "美丽大讲堂") {// 美丽大讲堂 2013-09-17
                    window.location.href = typeurl + "mldjt.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "科教民生服务") {// 渝新欧媒体行 2013-09-17
                    window.location.href = typeurl + "aiKeJiao.jsp?typeId=10000100000000090000000000102364&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "渝新欧媒体行") {// 渝新欧媒体行 2013-09-17
                    window.location.href = typeurl + "yxo_index.jsp?pTypeId=10000100000000090000000000102120&pSize=9&typeId=10000100000000090000000000102130&size=3";
                    return;
                }
                if (data.name == "仁心柳叶刀") {// 仁心柳叶刀 2013-10-28
                    window.location.href = typeurl + "yxlyd.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "宅男女神赵奕欢") {// 宅男女神赵奕欢 2013-10-28
                    window.location.href = typeurl + "ns_zyh.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "奇迹梦工厂") {// 奇迹梦工厂 2013-10-28
                    window.location.href = typeurl + "qjmgc.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "谁是你心中的传奇英雄") {// 谁是你心中的传奇英雄 2013-10-28
                    window.location.href = typeurl + "dgg_index.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "渝派纪录片展播季") {// 渝派纪录片展播季 2013-09-17
                    window.location.href = typeurl + "ypjlp.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "养在秋季") {// 养在秋季 2013-09-17
                    window.location.href = typeurl + "yzqj01.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "全球最受欢迎动画角色TOP10") {// 全球最受欢迎动画角色TOP10 2013-09-17
                    window.location.href = typeurl + "zhy_animal.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "越挫越勇大明星") {// 越挫越勇大明星 2013-09-17
                    window.location.href = typeurl + "damx.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "渝新欧媒体行") {// 渝新欧媒体行 2013-09-02
                    window.location.href = typeurl + "yxo_index.jsp?pTypeId=10000100000000090000000000102120&pSize=9&typeId=10000100000000090000000000102130&size=3";
                    return;
                }
                if (data.name == "开学了") {// 开学了 2013-09-02
                    window.location.href = typeurl + "schoolOpens.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "说得更比唱得好") {// 说得更比唱得好 2013-09-02
                    window.location.href = typeurl + "superOrator.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "小爸爸文章成长记") {// 小爸爸文章成长记 2013-08-26
                    window.location.href = typeurl + "wenzhang_index.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "了不起的盖茨李") {// 了不起的盖茨李 2013-08-21
                    window.location.href = typeurl + "index_acl01.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "生活智慧猜猜猜") {// 生活智慧猜猜猜 2013-08-14
                    window.location.href = typeurl + "live_guess.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "暑期档之八月观影指南") {// 暑期档之八月观影指南 2013-08-7
                    window.location.href = typeurl + "movieGuide8.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "好莱坞末日灾难时代") {// 好莱坞末日灾难时代 2013-08-1
                    window.location.href = typeurl + "hollywood_times.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "暑期必追神剧") {// 暑期必追神剧 2013-07-25
                    window.location.href = typeurl + "shuqi_zqj.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "老地图里的重庆记忆") {// 老地图里的重庆记忆 2013-07-24
                    window.location.href = typeurl + "oldmap.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "我的青春映像纪") {// 我的青春映像纪 2013-07-18
                    window.location.href = typeurl + "myYouth.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "给大小孩的治愈系动画") {// 给大小孩的治愈系动画 2013-07-10
                    window.location.href = typeurl + "dxhaizi.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "跟我去台北") {// 跟我去台北 2013-07-08
                    window.location.href = typeurl + "comewithmeitotaibei.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "暑期观剧指南") {// 暑期观剧指南 2013-07-04
                    window.location.href = typeurl + "sq_gy.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }

                if (data.name == "编辑部的故事") {// 编辑部的故事 2013-05-14
                    window.location.href = typeurl + "storyEditorialDept.jsp?typeId=" + data.typeId + "&pageSize=8&startIndex=0";
                    return;
                }
                if (data.name == "韩剧狗血剧情") {// 韩剧狗血剧情 2013-03-26
                    window.location.href = typeurl + "hjg_index.jsp?typeId=" + data.typeId + "&pageSize=8&startIndex=0";
                    return;
                }
                if (data.name == "多面丑男黄渤") {// 多面丑男黄渤  2013-03-29
                    window.location.href = typeurl + "cnhb.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "金像影片大赏") {// 金像影片大赏 2013-04-08
                    window.location.href = typeurl + "jxypds.jsp?typeId=" + data.typeId + "&pageSize=10&startIndex=0";
                    return;
                }
                if (data.name == "百变王祖蓝") {// 百变王祖蓝 2013-04-03
                    window.location.href = typeurl + "changeable_wzl.jsp?typeId=" + data.typeId + "&pageSize=14&startIndex=0";
                    return;
                }
                if (data.name == "终极歌王战") {// 终极歌王战 2013-04-11
                    window.location.href = typeurl + "zjgwz.jsp?typeId=" + data.typeId + "&pageSize=30&startIndex=0";
                    return;
                }
                if (data.name == "素颜女神王丽坤") {// 终极歌王战 2013-04-11
                    window.location.href = typeurl + "syns.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "爆笑体育") {// 终极歌王战 2013-04-11
                    window.location.href = typeurl + "laughandsports.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "那些荒唐的日子") {// 终极歌王战 2013-04-11
                    window.location.href = typeurl + "theabsurddays.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "2013重庆最辣妈决赛") {
                    window.location.href = typeurl + "lm_index.jsp?typeId=10000100000000090000000000101780&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "TICO动漫宝贝") {//  2013-04-11
                    window.location.href = typeurl + "tico_baby.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "TICO动漫宝贝决赛") {//  2013-04-11
                    window.location.href = typeurl + "TICO_finals.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "爱看微信订阅号全城有奖公测") {//  2013-04-11
                    window.location.href = typeurl + "weixinSurvey.htm?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "学霸来了") {//  2013-04-11
                    window.location.href = typeurl + "xueBa.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "7月观影指南") {//  2013-04-11
                    window.location.href = typeurl + "julyMovie.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "消夏美食季之舌尖上的重庆") {//  2013-04-11
                    window.location.href = typeurl + "tongueOfChongqing.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == '十大广场舞必练“神曲”') {//  2013-04-11
                    window.location.href = typeurl + "dance10.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == '欢乐水魔方免费亲子游') {//  2013-04-11
                    window.location.href = typeurl + "water.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == '暑期补剧班之名著') {//  2013-04-11
                    window.location.href = typeurl + "summerfamous.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == '嫩妹当道——新生代女神') {//  2013-04-11
                    window.location.href = typeurl + "nvshen.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if ("搜索" == data.name) {
                    window.location.href = typeurl + "search.jsp?typeId=" + listTypeId;
                }
                //有子栏目
                else if (1 == data.hasSubType) {
                    window.location.href = typeurl + "type_second.jsp?typeId=" + data.typeId;
                } else {
                    //无子栏目有节目 或者 既无子栏目也无节目
                    iPanel.eventFrame.showType = 0;//显示那个图片
                    window.location.href = typeurl + "iCatch_yulq_list.jsp?typeId=" + data.typeId + "&pageLength=8";
                }
            }
            break;
        case 1:	//焦点在大图上
            var data = bigImgData;
            var typeurl = focusURL();
            if (data.name == '点爆“冰与火”限时全免') {
                window.location.href = typeurl + "/EPG/jsp/neirong/S20160322.jsp";
            } else {
                iPanel.eventFrame.showType = 0;//显示那个图片
                window.location.href = typeurl + "iCatch_yulq_list.jsp?typeId=" + data.typeId + "&pageLength=8";
            }
            break;
        case 2:	//焦点在按钮上
            if (buttonFocusPos == 0) {
                doMenu();
            }
            else {
                doBack();
            }
            break;
    }
}

//打开首页
function doMenu() {
    iPanel.mainFrame.location.href = E.portal_url;
}

function doBack() {
    window.location.href = "<%=turnPage.go(-1)%>";
}

function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + listObj.position + "&url=";
    return baseurl;
}

//设置箭头样式
function setArrowStyle() {
    if (listObj.focusPos == 0 && listObj.position == 0) {
        $("arrup").src = "iCatch_image/arrow_up0.png";
    }
    else {
        $("arrup").src = "iCatch_image/arrow_up1.png";
    }

    if (listObj.position == listObj.dataSize - 1) {
        $("arrdown").src = "iCatch_image/arrow_down0.png";
    }
    else {
        $("arrdown").src = "iCatch_image/arrow_down1.png";
    }
}
//-->
</script>
</head>

<body background="iCatch_image/zth_bg.jpg" leftmargin="0" topmargin="0" onLoad="javascript:init();">

<!--Logo-->
<div style="position:absolute; left:141px; top:56px; width:158px; height:36px;"><img src="iCatch_image/logo_title5.png"
                                                                                     width="158" height="36"/></div>

<!--Arrow-->
<div style="position:absolute; left:246px; top:148px; width:21px; height:15px;"><img src="iCatch_image/arrow_up0.png"
                                                                                     width="21" height="15" id="arrup"/>
</div>
<div style="position:absolute; left:246px; top:529px; width:21px; height:15px;"><img src="iCatch_image/arrow_down0.png"
                                                                                     width="21" height="15"
                                                                                     id="arrdown"/></div>

<!--Left List-->
<div style="position:absolute; left:85px; top:170px; width:340px; height:44px; background:url(iCatch_image/btm4_1.png) center no-repeat;-webkit-transition-duration:100ms;font-size:24px; color:#fefefe;line-height:44px; text-align:center; z-index:2; visibility:hidden;"
     id="listfocus"></div>
<div style="position:absolute; left:85px; top:170px; width:340px; height:352px;">
    <table width="340" height="352" border="0" cellspacing="0" cellpadding="0" class="btm4_0">
        <tr>
            <td width="340" height="44" id="list0"></td>
        </tr>
        <tr>
            <td height="44" id="list1"></td>
        </tr>
        <tr>
            <td height="44" id="list2"></td>
        </tr>
        <tr>
            <td height="44" id="list3"></td>
        </tr>
        <tr>
            <td height="44" id="list4"></td>
        </tr>
        <tr>
            <td height="44" id="list5"></td>
        </tr>
        <tr>
            <td height="44" id="list6"></td>
        </tr>
        <tr>
            <td height="44" id="list7"></td>
        </tr>
    </table>
</div>

<!--Poster-->
<div id="bigimgfocus"
     style="position:absolute; left:443px; top:123px; width:763px; height:441px; background:url(iCatch_image/focus06.png) center no-repeat; z-index:1; visibility:hidden;"></div>
<div style="position:absolute; left:453px; top:133px; width:742px; height:420px;"><img src="iCatch_image/global_tm.gif"
                                                                                       width="742" height="420"
                                                                                       id="bigimg"/></div>
<div style="position:absolute; left:447px; top:449px; width:24px; height:40px; background:url(iCatch_image/cover.png) center no-repeat; visibility:visible;"
     id="cover"></div>
<!--Bottom-->
<div style="position:absolute; left:55px; top:625px; width:250px; height:45px;">
    <div style="position:absolute; top:1px; left:0px; width:58px; height:44px;"><img src="iCatch_image/footicon.png"
                                                                                     width="58" height="44"/></div>
    <div style="position:absolute; top:3px; left:60px; width:90px; height:42px;"><img src="iCatch_image/footbtn0_01.png"
                                                                                      width="90" height="42"
                                                                                      id="button0"/></div>
    <div style="position:absolute; top:3px; left:133px; width:90px; height:42px;"><img
            src="iCatch_image/footbtn0_02.png" width="90" height="42" id="button1"/></div>
</div>
<div style="position:absolute; left:400px; top:630px; width:806px; height:40px; font-size:18px; color:#fff; line-height:40px;">
    <marquee id="marquee">
    </marquee>
</div>
<div style="position: absolute; left: 1065px; top: 121px; width: 140px; height: 145px; background: url(iCatch_image/new.png) center no-repeat; z-index:10;"></div>
</body>
</html>