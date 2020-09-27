<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    //  背景全是图片的专题（模块）
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;
    direct:方向，默认为坚，当不为空时为横
    type: (默认为1)， 取栏目下的视频，可以播放
        : 2， 取栏目下子栏目的背景图，仅展示图片，不可以播放
        : 3， 背景图直接绑在栏目上，不可以播放
    //背景绑定在每个条目的背景图上
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000117946";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = "images/J20191120Bg.png";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }
    int type = inner.getInteger("type", 1);  //默认所有图片绑到成栏目背景图下
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
    <title><%=column == null ? "背景全是图片的专题（模块）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        #listOne{
            position: absolute;
            left: <%=lt %>px;
            top: <%= tp %>px;
            width: <%=w %>px;
        }
        .listName{
            position: absolute;
            width: <%=w %>px;
            height: <%=ih + mr %>px;
            color:#<%=cl%>;
            font-size:<%=fs %>px;
            background-color: transparent;
            overflow: hidden;
            text-align: left;
            line-height: <%=ih + mr %>px;
            padding: 5px;
        }
        .list0{
            position: absolute;
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
        img{
            position: absolute;
            width: 225px;
            height: 155px;

        }

    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200102Bg.png)":" url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after"></div>
<div id="focus" style="position: absolute;width: 260px;height: 313px;left: 924px;top: 50px; overflow:hidden; background: url('images/J20200915ListFocus.png') no-repeat; visibility: visible; z-index: 1;" ></div>
<div id="scrollLower" style="position: absolute; left: 1120px; top: 230px; width: 5px; background-color: #dddddd; visibility: hidden; height: 400px;">
    <div id="scrollUpper" style="position: absolute; top: 0px; height: 100px;width: 28px;left: -12px; background-color: #fff1c0;z-index: 1;color: #3a8086;font-size: 22px;"></div>
</div>
<img id="bigImg" style="position: absolute;width: 750px; height: 500px;left: 140px; top: 120px;"/>
<div id="listOne">
    <div id="list0" class="list0" style="top: 0px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list0" style="top: 160px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list0" style="top: 320px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list0" style="top: 480px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
    </div>

<%--    <div id="list4" class="list0" style="top: 273px;">--%>
<%--        <img id="listImg4" class="listImg"/>--%>
<%--        <div id="listName4" class="listName"></div>--%>
<%--    </div>--%>
<%--    <div id="list5" class="list0" style="top: 340px;">--%>
<%--        <img id="listImg5" class="listImg"/>--%>
<%--        <div id="listName5" class="listName"></div>--%>
<%--    </div>--%>
<%--    <div id="list6" class="list0" style="top: 395px;">--%>
<%--        <img id="listImg6" class="listImg"/>--%>
<%--        <div id="listName6" class="listName"></div>--%>
<%--    </div>--%>
</div>

</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var maxTitleLen = 15;
    var scrollFlag = <%= sc[0]%>;
    var scrollWay = 1;
    var initialize = {
        data        : [<%
                String html = "";
                if( type == 1 || type == 2 ) {
                    for ( int i = 0; i < infos.size(); i++) {
                        ColumnInfo info = infos.get(i);
                        Result result =
                            type == 1 ?
                                inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() ) :
                                inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() );
                        html += inner.resultToString(result);
                        if( i + 1 < infos.size() ) html += ",\n";
                    }
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            <% if( type != 1 ) { %>
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            <% } else { %>
            var column = <%= inner.writeObject(column)%>;
            var posters = column.posters['5'];
            listData = posters;
            cursor.focusable[0] = {focus:0,items:[]};
            for( var i = 0; i < posters.length; i ++ )
                cursor.focusable[0].items[i] = {'name':'pic' +String( i + 1), 'posters':{'7':[posters[i]]} };
            <% } %>
            initList();
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            //为空时，上下移动，不为空时，左右移动
            var direct = <%= isEmpty(inner.get("direct")) %>;
            if (direct == 1) {   // 上下移动
                if (listBox.position > 0 && index == 11){
                    listBox.changeList(-1);
                } else if (listBox.position<listBox.dataSize-1 && index == -11){
                    listBox.changeList(1);
                }
            }else {               // 左右移动
                if (listBox.position > 0 && index == -1){
                    listBox.changeList(-1);
                } else if (listBox.position < listBox.dataSize-1 && index == 1){
                    listBox.changeList(1);
                }
            }

            cursor.focusable[blocked].focus = listBox.position;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        select : function(){ return;},
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            $("focus").style.top = String(listBox.focusPos*160+50)+"px";
            $("bigImg").src = listData[focus];
            // document.body.style.backgroundImage = 'url("' + picture + '")';
        }
    };
    function initList() {
        var focus = cursor.focusable[0].focus;
        listBox = new showList(4, listData.length, focus, 127, window);
        listBox.showType = 1;
        listBox.haveData = function (List) {
            $("listImg"+String(List.idPos)).src = listData[List.dataPos];
            // $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
        }
        listBox.notData = function (List) {
            // $("listName" + String(List.idPos)).innerText = "";
            $("listImg"+List.idPos).src = "images/global_tm.gif";
        };
        listBox.startShow();
        initScroll(listBox.dataSize,1,listBox.listPage);
        $("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />"+listBox.dataSize;
    }
    cursor.initialize(initialize);
    -->
</script>
</html>