<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId )) typeId = "10000100000000090000000000109241";//10000100000000090000000000109775
    infos.add(new ColumnInfo(typeId, 1, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);

    List<Vod> vods = inner.getList(typeId,1,0,new Vod());
    String vodId = "";
    if( vods != null && vods.size() > 0 ) {
        vodId = String.valueOf(vods.get(0).getId());
    }

    int focus = 0;
%>
<html>
<head>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%=column == null ? "" : column.getName()%></title>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2018-03-19.png') no-repeat;background-position: 0px 0px;}
        .maskNone{width:1px;height:1px;left:-1px;top:-1px;}
        .remainderDays {width:116px;height:97px;left:769px; top:137px; color:white;font-size:84px;text-align: center; overflow: hidden;line-height: 97px; position:absolute;}


        .flowed {width:1100px;height:200px;position:absolute;left:104px;top:500px;overflow: hidden;}

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
<div style="background:transparent url('images/bg-2018-07-03.png') no-repeat;width:1280px;height:720px;left:0px;top:0px;position:absolute;"></div>
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

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].focus = this.focused.length > 1 ? Number(this.focused[1]) : 0;
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
            }
            setTimeout("cursor.call('playMovie')",50);
            cursor.call('showFlowed');
        },
        playMovie : function () {
            player.play({
                position: {left:55, top:73, width:595, height:405},
                vodId : <%=vodId%>
            });
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index === 11 || index === -11 || index === -1 && focus <= 0 || index === 1 && focus + 1 >= items.length)) return;
            if( blocked === 0 ) {
                focus += index;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('showFlowed');
        },
        nextVideo : function (){
            cursor.call('playMovie');
        },
        showFlowed : function(){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            var pageCount = 5;
            //每页显示数量
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item">';
                html += '<div class="mask itemImg"><img src="' + cursor.pictureUrl(item.posters,1) + '"/></div>';
                html += '<div class="mask ' + ( ( i == focus && cursor.blocked == 0 ) ? "itemFocus" : "itemMask" )  + '"></div>';
                html += '<div class="itemText" id="txt' + ( i + 1) + '">' + item.name + '</div>';
                html += '</div>';
            }
            $("flowed").innerHTML = html;
            (function(id,value){
                cursor.calcStringPixels(value, 20, function(pixelsWidth){
                    var innerHTML = pixelsWidth > 209 ? ('<marquee class="maskMarquee" scrollamount="10">' + value + "</marquee>") : value ;
                    $(id).innerHTML = innerHTML;
                });
            })('txt' + (focus + 1),items[focus].name);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>