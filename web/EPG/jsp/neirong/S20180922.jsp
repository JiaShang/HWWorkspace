<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 9));
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
        .mask {width:141px;height:191px;position:absolute;background:transparent url('images/mask-2018-09-22.png') no-repeat;background-position: 0px 0px;}
        .after{width:837px;height:365px;left:351px;top:230px;background-position: 0px 0px;}
        .mask1 {left:457px;top:221px;background-position:-900px 0px;}
        .mask2 {left:640px;top:221px;background-position:-900px 0px;}
        .mask3 {left:818px;top:221px;background-position:-900px 0px;}
        .mask4 {left:1001px;top:221px;background-position:-900px 0px;}
        .mask5 {left:339px;top:422px;background-position:-900px 0px;}
        .mask6 {left:521px;top:422px;background-position:-900px 0px;}
        .mask7 {left:702px;top:422px;background-position:-900px 0px;}
        .mask8 {left:884px;top:422px;background-position:-900px 0px;}
        .mask9 {left:1059px;top:422px;background-position:-900px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-09-22.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after" class="mask after"></div>
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

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && ( index == 11 && focus <= 3 || index == -11 && focus >= 4 || index == -1 && (focus <= 0 || focus == 4 ) || index == 1 && (focus == 3 || focus + 1 >= items.length ) )) return;
            if(index == 1 || index == -1 ) focus += index;
            else {
                if( index == 11 && focus == items.length -1 ) focus = 3;
                else focus += index > 0 ? -4 : 4;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = "mask mask" + ( focus + 1);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>