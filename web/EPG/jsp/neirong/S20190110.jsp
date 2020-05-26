<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000110883";
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
        .mask {position:absolute;background:transparent url('images/mask-2019-01-10.png') no-repeat;background-position: 0px 0px;}

        .top {width:1280px;height:245px;left:0px;top:0px;position:absolute; background: transparent url('images/bg-2019-01-10-top.jpg') no-repeat left top;}
        .left {width:60px;height:380px;left:0px;top:244px;position:absolute; background: transparent url('images/bg-2019-01-10-left.jpg') no-repeat left top;}
        .right {width:549px;height:380px;left:731px;top:244px;position:absolute; background: transparent url('images/bg-2019-01-10-right.jpg') no-repeat left top;}
        .bottom {width:1280px;height:97px;left:0px;top:623px;position:absolute; background: transparent url('images/bg-2019-01-10-bottom.jpg') no-repeat left top;}

        .mask1 {width:267px;height:199px;top:233px;left:741px;background-position:0px -250px;}
        .mask2 {width:267px;height:193px;top:441px;left:741px;background-position:-300px -250px;}
        .mask3 {width:206px;height:401px;top:233px;left:1015px;background-position:-600px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div id="bg" style="width:1280px;height:720px;position:absolute;left:0px;top:0px">
    <div class="top"></div> <div class="left"></div> <div class="right"></div> <div class="bottom"></div>
    <div id="mask"></div>
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
            cursor.fullmode = false;
            cursor.serviceId = 2602;
            cursor.frequency = 2750000;
            cursor.fullmode = false;
            var items = this.data.length == 0 ? [] : this.data[0]['data'];
            cursor.vodId = items != undefined && items.length > 0 ? items[0].id : undefined;

            var links = [
                {name:'品牌篇',linkto:'/EPG/jsp/neirong/S20190110List.jsp?typeId=10000100000000090000000000110886&voteId=441'},
                {name:'行业篇',linkto:'/EPG/jsp/neirong/S20190110List.jsp?typeId=10000100000000090000000000110885&voteId=440'},
                {name:'区县篇',linkto:'/EPG/jsp/neirong/S20190110List.jsp?typeId=10000100000000090000000000110884&voteId=439'}
            ];
            cursor.focusable[0] = {
                focus : this.focused.length > 1 ? Number( this.focused[1] ) : 0,
                items : links
            };
            player.setPosition(60,245,671,378);
            cursor.call('prepare');
            cursor.call('show');
        },
        move        :   function(index){
            if( cursor.fullmode ) return;
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 && ( focus == 0 || focus == 2 ) || index == -11 && focus >= 1 || index == -1 && focus <= 1 || index == 1 && focus == 2 ) return;
            if( index == 11 ) {
                focus = 0;
            } else if( index == -11 ) {
                focus = 1;
            } else if( index == -1 ) {
                focus = 0;
            } else {
                focus = 2;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        select : function(){
            var blocked = cursor.blocked;
            if(blocked != 0 && ! cursor.fullmode ) {
                $('bg').style.visibility = 'hidden';
                player.fullScreen();
                cursor.fullmode = true;
                return;
            }
            cursor.call("selectAct");
        },
        goBack : function(){
            if(cursor.fullmode ) {
                $('bg').style.visibility = 'visible';
                player.setPosition(75,83,617,347);
                cursor.fullmode = false;
                return;
            }
            cursor.call('goBackAct');
        },
        prepare :function(){
            var date = new Date();
            var time = date.Format("yyyy-MM-dd");
            var hour = date.Format('hh:mm:ss');

            if( cursor.vodId == undefined || ( time == '2018-12-30' ) && ( '19:00:00' <= hour && hour <= '23:00:00' )) {
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