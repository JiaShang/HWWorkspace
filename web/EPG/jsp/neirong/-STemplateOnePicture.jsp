<%--
    参数说明：
    当左侧有文字显示时, 整个条目的宽度为: [条目宽度] + [左侧标签的宽度] + [与右边条目之间的距离]
    bp: height,left,top,color   背景竖条参数
    ps: width,height,left,top   视频位置.通过视频位置计算背景图片的坐标
    loop:                       是否循环播放. 不循环播放时，只播放第一条视频，否则循环播放,0,循环，1，不循环，2，使用图片
    pg:                         当前页显示多少条视频
    item:[整个条目容器的Width],[整个条目容器的Height],[整个条目容器的LEFT],[整个条目容器的TOP],[条目宽度],[条目高度],[背景颜色],[字体颜色],[字体大小]， 单条目容器的高度用计算方式获得
    fc:                         焦点字体颜色
    fcbr:[宽度]，[颜色]            获得焦点后条目边框颜色
    fcbg:                        当获得焦点后背景颜色
    split:                      是否显示左侧文字, 0 为无文字显示,1为有文字显示
    mk:[与右边条目之间的距离],[宽度]:[颜色]:[对齐方式]    当左侧显示文字时，显示左侧文字内容，对齐方式为：0，左对齐，1：右对齐，2：居中对齐
--%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%!
    final Pattern pattern = Pattern.compile("^?\\d+$");
    private boolean isNumeric(String str) {
        Matcher matcher = pattern.matcher(str);
        return matcher.matches();
    }
    private String getString(HttpServletRequest request,String name){
        String value = request.getParameter(name);
        return StringUtils.isEmpty( value ) ? "" : value;
    }
    private int getInteger(HttpServletRequest request,String name){
        try {
            String value = request.getParameter( name ).trim();
            return isNumeric( value ) ? Integer.parseInt( value ) : 0;
        } catch ( Throwable e) {
            return 0;
        }
    }
    private void print(JspWriter out, String message){
        try {
            out.println("<!-- " + message + " -->");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {typeId};
    final int[] position = {50,0};
    //TODO:每次需要修改
    int focused = 0, area = 0;
    int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    int slitWidth = 2, slitHeight = 0,slitLeft = 0,slitTop = 0;
    int videoWidth = 0,videoHeight = 0,videoLeft = 0,videoTop = 0;
    int loop = 0,focusBorderWidth = 0,fontSize = 0;
    String slitColor = "",itemBackgroundColor = "",itemColor = "",focusColor = "",focusBorderColor = "",focusBackgroundColor = "";
    int containerWidth = 0,containerHeight = 0,containerLeft = 0,containerTop = 0,itemContainerWidth = 0,itemContainerHeight = 0,itemWidth = 0,itemHeight = 0;
    int rows = 5, split = 3, markWidth = 0,markMarginRight = 0;
    String markAlign = "0", markColor = "";

    String bodyLeft = "",bodyTop = "", bodyRight = "", bodyBottom = "";
    int played = 0, playIndex = 0,playTime = 0;

    List<List<Vod>> list = null;
    Column column = new Column();

    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");

        //背景竖条
        String outString = getString(request,"bp");
        print(out, "slit position:" + outString);
        String[] parameters = outString.split("\\,");
        slitHeight = parameters.length > 0 && isNumeric(parameters[0]) ? Integer.parseInt(parameters[0]) : 3;
        slitLeft = parameters.length > 1 && isNumeric(parameters[1]) ? Integer.parseInt(parameters[1]) : 500;
        slitTop = parameters.length > 2 && isNumeric(parameters[2]) ? Integer.parseInt(parameters[2]) : 500;
        slitColor = parameters.length > 3 && StringUtils.isNotEmpty(parameters[3]) ? "#" + parameters[3] : "transparent";

        //视频框
        outString = getString(request,"ps");
        print(out, "video position:" + outString);
        parameters = outString.split("\\,");
        videoWidth = parameters.length > 0 && isNumeric(parameters[0]) ? Integer.parseInt(parameters[0]) : 493;
        videoHeight = parameters.length > 1 && isNumeric(parameters[1]) ? Integer.parseInt(parameters[1]) : 310;
        videoLeft = parameters.length > 2 && isNumeric(parameters[2]) ? Integer.parseInt(parameters[2]) : 712;
        videoTop = parameters.length > 3 && isNumeric(parameters[3]) ? Integer.parseInt(parameters[3]) : 206;

        rows = getInteger(request, "pg") == 0 ? 8 : getInteger(request, "pg");
        loop = getInteger(request, "loop");

        outString = getString(request,"item");
        print(out, "item attributes:" + outString);
        parameters = outString.split("\\,");
        containerWidth = parameters.length > 0 && isNumeric(parameters[0]) ? Integer.parseInt(parameters[0]) : 3;
        containerHeight = parameters.length > 1 && isNumeric(parameters[1]) ? Integer.parseInt(parameters[1]) : 500;
        containerLeft = parameters.length > 2 && isNumeric(parameters[2]) ? Integer.parseInt(parameters[2]) : 500;
        containerTop = parameters.length > 3 && isNumeric(parameters[3]) ? Integer.parseInt(parameters[3]) : 500;
        itemWidth = parameters.length > 4 && isNumeric(parameters[4]) ? Integer.parseInt(parameters[4]) : 3;
        itemHeight = parameters.length > 5 && isNumeric(parameters[5]) ? Integer.parseInt(parameters[5]) : 500;
        itemBackgroundColor = parameters.length > 6 && StringUtils.isNotEmpty(parameters[6]) ? "#" + parameters[6] : "transparent";
        itemColor = parameters.length > 7 && StringUtils.isNotEmpty(parameters[7]) ? "#" + parameters[7] : "transparent";
        fontSize = parameters.length > 8 && isNumeric(parameters[8]) ? Integer.parseInt(parameters[8]) : 22;

        focusBackgroundColor = getString(request,"fcbg");
        focusBackgroundColor =  StringUtils.isNotEmpty(focusBackgroundColor) ? "#" + focusBackgroundColor : "transparent";

        outString = getString(request,"fcbr");
        parameters = outString.split("\\,");
        print(out, "focused border attributes:" + outString + ", length : " + parameters.length);
        focusBorderWidth = parameters.length > 0 && isNumeric(parameters[0]) ? Integer.parseInt(parameters[0]) : 1;
        focusBorderColor = parameters.length > 1 && StringUtils.isNotEmpty(parameters[1]) ? "#" + parameters[1] : "transparent";

        focusColor = getString(request,"fc");
        focusColor =  StringUtils.isNotEmpty(focusColor) ? "#" + focusColor : "transparent";

        split = getInteger(request, "split");
        print(out, "split attributes:" + split );

        outString = getString(request,"mk");
        parameters = outString.split("\\,");
        //[与右边条目之间的距离],[宽度]:[颜色]:[对齐方式]0，左对齐，1：右对齐，2：居中对齐
        print(out, "focused border attributes:" + outString + ", length : " + parameters.length);
        markMarginRight = parameters.length > 0 && isNumeric(parameters[0]) ? Integer.parseInt(parameters[0]) : 0;
        markWidth = parameters.length > 1 && isNumeric(parameters[1]) ? Integer.parseInt(parameters[1]) : 0;
        markColor = parameters.length > 2 && StringUtils.isNotEmpty(parameters[2]) ? "#" + parameters[2] : "transparent";
        markAlign = parameters.length > 3 && StringUtils.isNotEmpty(parameters[3]) ? parameters[3] : "";
        markAlign = markAlign.equalsIgnoreCase("0")?"left":markAlign.equalsIgnoreCase("1")?"right":"center";

        // -50 , 播放图标宽度， -16， padding 宽度
        popItemMaxCharLength = (int)Math.floor( ( itemWidth - 50 - 16 ) / fontSize / 1.15 ) * 2;

        isKorean = StringUtils.isEmpty(request.getParameter("isKorean"))? isKorean : request.getParameter("isKorean");

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

        print(out, "before get focused:" + outString);
        // 返回时获取焦点信息数据
        String[] focus = null;
        value = request.getParameter("currFoucs");
        focus = StringUtils.isEmpty( value ) ? turnPage.getPreFoucs() : value.split("\\,");

        if(null != focus ){
            if( focus.length > 0 && focus[0] != null ) area = Integer.parseInt(focus[0]);
            if( focus.length > 1 && focus[1] != null ) focused = Integer.parseInt(focus[1]);
            if( focus.length > 2 && focus[2] != null ) played = Integer.parseInt(focus[2]);
            if( focus.length > 3 && focus[3] != null ) playIndex = Integer.parseInt(focus[3]);
            if( focus.length > 4 && focus[4] != null ) playTime = Integer.parseInt(focus[4]);
        }

        print(out, "after get focused");
        backUrl = request.getParameter("backURL");
        if( StringUtils.isEmpty( backUrl ) )
            backUrl = turnPage.go(-1);

        MetaData metaHelper = new MetaData(request);
        column = getDetailInfo( metaHelper, types[0], column );

        print(out, "after get focused");
        bodyTop = Utils.pictureUrl("images/bg-2017-12-29-top.png", column.getPosters(), "7",0 , request);
        bodyLeft = Utils.pictureUrl("images/bg-2017-12-29-left.png", column.getPosters(), "7",1 , request);
        bodyRight = Utils.pictureUrl("images/bg-2017-12-29-right.png", column.getPosters(), "7",2 , request);
        bodyBottom = Utils.pictureUrl("images/bg-2017-12-29-bottom.png", column.getPosters(), "7",3 , request);


        list = new ArrayList<List<Vod>>();
        int i = 0;
        for( String type : types ){
            List<Vod> ls = getVodList( metaHelper, type,position[i], position[i+1]);
            list.add( ls );
            i+=2;
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat;background-position: 0px 0px;}

        .bodyTop {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height: <%=videoTop%>px;<%= StringUtils.isNotEmpty(bodyTop) ? "background:transparent url('" + bodyTop + "') no-repeat left top;" : ""%>}
        .bodyLeft {position: absolute;z-index:0;overflow: hidden; left:0px;top:<%=videoTop%>px;width:<%= videoLeft %>px;height: <%=videoHeight%>px;<%= StringUtils.isNotEmpty(bodyLeft) ? "background:transparent url('" + bodyLeft + "') no-repeat left top;" : ""%>}
        .bodyRight {position: absolute;z-index:0;overflow: hidden; left:<%=videoWidth + videoLeft%>px;top:<%=videoTop%>px;width:<%= 1280-videoLeft-videoWidth %>px;height: <%=videoHeight%>px;<%= StringUtils.isNotEmpty(bodyRight) ? "background:transparent url('" + bodyRight + "') no-repeat left top;" : ""%>}
        .bodyBottom {position: absolute;z-index:0;overflow: hidden; left:0px;top:<%=videoTop + videoHeight%>px;width:1280px;height: <%=720-videoTop-videoHeight%>px;<%= StringUtils.isNotEmpty(bodyBottom) ? "background:transparent url('" + bodyBottom + "') no-repeat left top;" : ""%>}

        .slit { position:absolute;z-index:1; overflow: hidden;width:<%= slitWidth%>px;height:<%=slitHeight%>px;left:<%=slitLeft%>px;top:<%=slitTop%>px;background-color:<%=slitColor%>;}

        .flowed {position:absolute;z-index:5;left:<%=containerLeft%>px;top:<%=containerTop%>px;width:<%=containerWidth%>px;height:<%=containerHeight%>px;}

        .itemContainer{width:<%=containerWidth%>px;height:<%=containerHeight / rows%>px; float:left;position: relative;overflow: hidden;}
        .itemMarket{position:absolute;width:<%=markWidth%>px;height:<%=itemHeight%>px;left:0px;top:0px;text-align: <%=markAlign%>;font-size: <%=fontSize%>;line-height:<%=itemHeight - 5%>px;overflow:hidden;color: <%=markColor%>; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .itemIcon,.itemIconFocus {position:absolute;width:<%=markMarginRight%>px;left:<%=markWidth%>px;top:0px;height:<%=itemHeight%>px;}

        .itemIcon{background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat -<%=300 - markMarginRight / 2 + 2 %>px -100px;}
        .itemIconFocus{background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat -<%=100 - markMarginRight / 2 + 2 %>px -100px;}

        .item{position:absolute;width:<%=itemWidth%>px;height:<%=itemHeight%>px;left:<%=markMarginRight + markWidth%>px;top:0px;text-align: left;font-size: <%=fontSize%>;line-height:<%=itemHeight - focusBorderWidth * 3 + 1%>px;color: <%=markColor%>; }
        .itemPlayFocusedText,.itemPlayText,.itemFocusText,.itemText{padding:0px 8px;float: left;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .itemFocusText,.itemText{width:<%= itemWidth - 50 - 16 %>px;}
        .itemText,.itemPlayText {border:solid <%=focusBorderWidth%>px transparent;color:<%=itemColor%>;background-color:<%=itemBackgroundColor%>}
        .itemPlayFocusedText,.itemPlayText{width:<%= itemWidth - 50 - 16 - 17 %>px;}
        .itemPlayFocusedText,.itemFocusText{border:solid <%=focusBorderWidth%>px <%=focusBorderColor%>;background-color:<%= focusBackgroundColor%>;color:<%= focusColor%>}
        .marquee {line-height: <%=itemHeight - focusBorderWidth * 5 - 1%>px; height:<%=itemHeight - focusBorderWidth * 5 - 1%>px;}
        .itemPlayed{margin:0px 0px 0px 10px;float: left;height:<%=itemHeight%>px;width:50px;background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat -300px -300px;}

        .arrowDown {position:absolute;left:352px;top:662px;width:30px;height:23px;background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat -100px -300px;}

        .after {}
        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/
    </style>
    <script language="javascript" type="text/javascript">
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
        var blocked = blocked ? blocked : <%= area %>;
        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //弹出对话框中最大列表数量
        var popMaxItemsLength = 6;

        //可获得焦点的区域个数
        var focusable = focusable ? focusable : [
            <%
            value = "";
            //final String[][] actions = {"[0,0,0,3,0,0,0,1]|[0,1,0,3,0,0,0,2]|[0,2,0,5,0,1,0,2]|[0,1,0,6,0,3,0,4]|[0,1,0,7,0,3,0,5]|[0,2,0,8,0,4,0,5]|[0,3,0,6,0,6,0,7]|[0,4,0,7,0,6,0,8]|[0,5,2,0,0,7,0,8]".split("\\|")};
            Pattern pattern = Pattern.compile("(.*)（(.*)）",Pattern.CASE_INSENSITIVE);
            if( list != null && list.size() > 0){
                for(int i = 0; i < list.size() ; i++){
                    value += "{focus:0,played:" + played + ",playIndex:"+ playIndex + ",playTime:" + playTime +",typeId:'" + types[i] + "',items:[";
                    List<Vod> vodList = list.get(i);
                    for( int j = 0; j < vodList.size() ; j++ ){
                        Vod vod = vodList.get(j);
                        String name = vod.getName();
                        String mark = "";
                        if( split != 0 ) {
                            Matcher matcher = pattern.matcher( name );
                            if( matcher.find() ) {
                                name = matcher.group(1);
                                mark = matcher.group(2);
                            }
                        }
                        String str = "{ mid:'" + vod.getId() + "'," +
                                   (split != 0 ? ("mark:\"" + mark + "\",") : "") +
                                   "text:\"" + name + "\"," +
                                 "length:" + StringUtil.length(name) + "," +
                              "shortText:\"" + StringUtil.limitStringLength(name, popItemMaxCharLength) + "\"" + "," +
                              (loop != 0 ? ("picture:'" + Utils.pictureUrl("images/default_preview_lb.png", vod.getPosters(), "1", request)+ "'" + ",") : "") +
                                  "playType:" + vod.getIsSitcom() ;
                            str += "}" ;
                            str += ( j + 1 < vodList.size()  ? "," : "");
                        value += str;
                    }
                    value += "]}";
                }
                out.write(value);
            }
            %>
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var isKorean = <%= isKorean%>;                   //是否为韩剧
        var columns = 1; rows = <%= rows %>;              //定义行列，　几行几列
        var pageCount = columns * rows;
        function getUrlParameters(str, link) {
            var rs = new RegExp("(\\?|&)?" + str + "=([^&]*?)(&|$)", "gi").exec(link);
            if (typeof rs === 'undefined' || rs === null ) return "";
            return rs[2];
        }
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //上:11,下:-11,左-1,右1
                //如果焦点在投票上,按上下左右键时
                if( index == 11 && focus < columns || //按上光标键时
                    index == -1 && focus % columns == 0 || //按左光标键时
                    index == 1 && focus % columns == columns - 1 || //按右光标键时
                    index == -11 && ( ( columns == 1 && focus + 1 >= focusable[blocked].items.length ) || ( columns > 1 && ( Math.floor( focus / columns ) == Math.floor( focusable[blocked].items.length / columns ) )) ) //按下光标键时   && focus + columns != focusable[blocked].items.length (最后一个未对齐时)
                ) return;
                //TODO:当光标在首页、返回按钮上时，可同时按上，左键返回到列目中时，需要重写光标移动代码
                if( index == 1 || index == -1 ) focus += index;
                else if( index == 11 ) focus -= columns;
                else if( index == -11 ) focus += columns;
                if( focus >= focusable[blocked].items.length ) { focus = focusable[blocked].items.length - 1 ; }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                focusable[blocked].focus = focus = previous = index;
            }

            $("arrowDown").style.visibility = focus >= pageCount ? "hidden" : "visible";
            flowedShow(0);
        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            var played = focusable[index].playIndex;
            //每页显示数量
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='itemContainer'>";

                <% if( split != 0) { /*左侧无文字显示*/%>
                html += "<div class='itemMarket'>" + item.mark + "</div>";
                <% } %>
                if( i === played && i === focus ) {
                    html += "<div class='itemIconFocus'></div>";
                    html += "<div class='item'>";
                    html += "<div class='itemPlayFocusedText'>" + ( item.text != item.shortText ? "<marquee>" + item.text + "</marquee>" : item.text ) + "</div><div class='itemPlayed'></div>";
                } else if(i === played ) {
                    html += "<div class='itemIcon'></div>";
                    html += "<div class='item'>";
                    html += "<div class='itemPlayText'>" + item.shortText + "</div><div class='itemPlayed'></div>";
                } else if(i === focus ) {
                    html += "<div class='itemIconFocus'></div>";
                    html += "<div class='item'>";
                    html += "<div class='itemFocusText'>" + ( item.text != item.shortText ? "<marquee>" + item.text + "</marquee>" : item.text ) + "</div>";
                } else {
                    html += "<div class='itemIcon'></div>";
                    html += "<div class='item'>";
                    html += "<div class='itemText'>" + item.shortText + "</div>";
                }
                html += "</div></div>";
            }
            $("flowed").innerHTML = html;
        }

        var loopAjaxPlay = function(){
            try{
                media.video.setPosition(<%=videoLeft%>,<%=videoTop%>,<%=videoWidth%>,<%=videoHeight%>);
                var vodid = focusable[0].items[focusable[0].playIndex].mid;
                var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" +vodid + "&contentType=0&business=1&baseFlag=0";
                var XHR = new XMLHttpRequest();
                XHR.onreadystatechange = function (){
                    if(XHR.readyState == 4){
                        if(XHR.status == 200){
                            var json = eval("(" + XHR.responseText + ")");
                            var ret = json.playUrl.split("^");
                            media.AV.open(ret[4],"VOD");
                        }
                    }
                }
                XHR.open("GET", rtspUrl, true);
                XHR.send(null);
            } catch (e){ }
        }
        function init(){
            String.prototype.trim=function(){return this.replace(/(^\s*)|(\s*$)/g, "");}
            String.prototype.ltrim=function(){return this.replace(/(^\s*)/g,"");}
            String.prototype.rtrim=function(){return this.replace(/(\s*$)/g,"");}
            String.prototype.endWith=function(str){
                if(str==null||str==""||this.length==0||str.length>this.length)
                    return false;
                return this.substring(this.length-str.length) === str;
            }
            String.prototype.startWith=function(str){
                if(str==null||str==""||this.length==0||str.length>this.length)
                    return false;
                return  this.substr(0,str.length) === str;
            }
            String.prototype.isEmpty = function(){  return (/^\s*$/.test(this)); };
            Array.prototype.clear = function(){ this.length=0; }
            Array.prototype.insertAt = function(index, o ){ this.splice(index, 0, o ); }
            Array.prototype.removeAt = function(index){ this.splice(index,1); }
            Array.prototype.remove = function(o){ var index = this.indexOf( o ); if ( index >= 0) this.removeAt(index); }

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
                        case 38: focused(11, false);break;      //上光标键
                        case 40:focused(-11, false);break;      //下光标键
                        case 37:focused(-1, false);break;       //左光标键
                        case 39:focused(1, false);break;        //右光标键
                        case 13:doEnter(); break;              //选择回车键
                        case 46:goBack(true);break;
                        case "KEY_EXIT":
                        case "KEY_MENU":top.window.location.href = iPanel.eventFrame.portalUrl; return 0;break;
                    }
                }
            }
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "," + focusable[blocked].playIndex +",0&url=";
            };
            $.buildUserInterface = function(option){

                var html = "<div class='bodyTop'></div>";
                html += "<div class='bodyLeft'></div>";
                html += "<div class='bodyRight'></div>";
                html += "<div class='bodyBottom'></div>";

                html += "<div class='slit'></div>";

                html += "<div class='arrowDown' id='arrowDown'></div>";
                html += "<div class='flowed' id='flowed'></div>";

                if(typeof option.external.before == 'string') html += option.external.before;
                html += "<div id='mask'></div>";
                if(typeof option.external.after == 'string' ) html += option.external.after;
                document.body.innerHTML = html;
                loopAjaxPlay();
            }
            $.buildUserInterface({flowed:[0],external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if(typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 1 ) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            var item =  focusable[blocked].items[focusable[blocked].focus];
            if(typeof item == 'undefined' || item.playType == 'undefined') return;
            var typeId = focusable[blocked].typeId;
            switch(item.playType){
                case -1:
                    focusable[item.blocked].backed = blocked;
                    blocked = item.blocked;
                    focused(focusable[blocked].focus, true);
                    break;
                case -2:
                    break;
                case -3:
                    var url = '';
                    if( ! item.link.startWith('http') ){
                        url += $.current() + item.link;
                    } else if( item.link.indexOf("wasu.cn/") > 0 ) {
                        //curr_url = "ui://portal1.htm?" + curr_url;
                        url = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/Category.jsp?url=" + item.link;
                    } else {
                        url = item.link;
                        url += url.indexOf("?") > 0 ? '&' : '?';
                        url += 'backURL=';
                        var requestUrl = "<%= request.getRequestURL().toString() %>";
                        var queryStr = "<%= request.getQueryString() %>";
                        if( queryStr == 'null' ) queryStr = '';
                        var focusStr = blocked + "," + focusable[blocked].focus;
                        if( ! queryStr.isEmpty() ) {
                            requestUrl += "?" + ( queryStr.indexOf( 'currFoucs=' ) < 0 ? ( queryStr + "&currFoucs=" + focusStr ) : queryStr.replace('currFoucs=' + getUrlParameters("currFoucs", queryStr), 'currFoucs=' + focusStr) );
                        } else {
                            requestUrl += '?currFoucs=' + focusStr;
                        }
                        url += encodeURIComponent(requestUrl);
                    }
                    top.window.location.href = url;
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'vod/tv_d'/*'western/eu_tvD'*/) + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
                    break;
                case 0://去掉基本包检验 baseFlag=0
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
                    break;
            }
        }
        function eventHandler(eventObj, __type){
            switch(eventObj.code){
                case "KEY_UP":focused(11, false);break;
                case "KEY_DOWN":focused(-11, false);break;
                case "KEY_LEFT":focused(-1, false);break;
                case "KEY_RIGHT":focused(1, false);break;
                case "KEY_SELECT":doEnter();break;
                case "KEY_NUMERIC":break;
                case "KEY_BACK": goBack(true);break;
                case "KEY_EXIT":
                case "KEY_MENU":location.href = iPanel.eventFrame.portalUrl;return 0;break;
                case "VOD_PREPAREPLAY_SUCCESS":
                    media.AV.play();
                    break;
                case "EIS_VOD_PROGRAM_END":
                    focusable[0].playIndex ++;
                    if(focusable[0].playIndex >= focusable[0].items.length) focusable[0].playIndex = 0;
                    loopAjaxPlay();
                    break;
            }
            return 	eventObj.args.type;
        }
        function exit() { try {DVB.stopAV(0);media.AV.close();} catch (e) {}}
        window.onload = function(){setTimeout("init()",100);}
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();"></body>
</html>