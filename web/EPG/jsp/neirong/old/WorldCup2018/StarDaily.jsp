<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //每日之星  10000100000000090000000000109603

    //首先获取参数中的栏目ID
    //取最新创建的子栏目
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109300";
    Result result = inner.getTypeList(typeId,0,1);

    //获取当前栏目的详细信息
    Column column = new Column();
    if( result.isSuccess() ) {
        List<Column> cols = (List<Column>)result.data;
        column = cols.get(0);
        typeId = column.getId();
    }
    infos.add(new ColumnInfo(typeId, 0, 99));
    String picture = inner.pictureUrl("images/StarIconDaily.png", column.getPosters(),"12");
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:526px;height:69px;top:268px;left:555px;position:absolute;background:transparent url('images/StarDailyMask.png') no-repeat 0px 0px;}
        .starIcon {width:520px;height:513px;left:32px;top:155px;position:absolute;background:transparent url('<%=picture%>') no-repeat 0px 0px;}
        .after {width:490px;height:348px;left:575px;top:276px;position:absolute;overflow: hidden}
        .item,.itemFocus {width:479px;height:59px;line-height: 56px;font-size:20px;color:white;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .itemFocus {color:#C8B133;}
        .marqueed {width:489px;color:#C8B133;line-height: 47px;}
        .page,.count {width:29px;height:20px;position:absolute;left:1095px;top:328px;font-size:16px;text-align: center;color:black;}
        .count {top:354px;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/StarDaily.jpg') no-repeat;" onUnload="exit();">
<div id="mask" class="mask"></div>
<div id="starIcon" class="starIcon"></div>
<div id="after" class="after"></div>
<div id="page" class="page"></div>
<div id="count" class="count"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.pageSize = 6;
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
                        id:419,limit:9999,limitPer:9999,target:'每日之星',repeat:true
                    });
                    var url = "http://192.168.89.23/serve/vistor/count.do?id=1&choice=" +
                        encodeURIComponent("每日之星") + "&cardNo=" + CA.card.serialNumber;
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
                var id = "item" + ( i + 1);
                html += '<div class="item" id="' + id +  '">' + item.name + "</div>";
            }
            $("after").innerHTML = html;

            $("page").innerHTML = Math.ceil((focus  +  1.0) / pageCount);
            $("count").innerHTML = Math.ceil(items.length  * 1.0 / pageCount);

        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) return;
            if( index == 1 || index == -1 ) {
                return;
            }
            var previous = focus;
            focus += index > 0 ? -1 : 1;
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            if( Math.floor(focus * 1.0 / cursor.pageSize ) != Math.floor(previous * 1.0 / cursor.pageSize ))
                cursor.call('flowedShow');
            else {
                $("item" + (previous + 1)).className = "item";
                $("item" + (previous + 1)).innerHTML = items[previous].name;
            }
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").style.top = (268 + focus % cursor.pageSize * 59) + "px";
            $("item" + (focus + 1)).className = "itemFocus";

            if( cursor.scrollTimer ) clearTimeout( cursor.scrollTimer );
            cursor.scrollTimer = setTimeout(function(){
                var item = cursor.focusable[blocked].items[focus];
                cursor.calcStringPixels( item.name,20, function(width){
                    if(width < 479) return;
                    $("item" + (focus + 1)).innerHTML = '<marquee class="marqueed" scrollamount="8">' + item.name + "</marquee>";
                });
            }, 1000);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>