<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114280";

    Column column = new Column();
    List<Column> columns = inner.getList(typeId, 3, 0, column);
    for( Column col : columns ) {
        infos.add(new ColumnInfo(col.getId(), 0, 99));
    }
    Result result = new Result( typeId, columns );
    //获取当前栏目的详细信息
    column = inner.getDetail(typeId,column);
    String picture = "";
//    picture = "images/J20200225Bg.png";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "6");
    }
%>
<html>
<head>
    <title><%=column == null ? "“双11” 我们玩真的！" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .container {width: 1280px;height:720px;left:0px;top:0px; position:absolute; background: transparent url("<%=picture%>") no-repeat left top;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div id="container" class="container"></div>

<div id="focus0" style="position: absolute;width: 473px;height: 61px;left: 103px;top: 213px;background:transparent url('images/J20200310Focus0.png') no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="focus1" style="position: absolute;width: 506px;height: 93px;left: 85px;top: 573px;background:transparent url('images/J20200310Focus1.png') no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="focus2" style="position: absolute;width: 600px;height: 93px;left: 590px;top: 573px;background:transparent url('images/J20200310Focus2.png') no-repeat;overflow:hidden; visibility: hidden;"></div>
<div id="list" style="position: absolute;width: 430px;height: 280px;left: 120px;top: 237px;background:transparent; font-size: 24px;color: #ffffff;line-height: 38px;">
    <div id="list0" style="position: absolute;width: 435px;height: 38px;top: 10px;overflow:hidden;"></div>
    <div id="list1" style="position: absolute;width: 435px;height: 38px;top: 58px;overflow:hidden;"></div>
    <div id="list2" style="position: absolute;width: 435px;height: 38px;top: 106px;overflow:hidden;"></div>
    <div id="list3" style="position: absolute;width: 435px;height: 38px;top: 155px;overflow:hidden;"></div>
    <div id="list4" style="position: absolute;width: 435px;height: 38px;top: 203px;overflow:hidden;"></div>
    <div id="list5" style="position: absolute;width: 435px;height: 38px;top: 250px;overflow:hidden;"></div>
</div>
<div id="pageData" style="position: absolute;width: 60px;height: 30px;top: 535px;left:512px;overflow:hidden;font-size: 22px;color: #ffffff;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var maxTitleLen = 22;
    var initialize = {
        data        : [<%
                String html = "";
                html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"}) + ",\n";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    inner.special = true;
                    result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            // cursor.lastBlocked = 1;
            cursor.lastBlocked = cursor.blocked > 0 ? cursor.blocked : 1;
            cursor.playBlocked = 0;
            cursor.playIndex = 0;
            for (var i = 0; i < this.data.length-1; i++) {
                var o = this.data[i+1];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
                cursor.focusable[i].focus = this.focused.length > i+1 ? Number(this.focused[i+1]) : 0;
            }

            cursor.focusable[1].items = [];
            cursor.focusable[1].items[0] = {
                'linkto': '/EPG/jsp/neirong/shang/J20200310List.jsp?typeId=' + this.data[2]["id"]
            }
                 // }else {
                 //     cursor.focusable[i].items = [];
                 //     cursor.focusable[i].items[0] = {
                 //         'linkto': '/EPG/jsp/neirong/shang/J20200310List.jsp?typeId=' + this.data[i+1]["id"]
                 //     }
            setTimeout(function(){
                cursor.call('initList');
                cursor.call('show');
                cursor.call('lazyShow');},100);
            setTimeout(function(){ cursor.call('prepareVideo');},50);
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            cursor.call('loseFocus');
            if(index == -11){  //下
                if(blocked == 0){
                    if(listBox.focusPos < 5 && listBox.position<items.length-1){
                        listBox.changeList(1);
                        cursor.focusable[blocked].focus = listBox.position;
                    }else {
                        blocked = cursor.lastBlocked;
                        cursor.lastBlocked = blocked;
                    }
                }

            }else if(index == 11){  //上
                if (blocked > 0) {
                    cursor.lastBlocked = blocked;
                    blocked = 0;
                }else if (blocked == 0){
                    if (listBox.focusPos > 0){
                        listBox.changeList(-1);
                        cursor.focusable[blocked].focus = listBox.position;
                    }
                }
            }else if(index == 1) {  //右
                if (blocked > 0 && blocked < 3) {
                    blocked++;
                }else if (blocked == 0 && listBox.currPage < listBox.listPage) {
                    listBox.changePage(1);
                    cursor.focusable[blocked].focus=listBox.position;
                }
            }else if(index == -1) {  //左
                if (blocked > 1 ) {
                    blocked--;
                }else if (blocked == 0 && listBox.currPage > 0 ) {
                    listBox.changePage(-1);
                    cursor.focusable[blocked].focus=listBox.position;
                }
            }
            cursor.blocked = blocked;
            cursor.call('show');
            cursor.call('lazyShow');
            $("pageData").innerText = listBox.currPage + "/" + listBox.listPage;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                cursor.moveTimer = undefined;
                var focus = cursor.focusable[0].focus;
                if(cursor.blocked == 0 && cursor.playIndex != focus){
                    cursor.playIndex = focus ;
                    // cursor.playBlocked = blocked;
                    cursor.call('prepareVideo');
                }
            }, 800);
        },
        lazyShow    :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[0].focus;
            if( blocked <= 0 && focus > 0 ) {
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String(focus);
            cursor.calcStringPixels(text, 24, function(width){
                if( width <= 420 ) return;
                $('list' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
            };
        },
        nextVideo   :   function () {
            var blocked = cursor.playBlocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            cursor.call('loseFocus');
            if( focus == items.length-1){
                listBox.focusPos = 0;
                listBox.position = 0;
            }else{
                listBox.changeList(1);
            }
            cursor.focusable[blocked].focus = listBox.position;
            cursor.playBlocked = blocked;
            cursor.playIndex = focus ;
            cursor.call('show');
            cursor.call('lazyShow');
            cursor.call('prepareVideo');
        },
        prepareVideo : function(){
            var blocked = cursor.playBlocked;
            var focus = cursor.focusable[blocked].focus;
            cursor.playIndex = focus;
            var item = cursor.focusable[blocked].items[ cursor.playIndex ];
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:595,height:378,left:593,top:195},
                callback:function(){
                }
            });
        },
        initList      :   function(){
            var blocked = 0;
            var focus = cursor.focusable[blocked].focus;
            listData = cursor.focusable[blocked].items;
            listBox = new showList(6, listData.length, focus, 127, window);
            listBox.showType = 0;
            listBox.haveData = function (List) {
                $("list" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
            }
            listBox.notData = function (List) {
                $("list" + List.idPos).innerText = "";
            };
            listBox.startShow();
            $("pageData").innerText = listBox.currPage + "/" + listBox.listPage;
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus0 = cursor.focusable[0].focus;
            if( blocked == 0){
                $("focus0").style.top = String(listBox.focusPos*49+233)+"px";
                $("focus0").style.visibility = "visible";
                $("focus1").style.visibility = "hidden";
                $("focus2").style.visibility = "hidden";
            }else if( blocked == 1){
                $("focus1").style.visibility = "visible";
                $("focus0").style.visibility = "hidden";
                $("focus2").style.visibility = "hidden";
            }else {
                $("focus2").style.visibility = "visible";
                $("focus1").style.visibility = "hidden";
                $("focus0").style.visibility = "hidden";
            }
        },
        loseFocus        :   function(){
            var blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[cursor.blocked].focus;
            if( blocked <= 0){
                // $("list"+String(focus)).style.backgroundColor = "transparent";
                // $("list"+String(focus)).style.color = "#000000";
                $('list' + String(listBox.focusPos)).innerText = getStrChineseLength(items[focus].name) > maxTitleLen?subStr(items[focus].name,maxTitleLen,"..."):items[focus].name;
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>