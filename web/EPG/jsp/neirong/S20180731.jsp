<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    //  背景全是图片的专题（模块）
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;
    direct:方向，默认为坚，当不为空时为横
    //背景绑定在每个条目的背景图上
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 8));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "背景全是图片的专题（模块）" : column.getName()%></title>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden;background:transparent none no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.col = 4;
            cursor.row = 2;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                var oData =  o["data"] || [];
                for( var j = 0; j < oData.length; j ++ )
                    oData[j].linkto = "/EPG/jsp/neirong/S20180731Detail.jsp?tp=233&fs=22&hm=1&w=785&mr=23&lft=240&ih=54&al=0&bc=D1267C&fc=000000&cl=000000&pg=6&typeId=" + oData[j].id;

                cursor.focusable[i].items = oData;
            }
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( index == -1 && focus % cursor.col === 0 || index == 1 && focus % cursor.col == cursor.col - 1 || index === 11 && focus < cursor.col || index === -11 && Math.floor( focus * 1.0 / cursor.col ) * cursor.col + cursor.col >=  items.length) return;

            if( index === -1 || index === 1 ) {
                focus += index;
            } else {
                focus += index > 0 ? -cursor.col : cursor.col;
                if( focus >= items.length ) focus = items.length - 1;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            var item = cursor.focusable[0].items[focus];
            document.body.style.backgroundImage = 'url("images/bg-2018-07-31-' + ( focus + 1 ) + '.jpg")';
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>