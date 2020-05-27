<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000111829";
    List<Column> list = inner.getList(typeId,3,1, new Column());
    for( Column col : list) infos.add(new ColumnInfo(col.getId(), 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:#F0A55B none no-repeat;background-position: 0px 0px;}
        .column{width:158px;height:235px;left:170px;top:267px;background:transparent url('images/mask-2019-05-29.png') no-repeat;background-position: 0px -200px; position:absolute;}

        .mask1{width:188px;height:49px;left:156px;position:absolute;background:transparent url('images/mask-2019-05-29.png') no-repeat;background-position: 0px 0px;}
        .mask11{top:260px;background-position:-300px -300px;}
        .mask12{top:357px;background-position:-300px -300px;}
        .mask13{top:458px;background-position:-300px -300px;}


        .after {width:500px;height:536px; left:488px;top:170px; position:absolute;overflow: hidden;}
        .item {width:500px;height:61px;float: left; position: relative;overflow: hidden;}
        .text {width:478px;height:61px;position:absolute;left:11px;top:0px; color:black;font-size:22px;line-height:60px; overflow: hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}

        .focus {width:508px;height:66px;left:488px;background-position: 0px 0px;}
        .focus .text{line-height: 63px;color: white;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-05-29-List.jpg') no-repeat;" onUnload="exit();">
<div id="colFocus"></div>
<div id="column" class="column"></div>
<div id="after" class="after"></div>
<div id="mask"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = inner.resultToString(new Result( typeId, list)) + ",\n";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('show');
            cursor.call('showMajor', true);
            cursor.call('lazyShow');
        },
        lazyShow : function(){
            var blocked = cursor.focusable[0].focus + 1;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            cursor.calcStringPixels(text, 22, function(width){
                if( cursor.blocked == blocked && width <= 478 ) return;
                $('mask').innerHTML = '<div class="text"><marquee scrollamount="8">' + text + '</marquee><div>';
            });
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( index == -1 && blocked == 0 || index == 1 && blocked != 0 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) return;
            if( index == 1 || index == -1) {
                blocked = index == -1 ? 0 : ( focus + 1 );
                focus = cursor.focusable[blocked].focus;
            } else {
                focus += index > 0 ? -1 : 1;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.moveTimer = undefined;cursor.call('lazyShow');}, 1300);
            if( blocked == 0 ) cursor.call('showMajor');
            cursor.call('show');
        },
        showMajor : function(init){
            return;
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            var blocked = cursor.blocked;

            $("colFocus").className = 'mask1 mask1' + String( focus + 1);
            $("mask").style.visibility = blocked == 0 ? 'hidden' : 'visible';

            blocked = focus + 1;
            focus = cursor.focusable[blocked].focus;
            var pageCount = 7;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '<div class="container">';
            var items = cursor.focusable[blocked].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item" id="item' + String( i + 1) + '"><div class="text">' + item.name + '</div></div>';
            }
            html += '</div>';
            $("after").innerHTML = html;
            if( blocked == cursor.blocked ) {
                $("mask").className = 'mask focus';
                $("mask").style.top = String( 169 + focus % pageCount * 61) + 'px';
                $("mask").innerHTML = '<div class="text">' + items[focus].name + '<div>';
            }
        },
        select : function(){
            var blocked = cursor.blocked;
            if( blocked == 0 ) return;
            cursor.call("selectAct");
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>