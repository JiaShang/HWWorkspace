<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000111103";
    infos.add(new ColumnInfo(typeId, 0, 8));
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
        .mask {position:absolute;background:transparent url('images/mask-2019-07-18.png') no-repeat;background-position: 0px 0px;}

        .mask1{width:582px;height:228px;left:58px;top:230px;background-position: -300px -500px;}
        .mask2{width:582px;height:228px;left:641px;top:230px;background-position: -300px -500px;}
        .mask3{width:199px;height:254px;left:57px;top:441px;background-position: 0px -500px;}
        .mask4{width:199px;height:254px;left:251px;top:441px;background-position: 0px -500px;}
        .mask5{width:199px;height:254px;left:445px;top:441px;background-position: 0px -500px;}
        .mask6{width:199px;height:254px;left:639px;top:441px;background-position: 0px -500px;}
        .mask7{width:199px;height:254px;left:831px;top:441px;background-position: 0px -500px;}
        .mask8{width:199px;height:254px;left:1025px;top:441px;background-position: 0px -500px;}

        .after{width:1143px;height:461px;left:71px;top:210px;position:absolute;background:transparent url('images/mask-2019-07-18.png') no-repeat;background-position: 0px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-07-18.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after" class="after"></div>
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
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 && focus <= 1 || index == -11 && focus > 1 || index == -1 && ( focus == 0 || focus == 2 ) || index == 1 && ( focus == 1 || focus + 1 >= items.length )) return;
            if ( index == -1 || index == 1 ) focus += index;
            else if( index == -11 ){
                focus = focus == 0 ? 2 : 5
            } else {
                focus = focus >= 5 ? 1 : 0;
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