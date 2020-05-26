<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>

<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113400";
    infos.add(new ColumnInfo(typeId,0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = "";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }

%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent url('images/J20191212Bg.jpg') no-repeat;" onUnload="exit();">
<div id="focus0" style="position: absolute;width: 576px;height: 222px;left: 60px;top: 212px; overflow:hidden; background: url('images/J20191212Focus0.png') no-repeat; visibility: hidden;" ></div>
<div id="focus1" style="position: absolute;width: 191px;height: 256px;left: 60px;top: 445px; overflow:hidden; background: url('images/J20191212Focus1.png') no-repeat; visibility: hidden;" ></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        data: [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused: [<%= inner.getPreFoucs() %>],
        init: function () {
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl = '<%= backUrl %>';
            cursor.lastFocus0 = 0;
            cursor.lastFocus1 = 2;
            for (var i = 0; i < this.data.length; i++) {
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                cursor.focusable[i].items = o["data"];
            }
            setTimeout(function(){ cursor.call('show');},50);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
        var focus = cursor.focusable[cursor.blocked].focus;
        if( focus <=1 ){
            if (index == -11){
                cursor.lastFocus0 = focus;
                focus = cursor.lastFocus1;
            }else if (index == 1){
                if ( focus <= 0 ) {
                    focus = 1;
                }
            }else if (index == -1) {
                if (focus == 1) {
                    focus = 0;
                }
            }
        }else {
            if( index == -1 ){
                if( focus !=2 ){
                    focus--;
                }
            }
            else if( index == 1 ){
                if(focus !=7){
                    focus++;
                }
            }
            else if(index == 11){
                cursor.lastFocus1 = focus;
                focus = cursor.lastFocus0;
            }
        }
        cursor.focusable[0].focus = focus;
        cursor.call('show');
        },
        show : function(){
            var focus = cursor.focusable[0].focus;
            if(focus <= 1){
                $("focus0").style.left = String(60+focus*584)+"px";
                $("focus0").style.visibility = "visible";
                $("focus1").style.visibility = "hidden";
            }else{
                $("focus1").style.left = String(60+(focus-2)*194)+"px";
                $("focus0").style.visibility = "hidden";
                $("focus1").style.visibility = "visible";
            }

        }
    });
    -->
</script>
</html>