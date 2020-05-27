<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107920";
    infos.add(new ColumnInfo(typeId, 0, 1));
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
        .top {width:1280px;height:298px;left:0px;top:0px;position:absolute; background: transparent url('images/bg-2018-10-17-top.jpg') no-repeat left top;}
        .left {width:589px;height:360px;left:0px;top:297px;position:absolute; background: transparent url('images/bg-2018-10-17-left.jpg') no-repeat left top;}
        .right {width:55px;height:360px;left:1225px;top:297px;position:absolute; background: transparent url('images/bg-2018-10-17-right.jpg') no-repeat left top;}
        .bottom {width:1280px;height:64px;left:0px;top:656px;position:absolute; background: transparent url('images/bg-2018-10-17-bottom.jpg') no-repeat left top;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent none no-repeat;" onUnload="exit();">
<div id="bg" style="width:1280px;height:720px;position:absolute;left:0px;top:0px">
    <div class="top"></div>
    <div class="left"></div>
    <div class="right"></div>
    <div class="bottom"></div>
</div>
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
            cursor.serviceId = 2602;
            cursor.frequency = 2750000;
            cursor.fullmode = false;
            var items = this.data.length == 0 ? [] : this.data[0]['data'];
            cursor.vodId = items != undefined && items.length > 0 ? items[0].id : undefined;

            player.setPosition(589,298,636,358);

            cursor.call('prepare');
        },
        move        :   function(index){
        },
        select : function(){
            if(! cursor.fullmode ) {
                $('bg').style.visibility = 'hidden';
                player.fullScreen();
                cursor.fullmode = true;
            }
        },
        goBack : function(){
            if(cursor.fullmode ) {
                $('bg').style.visibility = 'visible';
                player.setPosition(589,298,636,358);
                cursor.fullmode = false;
                return;
            }
            cursor.call('goBackAct');
        },
        prepare :function(){
            var date = new Date();
            var time = date.Format("yyyy-MM-dd");
            var hour = date.Format('hh:mm:ss');

            if( cursor.vodId == undefined || ( time == '2018-10-20' || time == '2018-10-21' ) && ( '08:00:00' <= hour && hour <= '18:00:00' )) {
                player.play({
                    serviceId: cursor.serviceId,
                    frequency: cursor.frequency
                });
            } else {
                player.play({ vodId: cursor.vodId });
            }
        },
        nextVideo   :   function () {
            cursor.call('prepare');
        },
        show        :   function(){
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>