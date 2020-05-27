<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114182";

    Column column = new Column();
    List<Column> columns = inner.getList(typeId, 4, 0, column);
    for( Column col : columns ) {
        infos.add(new ColumnInfo(col.getId(), 0, 6));
    }
    Result result = new Result( typeId, columns );
    //获取当前栏目的详细信息
    column = inner.getDetail(typeId,column);
    String picture = "";
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
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div id="container" class="container"></div>
<div id="focus0" style="position: absolute;width: 477px;height: 48px;left: 725px;top:290px;background:transparent no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="focus1" style="position: absolute;width: 370px;height: 151px;left: 73px;top: 513px;background:transparent url('images/J20200225Focus.png') no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="list" style="position: absolute;width: 600px;height: 280px;left: 655px;top: 237px;background:transparent; font-size: 24px;color: #000000;line-height: 38px;">
    <div id="list0" style="position: absolute;width: 502px;height: 38px;top: 10px;overflow:hidden;"></div>
    <div id="list1" style="position: absolute;width: 502px;height: 38px;top: 58px;overflow:hidden;"></div>
    <div id="list2" style="position: absolute;width: 502px;height: 38px;top: 106px;overflow:hidden;"></div>
    <div id="list3" style="position: absolute;width: 502px;height: 38px;top: 155px;overflow:hidden;"></div>
    <div id="list4" style="position: absolute;width: 502px;height: 38px;top: 203px;overflow:hidden;"></div>
    <div id="list5" style="position: absolute;width: 502px;height: 38px;top: 250px;overflow:hidden;"></div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var maxTitleLen = 22;
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.lastBlocked = 1;
            // cursor.lastBlocked1 = cursor.blocked > 0 ? cursor.blocked : 1;
            cursor.playBlocked = 0;
            cursor.playIndex = 1;
            var o = this.data[1];
            cursor.focusable[0] = {};
            cursor.focusable[0].typeId = o["id"];
            cursor.focusable[0].items = o["data"];
            cursor.focusable[0].focus = this.focused.length > 1 ? Number( this.focused[1]) : 0;

            for( var i = 1; i < 4; i++) {
                cursor.focusable[i] = {};
                cursor.focusable[i].focus = this.focused.length > i+1 ? Number(this.focused[i+1]) : 0;
                // if(i == 1){
                cursor.focusable[i].items = [];
                cursor.focusable[i].items[0] = {
                    'name': '底部入口',
                    'linkto': '/EPG/jsp/neirong/shang/J20200225List.jsp?typeId=' + this.data[i]["id"] +'&lft=220&tp=230&w=312&ih=50&mr=5&fs=24&hm=1&pg=7&fs=22&ftop=0&fleft=3&fc=ffffff&bc=2e8d86&cl=000000&sc=1,470,000000,2e8d86'
                    }
                    // }else {
                    //     cursor.focusable[i].items[0] = {
                    //         'name':'底部入口',
                    //         'linkto':'/EPG/jsp/neirong/shang/J20200106List.jsp?typeId=' + cursor.focusable[i].typeId + '&blocked=' + i
                    //     }
                    // }
            }
            setTimeout(function(){cursor.call('initList');},50);
            setTimeout(function(){ cursor.call('show');cursor.call('lazyShow');},50);
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
                }
            }else if(index == -1) {  //左
                if (blocked > 1 ) {
                    blocked--;
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
            if( blocked <= 0 && focus > 0 ) {
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String(focus);
            cursor.calcStringPixels(text, 24, function(width){
                if( width <= 482 ) return;
                $('list' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
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
                position:{width:517,height:318,left:78,top:185},
                callback:function(){
                }
            });
        },
        initList      :   function(){
            var blocked = 0;
            var items = cursor.focusable[blocked].items;
            if(items.length < 1)return;
            for( var i = 0; i < 5 && i < items.length-1; i++){
                $('list' + i).innerText = getStrChineseLength(items[i+1].name) > maxTitleLen?subStr(items[i+1].name,maxTitleLen,"..."):items[i+1].name;
            }
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus0 = cursor.focusable[0].focus;
            if( blocked <= 0){
                $("list"+String(focus0)).style.backgroundColor = "#2e8d86";
                $("list"+String(focus0)).style.color = "#ffffff";
                $("focus1").style.visibility = "hidden";
            }else{

                $("focus1").style.left = String((blocked-1)*387+73)+"px";
                $("focus1").style.visibility = "visible";
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
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>