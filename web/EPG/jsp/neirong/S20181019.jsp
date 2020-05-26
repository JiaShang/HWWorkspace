<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 5));
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
        .mask {position:absolute;background:transparent url('images/mask-2018-10-19.png') no-repeat;background-position: 0px 0px;}
        .mask1 {width:225px;height:44px;left:452px;top:252px;background-position:0px 0px;}
        .mask2 {width:198px;height:40px;left:175px;top:553px;background-position:0px -50px;}
        .mask3 {width:167px;height:238px;left:456px;top:379px;background-position:0px -100px;}
        .mask4 {width:167px;height:238px;left:654px;top:379px;background-position:0px -100px;}
        .mask5 {width:167px;height:238px;left:852px;top:379px;background-position:0px -100px;}
        .mask6 {width:167px;height:238px;left:1047px;top:379px;background-position:0px -100px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-10-19.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
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
            var link = {'name':'报名','linkto':'/EPG/jsp/neirong/S20181019Vote.jsp'};
            cursor.focusable[0].items.insertAt(1,link);

            cursor.call('show');
        },
        move        :   function(index){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            if( index == -1 && focus <= 1 || index == 1 && ( focus == 0 || focus + 1 >= items.length ) || index == 11 && focus == 0 || index == -11 && focus >= 1 ) return;

            if( index == 1 || index == -1 ) {
                focus += index;
            } else if( index == 11 ) {
                focus = 0;
            } else {
                focus = 2;
            }
            cursor.focusable[0].focus = focus;
            cursor.call('show');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            $("mask").className = 'mask mask' + String( focus + 1);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>