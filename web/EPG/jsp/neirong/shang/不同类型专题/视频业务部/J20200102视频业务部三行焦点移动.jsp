<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>

<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113641";
    infos.add(new ColumnInfo(typeId,0, 2));
    infos.add(new ColumnInfo(typeId,2, 3));
    infos.add(new ColumnInfo(typeId,5, 7));

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
    <style>
        .listName{
            width: 160px;
            height: 60px;
            color: #ffffff;
            font-size:24px;
            background-color: transparent;
            overflow: hidden;
            text-align: left;
            line-height: 60px;
            position: absolute;
        }
        #list{
            position: absolute;
            width: 1280px;
            height: 60px;
            top: 662px;
            left: 0px;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url('images/J20200102Bg.png')" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="focus0" style="position: absolute;width: 584px;height: 209px;left: 57px;top: 140px; overflow:hidden; background: url('images/J20200102Focus0.png') no-repeat; visibility: hidden;" ></div>
<div id="focus1" style="position: absolute;width: 384px;height: 186px;left: 56px;top: 350px; overflow:hidden; background: url('images/J20200102Focus1.png') no-repeat; visibility: hidden;" ></div>
<div id="focus2" style="position: absolute;width: 154px;height: 154px;left: 52px;top: 528px; overflow:hidden; background: url('images/J20200102Focus2.png') no-repeat; visibility: hidden;" ></div>
<div id="data" style="position: absolute;width: 1141px;height: 155px;left: 60px;top: 522px; overflow:hidden; background: url('images/J20200102Data.png') no-repeat; visibility: visible;" ></div>
<div id="list">
    <div id="list0" class="list">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName" style="left: 55px;"></div>
    </div>
    <div id="list1" class="list">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName" style="left: 223px;"></div>
    </div>
    <div id="list2" class="list">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName" style="left: 390px;"></div>
    </div>
    <div id="list3" class="list">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName" style="left: 550px;"></div>
    </div>
    <div id="list4" class="list">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName" style="left: 731px;"></div>
    </div>
    <div id="list5" class="list">
        <img id="listImg5" class="listImg" />
        <div id="listName5" class="listName" style="left: 896px;"></div>
    </div>
    <div id="list6" class="list" >
        <img id="listImg6" class="listImg" />
        <div id="listName6" class="listName" style="left: 1065px;"></div>
    </div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var maxTitleLen = 6;
    var focusXY = [[57,640],[56,443,834],[51,218,385,553,722,889,1057]];
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
            cursor.blockedNum = this.data.length;
            for (var i = 0; i < this.data.length; i++) {
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                cursor.focusable[i].items = o["data"];
            }
            for ( var i = 0; i < cursor.focusable[2].items.length; i++ ){
                $(String("listName"+i)).innerText = cursor.focusable[2].items[i].name;
            }
            setTimeout(function(){ cursor.call('show');cursor.call('lazyShow');},50);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
        var blocked = cursor.blocked;
        var focus = cursor.focusable[cursor.blocked].focus;
        var items = cursor.focusable[cursor.blocked].items;
        cursor.call('loseFocus');
        cursor.call('stopLazyShow');
        if( index == -11 ) {   //下
            if (blocked < cursor.blockedNum-1 ) {
                blocked++;
                cursor.blocked = blocked;
            }
        }else if (index == 11){   //上
            if ( blocked > 0 ){
                blocked--;
                cursor.blocked = blocked;
            }
        }else if (index == 1){   //右
            if ( focus < items.length-1 ){
                focus++;
                cursor.focusable[cursor.blocked].focus = focus;
            }
        }else if(index == -1){   //左
            if ( focus > 0 ){
                focus--;
                cursor.focusable[cursor.blocked].focus = focus;
            }
        }
        cursor.call('show');
        if( blocked == 2 ){
            cursor.call('lazyShow');
        }
        },
        lazyShow : function(){
            var blocked = 2;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String( focus );
            cursor.calcStringPixels(text, 24, function(width){
                if( width <= 160 ) return;
                $('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
        },
        stopLazyShow : function(){
            var blocked = 2;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String( focus );
            $("listName" + id ).innerText = getStrChineseLength(text) > maxTitleLen?subStr(text,maxTitleLen):text;
        },
        show : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[cursor.blocked].focus;
            $(String("focus"+blocked)).style.left = String(focusXY[blocked][focus])+"px";
            $(String("focus"+blocked)).style.visibility = "visible";
        },
        loseFocus : function(){
            var blocked = cursor.blocked;
            $(String("focus"+blocked)).style.visibility = "hidden";
        }
    });
    -->
</script>
</html>