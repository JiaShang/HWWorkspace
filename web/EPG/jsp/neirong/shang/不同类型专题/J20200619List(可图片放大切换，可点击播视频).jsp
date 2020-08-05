<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113411";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");

    Integer playFlag = null,direct = null;
    playFlag = inner.getInteger("playFlag", inner.getInteger("playFlag", 1));
    direct = inner.getInteger("direct", inner.getInteger("direct", 1));
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
            width: 238px;
            height: 295px;

         }
        .listOne{
            position: absolute;
            top: 23px;
            width: 360px;
            height: 215px;
        }
        .listTow{
            position: absolute;
            top: 350px;
            width: 360px;
            height: 215px;
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
    var scrollFlag = 1;
    var scrollWay = 2;
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
            var playFlag = <%=playFlag %>;
            if(playFlag == 1){
                for (var i = 0 ; i < this.data[0]["data"].length ; i ++) {
                    if (typeof this.data[0].data[i].posters == 'undefined' || typeof this.data[0].data[i].posters['1'] == 'undefined') {
                        posters[i] = "images/defaultImg.png";
                    }else {
                        posters[i] = this.data[0].data[i].posters['1'];
                    }
                }
            }else{
                if (typeof this.data[0].data[0].posters != 'undefined' && typeof this.data[0].data[0].posters['1'] != 'undefined') {
                    posters = this.data[0].data[0].posters['1'];
                }
                if (typeof this.data[0].data[0].posters != 'undefined' && typeof this.data[0].data[0].posters['7'] != 'undefined') {
                    bgImgs = this.data[0].data[0].posters['7'];
                }
            }

            setTimeout(function(){ initList();cursor.call('show');},150);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
        switch (index) {
            case 11:    //上
                if( listBox.position > 3){
                    listBox.changeList(-4);
                }
                break;
            case -11:   //下
                if( listBox.position < listBox.dataSize-4){
                    listBox.changeList(4);
                }
                break;
            case -1:    //左
                if( listBox.position > 0){
                    listBox.changeList(-1);
                }
                break;
            case 1:     //右
                if( listBox.position < listBox.dataSize-1){
                    listBox.changeList(1);
                }
                break;
        }
        cursor.focusable[0].focus = listBox.position;
        cursor.call('show');
        },
        show : function(){
            var playFlag = <%=playFlag %>;
            if(playFlag == 0 && cursor.enlarged ==1){
                //$("enlargedPic").style.backgroundImage = "url("+bgImgs[listBox.position]+")";
                $("enlargedPic1").src = bgImgs[listBox.position];
                $("enlargedPic").style.visibility = "visible";
            }else {
                $("enlargedPic").style.visibility = "hidden";
            }
            //alert("listBox.currPage=="+listBox.currPage+",,,,listBox.listPage==="+listBox.listPage)
            $("focus").style.left = String(48+(listBox.focusPos%4)*285)+"px";
            $("focus").style.top = String(38+Math.floor(listBox.focusPos/4)*325)+"px";
            //$("scroll").style.top = String(150+(listBox.currPage-1)*(400)/listBox.pageSize)+"px";
            scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage)
        },
        select : function(){
            var playFlag = <%=playFlag %>;
            if (playFlag == 0){
                if( cursor.enlarged ==1 ) {
                    cursor.enlarged = 0;
                }else{
                    cursor.enlarged = 1;
                }
                cursor.call('show');
            }else {
                cursor.call('selectAct');
            }
        },
        goBack : function(){
            var playFlag = <%=playFlag %>;
            if (playFlag == 0 && cursor.enlarged ==1){
                cursor.enlarged = 0;
                cursor.call('show');
            }else {
                cursor.call('goBackAct');
            }
        },
    });
    function initList(){
        listData = posters;
        listBox = new showList(8,listData.length,0,127,window);
        listBox.showType =0 ;
        listBox.haveData = function(List){
            $("listImg"+String(List.idPos)).src = listData[List.dataPos];
            }
        listBox.notData = function(List){
            $("listImg"+List.idPos).src = "images/global_tm.gif";
        };
        listBox.startShow();
        initScroll(listBox.dataSize,8,listBox.listPage)
    }
    -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "none" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="focus" style="position: absolute;width: 260px;height: 313px;left: 48px;top: 38px; overflow:hidden; background: url('images/J20200619ListFocus.png') no-repeat; visibility: visible; z-index: 1;" ></div>
<div id="scrollLower" style="position: absolute;width: 7px;height: 660px;left: 1214px;top: 30px;background-color: #959ea5; visibility: visible;" >
    <div id="scrollUpper" style="position: absolute;width: 24px;height: 92px;left: -8px;top: 0px; overflow:hidden; background: url('images/J20191120ListScroll.png') no-repeat;z-index: 1;" ></div>
</div>
<div  id="enlargedPic" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: hidden;overflow: hidden; background: transparent no-repeat; z-index: 2;">
    <img id="enlargedPic1" style="width: 1280px;height: 720px;" src="">
</div>
<div id="list" style="position: absolute;width: 1100px;height: 600px;left: 50px;top: 20px;">
    <div id="list0" class="listOne" style="left: 10px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="listOne" style="left: 300px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="listOne" style="left: 580px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="listOne" style="left: 860px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="listTow" style="left: 10px;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName"></div>
    </div>
    <div id="list5" class="listTow" style="left: 300px;;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName"></div>
    </div>
    <div id="list6" class="listTow" style="left: 580px;">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName"></div>
    </div>
    <div id="list7" class="listTow" style="left: 860px;">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName"></div>
    </div>
</div>
</body>
</html>