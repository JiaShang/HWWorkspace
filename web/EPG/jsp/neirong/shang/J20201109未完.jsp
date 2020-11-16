<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114365";

    Column column = new Column();
    List<Column> columns = inner.getList(typeId, 6, 0, column);
    for( Column col : columns ) {
        infos.add(new ColumnInfo(col.getId(), 0, 99));
    }

    Result result = new Result( typeId, columns );
    //获取当前栏目的详细信息
    column = inner.getDetail(typeId,column);
    String picture = "images/J20200318Bg.png";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }
    picture = "images/J20201109Bg.jpg";
    String[] sc = {};
    String[] title = {};
    String[] titlePic = {};
    String[] list = {};
    String[] focusPic = {};

///EPG/jsp/neirong/shang/J20201109.jsp?typeId=10000100000000090000000000119520&title=80,215,200,500,90,30,d51e22,d51e22,4,4,0,1&list=235,230,300,300,48,24,000000,000000,7,13,1&titlePic=786,89,315,84,48,20201109,1,1&focusPic=215,227,350,84,48,20201109,1&sc=492,249,343,000000,e1221d,1,1,0&video=725,412,565,178
    Integer direct = null, w = null, h = null, ih = null, fs = null, lt = null,tp = null, pg = null, mr = null,focusLeft = null, focusTop = null,titleLeft = null, titleTop = null,titleStep = null, cat = null,maxTitleLen = null;
    String cl = null, bc = null,fc = null,bg=null,al=null,hm = null;
//    List<List<Vod>> list = null;

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
    title = isEmpty( inner.get( "title" )) ? new String[0] : inner.get("title").split("\\,");
    titlePic = isEmpty( inner.get( "titlePic" )) ? new String[0] : inner.get("titlePic").split("\\,");
    list = isEmpty( inner.get( "list" )) ? new String[0] : inner.get("list").split("\\,");
    focusPic = isEmpty( inner.get( "focusPic" )) ? new String[0] : inner.get("focusPic").split("\\,");
//    blocked = !isNumber( inner.get("blocked") ) ? 2 : Integer.valueOf(inner.get("blocked"));
    cat = !isNumber( inner.get("cat") ) ? 0 : Integer.valueOf(inner.get("cat"));
    String video = inner.get("video","");
%>
<html>
<head>
    <title><%=column == null ? "“双11” 我们玩真的！" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .container {width: 1280px;height:720px;left:0px;top:0px; position:absolute; background: transparent url("<%=picture%>") no-repeat left top;}

        #list{
            position: absolute;
            left: <%=list[0] %>px;
            top: <%=list[1] %>px;
            width: <%=list[2] %>px;
            height:<%= list[3] %>px;

        }
        .listName{
            width: <%=list[2] %>px;
            height: <%= list[4] %>px;
            line-height: <%= list[4] %>px;
            font-size:<%= list[5] %>px;
            color:#<%= list[6] %>;
            background-color: transparent;
            overflow: hidden;
            text-align: left;
        }
        #focus{
            position:absolute;
            overflow:hidden;
            left: <%= focusPic[0]%>px;
            top: <%= focusPic[1]%>px;
            width: <%= focusPic[2]%>px;
            height: <%= focusPic[3]%>px;
        }

        #titleFocus{
            position:absolute;
            overflow:hidden;
            left: <%= titlePic[0]%>px;
            top: <%= titlePic[1]%>px;
            width: <%= titlePic[2]%>px;
            height: <%= titlePic[3]%>px;
        }
        #titleList{
            position: absolute;
            left: <%=title[0] %>px;
            top: <%=title[1] %>px;
            width: <%=title[2] %>px;
            height:<%= title[3] %>px;

        }
        .titleName{
            width: <%=title[2] %>px;
            height: <%= title[4] %>px;
            line-height: <%= title[4] %>px;
            font-size:<%= title[5]%>px;
            color:  <%= title[6]%>;
            text-align: left;
            overflow:hidden;
            background-color: transparent;
            background-repeat: no-repeat;
        }
        .titleImg{
            visibility: hidden;
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div id="container" class="container"></div>
<div id="scrollLower" style="position: absolute;z-index: 1 ">
    <div id="scrollUpper" style="position: absolute;left: -2px; top: 0px; height: 70px;  width: 6px;z-index: 2;"></div>
</div>
<div id="titleFocus" style="background:transparent no-repeat;visibility: hidden;" ></div>
<div id="focus" style="background:transparent no-repeat;visibility: hidden;" ></div>
<div id="titleList" style="">
    <div id="title0" class="list" style="top: 15px;">
        <img id="titleImg0" class="titleImg"/>
        <div id="titleName0" class="titleName"></div>
    </div>
    <div id="title1" class="list" style="top: 60px;">
        <img id="titleImg1" class="titleImg"/>
        <div id="titleName1" class="titleName"></div>
    </div>
    <div id="title2" class="list" style="top: 105px;">
        <img id="titleImg2" class="titleImg"/>
        <div id="titleName2" class="titleName"></div>
    </div>
    <div id="title3" class="list" style="top: 153px;">
        <img id="titleImg3" class="titleImg"/>
        <div id="titleName3" class="titleName"></div>
    </div>
    <div id="title4" class="list" style="top: 197px;">
        <img id="titleImg4" class="titleImg"/>
        <div id="titleName4" class="titleName"></div>
    </div>
    <div id="title5" class="list" style="top: 248px;">
        <img id="titleImg5" class="titleImg"/>
        <div id="titleName5" class="titleName"></div>
    </div>
</div>
<div id="list" style="">
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
    var listColor = "#<%= list[6]%>";
    var listFsColor = "#<%= list[7]%>";
    var listePg =  <%= list[8]%>;
    var maxListLen = <%= list[9]%>;
    var ListDirect = <%= list[10]%>;

    var titleBox = null;
    var titleData = [];
    var titleColor = "#<%= title[6]%>";
    var titleFsColor = "#<%= title[7]%>";
    var titlePg = <%= title[8]%>;
    var maxTitleLen = <%= title[9]%>;
    var titleDirect = <%= title[10]%>;

    var focusFlag = <%=focusPic[6]  %>;
    var titleFlag = <%=focusPic[6]  %>;

    var isShowTitle = <%=title[11]  %>;


    var scrollFlag = <%= sc[5]%>;
    var scrollWay = <%= sc[6]%>;
    var scrollData = <%= sc[7]%>;

    var focusArea = 1;

    var initialize = {
        data        : [<%
                String html = "";

                html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"}) + ",\n";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    inner.special = true;
                    result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.listBlocked = typeof cursor.listBlocked == 'undefined' ? 1 : cursor.listBlocked;
            cursor.backUrl='<%= backUrl %>';
            <% if( !isEmpty(video) && video.split("\\,").length > 3 ){ %>
            cursor.moviePos = [<%=video%>];
            <% } %>
            totalBlocked = this.data.length;
            cursor.lastBlocked = cursor.blocked;
            cursor.playBlocked = cursor.blocked;
            titleData = this.data[0]["data"];
            for( var i = 1; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i-1] = {};
                cursor.focusable[i-1].typeId = o["id"];
                cursor.focusable[i-1].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                if (typeof o["data"] == 'undefined') {
                    cursor.focusable[i-1].items = [];
                }else {
                    cursor.focusable[i-1].items = o["data"];
                }
                if( <%=cat %> ) {
                    for (var j = 0; j < cursor.focusable[i-1].items.length; j++) {
                        var name = cursor.focusable[i-1].items[j].name;
                        var star = name.indexOf("：");  //不存在返回-1
                        star++;
                        var end = name.indexOf("（") <= 0 ? name.length : name.indexOf("（");
                        cursor.focusable[i-1].items[j].name = name.substring(star, end);  //substring取前不取后
                    }
                }
            }
            cursor.palyIndex = cursor.focusable[cursor.blocked].focus;
            setTimeout(function(){
                if (focusFlag==0){
                    $("focus").style.visibility = "hidden";
                }else if (focusFlag== 1) { //焦点框
                    $("focus").style.visibility = "visible";
                    $("focus").style.backgroundImage = "url(images/J<%=focusPic[5]%>Focus.png)";
                }

                if (titleFlag==2){  //显示文字，滑动背景
                    $("titleFocus").style.backgroundImage = "url(images/J<%=titlePic[5]%>Title.png)";
                }else if (titleFlag==1){  //替换背景
                    $("titleFocus").style.backgroundImage = "url(images/J<%=titlePic[5]%>Title"+cursor.blocked+".png)";
                }else if (titleFlag==0) {
                    $("titleFocus").style.visibility = "hidden";
                }

                if (isShowTitle == 1){
                    $("titleList").style.visibility = "visible";
                } else {
                    $("titleList").style.visibility = "hidden";
                }

            },150);
            if( typeof cursor.moviePos != 'undefined' ) {
                cursor.playIndex = cursor.focusable[cursor.blocked].focus;
                setTimeout(function(){cursor.call('prepareVideo');},150);
            }
            setTimeout(function(){cursor.call('initTitle');cursor.call('initList');},50);
            setTimeout(function(){ cursor.call('show');cursor.call('lazyShow');},50);
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            cursor.call('loseFocus');
            if(index == -11){  //下
                if(focusArea == 0){
                    if(titleBox.position < titleBox.dataSize-1){
                        titleBox.changeList(1);
                        cursor.blocked = titleBox.position+1;
                        cursor.listBlocked = titleBox.position+1;
                        cursor.call('initList');
                    }
                }else if(focusArea == 1){
                    if(listBox.position < listBox.dataSize-1){
                        listBox.changeList(1);
                    }
                }
            }else if(index == 11){  //上
                if(focusArea == 0) {
                    if (titleBox.position > 0) {
                        titleBox.changeList(-1);
                        cursor.blocked = titleBox.position+1;
                        cursor.listBlocked = titleBox.position+1;
                        cursor.call('initList');
                    }
                }else if (focusArea == 1) {
                    if (listBox.position > 0) {
                        listBox.changeList(-1);
                    }
                }
            }else if(index == 1) {  //右
                if (focusArea == 0) {
                    focusArea = 1;
                }
            }else if(index == -1) {  //左
                if (focusArea == 1) {
                    focusArea = 0;
                }
            }
            // cursor.focusable[0].focus = titleBox.position;
            cursor.focusable[titleBox.position].focus = listBox.position;
            cursor.call('show');
            cursor.call('lazyShow');
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            if(focusArea == 1){
                cursor.moveTimer = setTimeout(function(){
                    clearTimeout(cursor.moveTimer);
                    cursor.moveTimer = undefined;
                    var focus = cursor.focusable[cursor.blocked].focus;
                    if(cursor.blocked != cursor.playBlocked || cursor.playIndex != focus){
                        cursor.playIndex = focus ;
                        cursor.playBlocked = cursor.blocked;
                        cursor.call('prepareVideo');
                    }
                }, 800);
            }
        },
        lazyShow    :   function(){
            var blocked = cursor.listBlocked;
            var focus = cursor.focusable[blocked].focus;
            var id = "";
            var str = "";
            var txt = "";
            if( focusArea == 1 ) {
                str = "list";
                id = String(listBox.focusPos);
                txt = listData[listBox.position].name;
            }else if (focusArea == 0) {
                str = "title";
                id = String(titleBox.focusPos);
                txt = titleData[titleBox.position].name;
            }
            var text = $(str+'Name' + id).innerText;
            if ( text.indexOf("...") != -1 ) {
                $(str+'Name' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + txt + '</marquee>';
            }
        },
        nextVideo   :   function () {
            var blocked = cursor.playBlocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            cursor.call('loseFocus');
            if( focus == items.length-1 ){
                listBox.changeList(1-items.length);
            }else{
                listBox.changeList(1);
            }
            cursor.focusable[blocked].focus = listBox.position;
            cursor.playIndex = listBox.position ;
            cursor.call('show');
            cursor.call('lazyShow');
            cursor.call('prepareVideo');

        },
        prepareVideo : function(){
            var blocked = cursor.playBlocked;
            var focus = cursor.focusable[blocked].focus;
            var pos = cursor.moviePos;
            cursor.playIndex = focus;
            var item = cursor.focusable[blocked].items[ cursor.playIndex ];
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
                callback:function(){
                }
            });
        },
        initTitle      :   function(){
            titleBox = new showList(titlePg, titleData.length, cursor.blocked, 127, window);
            titleBox.showType = 0;
            titleBox.haveData = function (List) {
                $("titleName" + String(List.idPos)).innerText = getStrChineseLength(titleData[List.dataPos].name) > maxTitleLen?subStr(titleData[List.dataPos].name,maxTitleLen,"..."):titleData[List.dataPos].name;
            }
            titleBox.notData = function (List) {
                $("titleName" + List.idPos).innerText = "";
            };
            titleBox.startShow();
        },
        initList      :   function(){
            var blocked = cursor.listBlocked;
            var focus = cursor.focusable[blocked].focus;
            listData = cursor.focusable[blocked].items;
            listBox = new showList(listePg, listData.length, focus, 127, window);
            listBox.showType = 0;
            listBox.haveData = function (List) {
                $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxListLen,"..."):listData[List.dataPos].name;
            }
            listBox.notData = function (List) {
                $("listName" + List.idPos).innerText = "";
            };
            listBox.startShow();
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;

            <%--var  blocked = cursor.blocked;--%>
            <%--var items = cursor.focusable[blocked].items;--%>
            <%--var focus = cursor.focusable[blocked].focus;--%>
            <%--if( items.length <= 0 ) return;--%>
            <%--if (titleFlag == 1) {      //换背景图--%>
            <%--    $("title").style.backgroundImage = "url(images/J<%=titlePic[4]%>Title" + blocked + ".png)";--%>
            <%--}else if (titleFlag == 2){  //左右移动--%>
            <%--    $("title").style.left = String(<%= titlePic[0]%>+blocked*<%= titlePic[6]%>)+"px";--%>
            <%--    $("title").style.backgroundPosition = String(blocked*(-<%= titlePic[6]%>))+"px "+"0px";--%>
            <%--}else if (titleFlag == 3){  //上下移动--%>
            <%--    $("title").style.top = String(<%= titlePic[1]%>+blocked*<%= titlePic[6]%>)+"px";--%>
            <%--    $("title").style.backgroundPosition = "0px "+String(blocked*(-<%= titlePic[6]%>))+"px";--%>
            <%--}--%>
            <%--$("listName"+String(listBox.focusPos)).style.color = "#<%=fc %>";--%>
            <%--var bc = "<%=bc %>";--%>
            <%--if( bc == "transparent"){--%>
            <%--    $("listName"+String(listBox.focusPos)).style.backgroundColor = "<%=bc %>";--%>
            <%--}else {--%>
            <%--    $("listName"+String(listBox.focusPos)).style.backgroundColor = "#<%=bc %>";--%>
            <%--}--%>
            <%--var focusFlag = <%=focusPic[5]  %>;--%>
            <%--if (focusFlag) {--%>
            <%--    $("focus").style.top =String(listBox.focusPos*(<%=ih %>+<%=mr %>)+<%=focusPic[1] %>)+"px";--%>
            <%--}--%>
            <%--scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);--%>
            <%--cursor.call('lazyShow');--%>


            if( focusArea == 0 ){
                $("titleName"+String(titleBox.focusPos)).style.color = titleFsColor;
                $("listName"+String(listBox.focusPos)).style.color = listColor;
                $("focus").style.visibility = "hidden";
                $("titleFocus").style.visibility = "visible";
                $("titleFocus").style.top = String((listBox.focusPos)*<%=titlePic[4]%>+<%=title[1]%>)+"px";
            }else if( focusArea == 1 ){
                $("focus").style.top = String((listBox.focusPos)*<%=focusPic[4]%>+<%=focusPic[1]%>)+"px";
                $("focus").style.visibility = "visible";
                $("titleFocus").style.visibility = "hidden";
                $("titleName"+String(titleBox.focusPos)).style.color = titleColor;
                $("titleName"+String(titleBox.focusPos)).style.backgroundImage = "url(images/J20200318Title0.png)";
                $("listName"+String(listBox.focusPos)).style.color = listFsColor;
            }
        },
        loseFocus        :   function(){
            var items = cursor.focusable[titleBox.position+1].items;
            var focus = cursor.focusable[titleBox.position+1].focus;
            if( focusArea == 0 ){
                $("titleName"+String(titleBox.focusPos)).style.backgroundImage = "url(images/global_tm.gif)";
                $('listName' + String(listBox.focusPos)).innerText = getStrChineseLength(items[focus].name) > maxTitleLen?subStr(items[focus].name,maxTitleLen,"..."):items[focus].name;
                $("titleName"+String(titleBox.focusPos)).style.color = titleColor;
            }else if( focusArea == 1 ){
                $("titleName"+String(titleBox.focusPos)).style.color = listColor;
                $('listName' + String(listBox.focusPos)).innerText = getStrChineseLength(items[focus].name) > maxTitleLen?subStr(items[focus].name,maxListLen,"..."):items[focus].name;
                // $("titleName"+String(titleBox.focusPos)).style.backgroundImage = "url(images/J20200318Title0.png)";
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>