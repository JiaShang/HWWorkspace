<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo("10000100000000090000000000105268", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000105269", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000105270", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000105271", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000105272", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000105273", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000105274", 0, 5));
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>最强综艺收录</title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2015-06-11.png') no-repeat;background-position: 0px 0px;}

        .flowedContainer{width:1280px;height: 401px;left:0px;top:214px;position: relative;}
        .flowed { width:152px; height:401px; position:absolute;top:0px; overflow: hidden;}
        #flowed0 {left:62px;}
        #flowed1 {left:232px;}
        #flowed2 {left:402px;}
        #flowed3 {left:573px;}
        #flowed4 {left:743px;}
        #flowed5 {left:913px;}
        #flowed6 {left:1083px;}
        .childrenContainer{width:152px;height:202px;margin:7px 0px 0px 0px;}
        .flowedItem,.flowedItemFocused {height: 40px;line-height: 32px;width: 152px;overflow: hidden;white-space: nowrap; font-size: 18px;color: #ffffff;text-align: center;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;background:transparent url('images/mask-2015-06-11.png') no-repeat;background-position:-20px 50px; }
        .flowedItemFocused {background-position:-20px -2px; }
        .flowedMarquee {width:146px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2015-06-11.jpg') no-repeat;" onUnload="exit();">
<div id='flowedContainer' class='flowedContainer'></div>
<div id='mask' style="visibility: hidden;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        data : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            if( this.data.length > 0 ) {
                for( var i = 0; i < this.data.length; i ++){
                    var o = this.data[i];
                    cursor.focusable[i] = {};
                    cursor.focusable[i].typeId = o["id"];
                    cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                    cursor.focusable[i].items = o["data"];
                }
            }
            cursor.focusable =  cursor.focusable || [];
            cursor.call("showUI");
            cursor.focused = String(cursor.blocked) + String(cursor.focusable[cursor.blocked].focus);
            cursor.call('show');
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 || index == -11 ) {
                focus += index > 0 ? -1 : 1;
                if( focus < 0 || focus >= items.length) return;
            } else {
                blocked += index;
                if( blocked < 0 || blocked > 6 ) { return;}
                else {
                    focus = cursor.focusable[blocked - index].focus;
                    if( focus >= cursor.focusable[blocked].items.length ) focus = cursor.focusable[blocked].items.length - 1;
                    if( focus < 0 ) return;
                }
            }
            cursor.blocked = blocked;
            cursor.focusable[blocked].focus = focus;
            cursor.previous = cursor.focused;
            cursor.focused = String(blocked) + String(focus);
            cursor.call('show');
        },
        showUI:function(){
            var html = '';
            for( var i = 0; i< 7; i++){
                html += '<div class="flowed" id="flowed' + i + '">';
                var items = cursor.focusable[i].items;
                var focus = cursor.focusable[i].focus;
                var pic =  ( typeof items == 'object' && typeof items[0] == 'object' ) ? cursor.pictureUrl(items[focus].posters,1) : '';
                html += '<img src="' + pic + '" style="width:152px;height:196px;" id="img' + String(i) + '"/>';
                html += '<div id="childrenContainer' + i + '" class="childrenContainer">';
                for(var j = 0; j < items.length; j += 1) {
                    html += '<div class="flowedItem" id="txt' + String(i) + String(j) + '">' + items[j].name + '</div>';
                    items[j].linkto = '/EPG/jsp/defaultHD/en/iCatch_yulq_list.jsp?typeId=' + items[j].id + '&pageLength=8';
                }
                html += '</div></div>';
            }
            $("flowedContainer").innerHTML = html;
        },
        show:function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var item = cursor.focusable[blocked].items[focus];

            if(typeof cursor.previous !== 'undefined' ){
                var b = Number(cursor.previous.substr(0,1));
                var f = Number(cursor.previous.substr(1,1));
                $('txt' + cursor.previous).innerHTML = cursor.focusable[b].items[f].name;
                $('txt' + cursor.previous).className = 'flowedItem';
            }

            $('txt' + cursor.focused).className = 'flowedItemFocused';
            $('img' + cursor.blocked).src = cursor.pictureUrl(item.posters,1);

            (function(id,value){
                cursor.calcStringPixels(value, 18, function(pixelsWidth){
                    var innerHTML = pixelsWidth > 158 ? ('<marquee class="marqueed" scrollamount="10">' + value + "</marquee>") : value ;
                    $(id).innerHTML = innerHTML;
                });
            })('txt' + cursor.focused,item.name);
        }
    });
    -->
</script>
</html>