<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    infos.add(new ColumnInfo("10000100000000090000000000109461", 0, 1));
    infos.add(new ColumnInfo("10000100000000090000000000109464", 0, 99));

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
        .bgTop{position:absolute;width:1280px;height:138px;left:0px;top:0px;background:transparent url('images/bg-2018-04-28-top.jpg') no-repeat left top;}
        .bgMiddle{position:absolute;width:1280px;height:322px;left:0px;top:138px;background:transparent url('images/bg-2018-04-28-middle.png') no-repeat left top;}
        .bgBottom{position:absolute;width:1280px;height:260px;left:0px;top:460px;background:transparent url('images/bg-2018-04-28-bottom.jpg') no-repeat left top;}
        .mask {position:absolute;border:none;background:transparent url('images/mask-2018-03-19.png') no-repeat;background-position: 0px 0px;}
        .maskNone{width:1px;height:1px;left:-1px;top:-1px;}

        .mask11{width:76px;height:76px;left:263px;top:280px;background-position: -220px 0px;}

        .mask2{position:absolute;border:solid 8px red; background: transparent none no-repeat;background-position: 300px 300px;}
        .mask21{width:231px;height:150px;left:562px;top:132px;}
        .mask22{width:231px;height:150px;left:788px;top:132px;}
        .mask23{width:231px;height:150px;left:1017px;top:132px;}
        .mask24{width:232px;height:160px;left:561px;top:300px;}
        .mask25{width:232px;height:160px;left:789px;top:300px;}
        .mask26{width:232px;height:160px;left:1018px;top:300px;}

        .flowed {width:1100px;height:200px;position:absolute;left:104px;top:486px;overflow: hidden;}

        .item {width:219px;height:199px;position:relative;float:left; overflow: hidden;}
        .itemImg {width:208px;height:137px;position:absolute;left:1px;top:1px;overflow: hidden;}
        .itemImg img{width:208px;height:137px;}
        .itemMask,.itemFocus{width:210px;height:139px;position:absolute;left:0px;top:0px;overflow: hidden;}
        .itemMask {background-position: 0px 0px;}
        .itemFocus {background-position: 0px -140px;}
        .itemText {width:209px;height:40px;position:absolute;color:#333;font-size:20px;left:2px;top:150px;text-align:left;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
    </style>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div class="bgTop"></div><div class="bgMiddle"></div><div class="bgBottom"></div>
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
            /*此频点是重庆卫视高清*/
            cursor.serviceId = 4603;
            cursor.frequency = 1870000;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[0].focus = 0;
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

            var obj = { focus:this.focused.length > 1 ? Number( this.focused[1] ) : 0,items:
                [
                    {name:'塞事详请',linkto:'/EPG/jsp/neirong/S20180428Detail.jsp',style:'mask mask2 mask21'},
                    {name:'龙乡铜梁',linkto:'/EPG/jsp/neirong/STemplateOneTextColumn.jsp?typeId=10000100000000090000000000109462&lt=580&tp=110&w=540&ih=39&mr=16&fs=22&hm=1&al=0&pg=10&bc=C51F00&fc=FFFFFF&cl=ffffff&sc=1160,110,530,8e8e8e,e03034',style:'mask mask2 mask22'},
                    {name:'开州马拉松',linkto:'/EPG/jsp/neirong/STemplateOneTextColumn.jsp?typeId=10000100000000090000000000109463&lt=580&tp=110&w=540&ih=39&mr=16&fs=22&hm=1&al=0&pg=10&bc=C51F00&fc=FFFFFF&cl=ffffff&sc=1160,110,530,8e8e8e,e03034',style:'mask mask2 mask23'},
                    {name:'跑前拉伸',linkto:'http://192.168.35.153:8080/program_theme_9.jsp?id=76&type=9&lcn=2',style:'mask mask2 mask24'},
                    {name:'助力运动消耗',linkto:'http://192.168.35.153:8080/program_theme_9.jsp?id=75&type=9&lcn=1',style:'mask mask2 mask25'},
                    {name:'体能与赛后拉伸',linkto:'http://192.168.35.153:8080/program_theme_9.jsp?id=77&type=9&lcn=3',style:'mask mask2 mask26'}
                ]};
            cursor.focusable.insertAt(1, obj);

            for( var i = 0 ; i < cursor.focusable.length ; i ++ )
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;

            setTimeout("cursor.call('counter')",500);
            setTimeout("cursor.call('playMovie')",50);
            cursor.call('showFlowed');
            cursor.call('show');
        },
        playMovie : function () {
            try{
                media.video.setPosition(37,138,520,322);
                if( cursor.focusable[0].items[0].replay ) {
                    var id = cursor.focusable[0].items[0].id;
                    var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + id + "&contentType=0&business=1&baseFlag=0";
                    ajax(rtspUrl,function(result){
                        if( result.playFlag === "1"){
                            var rtsp = result.playUrl.split("^")[4];
                            media.AV.open(rtsp,"VOD");
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
                blocked == 1 && ( index === 11 && focus <= 2 || index === 1 && focus % 3 === 2 ) ||
                blocked == 2 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length )) return;
            if( index == 1 ) {
                if( blocked == 0 ){
                    blocked = 1; focus = 0;
                } else {
                    focus += 1;
                }
            } else if( index == -1 ) {
                if( blocked == 1 && focus % 3 == 0 ) {
                    blocked = 0; focus = 0;
                } else {
                    focus -= 1;
                }
            } else if( index == 11 ) {
                if( blocked == 1 ) {
                    focus -= 3;
                } else if( blocked == 2 ) {
                    if( focus <= 1 ) {
                        blocked = 0; focus = 0;
                    } else {
                        blocked = 1; focus = focus % 5 + 1;
                    }
                }
            } else {
                if( blocked == 1 && focus >= 3 ) {
                    blocked = 2; focus = cursor.focusable[blocked].focus;
                } else if( blocked == 1 ) {
                    focus += 3;
                } else if( blocked == 0 ) {
                    blocked = 2;
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
            if( previousBlocked === 2 && previousBlocked !== blocked )
                cursor.call('showFlowed');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if(blocked === 2) {
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
            var focus = cursor.focusable[2].focus;
            var items = cursor.focusable[2].items;
            var pageCount = 5;
            //每页显示数量
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item">';
                html += '<div class="mask itemImg"><img src="' + cursor.pictureUrl(item.posters,1) + '"/></div>';
                html += '<div class="mask ' + ( ( i == focus && cursor.blocked == 2 ) ? "itemFocus" : "itemMask" )  + '"></div>';
                html += '<div class="itemText" id="txt' + ( i + 1) + '">' + item.name + '</div>';
                html += '</div>';
            }
            $("flowed").innerHTML = html;
            if( cursor.blocked == 2 )
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
            var liveId = typeof iPanel.eventFrame.systemId === 'undefined' ? 413 : 412;
            var replayId = !cursor.focusable[0].items[0].replay ? (typeof iPanel.eventFrame.systemId === 'undefined' ? 415 : 414) : 0;
            (function(liveId, replayId){
                cursor.call("sendVote",{
                    id:liveId,limit:999,limitPer:999,target:'1',repeat:true
                });
                if( replayId !== 0 ) {
                    setTimeout(function(){
                        cursor.call("sendVote",{
                            id:replayId,limit:999,limitPer:999,target:'1',repeat:true
                        })
                    },100);
                }
            })(liveId,replayId );
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>