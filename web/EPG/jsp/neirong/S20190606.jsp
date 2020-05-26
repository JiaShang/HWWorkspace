<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = "10000100000000090000000000111871";
    infos.add(new ColumnInfo("10000100000000090000000000111886", 0, 1));
    infos.add(new ColumnInfo("10000100000000090000000000111887", 0, 99));

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
        .mask {position:absolute;background:transparent url('images/mask-2019-06-06.png') no-repeat;background-position: -1000px -10px;}
        .maskNone{width:1px;height:1px;left:-1px;top:-1px;}
        .mask11 {width:518px;height:57px;left:37px;top:397px;background-position:0px 0px;}
        .introduceBg {position:absolute;width:673px;height:238px;left:564px;top:213px;background:transparent url("<%=body%>") no-repeat 0px 0px;}

        .flowed {width:1230px;height:200px;position:absolute;left:45px;top:510px;overflow: hidden;}

        .item{width:245px;height:150px;position:relative;float:left;overflow: hidden;}
        .image{position:absolute;width:214px;height:144px;left:3px;top:3px;overflow: hidden;}
        .image img{width:214px;height:144px;}
        .focusItem,.regularItem{position:absolute;width:220px;height:150px;left:0px;top:0px;background-position:-300px -100px;}
        .regularItem {background-position:0px -100px;}
        .text{width:214px;height:30px;left:3px;top:126px;position:absolute;font-size: 16px;color:white;line-height: 16px;text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
    </style>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
    <div style="background:transparent url('images/bg-2019-06-06.png') no-repeat;width:1280px;height:720px;left:0px;top:0px;position:absolute;"></div>
    <div class='introduceBg'></div>
    <div id='mask' class="mask mask11" style="visibility: hidden" ></div>
    <div id='flowed' class='flowed'></div>
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
                html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
            %>],
        moviePos : {width:510,height:330,left:41,top:71},
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';

            cursor.serviceId = 1606;
            cursor.frequency = 3390000;

            // 重庆卫视高清
            //cursor.serviceId = 4603;
            //cursor.frequency = 1870000;

            cursor.moviePos = this.moviePos;
            cursor.fullmode = false;
            cursor.showBared = false;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[0].items = cursor.focusable[0].items || [];
            cursor.focusable[0].items[0] = cursor.focusable[0].items[0] || {};
            cursor.focusable[0].items[0].style ='mask mask11';

            cursor.replay = cursor.focusable[0].items.length > 0;
            cursor.focusable[0].items[0].linkto = '/EPG/jsp/neirong/VideoFullPlay.jsp?frequency=' + cursor.frequency + "&serviceId=" + cursor.serviceId;

            for( var i = 0 ; i < cursor.focusable.length ; i ++ )
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;

            cursor.call('show');
            setTimeout(function(){
                cursor.call('enterSmallMode');
                cursor.call('playMovie');
                setTimeout(function(){cursor.call('counter')}, 100);
            },50);
            cursor.call('lazyShow');
        },
        nextVideo : function (){
            cursor.call('playMovie');
        },
        select:function(){
            if( cursor.blocked == 0 && iPanel.mediaType != 'PC' ){
                cursor.call("sendVote",{id:452,limit:999,limitPer:999,target:'1',repeat:true, callback:function(rst){
                        cursor.call('selectAct');
                    }});
                return;
            }
            cursor.call('selectAct');
        },
        playMovie : function () {
            try{
                if( cursor.replay ) {
                    var id = cursor.focusable[0].items[0].id;
                    player.play({vodId: id});
                } else {
                    player.play({
                        serviceId: cursor.serviceId,
                        frequency: cursor.frequency
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
            $("listBody").style.display = 'none';
            player.fullScreen();
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
            var pageCount = 5;

            if( blocked == 0 && ( index != -11 ) ||
                blocked == 1 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length ) ) return;
            if( index == -11 ) {
                blocked = 1; focus = cursor.focusable[blocked].focus;
            } else if( index == 11 ) {
                blocked = 0; focus = cursor.focusable[blocked].focus;
            } else {
                focus += index;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');

            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.moveTimer = undefined;cursor.call('lazyShow');}, 1300);

        },
        lazyShow : function(){
            var blocked = cursor.blocked;
            if( blocked != 1 ) return;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            cursor.calcStringPixels(text, 16, function(width){
                var fus = cursor.focusable[cursor.blocked].focus
                if( cursor.blocked != 1 || focus != fus || width <= 214 ) return;
                $('text' + String(focus + 1)).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            $("mask").style.visibility = blocked === 0 ? 'visible' : 'hidden';
            cursor.call('showFlowed')
        },
        showFlowed : function(){
            var focus = cursor.focusable[1].focus;
            var items = cursor.focusable[1].items;
            var pageCount = 5;
            //每页显示数量
            var defaultIndex = Math.floor(pageCount / 2.0);
            var flowCursorIndex = focus < defaultIndex ? 0 : focus - defaultIndex;
            if( flowCursorIndex + pageCount >= items.length ) flowCursorIndex = items.length - pageCount;
            if( flowCursorIndex < 0 ) flowCursorIndex = 0;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item">';
                html += '<div class="image"><img src="' + cursor.pictureUrl(item.posters,1) + '"/></div>';
                var style = cursor.blocked == 1 && i == focus ? 'focusItem' : 'regularItem';
                html += '<div class="mask ' + style + '"></div>';
                html += '<div class="text" id="text' + String( i + 1) + '">' + item.name + '</div>';
                html += '</div>';
            }
            $("flowed").innerHTML = html;
        },
        counter : function(){
            cursor.call("sendVote",{
                id:451,limit:999,limitPer:999,target:'1',repeat:true
            });
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>