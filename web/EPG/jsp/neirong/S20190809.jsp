<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    infos.add(new ColumnInfo("10000100000000090000000000112302", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000112309", 0, 2));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail("10000100000000090000000000112301",column);
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-08-09.png') no-repeat;background-position: 0px 0px;}
        .flowed {width:1280px;height:720px;left:0px;top:0px;position:absolute;}

        .list{width:440px;height:340px;left:130px;top:217px;position:absolute;}
        .ItemContainer,.ItemContainerFocus{width:440px;height:61px;float:left;overflow: hidden;background-position: 0px 0px;}
        .ItemContainer {position:relative;}
        .ItemContainerFocus {background:transparent url('images/mask-2019-08-09.png') no-repeat;background-position:0px 0px;height:74px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;position:absolute;left:182px;}

        .ItemContainer .item,.ItemContainerFocus .item,.ItemContainer .item .marquee {width:400px;height:61px;line-height:50px;font-size: 20px;position:absolute;}
        .ItemContainer .item {color:black;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;left:30px;}
        .ItemContainerFocus .item {color:red;left:30px;line-height:70px;}
        .icon {position:absolute;left:0px;width:30px;height:61px;top:0px;background:transparent url('images/mask-2019-08-09.png') no-repeat;background-position: -840px -129px;}

        .image2 {position:absolute;width:570px;left:618px;}
        .image21 {height:217px;top:169px;}
        .image22 {height:125px;top:402px;}

        .image3{width:211px;height:107px;top:548px;position:absolute;}
        .image31 {left:75px;}
        .image32 {left:300px;}
        .image33 {left:524px;}
        .image34 {left:749px;}
        .image35 {left:974px;}
        img {width:100%;height:100%}

        .mask1 {width:500px;height:74px;left:97px; background-position:0px -100px;}
        .mask11 {top:206px;}
        .mask12 {top:267px;}
        .mask13 {top:328px;}
        .mask14 {top:389px;}
        .mask15 {top:450px;}

        .mask2 {width:591px;left:607px;}
        .mask21 {height:238px; top:157px; background-position:0px -200px;}
        .mask22 {height:147px; top:391px; background-position:-600px -250px;}

        .mask3 {width:229px;height:134px;top:538px; background-position:-600px -100px;}
        .mask31 {left:65px;}
        .mask32 {left:290px;}
        .mask33 {left:515px;}
        .mask34 {left:740px;}
        .mask35 {left:965px;}

        .mask4 {width:86px;height:58px;left:512px;top:167px; background-position:-500px -100px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-08-09.png') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="list" class="list"></div>
<div id="flowed" class="flowed"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                Result result = null;
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    inner.special = i == 1;
                    result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    html += ",\n";
                }
                inner.special = true;
                result = inner.getTypeList( "10000100000000090000000000112301", 2, 5);
                html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.consigned = [];
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[1].items = cursor.focusable[1].items || [];
            for( var i = cursor.focusable[1].items.length; i < 2; i++) cursor.focusable[1].items.push({"name":"连接专题","generated":"true"});
            for( var i = 0; i < cursor.focusable[2].items.length; i++) {
                if( typeof cursor.focusable[2].items[i].linkto == 'string' ) continue;
                cursor.focusable[2].items[i].linkto = "/EPG/jsp/neirong/S20190809Txt.jsp?typeId=" + cursor.focusable[2].items[i].id;
            }
            cursor.focusable[3] = {focus: 0, items: [{"name":"更多","linkto":"/EPG/jsp/neirong/S20190809Txt.jsp?typeId=" + cursor.focusable[0].typeId }]};
            if( this.focused.length > 0 ) cursor.consigned[0] = this.focused[this.focused.length -1];
            cursor.call('showUI');
            cursor.call('show');
            setTimeout(function(){cursor.call('lazyShow');}, 40);
            setTimeout(function(){cursor.call('counter')}, 100);
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var previous = blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked == 0 && ( index == -1 ) ||
                blocked == 1 && ( index == 1 || index == 11 && focus <= 0 ) ||
                blocked == 2 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length ) ||
                blocked == 3 && ( index == -1 || index == 11)
              ) return;

            if( blocked == 0 ) {
                if( index == 1 ) {
                    blocked = 1 ; focus = cursor.focusable[blocked].focus;
                } else if( index == 11 ) {
                    focus -= 1;
                    if( focus < 0 ) {  blocked = 3 ; focus = cursor.focusable[blocked].focus; }
                } else {
                    focus += 1;
                    if( focus >= items.length ) { cursor.consigned[0] = blocked; blocked = 2 ; focus = cursor.focusable[blocked].focus; }
                }
            } else if( blocked == 1) {
                if( index == -1 ) {
                    blocked = 0 ; focus = cursor.focusable[blocked].focus;
                } else if( index == 11 ) {
                    focus -= 1;
                } else {
                    focus += 1;
                    if( focus >= items.length ) {  cursor.consigned[0] = blocked; blocked = 2 ; focus = cursor.focusable[blocked].focus; }
                }
            } else if( blocked == 2) {
                if( index == 11 ) {
                    blocked = typeof cursor.consigned[0] == 'undefined' ? 0 : cursor.consigned[0];
                    focus = cursor.focusable[blocked].focus;
                } else {
                    focus += index;
                }
            } else {
                blocked = index == -11 ? 0 : 1;
                focus = cursor.focusable[blocked].focus;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.moveTimer = undefined;cursor.call('lazyShow');}, 1300);
            if( previous == 0 || blocked == 0 ) cursor.call('showItems');
            cursor.call('show');
        },
        lazyShow : function(){
            var blocked = cursor.blocked;
            if( blocked != 0 ) return;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            cursor.calcStringPixels(text, 20, function(width){
                if( blocked != cursor.blocked || width <= 400 ) return;
                $('item' + (focus + 1)).innerHTML  = '<marquee class="marquee" scrollamount="8">' + text + "</marquee>";
            });
        },
        showItems     :   function(){
            var blocked = 0;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[blocked].focus;

            //每页显示数量
            var pageCount = 5;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '', id = '';
            var container = 'list';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='ItemContainer' id='txt" + ( i - flowCursorIndex + 1 ) + "'>";
                html += "<div class='icon'></div>";
                html += "<div class='item' id='item" +  String( i - flowCursorIndex + 1 ) + "'>" + item.name;
                html += "</div></div>";
            }
            $(container).innerHTML = html;
        },
        showUI        :   function(){
            cursor.call("showItems");
            var html = "";
            for( var blocked = 1; blocked < 3; blocked ++){
                var items = cursor.focusable[blocked].items;
                for( var i = 0; i < items.length ; i ++){
                    html += '<div class="image' + String(blocked + 1) + ' image' + String(blocked + 1) + String( i + 1) + '">';
                    html += '<img src="' + cursor.pictureUrl(items[i].posters, 2, 'images/defaultImg.png') +  '"/>';
                    html += '</div>';
                }
            }
            $("flowed").innerHTML = html;
        },
        select      :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var item = items[focus];
            if( typeof item.generated != 'undefined' ) return;
            cursor.call('selectAct');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = 'mask mask' + String(blocked + 1) + " mask" + String(blocked + 1) + String( ( blocked == 0 ? focus % 5 : focus ) + 1 );
        },
        counter : function(){
            try {
                cursor.call("sendVote",{
                    id:461,limit:9999,limitPer:9999,target:'+1',repeat:true
                });
            } catch (e) {}
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>