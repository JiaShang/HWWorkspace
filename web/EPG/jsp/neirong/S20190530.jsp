<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    infos.add(new ColumnInfo("10000100000000090000000000111840", 0, 1));
    infos.add(new ColumnInfo("10000100000000090000000000111842", 0, 99));

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
        .mask {position:absolute;background:transparent url('images/mask-2019-05-30.png') no-repeat;background-position: -10px -10px;}
        .maskNone{width:1px;height:1px;left:-1px;top:-1px;}

        .remainBg1{width:337px;height:58px;left:568px;top:126px;background-position:-500px -200px;}
        .remainBg2{width:464px;height:31px;left:566px;top:150px;background-position:-340px -500px;}
        .remainderDays {width:160px;height:99px;left:742px; top:114px; color:black;font-size:99px;text-align: center; overflow: hidden;line-height: 99px; position:absolute;}

        .mask11{width:496px;height:314px;left:50px;top:136px;background-position: 0px 0px;}
        .mask21{width:433px;height:107px;left:538px;top:218px;background-position: 0px -350px;}
        .mask22{width:306px;height:107px;left:854px;top:218px;background-position: 0px -470px;}

        .mask3 {width:313px;height:116px;top:334px;background-position: 0px -600px;}
        .mask31 {left: 538px;}
        .mask32 {left: 847px;}

        .mask4 {width:265px;height:181px;top:469px;background-position: -500px 0px;}
        .mask41 {left: 116px;}
        .mask42 {left: 375px;}
        .mask43 {left: 633px;}
        .mask44 {left: 893px;}

        .flowed {width:1100px;height:200px;position:absolute;left:122px;top:476px;overflow: hidden;}

        .item {width:261px;height:164px;position:relative;float:left; overflow: hidden; background: transparent url("images/mask-2019-05-30.png") no-repeat -1000px -150px; }
        .itemImg {width:242px;height:158px;position:absolute;left:3px;top:3px;overflow: hidden;}
        .itemImg img{width:100%;height:100%;}

        .barcode {width:1280px;height:720px;position:absolute;left:0px;top:0px;background: transparent url("images/focusBg-2019-05-30-BarCode.png") no-repeat 0px 0px; }
    </style>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
    <div style="background:transparent url('images/bg-2019-05-30.png') no-repeat;width:1280px;height:720px;left:0px;top:0px;position:absolute;"></div>
    <div id="ticket"></div>
    <div class="remainderDays" id="remainderDays"></div>
    <div id='mask'></div>
    <div id='flowed' class='flowed'></div>
    <div id='barcode' class='barcode' style="visibility: hidden;"></div>
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
        moviePos : {width:472,height:290,left:61,top:148},
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.serviceId = 4603;
            cursor.frequency = 1870000;

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

            var current = (new Date()).Format("yyyy-MM-dd hh:mm:ss");

            cursor.focusable[0].items[0].replay = typeof cursor.focusable[0].items[0].isSitcom !== 'undefined' || current >= '2019-03-31 07:15:00' && current <= '2019-03-31 10:30:00';
            cursor.focusable[0].items[0].linkto = '';

            var obj = {items:[
                {name:'回顾',style:'mask mask21',linkto:'/EPG/jsp/neirong/S20190530List.jsp'},
                {name:'抢票',style:'mask mask22'}
            ]};
            cursor.focusable.insertAt(1, obj);
            obj = { focus:this.focused.length > 2 ? Number( this.focused[2] ) : 0,items:
                [
                    {name:'活动',linkto:'/EPG/jsp/neirong/S20190530Act.jsp',style:'mask mask3 mask31'},
                    {name:'功略',linkto:'/EPG/jsp/neirong/S20190530Guide.jsp',style:'mask mask3 mask32'},
                ]};
            cursor.focusable.insertAt(2, obj);
            var startTime = Date.parse("2019-06-05T00:00:00-08:00");
            var currentTime = Date.parse((new Date()).Format('yyyy-MM-dd') + 'T00:00:00-08:00');
            var num = num = currentTime < startTime ? Math.ceil((startTime - currentTime)/(24*3600*1000)) : 0;
            if( num <= 0 ) {
                //ticket
                $("ticket").className = 'mask remainBg2';
            } else {
                $("remainderDays").innerHTML = String(num);
                $("ticket").className = 'mask remainBg1';
            }

            for( var i = 0 ; i < cursor.focusable.length ; i ++ )
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
            cursor.call('showFlowed');
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
        playMovie : function () {
            try{
                if( cursor.focusable[0].items[0].replay ) {
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
        showBarCode:function(){
          cursor.showBared = true;
          $('barcode').style.visibility = 'visible';
          if( iPanel.mediaType == 'P60' ) sysmisc.bringToForeground("web");
        },
        hiddenBarCode:function(){
          cursor.showBared = false;
          $('barcode').style.visibility = 'hidden';
        },
        select: function() {
            if( cursor.fullmode ) return;
            if( cursor.showBared ){ return cursor.call('hiddenBarCode'); }
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked == 0 ) return cursor.call('enterFullMode');
            if( blocked == 1 && focus == 1 ) return cursor.call('showBarCode');
            cursor.call('selectAct');
        },
        goBack : function(){
            if( cursor.fullmode )  return cursor.call('enterSmallMode');
            if ( cursor.showBared ) return cursor.call('hiddenBarCode');
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
            var pageCount = 4;

            if( blocked == 0 && ( index == -1 || index == 11 ) ||
                blocked == 1 && ( index == 11 || index == 1 && focus + 1 >= items.length ) ||
                blocked == 2 && ( index == 1 && focus + 1 >= items.length ) ||
                blocked == 3 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length )) return;
            if( index == 1 ) {
                if( blocked == 0 ){
                    blocked = 1; focus = 0;
                } else {
                    focus += 1;
                }
            } else if( index == -1 ) {
                if( blocked == 1 && focus == 0 || blocked == 2 && focus == 0 ) {
                    blocked = 0;
                } else {
                    focus -= 1;
                }
            } else if( index == 11 ) {
                if( blocked == 3) {
                    blocked = focus <= 1 ? 0 : 2; focus = cursor.focusable[blocked].focus;
                } else if( blocked == 2 ) {
                    blocked = 1;focus = 0;
                }
            } else {
                if( blocked == 1 ) {
                    blocked = 2; focus = cursor.focusable[blocked].focus;
                } else if( blocked == 2 ) {
                    blocked = 3;
                    if( cursor.focusable[blocked].focus >= 2 )
                        focus = cursor.focusable[blocked].focus;
                    else {
                        var sub = 2 - cursor.focusable[blocked].focus;
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
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if(blocked === 3) {
                $("mask").className = "mask mask4 mask4" + (focus <= 1 ? String(focus + 1) : String( focus + 1 == items.length ? 4 : 3 ));
                cursor.call('showFlowed');
            } else {
                var item = items[focus];
                $("mask").className = item.style;
                $("mask").style.visibility = 'visible';
            }
        },
        showFlowed : function(){
            var focus = cursor.focusable[3].focus;
            var items = cursor.focusable[3].items;
            var pageCount = 4;
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
                html += '<div class="mask itemImg"><img src="' + cursor.pictureUrl(item.posters,6) + '"/></div>';
                html += '</div>';
            }
            $("flowed").innerHTML = html;
        },
        counter : function(){
            cursor.call("sendVote",{
                id:444,limit:999,limitPer:999,target:'1',repeat:true
            });
            if( !cursor.focusable[0].items[0].replay ){
                cursor.call("sendVote",{
                    id:445,limit:999,limitPer:999,target:'1',repeat:true
                });
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>