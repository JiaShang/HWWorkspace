<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109281";
    infos.add(new ColumnInfo(typeId, 0, 5));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:184px;height:190px;position:absolute;background:transparent url('images/mask-2018-03-22.png') no-repeat;background-position: 0px 0px;}
        .mask1 {left:622px;top:111px;}
        .mask2 {left:827px;top:111px;}
        .mask3 {left:1032px;top:111px;}
        .mask4 {left:713px;top:319px;}
        .mask5 {left:932px;top:324px;}
        .mask6 {width:138px;height:101px;left:544px;top:588px;background-position: -200px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-03-22.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
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
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            var links = [{name:'更多链接',linkto:'http://192.168.34.131:8300/video_hall/index.do?from=pacific'}]
            cursor.focusable[0].items.pushAll(links);

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index == 11 && focus <= 2 || index == -1 && (focus == 0 || focus ==3 || focus == 5 ) || index === 1 && ( focus === 2 || focus >= 4)) || index == -11 && focus > 4) return;
            if( index == 1 || index == -1 ) {
                focus += index;
            } else if( index == -11 ) {
                if( focus === 0 ) focus = 3;
                else if( focus === 1 || focus === 2 ) focus = 4;
                else focus = 5;
            } else {
                if( focus === 5 ) focus = 3;
                else focus -= 3;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if(blocked === 0) {
                $("mask").className = "mask mask" + ( focus + 1);
                return;
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>