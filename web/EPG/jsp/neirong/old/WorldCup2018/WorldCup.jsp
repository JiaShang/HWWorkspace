<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首页视频窗的栏目ID：10000100000000090000000000109645

    infos.add(new ColumnInfo("10000100000000090000000000109625", 0, 3));
    infos.add(new ColumnInfo("10000100000000090000000000109629", 0, 5));

    int vodId = 0;
    Vod vod = new Vod();
    List<Vod> vods = inner.getList("10000100000000090000000000109645",1,0,vod);
    if( vods != null && vods.size() > 0) {
        vodId = vods.get(0).getId();
    }
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>世界杯主页</title>
    <style>
        .mask{position:absolute;background: transparent url("images/WorldCupMask.png") no-repeat left top;}

        .top {width:1280px;height:144px;left:0px;top:0px;position:absolute;background:transparent url("images/WorldCup_Top.jpg") no-repeat left top;}
        .left {width:74px;height:256px;left:0px;top:144px;position:absolute;background:transparent url("images/WorldCup_Left.jpg") no-repeat left top;}
        .right {width:746px;height:256px;left:534px;top:144px;position:absolute;background:transparent url("images/WorldCup_Right.jpg") no-repeat left top;}
        .bottom {width:1280px;height:320px;left:0px;top:400px;position:absolute;background:transparent url("images/WorldCup_Bottom.jpg") no-repeat left top;}

        .scrollPic {width:300px;height:306px;left:905px;top:145px;position:absolute;overflow: hidden;}
        .scrollPic img {width:300px;height:306px;}
        .scrollStatus,.scrollStatusFocus{width:9px;height:9px;position:absolute;top:430px;background:transparent url("images/WorldCupMask.png") no-repeat left top; background-position:-50px 0px;}
        .scrollStatusFocus {background-position:-60px 0px;}
        .scrollStatus1 {left:1159px;}
        .scrollStatus2 {left:1171px;}
        .scrollStatus3 {left:1184px;}

        .liveStatus{width:49px;height: 18px;top:429px;position:absolute;overflow: hidden;background:transparent url("images/WorldCupMask.png") no-repeat left top; background-position: 0px 0px;}
        .liveStatus1 {left:252px;}
        .liveStatus2 {left:483px;}

        .innerPic {position:absolute;top:472px;overflow: hidden;height:110px;}
        .innerPic img {height:110px;}
        .innerPic1 {width:281px;left:73px;}
        .innerPic1 img {width:281px;}
        .innerPic2 {width:151px;left:380px;}
        .innerPic3 {width:151px;left:555px;}
        .innerPic4 {width:151px;left:730px;}
        .innerPic2 img,.innerPic3 img,.innerPic4 img {width:151px;}
        .innerPic5 {width:300px;left:905px;}
        .innerPic5 img{width:300px;}

        .mask1 {width:238px;height:57px;top:396px;}
        .item11 {left:70px;background-position: 0px -20px;}
        .item12 {left:300px;background-position: 0px -300px;}

        .mask2 {width:276px;height:71px;left:581px;top:386px;background-position: 0px -80px;}
        .item21 {}

        .mask3 {width:319px;height:325px;left:894px;top:135px;background-position: 0px 0px;background: transparent url("images/WorldCupScrollMask.png") no-repeat left top;}
        .item31,.item32,.item33 {}

        .mask4 {height:136px;top:459px;}
        .item41 {width:305px;left:62px;background-position: -300px 0px;}
        .item42 {width:174px;left:368px;background-position: -650px 0px;}
        .item43 {width:174px;left:543px;background-position: -650px 0px;}
        .item44 {width:174px;left:719px;background-position: -650px 0px;}
        .item45 {width:325px;left:893px;background-position: 0px -160px;}

        .mask5 {width:147px;height:40px;top:615px;}
        .item51 {width:211px;left:214px;background-position: -350px -160px;}
        .item52 {left:501px;background-position: -350px -200px;}
        .item53 {width:205px;left:690px;background-position: -350px -240px;}
        .item54 {left:911px;background-position: -600px -160px;}

        .notice {width:245px;height:199px;position:absolute;left:597px;top:173px;overflow:hidden;}
        .noteItem {width:245px;height:55px;position:absolute;left:0px;top:32px;overflow: hidden;}
        .noteItem .team {width:87px;height:55px;float: left;}
        .noteItem .text {width:71px;height:55px;float: left;}
        .noteItem .text div{width:71px;height:22px;color:white;font-size:13px;line-height:26px;text-align: center;}
        .noteItem .team .flag{ width:87px; height:30px;text-align: center;}
        .noteItem .team .flag img {width:34px;height:24px;}
        .noteItem .team .name{ width:87px;color:white;font-size: 14px;line-height: 25px;height:25px;text-align: center;}

        .noticeStatus {width:69px;height:21px;position:absolute;left:687px;background: transparent url("images/WorldCupMask.png") no-repeat left top; background-position: -700px -300px;}
        .notice1 {top:172px;}
        .notice2 {top:284px;}
        .live {background-position: -600px -200px;}
        .prepare {background-position: -600px -240px;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:transparent url("../images/translateBg.png") no-repeat;' onUnload="exit();">
<div class="top"></div><div class="left"></div><div class="right"></div><div class="bottom"></div>
<div class="notice" id="notice"></div>
<div id="noticeStatus1"></div><div id="noticeStatus2"></div>
<div id="scrollPic" class="scrollPic"></div>
<div id="scrollStatus1"></div><div id="scrollStatus2"></div><div id="scrollStatus3"></div>

<div id="innerPic1"></div>
<div id="innerPic2"></div>
<div id="innerPic3"></div>
<div id="innerPic4"></div>
<div id="innerPic5"></div>
<div id="mask"></div>
<div id="liveStatus" style="visibility: hidden"></div>

</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        focused     :   [<%= inner.getPreFoucs() %>],
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    inner.special = i == 0 ;
                    Result result = i == 0 ? inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() )  : inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        init:function(){
            cursor.backUrl='<%= backUrl %>';
            cursor.focused = this.focused;
            var url = "http://192.168.89.23/worldCup/schedule.js";
            ajax( url, function( results ){
                var items = results.data;
                cursor.schedule = {focus: 0, items: items};
                //显示世界杯即将比赛图
                cursor.call("showNextMatches");
            });

            cursor.vodId = <%= vodId %>;

            cursor.focusable[0] = {
                focus : 0,
                items: [
                    { name:"cctv-5", serviceId : "4602",frequency: "1870000",linkto:'/EPG/jsp/neirong/VideoFullPlay.jsp?serviceId=4602&frequency=1870000'},
                    { name:"cctv-5+", serviceId : "4101",frequency: "2190000",linkto:'/EPG/jsp/neirong/VideoFullPlay.jsp?serviceId=4101&frequency=2190000'}
                ]
            };
            cursor.focusable[1] = {
                focus : 0,
                items: [
                    { name:"竞猜赢大奖",linkto:'/EPG/jsp/neirong/WorldCup2018/QuizGuessing.jsp'}
                ]
            };
            cursor.focusable[2] = {
                focus : 0,
                typeId: this.data[0].id,
                items: this.data[0].data || []
            };
            cursor.focusable[3] = {
                focus : 0,
                items: [
                    { name:"全民拼手气",linkto:'/EPG/jsp/neirong/WorldCup2018/matchVibe.jsp'},
                    { name:"积分榜，射手榜",linkto:'/EPG/jsp/neirong/WorldCup2018/TextListAndPlay.jsp?typeId=10000100000000090000000000109615&kd=1'},
                    { name:"冠军之路",linkto:'/EPG/jsp/neirong/WorldCup2018/TourChampion.jsp?typeId=10000100000000090000000000109616&official=1'},
                    { name:"精彩集锦",linkto:'/EPG/jsp/neirong/WorldCup2018/TextListAndPlay.jsp?typeId=10000100000000090000000000109612&kd=2'},
                    { name:"球迷狂欢",linkto:'/EPG/jsp/neirong/WorldCup2018/carnivalFan.jsp?typeId=10000100000000090000000000109613'}
                ]
            };

            var items = this.data[1].data || [];
            for( var i = 0 ; i < items.length; i ++ ) cursor.focusable[3].items[i].posters = items[i].posters;

            cursor.focusable[4] = {
                focus : 0,
                items: [
                    { name:"明嘴点评",linkto:'/EPG/jsp/neirong/WorldCup2018/TextListAndPlay.jsp?typeId=10000100000000090000000000109768&kd=3'},
                    { name:"每日之星",linkto:'/EPG/jsp/neirong/WorldCup2018/StarDaily.jsp?typeId=10000100000000090000000000109603'},
                    { name:"赛场内外",linkto:'/EPG/jsp/neirong/WorldCup2018/RankingList.jsp?official=1'},
                    { name:"诸强巡礼",linkto:'/EPG/jsp/neirong/WorldCup2018/TourStronger.jsp?typeId=10000100000000090000000000109614'}
                ]
            };

            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            if( this.focused.length > 1 ) {
                for(var i = 1; i - 1 < cursor.focusable.length && i < this.focused.length; i ++ )
                    cursor.focusable[i-1].focus = Number(this.focused[i]);
            }
            cursor.call("visitedRecord");
            //播放直播频道
            cursor.call("preparePlay");
            //显示右侧动态图
            cursor.call("showScrolls", true);
            //显示世界标专题链接图
            cursor.call("showInnerPics");
            cursor.call("show");
        },
        visitedRecord : function(){
            var record = function(){
                try {
                    cursor.call("sendVote",{
                        id:419,limit:9999,limitPer:9999,target:'世界杯首页',repeat:true
                    });
                    var url = "http://192.168.89.23/serve/vistor/count.do?id=1&choice=" + encodeURIComponent("世界杯首页") + "&cardNo=" + CA.card.serialNumber;
                    ajax(url);
                }catch (e) { }
            };
            setTimeout(function(){ record(); },30);
        },
        showInnerPics : function(){
            var focus = cursor.focusable[3].focus;
            var items = cursor.focusable[3].items;
            for( var i = 0 ; i< items.length; i ++ ) {
                var id = "innerPic" + ( i + 1);
                $(id).className = "innerPic " + id;
                var item = items[i];
                $(id).innerHTML = "<img src='"  + cursor.pictureUrl(item.posters,12) + "' />";
            }
        },
        select : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var item = cursor.focusable[blocked].items[focus];

            if( item.tags === '广告' ) return;
            if( blocked == 0 ) {
                var name = "进入直播信号：" + item.name;
                try {
                    cursor.call("sendVote",{
                        id:419,limit:9999,limitPer:9999,target:name,repeat:true
                    });
                    ajax("http://192.168.89.23/serve/vistor/count.do?id=1&choice=" + encodeURIComponent(name) + "&cardNo=" + CA.card.serialNumber, function(){
                        cursor.call("selectAct");
                    });
                }catch (e) { }
            } else {
                cursor.call("selectAct");
            }
        },
        showNextMatches : function(){
            var check = function( date ){
                cursor.lives = [];
                cursor.prepares = [];

                for( var i = 0; i < cursor.schedule.items.length; i ++) {
                    var item = cursor.schedule.items[i];
                    if( date < item.start ) {
                        item.isLive = false;
                        cursor.prepares.push(item); continue;
                    } else if( item.start <= date && date < item.end ){
                        item.isLive = true;
                        cursor.lives.push(item); continue;
                    } else {
                        cursor.schedule.items.removeAt(i);
                        i --;
                    }
                }
            };

            var showItems = function(){
                var date = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
                check( date );
                var live = typeof cursor.schedule.live == 'undefined' ? 0 : cursor.schedule.live ;
                var prepare = typeof cursor.schedule.prepare == 'undefined' ? 0 : cursor.schedule.prepare ;

                var items = [];
                var item = undefined;
                if( cursor.lives.length > 0 ) {
                    if( live >= cursor.lives.length ) live = 0;
                    item = cursor.lives[live];
                    items.push(item);
                    cursor.schedule.live = live += 1;
                }
                var next = function( num ){
                    if( cursor.prepares.length == 0 ) return;
                    if( prepare >= cursor.prepares.length ) prepare = 0;
                    iPanel.debug("prepare:" + prepare);
                    items.push(cursor.prepares[prepare]);
                    cursor.schedule.prepare = prepare += 1;

                    if( num == 1 || cursor.prepares.length == 1 ) return;

                    if( prepare >= cursor.prepares.length ) prepare = 0;
                    items.push(cursor.prepares[prepare]);

                };
                next( items.length == 0 ? 2 : 1);
                if( items.length == 0 ){
                    $("notice").style.backgroundImage = "url('images/WorldCupIcon.png')";
                }
                var html = "";
                for( var i = 0; i < 2; i ++ ) {
                    var id = i + 1;
                    if( i >= items.length ) {
                        $("noticeStatus" + id).style.visibility =  "hidden"; continue;
                    }
                    item = items[i];
                    var flags = item.abbr.split(":");
                    var teams = item.compete.split(":");
                    var times = item.time.split(" ");
                    $("noticeStatus" + id).className = "noticeStatus notice" + id + (item.isLive ? " live" : " prepare");
                    html += "<div class='noteItem'" + ( i == 1 ? " style='top:146px;'" : "") + ">";
                    html += "<div class='team'>";
                    html += "<div class='flag'><img src='images/" + flags[0] + ".png' /></div>";
                    html += "<div class='name'>" + teams[0] + "</div>";
                    html += "</div>";
                    html += "<div class='text'>";
                    html += "<div>" + times[0] + "</div>";
                    html += "<div>" + times[1] + "</div>";
                    html += "</div>"
                    html += "<div class='team'>";
                    html += "<div class='flag'><img src='images/" + flags[1] + ".png' /></div>";
                    html += "<div class='name'>" + teams[1] + "</div>";
                    html += "</div>";
                    html += "</div>";
                }
                $("notice").innerHTML = html;

            }
            showItems();
            setInterval(function(){showItems();}, 6000);
        },
        showScrolls : function(init){
            var showPic = function(){
              var focus = cursor.focusable[2].focus;
              var items = cursor.focusable[2].items;

              var item = items[focus];
              if( item ) $("scrollPic").innerHTML = "<img src='" + cursor.pictureUrl(item.posters,0,"images/defaultScrollPic.jpg") + "' />";
              for( var i = 0; i < 3; i ++ ){
                  var id = i + 1;
                  $("scrollStatus" + id).className = "scrollStatus" + (i == focus ? "Focus" : "") + " scrollStatus" + id ;
              }
            };
            if( init ) showPic();
            if( cursor.scrollTimer ) return;
            cursor.scrollTimer = setInterval( function(){
                if( cursor.blocked == 2 ) return;
                var focus = cursor.focusable[2].focus;
                var items = cursor.focusable[2].items;
                focus += 1;
                if( focus >= items.length ) focus = 0;
                cursor.focusable[2].focus = focus;
                showPic();
            }, 5000);
        },
        move : function(index){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 && (blocked <= 2 ) || index == -11 && blocked == 4 || index == -1 && focus <= 0 && ( blocked == 0 || blocked >= 3 ) || index == 1 && focus + 1 >= items.length && blocked >= 2 ) return;

            if( index == 1 || index == -1 ){
                focus += index;
                if( focus < 0 ) {
                    blocked -= 1;
                    focus = cursor.focusable[blocked].items.length - 1;
                } else if( focus >= items.length ) {
                    blocked += 1;
                    focus = blocked == 2 ? cursor.focusable[blocked].focus : 0;
                }
            } else if( index == -11 ) {
                if( blocked <= 2 ) {
                    if( blocked == 0 ) {
                        // focus 不变
                    } else {
                        focus =  blocked == 1 ? 2 : 4;
                    }
                    blocked = 3;
                } else {
                    blocked = 4;
                    focus = focus <= 1 ? 0 : focus -1;
                }
            } else {
                if( blocked == 4 ) {
                    blocked = 3;
                    focus = focus == 0 ? 0 : focus + 1;
                }  else {
                    if( focus <= 1 ) {
                        blocked = 0;
                    } else if( focus == 2 || focus == 3 ) {
                        blocked = 1;
                        focus = 0;
                    } else {
                        blocked = 2;
                        focus = cursor.focusable[blocked].focus;
                    }
                }
            }

            cursor.blocked = blocked;
            cursor.focusable[blocked].focus = focus;
            cursor.call("show");
        },
        preparePlay : function(){
            player.setPosition(74,144,460,256);
            if( !cursor.vodId ) {
                var focus = cursor.focusable[0].focus;
                var item = cursor.focusable[0].items[focus];
                player.play({frequency :item.frequency, serviceId: item.serviceId });
                $("liveStatus").className = "liveStatus liveStatus" + (focus + 1);
                $("liveStatus").style.visibility = "visible";
            } else {
                $("liveStatus").style.visibility = "hidden";
                player.play({ 'vodId':cursor.vodId });
            }
        },
        nextVideo   :   function () {
            cursor.call("preparePlay");
        },
        show : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var id = String( blocked + 1);
            $("mask").className = "mask mask" + id + " item" + id + (focus + 1);
            if( blocked != 0 && blocked != 2) return;
            if( blocked == 2 ) {
                cursor.call("showScrolls", true);
                return;
            }
            // 如果 vodId 不为空，或为0时，播放直播信号
            if( ! cursor.vodId ) cursor.call("preparePlay");
        }
    });
    -->
</script>
</html>