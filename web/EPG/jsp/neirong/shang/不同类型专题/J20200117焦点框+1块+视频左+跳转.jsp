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
    ftop:焦点框距离文字顶部的距离
    fleft:焦点框距离文字左边的距离
    pg:页面显示内容条数
    hm:是否显示首页，0:默认为空值，显示首页按钮，1:只要有任何值均不显示首页按钮
    sc:滚动条样式left,top,heihgt,bgColor,fcColor
    video:视频窗位置，width,height,left,top,
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113885";
    infos.add(new ColumnInfo(typeId, 0, 7));
//    List<Column> columns = inner.getList(typeId, 1, 0 , new Column());
//    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
//        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
//    }

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("images/J20200117Bg.png",column.getPosters(),"7");
    picture = "images/J20200117Bg.png";
    String titlePic = "";
    String[] sc = {};
    Integer w = null, h = null, ih = null, fs = null, lt = null,tp = null,   pg = null, mr = null,   ftop = null, fleft = null;
    String cl = null, bc = null,fc = null,bg=null,al=null,hm = null;
    List<List<Vod>> list = null;

    w = !isNumber( inner.get("w") ) ? 237 : Integer.valueOf(inner.get("w"));
    h = !isNumber( inner.get("h") ) ? 73 : Integer.valueOf(inner.get("h"));
    ih = !isNumber( inner.get("ih") ) ? 40 : Integer.valueOf(inner.get("ih"));
    fs = !isNumber( inner.get("fs") ) ? 22 : Integer.valueOf(inner.get("fs"));
    mr = !isNumber( inner.get("mr") ) ? 8 : Integer.valueOf(inner.get("mr"));
    ftop = !isNumber( inner.get("ftop") ) ? 10 : Integer.valueOf(inner.get("ftop"));
    fleft = !isNumber( inner.get("fleft") ) ? 20 : Integer.valueOf(inner.get("fleft"));

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
            width: <%=w %>px;
            height: <%=ih + mr %>px;
            color:#<%=cl%>;
            font-size:<%=fs %>px;
            background-color: transparent;
            overflow: hidden;
            text-align: left;
            line-height: <%=ih + mr %>px;
        }
        #scrollLower{
            left: <%=lt + w +40 %>px;
            top: <%= tp %>px;
            height: <%= sc[1]%>px;
            width: 5px;
            background-color:#<%= sc[2]%>;
            visibility: hidden;
        }
        #scrollUpper {
            background-color:#<%= sc[3]%>;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var maxTitleLen = 19;
     var scrollFlag = <%= sc[0]%>;
    var scrollWay = 1;
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
        // alert(this.data[0]["data"].length);
        cursor.focusable[0].items[this.data[0]["data"].length]={
            'name': '',
            'linkto': '/EPG/jsp/neirong/shang/J20200117List.jsp?typeId=' + '<%=typeId%>'+'&lft=220&tp=230&w=312&ih=50&mr=5&fs=24&hm=1&pg=7&fs=22&ftop=0&fleft=3&fc=ff0c01&bc=efe596&cl=efe596&sc=1,470,ffffff,af0200'
        };
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
            cursor.call('loseFocus');
            listBox.changeList(-1);
            cursor.focusable[blocked].focus = listBox.position;
            cursor.call('show');
        }else if( index == -11 && listBox.position < listBox.dataSize-1){
            cursor.call('loseFocus');
            listBox.changeList(1);
            cursor.focusable[blocked].focus = listBox.position;
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
        //var focus = listBox.position;
        var blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        var text = cursor.focusable[blocked].items[focus].name;
        //var id = String( focus + 1 );
        var id = String( listBox.focusPos );
        cursor.calcStringPixels(text, <%= fs %>, function(width){
            if( width <= <%= w-20 %> ) return;
            $('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
        });
    },
    show:function(){
        var  blocked = cursor.blocked;
        var items = cursor.focusable[blocked].items;
        var focus = cursor.focusable[blocked].focus;
        if( items.length <= 0 ) return;
        if(listBox.focusPos == items.length-1){
            $("focus").style.top =String(listBox.focusPos*<%=ih + mr %>+<%=tp-7%>)+"px";
        }else{
            $("focus").style.top =String(listBox.focusPos*<%=ih + mr %>+<%=tp-ftop%>)+"px";
        }
        $("listName"+listBox.focusPos).style.color = "#<%=fc%>";
        scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
        cursor.call('lazyShow');
        },
    loseFocus:function(){
        var  blocked = cursor.blocked;
        var items = cursor.focusable[blocked].items;
        if( items.length <= 0 ) return;
        $("listName"+listBox.focusPos).style.color = "#<%=cl%>";
        $("listName" + String(listBox.focusPos)).innerText = getStrChineseLength(listData[listBox.position].name) > maxTitleLen?subStr(listData[listBox.position].name,maxTitleLen,"..."):listData[listBox.position].name;
    }
    });
    function initList() {
        var blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        listData = cursor.focusable[blocked].items;
        var pageCount = <%= pg +1%>;
        listBox = new showList(pageCount, listData.length, focus, 127, window);
        listBox.showType = 1;
        listBox.haveData = function (List) {
            $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
        }
        listBox.notData = function (List) {
            $("listName" + List.idPos).innerText = "";
        };
        listBox.startShow();
        initScroll(listBox.dataSize,pageCount,listBox.listPage)
    }
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "url(images/J20200115Bg.png)" : (" url('" + picture + "')")%> no-repeat;"></div>
<div id="focus" style="width:145px;height:39px;left:<%=lt-fleft%>px;top:<%=tp-ftop%>px;position:absolute;overflow:hidden; background:transparent url(images/J20200117Focus.png) no-repeat;" ></div>
<div id="scrollLower" style="position: absolute;z-index: 1 ">
    <div id="scrollUpper" style="position: absolute; top: 0px; height: 100px;  width: 5px;z-index: 2;"></div>
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
</div>
</body>
</html>