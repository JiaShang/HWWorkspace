<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109321";//
    infos.add(new ColumnInfo(typeId, 0, 7));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2018-03-29.png') no-repeat;background-position: 0px 0px;}
        .mask1 {width:294px;height:51px;left:19px;top:268px;background-position: 0px 0px;}
        .mask2 {width:309px;height:50px;left:916px;top:270px;background-position: 0px -60px;}
        .mask3 {width:223px;height:51px;left:101px;top:335px;background-position: 0px -120px;}
        .mask4 {width:210px;height:49px;left:870px;top:345px;background-position: 0px -180px;}
        .mask5 {width:203px;height:51px;left:1078px;top:344px;background-position: 0px -240px;}
        .mask6 {width:239px;height:48px;left:140px;top:420px;background-position: 0px -300px;}
        .mask7 {width:214px;height:54px;left:974px;top:416px;background-position: 0px -360px;}
        .mask8 {width:361px;height:101px;left:875px;top:57px;background-position: 0px -420px;}
        .mask9 {width:896px;height:720px;left:183px;top:0px;background-position: -370px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-03-29.jpg') no-repeat;" onUnload="exit();">
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

            cursor.consigned = [];
            cursor.consigned[0] = this.focused.length > 2 ? Number(this.focused[2] ) : 0;

            var links = [
                {name:'前往未来世界',linkto:'http://192.168.34.131:8300/video_hall/index.do?from=readyplayer'},
                {name:'游戏链接',linkto:'http://192.168.34.131:8300/video_hall/all_video.do?kind=hot_games'}
            ];

            cursor.focusable[0].items.pushAll(links);

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == -1 && ( focus ===0 || focus === 2 || focus === 5 ) ||
                index == 1 && (focus === 7 || focus == 1 || focus == 4 || focus == 6) ||
                index == 11 && ( focus == 0 || focus == 7 || focus == 8 ) ||
                index == -11 && ( focus == 5 || focus == 8 || focus == 6 )) return;
            if( index === 1 ) {
                if( focus == 0 || focus == 2 || focus == 5 ) {
                    cursor.consigned[0] = focus;
                    focus = 8;
                } else  if( focus === 3 ) focus = 4;
                else if( focus == 8 ){
                    if( cursor.consigned[0] === 0 || cursor.consigned[0] === 1  ) focus = 1;
                    else if( cursor.consigned[0] === 2 || cursor.consigned[0] === 3 ) focus = 3;
                    else if( cursor.consigned[0] === 5 || cursor.consigned[0] === 6 ) focus = 6;
                    else if( cursor.consigned[0] === 7 ) focus = 7;
                }
            } else if( index === -1 ) {
                if( focus == 7 || focus == 1 || focus == 3 || focus == 6 ) {
                    cursor.consigned[0] = focus;
                    focus = 8;
                } else  if( focus === 4 ) focus = 3;
                else if( focus == 8 ){
                    if( cursor.consigned[0] === 0 || cursor.consigned[0] === 1 || cursor.consigned[0] === 7 ) focus = 0;
                    else if( cursor.consigned[0] === 2 || cursor.consigned[0] === 3 ) focus = 2;
                    else if( cursor.consigned[0] === 5 || cursor.consigned[0] === 6 ) focus = 5;
                }
            } else if( index === 11 ) {
                switch (focus){
                    case 5 : focus = 2;break;
                    case 2 : focus = 0;break;
                    case 6 : focus = 3;break;
                    case 3 :
                    case 4 : focus = 1;break;
                    case 1 : focus = 7;break;
                }
            } else {
                switch (focus){
                    case 0 : focus = 2;break;
                    case 2 : focus = 5;break;
                    case 7 : focus = 1;break;
                    case 1 : focus = 3;break;
                    case 3 :
                    case 4 : focus = 6;break;
                }
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