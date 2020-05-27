<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    //  背景全是图片的专题（模块）
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;
    direct:方向，默认为坚，当不为空时为横
    type: (默认为1)， 取栏目下的视频，可以播放
        : 2， 取栏目下子栏目的背景图，仅展示图片，不可以播放
        : 3， 背景图直接绑在栏目上，不可以播放
    //背景绑定在每个条目的背景图上
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    int type = inner.getInteger("type", 1);
    String classifyID = inner.get("classifyID");
    //if( isEmpty(classifyID ) ) classifyID = "473";
%>
<html>
<head>
    <title><%=column == null ? "背景全是图片的专题（模块）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
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
                if( type == 1 || type == 2 ) {
                    for ( int i = 0; i < infos.size(); i++) {
                        ColumnInfo info = infos.get(i);
                        Result result =
                            type == 1 ?
                                inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() ) :
                                inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() );
                        html += inner.resultToString(result);
                        if( i + 1 < infos.size() ) html += ",\n";
                    }
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            <% if( type == 1 ) { %>
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            <% } else { %>
            var column = <%= inner.writeObject(column)%>;
            var posters = column.posters['7'];
            cursor.focusable[0] = {focus:0,items:[]};
            for( var i = 0; i < posters.length; i ++ )
                cursor.focusable[0].items[i] = {'name':'pic' +String( i + 1), 'posters':{'7':[posters[i]]} };
            <% } %>
            cursor.call('show');
            if( '<%=classifyID%>' != '' ) {
                cursor.call('trafficNum');
            }
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            //为空时，上下移动，不为空时，左右移动
            var direct = <%= isEmpty(inner.get("direct")) %>;

            if( direct && (index === -1 || index === 1) ||
               !direct && (index === -11 || index === 11 )) return;
            focus += (index == 1 || index == -11) ? 1 : -1 ;

            if( focus < 0 ) focus = items.length - 1;
            else if( focus >= items.length ) focus = 0;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        select : function(){ return;},
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            var item = cursor.focusable[0].items[focus];
            var picture = cursor.pictureUrl(item.posters,7);
            document.body.style.backgroundImage = 'url("' + picture + '")';
        },
        trafficNum      :function(){
            var url="http://192.168.18.249:8080/voteNew/external/clickCount.ipanel?icid="+iPanel.cardId+"&classifyID="+'<%=classifyID%>'+"&content=1";
            ajax(url, function(rst){
                if( rst != "" && rst != 'undefined'&& rst.result ) {
                    //tooltip( decodeURIComponent('统计成功') );  //统计成功
                    return;
                }
            });
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>