<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = "10000100000000090000000000112045";

    //
    int vodId = 0;
    try {
        List<Vod> vods = inner.getList( "10000100000000090000000000112046",1,0,new Vod() );
        if( vods != null && vods.size() > 0 ) {
            vodId = vods.get(0).getId();
        }
    } catch (Throwable e){}

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String body = "none";
    if( column != null ) body = inner.pictureUrl(body, column.getPosters(), "7",0 );
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-07-01.png') no-repeat;background-position: 0px 0px;}

        .mask11 {width:159px;height: 77px;left:497px;top:60px;background-position: 0px -600px;}
        .mask12 {width:594px;height:390px;left:60px;top:173px;background-position: 0px 0px;}
        .mask13 {width:586px;height: 65px;left:64px;top:550px;background-position: 0px -500px;}

        .mask21 {width:534px;height: 99px;left:678px;top:347px;background-position: 0px -400px;}
        .mask22 {width:534px;height: 99px;left:678px;top:435px;background-position: 0px -400px;}
        .mask23 {width:534px;height: 99px;left:678px;top:524px;background-position: 0px -400px;}
    </style>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
    <div style="background:transparent url('images/bg-2019-07-01.png') no-repeat;width:1280px;height:720px;left:0px;top:0px;position:absolute;"></div>
    <div id='mask'></div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [],
        moviePos : {width:577,height:374,left:68,top:181},
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';


            cursor.moviePos = this.moviePos;
            cursor.fullmode = false;
            cursor.showBared = false;

            // 重庆卫视高清
            //cursor.serviceId = 4603;
            //cursor.frequency = 1870000;
            //风云足球频道
            cursor.serviceId = 1606;
            cursor.frequency = 3390000;

            cursor.focusable[0] = {
                items:[
                {"name":"投票规则","linkto":"/EPG/jsp/neirong/S20190701Img.jsp?id=1"},
                {"name":"全屏播放"},
                {"name":"一键跳转","linkto":'/EPG/jsp/neirong/VideoFullPlay.jsp?frequency=' + cursor.frequency + "&serviceId=" + cursor.serviceId }
            ]};
            cursor.focusable[1] = {items:[
                {"name":"成年组","linkto":"/EPG/jsp/neirong/S20190701Vote-1.jsp?typeId=10000100000000090000000000112068&VOTEID=454"},
                {"name":"U9组","linkto":"/EPG/jsp/neirong/S20190701Vote-2.jsp?typeId=10000100000000090000000000112047&VOTEID=455"},
                {"name":"个人","linkto":"/EPG/jsp/neirong/S20190701Img.jsp?id=2"}
            ]};

            for( var i = 0 ; i < cursor.focusable.length ; i ++ )
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : ( i == 0  ? 1 : 0 );

            cursor.call('show');
            setTimeout(function(){
                cursor.call('enterSmallMode');
                cursor.call('playMovie');
                setTimeout(function(){cursor.call('counter')}, 100);
            },50);
        },
        nextVideo : function (){
            cursor.call('playMovie');
        },
        select:function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( cursor.fullmode )  return cursor.call("enterSmallMode");
            if( blocked == 0 && ( focus == 1 || focus == 2 )){
                if( iPanel.mediaType == 'PC' ) return;
                var voteId = focus == 1 ? 457 : 458;
                cursor.call("sendVote",{id:voteId,limit:999,limitPer:999,target:'1',repeat:true, callback:function(rst){
                    if(focus == 1) return cursor.call("enterFullMode");
                    return cursor.call('selectAct');
                 }});
                return;
            }
            cursor.call('selectAct');
        },
        playMovie : function () {
            try{
                var time = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
                //14号19:30～22：30
                if( ( time < '2019-06-14 19:30:00' ||  time > '2019-06-14 22:30:00' ) && <%=vodId%> != 0 ) {
                    player.play({vodId: <%=vodId%>});
                } else {
                    //文体娱乐高清：serviceid：4202 频点：626
                    player.play({
                        serviceId: 4202,
                        frequency: 6260000
                    });
                }
            } catch (e){}
        },
        goBack : function(){
            if( cursor.fullmode )  return cursor.call('enterSmallMode');
            cursor.call('goBackAct');
        },
        enterFullMode : function(){
            cursor.fullmode = true;
            player.fullScreen();
            $("listBody").style.display = 'none';
        },
        enterSmallMode : function(){
            cursor.fullmode = false;
            var pos = cursor.moviePos;
            player.setPosition(pos.left,pos.top,pos.width,pos.height);
            $("listBody").style.display = '';
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            if( cursor.fullmode || cursor.showBared ) return;
            var blocked = cursor.blocked;
            var previousBlocked = blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length || ( index == -1 && blocked == 0 || index == 1 && blocked == 1 )) return;
            if( index == 11 || index == -11 ) {
                focus += index > 0 ? -1 : 1;
            } else {
                blocked = index == -1 ? 0 : 1;
                focus = cursor.focusable[blocked].focus;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = "mask mask" + String(blocked + 1) + String(focus + 1);
        },
        counter : function(){
            cursor.call("sendVote",{
                id:456,limit:999,limitPer:999,target:'1',repeat:true
            });
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>