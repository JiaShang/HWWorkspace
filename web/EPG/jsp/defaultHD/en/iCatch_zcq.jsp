<%@ page language="java" import="java.util.*" pageEncoding="GBK" %>
<%@ include file="datajspHD/iCatch_zch_data.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <title>无标题文档</title>
    <link rel="stylesheet" href="iCatch_image/main.css" type="text/css"/>
    <script language="javascript" type="text/javascript">
        <!--
        iPanel.eventFrame.initPage(window);

        var menuData = [
            {name: "重庆资讯", url: "iCatch_yulq_list.jsp?typeId=10000100000000090000000000101280&pageLength=8"},
            {name: "麻辣剧场", url: "iCatch_yulq_list.jsp?typeId=10000100000000090000000000101281&pageLength=8"},
            {name: "生活帮", url: "iCatch_yulq_list.jsp?typeId=10000100000000090000000000101282&pageLength=8"},
            {name: "TICO空间", url: "iCatch_TICO.jsp?imgVodId=10000100000000090000000000101283"},
            {
                name: "微视频",
                url: "iCatch_microVideo.jsp?charVodId=10000100000000090000000000101284&bigImgVodId=10000100000000090000000000101300"
            }
        ];
        var menuObj = {};
        var focusPos = areaArry;	//焦点位置，0在菜单上，1在列表上，2在大图片上，3在下面的图片列表上，4在按钮上
        var lastFocusPos = 0;	//上一次焦点位置
        var listData = [
            {type: "头条", title: "超牛的哥开超牛的哥速度感豆腐干豆腐干开\"瘸腿汽车\"", url: ""},
            {type: "社会", title: "重庆文化艺术职业学院今年开建", url: ""},
            {type: "深度", title: "超牛的哥开超牛的哥开开超牛的哥开\"瘸腿汽车\"", url: ""},
            {type: "", title: "重庆文化艺术职业学院今年开建", url: ""},
            {type: "", title: "超牛的哥开超牛的哥开\"瘸腿汽车\"", url: ""}
        ];
        var listObj = {};
        var bigPicData = {
            src: "zcq_pic0.gif",
            url: ""
        };	//大图片数据
        var picData = [
            {src: "zcq_pic_img1.gif", title: "重庆科技馆参观活动图片集锦一", url: ""},
            {src: "zcq_pic_img2.gif", title: "刘德华 重庆演唱会巡演", url: ""},
            {src: "zcq_pic_img3.gif", title: "儿童节小伙伴看动画", url: ""}
        ];	//图片列表数据
        var picObj = {};
        var buttonData = [
            {focus: "iCatch_image/footbtn1_01.png", lostFocus: "iCatch_image/footbtn0_01.png", url: ""},
            {focus: "iCatch_image/footbtn1_02.png", lostFocus: "iCatch_image/footbtn0_02.png", url: ""}
        ];
        var buttonLen = buttonData.length;
        var buttonFocusPos = 0;
        var marqueeData = "TV+用户体验升级，爱看专区-最重庆全新亮相！为您全城搜罗本地新闻时事、生活实用资讯；集中献映本土麻辣影视；联手TICO少儿，集结品牌动漫，打造小朋友的专属乐园；汇聚本地原创微视频，发掘城市创意。过地道重庆生活，点播爱看专区-最重庆。";
        var currVodId = "";

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
                    case "KEY_EXIT":
                        doExit();
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
            initMenu();
            initList();
            showPic();
            initPic();
            initButton();
            showMarquee();
            setStyle(1);
        }

        //初始化菜单
        function initMenu() {
            var showIndex = 0;
            if (focusPos == 0) {
                showIndex = curPos;
            }
            menuObj = new E.showList(5, menuData.length, showIndex, 278, window);
            menuObj.listSign = 1;
            menuObj.listHigh = 180;
            menuObj.focusDiv = "menufocus";
            menuObj.haveData = setMenu;
            menuObj.notData = clearMenu;
            menuObj.startShow();
        }

        //设置菜单
        function setMenu(list) {
            //$("menufocus").innerText = menuData[list.dataPos].name;
        }

        //清除菜单
        function clearMenu(list) {
            $("menu" + list.idPos).innerText = "";
        }

        //初始化列表
        function initList() {
            var showIndex = 0;
            if (focusPos == 1) {
                showIndex = res_index;
            } else if (focusPos == 3) {
                showIndex = 4;
            }
            listObj = new E.showList(5, dataList.length, showIndex, 181, window);
            listObj.listHigh = 47;
            listObj.showType = 0;
            listObj.focusDiv = "listfocus";
            listObj.haveData = setList;
            listObj.notData = clearList;
            listObj.startShow();
        }

        //设置列表
        function setList(list) {
            var idPos = list.idPos;
            var tempListData = dataList[list.dataPos];

            $("listtype" + idPos).innerText = tempListData.type;
            $("listtitle" + idPos).innerText = iPanel.misc.interceptString(tempListData.name, 38);
        }

        //清除列表
        function clearList(list) {
        }

        //显示大图片
        function showPic() {
            $("pic").src = typeImgArray[0].typepicpath;
        }

        //初始化图片列表
        function initPic() {
            var showIndex = 0;
            if (focusPos == 3) {
                showIndex = curPos;
            }
            picObj = new E.showList(3, vodImgArray.length, showIndex, 75, window);
            picObj.listSign = 1;
            picObj.listHigh = 370;
            picObj.focusDiv = "picfocus";
            picObj.haveData = setPic;
            picObj.notData = clearPic;
            picObj.startShow();
        }

        //设置图片列表
        function setPic(list) {
            var idPos = list.idPos;
            var tempPicData = vodImgArray[list.dataPos];
            //if(idPos != 2){//去掉栏目改为全是影片
            $("img" + idPos).src = tempPicData.picPath;
            $("imgtitle" + idPos).innerText = iPanel.misc.interceptString(tempPicData.blockName, 28);
            $("imgdiv" + idPos).style.visibility = "visible";
            /*}else{
             $("img" + idPos).src = bottomImgArray[0].typepicpath;
             $("imgtitle" + idPos).innerText = iPanel.misc.interceptString(bottomImgArray[0].typeName,28);
             $("imgdiv" + idPos).style.visibility = "visible";
             }*/

        }

        //清除图片列表
        function clearPic(list) {
            $("imgdiv" + list.idPos).style.visibility = "hidden";
        }

        //初始化按钮
        function initButton() {
            for (var i = 0; i < buttonLen; i++) {
                $("button" + i).src = buttonData[i].lostFocus;
            }
        }

        //显示跑马灯内容
        function showMarquee() {
            E.marqueeZcq = marqueeData;
            $("marquee").innerText = E.marqueeZcq;
        }

        function setStyle(flag) {
            if (focusPos == 0) {
                $("menufocus").innerText = menuData[menuObj.position].name;
                $("menufocus").style.visibility = flag ? "visible" : "hidden";
            } else if (focusPos == 1) {
                $("listfocus").style.visibility = flag ? "visible" : "hidden";

                var tempList = dataList[listObj.position];
                var name = tempList.name;
                var tempName = iPanel.misc.interceptString(name, 32);

                $("typegreen").innerText = tempList.type;

                if (flag == 1) {
                    if (name != tempName) {
                        $("showName").innerHTML = "<marquee style=\"width:412px;height:47px;\">" + name + "</marquee>";
                    }
                    else {
                        $("showName").innerText = tempName;
                    }
                } else {
                    $("showName").innerText = tempName;
                }

                if (listObj.position > 2) {
                    $("typegreen").style.backgroundImage = "url()";
                } else {
                    $("typegreen").style.backgroundImage = "url(iCatch_image/zcq_mark_green.png)";
                }
            } else if (focusPos == 3) {
                $("picfocus").style.visibility = flag ? "visible" : "hidden";

                var tempList = vodImgArray[picObj.position];
                var name = tempList.blockName;
                var tempName = iPanel.misc.interceptString(name, 26);
                //if(picObj.position != 2){ //去掉栏目改为全是影片
                if (flag == 1) {
                    if (name != tempName) {
                        $("imgtitle" + picObj.position).innerHTML = "<marquee style=\"width:362px;height:47px;\">" + name + "</marquee>";
                    }
                    else {
                        $("imgtitle" + picObj.position).innerText = tempName;
                    }
                } else {
                    $("imgtitle" + picObj.position).innerText = tempName;
                }
                //}
            } else if (focusPos == 2) {
                $("focus").style.visibility = flag ? "visible" : "hidden";
            } else if (focusPos == 4) {
                if (buttonFocusPos == 0) {
                    $("button0").src = flag ? "iCatch_image/footbtn1_01.png" : "iCatch_image/footbtn0_01.png";
                } else {
                    $("button1").src = flag ? "iCatch_image/footbtn1_02.png" : "iCatch_image/footbtn0_02.png";
                }
            }
        }

        //上下移动
        function udMove(num) {
            setStyle(0);
            switch (focusPos) {
                case 0:	//焦点在菜单上
                    if (num > 0) {
                        focusPos = lastFocusPos == 0 ? 1 : lastFocusPos;
                        $(menuObj.focusDiv).style.visibility = "hidden";

                        if (focusPos == 1) {
                            setListStyle(true);
                            $(listObj.focusDiv).style.visibility = "visible";
                        }
                        else {
                            $("focus").style.visibility = "visible";
                        }
                    }
                    break;
                case 1:	//焦点在列表上
                    if (listObj.position == 0 && num < 0) {
                        lastFocusPos = 1;
                        focusPos = 0;
                        $(listObj.focusDiv).style.visibility = "hidden";
                        setListStyle(false);
                        $(menuObj.focusDiv).style.visibility = "visible";
                    }
                    else if (listObj.position == listObj.dataSize - 1 && num > 0 || listObj.position == 4 && num > 0) {
                        lastFocusPos = 1;
                        focusPos = 3;
                        $(listObj.focusDiv).style.visibility = "hidden";
                        setListStyle(false);
                        $(picObj.focusDiv).style.visibility = "visible";
                    }
                    else {
                        setListStyle(false);
                        listObj.changeList(num);
                        setListStyle(true);
                    }

                    break;
                case 2:	//焦点在大图上
                    lastFocusPos = focusPos;
                    focusPos = num > 0 ? 3 : 0;
                    $("focus").style.visibility = "hidden";
                    if (num > 0) {
                        $(picObj.focusDiv).style.visibility = "visible";
                    }
                    else {
                        $(menuObj.focusDiv).style.visibility = "visible";
                    }
                    break;
                case 3:	//焦点在图片列表上
                    if (num > 0) {
                        focusPos = 4;
                    } else {
                        focusPos = 1;
                    }
                    /*if (num > 0) {
                     lastFocusPos = focusPos;
                     focusPos = 4;
                     $(picObj.focusDiv).style.visibility = "hidden";
                     $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focus;
                     }
                     else {
                     focusPos = lastFocusPos == 4 ? 1 : lastFocusPos;
                     lastFocusPos = 3;
                     $(picObj.focusDiv).style.visibility = "hidden";

                     if (focusPos == 1) {
                     $(listObj.focusDiv).style.visibility = "visible";
                     setListStyle(true);
                     }
                     else {
                     $("focus").style.visibility = "visible";
                     }
                     }*/
                    break;
                case 4:	//焦点在按钮上
                    if (num < 0) {
                        focusPos = 3;
                    }
                    break;
            }
            setStyle(1);
        }

        //左右移动焦点
        function lrMove(num) {
            setStyle(0);
            switch (focusPos) {
                case 0:
                    menuObj.changeList(num);
                    break;
                case 1:
                    if (num > 0) {
                        lastFocusPos = focusPos = 2;
                        $(listObj.focusDiv).style.visibility = "hidden";
                        setListStyle(false);
                        $("focus").style.visibility = "visible";
                    }
                    break;
                case 2:
                    if (num < 0) {
                        lastFocusPos = focusPos = 1;
                        $(listObj.focusDiv).style.visibility = "visible";
                        setListStyle(true);
                        $("focus").style.visibility = "hidden";
                    }
                    break;
                case 3:
                    picObj.changeList(num);
                    break;
                case 4:
                    $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].lostFocus;
                    buttonFocusPos = ((buttonFocusPos + num) % buttonLen + buttonLen) % buttonLen;
                    $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focus;
                    break;
            }
            setStyle(1);
        }

        function doSelect() {
            switch (focusPos) {
                case 0:
                    var typeurl = "SaveCurrFocus.jsp?currFoucs=" + 0 + "," + 1 + "," + focusPos + "," + menuObj.position + "&url=";
                    location.href = typeurl + menuData[menuObj.position].url;
                    break;
                case 1:
                    currVodId = dataList[listObj.position].vodId;
                    getAuthUrl(currVodId);
                    break;
                case 2:
                    //右侧大图位
                    var typeurl = "SaveCurrFocus.jsp?currFoucs=" + 0 + "," + 1 + "," + focusPos + "," + 0 + "&url=";
                    if (typeImgArray[0].typeName == "防秋燥 吃螃蟹") {
                        window.location.href = typeurl + "2015autumn.jsp?typeId=10000100000000090000000000105554&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "情牵女人心") {
                        window.location.href = typeurl + "2015women.jsp?typeId=10000100000000090000000000104987&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "快乐暑期 安全不放假") {
                        window.location.href = typeurl + "2015_summerSafety.jsp?typeId=10000100000000090000000000105347&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "中高考实用宝典") {
                        window.location.href = typeurl + "2015gaoKao.jsp?typeId=10000100000000090000000000105178&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "炒股VS买房 你想好了吗") {
                        window.location.href = typeurl + "StockOrEstate.jsp?typeId=10000100000000090000000000105126&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "春季养生好时节") {
                        window.location.href = typeurl + "2015spring.jsp?typeId=10000100000000090000000000104987&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "高考实用宝典") {
                        window.location.href = typeurl + "entrance.jsp?typeId=" + typeImgArray[0].typeId + "&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "内养外护巧过冬") {
                        window.location.href = typeurl + "winterIndex.jsp?typeId=10000100000000090000000000104745&pageSize=100&startIndex=0";
                    } else if (typeImgArray[0].typeName == "2014年“最”榜单") {
                        window.location.href = typeurl + "listIndex.jsp?typeId=001000&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "学霸来了") {
                        window.location.href = typeurl + "xueBa.jsp?typeId=" + typeImgArray[0].typeId + "&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "智能手机那些事儿") {
                        window.location.href = typeurl + "mobilePhone.jsp?typeId=" + typeImgArray[0].typeId + "&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "骗术大揭秘") {
                        window.location.href = typeurl + "cheat.jsp?typeId=10000100000000090000000000104664&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "消夏美食季之舌尖上的重庆") {
                        window.location.href = typeurl + "tongueOfChongqing.jsp?typeId=" + typeImgArray[0].typeId + "&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == "挑战阿尔法狗") {
                        window.location.href = typeurl + "http://192.168.35.153:8080/weiqi.jsp?lcn=weiqi";
                    } else if (typeImgArray[0].typeName == "抗击节后综合症") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20160221.jsp";
                    } else if (typeImgArray[0].typeName == "2016全国两会") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20160307.jsp";
                    } else if (typeImgArray[0].typeName == "金婚祝福礼") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150916.jsp";
                    } else if (typeImgArray[0].typeName == "天天向上") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20160310.jsp";
                    } else if (typeImgArray[0].typeName == "3.15在行动") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20160315.jsp";
                    } else if (typeImgArray[0].typeName == "小编教你买年货") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20160201.jsp";
                    } else if (typeImgArray[0].typeName == "“习马会”历史性会见") {
                        window.location.href = typeurl + "iCatch_yulq_list.jsp?typeId=10000100000000090000000000105637&pageLength=8";
                    } else if (typeImgArray[0].typeName == "期末备考帮你赢") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20160115.jsp";
                    } else if (typeImgArray[0].typeName == "抢儿童新年音乐会门票") {
                        window.location.href = typeurl + "http://192.168.48.217:8085/iptv/entrance.jsp?gpid=126";
                    } else if (typeImgArray[0].typeName == "2016广播电视报读者新春大联欢") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20160114.jsp";
                    }  else if (typeImgArray[0].typeName == "十大妙招助你过暖冬") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20151215.jsp";
                    } else if (typeImgArray[0].typeName == "网购达人必看这十条") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20151105.jsp";
                    } else if (typeImgArray[0].typeName == "2015感动重庆年度人物") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20151223.jsp";
                    } else if (typeImgArray[0].typeName == "吃遍重庆旮旮旯旯") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150930.jsp";
                    } else if (typeImgArray[0].typeName == "青春 奋斗山城故事") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150730.jsp";
                    } else if (typeImgArray[0].typeName == "逐梦他乡重庆人") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150714.jsp";
                    } else if (typeImgArray[0].typeName == "火辣女人疯狂夏日") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150708.jsp";
                    } else if (typeImgArray[0].typeName == "儿童安全行为手册") {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150529.jsp";
                    } else if (typeImgArray[0].typeName == '女司机是不是“马路杀手”') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150507.jsp";
                    } else if (typeImgArray[0].typeName == '我家有房要装修') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150522.jsp";
                    } else if (typeImgArray[0].typeName == '家庭必备科学急救常识') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150330.jsp";
                    } else if (typeImgArray[0].typeName == '年夜饭家乡味') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150217.jsp";
                    } else if (typeImgArray[0].typeName == '冬季酷游记') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/A20141127.jsp";
                    } else if (typeImgArray[0].typeName == '小儿不再“难养”') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/S20150127.jsp";
                    } else if (typeImgArray[0].typeName == '麻辣言子儿逗山城第二季') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/A20141113.jsp";
                    } else if (typeImgArray[0].typeName == '我们一起过暖冬') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/A20141215.jsp";
                    } else if (typeImgArray[0].typeName == '我的上班路') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/A20140920.jsp?typeId=" + typeImgArray[0].typeId;
                    } else if (typeImgArray[0].typeName == '巧用带薪假环球走一个') {
                        window.location.href = typeurl + "/EPG/jsp/neirong/A20140828.jsp?typeId=" + typeImgArray[0].typeId;
                    } else if (typeImgArray[0].typeName == '十大广场舞必练“神曲”') {
                        window.location.href = typeurl + "dance10.jsp?typeId=" + typeImgArray[0].typeId + "&pageSize=50&startIndex=0";
                    } else if (typeImgArray[0].typeName == '做好七件事舒服过金秋') {
                        window.location.href = typeurl + "qiuys.jsp?typeId=" + typeImgArray[0].typeId + "&pageSize=50&startIndex=0";
                    } else {
                        window.location.href = typeurl + "iCatch_yulq_list.jsp?typeId=" + typeImgArray[0].typeId + "&pageLength=8";
                    }
                    break;
                case 3:
                    /*if(picObj.position == 2){ //改为全视频
                     var typeurl = "SaveCurrFocus.jsp?currFoucs=" + 0 + "," + 1+ "," + focusPos+ "," + picObj.position+"&url=";
                     if(bottomImgArray[0].typeName == '科教民生服务'){
                     window.location.href = typeurl+"aiKeJiao.jsp?typeId=10000100000000090000000000102364&pageSize=50&startIndex=0";
                     }else{
                     window.location.href = typeurl+"iCatch_yulq_list.jsp?typeId=" + bottomImgArray[0].typeId+ "&pageLength=8";
                     }
                     }else{*/
                    var typeurl = "SaveCurrFocus.jsp?currFoucs=" + 0 + "," + 1 + "," + focusPos + "," + menuObj.position + "&url=";
                    //第三个位置为专题推荐位
                    if (picObj.position == 2) {
                        if( vodImgArray[picObj.position].blockName == '逐梦他乡重庆人' ) {
                            window.location.href = typeurl + "/EPG/jsp/neirong/S20150714.jsp";
                        } else {
                            window.location.href = typeurl + "iCatch_yulq_list.jsp?typeId=10000100000000090000000000103636&pageLength=8";
                        }
                    } else {
                        if (vodImgArray[picObj.position].playType == 1) {
                            location.href = typeurl + "iCatch_TV_detail.jsp?vodId=" + vodImgArray[picObj.position].vodId + "&typeId=" + imgVodId;
                        } else {
                            currVodId = vodImgArray[picObj.position].vodId;
                            getAuthUrl(currVodId);
                        }
                    }
                    //}
                    break;
                case 4:
                    if (buttonFocusPos == 0) {
                        iPanel.mainFrame.location.href = iPanel.eventFrame.portalUrl;
                    }
                    else {
                        doBack();
                    }
                    break;
            }
        }

        /* tipsWindow.jsp中getAuthUrl()方法调用，从开始处播放 */
        function tip_fromBeginPlay() {
            res_index = listObj.position;
            var typeurl = "SaveCurrFocus.jsp?currFoucs=" + res_index + "," + 1 + "," + focusPos + "," + picObj.position + "&url=";

            var url = typeurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
                    + "&progId=" + currVodId + "&contentType=0&business=1&baseFlag=0";
            $("data_ifm").src = url;
        }

        /**从书签处播放 */
        function tip_fromBookmarkPlay() {
            res_index = listObj.position;
            var typeurl = "SaveCurrFocus.jsp?currFoucs=" + res_index + "," + 1 + "," + focusPos + "," + picObj.position + "&url=";

            var tempTime = domark(currVodId);
            var url = typeurl + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1"
                    + "&progId=" + currVodId + "&contentType=0&startTime=" + tempTime + "&business=1&baseFlag=0";
            $("data_ifm").src = url;
        }

        //退出
        function doExit() {
            iPanel.mainFrame.location.href = "ui://iptv_exit.htm?exit";
        }

        //返回
        function doBack() {
            window.location.href = "<%=turnPage.go(-1)%>";
        }

        function setListStyle(flag) {
            if (flag) {
                $("listdiv" + listObj.focusPos).style.backgroundImage = "url(iCatch_image/btm5_0.png)";
                $("listtitle" + listObj.focusPos).style.color = "#ffffff";
                $("listarrow" + listObj.focusPos).src = "iCatch_image/arrow0_1.png";
            }
            else {
                $("listdiv" + listObj.focusPos).style.backgroundImage = "url(iCatch_image/btm5_0.png)";
                $("listtitle" + listObj.focusPos).style.color = "#6a6868";
                $("listarrow" + listObj.focusPos).src = "iCatch_image/arrow0_0.png";
            }
        }
        //-->
    </script>
</head>

<body background="iCatch_image/zcq_bg.jpg" leftmargin="0" topmargin="0" onLoad="javascript:init();">

<!--Menu-->
<div style="position:absolute; left:278px; top:93px; width:187px; height:69px; background:url(iCatch_image/focus00.png) center no-repeat;-webkit-transition-duration:200ms; visibility: hidden;font-size:24px; color:#fff; line-height:78px; font-weight:bold; text-align:center;"
     id="menufocus"></div>
<div style="position:absolute; left:278px; top:108px; width:905px; height:50px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0"
           style="font-size:24px; color:#fff; line-height:50px; font-weight:bold; ">
        <tr>
            <td width="180" align="center" id="menu0">重庆资讯</td>
            <td width="180" align="center" id="menu1">麻辣剧场</td>
            <td width="180" align="center" id="menu2">生活帮</td>
            <td width="180" align="center" id="menu3">TICO空间</td>
            <td width="180" align="center" id="menu4">微视频</td>
        </tr>
    </table>
</div>

<!--文字列表区-->
<!--<div id="listfocus" style="position:absolute; left:95px; top:181px; width:596px; height:49px; background:url(iCatch_image/btm5_1.png) center no-repeat;-webkit-transition-duration:50ms; z-index:-1; visibility:hidden;"></div>
-->

<div style="position:absolute; left:95px; top:181px;background:url(iCatch_image/btm5_1.png) center no-repeat;line-height:49px;height:49px; z-index:1; visibility:hidden;"
     id="listfocus">
    <table width="597" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="72"
                style="background:url(iCatch_image/zcq_mark_green.png) no-repeat; color:#fefefe;font-weight:bold; font-size:22px; padding-left:5px;"
                id="typegreen">&nbsp;</td>
            <td width="30" height="49">&nbsp;</td>
            <td width="440" style="font-size:22px; color:#ffffff; font-weight:bold;" id="showName">&nbsp;</td>
            <td width="55"><img src="iCatch_image/arrow0_1.png" width="15" height="18" id="listarr"/></td>
        </tr>
    </table>
</div>

<div class="btm5_0" style="position:absolute; left:95px; top:181px;" id="listdiv0">
    <table width="597" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="72"
                style="background:url(iCatch_image/zcq_mark_green.png) no-repeat; color:#fefefe;font-weight:bold; font-size:22px; padding-left:5px;"
                id="listtype0">&nbsp;</td>
            <td width="30" height="49">&nbsp;</td>
            <td width="440" class="btm5_0txt" id="listtitle0"></td>
            <td width="55"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="listarrow0"/></td>
        </tr>
    </table>
</div>
<div class="btm5_0" style="position:absolute; left:95px; top:228px;" id="listdiv1">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="72"
                style="background:url(iCatch_image/zcq_mark_green.png) no-repeat; color:#fefefe;font-weight:bold; font-size:22px; padding-left:5px;"
                id="listtype1"></td>
            <td width="30" height="49">&nbsp;</td>
            <td width="440" class="btm5_0txt" id="listtitle1"></td>
            <td width="55"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="listarrow1"/></td>
        </tr>
    </table>
</div>
<div class="btm5_0" style="position:absolute; left:95px; top:275px;" id="listdiv2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="72"
                style="background:url(iCatch_image/zcq_mark_green.png) no-repeat; color:#fefefe;font-weight:bold; font-size:22px; padding-left:5px;"
                id="listtype2"></td>
            <td width="30" height="49">&nbsp;</td>
            <td width="440" class="btm5_0txt" id="listtitle2"></td>
            <td width="55"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="listarrow2"/></td>
        </tr>
    </table>
</div>
<div class="btm5_0" style="position:absolute; left:95px; top:322px;" id="listdiv3">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="72" id="listtype3"></td>
            <td width="30" height="49">&nbsp;</td>
            <td width="440" class="btm5_0txt" id="listtitle3"></td>
            <td width="55"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="listarrow3"/></td>
        </tr>
    </table>
</div>
<div class="btm5_0" style="position:absolute; left:95px; top:369px;" id="listdiv4">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="72" id="listtype4"></td>
            <td width="30" height="49">&nbsp;</td>
            <td width="440" class="btm5_0txt" id="listtitle4"></td>
            <td width="55"><img src="iCatch_image/arrow0_0.png" width="15" height="18" id="listarrow4"/></td>
        </tr>
    </table>
</div>

<!--右上方专题图片推荐区-->
<div style="position:absolute; left:721px; top:183px; width:453px; height:240px;"><img src="iCatch_image/global_tm.gif"
                                                                                       width="454" height="240"
                                                                                       id="pic"/></div>
<div id="focus"
     style="position: absolute; left: 708px; top: 170px; width: 476px; height: 265px; background: url(iCatch_image/focus000.png) center no-repeat; visibility:hidden;"></div>

<!--页面下方节目推荐区-->
<div style="position:absolute; left:80px; top:436px; width:372px; height:159px; background:url(iCatch_image/zcq_pic_bg.png) no-repeat;"
     id="imgdiv0">
    <div style="position:absolute; left:6px; top:6px; width:360px; height:147px;"><img src="iCatch_image/global_tm.gif"
                                                                                       width="360" height="147"
                                                                                       id="img0"/></div>
    <div class="pic_shade" style="position:absolute; left:6px; top:118px;" id="imgtitle0"></div>
</div>
<div style="position:absolute; left:450px; top:436px; width:372px; height:159px; background:url(iCatch_image/zcq_pic_bg.png) no-repeat;"
     id="imgdiv1">
    <div style="position:absolute; left:6px; top:6px; width:360px; height:147px;"><img src="iCatch_image/global_tm.gif"
                                                                                       width="360" height="147"
                                                                                       id="img1"/></div>
    <div class="pic_shade" style="position:absolute; left:6px; top:118px;" id="imgtitle1"></div>
</div>
<div style="position:absolute; left:820px; top:436px; width:372px; height:159px; background:url(iCatch_image/zcq_pic_bg.png) no-repeat;"
     id="imgdiv2">
    <div style="position:absolute; left:6px; top:6px; width:360px; height:147px;"><img src="iCatch_image/global_tm.gif"
                                                                                       width="360" height="147"
                                                                                       id="img2"/></div>
    <div class="pic_shade" style="position:absolute; left:6px; top:118px;" id="imgtitle2"></div>
</div>
<div id="picfocus"
     style="position:absolute; left:75px; top:430px; width:384px; height:173px; background:url(iCatch_image/focus001.png) center no-repeat; -webkit-transition-duration:200ms;visibility:hidden;"></div>
<!--Bottom-->
<div style="position:absolute; left:60px; top:625px; width:250px; height:45px;">
    <div style="position:absolute; top:1px; left:0px; width:58px; height:44px;"><img src="iCatch_image/footicon.png"
                                                                                     width="58" height="44"/></div>
    <div style="position:absolute; top:3px; left:60px; width:90px; height:42px;"><img src="iCatch_image/footbtn0_01.png"
                                                                                      width="90" height="42"
                                                                                      id="button0"/></div>
    <div style="position:absolute; top:3px; left:133px; width:90px; height:42px;"><img
            src="iCatch_image/footbtn0_02.png" width="90" height="42" id="button1"/></div>
</div>
<div style="position:absolute; left:400px; top:630px; width:780px; height:40px; font-size:18px; color:#fff; line-height:40px;">
    <marquee id="marquee">
    </marquee>
</div>

<iframe id="data_ifm" width="0px" height="0px" style="display:none;"></iframe>
<jsp:include page="showtip.jsp"></jsp:include>
</body>
</html>
