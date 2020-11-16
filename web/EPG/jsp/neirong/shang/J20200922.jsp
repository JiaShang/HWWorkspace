<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    w:宽度
    h:高度
    ih:条目的高度
    mr:两个条目之间的空隙
    fs:字体大小
    lft:文本块显示坐标 LEFT
    tp:文本块显示坐标 TOP
    cl:文字颜色
    al:文字对齐方式，0:左对齐，１:居中对齐, 2:右对齐
    bg:普通条目背景颜色
    fc:焦点文字颜色
    bc:焦点背景
    pg:页面显示内容条数
    hm:是否显示首页，0:默认为空值，显示首页按钮，1:只要有任何值均不显示首页按钮
    sc:滚动条样式left,top,heihgt,bgColor,fcColor
    video:视频窗位置，width,height,left,top,
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000118154";

    Integer blocked = null;
    blocked = !isNumber( inner.get("blocked") ) ? 1 : Integer.valueOf(inner.get("blocked"));
    if(blocked == 1){
        infos.add(new ColumnInfo(typeId, 0, 99));
    }else {
        List<Column> columns = inner.getList(typeId, blocked, 0 , new Column());
        for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
            infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
        }
    }

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("images/J20200702Bg.png",column.getPosters(),"7");
//    picture = "images/J20200702Bg.png";
    String[] sc = {};
    String[] titlePic = {};
    String[] focusPic = {};
    Integer w = null, h = null, ih = null, fs = null, lt = null,tp = null, pg = null, mr = null,focusLeft = null, focusTop = null,titleLeft = null, titleTop = null,titleStep = null, cat = null,maxTitleLen = null;
    String cl = null, bc = null,fc = null,bg=null,al=null,hm = null;
    List<List<Vod>> list = null;

//    w = !isNumber( inner.get("w") ) ? 237 : Integer.valueOf(inner.get("w"));
//    h = !isNumber( inner.get("h") ) ? 73 : Integer.valueOf(inner.get("h"));
//    ih = !isNumber( inner.get("ih") ) ? 40 : Integer.valueOf(inner.get("ih"));
//    fs = !isNumber( inner.get("fs") ) ? 22 : Integer.valueOf(inner.get("fs"));
//    mr = !isNumber( inner.get("mr") ) ? 8 : Integer.valueOf(inner.get("mr"));
//
//    lt = isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : ( isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : 73 );
//    tp = !isNumber( inner.get("tp") ) ? 353 : Integer.valueOf(inner.get("tp"));
//    cl = isEmpty( inner.get("cl") ) ? "ffffff" : inner.get("cl");
//    fc = isEmpty( inner.get("fc") ) ? "ffffff" : inner.get("fc");
//    bc = isEmpty( inner.get("bc") ) ? "transparent" : inner.get("bc");
//    bg = isEmpty( inner.get("bg") ) ? "transparent" : inner.get("bg");
//    al = isEmpty( inner.get("al") ) ? "0" : inner.get("al");
    sc = isEmpty( inner.get( "sc" )) ? new String[0] : inner.get("sc").split("\\,");
//    titlePic = isEmpty( inner.get( "titlePic" )) ? new String[0] : inner.get("titlePic").split("\\,");
//    focusPic = isEmpty( inner.get( "focusPic" )) ? new String[0] : inner.get("focusPic").split("\\,");

//    pg = isEmpty( inner.get("pg") ) ? list.get(0).size() : Integer.valueOf( inner.get("pg") );


//    blocked = !isNumber( inner.get("blocked") ) ? 2 : Integer.valueOf(inner.get("blocked"));
//    titleTop = !isNumber( inner.get("titleTop") ) ? 100 : Integer.valueOf(inner.get("titleTop"));
//    titleLeft = !isNumber( inner.get("titleLeft") ) ? 200 : Integer.valueOf(inner.get("titleLeft"));
    cat = !isNumber( inner.get("cat") ) ? 0 : Integer.valueOf(inner.get("cat"));
    maxTitleLen = !isNumber( inner.get("maxTitleLen") ) ? 17 : Integer.valueOf(inner.get("maxTitleLen"));



//    if( al.equalsIgnoreCase("0")) al = "left";
//    else if( al.equalsIgnoreCase("1")) al = "center";
//    else al="right";

//    h = pg * (ih + mr);
//    titleTop = tp -50;
//    titleLeft = lt;
//    focusTop = tp -5;
//    focusLeft = lt -15;
    String video = inner.get("video","");
//    String titlePic = inner.get("titlePic","");
//    String focusPic = inner.get("focusPic","");



%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        #list{
            position:absolute;
            left: 588px;
            top: 520px;
            width: 620px;
            height: 250px;
        }
        .listName{
            position:absolute;
        <%--left: <%=lt%>px;--%>
            width: 300px;
            height: 80px;
            color: #975c32;
            font-size:24px;
            background-color: transparent;
            overflow: hidden;
            text-align: left;
            line-height: 80px;
            /*padding-left: 10px;*/
            /*padding-right: 10px;*/
        }
        #scrollLower{
            left: <%= sc[0]%>px;
            top: <%= sc[1]%>px;
            height: <%= sc[2]%>px;
            width: 2px;
            background-color:#<%= sc[3]%>;
            visibility: hidden;
        }
        #scrollUpper {
            background-color:#<%= sc[4]%>;
        }

        #more{
            position:absolute;
            overflow:hidden;
            left: 840px;
            top: 620px;
            width: 190px;
            height: 42px;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var maxTitleLen = <%= maxTitleLen%>;
    var scrollFlag = <%= sc[5]%>;
    var scrollWay = <%= sc[6]%>;
    var scrollData = <%= sc[7]%>;
    var totalBlocked = 1;

    var tipFlag = -1;
    var tipPic = "Vote1_";
    var tipFlagFocusPic = "tipFlagFocus1_";
    var tipFlagFocus = 0;
    var phoneNum = "0";
    var isPhoneError = true;
    var isFirstVote = true;
    var startHour = 20;
    var startMin = 0;
    var endHour = 22;
    var endMin = 0;
    var startDay = "2020-09-25 0:0:0";
    var endDay = "2020-09-30 0:0:0";
    <%--var blocked = <%= blocked%>;--%>
    cursor.initialize({
        data : [<%
            String html = "";
            for ( int i = 0; i < infos.size(); i++) {
                ColumnInfo info = infos.get(i);
                Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result);
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
        %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.voteId = 497 ;
            cursor.backUrl='<%= backUrl %>';
            <% if( !isEmpty(video) && video.split("\\,").length > 3 ){ %>
            cursor.moviePos = [<%=video%>];
            cursor.focusPos = 0;
            <% } %>
            totalBlocked = this.data.length;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                if (typeof o["data"] != "undefined" ){
                    cursor.focusable[i].items = o["data"];
                }else {
                    cursor.focusable[i].items = [];
                }
                if( <%=cat %> ){
                    for( var j = 0; j < cursor.focusable[i].items.length; j ++){
                        var name = cursor.focusable[i].items[j].name;
                        var star = name.indexOf("】");  //不存在返回-1
                        star++;
                        // if (star == -1){
                        //     star++;
                        // } else {
                        //     star = star+2;
                        // }
                        var end = name.indexOf("（") <=0 ? name.length : name.indexOf("（");
                        cursor.focusable[i].items[j].name = name.substring(star,end);  //substring取前不取后
                    }
                }
            }
            cursor.focusable[1].items[0]={
                'name': '演出活动',
                'linkto': '/EPG/jsp/neirong/shang/Jpicture.jsp?typeId='+cursor.focusable[1].typeId+'&direct=1'
            };
            cursor.focusable[2].items[0]={
                'name': '惠民活动',
                'linkto': '/EPG/jsp/neirong/shang/Jpicture.jsp?typeId='+cursor.focusable[2].typeId+'&direct=1'
            };
            cursor.palyIndex = cursor.focusable[2].focus;
            cursor.palyBlocked = cursor.blocked;
            setTimeout(function(){
                initList();
                cursor.call('show');
            },150);
            if( typeof cursor.moviePos != 'undefined' ) {
                cursor.playIndex = cursor.focusable[cursor.blocked].focus;
                setTimeout(function(){cursor.call('prepareVideo');},150);
            }
        },
        nextVideo   :   function () {
            var playIndex = cursor.playIndex;
            var blocked = 3;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[blocked].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex || 0;
            var blocked = 3;
            if( cursor.focusable[blocked].items.length <= 0 )return;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        playMovie : function(item){
            var pos = cursor.moviePos;
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
                callback:function(){
                    cursor.focusable[cursor.blocked].focus = cursor.playIndex;
                    //cursor.call('show');
                    //setTimeout(function(){cursor.call('lazyShow');},50);
                }
            });
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            //var focus = cursor.focusable[blocked].focus;
            // var items = cursor.focusable[blocked].items;
            cursor.call('loseFocus');
            if (tipFlag >=0 ){
                if(tipFlag == 4){
                    if(tipFlagFocus == 0 && index == -11){
                        tipFlagFocus = 1;
                        var tmp = $("phone").innerText;
                        if (tmp.indexOf("|") != -1) {
                            tmp = tmp.substring(0, tmp.length - 1);
                            $("phone").innerText = tmp;
                        }
                        $("tipFlagFocus1").style.visibility = 'visible';
                        $("tipFlagFocus0").style.visibility = 'hidden';
                    }else if(tipFlagFocus == 1 && index == 11){
                        tipFlagFocus = 0;
                        var tmp = $("phone").innerText;
                        if (tmp.indexOf("|") < 0) {
                            tmp = tmp + "|"
                            $("phone").innerText = tmp;
                        }
                        $("tipFlagFocus0").style.visibility = 'visible';
                        $("tipFlagFocus1").style.visibility = 'hidden';
                    }
                }
                return;
            }
            switch (index) {
                case 11:
                    cursor.call('upMove');
                    break;
                case -11:
                    cursor.call('downMove');
                    break;
                case -1:
                    cursor.call('leftMove');
                    break;
                case 1:
                    cursor.call('rightMove');
                    break;
            }
            cursor.call('show');
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                <% if( isEmpty(video) || video.split("\\,").length < 4 ){ %>
                //cursor.call('show');
                return;
                <% } else {%>
                var focus = cursor.focusable[cursor.blocked].focus;
                if( cursor.blocked == 3 && cursor.playIndex != focus ) {
                    cursor.playIndex = focus;
                    cursor.palyBlocked = blocked;
                    var item = cursor.focusable[cursor.blocked].items[focus];
                    cursor.call('playMovie', item);
                }
                <% }%>
            }, 1000);
        },
        upMove : function(){
            if (cursor.blocked == 3){
                if (listBox.focusPos > 1){
                    listBox.changeList(-2);
                    cursor.focusable[cursor.blocked].focus = listBox.position;
                }else {
                    cursor.blocked = listBox.focusPos+1;
                }
            }
        },
        downMove : function(){
            if (cursor.blocked == 1 || cursor.blocked == 2) {
                cursor.blocked = 3;
            }else if (cursor.blocked == 3){
                if (listBox.focusPos < 2) {
                    listBox.changeList(2);
                    cursor.focusable[cursor.blocked].focus = listBox.position;
                }
            }
        },
        leftMove : function(){
            if (cursor.blocked == 1 || cursor.blocked == 2) {
                cursor.blocked --;
            }else if (cursor.blocked == 3) {
                if (listBox.focusPos %2 == 0){
                    cursor.blocked = 0;
                }else {
                    listBox.changeList(-1);
                    cursor.focusable[cursor.blocked].focus = listBox.position;
                }
            }
        },
        rightMove : function(){
            if (cursor.blocked == 1) {
                cursor.blocked =2 ;
            }else if (cursor.blocked == 0) {
                cursor.blocked =3 ;
                listBox.changeList(listBox.position);
                cursor.focusable[cursor.blocked].focus = listBox.position;
            }else if (cursor.blocked == 3) {
                if (listBox.focusPos %2 == 0){
                    listBox.changeList(1);
                    cursor.focusable[cursor.blocked].focus = listBox.position;
                }else {
                    listBox.changeList(-1);
                    cursor.focusable[cursor.blocked].focus = listBox.position;
                }
            }
        },
        lazyShow : function(){
            //var focus = listBox.position;
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var id = String( listBox.focusPos );
            var text = $('listName' + id).innerText;
            if ( text.indexOf("...") != -1 ) {
                $('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + cursor.focusable[blocked].items[focus].name + '</marquee>';
            }
        },
        show:function(){
            var blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[blocked].focus;
            $("focus0").style.visibility = 'hidden';
            $("focus1").style.visibility = 'hidden';
            $("focus3").style.visibility = 'hidden';
            switch (blocked) {
                case 0:
                    $("focus0").style.visibility = 'visible';
                    break;
                case 1:
                    $("focus1").style.visibility = 'visible';
                    $("focus1").style.left = '565px';
                    break;
                case 2:
                    $("focus1").style.visibility = 'visible';
                    $("focus1").style.left = '723px';
                    break;
                case 3:
                    $("focus3").style.visibility = 'visible';
                    $("focus3").style.left = 567 + (listBox.focusPos%2)*323 + "px";
                    $("focus3").style.top = 531+ Math.floor(listBox.position/2)*55 +"px";
                    scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
                    cursor.call('lazyShow');
                    break;
            }
        },
        loseFocus:function(){
            if (cursor.blocked == 3) {
                $("listName" + String(listBox.focusPos)).innerText = getStrChineseLength(listData[listBox.position].name) > maxTitleLen ? subStr(listData[listBox.position].name, maxTitleLen, "...") : listData[listBox.position].name;
            }
        },
        select : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[0].focus;
            if (cursor.blocked == 0) {
                if (tipFlag < 0) {
                    // var currentTime = new Date().getTime();
                    // || !betweenHour(startHour, startMin, endHour, endMin)
                    if (betweenDay(startDay, endDay) == -1) {
                        cursor.call('showTip', 0);   //还未到时间
                    } else if (betweenDay(startDay, endDay) == 1) {
                        cursor.call('showTip', 3);   //已结束
                    } else {
                        cursor.call('showTip', 4);
                        // cursor.call('isFirstVote', cursor.voteId);
                        // setTimeout(function () {
                        //     // alert("isFirstVote==="+isFirstVote);
                        //     if (!isFirstVote) {
                        //         cursor.call('vote');  //投票
                        //     } else {
                        //         cursor.call('showTip', 4);   //首次投票，需要输入电话号
                        //     }
                        // }, 500);
                    }
                } else {
                    if (tipFlag == 4) {
                        if (tipFlagFocus == 1) {
                            cursor.call('showTip', 4);
                            if (!isPhoneError) {
                                phoneNum = $("phone").innerText;
                                cursor.call('vote');  //投票
                                cursor.call('loseTip');
                            }
                        }
                    } else {
                        cursor.call('loseTip');
                    }
                }
            }else {
                cursor.call('selectAct');
            }
            cursor.call('show');
        },
        goBack : function(){
            if (tipFlag >= 0 ){
                var tmp = $("phone").innerText;
                if (tipFlag == 4 && tipFlagFocus ==0 && tmp.length > 1 ){
                    rollBackInputNum("phone");  //回滚手机号
                } else {
                    cursor.call('loseTip');
                }

            }else {
                cursor.call('goBackAct');
            }
        },
        showTip : function(id){
            tipFlag = id;
            $("tooltip").style.backgroundImage = 'url("images/' + tipPic + String(id) + '.png")';
            $("tooltip").style.visibility = 'visible';
            if ( tipFlag == 4 ) {      //输入电话号时，按钮的样式
                var tmp = $("phone").innerText;
                $("tip").style.visibility = 'visible';
                $("tip").innerText = "请输入您的电话号码!";
                $("phone").style.visibility = 'visible';
                if (tmp.indexOf("|") < 0) {
                    if (tipFlagFocus == 0) {
                        // if (tmp == " "){
                        // tmp = "";
                        // }
                        tmp = tmp + "|";
                        $("phone").innerText = tmp;
                        $("tipFlagFocus0").style.visibility = 'visible';
                        $("tipFlagFocus1").style.visibility = 'hidden';
                    }
                } else {
                    if (tipFlagFocus != 0) {
                        tmp = tmp.substring(0, tmp.length - 1);
                        $("phone").innerText = tmp;
                        $("tipFlagFocus1").style.visibility = 'visible';
                        $("tipFlagFocus0").style.visibility = 'hidden';
                    }
                }
                if (tipFlagFocus == 1) {
                    isPhoneError = checkInput("phone", "tip");
                    if (!isPhoneError) {
                        showTipText("请点击按钮提交!", "tip");
                    }
                }
            }
            // $("tipFlagFocus").style.backgroundImage = 'url("images/' +tipFlagFocusPic + String(tipFlagFocus) + '.png")';
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                cursor.moveTimer = undefined;
                if(tipFlag >= 0 && tipFlag < 4){
                    cursor.call('loseTip');
                }
            }, 3000);
        },
        loseTip : function(){
            tipFlag = -1;
            tipFlagFocus = 0;
            $("tooltip").style.visibility = 'hidden';
            $("tip").style.visibility = 'hidden';
            $("phone").style.visibility = 'hidden';
            $("phone").innerText = "";
            $("tipFlagFocus0").style.visibility = 'hidden';
            $("tipFlagFocus1").style.visibility = 'hidden';
        },
        input : function(ch){
            if (tipFlag == 4 && tipFlagFocus == 0) {
                getInputNum(ch, "phone");
            }
        },
        vote : function(){
            var blocked = cursor.blocked;
            // if( blocked == 0 && focusPic == 1) {
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var currentTime = new Date().Format("yyyy-MM-dd hh:mm:ss");
            // var content = "提交时间："+currentTime;
            var content = iPanel.serialNumber;   //卡号
            voteMsg = {
                icid:iPanel.cardId,   //序列号
                phone:phoneNum,
                total:"false",  //是否返回最新票数总数（可选）
                classifyID:cursor.voteId,  //投票id
                content:encodeURIComponent(content),     //投票内容，中文请通过encodeURIComponent编码（可选）
                voteCount:10,     //总投票数
                compare:"ture",   //比较值（可选，用于实现如指定用户可投票功能）
                contentNum:10,      //对同一内容投票数
                msgContent:""    //(可选，当存在这个值则向当前phone推送一条短信，中文请通过encodeURIComponent编码)
            };
            var url="http://192.168.18.249:8080/voteNew/external/addVote6.ipanel?icid="+voteMsg.icid+"&phone="+voteMsg.phone+"&classifyID="+voteMsg.classifyID+"&content="+voteMsg.content+"&voteCount="+voteMsg.voteCount+"&contentNum="+voteMsg.contentNum;
            ajax(url, function(result){
                    if( result.recode != "002" || result.result == false ) {
                        //tooltip( decodeURIComponent('投票失败') );  //统计失败
                        cursor.call('showTip', 2);
                        return;
                    }else{
                        // tooltip( decodeURIComponent('投票成功') );  //统计成功{"result":true,"recode":"002"}
                        cursor.call('showTip', 1);  //投票成功
                        // items[focus].voteResult++;
                        var lastPos = listBox.position;
                        var lastName = cursor.focusable[0].items[listBox.position].name;
                        cursor.call('getVoteResult');
                        setTimeout(function(){
                            for (var i = 0;i < cursor.focusable[0].items.length ;i++) {
                                if (cursor.focusable[0].items[i].name == lastName) {
                                    cursor.call('loseFocus');
                                    listBox.changeList(i-lastPos);
                                    cursor.focusable[0].focus = listBox.position;
                                }
                            }
                            // initList(cursor.focusable[0].focus);
                            // $("listVoteResult"+String(listBox.focusPos)).innerText = cursor.focusable[0].items[cursor.focusable[0].focus].voteResult + "票";
                            cursor.call('show');
                        },800);
                    }
                },
                {
                    fail:function( meg )
                    {
                        tooltip( decodeURIComponent("fail") );
                        return;
                    }
                }
            );
        },
        isFirstVote : function(voteId){
            var url="http://192.168.18.249:8989/VoteStatistics/getVoteInfo?classifyID="+voteId;
            ajax(url, function(rst){
                    if( rst != "" && rst != 'undefined') {
                        //tooltip( decodeURIComponent('获取投票结果成功') );  //成功
                        for (var j = 0;j < rst.length ;j++){
                            rst[j].name = decodeURIComponent(rst[j].name);
                            if(iPanel.serialNumber == rst[j].name){
                                isFirstVote = false;
                                break;
                            }
                        }
                        return true;
                    }else{
                        // tooltip( decodeURIComponent('获取投票结果失败') );  //失败或者
                        return false;
                    }
                },
                {
                    fail:function( meg )
                    {
                        // tooltip( decodeURIComponent("fail") );
                        return false;
                    }
                }
            );
        }
    });
    function initList() {
        var blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        var pageCount = 4;
        listData = cursor.focusable[3].items;
        listBox = new showList(pageCount, listData.length, focus, 127, window);
        listBox.showType = 1;
        listBox.haveData = function (List) {
            $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
        }
        listBox.notData = function (List) {
            $("listName" + List.idPos).innerText = "";
            $("listName"+String(List.idPos)).style.backgroundColor = "transparent";
        };
        listBox.startShow();
        initScroll(listBox.dataSize,pageCount,listBox.listPage)
    }
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "url(images/J20200515Bg.png)" : (" url('" + picture + "')")%> no-repeat;"></div>
<div id="title" style="background:transparent no-repeat;visibility: hidden;" ></div>
<div id="focus3" style="position: absolute; width: 339px; height: 74px; left: 567px; top: 530px; background:url('images/J20200922Focus3.png') no-repeat; overflow: hidden; visibility: hidden;" ></div>
<div id="focus0" style="position: absolute; width: 443px; height: 80px; left: 85px; top: 561px; background:url('images/J20200922Focus0.png') no-repeat; overflow: hidden; visibility: hidden;" ></div>
<div id="focus1" style="position: absolute; width: 179px; height: 77px; left: 565px; top: 96px; background:url('images/J20200922Focus1.png') no-repeat; overflow: hidden; visibility: hidden;" ></div>
<div id="more" style="background:transparent no-repeat;visibility: visible;" ></div>
<div id="scrollLower" style="position: absolute;z-index: 1 ">
    <div id="scrollUpper" style="position: absolute;left: -2px; top: 0px; height: 70px;  width: 6px;z-index: 2;"></div>
</div>

<div id="list">
    <div id="list0" class="list">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName" style="top: 1px; left: 0px;"></div>
    </div>
    <div id="list1" class="list">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName" style="top: 1px; left: 320px;"></div>
    </div>
    <div id="list2" class="list">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName" style="top: 62px; left: 0px;"></div>
    </div>
    <div id="list3" class="list">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName" style="top: 62px; left: 320px;"></div>
    </div>
    <div id="list4" class="list">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName" style="top: 197px;"></div>
    </div>
    <div id="list5" class="list">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName" style="top: 248px;"></div>
    </div>
    <div id="list6" class="list">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName" style="top: 295px;"></div>
    </div>
    <div id="list7" class="list">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName" style="top: 341px;"></div>
    </div>
</div>

<div id="tooltip" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;">
    <div id="tip" style="position: absolute;left: 400px; top: 220px;width: 400px;height: 60px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #ffffff;font-size: 28px;">
    </div>
    <div id="phone" style="position: absolute;left: 420px; top: 305px;width: 400px;height: 50px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #c77000;font-size: 26px;">
    </div>
    <div id="tipFlagFocus0" style="position: absolute;left: 384px; top: 282px;width: 519px;height: 80px;visibility: hidden;overflow: hidden; background: url('images/tipFlagFocus.png') no-repeat;z-index: 2; visibility: hidden;">
    </div>
    <div id="tipFlagFocus1" style="position: absolute;left: 384px; top: 378px;width: 519px;height: 80px;visibility: hidden;overflow: hidden; background: url('images/tipFlagFocus.png') no-repeat;z-index: 2; visibility: hidden;">
    </div>
</div>

</body>
</html>