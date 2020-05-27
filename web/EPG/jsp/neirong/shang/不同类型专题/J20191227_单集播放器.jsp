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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113600";

    infos.add(new ColumnInfo(typeId, 0, 199));
//    List<Column> columns = inner.getList(typeId, 2, 0 , new Column());
//    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
//        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
//    }

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);

    String picture = column == null ? "" : inner.pictureUrl("images/J20191227Bg.png",column.getPosters(),"7");
    //picture = "images/J20191227Bg.png";
   // String titlePic = "";
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
        .listName{
            position: absolute;
        <%--width: <%=w %>px;--%>
            <%--height: <%=ih + mr %>px;--%>
            color:#c7a957;
            font-size:24px;
            overflow: hidden;
            line-height: 60px;
            background-repeat: no-repeat;
        }
        <%--#scrollLower{--%>
        <%--    left: <%= sc[0]%>px;--%>
        <%--    top: <%= sc[1]%>px;--%>
        <%--    height: <%= sc[2]%>px;--%>
        <%--    width: 5px;--%>
        <%--    background-color:#<%= sc[3]%>;--%>
        <%--    visibility: hidden;--%>
        <%--}--%>
        <%--#scrollUpper {--%>
        <%--    background-color:#<%= sc[4]%>;--%>
        <%--}--%>
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var maxTitleLen = 13;
    var scrollFlag = 1;
    var scrollWay = 1;
    cursor.initialize({
    data : [<%
            String html = "";
            for ( int i = 0; i < infos.size(); i++) {
                ColumnInfo info = infos.get(i);
                Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
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
        <% } %>
        for( var i = 0; i < this.data.length; i ++){
            var o = this.data[i];
            cursor.focusable[i] = {};
            cursor.focusable[i].typeId = o["id"];
            cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
            cursor.focusable[i].items = o["data"];
        }
        var items = cursor.focusable[0].items;
        for( var i = 0 ; i < items.length ;i ++  ){
            items[i].linkto = '/EPG/jsp/neirong/edu/v2/player.jsp?id=' + items[i].id + "&typeId=" + '<%= typeId%>';
        }
        cursor.focusable[1] = {};
        cursor.focusable[1].focus = this.focused.length > 2 ? Number( this.focused[2] ) : 0;
        cursor.focusable[1].items = [] ;
        for(var i = 0 ; i < 5; i++) {
            var o = this.data[0];
            cursor.focusable[1].items[i] = o["data"][5+i];
        }
        if(cursor.blocked <= 0){
            cursor.palyIndex = cursor.focusable[cursor.blocked].focus;
        } else if(cursor.blocked >=1){
            cursor.palyIndex = cursor.focusable[cursor.blocked].focus + 5;
        }
        setTimeout(function(){
            initList();
            cursor.call('show');
        },150);
        if( typeof cursor.moviePos != 'undefined' ) {
            setTimeout(function(){cursor.call('prepareVideo');},150);
        }
    },
    nextVideo   :   function () {
        var playIndex = cursor.playIndex;
        var blocked = 0;
        loseFocus();
        cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[blocked].items.length ? playIndex + 1 : 0;
        if(cursor.playIndex <= 4){
            cursor.blocked = 0;
            cursor.focusable[cursor.blocked].focus = cursor.palyIndex;
        }else{
            cursor.blocked = 1;
            cursor.focusable[cursor.blocked].focus = cursor.palyIndex - 5;
        }
        cursor.call('show');
        var item = cursor.focusable[blocked].items[playIndex];
        cursor.call("playMovie",item);
    },
    prepareVideo : function(){
       // var playIndex = cursor.playIndex || 0;
        var blocked = cursor.blocked;
        var focus = cursor.focusable[cursor.blocked].focus;
        if( cursor.focusable[blocked].items.length <= 0 )return;
        var item = cursor.focusable[blocked].items[focus];
        cursor.call("playMovie",item);
    },
    playMovie : function(item){
        var pos = cursor.moviePos;
        var parentId = undefined, vodId = undefined;
        if( typeof item.childrenList == "undefined" ){
            vodId = item.id;
            parentId = "undefined";
        } else {
            vodId = item.childrenList[0];
            parentId = item.id;
        }
        player.exit();
        player.play({
            vodId: vodId,
            parentId: parentId,
            position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
            callback:function(){
                //cursor.focusable[cursor.blocked].focus = cursor.playIndex;
                //cursor.call('show');
                //setTimeout(function(){cursor.call('lazyShow');},50);
            }
        });
    },
    move : function(index){
        //上 11，下 -11，左 -1，右 1
        var blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        //var items = cursor.focusable[blocked].items;
        loseFocus();
        if(index == 11){
            if(blocked <= 0 && focus > 0){
                focus--;
                cursor.focusable[blocked].focus = focus;
            }else if(blocked == 1){
                blocked = 0;
                cursor.blocked = blocked;
            }
        } else if (index == -11){
            if(blocked <=0 && focus < 4){
                focus++;
                cursor.focusable[blocked].focus = focus;
            }else if(blocked <=0 && focus >= 4){
                blocked = 1;
                cursor.blocked = blocked;
            }
        } else if(index == -1){
            if(blocked == 1 && focus > 0){
                focus--;
                cursor.focusable[blocked].focus = focus;
            }
        } else if (index == 1){
            if(blocked == 1 && focus < 4) {
                focus++;
                cursor.focusable[blocked].focus = focus;
            }
        }
        cursor.call('show');

        if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
        cursor.moveTimer = setTimeout(function(){
            clearTimeout(cursor.moveTimer);
            <% if( isEmpty(video) || video.split("\\,").length < 4 ){ %>
                return;
            <% } else {%>
            var focus = cursor.focusable[blocked].focus;
            var palyIndex = cursor.palyIndex;
            if( palyIndex != (focus + blocked *5) ) {
                if(blocked <= 0){
                    palyIndex = focus;
                }else if(blocked >=1){
                    palyIndex = focus+5;
                }
                var item = cursor.focusable[0].items[palyIndex];
                cursor.palyIndex = palyIndex;
                cursor.call('playMovie', item);
            }
            <% }%>
        }, 1000);

    },
    lazyShow : function(){
        var focus = cursor.focusable[cursor.blocked].focus;
        var w = 310;
        if(cursor.blocked >= 1){
            focus = focus+5;
            w = 185;
        }
        var blocked = 0;
        //var focus = cursor.focusable[blocked].focus;
        var text = cursor.focusable[blocked].items[focus].name;
        //var id = String( focus + 1 );
        var id = String( focus );
        cursor.calcStringPixels(text, 24, function(width){
            if( width <= w ) return;
            $('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
        });
    },
    show:function(){
        var  blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        if(blocked == 0){
            $("listName"+String(focus)).style.backgroundImage ="url(images/J20191227Focus0.png)";
            $("listName"+String(focus)).style.color ="#c08302";
        }else if(blocked == 1){
            $("listName"+String(focus+5)).style.backgroundImage ="url(images/J20191227Focus11.png)";
            $("listName"+String(focus+5)).style.color ="#c08302";
        }
        cursor.call('lazyShow');
        }
    });
    function initList() {
        var blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        if(blocked == 1){
            focus = focus+5;
        }
        listData = cursor.focusable[0].items;
        var pageCount = <%= pg %>;
        listBox = new showList(pageCount, listData.length, focus, 127, window);
        listBox.showType = 0;
        listBox.haveData = function (List) {
            $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
            if(List.idPos > 4){
                $("listName" + String(List.idPos)).style.backgroundImage = "url(images/J20191227Focus10.png)";
            }
        }
        listBox.notData = function (List) {
            $("listName" + List.idPos).innerText = "";
            if(List.idPos > 4){
                $("listName" + String(List.idPos)).style.backgroundImage = "url(images/global_tm.gif)";
            }
        };
        listBox.startShow();
    }
    function loseFocus(){
        var  blocked = cursor.blocked;
        var items = cursor.focusable[0].items;
        var focus = cursor.focusable[blocked].focus;
        if( items.length <= 0 ) return;
        if(blocked == 0){
            $("listName"+String(focus)).style.backgroundImage ="url(images/global_tm.gif)";
            $("listName"+String(focus)).style.color ="#c7a957";
            $("listName" + String(focus)).innerText = getStrChineseLength(listData[focus].name) > maxTitleLen?subStr(listData[focus].name,maxTitleLen,"..."):listData[focus].name;
        }else if(blocked == 1){
            $("listName"+String(focus+5)).style.backgroundImage ="url(images/J20191227Focus10.png)";
            $("listName"+String(focus+5)).style.color ="#c7a957";
            $("listName" + String(focus+5)).innerText = getStrChineseLength(listData[focus+5].name) > maxTitleLen?subStr(listData[focus+5].name,maxTitleLen,"..."):listData[focus+5].name;
        }
    }
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "none" : (" url('" + picture + "')")%> no-repeat;"></div>


<div id="list">
    <div id="list0" class="list" >
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName" style="left: 900px; top: 240px; width: 330px; height: 66px; text-align: left; padding-left: 20px;"></div>
    </div>
    <div id="list1" class="list" >
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName" style="left: 900px; top: 305px; width: 330px; height: 66px; text-align: left; padding-left: 10px;"></div>
    </div>
    <div id="list2" class="list" >
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName" style="left: 900px; top: 370px; width: 330px; height: 66px; text-align: left; padding-left: 20px;"></div>
    </div>
    <div id="list3" class="list" >
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName" style="left: 900px; top: 437px; width: 330px; height: 66px; text-align:left; padding-left: 20px;"></div>
    </div>
    <div id="list4" class="list">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName" style="left: 900px; top: 498px; width: 330px; height: 66px; text-align: left; padding-left: 20px;"></div>
    </div>
    <div id="list5" class="list">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName" style="left: 70px; top: 624px;width: 205px; height: 59px; text-align: center;"></div>
    </div>
    <div id="list6" class="list">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName" style="left: 290px; top: 624px;width: 205px; height: 59px; text-align: center;"></div>
    </div>
    <div id="list7" class="list">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName" style="left: 510px; top: 624px;width: 205px; height: 59px; text-align: center;"></div>
    </div>
    <div id="list8" class="list">
        <img id="listImg8" class="listImg"/>
        <div id="listName8" class="listName" style="left: 730px; top: 624px;width: 205px; height: 59px; text-align: center;"></div>
    </div>
    <div id="list9" class="list">
        <img id="listImg9" class="listImg"/>
        <div id="listName9" class="listName" style="left: 950px; top: 624px;width: 205px; height: 59px; text-align: center;"></div>
    </div>
</div>
</body>
</html>