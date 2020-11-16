<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113411";

    infos.add(new ColumnInfo(typeId, 1, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"99");
    String[] sc = {};
    String[] focusPic = {};
    focusPic = isEmpty( inner.get( "focusPic" )) ? new String[0] : inner.get("focusPic").split("\\,");
    sc = isEmpty( inner.get( "sc" )) ? new String[0] : inner.get("sc").split("\\,");
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
            width: 360px;
            height: 215px;

         }
        .list{
            position: absolute;
            width: 360px;
            height: 215px;
        }
        #scrollLower{
            left: <%= sc[0]%>px;
            top: <%= sc[1]%>px;
            height: <%= sc[2]%>px;
            width: 2px;
            background-color:#<%= sc[3]%>;
            visibility: hidden;
        }
        #scrollUpper {
            background-color:#<%= sc[4]%>;
        }
        #focus{
            position:absolute;
            overflow:hidden;
            left: <%= focusPic[0]%>px;
            top: <%= focusPic[1]%>px;
            width: <%= focusPic[2]%>px;
            height: <%= focusPic[3]%>px;
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
    var scrollFlag = <%= sc[5]%>;
    var scrollWay = <%= sc[6]%>;
    var scrollData = <%= sc[7]%>;
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
            var column = <%= inner.writeObject(column)%>;
            posters = column.posters['1'];
            bgImgs = column.posters['7'];
            if (scrollData == 1) {
                $("scrollUpper").style.width = "5px";
            }

            setTimeout(function(){ initList();cursor.call('show');},150);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
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
            if(cursor.enlarged ==1){
                $("enlargedPic").style.backgroundImage = "url("+bgImgs[listBox.position]+")";
                $("enlargedPic").style.visibility = "visible";
            }else {
                $("enlargedPic").style.visibility = "hidden";
            }
            //alert("listBox.currPage=="+listBox.currPage+",,,,listBox.listPage==="+listBox.listPage)
            $("focus").style.backgroundImage = "url(images/J<%=focusPic[4]%>Focus.png)";
            $("focus").style.left = String(50+(listBox.focusPos%3)*380)+"px";
            $("focus").style.top = String(140+Math.floor(listBox.focusPos/3)*275)+"px";
            // $("scroll").style.top = String(150+(listBox.currPage-1)*200)+"px";
            scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);

        },
        select : function(){
            if( cursor.enlarged ==1 ) {
                cursor.enlarged = 0;
            }else{
                cursor.enlarged = 1;
            }
            cursor.call('show');
        },
        goBack : function(){
            if( cursor.enlarged ==1 ) {
                cursor.enlarged = 0;
                cursor.call('show');
            }else{
                cursor.call('goBackAct');
            }
        },
    });
    function initList(){
        listBox = new showList(6,bgImgs.length,cursor.focusable[0].focus,127,window);
        listBox.showType =0 ;
        listBox.haveData = function(List){
            $("listImg"+String(List.idPos)).src = bgImgs[List.dataPos];
            }
        listBox.notData = function(List){
            $("listImg"+List.idPos).src = "images/global_tm.gif";
        };
        listBox.startShow();
        initScroll(listBox.dataSize,6,listBox.listPage)
    }
    -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200227Bg.png)" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="focus" style="position: absolute;width: 388px;height: 243px;left: 50px;top: 140px; overflow:hidden; background: no-repeat; visibility: visible; z-index: 1;" ></div>
<div id="scrollLower" style="position: absolute;z-index: 1 ">
    <div id="scrollUpper" style="position: absolute;left: -2px; top: 0px; height: 70px;  width: 6px;z-index: 2;"></div>
</div><div id="enlargedPic" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: hidden;overflow: hidden; background: transparent no-repeat; z-index: 2;"></div>
<div id="list" style="position: absolute;width: 1100px;height: 600px;left: 50px;top: 145px;">
    <div id="list0" class="list" style="left: 10px; top: 5px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list" style="left: 390px; top: 5px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list" style="left: 770px; top: 5px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list" style="left: 10px; top: 280px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="list" style="left: 390px; top: 280px;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName"></div>
    </div>
    <div id="list5" class="list" style="left: 770px; top: 280px;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName"></div>
    </div>
</div>
</body>
</html>