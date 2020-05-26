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
        .flowedContainer{width:1280px;height:450px;left:0px;top:208px;position: relative;}
        .flowed { width:145px; height:450px;position:absolute;top:83px; overflow: hidden;}
        .flowed img {position:absolute;left:0px;top:2px;}
        #flowed0 {left:91px;}
        #flowed1 {left:250px;}
        #flowed2 {left:412px;}
        #flowed3 {left:573px;}
        #flowed4 {left:733px;}
        #flowed5 {left:894px;}
        #flowed6 {left:1055px;}
        .childrenContainer{width:145px;height:202px;position:absolute; top:200px;left:0px;}
        .flowedItem,.flowedItemFocused {height: 46px;line-height:46px;width:145px;overflow: hidden;white-space: nowrap; font-size: 18px;color: #ffffff;text-align: center;overflow:hidden;word-break:keep-all;white-space:nowrap;background:transparent url('images/mask-2018-08-13.png') no-repeat;background-position:-300px -100px; }
        .flowedItemFocused {background-position:-20px -108px; color: black;}
        .flowedMarquee {width:145px;line-height:42px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-08-13.jpg') no-repeat;" onUnload="exit();">
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
                html += '<img src="' + pic + '" style="width:145px;height:185px;" id="img' + String(i) + '"/>';
                html += '<div id="childrenContainer' + i + '" class="childrenContainer">';
                for(var j = 0; j < items.length; j += 1) {
                    html += '<div class="flowedItem" id="txt' + String(i) + String(j) + '">' + items[j].name + '</div>';
                    items[j].linkto = '/EPG/jsp/neirong/S20180813List.jsp?typeId=' + items[j].id + '&tp=302&fs=22&hm=1&w=990&mr=0&lft=168&ih=65&al=0&bc=fc0000&fc=192454&cl=ffffff&pg=6';
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
                    var innerHTML = pixelsWidth > 145 ? ('<marquee class="marqueed" scrollamount="10">' + value + "</marquee>") : value ;
                    $(id).innerHTML = innerHTML;
                });
            })('txt' + cursor.focused,item.name);
        }
    });
    -->
</script>
</html>