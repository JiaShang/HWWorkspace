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
    ct:多少列;每行显示条目个数，默认为５个;
    row:多少行，pageCount 显示结果为 row * ct
    pg:页面显示内容条数
    hm:是否显示首页，0:默认为空值，显示首页按钮，1:只要有任何值均不显示首页按钮
    sc:滚动条样式left,top,heihgt,bgColor,fcColor
    video:视频窗位置，width,height,left,top,
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000115223";
    Integer blocked = null;
    blocked = isNumber( inner.get("blocked") ) ? 1 : Integer.valueOf(inner.get("blocked"));
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
    String picture = column == null ? "" : inner.pictureUrl("images/J20191226_2Bg.png",column.getPosters(),"7");
    String[] scLower = {"100","350","5","400","d8d6d6"}; //left,top,width,height,底部颜色，上层颜色，文字颜色
    String[] scUpper = {"100","350","25","-12","68c2e5","ffffff","1","1","0"}; //left,top,width,height,上层颜色,文字颜色,是否显示,显示类型,是否显示数字
    String[] sc = {"1","1","0"}; //是否显示,显示类型,是否显示数字
    String[] titlePic = {"100","100","100","100","20200414","0"};
    String[] focusPic =  {"100","100","100","100","20200414","0"};
    String[] video =  {"100","100","100","100","0"};
    String[] listName=  {"100","100","100","60","5","5","24","transparent","000000","ccc000","ffffff"}; // left,top.width,height,@left,@top,字体大小,背景色,文字色,焦点背景色,焦点文字色
    String[] listImg=  {"100","100","100","60","5","5","ccc000","ffffff"};// left,top,@left,@top,背景色,焦点背景色
    String[] list=  {"100","100","100","100","1","5"}; // left,top,@left,@top,列,行

//    if (!isEmpty( inner.get("sc"))){
//        sc =inner.get("sc").split("\\,");
//    }
//    if (!isEmpty( inner.get("titlePic"))){
//        titlePic =inner.get("titlePic").split("\\,");
//    }
//    if (!isEmpty( inner.get("focusPic"))){
//        focusPic =inner.get("focusPic").split("\\,");
//    }
//    if (!isEmpty( inner.get("video"))){
//        video =inner.get("video").split("\\,");
//    }
//    if (!isEmpty( inner.get("listName"))){
//        listName =inner.get("listName").split("\\,");
//    }
//    if (!isEmpty( inner.get("listImg"))){
//        listImg =inner.get("listImg").split("\\,");
//    }
//    if (!isEmpty( inner.get("list"))){
//        list =inner.get("list").split("\\,");
//    }
//
//    sc = isEmpty( inner.get("sc") ) ? sc : inner.get("sc").split("\\,");
//    titlePic = isEmpty( inner.get("titlePic") ) ? titlePic : inner.get("titlePic").split("\\,");
//    focusPic = isEmpty( inner.get("focusPic") ) ? focusPic : inner.get("focusPic").split("\\,");
//    video = isEmpty( inner.get("video") ) ? video : inner.get("video").split("\\,");
//    listName = isEmpty( inner.get("listName") ) ? listName : inner.get("listName").split("\\,");
//    listImg = isEmpty( inner.get("listImg") ) ? listImg : inner.get("listImg").split("\\,");
//    list = isEmpty( inner.get("list") ) ? list : inner.get("list").split("\\,");
    Integer cat = null,maxTitleLen = null;
    cat = !isNumber( inner.get("cat") ) ? 1 : Integer.valueOf(inner.get("cat"));
    maxTitleLen = !isNumber( inner.get("maxTitleLen") ) ? 17 : Integer.valueOf(inner.get("maxTitleLen"));
//    Integer tp = null,w = null, h = null, ih = null, fs = null, lt = null, pg = null, mr = null,focusLeft = null, focusTop = null,titleLeft = null, titleTop = null,titleStep = null, cat = null,maxTitleLen = null, ct = null,row = null;
//    String cl = null, bc = null,fc = null,bg=null,al=null,hm = null;
////    List<List<Vod>> list = null;
//
//    w = !isNumber( inner.get("w") ) ? 237 : Integer.valueOf(inner.get("w"));
//    h = !isNumber( inner.get("h") ) ? 73 : Integer.valueOf(inner.get("h"));
//    ih = !isNumber( inner.get("ih") ) ? 40 : Integer.valueOf(inner.get("ih"));
//    fs = !isNumber( inner.get("fs") ) ? 22 : Integer.valueOf(inner.get("fs"));
//    mr = !isNumber( inner.get("mr") ) ? 8 : Integer.valueOf(inner.get("mr"));
//    ct = !isNumber( inner.get("ct") ) ? 5 : Integer.valueOf(inner.get("ct"));
//    row = !isNumber( inner.get("row") ) ? 1 : Integer.valueOf(inner.get("row"));
//
//    lt = isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : ( isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : 73 );
//    tp = !isNumber( inner.get("tp") ) ? 353 : Integer.valueOf(inner.get("tp"));
//    cl = isEmpty( inner.get("cl") ) ? "ffffff" : inner.get("cl");
//    fc = isEmpty( inner.get("fc") ) ? "ffffff" : inner.get("fc");
//    bc = isEmpty( inner.get("bc") ) ? "transparent" : inner.get("bc");
//    bg = isEmpty( inner.get("bg") ) ? "transparent" : inner.get("bg");
//    al = isEmpty( inner.get("al") ) ? "0" : inner.get("al");
//    sc = isEmpty( inner.get( "sc" )) ? new String[0] : inner.get("sc").split("\\,");
//    titlePic = isEmpty( inner.get( "titlePic" )) ? new String[0] : inner.get("titlePic").split("\\,");
//    focusPic = isEmpty( inner.get( "focusPic" )) ? new String[0] : inner.get("focusPic").split("\\,");



//    if( al.equalsIgnoreCase("0")) al = "left";
//    else if( al.equalsIgnoreCase("1")) al = "center";
//    else al="right";
//
//    h = pg * (ih + mr);

//    String video = inner.get("video","");

%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .list{
            position: absolute;
            left: <%=list[0]%>;
            top: <%=list[1]%>;
            width:900px;
            height: 600px;
        }
        .listName{
            position: absolute;
            width: <%=listName[2] %>px;
            height: <%=listName[3] %>px;
            color:#<%=listName[8]%>;
            font-size:<%=listName[6] %>px;
            background-color: transparent;
            overflow: hidden;
            text-align: left;
            line-height: <%=listName[3] %>px;
            padding: 10px;
        }
        #scrollLower{
            position:absolute;
            left: <%= scLower[0]%>px;
            top: <%= scLower[1]%>px;
            height: <%= scLower[3]%>px;
            width: <%= scLower[2]%>px;
            background-color:#<%= sc[4]%>;
        }
        #scrollUpper {
            position:absolute;
            left: <%= scUpper[0]%>px;
            top: <%= scUpper[1]%>px;
            height: <%= scUpper[3]%>px;
            width: <%= scUpper[2]%>px;
            background-color:#<%= scUpper[4]%>;
            color:#<%= scUpper[5]%>;
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
    var maxTitleLen = <%= Integer.valueOf(maxTitleLen)%>;
    var scrollFlag = <%= Integer.valueOf(sc[0])%>;
    var scrollWay = <%= Integer.valueOf(sc[1])%>;
    var scrollData = <%= Integer.valueOf(sc[2])%>;
    var totalBlocked = 1;
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
        cursor.focusPos = 0;
        totalBlocked = this.data.length;
        for( var i = 0; i < this.data.length; i ++){
            var o = this.data[i];
            cursor.focusable[i] = {};
            cursor.focusable[i].typeId = o["id"];
            cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
            cursor.focusable[i].items = o["data"];
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
        cursor.palyBlocked = cursor.blocked;
        cursor.palyIndex = cursor.focusable[cursor.blocked].focus;
        setTimeout(function(){
            initList();
            var focusFlag = <%=Integer.valueOf(focusPic[5])  %>;
            if (focusFlag==0){
                $("focus").style.visibility = "hidden";
            }else {
                $("focus").style.visibility = "visible";
                $("focus").style.backgroundImage = "url(images/J<%=focusPic[4]%>Focus.png)";
            }
            var titleFlag = <%=Integer.valueOf(titlePic[5])  %>;
            if (titleFlag==0){
                $("title").style.visibility = "hidden";
            }else {
                $("title").style.visibility = "visible";
                $("title").style.backgroundImage = " url(images/J<%=titlePic[4]%>Title0.png)";
            }

            cursor.call('show');
        },150);
        var videoFlag = <%=Integer.valueOf(video[4]) %>;
        if( videoFlag !=0  ){
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
        player.exit();
        player.play({
            vodId:item.id,
            position:{width: <%=Integer.valueOf(video[0]) %>,height: <%=Integer.valueOf(video[1]) %>,left: <%=Integer.valueOf(video[2]) %>,top: <%=Integer.valueOf(video[3]) %>},
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
            var ct = <%=Integer.valueOf(list[4])%>;
            var row = <%=Integer.valueOf(list[5])%>;
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
            }else if(index == 1  && listBox.focusPos < ct*(row-1)){

                if (listBox.position < listBox.dataSize -row-1 ){
                    cursor.call('loseFocus');
                    listBox.changeList(row);
                    cursor.call('show');
                } else if(Math.floor(listBox.position%row) != Math.floor((listBox.dataSize -1)%row)){
                    cursor.call('loseFocus');
                    listBox.changeList(listBox.dataSize -1-listBox.position);
                    cursor.call('show');
                }
            }else if(index == -1 && listBox.focusPos < row){
                cursor.call('loseFocus');
                listBox.changeList(-row);
                cursor.call('show');
            }
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                var videoFlag = <%=Integer.valueOf(video[4]) %>;
                if( videoFlag ==0 ){
                    return;
                } else{
                var focus = cursor.focusable[blocked].focus;
                if( cursor.palyBlocked != blocked || cursor.playIndex != focus ) {
                    cursor.playIndex = focus;
                    cursor.palyBlocked = blocked;
                    var item = cursor.focusable[blocked].items[focus];
                    cursor.call('playMovie', item);
                }
                }
            }, 1000);

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
            var titleFlag = <%=Integer.valueOf(titlePic[5])  %>;
            if (titleFlag == 1) {
                $("title").style.backgroundImage = "url(images/J<%=titlePic[4]%>Title" + blocked + ".png)";
            }
            $("listName"+String(listBox.focusPos)).style.color = "#<%=listName[10] %>";
            var bc = "<%=listName[9] %>";
            if( bc == "transparent"){
                $("listName"+String(listBox.focusPos)).style.backgroundColor = "<%=listName[9] %>";
            }else {
                $("listName"+String(listBox.focusPos)).style.backgroundColor = "#<%=listName[9] %>";
            }
            var focusFlag = <%=Integer.valueOf(focusPic[5])  %>;
            if (focusFlag) {
                $("focus").style.top =String(listBox.focusPos*(<%=Integer.valueOf(listName[3]) %>+<%=Integer.valueOf(listName[5]) %>)+<%=Integer.valueOf(focusPic[1]) %>)+"px";
            }
            scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
            cursor.call('lazyShow');

        },
        loseFocus:function(){
            $("listName"+String(listBox.focusPos)).style.color = "#<%=listName[8] %>";
            var bg = "<%=listName[7] %>";
            if( bg == "transparent"){
                $("listName"+String(listBox.focusPos)).style.backgroundColor = "<%=listName[7] %>";
            }else {
                $("listName"+String(listBox.focusPos)).style.backgroundColor = "#<%=listName[7] %>";
            }
            $("listName" + String(listBox.focusPos)).innerText = getStrChineseLength(listData[listBox.position].name) > maxTitleLen?subStr(listData[listBox.position].name,maxTitleLen,"..."):listData[listBox.position].name;
        }
    });
    function initList() {
        var blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        var ct = <%=Integer.valueOf(list[4])%>;
        var row = <%=Integer.valueOf(list[5])%>;
        listData = cursor.focusable[blocked].items;
        var pageCount = ct*row;
        listBox = new showList(pageCount, listData.length, focus, 127, window);
        if (scrollFlag == 1 && <%=blocked%> == 1){
            listBox.showType = 1;
        } else {
            listBox.showType = 0;
        }
        listBox.haveData = function (List) {
            $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
            var bg = "<%=listName[7] %>";
            if( bg == "transparent"){
                $("listName"+String(List.idPos)).style.backgroundColor = "<%=listName[7] %>";
            }else {
                $("listName"+String(List.idPos)).style.backgroundColor = "#<%=listName[7] %>";
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
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "url(images/J20200515Bg.png)" : (" url('" + picture + "')")%> no-repeat;"></div>
<div id="title" style="background:transparent no-repeat;visibility: hidden;" ></div>
<div id="focus" style="background:transparent no-repeat;visibility: hidden;" ></div>
<div id="scrollLower" style="position: absolute;z-index: 1 ">
    <div id="scrollUpper" style="position: absolute;left: -2px; top: 0px; height: 70px;  width: 6px;z-index: 2;"></div>
</div>
<div id="list">
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
    <div id="list8" class="list" style="top: 15px;">
        <img id="listImg8" class="listImg"/>
        <div id="listName8" class="listName"></div>
    </div>
    <div id="list9" class="list" style="top: 60px;">
        <img id="listImg9" class="listImg"/>
        <div id="listName9" class="listName"></div>
    </div>
    <div id="list10" class="list" style="top: 105px;">
        <img id="listImg10" class="listImg"/>
        <div id="listName10" class="listName"></div>
    </div>
    <div id="list11" class="list" style="top: 153px;">
        <img id="listImg11" class="listImg"/>
        <div id="listName11" class="listName"></div>
    </div>
    <div id="list12" class="list" style="top: 197px;">
        <img id="listImg12" class="listImg"/>
        <div id="listName12" class="listName"></div>
    </div>
    <div id="list13" class="list" style="top: 248px;">
        <img id="listImg13" class="listImg"/>
        <div id="listName13" class="listName"></div>
    </div>
    <div id="list14" class="list" style="top: 295px;">
        <img id="listImg14" class="listImg"/>
        <div id="listName14" class="listName"></div>
    </div>
    <div id="list15" class="list" style="top: 341px;">
        <img id="listImg15" class="listImg"/>
        <div id="listName15" class="listName"></div>
    </div>
</div>
</body>
</html>