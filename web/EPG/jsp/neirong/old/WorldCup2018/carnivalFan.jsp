<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //球迷狂欢  10000100000000090000000000109613

    //首先获取参数中的栏目ID
    inner.special = true;

    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000103261";  //爱看策划： (getTypeList)

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:526px;height:69px;top:551px;left:555px;position:absolute;background:transparent url('images/carnivalFanMask.png') no-repeat 0px 0px;}
        .after {width:1160px;height:500px;left:52px;top:162px;position:absolute;overflow: hidden}
        .item,.itemFocus {width:384px;height:245px;overflow: hidden;float:left;position:relative;background: transparent url("images/carnivalFanMask.png") no-repeat 0px 0px;background-position: -400px 0px;}
        .itemFocus {background-position: -1px -240px;}
        .item .image,.itemFocus .image{width:361px;height:204px;position:absolute;left:13px;top:13px;overflow: hidden;}
        .item .image img,.itemFocus .image img {width:361px;height:204px;}
        .item .text,.itemFocus .text{width:361px;height:37px;font-size:20px;line-height:35px;text-align:right;position:absolute;left:13px;top:180px;overflow: hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;color:white;padding:0px 15px 0px 15px; background: transparent url("images/carnivalFanMask.png") no-repeat 0px -500px;}
        .count {width:100px;height:20px;position:absolute;left:1110px;top:649px;font-size:20px;text-align: center;color:white;}
        .marqueed {width:346px;margin:0px 15px 0px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/TourStronger.jpg') no-repeat;" onUnload="exit();">
<div id="after" class="after"></div>
<div id="count" class="count"></div>
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
            cursor.rows = 2;
            cursor.columns = 3;

            cursor.pageSize = cursor.rows * cursor.columns;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('flowedShow');
            cursor.call("visitedRecord");
            cursor.call('show');
        },
        visitedRecord : function(){
            var record = function(){
                try {
                    cursor.call("sendVote",{
                        id:419,limit:9999,limitPer:9999,target:'球迷狂欢',repeat:true
                    });
                    var url = "http://192.168.89.23/serve/vistor/count.do?id=1&choice=" +
                        encodeURIComponent("球迷狂欢") + "&cardNo=" + CA.card.serialNumber;
                    ajax(url);
                }catch (e) { }
            };
            setTimeout(function(){ record(); },30);
        },
        flowedShow : function(){
            var blocked = cursor.blocked;
            var pageCount = cursor.pageSize;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            var html = "";
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var id =  i + 1;
                html += '<div class="item" id="item' + id +  '">';
                html += '<div class="image">';
                html += "<img src='" + cursor.pictureUrl(item.posters,12) + "' />";
                html += "</div><div class='text' id='text" + id +  "'>" + item.name +  "</div></div>";
            }
            $("after").innerHTML = html;

            $("count").innerHTML = Math.ceil((focus  +  1.0) / pageCount) + " / " + Math.ceil(items.length  * 1.0 / pageCount);
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var row = cursor.rows;
            var column =  cursor.columns;

            if( index == 11 && focus < column || index == -11 && Math.ceil((focus + 1.0) / column) >= Math.ceil(items.length * 1.0 / column) || index == -1 && ( focus % column == 0 ) || index == 1 && ( focus % column == column - 1  || focus + 1 >= items.length )) return;

            var previous = focus;
            if( index == 1 || index == -1 ) {
                focus += index;
            } else {
                focus += index > 0 ? -column : column;
                if( focus >= items.length ) focus = items.length - 1;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            if( Math.floor(focus * 1.0 / cursor.pageSize ) != Math.floor(previous * 1.0 / cursor.pageSize ))
                cursor.call('flowedShow');
            else {
                $("item" + (previous + 1)).className = "item";
                $("text" + (previous + 1)).innerHTML = items[previous].name;
            }
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("item" + (focus + 1)).className = "itemFocus";
            if( cursor.scrollTimer ) clearTimeout( cursor.scrollTimer );
            cursor.scrollTimer = setTimeout(function(){
                var item = cursor.focusable[blocked].items[focus];
                cursor.calcStringPixels( item.name,20, function(width){
                    if(width < 345) return;
                    $("text" + (focus + 1)).innerHTML = '<marquee class="marqueed" scrollamount="8">' + item.name + "</marquee>";
                });
            }, 1000);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>