<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    infos.add(new ColumnInfo("10000100000000090000000000109240", 0, 1));
    infos.add(new ColumnInfo("10000100000000090000000000109241", 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);

    int focus = 0;
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2018-03-19.png') no-repeat;background-position: 0px 0px;}
        .maskNone{width:1px;height:1px;left:-1px;top:-1px;}
        .remainderDays {width:116px;height:97px;left:769px; top:137px; color:white;font-size:84px;text-align: center; overflow: hidden;line-height: 97px; position:absolute;}

        .mask11{width:76px;height:76px;left:263px;top:280px;background-position: -220px 0px;}
        .mask21{width:641px;height:90px;left:551px;top:253px;background-position: -300px 0px;}

        .mask3 {width:203px;height:157px;top:343px;}
        .mask31 {left: 550px;background-position: -220px -120px;}
        .mask32 {left: 720px;background-position: -420px -120px;}
        .mask33 {left: 889px;background-position: -620px -120px;}
        .mask34 {left: 1060px;background-position: -820px -120px;}

        .flowed {width:1100px;height:200px;position:absolute;left:104px;top:486px;overflow: hidden;}

        .item {width:219px;height:199px;position:relative;float:left; overflow: hidden;}
        .itemImg {width:208px;height:137px;position:absolute;left:1px;top:1px;overflow: hidden;}
        .itemImg img{width:208px;height:137px;}
        .itemMask,.itemFocus{width:210px;height:139px;position:absolute;left:0px;top:0px;overflow: hidden;}
        .itemMask {background-position: 0px 0px;}
        .itemFocus {background-position: 0px -140px;}
        .itemText {width:209px;height:40px;position:absolute;color:white;font-size:20px;left:2px;top:150px;text-align:left;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
    </style>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div style="background:transparent url('images/bg-2018-03-19.png') no-repeat;width:1280px;height:720px;left:0px;top:0px;position:absolute;"></div>
<div class="remainderDays" id="remainderDays"></div>
<div id='mask'></div>
<div id='flowed' class='flowed'></div>
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
            cursor.serviceId = 4603;
            cursor.frequency = 1870000;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[0].items = cursor.focusable[0].items || [];
            cursor.focusable[0].items[0] = cursor.focusable[0].items[0] || {};
            cursor.focusable[0].items[0].style ='mask mask11';

            cursor.focusable[0].items[0].replay = typeof cursor.focusable[0].items[0].isSitcom !== 'undefined';
            cursor.focusable[0].items[0].linkto = "/EPG/jsp/neirong/VideoFullPlay.jsp?" + (
                cursor.focusable[0].items[0].replay
                    ? "vodId=" + cursor.focusable[0].items[0].id
                    : "serviceId=" + cursor.serviceId + "&frequency=" + cursor.frequency
            );
            cursor.focusable[0].items[0].isSitcom = 1;

            var obj = {items:[{name:'活动链接',style:'mask mask21',linkto:'/EPG/jsp/neirong/S20180319Act.jsp'}]};
            cursor.focusable.insertAt(1, obj);
            obj = { focus:this.focused.length > 2 ? Number( this.focused[2] ) : 0,items:
                [
                    {name:'塞事详请',linkto:'/EPG/jsp/neirong/S20180319Detail.jsp',style:'mask mask3 mask31'},
                    {name:'比赛线路',linkto:'/EPG/jsp/neirong/S20180319Map.jsp',style:'mask mask3 mask32'},
                    {name:'综合训练',linkto:'http://192.168.35.153:8080/huoDong_banma.jsp?lcn=mls',style:'mask mask3 mask33'},
                    {name:'新手必看',linkto:'http://192.168.35.153:8080/huoDong_malasong.jsp?lcn=lequ',style:'mask mask3 mask34'}
                ]};
            cursor.focusable.insertAt(2, obj);
            var startTime = Date.parse("Mar 25 2018 08:00:00");

            var currentTime = new Date();
            var num = 0;
            if( currentTime < startTime )
            {
                num = Math.ceil(( startTime - currentTime ) / ( 60 * 60 * 1000 ));
                num = num <= 8 ? 0 : Math.ceil( ( num - 8 ) / 24 ) ;
            }
            $("remainderDays").innerHTML = "0" + num;

            for( var i = 0 ; i < cursor.focusable.length ; i ++ )
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
            setTimeout("cursor.call('counter')",500);
            setTimeout("cursor.call('playMovie')",50);
            cursor.call('showFlowed');
            cursor.call('show');
        },
        playMovie : function () {
            try{
                media.video.setPosition(40,148,514,315);
                if( cursor.focusable[0].items[0].replay ) {
                    var id = cursor.focusable[0].items[0].id;
                    var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + id + "&contentType=0&business=1&baseFlag=0";
                    ajax(rtspUrl,function(result){
                        if( result.playFlag === "1"){
                            var rtsp = result.playUrl.split("^")[4];
                            media.AV.open(rtsp,"VOD");
                        } else {
                        }
                    },{charset:'GBK'});
                } else {
                    DVB.playAV(cursor.frequency,cursor.serviceId);
                }
            } catch (e){}
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var previousBlocked = blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var pageCount = 5;

            if( blocked == 0 && ( index == -1 || index == 11 ) ||
                blocked == 1 && ( index == 1 || index == 11 ) ||
                blocked == 2 && ( index == 1 && focus >= 3) ||
                blocked == 3 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length )) return;
            if( index == 1 ) {
                if( blocked == 0 ){
                    blocked = 1; focus = 0;
                } else {
                    focus += 1;
                }
            } else if( index == -1 ) {
                if( blocked == 1 || blocked == 2 && focus == 0 ) {
                    blocked = 0;
                } else {
                    focus -= 1;
                }
            } else if( index == 11 ) {
                if( blocked == 3) {
                    blocked = focus % pageCount <= 1 ? 0 : 2; focus = cursor.focusable[blocked].focus;
                } else if( blocked == 2 ) {
                    blocked = 1;focus = 0;
                }
            } else {
                if( blocked == 1 ) {
                    blocked = 2; focus = cursor.focusable[blocked].focus;
                } else if( blocked == 2 ) {
                    blocked = 3;
                    if( cursor.focusable[blocked].focus % pageCount >= 2 )
                        focus = cursor.focusable[blocked].focus;
                    else {
                        var sub = 2 - cursor.focusable[blocked].focus % pageCount;
                        focus = cursor.focusable[blocked].focus + sub >= cursor.focusable[blocked].items.length ? cursor.focusable[blocked].items.length - 1 : cursor.focusable[blocked].focus + sub;
                    }
                } else if( blocked == 0 ) {
                    blocked = 3;
                    if( cursor.focusable[blocked].focus % pageCount < 2 )
                        focus = cursor.focusable[blocked].focus;
                    else {
                        focus = cursor.focusable[blocked].focus % pageCount - 2 ;
                    }
                }
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
            if( previousBlocked === 3 && previousBlocked !== blocked )
                cursor.call('showFlowed');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if(blocked === 3) {
                $("mask").className = "mask maskNone";
                $("mask").style.visibility = 'hidden';
                cursor.call('showFlowed');
            } else {
                var item = cursor.focusable[blocked].items[focus];
                $("mask").className = item.style;
                $("mask").style.visibility = 'visible';
            }
        },
        nextVideo : function (){
            cursor.call('playMovie');
        },
        showFlowed : function(){
            var focus = cursor.focusable[3].focus;
            var items = cursor.focusable[3].items;
            var pageCount = 5;
            //每页显示数量
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item">';
                html += '<div class="mask itemImg"><img src="' + cursor.pictureUrl(item.posters,1) + '"/></div>';
                html += '<div class="mask ' + ( ( i == focus && cursor.blocked == 3 ) ? "itemFocus" : "itemMask" )  + '"></div>';
                html += '<div class="itemText" id="txt' + ( i + 1) + '">' + item.name + '</div>';
                html += '</div>';
            }
            $("flowed").innerHTML = html;
            if( cursor.blocked == 3 )
            {
                (function(id,value){
                    cursor.calcStringPixels(value, 20, function(pixelsWidth){
                        var innerHTML = pixelsWidth > 209 ? ('<marquee class="maskMarquee" scrollamount="10">' + value + "</marquee>") : value ;
                        $(id).innerHTML = innerHTML;
                    });
                })('txt' + (focus + 1),items[focus].name);
            }
        },
        counter : function(){
            cursor.call("sendVote",{
                id:405,limit:999,limitPer:999,target:'1',repeat:true
            });
            if( !cursor.focusable[0].items[0].replay ){
                cursor.call("sendVote",{
                    id:406,limit:999,limitPer:999,target:'1',repeat:true
                });
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>