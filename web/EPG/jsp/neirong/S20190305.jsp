<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //���Ȼ�ȡ�����е���ĿID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 8));
    //��ȡ��ǰ��Ŀ����ϸ��Ϣ
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
        .mask {width:450px;height:43px;left:666px;position:absolute;background:transparent url('images/mask-2019-03-06.png') no-repeat;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-03-06.jpg') no-repeat;" onUnload="exit();">
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

            cursor.focusable[0].items.push({"name":"����","linkto":"http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5c6e22541d5de40f3d91a044d1329875"});

            cursor.call('show');
        },
        move        :   function(index){
            //�� 11���� -11���� -1���� 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) return;
            focus += index > 0 ? -1 : 1;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            setTimeout(function(){
                var blocked = cursor.blocked;
                var focus = cursor.focusable[blocked].focus;
                $("mask").className = "mask";
                $("mask").style.top = String( focus * 40 + 190 ) +  'px';
                $("mask").style.backgroundPosition = '0px -' + String( focus * 50) + 'px';
            },300);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>