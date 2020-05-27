<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%--
    //人物模板专题， 一般来说4行，2列， 背景为每个子栏目的背景
    参数说明：
    row:        页面显示几行，默认4行
    col:        页面显示几列，默认2列
    squarePos:  第一个人物列表显示位置，left,top,width,height
    itemPos:    第一个影片列表显示位置，left,top,width,height
    count:      显示影片个数，超出翻页
    fcolor:     获得焦点后，条目的背景颜色
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000111381";
    List<Column> columns = inner.getList(typeId,99,0, new Column());

    for( int i = 0 ; i < columns.size(); i ++ )
        infos.add(new ColumnInfo(columns.get(i).id,0,99));

    int row = inner.getInteger("row",4);
    int col = inner.getInteger("col",2);
    Rectangle squarePos = inner.getRectangle("squarePos");
    Rectangle square = new Rectangle();
    square.width = squarePos.width * col + 1;
    square.height = squarePos.height * row + 1;
    Rectangle itemPos = inner.getRectangle("itemPos");
    if( itemPos.width == 0 ) {
        itemPos.left = 528;
        itemPos.top = 404;
        itemPos.width = 158;
        itemPos.height = 188;
    }
    int count = inner.getInteger("count",4);
    String fcolor = isEmpty(inner.get("fcolor")) ? "#f8b901" : "#" + inner.get("fcolor");
    String txtColor = isEmpty(inner.get("txtColor")) ? "white" : "#" + inner.get("txtColor");
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .area {position:absolute;width:<%=square.width%>px;height:<%=square.height%>px;left:<%=squarePos.left%>px;top:<%=squarePos.top%>px;overflow: hidden;}
        .areaItem {width:<%=squarePos.width%>px;height: <%=squarePos.height%>px;overflow: hidden;background: transparent none no-repeat left top;overflow: hidden;float: left;}
        .after{position:absolute;width:<%=itemPos.width * count + 120%>px;height:<%=itemPos.height + 20 + 40%>px;left:<%=itemPos.left%>px;top:<%=itemPos.top%>px;overflow: hidden;}
        .before,.end {width:60px;height:<%=itemPos.height + 70%>px;position:absolute;top:0px;}
        .beforeItem,.endItem{width:60px;height:<%=itemPos.height + 10 %>px;}
        .beforeSplit,.endSplit{width:60px;height:20px;background:transparent url('images/mask-STemplateSquarenePersonage.png') no-repeat -20px -40px;}
        .endSplit{background-position: -316px -40px;}

        .item{width:<%=itemPos.width%>px;height:<%=itemPos.height + 70%>px;top:0px;position:absolute;}
        .itemImgBorder,.itemImgBorderFocus {width:<%=itemPos.width - 16%>px;height:<%=itemPos.height%>px;background-color: transparent;}
        .itemImgBorderFocus{background-color: <%=fcolor%>}
        .itemImg,.itemImg img{width:<%=itemPos.width - 16%>px;height:<%=itemPos.height - 10%>px;}
        .itemSplit{width:<%=itemPos.width%>px;height:20px;background:transparent url('images/mask-STemplateSquarenePersonage.png') no-repeat -75px 0px;}
        .itemSpace{width:<%=itemPos.width%>px;height:10px;}
        .itemSplitFocus{width:<%=itemPos.width%>px;height:20px;background:transparent url('images/mask-STemplateSquarenePersonage.png') no-repeat -75px -20px;}
        .itemText,.itemTextFocus{width:<%=itemPos.width- 16%>px;height:40px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden; color:<%=txtColor%>;line-height: 40px;font-size:18px;text-align: center;}
        .itemTextFocus {color:<%=fcolor%>}
        .marquee{width:<%=itemPos.width- 16%>px;line-height: 36px;font-size:18px;height:40px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black none no-repeat;" onUnload="exit();">
<div id="after" class="after"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                html += inner.resultToString(new Result(typeId, columns)) + ",\n";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(), info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';
            cursor.row = <%= row %>;
            cursor.col = <%= col %>;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            for(var i = 0; i < cursor.focusable[cursor.focusable.length-1].items.length; i ++ ){
                cursor.focusable[cursor.focusable.length - 1].items[i].name = i == 0 ? "陪你到世界之巅" : "人间至味是清欢";
                cursor.focusable[cursor.focusable.length - 1].items[i].linkto = i == 0 ? "http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5cfcffa21f519ef083ffbf7722d77042" : "http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=aaeb5fb4826e2740fce4b83271929802";
            }
            cursor.call('show',true);
        },
        select: function(){
          if( cursor.blocked === 0 ) {
              cursor.blocked = cursor.focusable[0].focus + 1;
              cursor.call("show");
              return;
          }
            cursor.call("selectAct");
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus || 0;
            var items = cursor.focusable[blocked].items || [];

            if( items.length === 0 ) return;

            if( blocked === 0 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length )return;

            if( index == -1 || index == 1 ) {
                focus += index;
            } else {
                blocked += index > 0 ? -1 : 1;
                if( index == 11 && blocked <= 0 )
                    blocked = cursor.focusable.length - 1;
                else if( index == -11 && blocked + 1 > cursor.focusable.length )
                    blocked = 1;
                cursor.focusable[0].focus = blocked - 1;
                focus = cursor.focusable[blocked].focus;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(init){
            var items = cursor.focusable[0].items;
            if( items.length === 0 ) return;
            var focus = cursor.focusable[0].focus;
            var pageCount,currentPage,flowCursorIndex,length,html = "";
            document.body.style.backgroundImage = 'url("' + cursor.pictureUrl(items[focus].posters,7) + '")';
            var blocked = focus + 1;
            html = "";
            items = cursor.focusable[blocked].items || [];
            if( items.length === 0 ) return;
            focus = cursor.focusable[blocked].focus;
            pageCount = <%= count %>;
            //每页显示数量
            currentPage = Math.floor(focus / pageCount);
            flowCursorIndex = currentPage * pageCount;

            length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            html += "<div class='end' style='left:" + <%=itemPos.width * count + 60%> + "px'><div class='endItem'></div><div class='endSplit'></div></div>";
            for( var i = flowCursorIndex; i < flowCursorIndex + length; i += 1 ){
                var item = items[i];
                var focusTxt = cursor.blocked == blocked && i == focus ? "Focus" : "";
                html += "<div class='item' style='left:" + (<%=itemPos.width %> * (pageCount - length + (i - flowCursorIndex)) + 60) +  "'><div class='itemImgBorder" + focusTxt + "'>";
                html += "<div class='itemImg'><img src='" + cursor.pictureUrl(item.posters,1) +"'></div>";
                html += "</div><div class='itemSpace'></div><div class='itemSplit" + focusTxt + "'></div>";
                html += "<div class='itemText" + focusTxt + "' id='txt" + (i + 1) + "'>" + item.name + "</div>";
                html += "</div>";
            }
            html += "<div class='before' style='left:" + (<%=itemPos.width %> * (pageCount - length)) + "px'><div class='beforeItem'></div><div class='beforeSplit'></div></div>";
            $("after").innerHTML = html;
            if( cursor.blocked == blocked ) {
                (function(id,value){
                    cursor.calcStringPixels(value, 18, function(pixelsWidth){
                        var innerHTML = pixelsWidth > <%= itemPos.width - 16 %> ? ('<marquee class="marquee" scrollamount="10">' + value + "</marquee>") : value ;
                        $(id).innerHTML = innerHTML;
                    });
                })('txt' + (focus + 1),items[focus].name);
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>