<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000115581";


    Column[] subColumns = new Column[4];
    List<Column> columns = inner.getList(typeId, 4, 0 , new Column());//（id，查询数据条数，开始查询位置）
    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
        subColumns[i] = new Column();
        subColumns[i] = inner.getDetail(columns.get(i).id,subColumns[i]);

    }
    Result result = new Result( typeId, columns );
    //获取当前栏目的详细信息

    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = "images/J20200615Bg.png";
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
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div id="container" class="container"></div>
<div id="focus0" style="position: absolute;width: 410px;height: 42px;left: 550px;top:287px;background:transparent url('images/J20200615Focus.png') no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="focus1" style="position: absolute;width: 376px;height: 157px;left: 73px;top: 513px;background:transparent no-repeat;overflow:hidden;"></div>
<div id="focus2" style="position: absolute;width: 376px;height: 157px;left: 460px;top: 513px;background:transparent no-repeat;overflow:hidden;"></div>
<div id="focus3" style="position: absolute;width: 376px;height: 157px;left: 850px;top: 513px;background:transparent no-repeat;overflow:hidden;"></div>
<div id="list" style="position: absolute;width: 360px;height: 200px;left: 580px;top: 280px;background:transparent; font-size: 24px;color: #000000;line-height: 38px;">
    <div id="list0" style="position: absolute;width: 360px;height: 38px;top: 10px;overflow:hidden;"></div>
    <div id="list1" style="position: absolute;width: 360px;height: 38px;top: 47px;overflow:hidden;"></div>
    <div id="list2" style="position: absolute;width: 360px;height: 38px;top: 84px;overflow:hidden;"></div>
    <div id="list3" style="position: absolute;width: 360px;height: 38px;top: 120px;overflow:hidden;"></div>
    <div id="list4" style="position: absolute;width: 360px;height: 38px;top: 158px;overflow:hidden;"></div>
    <div id="list5" style="position: absolute;width: 360px;height: 38px;top: 200px;overflow:hidden;"></div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var maxTitleLen = 15;
    // var focusPics = [];
    var focusPics = [["images/J20200615Focus10.png","images/J20200615Focus11.png"],["images/J20200615Focus20.png","images/J20200615Focus21.png"],["images/J20200615Focus30.png","images/J20200615Focus31.png"]];
    var subColumns = [];
    var initialize = {
        data        : [<%
                String html = "";
//                html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"}) + ",\n";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.lastBlocked = 1;
            // cursor.lastBlocked1 = cursor.blocked > 0 ? cursor.blocked : 1;
            cursor.playBlocked = 0;
            cursor.playIndex = 0;
            for (var i = 0; i < this.data.length; i++) {
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                if (typeof o['data'] == 'undefined') {
                    cursor.focusable[i].items = [];
                }else {
                    cursor.focusable[i].items = o['data'];
                }
            }
            cursor.focusable[1].items[0] = {
                'name': '线路推荐',
                'linkto': '/EPG/jsp/neirong/shang/J20200615List1.jsp?typeId='+cursor.focusable[1].typeId+'&row=1&ct=3&wh=330&ht=219&ml=30&cl=ffffff&fc=dc6b19&bc=ecaa4b&cat=1&lft=60&tp=180&w=800&fs=24&hm=1&cl=725f51&sc=540,255,390,d1dde9,c88bad,0,1,0&maxTitleLen=14&blocked=3'
            }
            cursor.focusable[2].items[0] = {
                'name': '足迹活动',
                'linkto': "/EPG/jsp/neirong/shang/J20200427_2.jsp?typeId="+cursor.focusable[2].typeId+"&titlePic=50,190,500,80,20200422,0&focusPic=760,77,550,80,20200615List2,1&cl=000000&fc=000000&cat=1&lft=770&tp=73&w=420&ih=65&mr=0&fs=24&hm=1&pg=9&sc=1250,90,580,4d9bde,ecaa4b,1,1,0&video=614,347,68,263&maxTitleLen=18"
            }
            if(cursor.focusable[3].items.length == 0 || (typeof cursor.focusable[3].items[0].posters != 'undefined' && typeof cursor.focusable[3].items[0].posters['5'] != 'undefined')){
                cursor.focusable[3].items[0] = {
                    'name': '关于我们',
                    'linkto': '/EPG/jsp/neirong/shang/Jpicture.jsp?typeId='+cursor.focusable[3].typeId+'&direct=1'
                }
            }

            var j = 0;
            <%for (int i = 0 ;i <4; i++ ){%>
            subColumns[j] = <%= inner.writeObject(subColumns[i])%>;
            j++;
            <%}%>
            for (var i = 1;i <4; i++ ){
                <%--var column = <%= inner.writeObject(subColumns[j+1])%>;--%>
                if (typeof subColumns[i].posters !='undefined' && typeof subColumns[i].posters[3] !='undefined' && subColumns[i].posters[3].length > 0) {
                    focusPics[i-1] = subColumns[i].posters['3'];
                    if (subColumns[i].posters[3].length == 1) {
                        focusPics[i-1][1] = ["images/defaultImg.png"];
                    }
                }else {
                    focusPics[i-1] = ["images/defaultImg.png","images/defaultImg.png"];
                }
                $("focus"+String(i)).style.backgroundImage = "url("+focusPics[i-1][0]+")";
            }
            setTimeout(function(){cursor.call('initList');},50);
            setTimeout(function(){ cursor.call('show');cursor.call('prepareVideo');cursor.call('lazyShow');},50);
            // setTimeout(function(){ cursor.call('prepareVideo');},50);
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            cursor.call('loseFocus');
            if(index == -11){  //下
                if(blocked == 0){
                    if(focus<4 && focus<items.length-1){
                        focus++;
                        cursor.focusable[blocked].focus = focus;
                    }else {
                        blocked = cursor.lastBlocked;
                        cursor.lastBlocked = blocked;
                    }
                }

            }else if(index == 11){  //上
                if (blocked > 0) {
                    blocked = 0;
                }else if (blocked == 0){
                    if (focus > 0){
                        focus--;
                        cursor.focusable[blocked].focus = focus;
                    }
                }
            }else if(index == 1) {  //右
                if (blocked > 0 && blocked < 3) {
                    blocked++;
                    cursor.lastBlocked = blocked;
                }
            }else if(index == -1) {  //左
                if (blocked > 1 ) {
                    blocked--;
                    cursor.lastBlocked = blocked;
                }
            }
            cursor.blocked = blocked;
            cursor.call('show');
            cursor.call('lazyShow');
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                cursor.moveTimer = undefined;
                var focus = cursor.focusable[0].focus;
                if(cursor.blocked == 0 && cursor.playIndex != focus){
                    cursor.playIndex = focus ;
                    // cursor.playBlocked = blocked;
                    cursor.call('prepareVideo');
                }
            }, 800);
        },
        lazyShow    :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[0].focus;
            if( blocked <= 0 ) {
                var blocked = cursor.blocked;
                var focus = cursor.focusable[blocked].focus;
                var id = String( focus );
                var text = $('list' + id).innerText;
                if ( text.indexOf("...") != -1 ) {
                    $('list' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + cursor.focusable[blocked].items[focus].name + '</marquee>';
                }
            };
        },
        nextVideo   :   function () {
            var blocked = cursor.playBlocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            cursor.call('loseFocus');
            if( focus == items.length-1 || focus == 4 ){
                focus = 0;
            }else{
                focus++;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.playBlocked = blocked;
            cursor.playIndex = focus ;
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
                position:{width:480,height:271,left:52,top:235},
                callback:function(){
                }
            });
        },
        initList      :   function(){
            var blocked = 0;
            var items = cursor.focusable[blocked].items;
            if(items.length < 1)return;
            for( var i = 0; i < 5 && i < items.length; i++){
                $('list' + i).innerText = getStrChineseLength(items[i].name) > maxTitleLen?subStr(items[i].name,maxTitleLen,"..."):items[i].name;
            }
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus0 = cursor.focusable[0].focus;
            if( blocked <= 0){
                // $("list"+String(focus0)).style.backgroundColor = "#2e8d86";
                $("list"+String(focus0)).style.color = "#00000";
                $("focus0").style.visibility = "visible";
                $("focus0").style.top = String(focus0*37+287)+"px";
            }else{
                $("focus0").style.visibility = "hidden";
                $("focus"+String(blocked)).style.backgroundImage = "url("+focusPics[blocked-1][1]+")";
            }

        },
        loseFocus        :   function(){
            var blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[cursor.blocked].focus;
            if( blocked <= 0){
                $("list"+String(focus)).style.backgroundColor = "transparent";
                $("list"+String(focus)).style.color = "#000000";
                $('list' + String(focus)).innerText = getStrChineseLength(items[focus].name) > maxTitleLen?subStr(items[focus].name,maxTitleLen,"..."):items[focus].name;
            }else {
                $("focus"+String(blocked)).style.backgroundImage = "url("+focusPics[blocked-1][0]+")";
            }

        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>