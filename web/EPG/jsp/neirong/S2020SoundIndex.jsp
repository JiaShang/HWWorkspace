<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    infos.add(new ColumnInfo("10000100000000090000000000113783", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000113784", 0, 6));
    infos.add(new ColumnInfo("10000100000000090000000000113791", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000113864", 0, 2));
    inner.special = true;

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="GB18030"/>
    <meta name="page-view-size" content="1280*720"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <style>
        .listBody{width:1280px;height:720px;position:relative; left:0px;top:0px;overflow: hidden;}
        .container,.bg{width:1280px;height:1574px;position:absolute;left:0px;}
        .bg{top:0px; overflow: hidden;}
        .flowed{width:334px;height:222px;left:858px;top:235px;position:absolute;overflow: hidden;}
        .flowed .item{width:334px;height:45px;font-size:20px;color:white;text-align: left;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;line-height:40px;}
        .marqueeItem{line-height:40px;height:45px;width:330px;}
        .adv {width:149px;height:104px;left:1067px;top:61px;position:absolute;overflow: hidden;}
        .mask{position:absolute;background: transparent url("http://192.168.89.23/active/images/mask-2020-Sounds-Index.png") no-repeat 0px 0px; background-position:0px 0px;}

        .image{position:absolute;overflow: hidden;}
        .image1{width:262px;height:214px;left:66px;top:182px;}
        .image2{width:262px;height:214px;left:66px;top:408px;}
        .image3{width:210px;height:121px;left:327px;top:486px;}
        .image4{width:210px;height:121px;left:554px;top:486px;}
        .image5{width:210px;height:121px;left:779px;top:486px;}
        .image6{width:210px;height:121px;left:1008px;top:486px;}
        .image7{width:566px;height:165px;left:65px;top:1314px;}
        .image8{width:566px;height:165px;left:652px;top:1314px;}

        .list{width:1154px;height:379px;left:65px;top:829px;position:absolute;overflow: hidden;}
        .list .item1{width:506px;height:379px;left:0px;top:0px;position:absolute;}
        .list .item2{width:295px;height:170px;left:535px;top:0px;position:absolute;}
        .list .item3{width:295px;height:170px;left:859px;top:0px;position:absolute;}
        .list .item4{width:295px;height:170px;left:535px;top:208px;position:absolute;}
        .list .item5{width:295px;height:170px;left:859px;top:208px;position:absolute;}
        .list .image{width:100%;height:100%;left:0px;top:0px;}
        .list .item1 .textBg{width:506px;height:60px;left:0px;top:319px;background-position: 0px -1020px;}
        .list .item2 .textBg,.list .item3 .textBg,.list .item4 .textBg,.list .item5 .textBg{width:295px;height:40px;position:absolute;left:0px;top:130px;background-position: -600px -1020px;}
        .text{left:10px;top:0px;position:absolute;color:white;text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .list .item1 .text{width:486px;height:60px;line-height:60px;font-size: 24px;}
        .list .item2 .text,.list .item3 .text,.list .item4 .text,.list .item5 .text{width:275px;height:40px;font-size: 20px;line-height:40px;}

        .mask1{width:506px;height:301px;left:320px;top:173px;background-position: 0px -80px;}
        .mask2{width:357px;height:41px;left:847px;background-position: -600px -80px;}
        .mask21{top:234px;}
        .mask22{top:280px;}
        .mask23{top:324px;}
        .mask24{top:369px;}
        .mask25{top:413px;}

        .mask3{width:261px;height:217px;left:56px;background-position:-600px -130px;}
        .mask31 {top:173px;}
        .mask32 {top:398px;}

        .mask4{width:224px;height:135px;top:480px;background-position:-600px -380px;}
        .mask41 {left:320px;}
        .mask42 {left:547px;}
        .mask43 {left:772px;}
        .mask44 {left:1001px;}

        .maskList {width:185px;height:72px;top:707px;}
        .maskList1{left:59px;background-position:0px 0px;}
        .maskList2{left:298px;background-position:-200px 0px;}
        .maskList3{left:532px;background-position:-400px 0px;}
        .maskList4{left:769px;background-position:-600px 0px;}
        .maskList5{left:1001px;background-position:-800px 0px;}

        .mask5{}
        .mask51{width:524px;height:398px;left:56px;top:819px;background-position:0px -400px;}
        .mask52{width:313px;height:189px;left:591px;top:820px;background-position:-600px -550px;}
        .mask53{width:313px;height:189px;left:915px;top:820px;background-position:-600px -550px;}
        .mask54{width:313px;height:189px;left:591px;top:1026px;background-position:-600px -550px;}
        .mask55{width:313px;height:189px;left:915px;top:1026px;background-position:-600px -550px;}

        .mask11{width:582px;height:180px;top:1306px;background-position:0px -820px;}
        .mask111{left:57px;}
        .mask112{left:646px;}

        img{width:100%;height:100%;border:none;}

        .popup {width:1280px;height:720px;position: absolute;left:0px;top:0px;background: transparent url("http://192.168.89.23/active/images/mask-2020-Sounds-Popup.png") no-repeat left top; overflow: hidden;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" bottommargin="0" rightmargin="0" style="overflow:hidden; background:transparent url('http://192.168.89.23/active/images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;z-index:0;width:2500px;height:45px;top:-45px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div id="listBody" class="listBody">
    <div id="container" class="container">
        <div class="bg" id="bg"></div>
        <div class='flowed' id='flowed'></div>
        <div id='maskList'></div>
        <div id='mask'></div>
    </div>
    <div id="popup" style="visibility: hidden;" class="popup"></div>
</div>
<div class="speed" id="speed"></div>
<script typeof="javascript" type="text/javascript">
<!--
window.moviePos = {width:487,height:280,left:329,top:184};
window.appendJS = function(path){
    var script = document.createElement('script');
    script.src = path;
    script.type = 'text/javascript';
    document.getElementsByTagName('head')[0].appendChild(script);
};
var initialize = {
    data: [<%
        String html = "";
        for ( int i = 0; i < infos.size(); i++) {
            ColumnInfo info = infos.get(i);
            inner.special = true;
            Result result = null;
            if( i == 2 ){
                List list = new ArrayList();
                list.add( result = inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength()) );
                List<Column> children = (List<Column>)result.getData();
                for(int j = 0 ; j < children.size(); j ++)
                    list.add(inner.getTypeList( children.get(j).id, 0,1));
                result = new Result(info.typeId, list);
            } else
                result = i == 0 ? inner.getVodList(info.getTypeId(), info.getStation(),info.getLength() ) : inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength());

            html += inner.resultToString(result);
            if( i + 1 < infos.size() ) html += ",\n";
        }
        out.write(html);
    %>],
    focused:[<%= inner.getPreFoucs() %>],
    init : function(){
        cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
        cursor.backUrl='<%= backUrl %>';
        var focused = this.focused;
        var enc = '&enc=1';
        if( iPanel.HD30Adv ) enc = '';
        var interrupt = function( condition ){
            if( !condition ) return false;
            tooltip( decodeURIComponent('%E5%BD%93%E5%89%8D%E4%B8%93%E9%A2%98%E5%B7%B2%E4%B8%8B%E7%BA%BF%E6%88%96%E6%A0%8F%E7%9B%AE%E5%B0%9A%E6%9C%AA%E6%BF%80%E6%B4%BB%EF%BC%8C%E8%AF%B7%E4%B8%8E%E7%BC%96%E8%BE%91%E4%BA%BA%E5%91%98%E8%81%94%E7%B3%BB%EF%BC%8C%E6%8C%89OK%E9%94%AE%E5%90%8E%E9%A1%B5%E9%9D%A2%E9%80%80%E5%87%BA%EF%BC%81') );
            setTimeout(function(){ cursor.call('goBackAct'); },5000);
            return true;
        };
        cursor.popup = false;
        try{
            var html = '';
            //全屏视频框
            cursor.focusable[0] = { items: [], focus : 0, name:'全屏' };
            //精彩视频列表
            var items = this.data[0]["data"], item = undefined, children = null;
            var focus = focused.length > 2 ? Number(focused[2]) : 0;
            cursor.focusable[1] = { items: items, focus : focus, typeId: this.data[0]["id"] };
            cursor.call('showFlowedList');

            //左侧两个稍大点的图片
            var url = 'http://192.168.89.23/active/';
            html = '<div style="width:1280px;height:620px;position:absolute;left:0px;top:0px;"><img src="http://192.168.89.23/active/images/bg-2020-Sounds-Index-1.png"/> </div>' +
                '<div style="width:1280px;height:622px;position:absolute;left:0px;top:619px;"><img src="http://192.168.89.23/active/images/bg-2020-Sounds-Index-2.png"/> </div>' +
                '<div style="width:1280px;height:334px;position:absolute;left:0px;top:1240px;"><img src="http://192.168.89.23/active/images/bg-2020-Sounds-Index-3.png"/> </div>';

            //页面中的广告
            //var adv = cursor.pictureUrl(rst.column.posters, 5, '');
            //if( !adv.isEmpty() ) html += '<div class="adv"><img src="' + adv + '/></div>';

            items = [];
            children = this.data[1]["data"];
            item = children[0];
            item.linkto = '';  //好声音周边 url +
            items.push(item);
            html += '<div class="image image1"><img src="' + cursor.pictureUrl(item.posters, 1, 'http://192.168.89.23/active/images/defaultImg.png') + '" /></div>';
            item = children[1];  //明星学员
            item.linkto = url + 'act2020StudentStar.html?typeId=' + item.id;
            items.push(item);
            html += '<div class="image image2"><img src="' + cursor.pictureUrl(item.posters, 1, 'http://192.168.89.23/active/images/defaultImg.png') + '" /></div>';
            focus = focused.length > 3 ? Number(focused[3]) : 0;
            cursor.focusable[2] = { items: items, focus : focus };

            //第一屏，下面4个图片位
            items = [];
            for( var i = 2; i < children.length ; i ++){
                item = children[i];
                switch (i) {
                    case 2:item.linkto = url + 'act2020SoundIntro.html?typeId=' + item.id;break;//赛事介绍
                    case 3:item.linkto = ''; break;//url + 'act2020SoundTeacher.html?typeId=' + item.id;break;//明星导师
                    case 4:item.linkto = url + 'act2020SoundHistory.html?typeId=' + item.id;break;//往届赛事
                    case 5:item.linkto = url + 'act2020SoundJoinUs.html'; break;//报名入口
                    default: item.linkto = ''; break;
                }
                items.push(item);
                html += '<div class="image image' + String( i + 1 ) + '"><img src="' + cursor.pictureUrl(item.posters, 1, 'http://192.168.89.23/active/images/defaultImg.png') + '" /></div>';
            }
            focus = focused.length > 4 ? Number(focused[4]) : 0;
            cursor.focusable[3] = { items: items, focus : focus };

            //第二屏，栏目名称
            items = this.data[2]['data'][0]['data'], children = this.data[2]['data'];
            var vodIds = '';
            focus = focused.length > 5 ? Number(focused[5]) : 0;
            //第四个列表记录了比赛全程下面的全部子栏目中的栏目数据
            cursor.focusable[4] = { items: items, focus : focus };
            //栏目数固定为5个
            html += '<div id="list" class="list"></div>';
            for( var i = 0; i < 5; i ++ ){
                if( i < items.length ) {
                    item = items[i];
                    vodIds += children[i + 1]['data'][0]['id'] + ",";
                } else
                    item = {name :'尚未激活'};
                cursor.focusable[5 + i] = { items: [], focus:focused.length > 6 + i ? Number(focused[6 + i]) : 0, name:item.name };
            }
            setTimeout(function(){
                var uri = EPGUrl + '/neirong/player/detail.jsp?id=' + vodIds + '&act=1' + enc + '&fn=5';
                ajax( uri , function( rst ){
                    //返回结果最少有5个列表
                    try {
                        list = rst.data;
                        var constI = 5;
                        for( var i = 0 ; i < 5; i ++ ){
                            if( i < list[0].length ){
                                var column = list[0][i];
                                typeId = column.id;
                                items = list[i + 1]['data'];
                                if( items.length == 5 ){
                                    switch (i) {
                                        case 0:
                                            items[items.length - 1].linkto = url + 'act2020SoundShow.html?typeId=' + column.id;
                                            items[items.length - 1].name = '';
                                            break;
                                        case 1:items[items.length - 1].linkto = ''; break;
                                        case 2:items[items.length - 1].linkto = ''; break;
                                        case 3:items[items.length - 1].linkto = ''; break;
                                        case 4:items[items.length - 1].linkto = ''; break;
                                    }
                                }
                                cursor.focusable[constI].items = items;
                                cursor.focusable[constI].typeId = typeId;
                                cursor.focusable[constI ++].available = true;
                                //默认进入最新的赛程
                                if( focused.length == 0 ) cursor.focusable[4].focus = constI - 6;
                            } else {
                                cursor.focusable[constI ++].available = false;
                            }
                        }
                        cursor.call('showList');
                    } catch(e){}
                });
            },50);

            //最后两个专题图位
            items = this.data[3]['data'];
            if(typeof items[0].linkto == 'undefined') items[0].linkto = '';
            if(typeof items[1].linkto == 'undefined') items[1].linkto = '';
            focus = focused.length > 11 ? Number(focused[11]) : 0;
            html += '<div class="image image' + String( 7 ) + '"><img src="' + cursor.pictureUrl(items[0].posters, 1, 'http://192.168.89.23/active/images/defaultImg.png') + '" /></div>';
            html += '<div class="image image' + String( 8 ) + '"><img src="' + cursor.pictureUrl(items[1].posters, 1, 'http://192.168.89.23/active/images/defaultImg.png') + '" /></div>';
            cursor.focusable[10] = { items: items, focus : focused.length > 11 ? Number(focused[11]) : 0 };
            $('bg').innerHTML = html;
        } catch (e) {
            return interrupt( true )
        }
        player.status = player.STOP;
        try {
            if( cursor.blocked <= 3 ) cursor.call('lazyShow', {isLoad: true} );
            cursor.call('show');
        } catch( e ) {}
    },
    showFlowedList:function(){
        var items = cursor.focusable[1].items;
        var html = '';
        for( var i = 0; i < items.length; i ++ ) {
            var item = items[i];
            html += '<div class="item" id="item2' + String( i + 1) + '">' + item.name.replace(new RegExp(decodeURIComponent("(%5C(%7C%EF%BC%88).*%3F(%5C)%7C%EF%BC%89)%24")),"") + '</div>';
        }
        $('flowed').innerHTML = html;
    },
    showList:function(){
        var blocked = 4;
        var focus = cursor.focusable[blocked].focus;
        $("maskList").className = "mask maskList maskList" + String( focus + 1 );
        blocked = focus + 5;
        var items = cursor.focusable[blocked].items;
        var html = '';
        for( var i = 0; i < items.length; i++){
            var item = items[i];
            html += '<div class="item' + String( i + 1) + '"><div class="image"><img src="' + cursor.pictureUrl(item.posters, 1, 'http://192.168.89.23/active/images/defaultImg.png') + '"/></div>';
            if( i < 4 ) html += '<div class="mask textBg"><div id="item' + String( blocked + 1 ) +   + String( i + 1) + '" class="text">' + item.name.replace(new RegExp(decodeURIComponent("(%5C(%7C%EF%BC%88).*%3F(%5C)%7C%EF%BC%89)%24")),"") +  '</div></div>';
            html += '</div>';
        }
        $('list').innerHTML = html;

    },
    scrollText:function(o){
        var blocked = o.blocked || cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        var name = o.name;
        cursor.calcStringPixels(name, 20, function(width){
            if( blocked != cursor.blocked && focus != cursor.focusable[blocked].focus ) return;
            if( cursor.blocked >= 4 && cursor.blocked <= cursor.focusable.length - 1 && width < ( focus == 0 ? 486 : 275 ) || blocked <= 3 && width < 334 ) return;
            $("item" + String( cursor.blocked <= 3 ? 2 : cursor.blocked + 1 ) + String( o.focus + 1 )).innerHTML = '<marquee class="marqueeItem" scrollamount="8">' + name + '</marquee>';
        });
    },
    playMovie : function(item){
        if( typeof item === 'undefined' )return;
        try{
            player.exit();
            player.play( {vodId: item.id, callback : function(){
                if( cursor.fullmode || cursor.blocked != 1) return;
                cursor.call('show');
                cursor.call('scrollText', {name: item.name.replace(new RegExp(decodeURIComponent("(%5C(%7C%EF%BC%88).*%3F(%5C)%7C%EF%BC%89)%24"), "gi"), ""), focus : cursor.focusable[cursor.focusable[0].focus + 1].focus});
            }} );
        } catch (e){ }
    },
    goBack : function(){
        if( cursor.popup ) { return cursor.call('hiddenPop');}
        if( cursor.fullmode ){
            cursor.call("enterSmallMode");
            $("listBody").style.visibility = 'visible';
            cursor.call("show");
            if( cursor.blocked == 1 ){
                var blocked = 1;
                var focus = cursor.focusable[blocked].focus;
                var item = cursor.focusable[blocked].items[focus];
                cursor.call('scrollText', {name: item.name.replace(new RegExp(decodeURIComponent("(%5C(%7C%EF%BC%88).*%3F(%5C)%7C%EF%BC%89)%24"), "gi"), ""), focus : focus});
            }
            return;
        }
        cursor.call('goBackAct');
    },
    interval : function(){
        if( cursor.fullmode && cursor.speed === 1 ) {
            var elapsed = 6 - cursor.elapsedSeconds();
            if( elapsed <= 0 ) {
                $("speed").style.visibility = 'hidden';
                return;
            }
        }
        $("speed").innerHTML = cursor.speed == 1 ? "播放" : "x" + ( Math.abs(cursor.speed) + " "  + ( cursor.speed > 0 ? "快进 " : "快退 " )) ;
        $("speed").style.visibility = cursor.fullmode ? 'visible' : 'hidden';
    },
    enterFullMode : function(){
        cursor.fullmode = true;
        cursor.call('resumePlay');
        $("listBody").style.visibility = 'hidden';
        $("mask").style.visibility = 'hidden';
        player.fullScreen();
        player.starter = new Date().getTime();
        cursor.timer = setInterval(function(){cursor.call('interval');},1000);
    },
    enterSmallMode : function(){
        cursor.fullmode = false;
        player.setPosition(moviePos.left,moviePos.top,moviePos.width,moviePos.height);
        $("listBody").style.visibility = 'visible';
        $("mask").style.visibility = 'visible';
        cursor.call('resumePlay',true);
        if( cursor.timer ) {
            clearInterval(cursor.timer);
            cursor.timer = undefined;
            $("speed").style.visibility = 'hidden';
        }
    },
    resumePlay : function(resume){
        cursor.starter = new Date().getTime();
        if( resume ) { cursor.speed = 1; player.resume(); }
    },
    stop : function(){
        player.setPosition(1279,719,1,1);
        player.exit();
        cursor.fullmode = false;
    },
    pausePlay : function(){
        player.setPosition(1279,719,1,1);
        player.pause();
    },
    continuePlay : function(){
        player.setPosition(moviePos.left,moviePos.top,moviePos.width,moviePos.height);
        player.resume();
    },
    showPop:function() {
        cursor.popup = true;
        if( cursor.blocked <= 3 ) cursor.call('pausePlay');
        $("popup").style.visibility = 'visible';
    },
    hiddenPop:function(){
        cursor.popup = false;
        if( cursor.blocked <= 3 ) cursor.call('continuePlay');
        $("popup").style.visibility = 'hidden';
    },
    select: function() {
        if( cursor.focusable.length <= 0 ) return;
        if( cursor.fullmode ) { if(cursor.speed != 1 ) cursor.call('resumePlay',true);return;}
        if( cursor.popup ) { return cursor.call('hiddenPop');}
        if( cursor.blocked == 0 ) { return cursor.call("enterFullMode"); }
        var blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        var items = cursor.focusable[blocked].items;
        var item = items[focus];
        var id = String(blocked + 1) + String( focus + 1 );

        if( typeof item.linkto == 'string' ){
            if (item.linkto != '') return cursor.call('selectAct') ;
            return cursor.call('showPop');
        }

        if( cursor.moveTimer ) cursor.call('clearMoveTimer');
        cursor.call("enterFullMode");
        if( cursor.played != id && cursor.blocked >= 1 ) {
            cursor.played = id;
            return cursor.call("playMovie", item);
        }
    },
    nextVideo : function ( ){
        alert(cursor.fullmode + ':' + cursor.blocked);
        if( cursor.fullmode && cursor.blocked != 0 && cursor.blocked != 1 ) {
            player.exit();
            player.status = player.STOP;
            cursor.fullmode = false;
            $("listBody").style.visibility = 'visible';
            $("mask").style.visibility = 'visible';
            cursor.call('show');
            return;
        }
        if( ! cursor.moveTimer ) {
            var blocked = 1;
            var playIndex = cursor.focusable[blocked].focus;
            playIndex = playIndex + 1 < cursor.focusable[blocked].items.length ? playIndex + 1 : 0;
            cursor.focusable[blocked].focus = cursor.playIndex = playIndex;
            if( !cursor.fullmode ) {
                cursor.call( 'lazyShow', {isLoad: true});
            } else {
                cursor.played = "1" + String( playIndex + 1);
                cursor.call("playMovie", cursor.focusable[blocked].items[playIndex]);
            }
        }
    },
    prepareVideo : function(){
        var blocked = 1;
        var playIndex = cursor.playIndex;
        if( cursor.focusable[blocked].items.length <= 0 )return;
        var item = cursor.focusable[blocked].items[playIndex];
        cursor.call("playMovie",item);
    },
    move : function(index){
        //上 11，下 -11，左 -1，右 1
        if( cursor.popup ) return;
        if( cursor.fullmode ) {
            if( index === 11 || index == -11 ) return;
            if( index == -1 && cursor.speed > -32) {
                cursor.speed = cursor.speed >= 1 ? -2 : Math.abs(cursor.speed) * -2;
                player.backward(cursor.speed);
            } else if( index == 1 && cursor.speed < 32 ){
                cursor.speed = cursor.speed <= 1 ? 2 : Math.abs(cursor.speed) * 2;
                player.forward(cursor.speed);
            }
            cursor.call('resumePlay');
            return;
        }

        var blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        var items = cursor.focusable[blocked].items;

        if(
            blocked == 0 && index == 11 || blocked == 1 && ( index == 1 || index == 11 && focus <= 0 ) ||
            blocked == 2 && ( index == -1 || index == 11 && focus <= 0 ) || blocked == 3 && index == 1 && focus + 1 >= items.length ||
            blocked == cursor.focusable.length - 1 && ( index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length || index == -11 )
        ) return;
        if( blocked == 0 ) {
            if( index == 1 ) blocked = 1;
            else blocked = index == -1 ? 2 : 3;
            focus = cursor.focusable[blocked].focus;
        } else if( blocked === 1 || blocked === 2 ) {
            if( index == 11 || index == -11 ) {
                focus += index > 0 ? -1 : 1;
                if( focus >= items.length ) {
                    blocked = blocked == 1 ? 3 : cursor.focusable[4].focus + 5;
                    focus = cursor.focusable[blocked].focus;
                }
            } else {
                blocked = blocked == 2 && focus == 1 ? 3 : 0; focus = 0;
            }
        } else if( blocked === 3 || blocked === cursor.focusable.length - 1){
            if( index == -1 || index == 1) {
                focus += index;
                if( focus < 0 ) {
                    blocked = 2; focus = 1;
                }
            } else {
                blocked = index == 11 && blocked == 3 ? ( focus <= 1 ? 0 : 1  ) : cursor.focusable[4].focus + 5;
                focus = cursor.blocked == cursor.focusable.length - 1 && focus == 0 ? 0 : cursor.focusable[blocked].focus;
            }
        } else {
            if( index == 11 ) {
                if(  focus >= 3 ) focus -= 2;
                else {
                    if( focus == 0 ) {
                        blocked = 2; focus = 1;
                    } else {
                        blocked = 3;
                        focus = focus == 1 ? 0 : 2;
                    }
                }
            } else if( index == -11 ) {
                if( focus == 1 || focus == 2 ) focus += 2;
                else {
                    blocked = cursor.focusable.length - 1;
                    focus = focus == 0 ? 0 : 1;
                }
            } else if( index == 1 ) {
                if( focus == 0 || focus == 1 || focus == 3 ){
                    focus += 1;
                } else {
                    blocked += 1;
                    if( !cursor.focusable[blocked].available ) return;
                    cursor.blocked = blocked; cursor.focusable[4].focus += 1;
                    focus = 0;
                    setTimeout(function () { cursor.call('showList') },30);
                }
            } else {
                if( focus == 3 ) {
                    focus = 0;
                } else if( focus == 0 ) {
                    if( blocked == 5 ) return;
                    cursor.blocked = blocked -= 1;
                    cursor.focusable[4].focus -= 1;
                    focus = 2;
                    setTimeout(function () { cursor.call('showList') },30);
                } else focus -= 1;
            }
        }
        cursor.blocked = blocked;
        cursor.focusable[blocked].focus = focus;
        cursor.call('clearMoveTimer');
        cursor.moveTimer = setTimeout(function(){ cursor.call('clearMoveTimer');if(cursor.blocked <= 3 )cursor.call('lazyShow');}, 1500);
        cursor.call('show');
    },
    clearMoveTimer : function(){
        if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
        cursor.moveTimer = undefined;
    },
    lazyShow : function( option ){
        var blocked = 1;
        var focus = cursor.focusable[blocked].focus;
        var id = String(blocked + 1) + String( focus + 1 );
        option = option || {'isLoad' : false};
        var isLoad = option.isLoad;
        if(player.status == decodeURIComponent('%E5%81%9C%E6%AD%A2')) {cursor.call('enterSmallMode');}
        if(( cursor.blocked == 1 || isLoad && cursor.blocked <= 3 ) && cursor.played != id ) {
            cursor.playIndex = focus;
            cursor.call('prepareVideo');
            cursor.played = id;
        } else if(cursor.blocked == 1 ||  cursor.blocked >= 5 && cursor.blocked < cursor.focusable.length - 1 ){
            blocked = cursor.blocked;
            focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            cursor.call('scrollText',{name: text.replace(new RegExp(decodeURIComponent("(%5C(%7C%EF%BC%88).*%3F(%5C)%7C%EF%BC%89)%24"), "gi"), ""), focus : focus, blocked: blocked})
        }
    },
    show: function(){
        var blocked = cursor.blocked ;
        if( blocked <= 3 ) {
            $("container").style.top = '0px';
            cursor.call('showFlowedList');
            if( player.status != decodeURIComponent('%E6%92%AD%E6%94%BE') ) {
                cursor.call( (player.status == decodeURIComponent('%E5%81%9C%E6%AD%A2') ? 'lazyShow' : 'continuePlay') , {'isLoad': true})
            }
        } else if( blocked < cursor.focusable.length - 1 ) {
            $("container").style.top = '-600px';
            cursor.call('showList');
            if( player.status == decodeURIComponent('%E6%92%AD%E6%94%BE') ) cursor.call('pausePlay');
        } else {
            $("container").style.top = '-854px';
            if( player.status == decodeURIComponent('%E6%92%AD%E6%94%BE') ) cursor.call('pausePlay');
        }
        if( cursor.blocked == 4 ) {
            $("mask").style.visibility = 'hidden';
        } else {
            var mask = '';
            if ( blocked <= 3 || blocked == cursor.focusable.length - 1) {
                mask = 'mask' + String( blocked + 1);
            } else {
                mask = 'mask5'
            }
            if(blocked != 0) mask += ' ' + mask + String(cursor.focusable[blocked].focus + 1);
            $('mask').className = 'mask ' + mask;
            $("mask").style.visibility = 'visible';
        }
    }
};
var lazied = function(t){
    if( typeof window.cursor == 'undefined') {
        if( t < 7000 ) {
            setTimeout( function () { lazied( t + 100 ); }, 100 );
            return;
        }
        tooltip( decodeURIComponent('%E8%84%9A%E6%9C%AC%E6%96%87%E4%BB%B6%E5%8A%A0%E8%BD%BD%E5%A4%B1%E8%B4%A5%EF%BC%8C%E8%AF%B7%E6%A3%80%E6%9F%A5%E6%9C%BA%E9%A1%B6%E7%9B%92%E7%BD%91%E7%BB%9C%E6%98%AF%E5%90%A6%E7%95%85%E9%80%9A%EF%BC%81') );
        return setTimeout(function(){ cursor.call('goBackAct'); },5000);
    }
    cursor.initialize(initialize);
};
lazied(0);
-->
</script>
</body>
</html>
