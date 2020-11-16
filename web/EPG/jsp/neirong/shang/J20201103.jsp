<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    w:整个条目的宽度
    h:所有条目高度的和
    ih:元素的高度
    mr:两个条目之间的空隙
    fs:字体大小
    lft:文本块显示坐标 LEFT
    tp:文本块显示坐标 TOP
    cl:文字颜色
    al:文字对齐方式，0:左对齐，１:居中对齐, 2:右对齐
    bg:普通条目背景颜色
    fc:焦点文字颜色
    bc:焦点背景
    pg:页面显示内容条数
    sc:滚动条样式left,top,heihgt,bgColor,fcColor
    video:视频窗位置，width,height,left,top (如果没有表示无小窗口播放)
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000119360";

//    infos.add(new ColumnInfo(typeId, 0, 99));
    Column column = new Column();
    List<Column> columns = inner.getList(typeId, 8, 0, column);   //（id，查询数据条数，开始查询位置）
    for( Column col : columns ) {
        infos.add(new ColumnInfo(col.getId(), 0, 99));
    }

    //获取当前栏目的详细信息
//    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("images/J20201103Bg.png",column.getPosters(),"7");
//    picture = "images/J20201103Bg.png";
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .listName{
            visibility: hidden;
            position: absolute;
            color: #8b0000;
            /*background-image: url("images/J20200227Focus0.png");*/
            font-size:24px;
            overflow: hidden;
            line-height: 43px;
            width: 204px;
            height: 43px;
            text-align: center;
            background-repeat: no-repeat;
        }
        #list{
            visibility: hidden;
            position: absolute;
            left: 90px;
            top: 570px;
            width: 800px;
            height: 60px;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200227Bg.png)" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">

<div id="focus0" style="position: absolute;width: 535px;height: 305px;left: 57px;top: 220px; overflow:hidden; background: url('images/J20201103Focus0.png') no-repeat; visibility: hidden;" ></div>
<div id="focus1" style="position: absolute;width: 110px;height: 305px;left: 599px;top: 220px; overflow:hidden; background: url('images/J20201103Focus1.png') no-repeat; visibility: hidden;" ></div>
<div id="focus2" style="position: absolute;width: 246px;height: 153px;left: 715px;top: 220px; overflow:hidden; background: url('images/J20201103Focus2.png') no-repeat; visibility: hidden;" ></div>
<div id="focus3" style="position: absolute;width: 163px;height: 148px;left: 715px;top: 376px; overflow:hidden; background: url('images/J20201103Focus3.png') no-repeat; visibility: hidden;" ></div>
<div id="focus7" style="position: absolute;width: 925px;height: 118px;left: 285px;top: 560px; overflow:hidden; background: url('images/J20201103Focus4.png') no-repeat; visibility: hidden;" ></div>
<div id="logo" style="position: absolute;width: 105px;height: 118px;left: 323px;top: 545px; overflow:hidden; background: url('images/J20201103Logo.png') no-repeat;" ></div>
<div id="time" style="position: absolute;width: 300px;height: 200px;left: 870px;top: 165px; overflow:hidden; background: transparent no-repeat; color: #ffbf5a;font-size: 50px;visibility: hidden;" ></div>
<div id="tooltip" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;">
<div id="list">
    <div id="list0" class="list0">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName" style="left: 10px;"></div>
    </div>
    <div id="list1" class="list0">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName" style="left: 195px;"></div>
    </div>
    <div id="list2" class="list0">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName" style="left: 380px;"></div>
    </div>
    <div id="list3" class="list0">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName" style="left: 585px;"></div>
    </div>
    <div id="list4" class="list0">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName" style="left: 780px;"></div>
    </div>
    <div id="list5" class="list0">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName" style="left: 585px;"></div>
    </div>
    <div id="list6" class="list0">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName" style="left: 780px;"></div>
    </div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var focusArea = 0;
    var tipFlag = -1;
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl = '<%= backUrl %>';
            cursor.playIndex = 0;
            cursor.serviceId = 2603;
            cursor.frequency = 2750000;
            cursor.channelId = '3792';
            cursor.program = '3';
            cursor.trafficId = 	[491,493,494,495,496] ;
            for (var i = 0; i < this.data.length ; i++) {
                var o = this.data[i];
                cursor.focusable[i] = {};
                if (typeof o["id"] != 'undefined'){
                    cursor.focusable[i].typeId = o["id"];
                } else {
                    cursor.focusable[i].typeId = '';
                }
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                if (typeof o["data"] != 'undefined'){
                    cursor.focusable[i].items = o["data"];
                }else {
                    cursor.focusable[i].items = [];
                }
            }
            // cursor.focusable[4] = {};
            // cursor.focusable[4].focus = 0;
            // cursor.focusable[4].items = [];
            cursor.focusable[1].items[0] = {
                'name':'大足石刻',
                'typeId':'',
                'linkto':'/EPG/jsp/neirong/shang/J20191217.jsp?typeId='+cursor.focusable[1].typeId+'&video=466,267,106,198'
            }
            cursor.focusable[2].items[0] = {
                'name':'国泰演出',
                'typeId':'',
                'linkto':'/EPG/jsp/neirong/shang/Jpicture.jsp?typeId='+cursor.focusable[2].typeId+'&direct=1'
            }
            cursor.focusable[3].items[0] = {
                'name':'涪陵大剧院',
                'typeId':'',
                'linkto':'/EPG/jsp/neirong/shang/Jpicture.jsp?typeId='+cursor.focusable[3].typeId+'&direct=1'
            }
            cursor.focusable[4].items[0] = {
                'name':'唱作专场',
                'typeId':'',
                'linkto':'/EPG/jsp/neirong/shang/Jpicture.jsp?typeId='+cursor.focusable[4].typeId+'&direct=1'
            }
            cursor.focusable[5].items[0] = {
                'name':'欢乐马戏',
                'typeId':'',
                'linkto':'/EPG/jsp/neirong/shang/J20191217.jsp?typeId='+cursor.focusable[5].typeId+'&video=466,267,697,145'
            }
            cursor.focusable[6].items[0] = {
                'name':'腾旅渝卡',
                'typeId':'',
                'linkto':'/EPG/jsp/neirong/shang/J20191217.jsp?typeId='+cursor.focusable[6].typeId+'&video=538,308,55,135'
            }
            cursor.focusable[7].items[0] = {
                'name':'小妮严选',
                'typeId':'',
                'linkto':'/EPG/jsp/neirong/shang/J20201103List.jsp?picFlag=1&typeId='+cursor.focusable[7].typeId
            }
            cursor.call('show');
            // cursor.call('trafficNum',cursor.trafficId[0]);
            setTimeout(function(){cursor.call('prepareVideo');},200);
        },
        move: function (index) {
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            // var focus = cursor.focusable[blocked].focus;
            // var items = cursor.focusable[blocked].items;
            cursor.call('loseFocus');
            // if (focus === 0) return;
            if (blocked < 2 ){
                if (index == 1){
                    blocked ++;
                } else if (index == -11){
                    blocked = 7;
                } else if (index == -1 && blocked == 1){
                    blocked = 0;
                }
            }else if (blocked <4){
                if (index == 1 && blocked != 3){
                    blocked ++;
                } else if (index == -1){
                    blocked --;
                }else if (index == -11){
                    blocked = blocked+2;
                }
            }else if (blocked <7){
                if (index == 1 && blocked != 6){
                    blocked ++;
                }else if (index == -1){
                    if (blocked != 4) {
                        blocked--;
                    }else{
                        blocked = 1;
                    }
                }else if (index == -11){
                    blocked = 7;
                }else if (index == 11){
                    if (blocked != 6) {
                        blocked = blocked-2;
                    }else{
                        blocked = blocked-3;
                    }
                }
            }else if (blocked == 7){
                if (index == 11){
                    blocked = 1;
                }
            }

            // cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');

        },
        show: function () {
            var blocked = cursor.blocked;
            if (blocked < 2 || blocked == 7){
                $("focus"+blocked).style.visibility = "visible";
            } else if (blocked < 4){
                $("focus2").style.visibility = "visible";
                $("focus2").style.left = String(715+249*(blocked-2))+"px";
            } else if (blocked < 7){
                $("focus3").style.visibility = "visible";
                $("focus3").style.left = String(715+165*(blocked-4))+"px";
            }
        },
        loseFocus: function () {
            var blocked = cursor.blocked;
            if (blocked < 2 || blocked == 7){
                $("focus"+blocked).style.visibility = "hidden";
            } else if (blocked < 4){
                $("focus2").style.visibility = "hidden";
            } else if (blocked < 7){
                $("focus3").style.visibility = "hidden";
            }
        },
        select : function(){
            var blocked = cursor.blocked;
            var items = cursor.focusable[0].items;
            if (focusArea == 0){
                if (blocked != 0){
                    // cursor.call('trafficNum',cursor.trafficId[blocked]);
                }else if (items.length ==8) {
                    var VODflag = getStrParams("VODflag", items[7].name);
                    if (VODflag == 1) { //时移播放
                        var item = cursor.focusable[blocked].items[0];
                        item.linkto = "/EPG/jsp/neirong/shang/fullScreenVOD.jsp?channelId=" + cursor.channelId + "&program=" + cursor.program + "&VODflag=1";
                    }else {   //VODflag == 0 频道直播
                        var item = cursor.focusable[blocked].items[0];
                        item.linkto = "/EPG/jsp/neirong/shang/fullScreenVOD.jsp?serviceId=" + cursor.serviceId + "&frequency=" + cursor.frequency;
                    }
                }
                cursor.call('selectAct');
            }
        },
        // goBack : function(){
        //     if (tipFlag > 0 ){
        //         cursor.call('loseTip');
        //     }else {
        //         cursor.call('goBackAct');
        //     }
        // },
        showTip : function(id){
            tipFlag = id;
            $("tooltip").style.backgroundImage = 'url("images/J20200731Rule.png")';
            $("tooltip").style.visibility = 'visible';
            $("focus1").style.visibility = "hidden";
        },
        loseTip : function(){
            tipFlag = -1;
            $("tooltip").style.visibility = 'hidden';
            $("focus1").style.visibility = "visible";
        },
        // loseFocus: function () {
        //     var blocked = cursor.blocked;
        //     var items = cursor.focusable[blocked].items;
        //     if (items.length <= 0) return;
        //     var focus = cursor.focusable[blocked].focus;
        //     $("listName"+String(focus-1)).style.backgroundImage = "url(images/J20200731Focus.png)";
        //     $("listName"+String(focus-1)).style.width = '204px';
        //     $("listName"+String(focus-1)).style.height = '43px';
        // },
        nextVideo: function () {
            var playIndex = cursor.playIndex;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[0].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie", item);
        },
        prepareVideo: function () {
            var playIndex = cursor.playIndex;
            // var playIndex = 0;
            if (cursor.focusable[0].items.length <= 0) return;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie", item);
        },
        playMovie: function (item) {
            var playIndex = cursor.playIndex;
            var pos = [538,307,55,220];
            var items = cursor.focusable[0].items;
            player.exit();
            // alert("iPanel.HD30Adv==="+iPanel.HD30Adv+",,,,items.length =="+items.length);
            if (items.length ==8) {
                var VODflag = getStrParams("VODflag",items[7].name);
                if (VODflag == 1){
                    player.play({
                        position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                        channelId: cursor.channelId,
                        program: cursor.program
                    });
                } else {
                    player.play({
                        position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                        serviceId: cursor.serviceId,
                        frequency: cursor.frequency
                    });
                }

            }else {
                player.play({
                    vodId: item.id,
                    position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                    callback: function () {
                        // cursor.focusable[cursor.blocked].focus = cursor.playIndex;
                        //cursor.call('show');
                        //setTimeout(function(){cursor.call('lazyShow');},50);
                    }
                });
            }
        },
        trafficNum      :function(id){
            var currentTime = new Date().getTime();
            currentTime = new Date(currentTime+45000).Format("yyyy-MM-dd hh:mm:ss");
            var content = encodeURIComponent(currentTime);
            var url="http://192.168.18.249:8080/voteNew/external/clickCount.ipanel?icid="+iPanel.cardId+"&classifyID="+id+"&content="+content;
            ajax(url, function(rst){
                if( rst != "" && rst != 'undefined'&& rst.result ) {
                    //tooltip( decodeURIComponent('统计成功') );  //统计成功
                    return;
                }else if( rst != "" && rst != 'undefined'&& rst.result ){
                    tooltip( decodeURIComponent('统计失败') );  //统计失败
                }
            },
            {
                fail:function( meg )
                {
                    tooltip( decodeURIComponent("fail") );
                    return;
                }
            }
        );
    }
    });
    //cursor.initialize(initialize);
    -->
</script>
</html>