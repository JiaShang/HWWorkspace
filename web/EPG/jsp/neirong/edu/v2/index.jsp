<%@ include file="../../player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%!
    private void itemBuilder(StringBuilder builder, Bean bean, int block, int index, String picType, boolean isVod){
        builder.append("<div class='").append(isVod ? "item" : "children").append("' id='item_").append(block + 1).append("_").append( index + 1).append("'>");
        if( bean != null ) {
            if( isVod ) {
                //builder.append("<div class='image'>").append("<img src='").append(inner.pictureUrl("images/defaultImg.jpg",bean.getPosters(), picType)).append("'/></div>");
                builder.append("<div class='image' id='image").append(block + 1).append("_").append(index + 1).append("'>").append("<img />").append("</div>");
                builder.append("<div class='text' id='txt_").append(block + 1).append("_").append( index + 1).append("'>").append(bean.getName()).append("</div>");
                builder.append("<div class='mask' id='mask_").append(block + 1).append("_").append( index + 1).append("' style='visibility:hidden'></div>");
            } else {
                builder.append("<div class='border'></div>");
                builder.append("<div class='mask' id='mask_").append(block + 1).append("_").append( index + 1).append("' style='visibility:hidden'></div>");
                builder.append("<div class='text' id='txt_").append(block + 1).append("_").append( index + 1).append("'>").append(bean.getName()).append("</div>");
            }
        } else {
            builder.append(isVod ? "<div class='image'></div>" : "<div class='border' style='background-color:red'></div>");
        }
        builder.append("</div>\n");
    }
%>
<%
    boolean isHD = ! isEmpty(inner.get("isHD"));
    /*
    2����������Ŀ 10000100000000090000000000109314
    */

    final int itemPovertyAlleviationHeight = 277;

    //����Ӱ��Ԫ�صĸ߶�
    final int itemMovieHeight = 298;
    //��������Ŀ�������,һ��Ԫ�صĸ߶�
    final int itemWithColumnHeight = 235;
    //��������Ŀ�������,����ĿԪ�صĸ߶�
    final int itemColumnHeight = 82;
    //���������,һ��Ԫ�صĸ߶�
    final int itemHeight = 271;
    //������Ļ��������ĸ߶�
    final int visibleHeight = 620;
    final boolean isHd = ! isEmpty(inner.get("isHD"));

    //if( isHD ) infos.add(new ColumnInfo("3.0 ��ҳ�Ƽ�","10000100000000090000000000108859", 0, 99));
    infos.add(new ColumnInfo("��ս��ʤ ��ƶ����","10000100000000090000000000117020", 0, 4));     //������Ŀ
    infos.add(new ColumnInfo("ѧϰʱ��","10000100000000090000000000108860", 0, 99));
    infos.add(new ColumnInfo("����ר��","10000100000000090000000000108867", 0, 99));
    infos.add(new ColumnInfo("���㵳��","10000100000000090000000000108862", 0, 99));           //������Ŀ
    infos.add(new ColumnInfo("��߰���","10000100000000090000000000109304", 0, 99));
    infos.add(new ColumnInfo("��ѵ����","10000100000000090000000000109306", 0, 99));           //������ѵ����������,��ȡ���㵳��, ��ȷID��:10000100000000090000000000109306, ����:10000100000000090000000000108862
    infos.add(new ColumnInfo("����Ӱ��","10000100000000090000000000108875", 0, 100));           //��ȡ�����¾��������,��ȷ��Ӧ����:10000100000000090000000000109311,����:10000100000000090000000000108875
    //infos.add(new ColumnInfo("������ҳ�Ƽ�","10000100000000090000000000109313", 0, 100));      //��ʱδ����ҳ��ʾ

    // ������ҳ�п��ܻ���ר����������, �������������ѯר��
    inner.setSpecial( true );


    String with =  "10000100000000090000000000108885";
    List<Integer> margins = new ArrayList<Integer>();
    List<Result> columnList = new ArrayList<Result>();
    margins.add(0);

    StringBuilder jsonBuilder = new StringBuilder();
    StringBuilder crumb = new StringBuilder();
    StringBuilder content = new StringBuilder();
    int totalHeight = 0;
    crumb.append("<div class='crumbItem' id='crumbItem1'><div class='item' id='crumbMask1'><img src='images/indexIcon1").append(isHD ? "1" : "").append(".png' /></div></div>").append("\n");
    for ( int i = 0; i < infos.size(); i++) {
        if( i == 0 ) {
            crumb.append("<div class='crumbItem' style='height:64px;position:relative;'><div class='item' style='position:absolute;height:40px;left:0px;top:19px;' id='crumbMask").append( i + 2).append("'></div>");
            crumb.append("<div class='item' style='position:absolute;left:0px;top:0px;height:64px;'><img src='images/indexIcon").append(i + 2).append(".png' /></div></div>").append("\n");
        } else {
            crumb.append("<div class='crumbItem'><div class='item' id='crumbMask").append( i + 2).append("'><img src='images/indexIcon").append(i + 2).append(".png' /></div></div>").append("\n");
        }
        ColumnInfo info = infos.get(i);
        Result result = i == 0 ? inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() ) : inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );

        //ͼƬ����
        String picType = info.name.equalsIgnoreCase("����ר��")? "99" : "9";
        if( i == infos.size() - 1 )  picType = "1";      //����Ӱ��
        //������¼����Ŀ��˳��
        int x = 0;
        //������Ŀ,Ӱ�Ӿ�,�Ͳ�������Ŀ��ʽ��ͬ
        String clazzName = "blocked";
        if( info.name.equalsIgnoreCase("����Ӱ��") ) clazzName = "blockMovie";
        else if( info.name.equalsIgnoreCase("���㵳��") ||  info.name.equalsIgnoreCase("��ѵ����") )
            clazzName = "blockedWithChildren";
        else if( info.name.equalsIgnoreCase("��ս��ʤ ��ƶ����") )
            clazzName = "blockedAlleviation";

        inner.setWithId( with );
        List<Bean> vodList = (List<Bean>)result.getData();

        int blockSize = vodList == null ? 0 : vodList.size();
        float rowSize = info.name.equalsIgnoreCase("��ս��ʤ ��ƶ����") ? 2.0F : (info.name.equalsIgnoreCase("����Ӱ��") ? 5.0F : 3.0F);
        blockSize = (int)( Math.ceil( blockSize / rowSize ) * rowSize );

        //����ҳ�沼�ֵĸ߶�
        int marginTop = 0;
        if( vodList != null && vodList.size() > 0 ){
            if(info.name.equalsIgnoreCase("���㵳��") ||  info.name.equalsIgnoreCase("��ѵ����")){
                marginTop = ((int)Math.ceil(vodList.size() / rowSize)) * itemWithColumnHeight + itemColumnHeight;
            } else {
                marginTop = ((int)Math.ceil(vodList.size() / rowSize)) * (info.name.equalsIgnoreCase("��ս��ʤ ��ƶ����") ? itemPovertyAlleviationHeight : ( info.name.equalsIgnoreCase("����Ӱ��") ? itemMovieHeight : itemHeight ) );
            }
            marginTop = (int)Math.ceil(marginTop * 1.0 / visibleHeight) * visibleHeight;
        }
        totalHeight += marginTop;
        content.append("<div id='blocked").append( i + 1).append("' style='height:").append(marginTop).append("px;' class='").append( clazzName ).append("'>");
        margins.add( totalHeight );

        for( int j = 0 ; vodList != null && j < blockSize; j ++ )
        {
            if( j == 3 && ( info.name.equalsIgnoreCase("���㵳��") ||  info.name.equalsIgnoreCase("��ѵ����") )){
                String subId = info.name.equalsIgnoreCase("���㵳��") ? "10000100000000090000000000109300" : "10000100000000090000000000109307";
                Result subColumn = inner.getTypeList( subId, info.getStation(), 3 );
                subColumn.message = info.name;
                List<Column> columns = (List<Column>)subColumn.data;
                columnList.add(subColumn);
                for( x = 0; x < 3; x ++){
                    itemBuilder(content, columns != null && x < columns.size() ? columns.get(x) : null, i, j + x, picType, false);
                }
            }
            itemBuilder(content, j < vodList.size() ? vodList.get(j) : null , i, j + x, picType, true);
        }
        content.append("</div>\n\n");
        jsonBuilder.append( inner.resultToString(result) );
        if( i + 1 < infos.size() ) jsonBuilder.append( ",\n" );
    }
    //��� User-Agent Ϊ����,˵���ǻ����з���.
    boolean browser = !isEmpty(inner.getBrowserInfo());
%>
<html>
<meta name="page-view-size" content="1280*720">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<head>
    <title>������ҳ</title>
    <style>
        body{overflow:hidden;background:transparent url('images/indexBg.jpg') no-repeat;width:1280px;height: 720px;margin:0px 0px 0px 0px;padding:0px 0px 0px 0px;}

        .crumb {width:223px;height:500px;position: absolute;left:0px;top:100px;overflow: hidden;}
        .crumbItem {width:223px;height:54px;overflow: hidden;background: transparent no-repeat left top; float: left; position: relative;}
        .crumbItem .item,.crumbItem .mask {width:223px;height:42px;position:absolute;left:0px;top:0px;overflow: hidden;background:transparent none no-repeat;}
        .crumbItem .mask {background: #fc3333 none no-repeat;}

        .container{width:1280px;height: 720px;position:absolute;left:0px;top:0px;overflow: hidden;}
        .contentBorder {position:absolute;width:1000px;left:241px;top:99px;overflow: hidden;height:<%=visibleHeight%>px;}
        .content{position:absolute;width:1000px;left:0px;top:0px;overflow: hidden;}

        .blocked,.blockedAlleviation,.blockedWithChildren,.blockMovie,.onlineTest {width:1000px;float: left;position:relative;overflow: hidden;}
        .blocked .item{width:331px;height:<%=itemHeight%>px;position:relative;float:left;overflow: hidden;}
        .blocked .item .image,.blocked .item .image img,.blockedWithChildren .item .image,.blockedWithChildren .item .image img,.blockedAlleviation .item .image,.blockedAlleviation .item .image img{width:317px;height:181px;left:3px;top:3px;position:absolute;overflow: hidden;border:none;}
        .blocked .item .text,.blockedWithChildren .item .text ,.blockedAlleviation .item .text {width:317px;top:184px;height:38px;left:3px;position:absolute;font-size: 20px;color:#242424;background-color:white;text-align: center;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;line-height: 38px;}
        .blocked .item .mask,.blockedWithChildren .item .mask,.blockedAlleviation .item .mask {width:<%= 321 - (browser ? 14 : 0) %>px;height:<%= 224 - (browser ? 14 : 0) %>px;position:absolute;left:1px;top:1px;overflow: hidden;background:transparent none no-repeat left top;border:#fff200 7px solid;}
        .blocked .item .image img,.blockedWithChildren .item .image img,.blockedAlleviation .item .image img{left:0px;top:0px;}
        .blocked .item .mask marquee,.blockedWithChildren .item .mask marquee,.blockedAlleviation .item .mask marquee{width:211px;height:38px;line-height:38px;}

        .blockedAlleviation .item{width:470px;height:<%=itemPovertyAlleviationHeight%>px;position:relative;float:left;overflow: hidden;}
        .blockedAlleviation .item .image,.blockedAlleviation .item .image img{width:430px;height:205px;left:3px;top:3px;position:absolute;overflow: hidden;border:none;}
        .blockedAlleviation .item .text{width:430px;top:208px;height:43px;left:3px;position:absolute;font-size: 22px;color:#242424;background-color:white;text-align: center;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;line-height: 43px;}
        .blockedAlleviation .item .mask{width:<%= 435 - (browser ? 14 : 0) %>px;height:<%= 253 - (browser ? 14 : 0) %>px;position:absolute;left:1px;top:1px;overflow: hidden;background:transparent none no-repeat left top;border:#fff200 7px solid;}
        .blockedAlleviation .item .image img,.blockedWithChildren .item .image img{left:0px;top:0px;}
        .blockedAlleviation .item .mask marquee{width:410px;height:43px;line-height:43px;}

        .blockedWithChildren .item {width:331px;height:<%=itemWithColumnHeight%>px;position:relative;float:left;overflow: hidden;}
        .blockedWithChildren .children {width:331px;height:<%=itemColumnHeight%>px;position:relative;float:left;overflow: hidden; text-align: center;}
        .blockedWithChildren .children .border,.blockedWithChildren .children .mask {width:250px;height:63px;overflow: hidden;position:absolute;left:38px;top:1px;}
        .blockedWithChildren .children .border {background-color:#028299; }
        .blockedWithChildren .children .mask {background-color:#ffb400; }
        .blockedWithChildren .children .text {position:absolute;width:252px;height:65px;left:37px;top:0px;overflow: hidden; text-align: center;font-size: 22px;line-height:60px;color: white;background-color: transparent;}

        .blockMovie .item{width:196px;height:<%=itemMovieHeight%>px;float: left;position:relative;overflow:hidden;}
        .blockMovie .item .image,.blockMovie .item .image img {width:176px;height:242px;left:3px;top:3px;position:absolute;border:none;}
        .blockMovie .item .image img {left:0px;top:0px;}
        .blockMovie .item .text {width:176px;top:242px;height:38px;left:3px;position:absolute;font-size: 20px;color:#242424;background-color:white;text-align: center;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;line-height: 38px;}
        .blockMovie .item .mask {width:<%= 180 - (browser ? 14 : 0) %>px;height:<%= 274 - (browser ? 7 : 0) %>px; left:1px;top:1px; position:absolute;background:transparent none no-repeat left top;border:#fff200 7px solid;}
    </style>
    <script language="javascript" type="text/javascript" src="../../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" onUnload="exit();">
<div style="position:absolute;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div class="container">
    <div class="top" id="top"></div>
    <div class="crumb" id="crumb"><%= crumb.toString() %></div>
    <div class="contentBorder">
        <div class="content" id="content" style="height:<%=totalHeight%>px;">
            <%= content.toString() %>
        </div>
    </div>
    <div class="shade" id="shade"></div>
</div>
<%%>
<div class="onlineTestResult" id="onlineTestResult"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    //type == 0 ����Ϊ��ʱ�����أ��ж����У�
    //type == 1 ����ÿ��Ԫ�صĸ߶�
    //type == 2 ����ÿ��Ԫ�صĿ��
    var getRowSize = function(columnName, type){
        var rowSize = undefined;
        if( typeof type == "undefined" || type == 0 ) {
            rowSize = 3;
            if( columnName == '����Ӱ��' ) {
                rowSize = 5;
            } else if( columnName == '��ս��ʤ ��ƶ����') {
                rowSize = 2;
            }
        } else if( type == 1 ) {
            rowSize = <%=itemHeight%>;
            if( columnName == '����Ӱ��' ) {
                rowSize = <%=itemMovieHeight%>;
            } else if( columnName == '��ս��ʤ ��ƶ����') {
                rowSize = <%=itemPovertyAlleviationHeight%>;
            }
        } else if( type == 2 ) {
            rowSize = 317
            if( columnName == '����Ӱ��' ) {
                rowSize = 176;
            } else if( columnName == '��ս��ʤ ��ƶ����') {
                rowSize = 470;
            }
        }
        return rowSize;
    }
    var initialize = {
        data        : [<%out.write(jsonBuilder.toString());%>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';

            /*�˴���������Ŀ��Ϣ*/
            cursor.columnChildren = [
                <%
                    String html = "";
                    for ( int i = 0; i < columnList.size(); i++) {
                        html += inner.resultToString(columnList.get(i));
                        if( i + 1 < columnList.size() ) html += ",\n";
                    }
                    out.write(html);
                %>
            ];
            cursor.focusable[0] = {};
            cursor.focusable[0].last = 0;  //�����洢�ϴι��Ľ���
            cursor.focusable[0].focus = this.focused.length > 1 ? Number( this.focused[1] ) : 1;
            cursor.focusable[0].items = [
                <%
                    out.write("{'name':'������ҳ'},");
                    for( int i = 0 ; i < infos.size(); i ++ ){
                        out.write("{'name':'" + infos.get(i).name + "'}" + ( i + 1 >= infos.size() ? "" : ","));
                    }
                %>
            ];
            cursor.last = '';
            var margins = [<% for( int i = 0; i < margins.size(); i ++ ) out.write(margins.get(i) + ( i + 1 < margins.size() ? "," : ""));%>];
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i + 1] = {};
                cursor.focusable[i + 1].typeId = o["id"];
                cursor.focusable[i + 1].marginTop = margins[i];
                cursor.focusable[i + 1].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 2] ) : 0;
                cursor.focusable[i + 1].items = o["data"] || [];
                var columnName = cursor.focusable[0].items[i + 1].name;
                if( columnName === '���㵳��' || columnName === '��ѵ����' ){
                    //������㵳�� �� ��ѵ���õ�����Ŀ��˳������,�����������
                    var subColumns = cursor.columnChildren[columnName === cursor.columnChildren[0].message ? 0 : 1].data;
                    if( cursor.focusable[i + 1].items.length < 3 )
                        cursor.focusable[i + 1].items.pushAll( subColumns );
                    else
                        cursor.focusable[i + 1].items.insertAllAt(3, subColumns);
                }
            }
            for( var i = 0; i < cursor.focusable[1].items.length; i++ ) {
                var item = cursor.focusable[1].items[i];
                if( typeof item.linkto === 'undefined' ) {
                    cursor.focusable[1].items[i].linkto = '/EPG/jsp/neirong/edu/v2/list.jsp?parentId=' + item.id + '&index=' + String(i) + '&typeId=10000100000000090000000000117020';
                }
            }
            // ��Ϊ������ť
            cursor.focusable[cursor.focusable.length] = {focus:0};
            if( cursor.blocked == cursor.focusable.length - 1 ) cursor.blocked = 0;
            cursor.call('show');
        },
        move        :   function(index){
            //�� 11���� -11���� -1���� 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var rowSize = getRowSize(cursor.focusable[0].items[ cursor.focusable[0].focus ].name);
            if( blocked === 0 && ( index == -1 || index === -11 && focus + 1 >= items.length ) ||
                (blocked >= 1 && blocked < cursor.focusable.length - 1 ) && index === 1 && ( focus % rowSize === (rowSize - 1) || focus + 1 >= items.length ) ||
                blocked === cursor.focusable.length - 1 && (index === -1 || index === 11)
            ) return;

            if(  blocked === 0 ) {
                if( index === 11 || index === -11 )
                {
                    focus += index > 0 ? -1 : 1;
                    if( index === 11 && focus < 0 ) {
                        return;
                        // ԭ�������������ڲ���
                        //blocked = cursor.focusable.length - 1;
                        //focus = 0;
                    } else {
                        //���Ϊ�����, Ŀ����Ϊ��ÿ���ƶ�����б�ʱ,��궼�ڵ�һ��, �������:
                        if( focus > 0 && focus + 1 < items.length ){
                            cursor.focusable[focus].focus = 0;
                        }
                    }
                } else {
                    if( focus === 0 ) blocked = 1;
                    else blocked = focus;
                    rowSize = getRowSize(cursor.focusable[0].items.length > blocked ? cursor.focusable[0].items[blocked].name : "");
                    focus = Math.floor(cursor.focusable[blocked].focus * 1.0 / rowSize) * rowSize;
                }
            } else if( blocked === cursor.focusable.length - 1 ) { //���������������ť��
                blocked = index == -11 ? 0 : 1 ; // ���������ʱ����һ����Ŀ���ƶ�������ʱ�������ѧϰʱ����
                focus = 0;
            } else {
                cursor.last = blocked +  "_" + (focus + 1);
                cursor.lastName = items[focus].name;
                if( index === -1 ) {
                    if( focus % rowSize <= 0 ) {
                        blocked = 0;
                        focus = cursor.focusable[blocked].focus;
                    }
                    else focus -= 1;
                } else if( index === 1 ) {
                    focus += 1;
                } else {
                    var nextRowSize = 0;
                    var nextFocus = focus + ( index > 0 ? -rowSize : rowSize );
                    var current = cursor.blocked;
                    if( nextFocus < 0 || nextFocus >= items.length) {
                        if( nextFocus < 0 ){
                            current -= 1;
                            if( current <= 0 ) return;
                            nextFocus = rowSize + nextFocus;
                            nextRowSize = getRowSize(cursor.focusable[0].items[ current ].name);
                            var nextItemCount = cursor.focusable[current].items.length;
                            //����������ƶ�,��Ҫ�ƶ�����һ����ʱ,һ���ƶ�����һ�����һ����Ŀ.
                            if( nextItemCount === 0 ) {
                                blocked = 0; focus = cursor.focusable[blocked].focus = current;
                            } else {
                                blocked = current;
                                if( nextFocus >= rowSize ) nextFocus = rowSize - 1;
                                nextFocus = Math.floor(nextItemCount * 1.0 / rowSize) * rowSize + nextFocus;
                                if( current == 6 ) nextFocus += 1;
                                if( nextFocus >= nextItemCount ) nextFocus = nextItemCount - 1;
                            }
                        } else if( nextFocus >= items.length ) {
                            if( Math.ceil( ( focus + 1.0 ) / rowSize) < Math.ceil( items.length * 1.0 / rowSize) ){
                                nextFocus = items.length - 1;
                            } else {
                                current += 1;
                                if( current >= cursor.focusable[0].items.length ) return;
                                nextRowSize = getRowSize(cursor.focusable[0].items[ current ].name);
                                //����������ƶ�ʱ,�����ǰ���㳬����ǰ���鳤��,�ƶ�����һ��
                                if( cursor.focusable[current].items.length === 0 ) {
                                    blocked = 0; focus = cursor.focusable[blocked].focus;
                                } else {
                                    blocked = current;
                                    nextFocus = nextFocus % rowSize;
                                    nextFocus = nextFocus > nextRowSize ? nextRowSize : nextFocus ;
                                }
                            }
                        }
                    }
                    cursor.focusable[0].focus = blocked;
                    focus = nextFocus;
                }
                $("txt_" + cursor.last ).innerHTML = cursor.lastName;
                $("txt_" + cursor.last ).className = "text";
                $("mask_" + cursor.last ).style.visibility = 'hidden';
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        marginShow  : function(){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            var columnName = cursor.focusable[0].items[focus].name;
            if( focus == 0 ) return;
            var baseMargin = cursor.focusable[focus].marginTop;
            var itemsCount = cursor.focusable[focus].items.length;
            focus = cursor.focusable[focus].focus;
            var invisible = 0, itemHeight = 0;
            var rowSize = getRowSize(columnName);
            if( columnName === '���㵳��' || columnName === '��ѵ����' ) {
                itemHeight = <%=itemWithColumnHeight%>;
                invisible = Math.ceil((focus + 1.0) / rowSize) * itemHeight;
                if( invisible >= 3 ) invisible -= ( <%=itemWithColumnHeight%> - <%=itemColumnHeight%> ); //��ȥǰ������ӵ���һ����
            } else {
                itemHeight = getRowSize(columnName, 1);
                invisible = Math.ceil((focus + 1.0) / rowSize)  * itemHeight;
            }
            if( invisible > <%= visibleHeight%> ) {
                var marginTop = Math.floor( invisible * 1.0 / <%= visibleHeight%>) * <%= visibleHeight%>;
                var marginOffset = 0;
                if( columnName !== '����Ӱ��' || Math.ceil((focus + 1.0) / rowSize) % 2 === 1 && Math.ceil((focus + 1.0) / rowSize) < Math.ceil(itemsCount * 1.0 / rowSize )) {
                    if( Math.ceil(( focus + 1.0  ) / rowSize) < Math.ceil( itemsCount * 1.0 / rowSize ) ) {
                        if( Math.ceil(( focus + 1.0  ) / rowSize) > 2 ) {
                            marginOffset = (Math.ceil(( focus + 1.0  ) / rowSize) - 2) * itemHeight + itemHeight / 2.0;
                            baseMargin += marginOffset;
                        }
                    } else {
                        baseMargin += invisible - 620;
                    }
                } else {
                    baseMargin += invisible - itemHeight * 2;
                }
            }
            $("content").style.marginTop = "-" + baseMargin + "px";

            var width = getRowSize( columnName, 2);
            var blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[blocked].focus;
            var item = items[focus];
            cursor.calcStringPixels(item.name,20, function(w){
                if(cursor.blocked != blocked || cursor.focusable[cursor.blocked].focus != focus || w <= width ) return;
                $("txt_" + String(blocked) + "_" + String(focus + 1)).innerHTML = "<marquee>" + item.name + "</marquee>";
            });

            cursor.showTimer = undefined;
        },
        /**
         * ��ʱ����
         * cursor.call("lazyLoad", blocked );
         * @param items
         * @param type
         */
        lazyLoad : function(blocked){
            if( blocked == 0 ) blocked = 1;
            var loaded = cursor.focusable[blocked].loaded;
            if( loaded ) return;
            var items = cursor.focusable[blocked].items;
            var columnName = cursor.focusable[0].items[cursor.focusable[0].focus].name;

            var picType = columnName == "����ר��" ? 99 : 9;
            if( columnName == "����Ӱ��" )  picType = 1;      //����Ӱ��

            var traversal = function(el){
                if( typeof el === 'undefined' ) return;
                var children = el.children;
                for( var i = 0; children && i < children.length ; i ++){
                    var child = children[i];
                    //IMAGE �ǻ����з��ص�����
                    if( child.tagName == "IMAGE" || child.tagName == "IMG" ) return child;
                    if(child.children.length == 0 ) continue;
                    child = traversal(child);
                    if( child.tagName != "IMAGE" && child.tagName != "IMG" ) continue;
                    return child;
                }
            };
            var defaultImage = 'images/defaultImg.jpg';
            var index = 0;
            var load = function() {
                var item = undefined;
                for( var i = 0; i < items.length; i ++) {
                    var img = traversal($("image" + ( blocked ) + "_" + ( i + 1)));
                    if( typeof img !== 'undefined' ){
                        item = items[i];
                        img.src = cursor.pictureUrl(item.posters,picType,defaultImage);
                    }
                }
                cursor.focusable[blocked].loaded = 1;
            }
            cursor.lazier = setTimeout(load,30);
        },
        hideTestResult : function(){
            $("onlineTestResult").style.visibility = "hidden"; cursor.showTootip = false;
        },
        goBack : function(){
            if( cursor.showTootip ) { cursor.call("hideTestResult"); return; }
            cursor.call("goBackAct");
        },
        select : function(){

            if( cursor.showTootip ) { cursor.call("hideTestResult"); return; }

            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 ){
                //������ҳ
                if( focus === 0 ) {
                    return cursor.call('goHome');
                } else if( focus === items.length - 1) {  // ����Ⱥ��
                    top.window.location.href = 'http://192.168.33.92/cqqg/index.htm?backUrl=' + encodeURIComponent(cursor.href);
                }
                return;
            } else if( blocked === cursor.focusable.length - 1 ){
                //top.window.location.href = cursor.current() + "/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp?epgBackurl="+ cursor.href;
                return cursor.call("search");
            } else {
                var typeId = cursor.focusable[blocked].typeId;
                var item = cursor.focusable[blocked].items[focus];
                var url = '';
                if( item.isSitcom === 0 ){
                    url = cursor.current() + '/EPG/jsp/neirong/edu/v2/player.jsp?id=' + item.id + "&typeId=" + typeId;
                } else {
                    if( typeof item.linkto === 'undefined' && typeof item.isRequiredCourse !== 'undefined'){
                        //��ID�����������б�ҳ��ȡ����
                        var columnName = cursor.focusable[0].items[blocked].name;
                        typeId = columnName === "���㵳��" ? "10000100000000090000000000108861" : "10000100000000090000000000109305";
                        // index ѡ����Ŀ��˳��
                        url = cursor.current() + '/EPG/jsp/neirong/edu/v2/list.jsp?parentId=' + typeId + "&index=" + (focus - 3);
                        typeId = columnName === cursor.columnChildren[0].message ? cursor.columnChildren[0].id : cursor.columnChildren[1].id;
                        url += '&typeId=' + typeId;
                    } else {
                        url = cursor.current() + ( item.linkto || ( '/EPG/jsp/neirong/edu/v2/player.jsp?id=' + item.id + "&typeId=" + typeId ) );
                    }
                }
                //�˴�ע��,��Ϊ��ʱ����Ҫ��ά�빦��.
                //if( typeId == '10000100000000090000000000108860' ) url += "&qrcode=1";
                top.window.location.href = url;
            }
        },
        show        :   function(){
            //������ʾ����б�Ľ���
            var blocked = cursor.blocked;
            var focus = cursor.focusable[0].focus;
            var last = undefined;

            if( blocked === cursor.focusable.length - 1 ) {
                $("crumbMask1").className = 'item';
            } else {
                blocked = 0;
                if(blocked === 0 || cursor.focusable[blocked].last != focus) {
                    last = cursor.focusable[blocked].last;
                    $("crumbMask" + (last + 1)).className = "item";
                    $("crumbMask" + (focus + 1)).className = "mask";
                    cursor.focusable[blocked].last = focus;
                }

                blocked = cursor.blocked;
                focus = cursor.focusable[blocked].focus;
                cursor.call("lazyLoad", blocked == 0 ? focus : blocked );
                if( blocked !== 0  ) {
                    last = blocked +  "_" + (focus + 1);
                    if( last = $("mask_" + last ) )  last.style.visibility = 'visible';
                }
                if( cursor.showTimer ) clearTimeout( cursor.showTimer );
                cursor.showTimer = setTimeout(function(){cursor.call("marginShow");},100);
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>