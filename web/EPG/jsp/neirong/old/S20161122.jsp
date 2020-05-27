<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {"10000100000000090000000000106881"};
    final int[] position = {15,0};
    //TODO:ÿ����Ҫ�޸�
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 32;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    List<Column> list = null;

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
        list = getTypeList( metaHelper, types[0],position[0], position[1]);
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>��ѧһ��</title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2016-11-22.png') no-repeat;background-position: 0px 0px;height:26px;}

        .mask1 {width:144px;left:157px;top:284px;background-position:0px 0px;}
        .mask2 {width:165px;left:352px;top:284px;background-position:0px -30px;}
        .mask3 {width:145px;left:556px;top:284px;background-position:0px -60px;}
        .mask4 {width:145px;left:755px;top:284px;background-position:0px -90px;}
        .mask5 {width:145px;left:956px;top:284px;background-position:0px -120px;}
        .mask6 {width:146px;left:157px;top:437px;background-position:0px -150px;}
        .mask7 {width:147px;left:356px;top:437px;background-position:0px -180px;}
        .mask8 {width:145px;left:556px;top:439px;background-position:0px -210px;}
        .mask9 {width:145px;left:755px;top:439px;background-position:0px -240px;}
        .mask10 {width:145px;left:956px;top:438px;background-position:0px -270px;}
        .mask11 {width:147px;left:157px;top:597px;background-position:0px -300px;}
        .mask12 {width:144px;left:356px;top:597px;background-position:0px -330px;}
        .mask13 {width:144px;left:556px;top:597px;background-position:0px -360px;}
        .mask14 {width:145px;left:755px;top:597px;background-position:0px -390px;}
        .mask15 {width:145px;left:956px;top:597px;background-position:0px -420px;}

        .arrow {position:absolute;width:24px;height:14px;left:615px;}
        .arrowUp {top:45px;background-position: -250px -120px;}
        .arrowDown {top:660px;background-position: -250px -150px;}
        .goTop{width:35px;height:92px;left:903px;top:549px;position:absolute;background-position: -200px -120px;}
        .page {width: 35px; color: white; font-size: 18px; height: 20px;  line-height: 20px; position: absolute; left: 903px; text-align: center; top: 125px;}
        .pageNum{top:125px;}
        .pageCount{top:165px;}

        .flowed {position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow:hidden;background: transparent url('images/focusBg-2016-11-22.png') no-repeat 0px 0px;}
        .container {width:527px;height:579px;left:357px;top:68px;position:absolute;}
        .item,.focusItem{width:527px;height:58px;float: left;padding: 0px 0px 0px 70px; line-height:50px;font-size:28px; overflow: hidden;}
        .item {color:white;background:transparent url('images/mask-2016-11-22.png') no-repeat -200px -58px;}
        .focusItem {color:black;background:transparent url('images/mask-2016-11-22.png') no-repeat -200px 0px;}
        .focusItem marquee {width:437px;line-height:50px;}
        .after {}

        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat fixed 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"����";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -350px;}

        .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat; top:636px;left:1066px; width:161px;height:41px; background-position: 0px 0px;}
        .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat; top:636px;left:1066px; width:161px; height:41px; background-position: 0px -42px;}
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
            value = "";String extern = "";
            if( list != null && list.size() > 0){
                value += "{focus:0,items:[";
                for(int i = 0; i < list.size() ; i++){
                    Column column = list.get(i);
                    String str = "{ mid:'" + column.getId() + "'," +
                                "name:'" + column.getName() + "'," +
                               "style:'mask mask" + (i + 1) + "'";
                        str += "}" ;
                        str += ( i + 1 < list.size()  ? "," : "");
                    value += str;
                    extern += "{focus:0,items:[]},";
                }
                value += "]},";
                out.write(value + extern);
            }
            %>
            { focus:0, vote:true, items : [
                {name:'input'},
                {name:'ȷ��',style:'btnSure'},
                {name:'ȡ��',style:'btnCancel'}
            ]},
            { focus:0, items : [
                {name:'��ҳ',style:'btnHome'},
                {name:'����',style:'btnReturn'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //�����������ݵ�
        var isKorean = <%= isKorean%>;                   //�Ƿ�Ϊ����
        var columns = 5; rows = 3;              //�������У������м���
        var pageCount = columns * rows;
        var arrows = [1,0];                     //�����ƶ�����ҳ���ذ�ť�Ĺ������£��ҡ�

        var popuped = false;
        if( typeof blocked !== 'undefined' && ( blocked >= 1 && blocked <= focusable[0].items.length ) ) {
            popuped = true;
            focusable[0].focus = blocked - 1;
        }
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //��:11,��:-11,��-1,��1
                if(
                    //���������ͶƱ�ķ��أ������½ǵķ����ϣ������ڸ�������ʱ,��갴�Ҽ�ֱ�ӷ���
                    blocked == focusable.length - 1 && (focus == 0 && arrows[1] == 0 && index == -1 || arrows[0] == 0 && index == 11 || index == -11 || focus == 1 && index == 1 ) ||
                    //���������ͶƱ��,���������Ҽ�ʱ
                    (blocked == focusable.length - 2 && ( $.vote.tooltiped || focus == 2 && index == 1 || focus <= 1 && index == -1 || focus == 0 && index == 11 || focus >= 1 && index == -11)) ||
                    //���߽����ڸ�������, ���������Ҽ�ʱ��
                    focusable[blocked].popuped && ( focus <= 0 && index == 11 || focus >= focusable[blocked].items.length - 1 && index == -11 || index == -1 || index == 1 )
                ) return;
                if( index == 1 && ( !$.vote.tooltiped && blocked == focusable.length - 2 && focus == 1 || blocked == focusable.length - 1 && focus == 0 ))
                    focus = focus + 1;
                else if( index == -1 && ( ! $.vote.tooltiped && blocked == focusable.length - 2 && focus == 2 || blocked == focusable.length - 1 && focus == 1))
                    focus = focus - 1;
                else if( focusable[blocked].popuped ) { focus += index > 0 ? -1 : 1;  }
                else if( blocked == focusable.length - 2 ) { if (focus == 0 && index == -11 ) {focus = 1; $("maskVote").style.visibility = "visible";} else if( focus >= 1 && index == 11) {focus = 0;$("maskVote").style.visibility = "hidden";} }
                else {
                     if( blocked == 0 && (
                         index == 11 && focus < columns || //���Ϲ���ʱ
                         index == -1 && focus % columns == 0 || //�������ʱ
                         index == 1 && arrows[1] == 0 && focus % columns == columns - 1 || //���ҹ���ʱ
                         index == -11 && (focus + columns >= focusable[blocked].items.length && arrows[0] == 0 || arrows[0] == 1 && focus + 1 != focusable[blocked].items.length && focus + columns + 1 > focusable[blocked].items.length ) //���¹���ʱ   && focus + columns != focusable[blocked].items.length (���һ��δ����ʱ)
                     ) || blocked >= 1 && blocked <= focusable[0].items.length && ( focus == 0 && index == 11 || typeof focusable[blocked].length != 'undefined' && focus + 1 >= focusable[blocked].length && index == -11 || index == -1 && focusable[blocked].view != 1 )  ) return;
                     //TODO:���������ҳ�����ذ�ť��ʱ����ͬʱ���ϣ�������ص���Ŀ��ʱ����Ҫ��д����ƶ�����
                     if( blocked == focusable.length - 1) { blocked = 0;focus = focusable[blocked].focus; }
                     else if( blocked == 0 ){
                         if( index == 1 || index == -1 ) focus += index;
                         else if( index == 11 ) focus -= columns;
                         else if( index == -11 ) focus += columns;
                         if( focus >= focusable[blocked].items.length ) { blocked = focusable.length - 1;focus = focusable[blocked].focus; }
                     } else if( blocked >= 1 && blocked <= focusable[0].items.length ) {
                         if( index == 11 || index == -11 ) {
                             focus += index > 0 ? -1 : 1;
                         } else {
                             focusable[blocked].view = focusable[blocked].view == 1 ? 0 : 1;
                         }
                     }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                if( blocked == focusable.length - 2 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];

            if(typeof item != 'undefined' && typeof item.style == 'string' )
                $( blocked == focusable.length - 2 ? "maskVote" : "mask").className = item.style;

            if( blocked >= 1 && blocked <= focusable[0].items.length ) flowedShow( blocked );

        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            $("flowed").className = 'flowed';
            $("flowed").style.visibility = 'visible';
            popuped = true;
            var focus = focusable[index].focus;if( focus < 0 ) focus = 0;
            var page = focusable[index].page; if( typeof page === 'undefined' ) page = 0;
            var typeId = focusable[0].items[focusable[0].focus].mid;
            var pageSize = 10;
            var items = focusable[index].items;
            var show = function( ) {
                items = focusable[index].items;
                page = focusable[index].page;
                var pageCount = Math.ceil( focusable[blocked].length * 1.0 / pageSize );
                var html = '';
                for( var i = 0 ; i < items.length ; i ++ ) {
                    var item = items[i];
                    html += "<div class='";
                    if(focusable[blocked].view != 1 && focus % pageSize === i ) {
                        html += "focusItem'>";
                        html += item.shortText != item.text ? "<marquee>" + item.text + "</marquee>" : item.text;
                    } else {
                        html += "item'>";
                        html += item.shortText;
                    }
                    html += "</div>";
                }
                $("flowedContainer").innerHTML = html;
                if( focus >= pageSize ) {
                    $("arrowUp").style.visibility = 'visible';
                    $("arrowUp").className = "mask arrow arrowUp";
                } else {
                    $("arrowUp").style.visibility = 'hidden';
                }
                if( pageCount > page  ) {
                    $("arrowDown").style.visibility = 'visible';
                    $("arrowDown").className = "mask arrow arrowDown";
                }
                $("pageNum").className = "page pageNum";
                $("pageNum").innerHTML = page + 1;
                $("pageCount").className = "page pageCount";
                $("pageCount").innerHTML = pageCount;
                if( focusable[blocked].view === 1) {
                    $("goTop").className = "mask goTop";
                    $("goTop").style.visibility = 'visible';
                } else {
                    $("goTop").style.visibility = 'hidden';
                }
            };
            if( Math.floor( focus / pageSize ) != page || items.length == 0 ) {
                focusable[index].page = page = Math.floor( focus / pageSize );
                $.ajax("edu/v1/interface.jsp?id=" + typeId + "&list=1&size=" + pageSize + "&max=<%= popItemMaxCharLength%>&tp=vod&page=" + page, function( rst ){
                    focusable[blocked].typeId = rst.typeId;
                    focusable[blocked].length = rst.length;
                    focusable[blocked].items = rst.items;
                    show();
                });
            } else  show();

        }
        function queryVoteResult(block,voteColumnId, callback ){
            $.ajax('http://192.168.49.56:8080/voteNew/external/queryVoteDatas.ipanel?columnA=' + voteColumnId + '&isable=1&startIndex=0&pageSize=50&total=true',function(result){
                var columns = result.result;
                for( var i = 0; i < columns.length; i++ ){
                    if( typeof focusable[block].items[i].voteId === 'undefined' ){
                        focusable[block].items[i].voteId = columns[i].ID;
                    }
                    focusable[block].items[i].total = columns[i].total;
                }
                if( typeof callback === 'function' ) callback();
            });
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
                        case 13: doEnter(); break;              //ѡ��س���
                        case 35:
                        case 46:goBack(true);break;
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
                                var result = (new Function("return " + responseText))();
                                callback( result );
                            }
                            else{request.abort();}
                        }
                    }
                    request.open(options.method, url, options.async);
                    request.send(null);
                };
            }
            $.popupShow = function(){
                var focus =  focusable[blocked].focus;
                var items = focusable[blocked].items;
                $("page").innerText = (Math.ceil((focus + 1) / popMaxItemsLength) + "/" + Math.ceil(items.length / popMaxItemsLength));
                if($("popuped").style.visibility == "hidden") $("popuped").style.visibility = "visible";
                var html = "";
                for(var i = 0; i < items.length ; i ++ ){
                    var vod = items[i];
                    html += "<div class='" + ( focus == i ? "maskItem" : "item") + "'>" +
                    (vod.length <= <%= popItemMaxCharLength %> || focus != i ? vod.shortText : ("<marquee class='marqueed'>" + vod.text + "</marquee>")) +
                    "</div>";
                }
                $("popupContent").innerHTML = html;
                $("popupContent").style.marginTop = "-" + (Math.floor(focus / popMaxItemsLength) * popMaxItemsLength * 51) + "px";
            }
            $.video = {};
            $.video.id = undefined;
            $.video.position = undefined;
            $.video.play = function(){
                try{
                    if(typeof $.video.id != "string" || $.video.id.isEmpty() || typeof iPanel === 'undefined') return;
                    var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + $.video.id + "&contentType=0&business=1&baseFlag=0&idType=FSN";
                    $.ajax(rtspUrl,function(result){
                        if( result.playFlag === "1"){
                            var rtsp = result.playUrl.split("^")[4];
                            media.AV.open(rtsp,"VOD");
                        }
                    });
                } catch (e){}
            }
            $.video.start = function(){
                try { if(typeof ($.video.id) === "string" && !$.video.id.isEmpty()) media.AV.play(); } catch (e) {}
            };
            $.vote = function (){
                if( $.vote.voted ) { if( !$.vote.tooltiped ) $.vote.tooltip($.vote.fail); else goBack();return; }
                //�����ʾ����ʾ��ȡ����ʾ�����ʾ��������ʾ�����
                if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 2 && focusable[focusable.length - 2].focus == focusable[focusable.length - 2].items.length - 1 ) { goBack(); return; }
                else {
                    if( $.vote.validate() ) {$.vote.tooltip(); return; }
                    //���� $.vote.current.message, $vote.current.id ����Ϊ��ʱ�Ž���ͶƱ
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = CA.card.serialNumber;
                    var url = "http://192.168.49.56:8080/voteNew/external/addVote.ipanel?icid=" + cardId + "&repeat=false&phone=" + $.vote.phone +"&classifyID=" + $.vote.current.id + "&content=" + encodeURIComponent($.vote.current.message);
                    $.ajax(url,function(result){
                        if(result.recode != '002' || result.result == false ){
                            $.vote.voted = result.result == false;
                            $.vote.tooltip($.vote.fail);
                        } else {
                            $.vote.voted = true;
                            $.vote.tooltip($.vote.success);
                        }
                    });
                }
            };
            $.vote.voted = false;
            $.vote.current = undefined;
            $.vote.status = undefined;
            $.vote.phone = undefined;
            $.vote.maskStyle = undefined;
            $.vote.tooltiped = false;
            $.vote.error = "�ֻ����벻��ȷ��";
            $.vote.fail = "���Ѳ����ͶƱ��";
            $.vote.success = "ͶƱ�ɹ���";
            $.vote.input = function (id ,num){
                if(typeof $.vote.status  != 'boolean' || !$.vote.status || $.vote.phone.length >=11)return;
                $.vote.phone += num;
                $(id).innerText = $.vote.phone;
            };
            $.vote.delete = function(id){
                if($.vote.phone.length==0)return;
                $.vote.phone = $.vote.phone.substr(0,$.vote.phone.length-1);
                $(id).innerText = $.vote.phone;
            };
            $.vote.validate = function(){
                var reg = /^1[3|4|5|8][0-9]\d{8}$/gi;
                return !reg.test($.vote.phone);
            };
            $.vote.show = function(){
                focusable[blocked].focus = 0;
                $.vote.phone = "";
                $.vote.tooltiped = false;
                $.vote.status = true;
                $("phoneNumber").innerHTML = "";
                if( typeof $.vote.maskStyle === 'undefined' && $("mask").style.visibility != 'hidden')
                {
                    $.vote.maskStyle = 'visible';
                    $("mask").style.visibility = "hidden";
                }
                $("votePop").style.visibility = "visible";
                $("votePop").style.backgroundPosition = "0px 0px";
            };
            $.vote.hidden = function(className){
                $.vote.status = false;
                $.vote.tooltiped = false;
                $.vote.current = undefined;
                if( typeof $.vote.maskStyle != 'undefined') {
                    $("mask").style.visibility = $.vote.maskStyle;
                    $.vote.maskStyle = undefined;
                }
                $("votePop").style.visibility = "hidden";
                $("maskVote").style.visibility = "hidden";
            };
            $.vote.tooltip = function(message){
                if( typeof  message == 'undefined' ) message = $.vote.error;
                $.vote.status = false;
                $.vote.tooltiped = true;
                $("phoneNumber").innerHTML = message;
                $("votePop").style.backgroundPosition = "0px -400px";
                $("votePop").style.visibility = "visible";
                $("maskVote").style.visibility = "hidden";
            };
            //������¼����绰����������˳�򼰽���
            $.vote.focus = {}
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                if(typeof option.external.before == 'string') html += option.external.before;
                html += "<div id='mask'></div>";
                html += "<div id='flowed'><div id='flowedContainer' class='container'></div><div id='arrowUp'></div><div id='arrowDown'></div><div id='goTop'></div><div id='pageNum' class='page pageNum'></div><div id='pageCount' class='page pageCount'></div></div>";
                if(typeof option.external.after == 'string' ) html += option.external.after;
                if(typeof option.popup != 'undefined'  ){
                    html += "<div class='popuped' id='popuped' style='visibility:hidden'><div class='container'  id='popupContainer'><div class='content' id='popupContent'></div></div><div class='page' id='page'>1/1</div></div>";
                    for(var i = 0; i< option.popup.length; i++) {
                        if( typeof focusable[option.popup[i].blocked].items[option.popup[i].item] == 'undefined' )
                            focusable[option.popup[i].blocked].items[option.popup[i].item] = {};
                        focusable[option.popup[i].blocked].items[option.popup[i].item].blocked = option.popup[i].target;
                        focusable[option.popup[i].blocked].items[option.popup[i].item].playType = -1;
                        if(typeof option.popup[i].style == 'string')  focusable[option.popup[i].blocked].items[option.popup[i].item].style = option.popup[i].style;
                        focusable[option.popup[i].target].popuped = true;
                        focusable[option.popup[i].target].backed = option.popup[i].blocked;
                        focusable[option.popup[i].target].previous = option.popup[i].item;
                    }
                }
                if( typeof option.vote != 'undefined' ){
                    html += "<div id='votePop' class='voteContainer' style='visibility:hidden'><div id='phoneNumber' class='phoneNumberInput' ></div></div>";
                    html += "<div id='maskVote'><span>&nbsp;</span></div>";
                    for(var i=0; i < option.vote.length; i++) {
                        if(typeof option.vote[i].item == 'undefined' )
                            focusable[option.vote[i].blocked].voteId = option.vote[i].id;
                        else if( typeof focusable[option.vote[i].blocked].items[option.vote[i].item] != 'undefined')
                            focusable[option.vote[i].blocked].items[option.vote[i].item].voteId = option.vote[i].id;
                    };
                }
                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; }
                document.body.innerHTML = html;
                if( typeof option.vote != 'undefined' ) $("maskVote").style.visibility = "hidden";
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
            $.buildUserInterface({flowed:undefined,popup:undefined,vote:undefined,video:undefined,position:undefined,external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            if( focusable.length == 2 ) {blocked = focusable.length - 1;}
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if( blocked >= 1 && blocked <= focusable[0].items.length ) {
                focusable[blocked].view = 0;
                blocked = 0;
                popuped = false;
                $("flowed").style.visibility = 'hidden';
                $("mask").className = focusable[0].items[focusable[0].focus].style;
                return;
            }
            if( blocked == focusable.length - 2) { if(focusable[focusable.length-2].focus == 0 && !$.vote.voted)  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
            if( typeof focusable[blocked].popuped == 'boolean' ) $("popuped").style.visibility = "hidden";
            if( typeof focusable[blocked].vote == 'boolean' || typeof focusable[blocked].popuped == 'boolean' ){
                if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                blocked = focusable[blocked].backed;
                focused(focusable[blocked].focus, true);
                return;
            }
            if(typeof iPanel != 'undefined' && blocked == focusable.length - 1 && focus == 0 && iPanel.eventFrame.systemId == 1 ) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = blocked == focusable.length - 1 && focusable[blocked].focus == 0 || EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            if( blocked == 0 ) {
                popuped = true;
                blocked = focusable[0].focus + 1;
                flowedShow( blocked );
                return;
            }
            if( focusable[blocked].view == 1 ) {
                focusable[blocked].focus = 0; focusable[blocked].view = 0;flowedShow(blocked); return;
            }
            //��ҳ������
            if( blocked == focusable.length - 1 ) { goBack(); return;}
            if( blocked == focusable.length - 2 ) { $.vote(); return; }
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
                    $.vote.current = {};
                    $.vote.current.id = typeof item.voteId == 'undefined' ? focusable[blocked].voteId : item.voteId;
                    $.vote.current.message = typeof item.text == 'undefined' ? item.name : item.text;
                    focusable[focusable.length - 2].backed = blocked;
                    blocked = focusable.length - 2;
                    focusable[blocked].focus = 0;
                    $.vote();
                    focused(0, true);
                    break;
                case -3:
                    var url = '';
                    if( ! item.link.startWith('http') ){
                        url += $.current() + item.link;
                    } else {
                        url = item.link;
                        url += url.indexOf("?") > 0 ? '&' : '?';
                        url += 'backURL=';
                        url += encodeURIComponent('<%= request.getRequestURL().toString() %>?currFoucs=' + blocked + "," + focusable[blocked].focus);
                    }
                    top.window.location.href = url;
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'vod/tv_d') + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
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
                case "KEY_NUMERIC":$.vote.input("phoneNumber", eventObj.args.value);break;
                case "KEY_BACK": goBack(true);break;
                case "KEY_EXIT":
                case "KEY_MENU":location.href = iPanel.eventFrame.portalUrl;return 0;break;
                case "VOD_PREPAREPLAY_SUCCESS":$.video.start();break;
                case "EIS_VOD_PROGRAM_END":$.video.play();break;
            }
            return 	eventObj.args.type;
        }
        function exit() { try {DVB.stopAV(0);media.AV.close();} catch (e) {}}
        window.onload = function(){setTimeout("init()",100);}
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2016-11-22.jpg') no-repeat;" onUnload="exit();"></body>
</html>