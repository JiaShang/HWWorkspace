<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 4));
    infos.add(new ColumnInfo(typeId, 4, 5));
    infos.add(new ColumnInfo(typeId, 9, 6));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:167px;height:42px;position:absolute;background:transparent url('images/mask-2018-06-15.png') no-repeat;background-position: 0px 0px;}
        .mask11{left:64px;top:351px;background-position: 0px 0px;}
        .mask12{left:64px;top:409px;background-position: 0px -50px;}
        .mask13{left:64px;top:470px;background-position: 0px -100px;}
        .mask14{left:64px;top:532px;background-position: 0px -150px;}

        .mask21{left:276px;top:351px;background-position: 0px -200px;}
        .mask22{left:276px;top:413px;background-position: 0px -250px;}
        .mask23{left:276px;top:475px;background-position: 0px -300px;}
        .mask24{left:276px;top:537px;background-position: 0px -350px;}
        .mask25{left:276px;top:599px;background-position: 0px -400px;}

        .mask31{left:494px;top:351px;background-position: 0px -450px;}
        .mask32{left:494px;top:409px;background-position: 0px -500px;}
        .mask33{left:494px;top:467px;background-position: 0px -550px;}
        .mask34{left:494px;top:523px;background-position: 0px -600px;}
        .mask35{left:494px;top:581px;background-position: 0px -650px;}
        .mask36{width:248px;left:494px;top:642px;background-position: -200px 0px;}

        .mask41{width:198px;height:47px;left:903px;top:628px;background-position: -200px -50px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-16-15.jpg') no-repeat;" onUnload="exit();">
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
            cursor.focusable[2].items.push ({name:'链接',linkto:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=49cd5287be696889ee8d319e7a76da2d'});
            cursor.focusable[3] = {focus:0,items:[{name:'链接',linkto:'http://192.168.17.42:8200/Fifa/main.html'}]};

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if(index == -1 && blocked == 0 || index == 1 && blocked >= 3 || index == -11 && focus + 1 >= items.length || index == 11 && focus == 0 ) return;
            if( index == 11 || index == -11 ) focus += index > 0 ? -1 : 1;
            else {
                if( blocked == 3 && index == -1 ) {
                    blocked = 2;
                    focus = cursor.focusable[blocked].focus;
                } else {
                    blocked += index ;
                    if( focus >= cursor.focusable[blocked].items.length )
                        focus =  cursor.focusable[blocked].items.length - 1;
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = "mask mask" + (blocked + 1) + "" + ( focus + 1);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>