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
    String body = "images/bg-2019-06-04.png";
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
        .mask {position:absolute;background:transparent url('images/mask-2019-06-04.png') no-repeat;background-position: 0px 0px;}
        .active{width:377px;height:67px;left:226px;}
        .active1{top:276px; background-position: 0px 0px;}
        .active2{top:367px; background-position: 0px -100px;}
        .active3{top:459px; background-position: 0px -200px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('<%=body%>') no-repeat;" onUnload="exit();">
<div style="position:absolute;z-index:0;width:2500px;height:45px;top:0px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
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
                    {'name':'重庆广播教育学校渝中校区','linkto':'/EPG/jsp/neirong/S20190604Vote.jsp?typeId=10000100000000090000000000111866&VOTEID=448&START=06-07&END=06-16&AREA=YZ'},
                    {'name':'重庆广播教育学校远洋校区','linkto':'/EPG/jsp/neirong/S20190604Vote.jsp?typeId=10000100000000090000000000111867&VOTEID=449&START=06-14&END=06-24&AREA=YY'},
                    {'name':'重庆广播教育学校沙坪坝校区','linkto':'/EPG/jsp/neirong/S20190604Role.jsp?AREA=SPB'}
                ]
            };

            var date = new Date();
            var current = date.Format("yyyy-MM-dd hh:mm:ss");
            if( current >= '2019-06-27 00:00:00' ) cursor.focusable[0].items[2].linkto = '/EPG/jsp/neirong/S20190604Vote.jsp?typeId=10000100000000090000000000111868&VOTEID=450&START=06-27&END=07-05&AREA=SPB';

            //渝中: /EPG/jsp/neirong/S20190604Vote.jsp?typeId=10000100000000090000000000111866&VOTEID=448&START=06-07&END=06-16&AREA=YZ
            //远洋: /EPG/jsp/neirong/S20190604Vote.jsp?typeId=10000100000000090000000000111867&VOTEID=449&START=06-14&END=06-24&AREA=YY
            //沙坪坝: /EPG/jsp/neirong/S20190604Vote.jsp?typeId=10000100000000090000000000111868&VOTEID=450&START=06-27&END=07-05&AREA=SPB
            cursor.call('show');
            cursor.call('prepare');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length || index  == 1 || index == -1) return;

            focus += index > 0 ? -1 : 1;

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
            player.play({position:{width:446,height:280,left:737,top:247}, vodId: vodId });
        },
        nextVideo   :   function () {
            cursor.call('prepare');
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>