<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //���Ȼ�ȡ�����е���ĿID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114921";

    Integer blocked = null;
//    String[] typeIds = new String[20];
    blocked = !isNumber( inner.get("blocked") ) ? 1 : Integer.valueOf(inner.get("blocked"));
    if(blocked == 1){
        infos.add(new ColumnInfo(typeId, 0, 99));
    }else {
        List<Column> columns = inner.getList(typeId, blocked, 0 , new Column());
        for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
            infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
//            typeIds[i] = columns.get(i).id;
        }
    }
//    Column column = new Column();
//    List<Column> columns = inner.getList(typeId, 4, 0, column);
//    for( Column col : columns ) {
//        infos.add(new ColumnInfo(col.getId(), 0, 6));
//    }
//    Result result = new Result( typeId, columns );
    //��ȡ��ǰ��Ŀ����ϸ��Ϣ
    Column column = new Column();
    column = inner.getDetail(typeId,column);
//    String[] picture = {};
//    for (int i = 0 ; i < typeIds.length; i++){
//        column = inner.getDetail(typeIds[i],column);
//        picture[i] = column == null ? "" : inner.pictureUrl("images/J20200511Bg.png",column.getPosters(),"7");
//    }
    String picture = column == null ? "" : inner.pictureUrl("images/J20200511Bg.png",column.getPosters(),"7");
    String[] sc = {};
    Integer w = null, h = null, ih = null, fs = null, lt = null,tp = null, pg = null, mr = null,focusLeft = null, focusTop = null,titleLeft = null, titleTop = null,titleStep = null, cat = null,maxTitleLen = null,direct=null;
    String cl = null, bc = null,fc = null,bg=null,al=null,hm = null,titlePic = null,focusPic = null;
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

    pg = isEmpty( inner.get("pg") ) ? list.get(0).size() : Integer.valueOf( inner.get("pg") );

    titlePic = isEmpty( inner.get("titlePic") ) ? null : inner.get("titlePic");
    focusPic = isEmpty( inner.get("focusPic") ) ? null : inner.get("focusPic");
//    blocked = !isNumber( inner.get("blocked") ) ? 2 : Integer.valueOf(inner.get("blocked"));
    titleTop = !isNumber( inner.get("titleTop") ) ? 100 : Integer.valueOf(inner.get("titleTop"));
    titleLeft = !isNumber( inner.get("titleLeft") ) ? 200 : Integer.valueOf(inner.get("titleLeft"));
    focusTop = !isNumber( inner.get("focusTop") ) ? 200 : Integer.valueOf(inner.get("focusTop"));
    focusLeft = !isNumber( inner.get("titleLeft") ) ? 500 : Integer.valueOf(inner.get("focusLeft"));
    cat = !isNumber( inner.get("cat") ) ? 0 : Integer.valueOf(inner.get("cat"));
    maxTitleLen = !isNumber( inner.get("maxTitleLen") ) ? 15 : Integer.valueOf(inner.get("maxTitleLen"));
    direct = !isNumber( inner.get("direct") ) ? 0 : Integer.valueOf(inner.get("direct"));

    if( al.equalsIgnoreCase("0")) al = "left";
    else if( al.equalsIgnoreCase("1")) al = "center";
    else al="right";

    h = pg * (ih + mr);
//    titleTop = tp -50;
//    titleLeft = lt;
    String video = inner.get("video","");

%>
<html>
<head>
    <title><%=column == null ? "��˫11�� ��������ģ�" : column.getName()%></title>
    <meta charset="GB18030">
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
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div id="bg" style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent no-repeat;"></div>
<div id="title" style="width:940px;height:48px;left:<%=titleLeft %>px;top:<%=titleTop %>px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(titlePic) ? "none" : (" url(images/J" + titlePic + "Title1.png)")%> no-repeat;visibility: visible;" ></div>
<div id="focus0" style="width:394px;height:50px;left:<%=focusLeft %>px;top:<%=focusTop %>px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(focusPic) ? "none" : (" url(images/J" + focusPic + "Focus.png)")%> no-repeat no-repeat;" ></div>
<div id="scrollLower" style="position: absolute;z-index: 1 ">
    <div id="scrollUpper" style="position: absolute; left: -3px; top: 0px; height: 70px;  width: 7px;z-index: 2;"></div>
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
<script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var maxTitleLen = <%= maxTitleLen%>;
    var scrollFlag = <%= sc[5]%>;
    var scrollWay = <%= sc[6]%>;
    var scrollData = <%= sc[7]%>;
    var titlePic = <%= titlePic%>;
    var focusPic = <%= focusPic%>;
    var blocked = <%= blocked%>;
    // var bgImgs = ["images/J20200511Bg0.jpg","images/J20200511Bg1.png","images/J20200511Bg2.png"];
        cursor.initialize({
        data        : [<%
            String html = "";
            for ( int i = 0; i < infos.size(); i++) {
                ColumnInfo info = infos.get(i);
                Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result);
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            if (blocked != cursor.blocked){
                blocked = cursor.blocked;
            }
            cursor.backUrl='<%= backUrl %>';
            cursor.playBlocked = 1;
            cursor.lastBlocked = 1;
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
                if (i == 1){
                    // cursor.focusable[i].items = o["data"];
                    if( <%=cat %> ){
                        for( var j = 0; j < cursor.focusable[i].items.length; j ++){
                            var name = cursor.focusable[i].items[j].name;
                            var star = name.indexOf("��");  //�����ڷ���-1
                            star++;
                            var end = name.indexOf("��") <=0 ? name.length : name.indexOf("��");
                            cursor.focusable[i].items[j].name = name.substring(0,end);  //substringȡǰ��ȡ��
                        }
                    }
                }

            }
            var column = <%= inner.writeObject(column)%>;
            bgImgs = column.posters['7'];
            setTimeout(function(){initList();},50);
            setTimeout(function(){ cursor.call('show');cursor.call('lazyShow');},150);
            if (cursor.blocked != 0 ){
                setTimeout(function(){ cursor.call('prepareVideo');},150);
            }
        },
        move        :   function(index){
            //�� 11���� -11���� -1���� 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var pageCount = <%= pg %>;
            cursor.call('loseFocus');
            if(index == -11){  //��
                if(blocked == 1){
                    // if(listBox.focusPos< pageCount-1 && listBox.position<items.length-1){
                    if(listBox.position<items.length-1){
                        listBox.changeList(1);
                        cursor.focusable[blocked].focus = listBox.position;
                    }
                }
            }else if(index == 11){  //��
                if (blocked == 1){
                    if (listBox.position > 0){
                        listBox.changeList(-1);
                        cursor.focusable[blocked].focus = listBox.position;
                    }
                }
            }else if(index == 1) {  //��
                if (blocked >= 0 && blocked < 2) {
                    blocked++;
                    cursor.blocked = blocked;
                }
            }else if(index == -1) {  //��
                if (blocked > 0 ) {
                    blocked--;
                    cursor.blocked = blocked;
                }
            }
            cursor.call('show');
            if (cursor.blocked == 1) {
                cursor.call('lazyShow');
            }
            if (cursor.blocked == 2) {
                cursor.playBlocked = blocked;
                cursor.call('prepareVideo');
            }else {
                player.exit();
            }
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                cursor.moveTimer = undefined;
                var focus = cursor.focusable[1].focus;
                if(cursor.blocked != 0 && (cursor.blocked != cursor.playIndex || cursor.playIndex != focus)){
                    cursor.playIndex = focus ;
                    cursor.playBlocked = blocked;
                    cursor.call('prepareVideo');
                }
            }, 500);
        },
        lazyShow    :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var id = String( listBox.focusPos );
            var text = $('listName' + id).innerText;
            if ( text.indexOf("...") != -1 ) {
                $('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + cursor.focusable[blocked].items[focus].name + '</marquee>';
            }
        },
        nextVideo   :   function () {
            var blocked = cursor.playBlocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            <%--var pageCount = <%= pg %>;--%>
            cursor.call('loseFocus');
            // if( focus == items.length-1 || focus == pageCount-1 ){
            if (blocked == 1){
                if( focus == items.length-1 ){
                    focus = 0;
                }else{
                    focus++;
                }
                cursor.focusable[blocked].focus = focus;
                cursor.playBlocked = blocked;
                cursor.playIndex = focus ;
                cursor.call('show');
                cursor.call('lazyShow');
            }
            cursor.call('prepareVideo');
        },
        prepareVideo : function(){
            var blocked = cursor.playBlocked;
            var focus = cursor.focusable[blocked].focus;
            cursor.playIndex = focus;
            var item = cursor.focusable[blocked].items[ cursor.playIndex ];
            var pos = [];
            if (blocked == 1){
                pos = [509,322,630,220];
            } else if (blocked == 2){
                pos = [590,373,330,182];
            }
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
                callback:function(){
                }
            });
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
            if( items.length <= 0 ) return;
            $("title").style.backgroundImage = "url(images/J"+titlePic+"Title"+blocked+".png)";
            scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
            if(blocked == 1){
                $("focus0").style.visibility = "visible";
                $("scrollLower").style.visibility = "visible";
                $("list").style.visibility = "visible";
                $("scrollUpper").style.visibility = "visible";
                $("listName"+String(listBox.focusPos)).style.color = "#<%=fc %>";
                var bc = "<%=bc %>";
                if( bc == "transparent"){
                    $("listName"+String(listBox.focusPos)).style.backgroundColor = "<%=bc %>";
                }else {
                    $("listName"+String(listBox.focusPos)).style.backgroundColor = "#<%=bc %>";
                }
                if (!<%= isEmpty(focusPic)%>) {
                    $("focus0").style.top =String(listBox.focusPos*(<%=ih + mr %>)+<%=focusTop %>)+"px";
                    $("focus0").style.visibility = "visible";
                }
                cursor.call('lazyShow');
            }else {
                $("focus0").style.visibility = "hidden";
                $("scrollLower").style.visibility = "hidden";
                $("list").style.visibility = "hidden";
                $("scrollUpper").style.visibility = "hidden";
            }
            <%--$("bg").style.backgroundImage = "url(<%=picture[blocked]%>)";--%>
            $("bg").style.backgroundImage = "url("+bgImgs[blocked]+")";

        },
        loseFocus:function() {
            var blocked = cursor.blocked;
            if (blocked == 1) {
                $("listName" + String(listBox.focusPos)).style.color = "#<%=cl %>";
                var bg = "<%=bg %>";
                if (bg == "transparent") {
                    $("listName" + String(listBox.focusPos)).style.backgroundColor = "<%=bg %>";
                } else {
                    $("listName" + String(listBox.focusPos)).style.backgroundColor = "#<%=bg %>";
                }
            $("listName" + String(listBox.focusPos)).innerText = getStrChineseLength(listData[listBox.position].name) > maxTitleLen ? subStr(listData[listBox.position].name, maxTitleLen, "...") : listData[listBox.position].name;
        }
        }
    });
    function initList() {
        var blocked = 1;
        var focus = cursor.focusable[blocked].focus;
        listData = cursor.focusable[blocked].items;
        var pageCount = <%= pg %>;
        listBox = new showList(pageCount, listData.length, focus, 127, window);
        if (scrollFlag == 1){
            listBox.showType = 1;
        } else {
            listBox.showType = 0;
        }
        listBox.haveData = function (List) {
            $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
            if (<%= isEmpty(focusPic)%>) {
                var bg = "<%=bg %>";
                if( bg == "transparent"){
                    $("listName"+String(List.idPos)).style.backgroundColor = "<%=bg %>";
                }else {
                    $("listName"+String(List.idPos)).style.backgroundColor = "#<%=bg %>";
                }
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
</html>