<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {typeId};
    final int[] position = {99,0};
    //TODO:ÿ����Ҫ�޸�
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 90;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    List<List<Vod>> list = null;
    Column column = new Column();

    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");
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

        // ����ʱ��ȡ������Ϣ����
        String[] focus = null;
        value = request.getParameter("currFoucs");
        focus = StringUtils.isEmpty( value ) ? turnPage.getPreFoucs() : value.split("\\,");

        if(null != focus ){
            if( focus.length > 0 && focus[0] != null )
                area = Integer.parseInt(focus[0]);
            if( focus.length > 1 && focus[1] != null )
                focused = Integer.parseInt(focus[1]);
        }

        backUrl = request.getParameter("backURL");
        if( StringUtils.isEmpty( backUrl ) )
            backUrl = turnPage.go(-1);

        MetaData metaHelper = new MetaData(request);
        column = getDetailInfo( metaHelper, types[0], column );

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
        .mask {position:absolute;background:transparent url('images/mask-2017-09-22.png') no-repeat;background-position: 0px 0px;}
        .arrow {width:37px;height:16px;left:619px;}
        .arrowUpN,.arrowUpF {top:203px;}
        .arrowUpN {background-position:-300px -150px;}
        .arrowUpF {background-position:-360px -150px;}
        .arrowDownN,.arrowDownF {top:666px;}
        .arrowDownN {background-position:-300px -180px;}
        .arrowDownF {background-position:-360px -180px;}

        .flowed {width:1044px;height:420px;position:absolute;left:103px;top:231px;overflow: hidden;}
        .item,.itemSel{width:1044px;height:60px;overflow: hidden;}
        .item {float:left;}
        .itemContainer{width:1004px;line-height:48px;font-size:20px;text-align:left;color:white;height:48px;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;margin:0px 20px 0px 20px;}
        .marquee{width:1004px;line-height: 48px;}
        .itemSel{height:58px;background-color: #f89a06;}

        .page {position:absolute;width:45px;left:1209px;height: 18px;text-align: center;font-size: 18px;color:white;line-height: 18px;overflow: hidden;}
        .pageNum {top:269px;}
        .pageCut {top:301px;}
    </style>
    <script language="javascript" type="text/javascript">
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
        var blocked = blocked ? blocked : <%= area %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //�����Ի���������б�����
        var popMaxItemsLength = 6;

        //�ɻ�ý�����������
        var focusable = focusable ? focusable : [
            <%
            value = "";
            if( list != null && list.size() > 0){
                for(int i = 0; i < list.size() ; i++){
                    value += "{focus:0,typeId:'" + types[i] + "',items:[";
                    List<Vod> vodList = list.get(i);
                    for( int j = 0; j < vodList.size() ; j++ ){
                        Vod vod = vodList.get(j);
                        String str = "{ mid:'" + vod.getId() + "'," +
                                   "text:\"" + vod.getName() + "\"," +
                                 "length:" + StringUtil.length(vod.getName()) + "," +
                              "shortText:\"" + StringUtil.limitStringLength(vod.getName(), popItemMaxCharLength) + "\"" + "," +
                                  "playType:" + vod.getIsSitcom() ;
                            str += "}" ;
                            str += ( j + 1 < vodList.size()  ? "," : "");
                        value += str;
                    }
                    value += "]},";
                }
                out.write(value);
            }
            %>
            { focus:0, vote:true, items : [
                {name:'input'},
                {name:'ȷ��',style:'btnSure'},
                {name:'ȡ��',style:'btnCancel'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //�����������ݵ�
        var isKorean = <%= isKorean%>;                   //�Ƿ�Ϊ����
        var columns = 1; rows = 7;              //�������У������м���
        var pageCount = columns * rows;
        function focused(index,initilized){
            if( focusable.length <= 1 ) return;
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //��:11,��:-11,��-1,��1
                //���������ͶƱ��,���������Ҽ�ʱ
                if( index == 11 && focus < columns || //���Ϲ���ʱ
                    index == -1 && focus % columns == 0 || //�������ʱ
                    index == 1 && focus % columns == columns - 1 || //���ҹ���ʱ
                    index == -11 && ( ( columns == 1 && focus + 1 >= focusable[blocked].items.length ) || ( columns > 1 && ( Math.floor( focus / columns ) == Math.floor( focusable[blocked].items.length / columns ) )) ) //���¹���ʱ   && focus + columns != focusable[blocked].items.length (���һ��δ����ʱ)
                ) return;
                //TODO:���������ҳ�����ذ�ť��ʱ����ͬʱ���ϣ�������ص���Ŀ��ʱ����Ҫ��д����ƶ�����
                if( index == 1 || index == -1 ) focus += index;
                else if( index == 11 ) focus -= columns;
                else if( index == -11 ) focus += columns;
                if( focus >= focusable[blocked].items.length ) { focus = focusable[blocked].items.length - 1 ; }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                focusable[blocked].focus = focus = previous = index;
            }
            flowedShow(0);
        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            //ÿҳ��ʾ����
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item">';
                if(blocked == index && focus == i){
                    html += '<div class="itemSel"><div class="itemContainer">' ;
                    if(item.shortText != item.text){
                        html += "<marquee scrolldelay='75' class='marquee'>" + item.text + "</marquee>";
                    } else
                        html += item.text;
                    html += "</div></div>"
                } else {
                    html += '<div class="itemContainer">' + item.text + "</div>";
                }
                html += '</div>';
            }
            $("flowed").innerHTML = html;

            if( flowCursorIndex + pageCount < items.length ){
                $( "arrowDown" ).style.visibility = 'visible';
                $( "arrowDown" ).className = 'mask arrow arrowDownF';
            } else
                $( "arrowDown" ).style.visibility = 'hidden';

            if( flowCursorIndex >= pageCount){
                $( "arrowUp" ).style.visibility = 'visible';
                $( "arrowUp" ).className = 'mask arrow arrowUpF';
            } else
                $( "arrowUp" ).style.visibility = 'hidden';

            if( items.length == 0 ) {
                $("pageNum").innerHTML = $("pageCount").innerHTML = '0';
            } else {
                $("pageNum").innerHTML = Math.ceil( (focus + 1.0) / pageCount);
                $("pageCount").innerHTML = Math.ceil(items.length * 1.0 / pageCount);
            }

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
                        case 38: focused(11, false);break;      //�Ϲ���
                        case 40:focused(-11, false);break;      //�¹���
                        case 37:focused(-1, false);break;       //�����
                        case 39:focused(1, false);break;        //�ҹ���
                        case 13:doEnter(); break;              //ѡ��س���
                        case 46:goBack(true);break;
                        case "KEY_EXIT":
                        case "KEY_MENU":top.window.location.href = iPanel.eventFrame.portalUrl; return 0;break;
                    }
                }
            }
            if( typeof $.ajax === 'undefined') {
                $.ajax = function(url,callback,options){
                    if( typeof  url === 'undefined' ) return;
                    if(typeof  options === 'undefined')options = {};

                    if(typeof options.method === 'undefined' ) options.method = "GET";
                    if( typeof options.async === 'undefined' ) options.async = true;
                    var request = new XMLHttpRequest();
                    request.onreadystatechange = function (){
                        if(request.readyState ===4){
                            if(request.status ===200 && typeof callback === 'function' ){
                                var responseText = request.responseText;
                                try {
                                    callback( (new Function("return " + responseText))() );
                                } catch ( e ) {
                                    callback( eval("(" + request.responseText + ")" ) );
                                }
                            }
                            else{request.abort();}
                        }
                    }
                    request.open(options.method, url, options.async);
                    request.send(null);
                };
            }
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                if(typeof option.external.before == 'string') html += option.external.before;
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='flowed'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                if(typeof option.external.after == 'string' ) html += option.external.after;
                html += "<div id='arrowUp'></div><div id='arrowDown'></div><div id='pageNum' class='page pageNum'></div><div id='pageCount' class='page pageCut'></div>";
                document.body.innerHTML = html;
            }
            $.bookmark = function(vodid){
                var marks = iPanel.ioctlRead("bookmark");
                if( marks != null ){
                    var overs = marks.split(";");
                    for(var i = 0; i < overs.length; i++){
                        var temp = overs[i].split(",");
                        if( temp[1] == "undefined" || temp[1] == undefined) return null;
                        if( temp[1] == 'vodid' ) return temp[4]; //���ϵ�ʱ��ȡ���������ֶβ�Ҫ
                    }
                }
                return null;
            }
            $.buildUserInterface({flowed:[0],vote:undefined,video:undefined,position:undefined,external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            top.window.location.href = typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
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
                case 0://ȥ������������ baseFlag=0
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
                case "VOD_PREPAREPLAY_SUCCESS":media.AV.play();break;
                case "EIS_VOD_PROGRAM_END":break;
            }
            return 	eventObj.args.type;
        }
        function getUrlParameters(str, link) {
            var rs = new RegExp("(\\?|&)?" + str + "=([^&]*?)(&|$)", "gi").exec(link);
            if (typeof rs === 'undefined' || rs === null ) return "";
            return rs[2];
        }
        function exit() { try {DVB.stopAV(0);media.AV.close();} catch (e) {}}
        window.onload = function(){setTimeout("init()",100);}
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2017-09-22-List.jpg') no-repeat;" onUnload="exit();"></body>
</html>