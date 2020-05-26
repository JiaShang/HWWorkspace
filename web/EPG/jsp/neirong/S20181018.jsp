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
        .top {width:1280px;height:152px;left:0px;top:0px;position:absolute; background: transparent url('images/bg-2018-10-18-top.jpg') no-repeat left top;}
        .left {width:78px;height:317px;left:0px;top:151px;position:absolute; background: transparent url('images/bg-2018-10-18-left.jpg') no-repeat left top;}
        .right {width:688px;height:317px;left:592px;top:151px;position:absolute; background: transparent url('images/bg-2018-10-18-right.jpg') no-repeat left top;}
        .bottom {width:1280px;height:253px;left:0px;top:467px;position:absolute; background: transparent url('images/bg-2018-10-18-bottom.jpg') no-repeat left top;}

        .mask {position:absolute; background:transparent url("images/mask-2018-10-18.png") no-repeat left top; background-position: 0px 0px;}
        .icon {width:684px;height:321px;left:596px;top:149px;overflow: hidden;}
        .remainderDays{width:310px;height:200px;left:295px;font-size:100px;color:#211B69;position:absolute;top:60px;overflow:hidden;}

        .mask1 {left:63px;top:136px;width:546px;height:347px;background-position:-700px 0px;}
        .mask2 {left:64px;top:484px;width:382px;height:161px;background-position:-700px -350px;}
        .mask3 {left:451px;top:484px;width:382px;height:161px;background-position:-700px -350px;}
        .mask4 {left:838px;top:484px;width:382px;height:161px;background-position:-700px -350px;}

        .image{width: 132px;height:189px;float: left;overflow: hidden;margin:0px 0px 0px 15px}
        .image img {width: 132px;height:189px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div id="bg" style="width:1280px;height:720px;position:absolute;left:0px;top:0px">
    <div class="top"></div>
    <div class="left"></div>
    <div class="right"></div>
    <div class="bottom"></div>
    <div class="mask icon" id="icon"></div>
    <div id="mask" class="mask mask1"></div>
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
            cursor.focusable[0] = {focus:0,items:[{ name : '视频'},{ name : 'Q&A', linkto:'/EPG/jsp/neirong/S20181018Detail.jsp'},{ name : '暴汗', linkto:'http://192.168.35.153:8080/program_theme_9.jsp?id=81&lcn=ban'},{ name : '翘臀', linkto:'http://192.168.35.153:8080/program_theme_9.jsp?id=80&lcn=ban'}]};
            cursor.focusable[0].focus = this.focused.length > 1 ? Number( this.focused[ 1 ] ) : 0;

            player.setPosition(78,152,514,315);

            cursor.call('prepare');
            cursor.call('showText');
            cursor.call('show');
        },
        move        :   function(index){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            if(cursor.fullmode || index == -1 && focus <= 1 || index == 1 && ( focus == 0 || focus + 1 >= items.length ) || index == 11 && focus == 0 || index == -11 && focus >= 1 ) return;

            if( index == 1 || index == -1 ) {
                focus += index;
            } else if( index == 11 ) {
                focus = 0;
            } else {
                focus = 1;
            }
            cursor.focusable[0].focus = focus;
            cursor.call('show');
        },
        showText : function(){
            //访问量统计431
            setTimeout(function(){
                cursor.call("sendVote",{id:431,limit:9999,limitPer:9999,target:'vod',repeat:true});
            },50);
            setTimeout(function(){
                var startTime = Date.parse("2018-10-28T00:00:00-08:00");
                var currentTime = Date.parse((new Date()).Format('yyyy-MM-dd') + 'T00:00:00-08:00');
                if( currentTime >= startTime ){
                    $('icon').style.backgroundPosition = '0px -350px';
                    return;
                }
                var num = Math.ceil((startTime - currentTime)/(24*3600*1000)) - 1;
                $('icon').style.backgroundPosition = '0px 0px';
                $('icon').innerHTML = '<div class="remainderDays"><div class="image"><img src="images/numeric1/0.png" /></div><div class="image"><img src="images/numeric1/' + String(num) + '.png" /></div></div>';
            },100);
        },
        select : function(){
            var focus = cursor.focusable[0].focus;
            if( focus == 0 && !cursor.fullmode ) {
                $('bg').style.visibility = 'hidden';
                player.fullScreen();
                cursor.fullmode = true;
                return;
            }
            cursor.call('selectAct');
        },
        goBack : function(){
            var focus = cursor.focusable[0].focus;
            if(focus == 0 && cursor.fullmode ) {
                $('bg').style.visibility = 'visible';
                player.setPosition(78,152,514,315);
                cursor.fullmode = false;
                return;
            }
            cursor.call('goBackAct');
        },
        prepare :function(){
            var time = (new Date()).Format("yyyy-MM-dd hh:mm:ss");

            if( cursor.vodId == undefined ) {
                player.play({
                    serviceId: cursor.serviceId,
                    frequency: cursor.frequency,
                    callback : function(){
                        //直播时段访问量统计432
                        setTimeout(function(){
                            cursor.call("sendVote",{id:432,limit:9999,limitPer:9999,target:'live',repeat:true});
                        },100);
                    }
                });
            } else {
                player.play({ vodId: cursor.vodId });
            }
        },
        nextVideo   :   function () {
            cursor.call('prepare');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            $("mask").className = 'mask mask' + String( focus + 1);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>