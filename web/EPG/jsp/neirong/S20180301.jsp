<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109122";
    infos.add(new ColumnInfo( typeId , 0, 9));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String defaultBg = "images/bg-2018-03-01.jpg";
    String picture = column == null ? defaultBg : inner.pictureUrl(defaultBg,column.getPosters(),"7");
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:59px;height:437px;top:214px;position:absolute;background:transparent url('images/mask-2018-03-01.png') no-repeat;background-position: 0px 0px;}
        .mask1 {width:148px;height:67px;left:31px;top:302px;background-position: 0px 0px;}
        .mask2 {width:230px;height:88px;left:121px;top:183px;background-position: -150px 0px;}
        .mask3 {width:191px;height:57px;left:242px;top:292px;background-position: -400px 0px;}
        .mask4 {width:191px;height:66px;left:413px;top:449px;background-position: -600px 0px;}
        .mask5 {width:191px;height:63px;left:605px;top:271px;background-position: 0px -100px;}
        .mask6 {width:191px;height:102px;left:700px;top:33px;background-position: -200px -100px;}
        .mask7 {width:226px;height:69px;left:783px;top:223px;background-position: -400px -100px;}
        .mask8 {width:191px;height:70px;left:989px;top:263px;background-position: 0px -250px;}
        .mask9 {width:187px;height:113px;left:1058px;top:113px;background-position: -200px -250px;}

    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('<%=picture %>') no-repeat;" onUnload="exit();">
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
            cursor.focusable[0].items =  cursor.focusable[0].items || [];
            var links = [
                {name:'敦刻尔克',linkto:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5a2f3dc4b43cb01beba244d3357e36a7', linkandr:'com.hunantv.operator,com.starcor.hunan.SplashActivity,cmd_ex###show_video_detail###video_id###f951ed6672f274fce49919a3bb5122c8###video_type###0###video_ui_style###0'},
                {name:'寻梦环游记',linkto:'http://192.168.5.229/dyyx/search_content.htm?vodId=PACKAGE201801000117-gehua&backurl=http://192.168.5.229/dyyx/index.htm'}
            ]
            cursor.focusable[0].items.insertAt(0, links[0]);
            cursor.focusable[0].items.insertAt(5, links[1]);
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && ((index == -1 || index == -11 ) && focus <= 0 || (index == 1 || index == 11 ) && focus + 1 >= items.length) ) return;
            focus += (index == -1 || index == -11) ? -1 : 1;
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