<%@ include file="../../player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    final String typeId = inner.get("typeId","10000100000000090000000000111880");
    final int itemHeight = 290;

    infos.add(new ColumnInfo(typeId, 0, 6));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String body = "images/missionBg.jpg";
    if( column != null ) body = inner.pictureUrl(body, column.getPosters(), "7",0 );

    inner.setSpecial( true );
    inner.setWithId( "10000100000000090000000000108885" );
    //如果 User-Agent 为空是,说明是机顶盒访问.
    boolean browser = !isEmpty(inner.getBrowserInfo());
%>
<html>
<meta name="page-view-size" content="1280*720">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<head>
    <title><%= column == null ? "" : column.getName() %></title>
    <style>
        body{overflow:hidden;background:transparent url('<%=body%>') no-repeat;width:1280px;height: 720px;margin:0px 0px 0px 0px;padding:0px 0px 0px 0px;}

        .container{width:1280px;height: 720px;position:absolute;left:110px;top:90px;overflow: hidden; }

        .blocked {width:1090px;float: left;position:relative;overflow: hidden;}
        .blocked .item {width:361px;height:<%=itemHeight%>px;position:relative;float:left;overflow: hidden;}
        .blocked .item .image,.blocked .item .image img{width:337px;height:200px;left:3px;top:3px;position:absolute;overflow: hidden;border:none;}
        .blocked .item .text {width:337px;top:203px;height:38px;left:3px;position:absolute;font-size: 20px;color:#242424;background-color:white;text-align: center;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;line-height: 38px;}
        .blocked .item .mask{width:<%= 341 - (browser ? 14 : 0) %>px;height:<%= 243 - (browser ? 14 : 0) %>px;position:absolute;left:1px;top:1px;overflow: hidden;background:transparent none no-repeat left top;border:#fff200 7px solid;}
        .blocked .item .image img{left:0px;top:0px;}
        .blocked .item .mask marquee{width:241px;height:38px;line-height:38px;}
    </style>
    <script language="javascript" type="text/javascript" src="../../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" onUnload="exit();">
<div style="position:absolute;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div class="container" id="container"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    inner.special = true;
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

            cursor.row = 2;
            cursor.column = 3;
            cursor.pageCount = cursor.row * cursor.column;

            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('showList');
            cursor.call('show');
        },
        showList : function(){
            var items = cursor.focusable[0].items;
            var html = '';
            html += '<div id="blocked1" style="height:620px;" class="blocked">';
            for( var i = 0; i < items.length; i ++ ){
                var item = items[i];
                item.linkto = '/EPG/jsp/neirong/edu/v2/list.jsp?parentId=' + item.id + '&index=0&typeId=' + item.id;
                html += '<div class="item" id="item_1_' + String( i + 1 ) + '">';
                html += '<div class="image" id="image1_' + String( i +1 ) + '"><img src="' + cursor.pictureUrl(item.posters, '9') + '" /></div>';
                html += '<div class="text" id="text_1_' + String( i + 1 ) + '">' + item.name + '</div>';
                html += '<div class="mask" id="mask_1_' + String( i + 1) + '" style="visibility: hidden"></div>';
                html += '</div>';
            }
            html += '</div>';
            $('container').innerHTML = html;
        },
        move        :   function(index){
            var blocked = 0;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( index == 11 && focus <= 2 || index == -11 && focus >= 3  || index == -1 && focus % 3 == 0 || index == 1 && (focus % 3 == 2 || focus + 1 >= items.length )) return;

            $('mask_1_' + String(focus + 1)).style.visibility = 'hidden';
            if( index == 1 || index == -1 ) {
                focus += index;
            } else {
                focus += index > 0 ? -3 : 3;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.call('show');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            $('mask_1_' + String(focus + 1)).style.visibility = 'visible';
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>