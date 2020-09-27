<%@ include file="../player/include.jsp" %>

<%--<%@ page language="java" pageEncoding="UTF-8"%>--%>
<%@ page language="java" pageEncoding="GB2312"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114768";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = "";
    String rulePic = "";
    if( column != null ) {
        picture = inner.pictureUrl("images/J20200415_2Bg.jpg", column.getPosters(), "7");
        rulePic = inner.pictureUrl("images/J20200415_2Rule.png", column.getPosters(), "4");
    }
    Integer maxTitleLen = null,direct=null;
    maxTitleLen = !isNumber( inner.get("maxTitleLen") ) ? 6 : Integer.valueOf(inner.get("maxTitleLen"));
    direct = !isNumber( inner.get("direct") ) ? 0 : Integer.valueOf(inner.get("direct"));
//    String picture = column == null ? "images/J20200213Bg.jpg" : inner.pictureUrl("",column.getPosters(),"7");
//    String rulePic = column == null ? "images/J20200213Rule.jpg" : inner.pictureUrl("",column.getPosters(),"4");
//    String picture = "images/J20200213Bg.jpg";
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .listName{
            position: absolute;
            width: 263px;
            height: 34px;
            top: 161px;
            color: #ffffff;
            font-size:24px;
            overflow: hidden;
            text-align: center;
            line-height: 34px;
            /*padding-left: 10px;*/
            /*background-color: #6b6f70;*/
        }
        .listVoteResult{
            position: absolute;
            width: 253px;
            height: 34px;
            top: 161px;
            color: #ffffff;
            font-size:24px;
            background: transparent;
            overflow: hidden;
            text-align: right;
            line-height: 34px;
            /*padding-right: 10px;*/
        }
        .listButton{
            position: absolute;
            width: 265px;
            height: 30px;
            top: 210px;
            color: #ffffff;
            font-size:22px;
            background:transparent;
            overflow: hidden;
            text-align: left;
            line-height: 30px;
            padding-left: 10px;
            background-repeat: no-repeat;
        }
        img{
            width: 263px;
            height: 195px;
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
        var listBox = null;
        var voteMsg = null;
        var listData = [];
        var posters = [];
        var bgImgs = [];
        var tipFlag = -1;
        var tipFlagFocus = 0;
        var phoneNum = "0";
        var isPhoneError = true;
        var isFirstVote = true;
        var scrollFlag = 1; //0：不显示滚动条，显示滚动条
        var scrollWay = 2;  //1：按数据个数滑动，按数据页数滑动
        var scrollData = 2; //1：按数据个数显示，按数据页数显示
        var focusPic = 1;  //为1时焦点在图片上，为0时焦点在按钮上

        var startTime = new Date("2020-04-24 0:0:0").getTime();
        var endTime = new Date("2020-04-30 23:59:59").getTime();
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
                cursor.voteId = 483 ;
                cursor.trafficId = 484 ;
                cursor.focusName = "";
                for (var i = 0; i < this.data.length; i++) {
                    var o = this.data[i];
                    cursor.focusable[i] = {};
                    cursor.focusable[i].typeId = o["id"];
                    cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                    cursor.focusable[i].items = o["data"];
                    for( var j = 0; j < cursor.focusable[i].items.length; j ++){
                        if (typeof cursor.focusable[i].items[j].posters != 'undefined' && typeof cursor.focusable[i].items[j].posters['5'] != 'undefined'){
                            cursor.focusable[i].items[j]={
                                'name':o["data"][j].name,
                                'linkto':'/EPG/jsp/neirong/shang/J20200420List.jsp?typeId='+o["id"]+'&blocked='+i+'&focus='+j+"&direct="+<%=direct%>,
                                'posters':o["data"][j].posters
                            };
                        }
                    }
                }
                for (var i = 0; i < cursor.focusable[0].items.length; i++) {
                    cursor.focusable[0].items[i].voteResult = 0;
                }
                cursor.focusable[1] = {};    //投票规则
                cursor.focusable[1].focus = 0;
                <%--var column = <%= inner.writeObject(column)%>;--%>
                // posters = column.posters['1'];
                // bgImgs = column.posters['7'];
                cursor.call('getVoteResult',cursor.voteId);
                setTimeout(function(){
                    initList(cursor.focusable[0].focus);
                },800);
                setTimeout(function(){
                    // initList(cursor.focusable[0].focus);
                    cursor.call('show');
                    cursor.call('lazyShow');
                },1000);
            },
            input : function(ch){
                if (tipFlag == 4 && tipFlagFocus == 0) {
                    getInputNum(ch, "phone");
                }
            },
            move : function(index){
                //上 11，下 -11，左 -1，右 1
                if(cursor.enlarged ==1 || (tipFlag >= 0 && tipFlag < 4) ) return;
                cursor.call('loseFocus');
                switch (index) {
                    case 11:    //上
                        if ( tipFlag == 4 ){
                            if(tipFlagFocus == 1){
                                tipFlagFocus = 0;
                                cursor.call('showTip',tipFlag);
                            }
                        } else {
                            if (cursor.blocked == 0  && tipFlag < 0 ) {
                                if (focusPic == 1){
                                    if( listBox.position > 3){
                                        listBox.changeList(-4);
                                        focusPic = 0;
                                    }else {
                                        cursor.blocked = 1;
                                    }
                                }else {
                                    focusPic = 1;
                                }
                            }
                        }
                        break;
                    case -11:   //下
                        if ( tipFlag == 4 ){
                            if (tipFlagFocus == 0){
                                tipFlagFocus = 1;
                                cursor.call('showTip',tipFlag);
                            }
                        } else if ( tipFlag < 0 ){
                            if(cursor.blocked == 0){
                                if (focusPic == 1){
                                    focusPic = 0;
                                }else {
                                    if( listBox.position < listBox.dataSize-4){
                                        listBox.changeList(4);
                                        focusPic = 1;
                                    }else if(Math.floor((listBox.dataSize-1)/4) > Math.floor(listBox.position/4)){
                                        listBox.changeList(listBox.dataSize-listBox.position-1);
                                        focusPic = 1;
                                    }
                                }
                            }else {
                                cursor.blocked = 0;
                            }
                        }
                        break;
                    case -1:    //左
                        if(cursor.blocked == 0 && tipFlag < 0 ){
                            if( listBox.focusPos != 0 && listBox.focusPos != 4){
                                listBox.changeList(-1);
                            }
                        }
                        break;
                    case 1:     //右
                        if(cursor.blocked == 0 && tipFlag < 0){
                            if( listBox.focusPos != 3 && listBox.focusPos != 7){
                                listBox.changeList(1);
                            }
                        }
                        break;
                }
                cursor.focusable[0].focus = listBox.position;
                scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
                cursor.call('show');
                cursor.call('lazyShow');
            },
            show : function(){
                if(cursor.enlarged ==1){
                    $("enlargedPic").style.visibility = "visible";
                }else {
                    $("enlargedPic").style.visibility = "hidden";
                }
                if(cursor.blocked == 0){
                    if (focusPic ==1 ){
                        $("focus").style.left = String(55+(listBox.focusPos%4)*280)+"px";
                        $("focus").style.top = String(170+Math.floor(listBox.focusPos/4)*255)+"px";
                        $("focus").style.visibility = "visible";
                        $("listButton"+String(listBox.focusPos)).style.backgroundImage = "url(images/J20200415_2Praise0.png)";
                        $("listButton"+String(listBox.focusPos)).style.color = "#ffffff";
                    }else {
                        $("focus").style.visibility = "hidden";
                        $("listButton"+String(listBox.focusPos)).style.backgroundImage = "url(images/J20200415_2Praise1.png)";
                        $("listButton"+String(listBox.focusPos)).style.color = "#000000";
                    }
                    $("rule").style.backgroundImage = "url(images/J20200415_2Rule0.png)";
                }else {
                    $("listButton"+String(listBox.focusPos)).style.backgroundImage = "url(images/J20200415_2Praise0.png)";
                    $("rule").style.backgroundImage = "url(images/J20200415_2Rule1.png)";
                    $("focus").style.visibility = "hidden";
                    $("listButton"+String(listBox.focusPos)).style.color = "#ffffff";
                }
            },
            lazyShow    :   function(){
                var blocked = cursor.blocked;
                var focus = cursor.focusable[0].focus;
                if( blocked <= 0 && focusPic == 1) {
                    var text = cursor.focusable[blocked].items[focus].name;
                    var id = String(focus);
                    cursor.calcStringPixels(text, 22, function(width){
                        if( width <= 230 ) return;
                        $('listName' + String(listBox.focusPos)).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
                    });
                };
            },
            loseFocus : function(){
                $("listButton"+String(listBox.focusPos)).style.backgroundImage = "url(images/J20200415_2Praise0.png)";
                $("listButton"+String(listBox.focusPos)).style.color = "#ffffff";
                $("listName"+String(listBox.focusPos)).innerText = cursor.focusable[0].items[listBox.position].name;
            },
            select : function(){
                var blocked = cursor.blocked;
                var focus = cursor.focusable[0].focus;
                if (cursor.blocked == 0){
                    if (focusPic == 0){
                        if(tipFlag < 0 ){
                            var currentTime = new Date().getTime();
                            if(currentTime < startTime){
                                cursor.call('showTip',0);   //还未到时间
                            }else if (currentTime > endTime) {
                                cursor.call('showTip',3);   //已结束
                            }else{
                                cursor.call('isFirstVote',cursor.trafficId);
                                setTimeout(function() {
                                    if (!isFirstVote) {
                                        cursor.call('vote');  //投票
                                    } else {
                                        cursor.call('showTip', 4);   //首次投票，需要输入电话号
                                    }
                                },1000);
                            }
                        }else {
                            if( tipFlag == 4 ){
                                if ( tipFlagFocus == 1 ) {
                                    cursor.call('showTip',4);
                                    if (!isPhoneError){
                                        phoneNum = $("phone").innerText;
                                        cursor.call('vote');  //投票
                                        cursor.call('loseTip');
                                    }
                                }
                            }else {
                                cursor.call('loseTip');
                            }
                        }
                    } else {
                        cursor.call('selectAct');
                    }
                }else {
                    if( cursor.enlarged ==1 ) {
                        cursor.enlarged = 0;
                    }else{
                        cursor.enlarged = 1;
                    }
                }
                if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
                cursor.moveTimer = setTimeout(function(){
                    clearTimeout(cursor.moveTimer);
                    cursor.moveTimer = undefined;
                    if(tipFlag > 0 && tipFlag < 4){
                        cursor.call('loseTip');
                    }
                }, 3000);
                cursor.call('show');
            },
            goBack : function(){
                if( cursor.blocked == 1 && cursor.enlarged ==1 ) {
                    cursor.enlarged = 0;
                    cursor.call('show');
                }else if (tipFlag > 0 ){
                    var tmp = $("phone").innerText;
                    if (tipFlag == 4 && tipFlagFocus ==0 && tmp.length > 1 ){
                        rollBackInputNum("phone");  //回滚手机号
                    } else {
                        cursor.call('loseTip');
                    }

                }else {
                    cursor.call('goBackAct');
                }
            },
            showTip : function(id){
                tipFlag = id;
                $("tooltip").style.backgroundImage = 'url("images/Vote' + String(id) + '.png")';
                $("tooltip").style.visibility = 'visible';
                if ( tipFlag == 4 ){      //输入电话号时，按钮的样式
                    var tmp = $("phone").innerText;
                    $("tipFlagFocus").style.visibility = 'visible';
                    $("tip").style.visibility = 'visible';
                    $("tip").innerText = "请输入您的电话号码!";
                    $("phone").style.visibility = 'visible';
                    if (tmp.indexOf("|") < 0) {
                        if(tipFlagFocus == 0){
                            // if (tmp == " "){
                            tmp = "";
                            // }
                            tmp = tmp+"|";
                            $("phone").innerText = tmp;
                        }
                    }else {
                        if(tipFlagFocus != 0){
                            tmp = tmp.substring(0,tmp.length-1);
                            $("phone").innerText = tmp;
                        }
                    }
                    if (tipFlagFocus == 1){
                        isPhoneError = checkInput("phone","tip");
                        if(!isPhoneError){
                            showTipText("请点击确定按钮投票!","tip");
                        }
                    }
                    $("tipFlagFocus").style.backgroundImage = 'url("images/tipFlagFocus' + String(tipFlagFocus) + '.png")';
                }
            },
            loseTip : function(){
                tipFlag = -1;
                tipFlagFocus = 0;
                $("tooltip").style.visibility = 'hidden';
                $("tip").style.visibility = 'hidden';
                $("phone").style.visibility = 'hidden';
                $("phone").innerText = "";
                $("tipFlagFocus").style.visibility = 'hidden';
            },
            vote : function(){
                var blocked = cursor.blocked;
                var focus = cursor.focusable[blocked].focus;
                var items = cursor.focusable[blocked].items;
                voteMsg = {
                    // icid:iPanel.cardId,
                    icid:iPanel.serialNumber,
                    phone: phoneNum,
                    total:"false",  //是否返回最新票数总数（可选）
                    classifyID:cursor.voteId,  //投票id
                    content:encodeURIComponent(items[focus].name),     //投票内容，中文请通过encodeURIComponent编码（可选）
                    voteCount:10,     //总投票数
                    compare:"ture",   //比较值（可选，用于实现如指定用户可投票功能）
                    contentNum:10,      //对同一内容投票数
                    msgContent:""    //(可选，当存在这个值则向当前phone推送一条短信，中文请通过encodeURIComponent编码)
                };
                //     // cursor.focusName = items[focus].name;
                //     (function(target){
                //         var item = items[focus];
                //         cursor.call("sendVote",{
                //             id:cursor.voteId,
                //             target:item.name,
                //             repeat:true,
                //             limit:100,　　//总投票数限制
                //             limitPer:100,//每个人投票限制
                //             callback: function(result){
                // if(result.recode != '002' || result.result == false ) {
                // cursor.call('showTip', 2);  //投票失败,次数超过限制
                // }// } else {
                // cursor.call('showTip', 1);  //投票成功
                // items[focus].voteResult++;
                //     var lastPos = listBox.position;
                //     var lastName = cursor.focusable[0].items[listBox.position].name;
                //     cursor.call('getVoteResult');
                // setTimeout(function(){
                //     for (var i = 0;i < cursor.focusable[0].items.length ;i++) {
                //         if (cursor.focusable[0].items[i].name == lastName) {
                //             listBox.changeList(i-lastPos);
                //             cursor.focusable[0].focus = listBox.position;
                //         }
                //     }
                //     initList(cursor.focusable[0].focus);
                //     $("listButton"+String(listBox.focusPos)).innerText = cursor.focusable[0].items[cursor.focusable[0].focus].voteResult;
                //     cursor.call('show');
                // },800);
                //             }
                //     });
                // })();
                // return;

                var url="http://192.168.18.249:8080/voteNew/external/addVote6.ipanel?icid="+voteMsg.icid+"&phone="+voteMsg.phone+"&classifyID="+voteMsg.classifyID+"&content="+voteMsg.content+"&voteCount="+voteMsg.voteCount+"&contentNum="+voteMsg.contentNum;
                ajax(url, function(result){
                        if( result.recode != "002" || result.result == false ) {
                            //tooltip( decodeURIComponent('投票失败') );  //统计失败
                            cursor.call('showTip', 2);
                            return;
                        }else{
                            // tooltip( decodeURIComponent('投票成功') );  //统计成功{"result":true,"recode":"002"}
                            cursor.call('showTip', 1);  //投票成功
                            if (isFirstVote){
                                cursor.call('traffic',cursor.trafficId);
                            }
                            // $("phone").innerText = "";
                            // items[focus].voteResult++;
                            var lastPos = listBox.position;
                            var lastName = cursor.focusable[0].items[listBox.position].name;
                            cursor.call('getVoteResult',cursor.voteId);
                            setTimeout(function(){
                                for (var i = 0;i < cursor.focusable[0].items.length ;i++) {
                                    if (cursor.focusable[0].items[i].name == lastName) {
                                        cursor.call('loseFocus');
                                        listBox.changeList(i-lastPos);
                                        cursor.focusable[0].focus = listBox.position;
                                    }
                                }
                                initList(cursor.focusable[0].focus);
                                $("listButton"+String(listBox.focusPos)).innerText = cursor.focusable[0].items[cursor.focusable[0].focus].voteResult;
                                cursor.call('show');
                            },800);
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
            },
            getVoteResult : function(voteId){
                var url="http://192.168.18.249:8989/VoteStatistics/getVoteInfo?classifyID="+voteId;
                ajax(url, function(rst){
                        if( rst != "" && rst != 'undefined') {
                            //tooltip( decodeURIComponent('获取投票结果成功') );  //成功
                            for (var i = 0;i < cursor.focusable[0].items.length ;i++) {
                                for (var j = 0;j < rst.length ;j++){
                                    // rst[j].name = decodeURIComponent(rst[j].name);
                                    if(cursor.focusable[0].items[i].name == rst[j].name){
                                        cursor.focusable[0].items[i].voteResult = rst[j].num;
                                        break;
                                    }
                                }
                            }
                            // cursor.focusable[0].items.sort(compare("voteResult",1));
                            sortByKey(cursor.focusable[0].items,"voteResult",1);
                            return true;
                        }else{
                            // tooltip( decodeURIComponent('获取投票结果失败') );  //失败
                            return false;
                        }
                    },
                    {
                        fail:function( meg )
                        {
                            // tooltip( decodeURIComponent("fail") );
                            return false;
                        }
                    }
                );
            },
            isFirstVote : function(voteId){
                var url="http://192.168.18.249:8989/VoteStatistics/getVoteInfo?classifyID="+voteId;
                ajax(url, function(rst){
                        if( rst != "" && rst != 'undefined') {
                            //tooltip( decodeURIComponent('获取投票结果成功') );  //成功
                            for (var j = 0;j < rst.length ;j++){
                                // rst[j].name = decodeURIComponent(rst[j].name);
                                if(iPanel.serialNumber == rst[j].name){
                                    isFirstVote = false;
                                    break;
                                }
                            }
                            return true;
                        }else{
                            // tooltip( decodeURIComponent('获取投票结果失败') );  //失败或者
                            return false;
                        }
                    },
                    {
                        fail:function( meg )
                        {
                            // tooltip( decodeURIComponent("fail") );
                            return false;
                        }
                    }
                );
            },
            traffic      :function(voteId){
                var url="http://192.168.18.249:8080/voteNew/external/clickCount.ipanel?icid="+iPanel.serialNumber+"&classifyID="+voteId+"&content="+iPanel.serialNumber;
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
        function initList(starPos){
            var items = cursor.focusable[0].items;
            listBox = new showList(8,items.length,starPos,127,window);
            listBox.showType =0 ;
            listBox.haveData = function(List){
                if (typeof items[List.dataPos].posters == "undefined" || (typeof items[List.dataPos].posters['1'] == "undefined" && typeof items[List.dataPos].posters['5'] == "undefined")) {
                    $("listImg"+String(List.idPos)).src = "images/defaultImg.png";
                }else if (typeof items[List.dataPos].posters['1'] != "undefined"){
                    $("listImg"+String(List.idPos)).src = items[List.dataPos].posters['1'][0];
                }else if (typeof items[List.dataPos].posters['5'] != "undefined") {
                    $("listImg"+String(List.idPos)).src = items[List.dataPos].posters['5'][0];
                }
                $("listName"+String(List.idPos)).innerText = items[List.dataPos].name;
                $("listName"+List.idPos).style.backgroundImage = "url(images/J20200415_2Title.png)";
                $("listButton"+String(List.idPos)).innerText = String(items[List.dataPos].voteResult);
                $("listButton"+List.idPos).style.backgroundImage = "url(images/J20200415_2Praise0.png)";
            }
            listBox.notData = function(List){
                $("listImg"+List.idPos).src = "images/global_tm.gif";
                $("listName"+String(List.idPos)).innerText = "";
                $("listButton"+String(List.idPos)).innerText = "";
                $("listName"+List.idPos).style.backgroundImage = "url(images/global_tm.gif)";
                $("listButton"+List.idPos).style.backgroundImage = "url(images/global_tm.gif)";
            };
            listBox.startShow();
            initScroll(listBox.dataSize,8,listBox.listPage);
        }
        function checkInput(id1,id2){
            var obj = $(id1).innerText;
            // obj = obj.substring(0,obj.length-1)
            var isPhoneError = true;
            if(obj.length == 0 || obj == ""){
                var str = "请输入您的电话号码!";
                showTipText(str,id2);
            }else if(!isTelephone(obj)){
                var str = "号码有误,请重新输入!";
                showTipText(str,id2);
            }else{
                isPhoneError = false;
            }
            // return true;
            return isPhoneError;
        }
        //删除输入的数据
        function delInputNum(id){
            var temp = 	$(id).innerText;
            // if(temp.length  == 0) return;
            // var inputKey = temp.substr(0,temp.length-1);
            $(id).innerText = "请输入您的电话号码!";
        }
    </script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200415_2Bg.jpg)" : (" url(" + picture + ")")%> no-repeat;" onUnload="exit();">
<div id="focus" style="position: absolute;width: 274px;height: 204px;left: 55px;top: 170px; overflow:hidden; background: url('images/J20200213Focus.png') no-repeat; visibility: visible; z-index: 1;" ></div>
<div id="scrollLower" style="position: absolute; left: 1200px; top: 175px; width: 5px; background-color: #959ea5; visibility: hidden; height: 490px;">
    <div id="scrollUpper" style="position: absolute; top: 0px; height: 100px;width: 25px;left: -12px; background-color: #209855;z-index: 1;color: #fffbfb;font-size: 22px;"></div>
</div>
<div id="enlargedPic" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: hidden;overflow: hidden; background: transparent <%= isEmpty(rulePic) ? "url(images/J20200213Rule.jpg)" : (" url(" + rulePic + ")")%> no-repeat; z-index: 2;"></div>
<div id="rule" style="position: absolute;left: 1000px; top: 125px;width: 141px;height: 34px;visibility: visible;overflow: hidden; background: url('images/J20200415_2Rule0.png') no-repeat;"></div>
<div id="tooltip" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;">
    <div id="tip" style="position: absolute;left: 500px; top: 290px;width: 400px;height: 60px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #0e0e0b;font-size: 28px;">
    </div>
    <div id="phone" style="position: absolute;left: 510px; top: 348px;width: 400px;height: 50px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #0e0e0b;font-size: 26px;">
    </div>
    <div id="tipFlagFocus" style="position: absolute;left: 545px; top: 420px;width: 160px;height: 41px;visibility: hidden;overflow: hidden; background: no-repeat;z-index: 2;">
    </div>
</div>

<div id="list" style="position: absolute;width: 1100px;height: 600px;left: 50px;top: 145px;">
    <div id="list0" class="list" style="left: 10px; top: 30px;">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
        <div id="listVoteResult0" class="listVoteResult"></div>
        <div id="listButton0" class="listButton"></div>
    </div>
    <div id="list1" class="list" style="left: 290px; top: 30px;">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
        <div id="listVoteResult1" class="listVoteResult"></div>
        <div id="listButton1" class="listButton"></div>
    </div>
    <div id="list2" class="list" style="left: 570px; top: 30px;">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
        <div id="listVoteResult2" class="listVoteResult"></div>
        <div id="listButton2" class="listButton"></div>
    </div>
    <div id="list3" class="list" style="left: 850px; top: 30px;">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
        <div id="listVoteResult3" class="listVoteResult"></div>
        <div id="listButton3" class="listButton"></div>
    </div>
    <div id="list4" class="list" style="left: 10px; top: 285px;">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName"></div>
        <div id="listVoteResult4" class="listVoteResult"></div>
        <div id="listButton4" class="listButton"></div>
    </div>
    <div id="list5" class="list" style="left: 290px; top: 285px;">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName"></div>
        <div id="listVoteResult5" class="listVoteResult"></div>
        <div id="listButton5" class="listButton"></div>
    </div>
    <div id="list6" class="list" style="left: 570px; top: 285px;">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName"></div>
        <div id="listVoteResult6" class="listVoteResult"></div>
        <div id="listButton6" class="listButton"></div>
    </div>
    <div id="list7" class="list" style="left: 850px; top: 285px;">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName"></div>
        <div id="listVoteResult7" class="listVoteResult"></div>
        <div id="listButton7" class="listButton"></div>
    </div>
</div>
</body>
</html>