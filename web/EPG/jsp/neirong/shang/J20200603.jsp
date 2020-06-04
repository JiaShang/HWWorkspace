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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114684";

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
    String picture = column == null ? "" : inner.pictureUrl("images/J20200603Bg.png",column.getPosters(),"7");
//    picture = "images/J20200603Bg.png";
    String[] sc = {};
    String[] titlePic = {};
    String[] focusPic = {};
    Integer w = null, h = null, ih = null, fs = null, lt = null,tp = null, pg = null, mr = null,focusLeft = null, focusTop = null,titleLeft = null, titleTop = null,titleStep = null, cat = null,maxTitleLen = null;
    String cl = null, bc = null,fc = null,bg=null,al=null,hm = null;
    List<List<Vod>> list = null;

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
                Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result);
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
        %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 3;
            cursor.backUrl='<%= backUrl %>';
            <% if( !isEmpty(video) && video.split("\\,").length > 3 ){ %>
            cursor.moviePos = [<%=video%>];
            cursor.lastBlocked = 3;
            cursor.playBlocked = 3;
            cursor.playIndex = 0;
            <% } %>
            totalBlocked = this.data.length;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                if(typeof o["data"] != 'undefined'){
                    cursor.focusable[i].items = o["data"];
                }else {
                    cursor.focusable[i].items = [];
                    cursor.focusable[i].items[0] = {
                        'name':"",
                        'dataNum':0
                    };
                }
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
            if (cursor.blocked < 3){
                cursor.playBlocked = 3;
                cursor.playIndex = cursor.focusable[cursor.blocked].focus;
            } else {
                if (typeof cursor.focusable[cursor.blocked].items[0].dataNum != 'undefined') {   //没有数据
                    cursor.playBlocked = 3;
                    cursor.playIndex = cursor.focusable[cursor.blocked].focus;
                }else {
                    cursor.playBlocked = cursor.blocked;
                    cursor.playIndex = cursor.focusable[cursor.blocked].focus;
                }
            }
            cursor.focusable[0].items[0].linkto = '/EPG/jsp/neirong/shang/J20200420List.jsp?typeId='+this.data[0]["id"]+'&blocked='+i+'&focus='+j+"&direct=0";
            cursor.focusable[1].items[0].linkto = '/EPG/jsp/neirong/shang/J20200420List.jsp?typeId='+this.data[1]["id"]+'&blocked='+i+'&focus='+j+"&direct=0";
            setTimeout(function(){
                initList();
                var focusFlag = <%=focusPic[5]  %>;
                if (focusFlag==0){
                    $("focus").style.visibility = "hidden";
                }else {
                    $("focus").style.visibility = "visible";
                    $("focus").style.backgroundImage = "url(images/J<%=focusPic[4]%>Focus.png)";
                }
                var titleFlag = <%=titlePic[5]  %>;
                if (titleFlag==0){
                    $("title").style.visibility = "hidden";
                }else {
                    $("title").style.visibility = "visible";
                    $("title").style.backgroundImage = " url(images/J<%=titlePic[4]%>Title0.png)";
                }

                cursor.call('show');
                var item = cursor.focusable[cursor.playBlocked].items[cursor.playIndex];
                cursor.call('playMovie', item);
            },150);

        },
        nextVideo   :   function () {
            var playIndex = cursor.playIndex;
            var blocked = cursor.playBlocked;
            cursor.call('loseFocus');

            if (listBox.position < listBox.dataSize -1){
                listBox.changeList(1);
            } else {
                listBox.changeList(-listBox.position);
            }
            cursor.playIndex = listBox.position;
            playIndex = cursor.playIndex;
            // cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[blocked].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
            cursor.focusable[cursor.playBlocked].focus = cursor.playIndex;
            cursor.call('show');
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            var blocked = cursor.playBlocked;
            if( cursor.focusable[blocked].items.length <= 0 )return;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
            // cursor.focusable[cursor.playBlocked].focus = cursor.playIndex;
            // cursor.call('show');
        },
        playMovie : function(item){
            var pos = cursor.moviePos;
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
                callback:function(){
                    // cursor.blocked = cursor.playBlocked;
                    // cursor.focusable[cursor.playBlocked].focus = cursor.playIndex;
                    // cursor.call('show');
                    //setTimeout(function(){cursor.call('lazyShow');},50);
                }
            });
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            //var focus = cursor.focusable[blocked].focus;
            //var items = cursor.focusable[blocked].items;
            if( index == 11 ){  //上
                if (blocked >2) {
                    cursor.call('loseFocus');
                    if (listBox.position > 0 ) {
                        listBox.changeList(-1);
                        cursor.focusable[blocked].focus = listBox.position;
                    }else {
                        cursor.lastBlocked = blocked;
                        blocked = blocked -3;
                        cursor.blocked = blocked;
                    }
                    cursor.call('show');
                }
            }else if( index == -11 ){   // 下
                if (blocked<2){
                    cursor.call('loseFocus');
                    blocked = blocked +3;
                    cursor.blocked = blocked;
                    initList();
                    cursor.call('show');
                } else if(blocked == 2){
                    cursor.call('loseFocus');
                    blocked = 4;
                    cursor.blocked = blocked;
                    initList();
                    cursor.call('show');
                }else {
                    if (listBox.position < listBox.dataSize-1) {
                        cursor.call('loseFocus');
                        listBox.changeList(1);
                        cursor.focusable[blocked].focus = listBox.position;
                        cursor.call('show');
                    }
                }
            }else if(index == -1 && blocked > 0){     //左
                if (blocked ==1 || blocked ==2){
                    cursor.call('loseFocus');
                    blocked--;
                    cursor.blocked = blocked;
                    cursor.call('show');
                } else if (blocked ==4) {
                    cursor.lastBlocked = blocked;
                    cursor.call('loseFocus');
                    blocked--;
                    cursor.blocked = blocked;
                    initList();
                    cursor.call('show');
                }
            }else if(index == 1){   // 右
                if (blocked ==1 || blocked ==0){
                    cursor.call('loseFocus');
                    blocked++;
                    cursor.blocked = blocked;
                    cursor.call('show');
                } else if (blocked ==3) {
                    cursor.lastBlocked = blocked;
                    cursor.call('loseFocus');
                    blocked++;
                    cursor.blocked = blocked;
                    initList();
                    cursor.call('show');
                }
            }
            <%--if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);--%>
            <%--cursor.moveTimer = setTimeout(function(){--%>
            <%--    clearTimeout(cursor.moveTimer);--%>
            <%--    <% if( isEmpty(video) || video.split("\\,").length < 4 ){ %>--%>
            <%--    //cursor.call('show');--%>
            <%--    return;--%>
            <%--    <% } else {%>--%>
            <%--    if (blocked > 2 && typeof cursor.focusable[blocked].items[0].dataNum == 'undefined'){--%>
            <%--        var focus = cursor.focusable[blocked].focus;--%>
            <%--        if( cursor.palyBlocked != blocked || cursor.playIndex != focus ) {--%>
            <%--            cursor.playIndex = focus;--%>
            <%--            cursor.palyBlocked = blocked;--%>
            <%--            var item = cursor.focusable[blocked].items[focus];--%>
            <%--            cursor.call('playMovie', item);--%>
            <%--            cursor.call('show');--%>
            <%--        }--%>
            <%--    }--%>
            <%--    <% }%>--%>
            <%--}, 1000);--%>

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
        select : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            // alert("iPanel.HD30Adv==="+iPanel.HD30Adv+",,,,items.length =="+items.length+"blocked==="+blocked+",,,,focus =="+focus);
            if(blocked == 2){
                cursor.call('search');
            }else if (blocked == 4 && typeof cursor.focusable[blocked].items[0].dataNum != 'undefined'){
                return;
            }else {
                cursor.call('selectAct');
            }
        },
        show:function(){
            var  blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[blocked].focus;
            if( items.length <= 0 ) return;
            var titleFlag = <%=titlePic[5]  %>;
            if (titleFlag == 1) {
                $("title").style.backgroundImage = "url(images/J<%=titlePic[4]%>Title" + blocked + ".png)";
            }
            $("listName"+String(listBox.focusPos)).style.color = "#<%=fc %>";
            var bc = "<%=bc %>";
            if( bc == "transparent"){
                $("listName"+String(listBox.focusPos)).style.backgroundColor = "<%=bc %>";
            }else {
                $("listName"+String(listBox.focusPos)).style.backgroundColor = "#<%=bc %>";
            }
            var focusFlag = <%=focusPic[5]  %>;
            if (focusFlag && cursor.blocked > 2 && typeof cursor.focusable[blocked].items[0].dataNum == 'undefined') {
                $("focus").style.top =String(listBox.focusPos*(<%=ih %>+<%=mr %>)+<%=focusPic[1] %>)+"px";
                $("focus").style.visibility = 'visible';
            }
            if (cursor.blocked > 2) {
                if (typeof cursor.focusable[blocked].items[0].dataNum != 'undefined') {    // 没有数据的情况
                    $("focus").style.visibility = 'hidden';
                    $("list").style.visibility = 'hidden';
                    player.exit();
                    $("bg").style.backgroundImage = 'url(images/J20200603Bg4.png)';
                } else {
                    // cursor.playBlocked = cursor.blocked;
                    if (typeof cursor.focusable[cursor.lastBlocked].items[0].dataNum != 'undefined') { // 没有数据的情况
                        var item = cursor.focusable[blocked].items[focus];
                        cursor.call('playMovie', item);
                    }else {
                        if( typeof cursor.moviePos != 'undefined') {
                            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
                            cursor.moveTimer = setTimeout(function(){
                                clearTimeout(cursor.moveTimer);
                                <% if( isEmpty(video) || video.split("\\,").length < 4 ){ %>
                                //cursor.call('show');
                                return;
                                <% } else {%>
                                    var focus = cursor.focusable[blocked].focus;
                                    if( cursor.palyBlocked != blocked || cursor.playIndex != focus ) {
                                        cursor.playIndex = focus;
                                        cursor.palyBlocked = blocked;
                                        var item = cursor.focusable[blocked].items[focus];
                                        cursor.call('playMovie', item);
                                        // cursor.call('show');
                                    }
                                <% }%>
                            }, 1000);
                        }
                        // cursor.playIndex = cursor.focusable[cursor.blocked].focus;
                        // setTimeout(function(){cursor.call('prepareVideo');},150);
                    }
                    $("focus").style.visibility = 'visible';
                    $("list").style.visibility = 'visible';
                    $("bg").style.backgroundImage = "url(" + "<%=picture %>" + ")";
                    cursor.call('lazyShow');
                }
            }else {
                $("focus").style.visibility = 'hidden';
                if (typeof cursor.focusable[cursor.lastBlocked].items[0].dataNum != 'undefined') { // 没有数据的情况
                    $("list").style.visibility = 'hidden';
                    player.exit();
                    $("bg").style.backgroundImage = 'url(images/J20200603Bg4.png)';
                }else{
                    $("list").style.visibility = 'visible';
                    $("bg").style.backgroundImage = "url(" + "<%=picture %>" + ")";
                }
            }
            scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
        },
        loseFocus:function(){
            $("listName"+String(listBox.focusPos)).style.color = "#<%=cl %>";
            var bg = "<%=bg %>";
            if( bg == "transparent"){
                $("listName"+String(listBox.focusPos)).style.backgroundColor = "<%=bg %>";
            }else {
                $("listName"+String(listBox.focusPos)).style.backgroundColor = "#<%=bg %>";
            }
            $("listName" + String(listBox.focusPos)).innerText = getStrChineseLength(listData[listBox.position].name) > maxTitleLen?subStr(listData[listBox.position].name,maxTitleLen,"..."):listData[listBox.position].name;
            if (cursor.blocked < 3 || (cursor.blocked > 2 && typeof cursor.focusable[cursor.blocked].items[0].dataNum != 'undefined')){
                $("focus").style.visibility = 'hidden';
            }
        }
    });
    function initList() {
        var blocked = 3;
        if (cursor.blocked < 3 ){
            blocked = cursor.lastBlocked;
        }else {
            blocked = cursor.blocked;
        }
        var focus = cursor.focusable[blocked].focus;
        listData = cursor.focusable[blocked].items;
        var pageCount = <%= pg %>;
        listBox = new showList(pageCount, listData.length, focus, 127, window);
        if (scrollFlag == 1 && <%=blocked%> == 1){
            listBox.showType = 1;
        } else {
            listBox.showType = 0;
        }
        listBox.haveData = function (List) {
            $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
            var bg = "<%=bg %>";
            if( bg == "transparent"){
                $("listName"+String(List.idPos)).style.backgroundColor = "<%=bg %>";
            }else {
                $("listName"+String(List.idPos)).style.backgroundColor = "#<%=bg %>";
            }
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
<div id="bg" style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "url(images/J20200515Bg.png)" : (" url('" + picture + "')")%> no-repeat;"></div>
<div id="title" style="background:transparent no-repeat;visibility: hidden;" ></div>
<div id="focus" style="background:transparent no-repeat;visibility: hidden;" ></div>
<div id="scrollLower" style="position: absolute;z-index: 1 ">
    <div id="scrollUpper" style="position: absolute;left: -2px; top: 0px; height: 70px;  width: 6px;z-index: 2;"></div>
</div>

<div id="list" style="position: absolute;width: <%=w %>px;height:<%= h %>px;left: <%=lt%>px;top: <%=tp%>px;">
    <div id="list0" class="list" style="top: 15px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list" style="top: 60px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list" style="top: 105px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list" style="top: 153px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="list" style="top: 197px;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName"></div>
    </div>
    <div id="list5" class="list" style="top: 248px;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName"></div>
    </div>
    <div id="list6" class="list" style="top: 295px;">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName"></div>
    </div>
    <div id="list7" class="list" style="top: 341px;">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName"></div>
    </div>

    <div id="list8" class="list" style="top: 248px;">
        <img id="listImg8" class="listImg"/>
        <div id="listName8" class="listName"></div>
    </div>
    <div id="list9" class="list" style="top: 295px;">
        <img id="listImg9" class="listImg"/>
        <div id="listName9" class="listName"></div>
    </div>
    <div id="list10" class="list" style="top: 341px;">
        <img id="listImg10" class="listImg"/>
        <div id="listName10" class="listName"></div>
    </div>
</div>
</body>
</html>