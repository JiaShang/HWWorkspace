<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109523";
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
        .flowed{width:251px;height:360px;left:777px;top:228px;position:absolute;overflow:hidden;}
        .item,.itemFocus {width:251px;height:65px;overflow: hidden;background:transparent url('images/mask-2018-05-10.png') no-repeat;background-position: 0px 0px;}
        .itemFocus {background-position: 0px -66px;}
        .text {width:230px;height:40px;margin:10px 10px 0px 10px;overflow: hidden;color:#794B00;font-size:18px;text-align:left;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .scroll {left:1044px;width:6px;position:absolute;overflow: hidden;background-color:#519cf9;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-05-10.jpg') no-repeat;" onUnload="exit();">
<div id="flowed" class="flowed"></div>
<div id="scroll" class="scroll"></div>
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
            cursor.pageSize = 5;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index == 1 || index == -1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length )) return;
            focus += index > 0 ? -1 : 1;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            var current = Math.floor(focus / 5.0) * 5;
            var html = "";
            for(var i = current, j = 0 ; i < items.length && j < cursor.pageSize; i ++ ,j ++) {
                var item = items[i];
                var focusStr = i == focus ? "Focus" : "";
                html += "<div class='item" + focusStr + "'><div class='text' id='text" + (i + 1) + "'>" + item.name + "</div></div>";
            }
            $("flowed").innerHTML = html;
            var item = items[focus];
            cursor.marquee(item.name,18,"text" + (focus + 1), 251);
            var len = items.length <= cursor.pageSize ? cursor.pageSize : ( items.length - 1 );
            var height = Math.ceil(( cursor.pageSize * 1.0 / len ) * 333);
            $("scroll").style.height = (( cursor.pageSize * 1.0 / len ) * 333) + "px";
            $("scroll").style.top = Math.floor((333.0 - height) / len * focus + 230) + "px";
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>