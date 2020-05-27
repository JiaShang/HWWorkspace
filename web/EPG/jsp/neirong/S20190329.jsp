<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000111301";
    infos.add(new ColumnInfo(typeId, 0, 12));
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
        .mask {width:363px;height:45px;left:904px;position:absolute;background:transparent url('images/mask-2019-03-29.png') no-repeat;background-position: 0px 0px;}
        .mask1 {top:164px;background-position:0px 0px;}
        .mask2 {top:205px;background-position:0px -50px;}
        .mask3 {top:246px;background-position:0px -100px;}
        .mask4 {top:288px;background-position:0px -150px;}
        .mask5 {top:329px;background-position:0px -200px;}
        .mask6 {top:370px;background-position:0px -250px;}
        .mask7 {top:411px;background-position:0px -300px;}
        .mask8 {top:452px;background-position:0px -350px;}
        .mask9 {top:493px;background-position:0px -400px;}
        .mask10 {top:535px;background-position:0px -450px;}
        .mask11 {top:576px;background-position:0px -500px;}
        .mask12 {top:617px;background-position:0px -550px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-03-29.jpg') no-repeat;" onUnload="exit();">
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

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) return;
            focus += index > 0 ? -1 : 1 ;

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