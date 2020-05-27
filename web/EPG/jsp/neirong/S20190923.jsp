<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000108421";
    infos.add(new ColumnInfo(typeId, 0, 8));
    infos.add(new ColumnInfo(typeId, 8, 2));
    infos.add(new ColumnInfo(typeId, 10, 1));
    infos.add(new ColumnInfo(typeId, 11, 1));
    infos.add(new ColumnInfo(typeId, 12, 4));
    infos.add(new ColumnInfo(typeId, 16, 1));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {width:21px;height:21px;position:absolute;background:transparent url('images/mask-2019-09-23.png') no-repeat;}
        .mask1 {top:290px;}
        .mask11 {left:586px;}
        .mask12 {left:612px;}
        .mask13 {left:637px;}
        .mask14 {left:663px;}
        .mask15 {left:689px;}
        .mask16 {left:717px;}
        .mask17 {left:744px;}
        .mask18 {left:770px;}

        .mask2 {top:332px;}
        .mask21 {left:566px;}
        .mask22 {left:592px;}

        .mask3 {top:375px;}
        .mask31 {left:642px;}

        .mask4 {top:478px;}
        .mask41 {left:579px;}

        .mask5 {top:517px;}
        .mask51 {left:547px;}
        .mask52 {left:577px;}
        .mask53 {left:604px;}
        .mask54 {left:632px;}

        .mask6 {top:620px;}
        .mask61 {left:527px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-09-23.jpg') no-repeat;" onUnload="exit();">
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
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
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

            if( index == 11 && blocked == 0 || index == -11 && blocked == cursor.focusable.length - 1 || index == -1 && focus <=0 || index == 1 && focus + 1 >= items.length ) return;
            if( index == 1 || index == -1 ){
                focus += index;
            } else {
                blocked += index > 0 ? -1 : 1;
                focus = cursor.focusable[blocked].focus;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            setTimeout(function(){
                $("mask").className = "mask mask" + (blocked + 1) + " mask" + String(blocked + 1) + String( focus + 1);
                if( items.length == 1 ) {
                    $("mask").style.backgroundPosition = '-240px 0px';
                } else {
                    $("mask").style.backgroundPosition = '-' + String(focus * 30) + 'px 0px';
                }
            },100);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>