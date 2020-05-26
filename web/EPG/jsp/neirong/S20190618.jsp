<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000111982";
    List<Column> list = inner.getList(typeId,1,0, new Column());
    int vodId = 0;
    if( list != null && list.size() > 0 ) {
        Vod vod = new Vod();
        List<Vod> vods = inner.getList(list.get(0).getId(),1,0,vod);
        if( vods != null && vods.size() > 0) {
            vodId = vods.get(0).getId();
        }
    }

    list = inner.getList(typeId,1,1, new Column());
    for( Column col : list) infos.add(new ColumnInfo(col.getId(), 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String body = "images/bg-2019-06-18.png";
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
        .mask {width:490px;height:57px;left:682px;position:absolute;background:transparent url('images/mask-2019-06-18.png') no-repeat;background-position: 0px 0px;}
        .mask1 {top:270px;background-position: 0px 0px;}
        .mask2 {top:343px;background-position: 0px -80px;}
        .mask3 {top:420px;background-position: 0px -160px;}
        .mask4 {top:498px;background-position: 0px -240px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('<%=body%>') no-repeat;" onUnload="exit();">
<div id='mask'></div>
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            var o = this.data[1];
            cursor.focusable[0] = {};
            cursor.focusable[0].typeId = o["id"];
            cursor.focusable[0].focus = this.focused.length > 1 ? Number( this.focused[1] ) : 0;
            cursor.focusable[0].items = o["data"];

            cursor.focusable[0].items[3] = {
                'name':'列表',
                'linkto':'/EPG/jsp/neirong/S20190618List.jsp?typeId=10000100000000090000000000111985'
            };

            cursor.call('show');
            cursor.call('prepare');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if(index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) return;

            focus += index > 0 ? -1 : 1;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            cursor.call('show');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            $("mask").className = 'mask mask' +  String( focus + 1 );
        },
        prepare :function(){
            var vodId = <%=vodId%>;
            if( vodId == 0 ) return;
            player.play({position:{width:446,height:280,left:139,top:273}, vodId: vodId });
        },
        nextVideo   :   function () {
            cursor.call('prepare');
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>