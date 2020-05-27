<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%-- -->
<%--
    模板说明: 基于行,列显示方式的投票模板, 如果有活动介绍时,介绍图片上传至专题栏目背景图(序号为2)
    参数说明:
    typeId:     栏目ID
    row:        页面显示几行
    col:        页面显示几列
    commet:     是否显示每个投票的介绍
    play:       是否播放视频
    showNo:     是否显示编号
    showRst:    是否显示投票结果
    showRanking: 是否显示排行榜
    showPage:    是否显示分页
    showIntroduce:是否显示活动介绍,活动介绍的焦点上传至专题栏目草图(序号1)
    countRank:   排行榜显示前X名!
    voteId:      投票的ID号
    startTime:   投票开始时间
    endTime:     投票结束时间
    withPhone:   是否需要输入电话号码
    direct:      投票按钮在图片的位置(右侧 1,或下方 0)
    pos:         投票条目第一个元素的坐标位置: left,top,width,heihgt
    pagePos:     分页按钮的坐标位置: left,top
    introducePos:活动介绍焦点的坐标位置: left,top
    imgPos:      图片的宽度和高度:width:height
    borderImg:   图片的边框的默认颜色，默认2个象素宽度
    fborderImg:  图片的边框的焦点颜色，默认6个象素宽度
    txtColor:    文字的显示颜色
    txtBgColor:  文字背景颜色
    btnPos:      投票按钮的宽度和高度:width:height
    btnColor:    投票按钮的颜色，[非焦点背景颜色],[非焦点字体颜色],[焦点背景颜色],[焦点字体颜色]
    splitPos:    右面分页背景条位置left,top,width,heihgt
    splitColor:  右面分页背景颜色
    pagePos:     右面分页文字块位置 left,top,width,heihgt
    pageBgColor: 右面分页文字块背景颜色
    nameSplit:   是否拆分名字，为0时，不拆分文字，为1时，取左边的文字，为1时，取右边的文字.
    voteLimit:   每个人每天最多投 ? 票,
    limitPer:    每个人，每天给指定的人限投 ? 票

    rankPos:     排行榜显示坐标
    rankNum:     排行榜显示数量
    rnkItmPos:   排行榜元素的宽度，高度
    rnkFntSiz:   排行榜字体大小
    rnkFntCol:   排行榜字体颜色.
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId,0,99));

    int row = inner.getInteger("row", 2);
    int col = inner.getInteger("col", 5);
    boolean commet = !isEmpty(inner.get("commet"));
    boolean play = !isEmpty(inner.get("play"));
    boolean showNo = !isEmpty(inner.get("showNo"));
    boolean showRanking = !isEmpty(inner.get("showRanking"));
    boolean showPage = !isEmpty(inner.get("showPage"));
    boolean showIntroduce = !isEmpty(inner.get("showIntroduce"));
    boolean showRst = !isEmpty(inner.get("showRst"));
    int countRank = inner.getInteger("countRank", 5);
    int voteId = inner.getInteger("voteId", -1);
    String startTime = inner.get("startTime");
    String endTime = inner.get("endTime");
    boolean withPhone = !isEmpty(inner.get("withPhone"));
    int direct = inner.getInteger("direct",0);
    //此pos在传递参数时，为第一个元素的宽度和高度，实际通过此坐标计算浮层的坐标与位置
    Rectangle  pos = inner.getRectangle("pos");
    //container 用来保存 pos传递过来的参数
    Rectangle container = new Rectangle();
    container.width = pos.width;
    container.height = pos.height;
    pos.width = (container.width + 2) * col;
    pos.height = (container.height + 2) * row;
    Rectangle  introducePos = inner.getRectangle("introducePos");
    Rectangle  imgPos = inner.getRectangle("imgPos");

    //由于getRectangle取值问题，所以width和height被保存在left,top中，所以这里进行交换
    imgPos.width = imgPos.left;imgPos.left = 0;
    imgPos.height = imgPos.top;imgPos.top = 0;

    Rectangle  btnPos = inner.getRectangle("btnPos");
    btnPos.width = btnPos.left;btnPos.left = 0;
    btnPos.height = btnPos.top;btnPos.top = 0;

    String borderImg = isEmpty(inner.get("borderImg")) || inner.get("borderImg").equalsIgnoreCase("transparent") ? "transparent" : "#" + inner.get("borderImg");
    String fborderImg = isEmpty(inner.get("fborderImg")) || inner.get("fborderImg").equalsIgnoreCase("transparent") ? "transparent" : "#" + inner.get("fborderImg");
    String txtColor = isEmpty(inner.get("txtColor")) ? "white" : "#" + inner.get("txtColor");
    String txtBgColor = isEmpty(inner.get("txtBgColor")) ? "transparent" : "#" + inner.get("txtBgColor");

    String btnColor = inner.get("btnColor");
    String btnBgColor = "#e90000";
    String btnFontColor = "#ffffff";
    String btnFcBgColor = "#ffb400";
    String btnFcFontColor = "#ffffff";
    if( !isEmpty(btnColor) ) {
        String[] colors = btnColor.split("\\,");
        btnBgColor = colors.length <= 0 ? btnBgColor : "#" + colors[0];
        btnFontColor = colors.length <= 1 ? btnFontColor : "#" + colors[1];
        btnFcBgColor = colors.length <= 2 ? btnFcBgColor : "#" + colors[2];
        btnFcFontColor = colors.length <= 3 ? btnFcFontColor : "#" + colors[3];
    }


    Rectangle splitPos = inner.getRectangle("splitPos");
    String splitColor = isEmpty(inner.get("splitColor")) ? "#ab5862" : "#" + inner.get("splitColor");

    Rectangle  pagePos = inner.getRectangle("pagePos");
    String pageBgColor = isEmpty(inner.get("pageBgColor")) ? "#3faafd" : "#" + inner.get("pageBgColor");
    String pageColor = isEmpty(inner.get("pageColor")) ? "white" : "#" + inner.get("pageColor");

    Rectangle rankPos = inner.getRectangle("rankPos");
    Rectangle rnkItmPos = inner.getRectangle("rnkItmPos");
    String rnkFntCol = isEmpty(inner.get("rnkFntCol")) ? "white" : "#" + inner.get("rnkFntCol");
    int rankNum = inner.getInteger("rankNum", 5);
    int rnkFntSiz = inner.getInteger("rnkFntSiz", 18);

    int nameSplit = inner.getInteger("nameSplit",0);
    int voteLimit = inner.getInteger("voteLimit",10);
    int limitPer = inner.getInteger("limitPer",voteLimit);

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("images/bg-Template-Vote-1.jpg",column.getPosters(),"7");
%>
<html>
<head>
    <title><%=column == null ? "投票专题模板" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .flowed{position: absolute;left:<%=pos.left%>px;top:<%=pos.top%>px;width:<%=pos.width%>px;height:<%=pos.height%>px;overflow: hidden;}
        .itemContainer{position: relative;width:<%=container.width%>px;height:<%=container.height%>px;overflow: hidden;float: left;}
        .imgContainer{position:absolute;width:<%=imgPos.width + 4%>px;height:<%=imgPos.height + 4%>px;left:3px;top:3px;background-color:<%=borderImg%>}
        .imgBorder{position:absolute;width:<%=imgPos.width%>px;height:<%=imgPos.height%>px;left:5px;top:5px;overflow: hidden;}
        .imgBorder img{width:<%=imgPos.width%>px;height:<%=imgPos.height%>px;}
        .imgContainerFocus{position:absolute;width:<%=imgPos.width + 10%>px;height:<%=imgPos.height + 10%>px;left:0px;top:0px;background-color:<%=fborderImg%>}
        .txt{position:absolute;left:5px;top:<%=imgPos.height + 10%>px;height:<%=btnPos.height%>px;font-size:18px;line-height: <%=btnPos.height%>px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden; color:<%=txtColor%>;background-color:<%=txtBgColor%>;padding:0px 4px 0px 4px;}
        .voteBtn,.voteBtnFocus{position:absolute;left:<%=imgPos.width + 5 - btnPos.width%>;top:<%=imgPos.height + 10%>px;width:<%=btnPos.width%>px;height:<%=btnPos.height%>px;line-height:<%=btnPos.height - 4%>px;font-size:22px; text-align: center;}
        .voteBtn{color:<%=btnFontColor%>;background-color: <%=btnBgColor%>;}
        .voteBtnFocus{color:<%=btnFcFontColor%>;background-color: <%=btnFcBgColor%>;}
        .commet{position:absolute;width:<%=imgPos.width%>px;left:5px;top:<%=imgPos.height + btnPos.height + 15%>px; height:<%=container.height - imgPos.height - btnPos.height - (container.width - imgPos.width) * 0.75 - 15%>px;overflow: hidden; color:<%=txtColor%>;font-size:16px;line-height:<%=(container.height - imgPos.height - btnPos.height - (container.width - imgPos.width) * 0.75 - 15) / 2 + 1%>px;}
        .txtResult {width:60px;height:16px;position:absolute;left:5px;top:<%= imgPos.height + 5 - 16%>px;color:<%=btnFcFontColor%>;background-color: <%=btnFcBgColor%>;font-size:14px;line-height: 16px;text-align: center;}
        .split{position:absolute;width:<%=splitPos.width%>px;left:<%=splitPos.left%>px;top:<%=splitPos.top%>px; height:<%=splitPos.height%>px;overflow: hidden; background-color:<%=splitColor%>;}
        .page{position:absolute;width:<%=pagePos.width%>px;left:<%=pagePos.left%>px;top:<%=pagePos.top%>px; height:<%=pagePos.height%>px;overflow: hidden; background-color:<%=pageBgColor%>;}
        .pageNum,.pageCount,.pageSplit{position:absolute;width:<%=pagePos.width%>px;height:20px;line-height: 20px;font-size: 20px;color:<%=pageColor%>;text-align: center;left:0px;overflow: hidden;}
        .pageNum{top:<%=(pagePos.height - 60)/3%>px;}
        .pageSplit{top:<%=(pagePos.height - 60)/3 + 20%>px;}
        .pageCount{top:<%=(pagePos.height - 60)/3 + 40%>px;}

        .voteBg{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px -400px;}
        .voteBgTooltip{background-position:0px -400px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-size:22px;}
        .txtTooltip{position: absolute;width: 350px;height: 80px;left: 130px;top: 70px;background-color: transparent;color: #ffffff;font-size: 26px;line-height:40px;text-align: center;overflow: hidden;}
        .voteSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .voteCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}

        .ranking{width:<%=rankPos.width%>px;height:<%=rankPos.height%>px;left:<%=rankPos.left%>px;top:<%=rankPos.top%>px;position:absolute;overflow: hidden;}
        .rankItem{width:<%=rankPos.width%>px;height:<%=rankPos.height/5-1%>px;float:left;overflow:hidden;position:relative;}
        .rankItem .name{width:120px;height:25px;overflow:hidden;position:absolute;left:0px;top:22px;color:white;font-size:20px;text-align:center;line-height:25px;}
        .rankItem .num{width:50px;height:18px;overflow:hidden;position:absolute;left:<%=rankPos.width - 80%>px;top:38px;color:white;font-size:16px;text-align:center;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js" charset="GBK"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black<%= isEmpty(picture) ? "" : (" url(" + picture + ")")%> no-repeat;" onUnload="exit();">
<div id="flowed" class="flowed"></div>
<%if( showPage ){ %>
<div id="split" class="split"></div>
<div id="page" class="page"></div>
<%}%>
<%if( showRanking ) { %>
<div id="ranking" class="ranking"></div>
<% } %>
<div id='voteResultDialog' class='voteBg' style="visibility: hidden"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){

            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.row = <%= row %>;
            cursor.col = <%= col %>;
            cursor.commet = <%= commet %>;
            cursor.play = <%= play %>;
            cursor.showNo = <%= showNo %>;
            cursor.showRanking = <%= showRanking %>;
            cursor.showPage = <%= showPage %>;
            cursor.showIntroduce = <%= showIntroduce %>;
            cursor.showRst = <%= showRst %>;
            cursor.countRank = <%= countRank %>;
            cursor.voteId = <%= voteId %>;
            cursor.direct = <%= direct %>;
            cursor.withPhone = <%= withPhone %>;
            cursor.startTime = '<%= startTime %>';
            cursor.endTime = '<%= endTime %>';
            var currentTime = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
            cursor.showBtn = currentTime >= cursor.startTime && ( cursor.endTime.isEmpty() || currentTime <= cursor.endTime );

            //当前焦点是否在投票按钮上
            cursor.voteBtnFocused = false;
            //当前是否显示投票输入框
            cursor.voteShowInput = false;
            //是否显示投票提示框
            cursor.voteShowDialog = false;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            var items = cursor.focusable[0].items;
            for( var i = 0 ; i < items.length; i ++){
                if( <%=nameSplit%> > 0 ) {
                    var txt = items[i].name;
                    var match = /(.*)（(.*)）/gi.exec( txt );
                    if (typeof match === 'undefined' || match === null ) {
                        items[i].originName = items[i].name;
                        items[i].split = '';
                        items[i].name = '';
                    } else {
                        items[i].originName =  items[i].name;
                        items[i].name = <%=nameSplit%> == 1 ? match[1] : match[2];
                        items[i].split = <%=nameSplit%> == 1 ? match[2] : match[1];
                    }
                }
                items[i].voteCount = 0;
            }
            cursor.call('show');
            cursor.showRankFunc = function( results ){
                var html = "";
                for( var i = 0; i < results.length && i < <%= rankNum%>; i ++){
                    html += "<div class='rankItem'>";
                    html += "<div class='name'>" + results[i].name + "</div>";
                    html += "<div class='num'>" + results[i].num + "</div>";
                    html += "</div>"
                }
                $("ranking").innerHTML = html;
            };
            if(cursor.showRst) cursor.call("voteResult",{callback:cursor.show});
            if(cursor.showRanking) cursor.call("voteResult",{callback:cursor.showRankFunc});
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            if( cursor.voteShowDialog ) return;
            if( cursor.voteShowInput ) {
                return;
            }

            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( index == 1 ) {
                //如果不显示投票按钮，或者投票按钮在图片下方时
                if( !cursor.showBtn || cursor.showBtn && cursor.direct === 0 ){
                    if ( focus % cursor.col === cursor.col - 1 || focus + 1 >= items.length ) return;
                    focus += 1;
                } else { //显示投票按钮，但是焦点没在最后一个的投票按钮上
                    if( ( focus % cursor.col === cursor.col - 1 || focus + 1 >= items.length ) && cursor.voteBtnFocused ) return;
                    if( cursor.voteBtnFocused ) {
                        cursor.voteBtnFocused = false;
                        focus += 1;
                    } else {
                        cursor.voteBtnFocused = true;
                    }
                }
            } else if( index == -1 ) {
                //如果不显示投票按钮，或者投票按钮在图片下方时
                if( !cursor.showBtn || cursor.showBtn && cursor.direct === 0 ){
                    if( focus % cursor.col === 0 ) return;
                    focus -= 1;
                } else { //焦点在第一列，但是焦点不在投票按钮上时
                    if( focus % cursor.col === 0 && !cursor.voteBtnFocused ) return;
                    if( cursor.voteBtnFocused ) {
                        cursor.voteBtnFocused = false;
                    } else {
                        focus -= 1;
                        cursor.voteBtnFocused = true;
                    }
                }
            } else if( index == 11 ) {
                if( !cursor.showBtn || cursor.showBtn && cursor.direct === 1 ){
                    if( index === 11 && focus < cursor.col ) return;
                    focus -= cursor.col;
                } else { //显示投票按钮，但是焦点没在最后一个的投票按钮上
                    if( index === 11 && focus < cursor.col && !cursor.voteBtnFocused ) return;
                    if( cursor.voteBtnFocused ) {
                        cursor.voteBtnFocused = false;
                    } else {
                        focus -= cursor.col;
                        cursor.voteBtnFocused = true;
                    }
                }
            } else {
                //如果不显示投票按钮，或者投票按钮在图片右方时
                if( !cursor.showBtn || cursor.showBtn && cursor.direct === 1 ){
                    if ( Math.floor( focus * 1.0 / cursor.col ) * cursor.col + cursor.col >=  items.length ) return;
                    focus += cursor.col;
                } else { //显示投票按钮，但是焦点没在最后一个的投票按钮上
                    if( ( Math.floor( focus * 1.0 / cursor.col ) * cursor.col + cursor.col >=  items.length ) && cursor.voteBtnFocused ) return;
                    if( cursor.voteBtnFocused ) {
                        cursor.voteBtnFocused = false;
                        focus += cursor.col;
                    } else {
                        cursor.voteBtnFocused = true;
                    }
                }
                if( focus >= items.length ) focus = items.length - 1;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var items = cursor.focusable[0].items || {};
            if( items.length <= 0 ) return;

            var focus = cursor.focusable[0].focus;
            //每页显示数量
            var pageCount = cursor.row * cursor.col;
            //每页显示数量
            var currentPage = Math.floor(focus / pageCount);
            var flowCursorIndex = currentPage * pageCount;
            var html = '';
            if( cursor.showPage ) {
                html += "<div class='pageNum'>" + (currentPage  + 1 ) + "</div>";
                html += "<div class='pageSplit'>/</div>";
                html += "<div class='pageCount'>" +  Math.ceil(items.length / pageCount)  + "</div>";
                $("page").innerHTML = html;
            }
            html = "";
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1){
                var item = items[i];
                var isFocus = i === focus;
                html += "<div class='itemContainer'>";
                html += "<div class='" + ( isFocus && !cursor.voteBtnFocused ? "imgContainerFocus" : "imgContainer" ) + "'></div>";
                html += "<div class='imgBorder'><img src='" + cursor.pictureUrl(item.posters, 1) + "' /></div>";
                html += "<div class='txt' style='width:" + ( cursor.showBtn ? <%=imgPos.width - btnPos.width%> : <%= imgPos.width %> ) + "px'>" + (cursor.showNo ? (String(i + 1).padLeft(2,'0') + " ") : "") + item.name + "</div>";
                if( cursor.showRst ) html += "<div class='txtResult'>" + item.voteCount + "</div>";
                if( cursor.showBtn ) html += "<div class='" + ( isFocus && cursor.voteBtnFocused ? "voteBtnFocus" : "voteBtn" ) + "'>投票</div>";
                if( cursor.commet ) html += "<div class='commet'>" + (item.introduce || "") + "</div>";
                html += "</div>";
            }
            $("flowed").innerHTML = html;
        },
        goBack      :   function(){
            if( cursor.voteShowDialog ){cursor.call("hideVoteToolTip"); return;}
            cursor.call("goBackAct");
        },
        hideVoteToolTip : function () {
            $("voteResultDialog").style.visibility = "hidden";
            cursor.voteShowDialog = false;
        },
        showVoteTooltip : function(message){
            cursor.voteShowDialog = true;
            var html = "<div class='txtTooltip'>" + message + "</div>";
            $("voteResultDialog").innerHTML = html;
            $("voteResultDialog").className = "voteBg voteBgTooltip";
            $("voteResultDialog").style.visibility = "visible";
        },
        select      :   function(){
            if( cursor.voteShowDialog ){cursor.call("hideVoteToolTip"); return;}
            if( cursor.voteBtnFocused ) {
                var item = cursor.focusable[0].items[cursor.focusable[0].focus];
                (function(target){
                    cursor.call("sendVote",{
                        id:<%=voteId%>,
                        limit:<%=voteLimit%>,
                        limitPer:<%=limitPer%>,
                        target:target,
                        repeat:true,
                        callback: function(result){
                            if(result.recode != '002' || result.result == false ){
                                cursor.call("showVoteTooltip","您投票次数超出限制，您每天最多可投 <%= voteLimit %> 票！");
                            } else {
                                if(cursor.showRanking){
                                    cursor.call("voteResult",{callback:cursor.showRankFunc},true);
                                } else if(cursor.showRst){
                                    cursor.call("voteResult",{callback:cursor.show},true);
                                } else {
                                    cursor.call("showVoteTooltip","您已投票成功！");
                                }
                            }
                        }
                    });
                })(item.name);
                return;
            }
            cursor.call("selectAct");
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>