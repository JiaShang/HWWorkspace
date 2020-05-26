<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000111765";
    List<Column> list = inner.getList(typeId,1,0, new Column());
    int vodId = 0;
    if( list != null && list.size() > 0 ) {
        Vod vod = new Vod();
        List<Vod> vods = inner.getList(list.get(0).getId(),1,0,vod);
        if( vods != null && vods.size() > 0) {
            vodId = vods.get(0).getId();
        }
    }
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String body = "images/bg-2019-05-29.png";
    if( column != null ) body = inner.pictureUrl(body, column.getPosters(), "7",0 );
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-05-29.png') no-repeat;background-position: 0px 0px;}
        .active{width:191px;height:159px;top:468px;}
        .active1{left:640px; background-position: 0px 1px;}
        .active2{left:835px; background-position: -200px 0px;}
        .active3{left:1031px; background-position: -400px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('<%=body%>') no-repeat;" onUnload="exit();">
<div id="active"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            cursor.focusable[0] = {
                focus : this.focused.length > 1 ? Number(this.focused[1]) : 0,
                items : [
                    {'name':'历史记忆','linkto':'/EPG/jsp/neirong/S20190529List.jsp?currFoucs=1,0,0,0,0,0'},
                    {'name':'纪念活动','linkto':'/EPG/jsp/neirong/S20190529List.jsp?currFoucs=2,1,0,0,0,0'},
                    {'name':'人防专区','linkto':'/EPG/jsp/neirong/S20190529List.jsp?currFoucs=3,2,0,0,0,0'}
                ]
            };
            cursor.call('show');
            cursor.call('prepare');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length || index == 11 || index == -11) return;

            focus += index ;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            var blocked = cursor.blocked;
            $("active").className = 'mask active active' +  String( focus + 1 );
        },
        prepare :function(){
            var vodId = <%=vodId%>;
            if( vodId == 0 ) return;
            player.play({position:{width:589,height:343,left:633,top:104}, vodId: vodId });
        },
        nextVideo   :   function () {
            cursor.call('prepare');
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>