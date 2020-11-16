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
    Integer picFlag = null;
    picFlag = !isNumber( inner.get("picFlag") ) ? 0 : Integer.valueOf(inner.get("picFlag")); //默认获取栏目下绑定的图片
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
            width: 253px;
            height: 231px;

         }
        .list{
            position: absolute;
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
    var picFlag = <%=picFlag%>;
    var posters = [];
    var codes = [];
    var bgImgs = [];
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

                if (picFlag == 1){
                    for (var j = 0; j < o["data"].length; j++) {
                        posters[j] = o["data"][j].posters['5'][0];
                        codes[j] = o["data"][j].posters['4'][0];
                        bgImgs[j] = o["data"][j].posters['99'][0];
                    }
                }
            }
            var column = <%= inner.writeObject(column)%>;
            if (picFlag == 0) {
                posters = column.posters['4'];  //广告
                codes = column.posters['5'];   // 标题
                bgImgs = column.posters['99'];   // 其他图
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
            if(cursor.enlarged ==1){
                $("pic0").style.backgroundImage = "url("+codes[listBox.position]+")";
                $("pic1").style.backgroundImage = "url("+bgImgs[listBox.position]+")";
                $("pic0").style.visibility = "visible";
                $("pic1").style.visibility = "visible";
                $("enlargedPic").style.visibility = "visible";
            }else {
                $("pic0").style.visibility = "hidden";
                $("pic1").style.visibility = "hidden";
                $("enlargedPic").style.visibility = "hidden";
            }
            //alert("listBox.currPage=="+listBox.currPage+",,,,listBox.listPage==="+listBox.listPage)
            $("focus").style.left = String(76+(listBox.focusPos%4)*279)+"px";
            $("focus").style.top = String(118+Math.floor(listBox.focusPos/4)*247)+"px";
            $("scroll").style.top = String(150+(listBox.currPage-1)*200)+"px";
            $("currPage").innerText = listBox.currPage;
            $("listPage").innerText = listBox.listPage;

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
        var listData = posters;
        listBox = new showList(8,listData.length,0,127,window);
        listBox.showType =0 ;
        listBox.haveData = function(List){
            $("listImg"+String(List.idPos)).src = listData[List.dataPos];
            }
        listBox.notData = function(List){
            $("listImg"+List.idPos).src = "images/global_tm.gif";
        };
        listBox.startShow();
    }
    -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200227Bg.png)" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="focus" style="position: absolute;width: 388px;height: 243px;left: 76px;top: 118px; overflow:hidden; background: url('images/J20201103List3Focus.png') no-repeat; visibility: visible; z-index: 1;" ></div>
<div id="scroll" style="position: absolute;width: 24px;height: 92px;left: 1206px;top: 150px; overflow:hidden; background: transparent no-repeat; visibility: visible;" ></div>
<div id="page" style="position: absolute;width: 44px;height: 150px;left: 1206px;top: 300px; overflow:hidden;" >
    <div id="currPage" style="position: absolute;width: 44px;height: 50px;left: 0px;top: 0px; color: #9C0000; overflow:hidden;" ></div>
    <div id="page0" style="position: absolute;width: 44px;height: 50px;left: 0px;top: 25px; color: #9C0000; overflow:hidden;" >/</div>
    <div id="listPage" style="position: absolute;width: 44px;height: 50px;left: 0px;top: 50px; color: #9C0000; overflow:hidden;" ></div>
</div>

<div id="enlargedPic" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: hidden;overflow: hidden; background: url('images/J20201103ListEnlargedPic.png') no-repeat; z-index: 2;">
    <div id="pic0" style="position: absolute;left: 350px; top: 200px;width: 230px;height: 230px;visibility: hidden;overflow: hidden; background: no-repeat; z-index: 3;">
    </div>
    <div id="pic1" style="position: absolute;left: 697px; top: 205px;width: 220px;height: 220px;visibility: hidden;overflow: hidden; background: no-repeat; z-index: 3;">
    </div>
</div>
<div id="list" style="position: absolute;width: 1100px;height: 600px;left: 50px;top: 120px;">
    <div id="list0" class="list" style="left: 30px; top: 5px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list" style="left: 310px; top: 5px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list" style="left: 590px; top: 5px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list" style="left: 870px; top: 5px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="list" style="left: 30px; top: 250px;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName"></div>
    </div>
    <div id="list5" class="list" style="left: 310px; top: 250px;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName"></div>
    </div>
    <div id="list6" class="list" style="left: 590px; top: 250px;">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName"></div>
    </div>
    <div id="list7" class="list" style="left: 870px; top: 250px;">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName"></div>
    </div>
</div>
</body>
</html>