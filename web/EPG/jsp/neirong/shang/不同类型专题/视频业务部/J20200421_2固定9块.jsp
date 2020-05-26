<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114701";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .listName{
            width: 300px;
            height: 60px;
            top: 210px;
            color: #ffffff;
            font-size:24px;
            background-color: transparent;
            overflow: hidden;
            text-align: center;
            line-height: 60px;
        }
        img{
            width: 296px;
            height: 174px;

        }
        .list{
            position: absolute;
            width: 360px;
            height: 215px;
        }
        #list{
            position: absolute;
            left: 150px;
            top: 170px;
        }
        #scrollLower{
            position: absolute;
            left: 1150px;
            top: 170px;
            height: 440px;
            width: 6px;
            background-color: #909090;
            visibility: hidden;
        }
        #scrollUpper {
        <%--background-color:#<%= sc[4]%>;--%>
            position: absolute;
            background-image: url("images/J20200414ListScroll.png");
            width: 24px;
            height: 100px;
            left: -9px;
            background-repeat: no-repeat;
            overflow: hidden;
            color: #006339;
            padding-top: 10px;
            padding-left: 2px;
            margin-top: 10px;
            visibility: hidden;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
    <script language="javascript" type="text/javascript">
        <!--
        var listBox = null;
        var listData = [];
        var posters = [];
        var bgImgs = [];
        var scrollFlag = 0;
        var scrollWay = 2;
        var scrollData = 1;
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
                cursor.enlarged = 0;
                for (var i = 0; i < this.data.length; i++) {
                    var o = this.data[i];
                    cursor.focusable[i] = {};
                    cursor.focusable[i].typeId = o["id"];
                    cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                    cursor.focusable[i].items = o["data"];
                }
                setTimeout(function(){ initList();cursor.call('show');},150);
            },
            move : function(index){
                //上 11，下 -11，左 -1，右 1
                // if(cursor.enlarged ==1) return;
                switch (index) {
                    case 11:    //上
                        if( listBox.position > 2){
                            listBox.changeList(-3);
                        }
                        break;
                    case -11:   //下
                        if( listBox.position < listBox.dataSize-3){
                            listBox.changeList(3);
                        }
                        break;
                    case -1:    //左
                        if( listBox.focusPos%3 != 0){
                            listBox.changeList(-1);
                        }
                        break;
                    case 1:     //右
                        if( listBox.focusPos%3 != 2){
                            listBox.changeList(1);
                        }
                        break;
                }
                cursor.focusable[0].focus = listBox.position;
                scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
                cursor.call('show');
            },
            show : function(){
                $("focus").style.left = String(260+(listBox.focusPos%3)*254)+"px";
                $("focus").style.top = String(184+Math.floor(listBox.focusPos/3)*147)+"px";
            },
        });
        function initList(){
            var blocked = cursor.blocked;
            listData = cursor.focusable[blocked].items;
            var startPos = cursor.focusable[blocked].focus;
            listBox = new showList(9,listData.length,startPos,127,window);
            listBox.showType =0 ;
            listBox.haveData = function(List){
                if ( typeof listData[List.dataPos].posters == "undefined" || typeof listData[List.dataPos].posters['1'] == "undefined" || listData[List.dataPos].posters['1'].length <= 0){
                    $("listImg"+String(List.idPos)).src = "images/defaultImg.png";
                } else {
                    $("listImg"+String(List.idPos)).src = listData[List.dataPos].posters['1'][0];
                }
            }
            listBox.notData = function(List){
                $("listImg"+List.idPos).src = "images/global_tm.gif";
            };
            listBox.startShow();
            initScroll(listBox.dataSize,9,listBox.listPage)
        }
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200414ListBg.jpg)" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="focus" style="position: absolute;width: 254px;height: 148px;left: 260px;top: 184px; overflow:hidden; background: url('images/J20200421_2Focus.png') no-repeat; visibility: visible; z-index: 1;" ></div>
<%--<div id="scroll" style="position: absolute;width: 24px;height: 92px;left: 1206px;top: 150px; overflow:hidden; background: url('images/J20200414ListScroll.png') no-repeat; visibility: visible;" ></div>--%>
<div id="scrollLower" style="z-index: 1; ">
    <div id="scrollUpper" style="z-index: 2;"></div>
</div>
<div id="list" style="width: 1100px;height: 600px;visibility: hidden;">
    <div id="list0" class="list" style="left: 10px; top: 20px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list" style="left: 340px; top: 20px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list" style="left: 670px; top: 20px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list" style="left: 10px; top: 245px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="list" style="left: 340px; top: 245px;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName"></div>
    </div>
    <div id="list5" class="list" style="left: 670px; top: 245px;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName"></div>
    </div>
    <div id="list6" class="list" style="left: 10px; top: 20px;">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName"></div>
    </div>
    <div id="list7" class="list" style="left: 340px; top: 20px;">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName"></div>
    </div>
    <div id="list8" class="list" style="left: 670px; top: 20px;">
        <img id="listImg8" class="listImg"/>
        <div id="listName8" class="listName"></div>
    </div>
    <div id="list9" class="list" style="left: 10px; top: 245px;">
        <img id="listImg9" class="listImg"/>
        <div id="listName9" class="listName"></div>
    </div>
    <div id="list10" class="list" style="left: 340px; top: 245px;">
        <img id="listImg10" class="listImg"/>
        <div id="listName10" class="listName"></div>
    </div>
    <div id="list11" class="list" style="left: 670px; top: 245px;">
        <img id="listImg11" class="listImg"/>
        <div id="listName11" class="listName"></div>
    </div>
</div>
</body>
</html>