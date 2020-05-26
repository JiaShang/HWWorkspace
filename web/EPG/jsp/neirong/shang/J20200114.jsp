<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113761";
    infos.add(new ColumnInfo(typeId, 0, 10));
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
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div id="mask" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var bgImgs = [];
    var initialize = {
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            cursor.call('show');
            cursor.call('playMovie');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var row = 5, column = 2;
            if( index == 11 && focus < column || index == -1 && focus % column == 0 || index == 1 && (focus % column == column - 1 || focus + 1 >= items.length ) || index == -11 && ( focus + column >= items.length && Math.ceil( (focus + 1.0) / column) == Math.ceil( items.length * 1.0 / column) ) ) return;
            if( index == 1 || index == -1 ) {
                focus += index;
            } else if( index == 11 ){
                focus -= column;
            } else {
                focus += column;
                if( focus > items.length ) focus = items.length - 1;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.call('playMovie');}, 1800);
            cursor.call('show');
        },
        playMovie   :   function(){
            player.exit();
            var item = cursor.focusable[0].items[cursor.focusable[0].focus];
            player.play({
                position:{width:455,height:304,left:571,top:339},
                vodId : item.id,
            })
        },
        nextVideo   :   function () {
            cursor.call('playMovie');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            var poster = cursor.focusable[0].items[focus].posters['7'][0];
            $("mask").style.backgroundImage = "url("+poster+")";
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>