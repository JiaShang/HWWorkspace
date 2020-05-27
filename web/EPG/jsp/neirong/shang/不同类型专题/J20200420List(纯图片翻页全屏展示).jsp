<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114402";

//    infos.add(new ColumnInfo(typeId, 0, 99));
//    List<Column> columns = inner.getList(typeId, 30 , 0 , new Column());
//    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
//        infos.add(new ColumnInfo(columns.get(i).id, 0, 8));
//    }
    infos.add(new ColumnInfo(typeId, 0, 99));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
//    direct 为空时，左右移动
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");
    String fc = null;
    Integer blocked = null,focus=null,direct = null;
    fc = isEmpty( inner.get("fc") ) ? "ccc000" : inner.get("fc");
    blocked = !isNumber( inner.get("blocked") ) ? 0 : Integer.valueOf(inner.get("blocked"));
    focus = !isNumber( inner.get("focus") ) ? 0 : Integer.valueOf(inner.get("focus"));
    direct = !isNumber( inner.get("direct") ) ? 0 : Integer.valueOf(inner.get("direct"));
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
            visibility: hidden;
        }
        .list{
            position: absolute;
            width: 164px;
            height: 235px;
        }
        #listOne{
            position: absolute;
            left: 0px;
            top: 0px;
            width: 1280px;
            height: 720px;
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
        var pageCount = 1;
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

                    cursor.focusable[i] = {};
                    cursor.focusable[i].typeId = o["id"];
                    cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                    cursor.focusable[i].items = o["data"];
                }
                if(typeof cursor.focusable[<%=blocked%>].items[<%=focus%>].posters != 'undefined'){
                    if(typeof cursor.focusable[<%=blocked%>].items[<%=focus%>].posters['7'] != 'undefined'){
                        bgImgs = cursor.focusable[<%=blocked%>].items[<%=focus%>].posters['7'];
                    }else {
                        bgImgs = ["images/defaultImg.png"];
                    }
                }
                <%--posters = cursor.focusable[<%=blocked%>].items[<%=focus%>].posters['5'];--%>

                setTimeout(function(){ initList();},150);
            },
            move : function(index){
                //上 11，下 -11，左 -1，右 1
                // var blocked = cursor.blocked;
                // cursor.call('loseFocus');
                var direct = <%=direct %>;

                if (direct == 0){  //默认左右翻页
                    if (index == -1){
                        listBox.changeList(-1);
                    } else if (index == 1){
                        listBox.changeList(1);
                    }

                }else {
                    if (index == 11){
                        listBox.changeList(-1);
                    } else if (index == -11){
                        listBox.changeList(1);
                    }
                }
                $("page").innerText = listBox.position+1+"/"+listBox.dataSize;
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
            select : function(){ return;},
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
            // var starPos = cursor.focusable[cursor.blocked].focus;
            listData = bgImgs;
            listBox = new showList(pageCount,listData.length,0,127,window);
            listBox.showType =1 ;
            listBox.focusFixed = true;
            listBox.haveData = function(List){
                $("listImg"+String(List.idPos)).src = listData[List.dataPos];
            }
            listBox.notData = function(List){
                $("listImg"+List.idPos).src = "images/global_tm.gif";
            };
            listBox.startShow();
            // $("body").style.backgroundImage = "url("+bgImgs[listBox.currPage-1]+")";
            // initScroll(listBox.dataSize,1,listBox.listPage);
            $("page").innerText = listBox.position+1+"/"+listBox.dataSize;

        }
        -->
    </script>
</head>
<body id="body" leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="scrollLower" style="position: absolute; left: 73px; top: 213px; width: 5px; background-color: transparent; visibility: hidden; height: 448px;">
    <div id="scrollUpper" style="position: absolute; top: 0px; height: 150px;width: 15px;left: -12px; background-color: #fbba54;z-index: 1;color: #ff0c01;font-size: 22px;"></div>
</div>
<div id="page" style="position: absolute;left: 590px;top: 600px;width: 100px;height: 80px;font-size: 50px;color:#<%=fc%>;z-index: 2;text-align: center;line-height: 80px;"></div>
<div id="listOne">
    <div id="list0" class="list" style="left: 0px;">
        <img id="listImg0" class="listImg" style="left: 0px; top: 0px; width: 1280px; height: 720px;"/>
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