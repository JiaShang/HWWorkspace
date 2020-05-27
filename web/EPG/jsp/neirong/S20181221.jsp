<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
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
        .mask {width:185px;height:55px;top:578px;position:absolute;background:transparent url('images/mask-2018-12-21.png') no-repeat;background-position: 0px 0px;}

        .top {width:1280px;height:83px;left:0px;top:0px;position:absolute; background: transparent url('images/bg-2018-12-21-top.jpg') no-repeat left top;}
        .left {width:75px;height:349px;left:0px;top:82px;position:absolute; background: transparent url('images/bg-2018-12-21-left.jpg') no-repeat left top;}
        .right {width:588px;height:349px;left:692px;top:82px;position:absolute; background: transparent url('images/bg-2018-12-21-right.jpg') no-repeat left top;}
        .bottom {width:1280px;height:290px;left:0px;top:430px;position:absolute; background: transparent url('images/bg-2018-12-21-bottom.jpg') no-repeat left top;}

        .mask1 {left:177px;background-position:0px 0px;}
        .mask2 {left:396px;background-position:-200px 0px;}
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
                {name:'流程介绍',linkto:'/EPG/jsp/neirong/S20181221-1.jsp'},
                {name:'嘉宾阵容',linkto:'/EPG/jsp/neirong/S20181221-2.jsp'}/*,
                {name:'更多精彩',linkto:'/EPG/jsp/neirong/S20181221-List.jsp?typeId=10000100000000090000000000109070&tp=126&fs=24&hm=1&w=508&mr=20&lft=114&ih=52&al=0&bc=F15200&fc=ffffff&cl=ffffff&pg=7&sc=626,126,480,eeeeee,F15200'}*/
            ];
            cursor.focusable[0] = {
                focus : this.focused.length > 1 ? Number( this.focused[1] ) : 0,
                items : links
            };
            player.setPosition(75,83,617,347);
            setTimeout(function(){
                cursor.call("sendVote",{
                    id:438,limit:999,limitPer:999,target:'1',repeat:true
                });
            },100);
            cursor.call('prepare');
            cursor.call('show');
        },
        move        :   function(index){
            if( cursor.fullmode ) return;
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if(  index == 11 || index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length ) return;
            focus += index ;

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