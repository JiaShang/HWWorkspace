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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000115000";

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
    String picture = column == null ? "" : inner.pictureUrl("images/J20200520Bg.png",column.getPosters(),"7");
    String[] sc = {};
    String[] titlePic = {};
    String[] focusPic = {};
    Integer w = null, h = null, ih = null, fs = null, lt = null,tp = null, pg = null, mr = null,focusLeft = null, focusTop = null,titleLeft = null, titleTop = null,titleStep = null, cat = null,maxTitleLen = null,direct=null;
    String cl = null, bc = null,fc = null,bg=null,al=null,hm = null;
    List<List<Vod>> list = null;

    String classifyID = inner.get("classifyID");
    //if( isEmpty(classifyID ) ) classifyID = "473";
    w = !isNumber( inner.get("w") ) ? 237 : Integer.valueOf(inner.get("w"));
    h = !isNumber( inner.get("h") ) ? 73 : Integer.valueOf(inner.get("h"));
    ih = !isNumber( inner.get("ih") ) ? 40 : Integer.valueOf(inner.get("ih"));
    fs = !isNumber( inner.get("fs") ) ? 22 : Integer.valueOf(inner.get("fs"));
    mr = !isNumber( inner.get("mr") ) ? 8 : Integer.valueOf(inner.get("mr"));

    lt = isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : ( isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : 73 );
    tp = !isNumber( inner.get("tp") ) ? 353 : Integer.valueOf(inner.get("tp"));
    cl = isEmpty( inner.get("cl") ) ? "ffffff" : inner.get("cl");
    fc = isEmpty( inner.get("fc") ) ? "ffffff" : inner.get("fc");
    bc = isEmpty( inner.get("bc") ) ? "transparent" : inner.get("bc");
    bg = isEmpty( inner.get("bg") ) ? "transparent" : inner.get("bg");
    al = isEmpty( inner.get("al") ) ? "0" : inner.get("al");
    sc = isEmpty( inner.get( "sc" )) ? new String[0] : inner.get("sc").split("\\,");
    titlePic = isEmpty( inner.get( "titlePic" )) ? new String[0] : inner.get("titlePic").split("\\,");
    focusPic = isEmpty( inner.get( "focusPic" )) ? new String[0] : inner.get("focusPic").split("\\,");

    pg = isEmpty( inner.get("pg") ) ? list.get(0).size() : Integer.valueOf( inner.get("pg") );


//    blocked = !isNumber( inner.get("blocked") ) ? 2 : Integer.valueOf(inner.get("blocked"));
    titleTop = !isNumber( inner.get("titleTop") ) ? 100 : Integer.valueOf(inner.get("titleTop"));
    titleLeft = !isNumber( inner.get("titleLeft") ) ? 200 : Integer.valueOf(inner.get("titleLeft"));
    cat = !isNumber( inner.get("cat") ) ? 0 : Integer.valueOf(inner.get("cat"));
    maxTitleLen = !isNumber( inner.get("maxTitleLen") ) ? 17 : Integer.valueOf(inner.get("maxTitleLen"));
    direct = !isNumber( inner.get("direct") ) ? 0 : Integer.valueOf(inner.get("direct"));


    if( al.equalsIgnoreCase("0")) al = "left";
    else if( al.equalsIgnoreCase("1")) al = "center";
    else al="right";

    h = pg * (ih + mr);
//    titleTop = tp -50;
//    titleLeft = lt;
    focusTop = tp -5;
    focusLeft = lt -15;
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
        .listName{
            width: <%=w %>px;
            height: <%=ih + mr %>px;
            color:#<%=cl%>;
            font-size:<%=fs %>px;
            background-color: transparent;
            overflow: hidden;
            text-align: left;
            line-height: <%=ih + mr %>px;
            padding-left: 10px;
            visibility: hidden;
        }
        .list{
            position: absolute;
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
        #title{
            position:absolute;
            overflow:hidden;
            left: <%= titlePic[0]%>px;
            top: <%= titlePic[1]%>px;
            width: <%= titlePic[2]%>px;
            height: <%= titlePic[3]%>px;
        }
        #focus{
            position:absolute;
            overflow:hidden;
            left: <%= focusPic[0]%>px;
            top: <%= focusPic[1]%>px;
            width: <%= focusPic[2]%>px;
            height: <%= focusPic[3]%>px;
        }
        img{
            background-repeat: no-repeat;
            overflow: hidden;
            width: 135px;
            height: 338px;
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
    <%--var blocked = <%= blocked%>;--%>
    cursor.initialize({
        data : [<%
            String html = "";
            for ( int i = 0; i < infos.size(); i++) {
                ColumnInfo info = infos.get(i);
                inner.special = true;
                Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result);
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
        %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';
            <% if( !isEmpty(video) && video.split("\\,").length > 3 ){ %>
            cursor.moviePos = [<%=video%>];
            cursor.focusPos = 0;
            <% } %>
            totalBlocked = this.data.length;
            cursor.serviceId = 2603;
            cursor.frequency = 2750000;
            cursor.channelId = '3792';
            cursor.program = '3';
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = [];
                if( <%=cat %> ){
                    for( var j = 0; j < cursor.focusable[i].items.length; j ++){
                        var name = cursor.focusable[i].items[j].name;
                        var star = name.indexOf("：");  //不存在返回-1
                        star++;
                        var end = name.indexOf("（") <=0 ? name.length : name.indexOf("（");
                        cursor.focusable[i].items[j].name = name.substring(0,end);  //substring取前不取后
                    }
                }
            }
            cursor.focusable[0].items=this.data[0]["data"];
            cursor.focusable[2].items[0]={};
            cursor.focusable[3].items[0]={};
            cursor.focusable[4].items[0]={};
            cursor.focusable[5].items[0]={};
            cursor.focusable[1].items = this.data[1]["data"];
            for (var i = 0 ; i < this.data[1]["data"].length ; i++){
                if (typeof cursor.focusable[1].items[i].posters != 'undefined' && typeof cursor.focusable[1].items[i].posters['5'] != 'undefined'){
                    // cursor.focusable[1].items[i]={};
                    cursor.focusable[1].items[i]={
                        'name':this.data[1]["data"][i].name,
                        'linkto':'/EPG/jsp/neirong/shang/J20200420List.jsp?typeId=10000100000000090000000000115000&blockedCount='+this.data.length+'&blocked=1&focus='+i+"&direct="+<%=direct%>,
                        'posters':this.data[1]["data"][i].posters
                    };
                    // adBgImgs = cursor.focusable[i].items[j].posters['5'];
                }else if (typeof cursor.focusable[1].items[i].posters != 'undefined' && typeof cursor.focusable[1].items[i].posters['99'] != 'undefined'){
                    // cursor.focusable[1].items[i]={};
                    var namePos = cursor.focusable[1].items[i].name.indexOf("&name=");
                    var name =cursor.focusable[1].items[i].name.substring(namePos+6);
                    var linkTo = cursor.focusable[1].items[i].name.substring(0,namePos);
                    cursor.focusable[1].items[i]={
                        'name':name,
                        'linkto':linkTo,
                        'posters':this.data[1]["data"][i].posters
                    };
                }
            }
            cursor.focusable[2].items[0]={
                'name':this.data[2]["data"][0].name,
                'linkto':"/EPG/jsp/neirong/shang/J20200427.jsp?typeId="+this.data[2].id+"&row=2&ct=3&wh=330&ht=219&ml=38&mh=5&cl=ffffff&fc=ff0000&bc=ff0000&cat=1&lft=43&tp=61&w=800&fs=24&cl=725f51&sc=1190,125,500,959ea5,ff0000,1,2,2&maxTitleLen=10"
            };
            cursor.focusable[3].items[0]={
                'name':this.data[3]["data"][0].name,
                'linkto':"http://125.62.26.147:82/list/tour/special.html?classId=57&rank=2&urlType=TOPIC"
            };
            cursor.focusable[4].items[0]={
                'name':this.data[4]["data"][0].name,
                'linkto':"http://125.62.26.147:82/list/tour/route.html?classId=59&rank=2&urlType=TOPIC"
            };
            cursor.focusable[5].items[0]={
                'name':this.data[5]["data"][0].name,
                'linkto':"/EPG/jsp/neirong/shang/J20200427_2.jsp?typeId="+this.data[5].id+"&titlePic=50,190,500,80,20200422,0&focusPic=785,74,550,80,20200520List,1&cl=ffffff&fc=ffffff&cat=1&lft=795&tp=70&w=420&ih=65&mr=0&fs=24&hm=1&pg=9&sc=490,250,330,ffffff,fff332,1,1,0&video=615,402,70,235&maxTitleLen=18"
            };

            cursor.palyBlocked = 0;
            cursor.palyIndex = 0;
            setTimeout(function(){
                initList();
                cursor.call('show');
                $("topic").style.backgroundImage = "url("+cursor.focusable[0].items[1].posters['3'][0] + ")";
            },500);
            if( typeof cursor.moviePos != 'undefined' ) {
                cursor.playIndex = cursor.focusable[cursor.blocked].focus;
                setTimeout(function(){cursor.call('prepareVideo');},500);
            }
            if( '<%=classifyID%>' != '' ) {
                cursor.call('trafficNum');
            }
        },
        nextVideo   :   function () {
            var playIndex = 0;
            var blocked = 0;
            // cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[blocked].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var playIndex = 0;
            var blocked = 0;
            if( cursor.focusable[blocked].items.length <= 0 )return;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        playMovie : function(item){
            var pos = cursor.moviePos;
            var items = cursor.focusable[0].items;
            player.exit();
            // alert("iPanel.HD30Adv==="+iPanel.HD30Adv+",,,,items.length =="+items.length);
            if (items.length ==3 && !iPanel.HD30Adv) {
                var VODflag = getStrParams("VODflag",items[2].name);
                if (VODflag == 1){
                    player.play({
                        position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                        channelId: cursor.channelId,
                        program: cursor.program
                    });
                } else if (VODflag == 2){
                    player.play({'url':'rtsp://192.168.14.60/PLTV/88888888/224/3221227603/10000100000000060000000004489947_0.smil'});
                } else {
                    player.play({
                        position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                        serviceId: cursor.serviceId,
                        frequency: cursor.frequency
                    });
                }

            }else {
                player.play({
                    vodId: item.id,
                    position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                    callback: function () {
                        // cursor.focusable[cursor.blocked].focus = cursor.playIndex;
                        //cursor.call('show');
                        //setTimeout(function(){cursor.call('lazyShow');},50);
                    }
                });
            }
        },
        select : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            // alert("iPanel.HD30Adv==="+iPanel.HD30Adv+",,,,items.length =="+items.length+"blocked==="+blocked+",,,,focus =="+focus);
            if(blocked == 0 && focus == 0 && items.length ==3 && !iPanel.HD30Adv ) {
                var VODflag = getStrParams("VODflag",items[2].name);
                if (VODflag == 1){ //时移播放
                    var item = cursor.focusable[blocked].items[0];
                    item.linkto = "/EPG/jsp/neirong/shang/fullScreenVOD.jsp?channelId=" + cursor.channelId + "&program=" + cursor.program + "&VODflag=1";
                } else if (VODflag == 2) {  //直接链接地址播放
                    var item = cursor.focusable[blocked].items[0];
                    item.linkto = "/EPG/jsp/neirong/shang/fullScreenVOD.jsp?VODflag=2";

                } else {
                    var item = cursor.focusable[blocked].items[0];
                    item.linkto = "/EPG/jsp/neirong/shang/fullScreenVOD.jsp?serviceId=" + cursor.serviceId + "&frequency=" + cursor.frequency;
                }
            }
            cursor.call('selectAct');
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            // var lastBlocke = cursor.lastBlocke;
            var items = cursor.focusable[blocked].items;
            cursor.call('loseFocus');
            if( index == 11){
                if (blocked == 2){
                    blocked = 0;
                    focus = 1;
                } else if (blocked == 0 && focus == 1) {
                    focus = 0;
                } else if (blocked > 2 ){
                    blocked = 1;
                    focus = cursor.focusable[blocked].focus;
                }
            }else if( index == -11){
                if (blocked == 0){
                    if (focus == 0){
                        focus = 1;
                    } else {
                        blocked = 2;
                        focus = 0;
                    }
                } else if (blocked == 1){
                    blocked = 3;
                    focus = 0;
                }
            }else if( index == -1 ){
                if (blocked == 1){
                    if (listBox.position == 0){
                        blocked--;
                        focus = 1;
                    } else {
                        listBox.changeList(-1);
                        focus = listBox.position;
                    }
                }else if(blocked > 2){
                    blocked--;
                    focus = 0;
                }
            }else if(index == 1 ){
                if (blocked == 0){
                    blocked = 1;
                    focus = listBox.position;
                }else if (blocked == 1){
                    if (listBox.position < listBox.dataSize-1) {
                        listBox.changeList(1);
                        focus = listBox.position;
                    }
                } else {
                    if (blocked < 5) {
                        blocked++;
                        focus = 0;
                    }
                }
            }
            cursor.blocked = blocked;
            // cursor.lastBlocke = blocked;
            cursor.focusable[blocked].focus = focus;
            cursor.call('show');
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
            var  blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[blocked].focus;
            if (blocked == 0){
                $("focus"+focus).style.visibility = "visible";
                $("title").style.backgroundImage = "url(images/J<%=titlePic[4]%>Title" + blocked + ".png)";
            } else if (blocked == 1){
                $("focus0").style.visibility = "hidden";
                $("focus1").style.visibility = "hidden";
                $("title").style.backgroundImage = "url(images/J<%=titlePic[4]%>Title" + (blocked-1) + ".png)";
                if (typeof items[listBox.position].posters != 'undefined' && typeof items[listBox.position].posters['3'] != 'undefined' && typeof items[listBox.position].posters['3'][0] != 'undefined' && typeof items[listBox.position].posters['3'][1] != 'undefined'){
                    $("listImg"+listBox.focusPos).src = items[listBox.position].posters['3'][1];
                } else {
                    $("listImg"+listBox.focusPos).src = "images/defaultImg.png";
                }
            } else{
                $("focus0").style.visibility = "hidden";
                $("focus1").style.visibility = "hidden";
                $("title").style.backgroundImage = "url(images/J<%=titlePic[4]%>Title" + blocked + ".png)";
            }
        },
        loseFocus:function(){
            var  blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[blocked].focus;
            if (blocked == 1){
                if (typeof items[listBox.position].posters != 'undefined' && typeof items[listBox.position].posters['3'] != 'undefined' && typeof items[listBox.position].posters['3'][0] != 'undefined'){
                    $("listImg"+listBox.focusPos).src = items[listBox.position].posters['3'][0];
                } else {
                    $("listImg"+listBox.focusPos).src = "images/defaultImg.png";
                }
            }else if (blocked == 0){
                $("focus"+focus).style.visibility = "hidden";
            }
        },
        trafficNum      :function(){
            var url="http://192.168.18.249:8080/voteNew/external/clickCount.ipanel?icid="+iPanel.cardId+"&classifyID="+'<%=classifyID%>'+"&content=1";
            ajax(url, function(rst){
                if( rst != "" && rst != 'undefined'&& rst.result ) {
                    //tooltip( decodeURIComponent('统计成功') );  //统计成功
                    return;
                }
            });
        }
    });
    function initList() {
        var blocked = 1;
        var focus = cursor.focusable[blocked].focus;
        listData = cursor.focusable[blocked].items;
        var pageCount = <%= pg %>;
        listBox = new showList(pageCount, listData.length, focus, 127, window);
        <%--if (scrollFlag == 1 && <%=blocked%> == 1){--%>
        <%--    listBox.showType = 1;--%>
        <%--} else {--%>
        <%--    listBox.showType = 0;--%>
        <%--}--%>
        listBox.showType = 0;
        listBox.haveData = function (List) {
            if (typeof listData[List.dataPos].posters != 'undefined' && typeof listData[List.dataPos].posters['3'] != 'undefined') {
                $("listImg"+List.idPos).src = listData[List.dataPos].posters['3'][0];
            }else {
                $("listImg"+List.idPos).src = "images/defaultImg.png";
            }
            $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
            var bg = "<%=bg %>";
            if( bg == "transparent"){
                $("listName"+String(List.idPos)).style.backgroundColor = "<%=bg %>";
            }else {
                $("listName"+String(List.idPos)).style.backgroundColor = "#<%=bg %>";
            }
        }
        listBox.notData = function (List) {
            $("listImg"+List.idPos).src = "images/global_tm.gif";
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
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "url(images/J20200520Bg.png)" : (" url('" + picture + "')")%> no-repeat;"></div>
<div id="title" style="background:transparent no-repeat;visibility: visible;" ></div>
<div id="focus0" style="background:transparent url(images/J20200520Focus0.png) no-repeat;visibility: hidden;position: absolute;left: 54px;top: 160px;width: 526px;height: 304px;" ></div>
<div id="focus1" style="background:transparent url(images/J20200520Focus1.png) no-repeat;visibility: hidden;position: absolute;left: 54px;top: 465px;width: 525px;height: 100px;" ></div>
<div id="topic" style="background:transparent no-repeat;visibility: visible;position: absolute;width: 509px;height: 83px;left: 62px;top: 473px;" ></div>
<div id="scrollLower" style="position: absolute;z-index: 1 ">
    <div id="scrollUpper" style="position: absolute;left: -2px; top: 0px; height: 70px;  width: 6px;z-index: 2;"></div>
</div>

<div id="list" style="position: absolute;width: <%=w %>px;height:<%= h %>px;left: <%=lt%>px;top: <%=tp%>px;">
    <div id="list0" class="list" style="top: 15px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list" style="top: 15px;left: 160px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list" style="top: 15px;left: 320px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list" style="top: 15px;left: 480px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="list" style="top: 197px;visibility: hidden;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName"></div>
    </div>
    <div id="list5" class="list" style="top: 248px;visibility: hidden;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName"></div>
    </div>
    <div id="list6" class="list" style="top: 295px;visibility: hidden;">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName"></div>
    </div>
    <div id="list7" class="list" style="top: 341px;visibility: hidden;">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName"></div>
    </div>
</div>
</body>
</html>