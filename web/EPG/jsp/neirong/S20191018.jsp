<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000112969";

    infos.add(new ColumnInfo(typeId, 0, 4));

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
        .mask {position:absolute;background:transparent url('images/mask-2019-10-18.png') no-repeat;background-position: 0px 0px;}


        .item1 {width:416px;height:266px;left:310px;top:50px;background-position: 0px 0px;}
        .item2 {width:434px;height:303px;left:832px;top:45px;background-position: -450px 0px;}
        .item3 {width:408px;height:246px;left:216px;top:400px;background-position: -900px 0px;}
        .item4 {width:391px;height:271px;left:732px;top:366px;background-position: -1350px 0px;}


        .item1Focus {width:464px;height:307px;left:303px;top:10px;background-position: 0px -310px;}
        .item2Focus {width:447px;height:352px;left:825px;top:29px;background-position: -500px -310px;}
        .item3Focus {width:451px;height:328px;left:169px;top:353px;background-position: -1000px -310px;}
        .item4Focus {width:446px;height:343px;left:688px;top:319px;background-position: -1500px -310px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-10-18.jpg') no-repeat;" onUnload="exit();">
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

            if( focus <= 1 && index == 11 || focus > 1 && index == -11 || focus % 2 == 0 && index == -1 || ( focus % 2 == 1  || focus + 1 >= items.length ) && index == 1 ) return ;

            if( index == 1 || index == -1 ) focus += index;
            else if( index == 11 ){
                focus -= 2;
            } else {
                focus +=2;
                if( focus >= items.length ) return;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var html = '';
            for( var i = 0; i < items.length; i ++ ){
                var clazz = 'item' + String( i + 1 );
                if( i === focus ) clazz += 'Focus';
                html += '<div class="mask ' + clazz + '"></div>';
            }
            document.body.innerHTML = html;
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>