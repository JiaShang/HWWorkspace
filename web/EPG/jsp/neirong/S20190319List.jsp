<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000111168";
    infos.add(new ColumnInfo(typeId, 0, 99));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    int ord = inner.getInteger("ord", 1);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:1040px;height:68px;left:102px;position:absolute;background:transparent url('images/mask-2019-03-19.png') no-repeat;background-position: 0px -350px;}
        .after {width:996px;height:408px;left:124px;top:230px;position:absolute;}
        .item {width:996px;height:65px;font-size: 20px;overflow: hidden;}
        .item .text{width: 930px;height: 65px;float:left;line-height: 65px;color:white;font-size:20px;text-align: left; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}

        .count,.page {width:40px;height:22px;position:absolute;left:1151px;top:187px;color:#402e52;font-size:20px;line-height: 20px;overflow: hidden;text-align: center;}
        .count {top:219px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-03-19-List-<%= ord %>.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
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
            cursor.pageCount = 6;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            cursor.call('showItems');
            cursor.call('show');
        },
        showItems : function(){
            var html = '';

            var pageCount = cursor.pageCount;
            var focus = cursor.focusable[0].focus;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var items = cursor.focusable[0].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex, j = 0; i < flowCursorIndex + length; i ++, j ++) {
                var item = items[i];
                var id = j + 1;
                html += "<div class='item'>";
                html += "<div class='text' id='text" + id + "'>" + item.name + "</div>";
                html += "</div>";
            }
            $("after").innerHTML = html;


            $("page").innerHTML = Math.ceil((focus  +  1.0) / pageCount);
            $("count").innerHTML = Math.ceil(items.length  * 1.0 / pageCount);

        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var previous = focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length )) return;
            focus += index > 0 ? -1 : 1;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            if( Math.floor(previous * 1.0 / cursor.pageCount) != Math.floor(focus * 1.0 / cursor.pageCount)) {
                cursor.call("showItems");
            }

            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = "mask mask" + ( focus % cursor.pageCount + 1);
            $("mask").style.top = String(focus % cursor.pageCount * 65 + 230) + 'px';
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>