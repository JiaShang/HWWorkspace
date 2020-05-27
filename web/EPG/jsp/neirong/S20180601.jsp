<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109618";
    infos.add(new ColumnInfo(typeId, 0, 8));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2018-06-01.png') no-repeat;background-position: 0px 0px;}
        .mask1 {width:473px;height:244px;left:0px;top:0px;background-position: 0px 0px;}
        .mask2 {width:447px;height:264px;left:463px;top:0px;background-position: 0px -300px;}
        .mask3 {width:244px;height:155px;left:808px;top:180px;background-position: 0px -600px;}
        .mask4 {width:380px;height:335px;left:907px;top:0px;background-position: 0px -800px;}
        .mask5 {width:403px;height:318px;left:0px;top:169px;background-position: -500px 0px;}
        .mask6 {width:379px;height:249px;left:908px;top:294px;background-position: -500px -350px;}
        .mask7 {width:405px;height:257px;left:0px;top:469px;background-position: -500px -600px;}
        .mask8 {width:511px;height:230px;left:399px;top:495px;background-position: -500px -900px;}
        .mask9 {width:380px;height:205px;left:907px;top:520px;background-position: 0px -1150px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-06-01.jpg') no-repeat;" onUnload="exit();">
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

            var links = [
                {name:'链接',linkto:'http://192.168.34.17:8300/app_redirect/game/activity/act_child_2018/index.do'}
            ]
            cursor.focusable[0].items.insertAt(2, links[0]);

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 && focus <= 3 || index == -11 && focus >= 6 || index == -1 && (focus == 0 || focus == 4 || focus == 6 ) || index == 1 && ( focus == 3 || focus == 5 || focus >= 8 )) return;
            if( index == -1 || index == 1 ) focus += index;
            else if(index == -11 ) {
                switch (focus) {
                    case 0: focus = 4;break;
                    case 1:
                    case 2: focus = 7; break;
                    case 3: focus = 5; break;
                    case 4: focus = 6; break;
                    case 5: focus = 8; break;
                    default: return;
                }
            } else  {
                switch (focus){
                    case 4: focus = 0; break;
                    case 5: focus = 3; break;
                    case 6: focus = 4; break;
                    case 7: focus = 1; break;
                    case 8: focus = 5; break;
                    default: break;
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