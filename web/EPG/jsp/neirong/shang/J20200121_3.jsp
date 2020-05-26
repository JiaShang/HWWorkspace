<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113921";

    infos.add(new ColumnInfo(typeId, 0, 99));
//    List<Column> columns = inner.getList(typeId, 30 , 0 , new Column());
//    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
//        infos.add(new ColumnInfo(columns.get(i).id, 0, 8));
//    }

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
            position: relative;
            width: 154px;
            height: 30px;
            left: 5px;
            top: 0px;
            color: #ffffff;
            font-size:22px;
            overflow: hidden;
            text-align: center;
            line-height: 30px;
            background-color: #7D7D7D;
            z-index: 1;
        }
        .list{
            position: absolute;
            width: 164px;
            height: 235px;
        }
        #listOne{
            position: absolute;
            left: 140px;
            top: 200px;
            width: 1000px;
            height: 300px;
        }
        #listTow{
            position: absolute;
            left: 140px;
            top: 450px;
            width: 1000px;
            height: 300px;
        }
        img{
            position: relative;
            left: 5px;
            top: 5px;
            width: 154px;
            height: 200px;
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
            cursor.blockedNum = this.data.length;
            for (var i = 0; i < this.data.length; i++) {
                var o = this.data[i];
                posters[i] = new Array();
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                cursor.focusable[i].items = o["data"];
                for(var j = 0; j < cursor.focusable[i].items.length; j++){
                    if((typeof cursor.focusable[i].items[j].posters!== "undefined")&&(typeof cursor.focusable[i].items[j].posters['1']!== "undefined")){
                        posters[i][j] = cursor.focusable[i].items[j].posters['1'][0];
                    }else{
                        posters[i][j] = "images/defaultImg.png";
                    }
                }
            }
            var column = <%= inner.writeObject(column)%>;
            bgImgs = column.posters['7']
            setTimeout(function(){ initList();cursor.call('show');},150);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
        var blocked = cursor.blocked;
        cursor.call('loseFocus');
        switch (index) {
            case 11:    //上
                if( listBox.position > 4){
                    listBox.changeList(-5);
                }
                $("body").style.backgroundImage = "url("+bgImgs[listBox.currPage-1]+")";
                break;
            case -11:   //下
                if( listBox.position < listBox.dataSize-5 ){
                    listBox.changeList(5);
                }else{
                    if ( Math.floor((listBox.focusPos+(listBox.dataSize-1-listBox.position))/5) != Math.floor(listBox.focusPos/5)){
                        listBox.changeList(listBox.dataSize-1-listBox.position);
                    }
                }
                $("body").style.backgroundImage = "url("+bgImgs[listBox.currPage-1]+")";
                break;
            case -1:    //左
                if( listBox.focusPos != 0 && listBox.focusPos != 5){
                    listBox.changeList(-1);
                }
                break;
            case 1:     //右
                if( listBox.focusPos != 4 && listBox.focusPos != 9){
                    listBox.changeList(1);
                }
                break;
        }
        cursor.focusable[blocked].focus = listBox.position;
        scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
        cursor.call('show');
        },
        lazyShow : function(){
            //var focus = listBox.position;
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            //var id = String( focus + 1 );
            var id = String( listBox.focusPos );
            cursor.calcStringPixels(text, <%= 22 %>, function(width){
                if( width <= <%= 154-20 %> ) return;
                $('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
        },
        show : function(){
            $("list"+ String(listBox.focusPos)).style.backgroundColor = "#ffcc00";
            $("listName"+ String(listBox.focusPos)).style.backgroundColor = "#FBBA54";
            cursor.call('lazyShow');
        },
        loseFocus : function(){
            $("list"+ String(listBox.focusPos)).style.backgroundColor = "transparent";
            $("listName"+ String(listBox.focusPos)).style.backgroundColor = "#7D7D7D";
            $("listName"+ String(listBox.focusPos)).innerText = listData[listBox.position].name;
        },
    });
    function initList(){
        var starPos = cursor.focusable[cursor.blocked].focus;
        listData = cursor.focusable[cursor.blocked].items;
        listBox = new showList(10,listData.length,starPos,127,window);
        listBox.showType =0 ;
        listBox.haveData = function(List){
            $("listImg"+String(List.idPos)).src = posters[cursor.blocked][List.dataPos];
            $("listName"+String(List.idPos)).innerText = listData[List.dataPos].name;
            $("listName"+ String(List.idPos)).style.backgroundColor = "#7D7D7D";
            // $("list"+ String(List.idPos)).style.border = "5px solid transparent";
        }
        listBox.notData = function(List){
            $("listImg"+List.idPos).src = "images/global_tm.gif";
            $("listName"+String(List.idPos)).innerText = "";
            $("listName"+ String(List.idPos)).style.backgroundColor = "transparent";
        };
        listBox.startShow();
        $("body").style.backgroundImage = "url("+bgImgs[listBox.currPage-1]+")";
        initScroll(listBox.dataSize,1,listBox.listPage);

    }
    -->
    </script>
</head>
<body id="body" leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="scrollLower" style="position: absolute; left: 73px; top: 213px; width: 5px; background-color: transparent; visibility: hidden; height: 448px;">
    <div id="scrollUpper" style="position: absolute; top: 0px; height: 150px;width: 15px;left: -12px; background-color: #fbba54;z-index: 1;color: #ff0c01;font-size: 22px;"></div>
</div>
<div id="listOne">
    <div id="list0" class="list" style="left: 46px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list" style="left: 240px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list" style="left: 434px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list" style="left: 628px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="list" style="left: 822px;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName"></div>
    </div>
</div>
<div id="listTow">
    <div id="list5" class="list" style="left: 46px;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName"></div>
    </div>
    <div id="list6" class="list" style="left: 240px;">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName"></div>
    </div>
    <div id="list7" class="list" style="left: 434px;">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName"></div>
    </div>
    <div id="list8" class="list" style="left: 628px;">
        <img id="listImg8" class="listImg"/>
        <div id="listName8" class="listName"></div>
    </div>
    <div id="list9" class="list" style="left: 822px;">
        <img id="listImg9" class="listImg"/>
        <div id="listName9" class="listName"></div>
    </div>
</div>
</body>
</html>