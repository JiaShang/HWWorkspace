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
//    picture = "images/J20200225Bg.png";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }
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
            width: 600px;
            height: 280px;
            left:225px;
            top: 230px;
            background:transparent;
            font-size: 24px;
            color: #ffffff;
            line-height: 38px;
        }
        .listName{
            position: absolute;
            width: 470px;
            height: 38px;
            overflow:hidden;
        }
        #title{
            position: absolute;
            width: 600px;
            height: 280px;
            left:50px;
            top: 198px;
            background:transparent;
            font-size: 24px;
            color: #ffffff;
            line-height: 51px;
            text-align: center;
        }
        .titleName{
            position: absolute;
            width: 139px;
            height: 51px;
            overflow:hidden;
            background-repeat: no-repeat;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div id="container" class="container"></div>
<div id="focus0" style="position: absolute;width: 522px;height: 51px;left: 198px;top:230px;background:transparent url('images/J20200318Focus0.png') no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="focus1" style="position: absolute;width: 499px;height: 167px;left: 738px;top: 492px;background:transparent url('images/J20200318Focus1.png') no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="title">
    <div id="titleName0" class="titleName" style="top: 10px;"></div>
    <div id="titleName1" class="titleName" style="top: 106px;"></div>
    <div id="titleName2" class="titleName" style="top: 202px;"></div>
    <div id="titleName3" class="titleName" style="top: 298px;"></div>
    <div id="titleName4" class="titleName" style="top: 394px;"></div>
</div>
<div id="list">
    <div id="listName0" class="listName" style="top: 10px;"></div>
    <div id="listName1" class="listName" style="top: 58px;"></div>
    <div id="listName2" class="listName" style="top: 106px;"></div>
    <div id="listName3" class="listName" style="top: 155px;"></div>
    <div id="listName4" class="listName" style="top: 205px;"></div>
    <div id="listName5" class="listName" style="top: 256px;"></div>
    <div id="listName6" class="listName" style="top: 307px;"></div>
    <div id="listName7" class="listName" style="top: 356px;"></div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var titleBox = null;
    var titleData = [];
    var focusArea = 1;
    var maxTitleLen = 19;
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.listBlocked = typeof cursor.listBlocked == 'undefined' ? 1 : cursor.listBlocked;
            cursor.backUrl='<%= backUrl %>';
            cursor.lastBlocked = 1;
            cursor.playBlocked = 1;
            cursor.playIndex = 0;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
                for( var j = 0; j < cursor.focusable[i].items.length; j ++){
                    var name = cursor.focusable[i].items[j].name;
                    var star = name.indexOf("：");  //不存在返回-1
                    star++;
                    var end = name.indexOf("（") <=0 ? name.length : name.indexOf("（");
                    cursor.focusable[i].items[j].name = name.substring(0,end);  //substring取前不取后
                }
            }
            setTimeout(function(){cursor.call('initTitle');cursor.call('initList');},50);
            setTimeout(function(){ cursor.call('show');cursor.call('lazyShow');},50);
            setTimeout(function(){ cursor.call('prepareVideo');},50);
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            cursor.call('loseFocus');
            if(index == -11){  //下
                if(focusArea == 0){
                    if(titleBox.focusPos < 4 && titleBox.position < titleBox.dataSize-1){
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
                }else if (focusArea == 1){
                    cursor.blocked = 6;
                    focusArea = 2;
                }
            }else if(index == -1) {  //左
                if (focusArea == 2 ) {
                    cursor.blocked = titleBox.position+1;
                    focusArea = 1;
                }else if (focusArea == 1) {
                    focusArea = 0;
                }
            }
            cursor.focusable[0].focus = titleBox.position;
            cursor.focusable[titleBox.position+1].focus = listBox.position;
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
            if( focusArea == 1 ) {
                var id = String(listBox.focusPos);
                var text = $('listName' + id).innerText;
                if ( text.indexOf("...") != -1 ) {
                    $('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + cursor.focusable[blocked].items[focus].name + '</marquee>';
                }
            };
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
            cursor.playIndex = focus;
            var item = cursor.focusable[blocked].items[ cursor.playIndex ];
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:489,height:278,left:741,top:201},
                callback:function(){
                }
            });
        },
        initTitle      :   function(){
            var focus = cursor.focusable[0].focus;
            titleData = cursor.focusable[0].items;
            var titleCount = 5;
            titleBox = new showList(titleCount, titleData.length, focus, 127, window);
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
            var listCount = 8;
            listBox = new showList(listCount, listData.length, focus, 127, window);
            listBox.showType = 0;
            listBox.haveData = function (List) {
                $("listName" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
            }
            listBox.notData = function (List) {
                $("listName" + List.idPos).innerText = "";
            };
            listBox.startShow();
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( focusArea == 0 ){
                $("titleName"+String(titleBox.focusPos)).style.color = "#4c3315";
                $("focus1").style.visibility = "hidden";
                $("focus0").style.visibility = "hidden";
                $("titleName"+String(titleBox.focusPos)).style.backgroundImage = "url(images/J20200318Title1.png)";
            }else if( focusArea == 1 ){
                $("focus0").style.top = String((listBox.focusPos)*50+230)+"px";
                $("focus0").style.visibility = "visible";
                $("focus1").style.visibility = "hidden";
                $("titleName"+String(titleBox.focusPos)).style.color = "#4c3315";
                $("titleName"+String(titleBox.focusPos)).style.backgroundImage = "url(images/J20200318Title0.png)";
            }else {
                $("focus0").style.visibility = "hidden";
                $("focus1").style.visibility = "visible";
                $("titleName"+String(titleBox.focusPos)).style.color = "#4c3315";
                $("titleName"+String(titleBox.focusPos)).style.backgroundImage = "url(images/J20200318Title0.png)";

            }
        },
        loseFocus        :   function(){
            var items = cursor.focusable[titleBox.position+1].items;
            var focus = cursor.focusable[titleBox.position+1].focus;
            if( focusArea == 0 ){
                $("titleName"+String(titleBox.focusPos)).style.backgroundImage = "url(images/global_tm.gif)";
                $("titleName"+String(titleBox.focusPos)).style.color = "#ffffff";
            }else if( focusArea == 1 ){
                $('listName' + String(listBox.focusPos)).innerText = getStrChineseLength(items[focus].name) > maxTitleLen?subStr(items[focus].name,maxTitleLen,"..."):items[focus].name;
                $("titleName"+String(titleBox.focusPos)).style.backgroundImage = "url(images/J20200318Title0.png)";
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>