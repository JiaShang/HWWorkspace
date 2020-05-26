<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>

<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String blocked = inner.get("blocked");
    String picture = "images/J20200110ListBg"+blocked+".jpg";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }
//    if(picture == ""){
//        picture = "images/J20200110ListBg"+blocked+".jpg";
//    }
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .text{
            width: 800px;
            height: 55px;
            color: #000000;
            font-size:24px;
            background-color: transparent;
            overflow: hidden;
            text-align: left;
            line-height: 55px;
        }
        .icon{
            position: absolute;
            width: 15px;
            height: 16px;
            left: -30px;
            top: 18px;
            background-repeat: no-repeat;
            overflow: hidden;
        }
        #list{
            position: absolute;
            width: 1000px;
            height: 400px;
            left: 250px;
            top: 233px;
        }
        .list{
            position: absolute;
        }

</style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
<script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var maxTitleLen = 45;
    var scrollFlag = 1;
    var scrollWay = 1;
    cursor.initialize({
        data : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            listData = cursor.focusable[0].items;
            setTimeout(function(){
                initList();
                cursor.call('show');
            },150);
            setTimeout(function(){cursor.call('lazyShow');},250);

        },
        nextVideo   :   function () {
            var playIndex = cursor.playIndex;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[0].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            if( cursor.focusable[0].items.length <= 0 )return;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie",item);
        },
        playMovie : function(item){
            var pos = cursor.moviePos;
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
                callback:function(){
                    cursor.focusable[0].focus = cursor.playIndex;
                    cursor.call('show');
                    setTimeout(function(){cursor.call('lazyShow');},50);
                }
            });
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            cursor.call('stopLazyShow');
            if( index == 11 && listBox.position > 0){
                listBox.changeList(-1);
            }else if( index == -11 && listBox.position < listBox.dataSize-1){
                listBox.changeList(1);
            }
            cursor.focusable[blocked].focus = listBox.position;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                cursor.call('lazyShow');
            }, 1000);
            cursor.call('show');
        },
        lazyShow : function(){
            var focus = listBox.position;
            var blocked = 0;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String( listBox.focusPos );
            cursor.calcStringPixels(text, 24, function(width){
                if( width <= 760 ) return;
                $('text' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
        },
        stopLazyShow : function(){
            var focus = listBox.focusPos;
            $("text" + String(focus)).innerText = getStrChineseLength(listData[listBox.position].name) > maxTitleLen?subStr(listData[listBox.position].name,maxTitleLen,"..."):listData[listBox.position].name;
            $("icon" + String(focus)).style.backgroundImage = "url(images/J20200110Point0.png)";
        },
        show:function(){
            var items = cursor.focusable[0].items;
            if( items.length <= 0 ) return;
            var focus = listBox.focusPos;
           // alert("listBox.focusPos==="+listBox.focusPos+",,,listBox.position==="+listBox.position);
            $("focus").style.top = String(listBox.focusPos*67+230)+"px";
            $("icon" + String(focus)).style.backgroundImage = "url(images/J20200110Point1.png)";
            scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage)
            if(listBox.dataSize >= 10){
                if(listBox.position+1 >= 10){
                    $("scrollUpper").innerHTML = (listBox.position+1)+"<br />&nbsp;/<br />"+listBox.dataSize;
                }else{
                    $("scrollUpper").innerHTML = "&nbsp;"+(listBox.position+1)+"<br />&nbsp;/<br />"+listBox.dataSize;
                }
            }else {
                $("scrollUpper").innerHTML = "&nbsp;"+(listBox.position+1)+"<br />&nbsp;/<br />&nbsp;"+listBox.dataSize;
            }
        }
    });
    function initList() {
        var focus = cursor.focusable[0].focus;
        listBox = new showList(6, listData.length, focus, 127, window);
        listBox.showType = 1;
        listBox.haveData = function (List) {
            $("icon" + String(List.idPos)).style.backgroundImage = "url(images/J20200110Point0.png)";
            $("text" + String(List.idPos)).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
        }
        listBox.notData = function (List) {
            $("text" + String(List.idPos)).innerText = "";
            $("icon"+String(List.idPos)).style.backgroundImage = "images/global_tm.gif";
        };
        listBox.startShow();
        initScroll(listBox.dataSize,6,listBox.listPage)
        $("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />"+listBox.dataSize;
    }
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 24px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "none" : (" url('" + picture + "')")%> no-repeat;"></div>
<div id="focus" style="position: absolute;width: 896px;height: 64px;left: 183px;top:230px;background:transparent url('images/J20200110ListFocus.png') no-repeat;overflow:hidden; visibility: visible;"></div>
<div id="scrollLower" style="position: absolute; left: 1120px; top: 230px; width: 5px; background-color: #dddddd; visibility: hidden; height: 400px;">
    <div id="scrollUpper" style="position: absolute; top: 0px; height: 85px;width: 28px;left: -12px; background-color: #c2261c;z-index: 1;color: #ffffff;font-size: 22px;"></div>
</div>

<div id="list">
    <div id="list0" class="list" style="top: 5px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName">
            <div id="icon0" class="icon" ></div>
            <div id="text0" class="text"></div>
        </div>
    </div>
    <div id="list1" class="list" style="top: 71px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName">
            <div id="icon1" class="icon" ></div>
            <div id="text1" class="text"></div>
        </div>
    </div>
    <div id="list2" class="list" style="top: 137px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName">
            <div id="icon2" class="icon" ></div>
            <div id="text2" class="text"></div>
        </div>
    </div>
    <div id="list3" class="list" style="top: 205px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName">
            <div id="icon3" class="icon" ></div>
            <div id="text3" class="text"></div>
        </div>
    </div>
    <div id="list4" class="list" style="top: 273px;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName">
            <div id="icon4" class="icon" ></div>
            <div id="text4" class="text"></div>
        </div>
    </div>
    <div id="list5" class="list" style="top: 340px;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName">
            <div id="icon5" class="icon" ></div>
            <div id="text5" class="text"></div>
        </div>
    </div>
    <div id="list6" class="list" style="top: 395px;">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName">
            <div id="icon6" class="icon" ></div>
            <div id="text6" class="text"></div>
        </div>
    </div>
    <div id="list7" class="list" style="top: 360px;">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName">
            <div id="icon7" class="icon" ></div>
            <div id="text7" class="text"></div>
        </div>
    </div>
</div>
</body>
</html>