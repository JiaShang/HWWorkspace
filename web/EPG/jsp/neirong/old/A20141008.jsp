<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104581";

    final String[] types = {"10000100000000090000000000104586", "10000100000000090000000000104585"};

    final int popItemMaxCharLength = 36;
    //TODO:每次需要修改
    int length = 50, start = 0;
    //区块中当前被选择的顺序
    int focused = 0;
    //选择的区块 0:普通焦点，1:首页，返回按钮，2:弹出对话框中的上一页，下一页，返回，3:弹出对话框中的列表中的条目
    int area = 0;

    String backUrl = "";
    String value = "";

    List<List<Vod>> list = null;

    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");

        if(null == playBack){
            if(null == fcr)
                turnPage.addUrl();
            else{
                turnPage.removeLast();
                turnPage.addUrl();
            }
        }
        else{
            turnPage.removeLast();
        }

        // 返回时获取焦点信息数据
        String[] focus = turnPage.getPreFoucs();
        if(null != focus ){
            if( focus.length > 0 && focus[0] != null )
                area = Integer.parseInt(focus[0]);
            if( focus.length > 1 && focus[1] != null )
                focused = Integer.parseInt(focus[1]);
        }

        backUrl = turnPage.go(-1);

        MetaData metaHelper = new MetaData(request);
        list = new ArrayList<List<Vod>>();
        for( String type : types ){
            List<Vod> ls = getVodList( metaHelper, type, length, start );
            list.add( ls );
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title>我是歌手中韩PK</title>
<style>
    .mask {position:absolute;width:326px; height:127px;}
    .mask1 {left:70px;top:537px;background:transparent url('images/mask-2014-10-08.png') no-repeat fixed 0px 0px;}
    .mask2 {left:902px;top:203px;background:transparent url('images/mask-2014-10-08.png') no-repeat fixed 0px -127px;}
    .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed 0px 0px; top:636px;left:1066px; width:161px;height:41px;}
    .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat fixed 0px -42px; top:636px;left:1066px; width:161px; height:41px;}

    .chunk {width:633px;height: 426px;left:165px;top:100px;position:absolute;background:transparent url('images/popup.png') no-repeat fixed 0px 0px; overflow: hidden;}
    .chunk .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
    .chunk .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
    .chunk .item,.maskItem{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -426px; overflow: hidden;}
    .maskItem {background-position:0 -477px;position:absolute; color: #fefefe;}
    .marqueed {font-size: 24px; height: 51px; width: 460px;color: #fefefe;line-height:45px;}
    .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }
</style>
<script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window);} catch (e) {};
    var blocked = blocked ? blocked : <%= area %>;
    var selected = selected ? selected : <%= focused %>;


    //TODO:每次需要修改的地方
    //用来存放弹出对话框中光标的基准坐标位置， 对话框的坐标 ＋ 对话框中Container的相对坐标
    var popStyleLeft = 165 + 45;
    var popStyleTop = 100 + 38;

    //弹出对话框中最大列表数量
    var popMaxItemsLength = 6;
    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
        {focus:0,items:[
            <%
                if( list != null && list.size() > 0){
                  value = "";
                  for( int i = 0; i < list.size(); i ++) {
                     value += "<div class='chunk' id='chunk" + ( i + 1 ) +  "' style='display:none'><div class='container'  id='container" + ( i + 1 ) + "'><div class='content' id='content" + ( i + 1 ) + "'>";
                     out.write("{focus:0,items:[");
                     List<Vod> vodList = list.get(i);
                     for( int j = 0; j < vodList.size(); j++ ){
                        Vod vod = vodList.get(j);
                        value += "<div class='item'>" + StringUtil.limitStringLength(vod.getName(),popItemMaxCharLength) + "</div>";
                        out.write("{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                           "playType:" + vod.getIsSitcom() + "," +
                             "length:" + StringUtil.length(vod.getName()) +
                         "}" +  ( j + 1 < vodList.size() ? "," : ""));
                     }
                     out.write("], style:'mask mask" + ( i + 1 ) + "'}" +  ( i + 1 < list.size() ? "," : ""));
                     value += "</div></div><div class='page' id='page" + ( i + 1 ) + "'>1/1</div></div>";
                  }
                  out.flush();
            }
            %>
        ]},
        { focus:0, items : [
            {name:'首页',style:'btnHome'},
            {name:'返回',style:'btnReturn'}
        ]},
        { focus:0, items : [
            {name:'上一页',style:'previous'},
            {name:'下一页',style:'next'},
            {name:'返回',style:'return'}
        ]}
    ];

    var backUrl = '<%= backUrl %>';
    var typeId = '<%= typeId %>';

    function popFocused(){
        var index = blocked - 3;
        var array = focusable[0].items;
        selected = array[index].focus;
        var item =  focusable[0].items[blocked - 3].items[selected];
        $("page" + (index + 1)).innerText = (Math.ceil((selected + 1) / popMaxItemsLength) + "/" + Math.ceil(array[index].items.length / popMaxItemsLength));
        $("chunk" + (blocked -2)).style.display = "block";
        $("mask").className = "maskItem";
        $("content" + (blocked -2)).style.marginTop = "-" + (Math.floor(selected / popMaxItemsLength) * popMaxItemsLength * 51) + "px";
        $("mask").style.top =  (popStyleTop + selected % popMaxItemsLength * 51) + "px";
        $("mask").style.left = popStyleLeft + "px";
        $("mask").innerHTML = item.length <= <%= popItemMaxCharLength %> ? item.text : ("<marquee class='marqueed'>" + item.text + "</marquee>");
        focusable[0].items[index].focus = selected;
    }

    function popLoses(){
        $("chunk" + (blocked -2)).style.display = "none";
        selected = blocked - 3;
        $("mask").style.top = "";
        $("mask").style.left = "";
        $("mask").innerHTML = "";
        blocked = 0;
        $("mask").className = focusable[blocked].items[selected].style;
    }

    function focused(index,initilized){
        if( initilized ){
            if( blocked < 2){
                $("mask").className = focusable[blocked].items[selected].style;
                $("mask").style.display = "block";
            }
            else if( blocked >= 3){
                focusable[0].items[blocked - 3].focus = selected;
                popFocused();
            }
            else {
                $("mask").style.display = "none";
            }
            return;
        }
        //左-1,右1
        if( index == -1 || index == 1 ){
            if(blocked < 2 ){

               selected = focusable[blocked].focus;
               selected += index;

               if( selected < 0)
                 selected = focusable[blocked].items.length - 1;
               else if( selected >= focusable[blocked].items.length)
                 selected = 0;

               focusable[blocked].focus = selected;

               $("mask").className = focusable[blocked].items[selected].style;

            } else if( blocked >= 3){
                focusable[0].items[blocked - 3].focus = index == -1 ? (focusable[0].items[blocked - 3].focus - popMaxItemsLength < 0  ? focusable[0].items[blocked - 3].focus : focusable[0].items[blocked - 3].focus - popMaxItemsLength ) : ( focusable[0].items[blocked - 3].focus + popMaxItemsLength >= focusable[0].items[blocked - 3].items.length  ? focusable[0].items[blocked - 3].items.length - 1: focusable[0].items[blocked - 3].focus + popMaxItemsLength );
                popFocused();
            }
        //上:11,下:-11
        } else if(index == -11 || index == 11){
            if(blocked == 0 || blocked == 1){
                blocked =  blocked != 1 ? 1 : 0;
                selected = focusable[blocked].focus;
                $("mask").className = focusable[blocked].items[selected].style;
            } else if(blocked >=3){
                if(index == 11 && focusable[0].items[blocked - 3].focus - 1 < 0 || index == -11 && focusable[0].items[blocked - 3].focus + 1 >= focusable[0].items[blocked - 3].items.length)
                return;
                focusable[0].items[blocked - 3].focus += index == -11 ? 1 : -1;
                popFocused();
            }
        }
    }
    function doEnter(){
        try{ E.is_HD_vod = true; } catch (e) {}
        if(blocked == 0){
            blocked = 3 + focusable[blocked].focus;
            popFocused();
        } else if( blocked >= 3) {
            var item =  focusable[0].items[blocked - 3].items[selected];
            if( item.playType == 1)
                top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/high_TV_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
            else {
                top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
            }
        } else {
            if(focusable[blocked].focus == 0)
                top.window.location.href = backUrl;
            else
                top.window.location.href = iPanel.eventFrame.portalUrl;
        }
    }

    function init(){
        if( typeof $ == "undefined" ){
            $ = function (objectId) {
                if(document.getElementById && document.getElementById(objectId)) {
                    return document.getElementById(objectId);
                } else if (document.all && document.all(objectId)) {
                    return document.all(objectId);
                } else if (document.layers && document.layers[objectId]) {
                    return document.layers[objectId];
                } else {
                    return false;
                }
            };
        }
        if( typeof iPanel == "undefined" ) {
            document.onkeydown = function(event){
                switch (event.keyCode) {
                    case 38:                        //上光标键
                        focused(11, false);
                        break;
                    case 40:                        //下光标键
                        focused(-11, false);
                        break;
                    case 37:                        //左光标键
                        focused(-1, false);
                        break;
                    case 39:                        //右光标键
                        focused(1, false);
                        break;
                    case 13:                        //选择回车键
                        doEnter();
                        break;
                    case "KEY_BACK":
                        top.window.location.href = backUrl;
                        break;
                    case "KEY_EXIT":
                    case "KEY_MENU":
                        top.window.location.href = iPanel.eventFrame.portalUrl;
                        return 0;
                        break;
                }
            }
        }

        focused(<%= focused %>, true);
    }
    function eventHandler(eventObj, __type){
        switch(eventObj.code){
            case "KEY_UP":
                focused(11, false);
                break;
            case "KEY_DOWN":
                focused(-11, false);
                break;
            case "KEY_LEFT":
                focused(-1, false);
                break;
            case "KEY_RIGHT":
                focused(1, false);
                break;
            case "KEY_SELECT":
                doEnter();
                break;
            case "KEY_BACK":
                if( blocked < 3)
                    window.location.href = backUrl;
                else
                    popLoses();
                break;
            case "KEY_EXIT":
            case "KEY_MENU":
                location.href = iPanel.eventFrame.portalUrl;
                return 0;
                break;
        }
        return 	eventObj.args.type;
    }
    function focusURL(){
        return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + selected + "&url=";
    }
    window.onload = function(){
        setTimeout("init()",100);
    }
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2014-10-08.jpg') no-repeat;">
<%= value %>
<div id="mask"></div>
</body>
</html>