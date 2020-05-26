<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113401";

    Column column = new Column();
    List<Column> columns = inner.getList(typeId, 6, 0, column);
    for( Column col : columns ) {
        infos.add(new ColumnInfo(col.getId(), 0, 5));
    }
    Result result = new Result( typeId, columns );
    //获取当前栏目的详细信息
    column = inner.getDetail(typeId,column);
    String picture = "images/J20191211Bg.png";
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
<div id="title" style="position: absolute;width: 585px;height: 49px;left: 622px;top: 182px;background:transparent no-repeat;overflow:hidden;"></div>
<div id="focus0" style="position: absolute;width: 548px;height: 39px;left: 635px;top:240px;background:transparent url('images/J20191211Focus0.png') no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="focus1" style="position: absolute;width: 398px;height: 167px;left: 56px;top: 499px;background:transparent url('images/J20191211Focus1.png') no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="list" style="position: absolute;width: 544px;height: 300px;left: 650px;top: 220px;background:transparent; font-size: 22px;">
    <div id="list0" style="position: absolute;width: 516px;height: 300px;top: 25px;"></div>
    <div id="list1" style="position: absolute;width: 516px;height: 300px;top: 70px;"></div>
    <div id="list2" style="position: absolute;width: 516px;height: 300px;top: 115px;"></div>
    <div id="list3" style="position: absolute;width: 516px;height: 300px;top: 160px;"></div>
    <div id="list4" style="position: absolute;width: 516px;height: 300px;top: 205px;"></div>
    <div id="list5" style="position: absolute;width: 516px;height: 300px;top: 250px; color: #366c94;text-align: center;">更多 ......</div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var maxTitleLen = 21;
    var initialize = {
        data        : [<%
                String html = "";
                html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"}) + ",\n";
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';
            cursor.lastBlocked0 = cursor.blocked > 3 ? 1 : cursor.blocked;
            cursor.lastBlocked1 = cursor.blocked > 3 ? cursor.blocked : 4;
            cursor.playBlocked = 1;
            cursor.playIndex = 0;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[i + 1]) : 0;
            }
            for( var i = 0; i < cursor.focusable.length; i++){
                var items = cursor.focusable[i].items;
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[i + 1]) : 0;
                if(i < 4 ){
                    cursor.focusable[i].items[5] = {
                        'name':'更多 ......',
                        'linkto':'/EPG/jsp/neirong/shang/J20191211List焦点框+8行.jsp?typeId=' + cursor.focusable[i].typeId
                    }
                }else{
                    cursor.focusable[i].items[0] = {
                        'name':'底部入口',
                        'linkto':'/EPG/jsp/neirong/shang/J20191211List焦点框+8行.jsp?typeId=' + cursor.focusable[i].typeId
                    }
                }
            }
            //alert("cursor.lastBlocked0=="+cursor.lastBlocked0+"cursor.lastBlocked1=="+cursor.lastBlocked1+"cursor.playBlocked=="+cursor.playBlocked+",,,cursor.playIndex==="+cursor.playIndex);
            setTimeout(function(){cursor.call('initList');},50);
            setTimeout(function(){ cursor.call('show');},50);
            setTimeout(function(){ cursor.call('lazyShow');},150);
            setTimeout(function(){ cursor.call('prepareVideo');},50);
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if(blocked > 0 && blocked < 4){
                $('list' + focus).innerHTML = getStrChineseLength(items[focus].name) > maxTitleLen?subStr(items[focus].name,maxTitleLen,"..."):items[focus].name;
                if(index == -11){
                    if(focus<5 && focus<items.length){
                        focus++;
                        cursor.focusable[blocked].focus = focus;
                    }else {
                        blocked = cursor.lastBlocked1;
                    }
                }else if(index == 11){
                    if(focus > 0){
                        focus--;
                        cursor.focusable[blocked].focus = focus;
                    }
                }else if(index == -1){
                    if(blocked > 1 && focus < 5){
                        blocked--;
                        cursor.lastBlocked0 = blocked;
                        cursor.call('initList');
                    }
                }else if(index == 1){
                    if(blocked < 3  && focus < 5 ){
                        blocked++;
                        cursor.lastBlocked0 = blocked;
                        cursor.call('initList');
                    }
                }
                if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
                cursor.moveTimer = setTimeout(function(){
                    clearTimeout(cursor.moveTimer);
                    cursor.moveTimer = undefined;
                    cursor.call('lazyShow');
                    if(focus !=5 && (cursor.playBlocked != blocked || cursor.playIndex != focus)){
                        cursor.playIndex = focus ;
                        cursor.playBlocked = blocked;
                        cursor.call('prepareVideo');
                    }
                }, 800);
            }else if(blocked>3 && blocked <=6){
                if(index == 11){
                    blocked = cursor.lastBlocked0;
                }else if (index == -1) {
                    if(blocked > 4){
                        blocked--;
                        cursor.lastBlocked1 = blocked;
                    }
                }else if (index == 1) {
                    if(blocked < 6){
                        blocked++;
                        cursor.lastBlocked1 = blocked;
                    }
                }
            }
            cursor.blocked = blocked;
            cursor.call('show');
        },
        lazyShow    :   function(){
            if( cursor.blocked > 0 && cursor.blocked < 4 ) {
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String(focus);
            cursor.calcStringPixels(text, 22, function(width){
                if( width <= 510 ) return;
                $('list' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
            };
        },
        nextVideo   :   function () {
            var blocked = cursor.lastBlocked0;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            $('list' + focus).innerHTML = getStrChineseLength(items[focus].name) > maxTitleLen?subStr(items[focus].name,maxTitleLen,"..."):items[focus].name;
            if( focus == items.length-1 || focus == 4 ){
                focus = 0;
            }else{
                focus++;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.playIndex = focus ;
            cursor.call('prepareVideo');
        },
        prepareVideo : function(){
            var blocked = cursor.lastBlocked0;
            var focus = cursor.focusable[blocked].focus;
            cursor.playIndex = focus == 5 ? 4 : focus;
            var item = cursor.focusable[blocked].items[ cursor.playIndex ];
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:520,height:321,left:75,top:183},
                callback:function(){
                    cursor.call('show');
                    cursor.call('lazyShow');
                }
            });
        },
        initList      :   function(){
            var blocked = cursor.lastBlocked0;
            for( var i = 0; i < 5; i++){
                var items = cursor.focusable[blocked].items;
                if(items.length <= 0)return;
                if(items.length < 5){
                    if(i <= items.length) {
                        $('list' + i).innerText = getStrChineseLength(items[i].name) > maxTitleLen?subStr(items[i].name,maxTitleLen,"..."):items[i].name;
                    }
                }else{
                    $('list' + i).innerText = getStrChineseLength(items[i].name) > maxTitleLen?subStr(items[i].name,maxTitleLen,"..."):items[i].name;
                }
            }
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus0 = cursor.focusable[cursor.lastBlocked0].focus;
            $("title").style.backgroundImage = "url(images/J20191211Title"+String(cursor.lastBlocked0-1)+".png)";
            if( 0 <= blocked && blocked < 4){
                $("focus0").style.top = String(focus0*45+240)+"px";
                $("focus0").style.visibility = "visible";
                $("focus1").style.visibility = "hidden";
            }else{
                $("focus0").style.visibility = "hidden";
                $("focus1").style.left = String((blocked-4)*387+56)+"px";
                $("focus1").style.visibility = "visible";
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>