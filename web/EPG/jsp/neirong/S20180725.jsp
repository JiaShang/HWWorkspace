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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109901";

    infos.add(new ColumnInfo(typeId, 0, 10));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "专题" : column.getName()%></title>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
    <style>
        .after {width:986px;height:161px;left:161px;top:449px;position: absolute;background:transparent url("images/mask-2018-07-25.png") no-repeat -100px 0px;}
        .mask {width:86px;height:198px;top:440px;background:transparent url("images/mask-2018-07-25.png") no-repeat 0px 0px;position:absolute;}
        .mask1{left:129px;}
        .mask2{left:243px;}
        .mask3{left:347px;}
        .mask4{left:453px;}
        .mask5{left:563px;}
        .mask6{left:667px;}
        .mask7{left:769px;}
        .mask8{left:873px;}
        .mask9{left:981px;}
        .mask10{left:1092px;}
    </style>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden;background:transparent url('images/bg-2018-07-25.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after" class="after"></div>
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
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            //为空时，上下移动，不为空时，左右移动
            var direct = false;

            if( direct && (index === -1 || index === 1) ||
               !direct && (index === -11 || index === 11 )) return;
            focus += (index == 1 || index == -11) ? 1 : -1 ;

            if( focus < 0 ) focus = items.length - 1;
            else if( focus >= items.length ) focus = 0;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            $("mask").className = "mask mask" + (focus + 1);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>