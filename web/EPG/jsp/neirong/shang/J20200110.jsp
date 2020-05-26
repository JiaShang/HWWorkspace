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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113720";
    List<Column> columns = inner.getList(typeId, 5, 0 , new Column());
    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
    }
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("images/J20200110Bg.png",column.getPosters(),"7");
    picture = "images/J20200110Bg.png";
//    String titlePic = "";
    String[] sc = {};
    Integer w = null, h = null, ih = null, fs = null, lt = null,tp = null,   pg = null, mr = null;
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
    bc = isEmpty( inner.get("bc") ) ? "F29B87" : inner.get("bc");
    bg = isEmpty( inner.get("bg") ) ? "transparent" : inner.get("bg");
    al = isEmpty( inner.get("al") ) ? "0" : inner.get("al");
    sc = isEmpty( inner.get( "sc" )) ? new String[0] : inner.get("sc").split("\\,");

    pg = isEmpty( inner.get("pg") ) ? list.get(0).size() : Integer.valueOf( inner.get("pg") );

    if( al.equalsIgnoreCase("0")) al = "left";
    else if( al.equalsIgnoreCase("1")) al = "center";
    else al="right";

    h = pg * (ih + mr);

    String video = inner.get("video","");

%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .text{
            width: <%=w %>px;
            height: <%=ih + mr %>px;
            color:#<%=cl%>;
            font-size:<%=fs %>px;
            background-color: transparent;
            overflow: hidden;
            text-align: left;
            line-height: <%=ih + mr %>px;
            left: 13px;
            top: 0px;
        }
        .icon{
            position: absolute;
            width: 15px;
            height: 16px;
            left: -30px;
            background-repeat: no-repeat;
            overflow: hidden;
        }
        #scrollLower{
            left: <%= sc[0]%>px;
            top: <%= sc[1]%>px;
            height: <%= sc[2]%>px;
            width: 6px;
            background-color:#<%= sc[3]%>;
            visibility: hidden;
        }
        #scrollUpper {
            background-color:#<%= sc[4]%>;
            width: 6px;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var maxTitleLen = 18;
    var scrollFlag = 1;
    var scrollWay = 1;
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
        cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
        cursor.backUrl='<%= backUrl %>';
        <% if( !isEmpty(video) && video.split("\\,").length > 3 ){ %>
        cursor.moviePos = [<%=video%>];
        cursor.focusPos = 0;
        cursor.blockedNum = this.data.length;
        <% } %>
        for( var i = 0; i < this.data.length; i ++){
            var o = this.data[i];
            cursor.focusable[i] = {};
            cursor.focusable[i].typeId = o["id"];
            cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
            cursor.focusable[i].items = o["data"];
        }
        var column = <%= inner.writeObject(column)%>;
        //var posters = column.posters['1'];
        for(var i = 1; i < 5; i ++){
            cursor.focusable[i].items[0] = {};
            if(i==4){
                cursor.focusable[i].items[0].linkto = '/EPG/jsp/neirong/STemplateOneTextColumn.jsp?typeId=10000100000000090000000000113680&lft=730&tp=250&w=425&h=387&ih=42&mr=1&fs=24&al=0&pg=8&bc=fff332&fc=000000&cl=171717&sc=1185,250,350,8c8c8c,fff332&video=631,392,42,232';
            }else {
                cursor.focusable[i].items[0].linkto = '/EPG/jsp/neirong/shang/J20200110List.jsp?typeId=' + cursor.focusable[i].typeId+'&blocked='+(i-1);
            }
        }
        cursor.palyBlocked = cursor.blocked;
        cursor.palyIndex = cursor.focusable[cursor.blocked].focus;
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
        var blocked = cursor.blocked;
        cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[blocked].items.length ? playIndex + 1 : 0;
        var item = cursor.focusable[blocked].items[playIndex];
        cursor.call("playMovie",item);
    },
    prepareVideo : function(){
        var playIndex = cursor.playIndex || 0;
        var blocked = cursor.blocked;
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
        //var items = cursor.focusable[blocked].items;

        if( index == 11 && listBox.position > 0){
            if(blocked <= 0 && listBox.position > 0){
                cursor.call('stopLazyShow');
                listBox.changeList(-1);
                cursor.focusable[blocked].focus = listBox.position;
                cursor.call('show');
            }
        }else if( index == -11 ){
            if(blocked <= 0 && listBox.position < listBox.dataSize-1){
                cursor.call('stopLazyShow');
                listBox.changeList(1);
                cursor.focusable[blocked].focus = listBox.position;
                cursor.call('show');
            }
        }else if(index == -1 && blocked > 0){
            blocked--;
            cursor.blocked = blocked;
            cursor.call('show');
        }else if(index == 1 && blocked < cursor.blockedNum-1){
            cursor.call('stopLazyShow');
            blocked++;
            cursor.blocked = blocked;
            cursor.call('show');
        }
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
            }
            <% }%>
        }, 1000);

    },
    lazyShow : function(){
        var focus = listBox.focusPos;
        var blocked = cursor.blocked;
        //var focus = cursor.focusable[0].focus;
        var text = cursor.focusable[blocked].items[focus].name;
        //var id = String( focus + 1 );
        var id = String( listBox.focusPos );
        $("icon" + String(focus)).style.backgroundImage = "url(images/J20200110Point1.png)";
        cursor.calcStringPixels(text, <%= fs %>, function(width){
            if( width <= <%= w-20 %> ) return;
            $('text' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
        });
    },
    stopLazyShow : function(){
        var focus = listBox.focusPos;
        $("text" + String(focus)).innerText = getStrChineseLength(listData[listBox.position].name) > maxTitleLen?subStr(listData[listBox.position].name,maxTitleLen,"..."):listData[listBox.position].name;
        $("icon" + String(focus)).style.backgroundImage = "url(images/J20200110Point0.png)";
    },
    show:function(){
        var  blocked = cursor.blocked;
        var items = cursor.focusable[blocked].items;
        var focus = cursor.focusable[0].focus;
        if( items.length <= 0 ) return;
        if(blocked > 0){
            $("focus1").style.visibility = "visible";
            $("focus1").style.left = String((blocked-1)*140+638)+"px";
            $("focus0").style.visibility = "hidden";
        }else {
            $("focus1").style.visibility = "hidden";
            $("focus0").style.visibility = "visible";
            $("focus0").style.top = String(listBox.focusPos * 62 + 236) + "px";
            scrollChange(listBox.dataSize, listBox.position, listBox.currPage, listBox.listPage);
            cursor.call('lazyShow');
        }
        }
    });
    function initList() {
        var blocked = 0;
        var focus = cursor.focusable[blocked].focus;
        listData = cursor.focusable[blocked].items;
        var pageCount = <%= pg %>;
        listBox = new showList(pageCount, listData.length, focus, 127, window);
        listBox.showType = 1;
        listBox.haveData = function (List) {
            $("icon" + String(List.idPos)).style.backgroundImage = "url(images/J20200110Point0.png)";
            $("text" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
        }
        listBox.notData = function (List) {
            $("text" + String(List.idPos)).innerText = "";
            $("icon"+String(List.idPos)).style.backgroundImage = "images/global_tm.gif";
        };
        listBox.startShow();
        initScroll(listBox.dataSize,pageCount,listBox.listPage)
    }
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "none" : (" url('" + picture + "')")%> no-repeat;"></div>
<div id="title0" style="width:117px;height:93px;left:645px;top:540px;position:absolute;overflow:hidden; background:transparent url(images/J20200110Title0.png) no-repeat;" ></div>
<div id="title1" style="width:117px;height:93px;left:785px;top:540px;position:absolute;overflow:hidden; background:transparent url(images/J20200110Title1.png) no-repeat;" ></div>
<div id="title2" style="width:117px;height:94px;left:925px;top:540px;position:absolute;overflow:hidden; background:transparent url(images/J20200110Title2.png) no-repeat;" ></div>
<div id="title3" style="width:117px;height:94px;left:1065px;top:540px;position:absolute;overflow:hidden; background:transparent url(images/J20200110Title3.png) no-repeat;" ></div>
<div id="focus1" style="width:135px;height:115px;left:638px;top:525px;position:absolute;overflow:hidden; background:transparent url(images/J20200110Focus1.png) no-repeat;visibility: hidden;" ></div>
<div id="focus0" style="width:500px;height:74px;left:97px;top:236px;position:absolute;overflow:hidden; background:transparent url(images/J20200110Focus0.png) no-repeat;visibility: hidden;" ></div>
<div id="scrollLower" style="position: absolute;z-index: 1 ">
    <div id="scrollUpper" style="position: absolute; top: 0px; height: 100px;z-index: 2;"></div>
</div>

<div id="list" style="position: absolute;width: <%=w %>px;height:<%= h %>px;left: <%=lt%>px;top: <%=tp%>px;">
    <div id="list0" class="list" style="top: 15px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName">
            <div id="icon0" class="icon" style="top: 22px;"></div>
            <div id="text0" class="text"></div>
        </div>
    </div>
    <div id="list1" class="list" style="top: 70px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName">
            <div id="icon1" class="icon" style="top: 85px;"></div>
            <div id="text1" class="text"></div>
        </div>
    </div>
    <div id="list2" class="list" style="top: 105px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName">
            <div id="icon2" class="icon" style="top: 148px;"></div>
            <div id="text2" class="text"></div>
        </div>
    </div>
    <div id="list3" class="list" style="top: 153px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName">
            <div id="icon3" class="icon" style="top: 211px;"></div>
            <div id="text3" class="text"></div>
        </div>
    </div>
    <div id="list4" class="list" style="top: 197px;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName">
            <div id="icon4" class="icon" style="top: 274px;"></div>
            <div id="text4" class="text"></div>
        </div>
    </div>
    <div id="list5" class="list" style="top: 278px;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName">
            <div id="icon5" class="icon" style="top: 333px;"></div>
            <div id="text5" class="text"></div>
        </div>
    </div>
    <div id="list6" class="list" style="top: 295px;">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName">
            <div id="icon6" class="icon" style="top: 295px;"></div>
            <div id="text6" class="text"></div>
        </div>
    </div>
    <div id="list7" class="list" style="top: 341px;">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName">
            <div id="icon7" class="icon" style="top: 341px;"></div>
            <div id="text7" class="text"></div>
        </div>
    </div>
</div>
</body>
</html>