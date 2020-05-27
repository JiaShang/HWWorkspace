<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
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
        .mask {width:64px;height:159px;position:absolute;background:transparent url('images/mask-2018-12-28.png') no-repeat;background-position: 0px 0px;}

        .mask1 {left:745px;top:143px;background-position:0px 0px;}
        .mask2 {left:819px;top:143px;background-position:-70px 0px;}
        .mask3 {left:891px;top:143px;background-position:-140px 0px;}
        .mask4 {left:964px;top:143px;background-position:-210px 0px;}
        .mask5 {left:1036px;top:143px;background-position:-280px 0px;}
        .mask6 {left:1108px;top:143px;background-position:-350px 0px;}
        .mask7 {left:745px;top:309px;background-position:0px -166px;}
        .mask8 {left:819px;top:309px;background-position:-70px -166px;}
        .mask9 {left:891px;top:309px;background-position:-140px -166px;}
        .mask10 {left:964px;top:309px;background-position:-210px -166px;}
        .mask11 {left:1036px;top:309px;background-position:-280px -166px;}
        .mask12 {left:1108px;top:309px;background-position:-350px -166px;}

        .QRCode{width:100px;height:100px;position:absolute;left:65px;top:501px;}
        /*word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;*/
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-12-28.jpg') no-repeat;" onUnload="exit();">
<div class="QRCode"><img src='<%=inner.pictureUrl("",column.getPosters(),"2")%>' style="width: 100%;height:100%"/> </div>
<div id="mask"></div>
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

            if( index == 11 && focus < 6 || index == -11 && focus >= 6 || index == -1 && focus % 6 == 0 || index == 1 && (focus % 6 == 5 || focus + 1 >= items.length)) return;
            if( index == 1 || index == -1 ){
                focus += index;
            } else if( index == -11 ) {
                focus += 6;
            } else {
                focus -= 6;
            }
            if( focus >= items.length ) focus = items.length - 1;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if(blocked === 0) {
                $("mask").className = "mask mask" + ( focus + 1);
                return;
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>