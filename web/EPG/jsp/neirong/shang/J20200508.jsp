<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>

<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114886";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");
    String video = inner.get("video","");
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
    <div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "none" : (" url('" + picture + "')")%> no-repeat;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        data : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            <% if( !isEmpty(video) && video.split("\\,").length > 3 ){ %>
            cursor.moviePos = [<%=video%>];
            <% } %>
            cursor.playIndex = 0;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = 1;
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[0].items[1]={
                'name': "更多视频",
                'linkto': '/EPG/jsp/neirong/shang/J20200508_2.jsp?typeId=10000100000000090000000000114887&row=2&ct=3&wh=330&ht=219&ml=38&mh=5&cl=000000&fc=dc6b19&bc=ffff00&cat=1&lft=43&tp=61&w=800&fs=24&cl=725f51&sc=1190,125,500,959ea5,fbba54,1,2,2&maxTitleLen=10'
            };
            setTimeout(function(){cursor.call('prepareVideo');},100);
        },
        nextVideo   :   function () {
            var playIndex = cursor.playIndex;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            if( cursor.focusable[0].items.length <= 0 )return;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie",item);
        },
        playMovie : function(item){
            var pos = cursor.moviePos;
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
                callback:function(){
                }
            });
        }
    });
    -->
</script>
</html>