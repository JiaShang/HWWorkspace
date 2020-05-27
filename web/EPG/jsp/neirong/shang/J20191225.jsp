<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000103261";

    infos.add(new ColumnInfo(typeId, 0, 12));   //id  取值开始位置  返回数据长度
//    List<Column> columns = inner.getList(typeId, 12, 0 , new Column());
//    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
//        infos.add(new ColumnInfo(columns.get(i).id, 1, 99));
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
        /*img{*/
        /*    width: 360px;*/
        /*    height: 215px;*/

        /* }*/
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
    var posters = [];
    var bgImgs = [];
    cursor.initialize({
        data: [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    inner.special = true;
                    //Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    Result result = inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused: [<%= inner.getPreFoucs() %>],
        init: function () {
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl = '<%= backUrl %>';
            cursor.playDVB =[{
                name: 'CCTV1',frequency: 5060000,serviceId: 3901
            },{
                name: '湖南卫视',frequency: 4980000,serviceId: 3702
            },{
                name: '江苏卫视',frequency: 2030000,serviceId: 3002
            },{
                name: '东方卫视',frequency: 4900000,serviceId: 3602
            }];;

            cursor.focusable[0] = {};
            cursor.focusable[1] = {};
            cursor.focusable[0].focus = 0;
            cursor.focusable[1].focus = this.focused.length > 2 ? Number(this.focused[2]) : 0;
            var o = this.data[0];
            cursor.focusable[2] = {};
            cursor.focusable[2].typeId = o["id"];
            cursor.focusable[2].focus = this.focused.length > 3 ? Number(this.focused[3]) : 0;
            cursor.focusable[2].items = o["data"];
            if(cursor.blocked < 2){
                cursor.showIndex = 0;
            }else {
                cursor.showIndex = cursor.focusable[2].focus < 6 ? -650 : -1142;
            }
            for(var i = 0 ; i < cursor.focusable[2].items.length ; i++ ){
                posters[i] = cursor.focusable[2].items[i].posters['1'];
            }
            setTimeout(function(){
                initList();
                getFocus();
                player.setPosition(323,183,598,347);
                cursor.call('playMovie');
            },150);
            // if( cursor.focusable[2].items[2] ) cursor.focusable[2].items[2].linkto = 'http://192.168.35.153:8080/common/program_theme_9.jsp?id=76&lcn=m';
            // if( cursor.focusable[2].items[3] ) cursor.focusable[2].items[3].linkto = 'http://192.168.35.153:8080/common/program_theme_9.jsp?id=103&lcn=qb';
        },
        playMovie   :   function(){
            var blocked = 1;
            alert(cursor.focusable[blocked].focus);
            alert(cursor.playDVB[cursor.focusable[blocked].focus].serviceId);
            player.exit();
            //播放直播
           // if( ! cursor.focusable[blocked].items ) {
            player.play(
                {
                    serviceId: cursor.playDVB[cursor.focusable[blocked].focus].serviceId,
                    frequency: cursor.playDVB[cursor.focusable[blocked].focus].frequency
                }
            );
            // } else {//播放点播
            //     var item = cursor.focusable[blocked].items[0];
            //     player.play({ vodId: item.id });
            // }
        },
        select : function(){
            var blocked = cursor.blocked;
            if(blocked == 0 ) {
                if( !cursor.fullmode  ){
                    cursor.fullmode = true;
                    player.setPosition(0,0,1280,720);
                    $("list").style.visibility = 'hidden';
                    $("body").style.visibility = 'hidden';
                    $("focus0").style.visibility = 'hidden';
                }
                return;
            }
            cursor.call("selectAct");
        },
        goBack : function(){
            if( cursor.fullmode ) {
                $("list").style.visibility = 'visible';
                $("body").style.visibility = 'visible';
                $("focus0").style.visibility = 'visible';
                player.setPosition(323,183,598,347);
                cursor.fullmode = false;
                return;
            }
            cursor.call('goBackAct');
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            focus1 = cursor.focusable[1].focus;
            focus2 = cursor.focusable[2].focus;
            loseFocus();
            switch (index) {
                case 11:    //上
                    if( blocked == 1){
                        blocked = 0;
                    }else if(blocked == 2){
                        if(focus2 < 3){
                            blocked = 1;
                            $("showImgBox").style.top="0px";
                            cursor.showIndex = 0;
                        }else if(focus2 < 6){
                            focus2 = focus2 - 3;
                        }else if(focus2 == 6){
                            $("showImgBox").style.top="-650px";
                            cursor.showIndex = -650;
                            focus2 = 4;
                        }else if(focus2 < 9){
                            focus2 = 6;
                        }else if(focus2 < 11){
                            focus2 = focus2 - 2;
                        }else if(focus2 == 11){
                            focus2 = 8;
                        }
                    }
                    break;
                case -11:   //下
                    if( blocked < 2){
                        if(blocked ==1){
                            $("showImgBox").style.top="-650px";
                            cursor.showIndex = -650;
                        }
                        blocked ++;
                    }else {
                        if( focus2 < 3 ){
                            focus2 = focus2 + 3;
                        }else if ( focus2 < 6 ){
                            focus2 = 6;
                        }else if(focus2 == 6 ){
                            focus2 = 7;
                            $("showImgBox").style.top="-1142px";
                            cursor.showIndex = -1142;
                        }else if(focus2 < 9){
                            focus2 = focus2 +2 ;
                        }
                    }
                    break;
                case -1:    //左
                    if( blocked == 1){
                        if(focus1 > 0){
                            focus1 -- ;
                        }
                    }else if(blocked == 2){
                        if(focus2 != 0 && focus2 != 3 && focus2 != 6 && focus2 != 7 && focus2 != 9){
                            focus2 -- ;
                        }
                    }
                    break;
                case 1:     //右
                    if( blocked == 1){
                        if(focus1 < 3){
                            focus1 ++ ;
                        }
                    }else if(blocked == 2){
                        if(focus2 != 2 && focus2 != 5 && focus2 != 6 && focus2 != 8 && focus2 != 11){
                            focus2 ++ ;
                        }
                    }
                    break;
            }
            cursor.blocked = blocked;
            cursor.focusable[1].focus = focus1;
            cursor.focusable[2].focus = focus2;
            getFocus();
        },
        show : function(){
            if(cursor.blocked ==0){
                $("focus0").style.visibility = "visible";
                $("focus1").style.visibility = "hidden";
            }else if(cursor.blocked ==1){
                $("focus1").style.visibility = "visible";
                $("focus0").style.visibility = "hidden";
            }else{

            }
        },
    });
    function getFocus(){
        focus1 = cursor.focusable[1].focus;
        focus2 = cursor.focusable[2].focus;
        $("showImgBox").style.top=String(cursor.showIndex)+"px";
        if(cursor.blocked == 0){
            $("focus0").style.visibility = "visible";
        }else if(cursor.blocked == 1){
            $("focus1").style.visibility = "visible";
            $("focus1").style.left = String(210+211*focus1)+"px";
        }else if(cursor.blocked == 2){
            $("listImg"+focus2).style.border = "6px solid #ffffff";
        }
    }
    function loseFocus(){
        focus2 = cursor.focusable[2].focus;
        if(cursor.blocked == 0){
            $("focus0").style.visibility = "hidden";
        }else if(cursor.blocked == 1){
            $("focus1").style.visibility = "hidden";
        }else if(cursor.blocked == 2){
            $("listImg"+focus2).style.border = "6px solid transparent";
        }
    }
    function initList(){
        listBox = new showList(12,posters.length,0,127,window);
        listBox.showType =0 ;
        listBox.haveData = function(List){
            $("listImg"+String(List.idPos)).src = posters[List.dataPos];
            $("listImg"+String(List.idPos)).style.border = "6px solid transparent";
        }
        listBox.notData = function(List){
            $("listImg"+List.idPos).src = "images/global_tm.gif";
        };
        listBox.startShow();
    }
    -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="width: 1280px; height: 1862px;left: 0px;top: 0px; overflow:hidden;" onUnload="exit();">
<div id="showImgBox" style="position:absolute; left: 0px; top: 0px; width:1280px; height:720px; -webkit-transition-duration:300ms;">
    <div id="body" leftmargin="0" topmargin="0" style="width: 1280px; height: 1862px;left: 0px;top: 0px; overflow:hidden; background: transparent url(images/J20191225Bg.png) no-repeat;" onUnload="exit();">
    </div>
    <div id="focus0" style="position: absolute;width: 618px;height: 367px;left: 314px;top: 171px; overflow:hidden; background: url('images/J20191225Focus0.png') no-repeat; visibility: hidden; z-index: 1;" ></div>
    <div id="focus1" style="position: absolute;width: 211px;height: 117px;left: 212px;top: 552px; overflow:hidden; background: url('images/J20191225Focus1.png') no-repeat; visibility: hidden; z-index: 1;" ></div>
    <div id="list" style="position: absolute;width: 1100px;height: 600px;left: 0px;top: 100px;">
    <div id="list0" class="list" style="left: 58px; top: 587px;">
        <img id="listImg0" class="listImg" width="377" height="210"/>
        <div id="listName0" class="listName" width="377" height="210"></div>
    </div>
    <div id="list1" class="list" style="left: 450px; top: 587px;">
        <img id="listImg1" class="listImg" width="377" height="210"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list" style="left: 841px; top: 587px;">
        <img id="listImg2" class="listImg" width="377" height="210"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list" style="left: 58px; top: 814px;">
        <img id="listImg3" class="listImg" width="377" height="210"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="list" style="left: 450px; top: 814px;">
        <img id="listImg4" class="listImg" width="377" height="210"/>
        <div id="listName4" class="listName"></div>
    </div>
    <div id="list5" class="list" style="left: 841px; top: 814px;">
        <img id="listImg5" class="listImg" width="377" height="210"/>
        <div id="listName5" class="listName"></div>
    </div>
    <div id="list6" class="list" style="left: 60px; top: 1053px;">
        <img id="listImg6" class="listImg" width="1159" height="225"/>
        <div id="listName6" class="listName"></div>
    </div>
    <div id="list7" class="list" style="left: 58px; top: 1297px;">
        <img id="listImg7" class="listImg" width="570" height="210"/>
        <div id="listName7" class="listName"></div>
    </div>
    <div id="list8" class="list" style="left: 647px; top: 1297px;">
        <img id="listImg8" class="listImg" width="570" height="210"/>
        <div id="listName8" class="listName"></div>
    </div>
    <div id="list9" class="list" style="left: 58px; top: 1524px;">
        <img id="listImg9" class="listImg" width="377" height="210"/>
        <div id="listName9" class="listName"></div>
    </div>
    <div id="list10" class="list" style="left: 452px; top: 1524px;">
        <img id="listImg10" class="listImg" width="377" height="210"/>
        <div id="listName10" class="listName"></div>
    </div>
    <div id="list11" class="list" style="left: 844px; top: 1524px;">
        <img id="listImg11" class="listImg" width="377" height="210"/>
        <div id="listName11" class="listName"></div>
    </div>
</div>
</div>
</body>
</html>