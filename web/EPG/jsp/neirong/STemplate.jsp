<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 5));
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
        .mask {width:59px;height:437px;top:214px;position:absolute;background:transparent url('images/mask-2019-03-22.png') no-repeat;background-position: 0px 0px;}
        /*word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;*/
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-03-22.jpg') no-repeat;" onUnload="exit();">
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

            //var links = [
            //    {name:'敦刻尔克',linkto:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5a2f3dc4b43cb01beba244d3357e36a7', linkandr:'com.hunantv.operator,com.starcor.hunan.SplashActivity,cmd_ex###show_video_detail###video_id###f951ed6672f274fce49919a3bb5122c8###video_type###0###video_ui_style###0'},
            //    {name:'寻梦环游记',linkto:'http://192.168.5.229/dyyx/search_content.htm?vodId=PACKAGE201901000117-gehua&backurl=http://192.168.5.229/dyyx/index.htm'}
            //]
            cursor.focusable[0].items.insertAt(0, links[0]);

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && ()) return;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        playMovie   :   function(){

        },
        nextVideo   :   function () {

        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if(blocked === 0) {
                $("mask").className = "mask mask" + (blocked + 1) + "" + ( focus + 1);
                return;
            }

            /*
            var html = '';
            $("mask").style.visibility = 'hidden';
            $("after").className = "layout layout" + blocked;
            $("after").style.visibility = 'visible';

            var pageCount = 5;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            html = '<div class="container">';
            var items = cursor.focusable[blocked].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                if( i == focus ) {
                    var id = 'layout' + (blocked + '' + (i + 1)) ;
                    html += '<div class="itemFocus" id="' + id + '"></div>';
                    cursor.calcStringPixels(item.name, 20, function(pixelsWidth){
                        var o = cursor.focusable[cursor.blocked].items[focus];
                        var inner = pixelsWidth > ( cursor.blocked === 1 ? 370 : 350 ) ? ("<marquee>" + o.name + "</marquee>") : o.name ;
                        $(id).innerHTML = inner;
                    });
                } else {
                    html += '<div class="item">' + item.name + "</div>";
                }
            }
            html += '</div>';
            $("after").innerHTML = html;

            (function(id,value){
                cursor.calcStringPixels(value, <%-- = fontSize --%>, function(pixelsWidth){
                    if(pixelsWidth <%-- = width --%> ) return;
                    $(id).innerHTML = '<marquee class="marquee" scrollamount="10">' + value + "</marquee>";
                });
            })('txt' + (focus + 1),items[focus].name);
            */
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>