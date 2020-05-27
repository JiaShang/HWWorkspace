<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = "10000100000000090000000000105342";
    String[] types = null;
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    List<List<?>> list = new ArrayList<List<?>>();

    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");

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


        List<?> ls = getTypeList(metaHelper, typeId, 100, 0);

        types = new String[ ls.size() ];

        for( int i = 0; i < ls.size(); i++ )
            types[i] = ((Column)ls.get(i)).getId();

        list = new ArrayList<List<?>>();
        int i = 0;
        for( String type : types ){
            ls = getVodList( metaHelper, type, 7, 0);
            list.add( ls );
            i+=2;
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>中国好声音第四季</title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2015-07-23.png') no-repeat fixed;background-position: 0px 0px;}

        .flowed1{width:63px;height:28px;left:175px;top:300px;background-position: -550px -520px;}
        .flowed2{width:63px;height:28px;left:238px;top:300px;background-position: -550px -520px;}
        .flowed3{width:63px;height:28px;left:301px;top:300px;background-position: -550px -520px;}
        .flowed4{width:63px;height:28px;left:364px;top:300px;background-position: -550px -520px;}
        .flowed5{width:63px;height:28px;left:427px;top:300px;background-position: -550px -520px;}
        .flowed6{width:63px;height:28px;left:490px;top:300px;background-position: -550px -520px;}
        .flowed7{width:63px;height:28px;left:562px;top:300px;background-position: -550px -520px;}
        .flowed8{width:63px;height:28px;left:625px;top:300px;background-position: -550px -520px;}
        .flowed9{width:63px;height:28px;left:688px;top:300px;background-position: -550px -520px;}
        .flowed10{width:63px;height:28px;left:751px;top:300px;background-position: -550px -520px;}
        .flowed11{width:63px;height:28px;left:826px;top:300px;background-position: -550px -520px;}
        .flowed12{width:63px;height:28px;left:889px;top:300px;background-position: -550px -520px;}
        .flowed13{width:63px;height:28px;left:952px;top:300px;background-position: -550px -520px;}
        .flowed14{width:63px;height:28px;left:1015px;top:300px;background-position: -550px -520px;}
        .flowed15{width:63px;height:28px;left:1078px;top:300px;background-position: -550px -520px;}

        .images1{width:483px;height:281px;left:44px;top:0px; position: absolute;}
        .images2{width:220px;height:122px;left:541px;top:13px; position: absolute;}
        .images3{width:220px;height:122px;left:780px;top:13px; position: absolute;}
        .images4{width:220px;height:122px;left:1017px;top:13px; position: absolute;}
        .images5{width:220px;height:122px;left:541px;top:155px; position: absolute;}
        .images6{width:220px;height:122px;left:780px;top:155px; position: absolute;}
        .images7{width:220px;height:122px;left:1017px;top:155px; position: absolute;}

        .mask1{width:523px;height:321px;left:25px;top:322px;background-position: 0px -520px;}
        .mask2{width:255px;height:157px;left:525px;top:338px;background-position: -550px -680px;}
        .mask3{width:255px;height:157px;left:764px;top:338px;background-position: -550px -680px;}
        .mask4{width:255px;height:157px;left:1001px;top:338px;background-position: -550px -680px;}
        .mask5{width:255px;height:157px;left:525px;top:479px;background-position: -550px -680px;}
        .mask6{width:259px;height:160px;left:764px;top:479px;background-position: -550px -680px;}
        .mask7{width:255px;height:157px;left:1001px;top:479px;background-position: -550px -680px;}

        .text {text-align: center;position: absolute; overflow: hidden; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis; color:#ebebeb;}
        .text1{width:418px;height:24px;font-size: 22px;line-height: 24px;left:77px;top:125px;}
        .text2,.text3,.text4,.text5,.text6,.text7{width:200px;height:18px;font-size: 16px;line-height: 16px;}
        .text2{left:548px;top:0px;}
        .text3{left:789px;top:0px;}
        .text4{left:1025px;top:0px;}
        .text5{left:548px;top:139px;}
        .text6{left:789px;top:139px;}
        .text7{left:1025px;top:139px;}

        .textNew {position:absolute;width:285px;height:21px;left:47px;top:657px;background:transparent url('images/focus-2015-07-23-1.png') no-repeat fixed 0px 0px;}
        .ImgNew{position:absolute;width:185px;height:55px;left:345px;top:641px;}
        .maskIcon{position:absolute;width:187px;height:57px;left:344px;top:639px;background:transparent url('images/focus-2015-07-23-2.png') no-repeat fixed;background-position: 0px 0px;}
        .flowed {}

        .popuped {width:633px;height: 426px;left:320px;top:187px;position:absolute;background:transparent url('images/popup.png') no-repeat fixed 0px 0px; overflow: hidden;}
        .popuped .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
        .popuped .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
        .popuped .item{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -426px; overflow: hidden;}
        .popuped .maskItem {width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #fefefe; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -477px; overflow: hidden;}
        .marqueed {font-size: 24px; height: 44px; width: 460px;color: #fefefe;line-height:44px;}
        .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }

        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat fixed 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"宋体";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -350px;}

        .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px;height:41px; background-position: 0px 0px;}
        .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px; height:41px; background-position: 0px -42px;}
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
            { focus:<%= ( area <= 0 ? ( types.length - 1 ) : (area - 1) ) %>, count: <%= types.length %> },
            <%
            value = "";
            if( list != null && list.size() > 0 ){
                for(int i = 0; i < list.size() ; i++){
                    value += "{focus:0,typeId:'" + types[i] + "',items:[";
                    List<?> vodList = list.get(i);
                    if( vodList != null && vodList.size() > 0 )
                        for( int j = 0; j < vodList.size() ; j++ ){
                        Vod vod = (Vod)vodList.get(j);
                        String str = "{ mid:'" + vod.getId() + "'," +
                                   "text:\"" + vod.getName() + "\"," +
                                    "length:" + StringUtil.length(vod.getName()) + "," +
                                "style:'mask mask" + (j + 1) + "'" + "," +
                                "picture:'" + Utils.pictureUrl("images/default_preview_lb.png", vod.getPosters(), "1", request)+ "'" + "," +
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
                {name:'现在开唱',playType:-3,link:'http://192.168.48.217:8082/epghd/1.html?pid=11',style:'maskIcon'},
            ]},
            { focus:0, vote:true, items : [
                {name:'input'},
                {name:'确定',style:'btnSure'},
                {name:'取消',style:'btnCancel'}
            ]},
            { focus:0, items : [
                {name:'首页',style:'btnHome'},
                {name:'返回',style:'btnReturn'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var isKorean = false;                   //是否为韩剧
        var columns = 0; rows = 0;              //定义行列，　几行几列
        var arrows = [1,0];                     //可以移动到首页返回按钮的光标键「下，右」
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //上:11,下:-11,左-1,右1
                if(
                    //如果焦点在投票的返回，或右下角的返回上，或者在浮动层上时,光标按右键直接返回
                    blocked == focusable.length - 1 && ( index == -11 || focus == 1 && index == 1 ) ||
                    //如果焦点在投票上,按上下左右键时
                    (blocked == focusable.length - 2 && ( $.vote.tooltiped || focus == 2 && index == 1 || focus <= 1 && index == -1 || focus == 0 && index == 11 || focus >= 1 && index == -11)) ||
                    //或者焦点在浮动层上, 按上下左右键时，
                    focusable[blocked].popuped && ( focus <= 0 && index == 11 || focus >= focusable[blocked].items.length - 1 && index == -11 || index == -1 || index == 1 )
                ) return;
                if( index == 1 && ( !$.vote.tooltiped && blocked == focusable.length - 2 && focus == 1 || blocked == focusable.length - 1 && focus == 0 ))
                    focus = focus + 1;
                else if( index == -1 && ( ! $.vote.tooltiped && blocked == focusable.length - 2 && focus == 2 || blocked == focusable.length - 1 && focus == 1))
                    focus = focus - 1;
                else if( focusable[blocked].popuped ) { focus += index > 0 ? -1 : 1;  }
                else if( blocked == focusable.length - 2 ) { if (focus == 0 && index == -11 ) {focus = 1; $("mask").style.visibility = "visible";} else if( focus >= 1 && index == 11) {focus = 0; $("mask").style.visibility = 'hidden';} }
                else {
                     //TODO:规则的行列模式光标移动代码，光标移动通过 arrows[下，右]控制
                     if( blocked != 0 &&  blocked < focusable.length - 3  && (
                         index == -1 && focus == 0 || //按左光标键时
                         index == 1 && ( focus == 3  || focus == 6 ) || //按右光标键时
                         index == -11 && ( focus == 4 || focus == 5 ) ) || //按下光标键时
                         blocked == 0 && (index == 11 || focus == 0 && index == -1 || focus == focusable[0].count - 1 && index == 1 ) ||
                         blocked == focusable.length -3 && ( index == -11 || index == -1 )
                     ) return;
                     //TODO:当光标在首页、返回按钮上时，可同时按上，左键返回到列目中时，需要重写光标移动代码
                     if( blocked == focusable.length - 1 ) {
                         blocked = index == 11 ? focusable[0].focus + 1 : focusable.length - 3 ;
                         focus = index == 11 ? 6 : 0;
                     } else if( blocked == focusable.length - 3 ) {
                         blocked = index == 11 ? focusable[0].focus + 1 : focusable.length - 1;
                         focus = 0 ;
                     } else if( blocked == 0 ) {
                        if( index == 1 || index == -1 )  {
                            focus += index;
                            focusable[blocked].focus = focus;
                        }
                        else {
                            blocked = focusable[0].focus + 1;
                            focus = focusable[blocked].focus;
                            flowedShow(0);
                        }
                        showTexts();
                    } else {
                         if( blocked != 0 && blocked < focusable.length - 3 ) {
                             if ( index == 1 || index == -1 ) {
                                 if( focus == 4 && index == -1 ) focus = 0;
                                 else focus += index;
                             }
                             if( index == -11 ) {
                                 if( focus == 0 ) {
                                     blocked = focusable.length - 3 ;
                                     focus = focusable[blocked].focus;
                                 } else if( focus == 6 ) {
                                     focusable[focusable.length - 1].blocked = blocked;
                                     blocked = focusable.length - 1;
                                     focus = focusable[blocked].focus;
                                 }
                                 else focus += 3;
                             } else if( index == 11 ) {
                                 if( focus <= 3 ) {
                                     blocked = 0;
                                     focus = focusable[blocked].focus;
                                     flowedShow(0);
                                     showTexts();
                                 }
                                 else focus -= 3;
                             }
                         }
                     }
                     if( blocked === -1) blocked = focusable.length - 1 ;
                }

                var vst = blocked != 0 ? 'visible' : 'hidden';
                if( vst != $("mask").style.visibility ) $("mask").style.visibility = vst;

                focusable[blocked].focus = focus;
            } else if( initilized ){
                if(typeof focusable.flowed != 'undefined' ) for( var z = 0; z < focusable.flowed.length; z++ ) if( z != blocked) flowedShow(z);
                if( blocked == focusable.length - 2 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];
            if( typeof item != 'undefined' && typeof item.style == 'string' )
            {
                $('mask').className = item.style;
                showTexts ( );
            }

            if( focusable[blocked].popuped ) $.popupShow();
            if( focusable[blocked].flowed ) flowedShow(blocked);
        }
        var flowedShow = function(index){
            var focus = focusable[0].focus;
            if( blocked == 0 ) {
                $("flowed").className = "mask flowed" + ( focus + 1 );
                $("flowed").style.visibility = 'visible';
            }
            else
                $("flowed").style.visibility = 'hidden';

            showItems( focus + 1 );
        }
        function showTexts ( ) {
            var items = focusable[ focusable[0].focus + 1 ].items;
            var focus = focusable[ focusable[0].focus + 1 ].focus;
            var text = "";
            for( var i = 0; i < items.length; i ++ ){
                text += "<div class='text text" + ( i + 1 ) + "' id='text" + ( i + 1 ) + "'>";
                if( focus == i &&  items[i].length > ( focus == 0 ? 20 : 11 ) && blocked != 0 && blocked < focusable.length - 3 )
                    text  += "<marquee style='width: 100%; '>" + items[i].text + "</marquee>";
                else
                    text += items[i].text;
                text += "</div>";
            }
            $("TitleContainer").innerHTML = text;
        }
        function showItems ( index ) {
            var items = focusable[index].items;
            var html = "";
            for( var i = 0; i < items.length; i ++ )
                html += "<img src = '" + items[i].picture + "' class='images" + ( i + 1 ) + "' />";
            $("ImageContainer").innerHTML = html;
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
                        case 38: focused(11, false);break;      //上光标键
                        case 40:focused(-11, false);break;      //下光标键
                        case 37:focused(-1, false);break;       //左光标键
                        case 39:focused(1, false);break;        //右光标键
                        case 13: doEnter(); break;              //选择回车键
                        case "KEY_BACK":goBack(true);break;
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
                //如果显示了提示框，取消提示框的显示，重新显示输入框
                if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 2 && focusable[focusable.length - 2].focus == focusable[focusable.length - 2].items.length - 1 ) { goBack(); return; }
                else {
                    if( $.vote.validate() ) {$.vote.tooltip(); return; }
                    //必须 $.vote.current.message, $vote.current.id 都不为空时才进行投票
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = CA.card.serialNumber;
                    var url = "http://192.168.9.79:8021/voteNew/external/addVote.ipanel?icid=" + cardId + "&repeat=false&phone=" + $.vote.phone +"&classifyID=" + $.vote.current.id + "&content=" + encodeURIComponent($.vote.current.message);
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
            $.vote.tooltiped = false;
            $.vote.error = "手机号码不正确！";
            $.vote.fail = "您已参与过投票！";
            $.vote.success = "投票成功！";
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
                $("mask").style.visibility = "hidden";
                $("votePop").style.visibility = "visible";
                $("votePop").style.backgroundPosition = "0px 0px";
            };
            $.vote.hidden = function(className){
                $.vote.status = false;
                $.vote.tooltiped = false;
                $.vote.current = undefined;
                $("mask").style.visibility = "visible";
                $("votePop").style.visibility = "hidden";
            };
            $.vote.tooltip = function(message){
                if( typeof  message == 'undefined' ) message = $.vote.error;
                $.vote.status = false;
                $.vote.tooltiped = true;
                $("mask").style.visibility = "hidden";
                $("phoneNumber").innerHTML = message;
                $("votePop").style.backgroundPosition = "0px -400px";
                $("votePop").style.visibility = "visible";
                $("mask").style.visibility = "hidden";
            };
            //用来记录输入电话号码框的数组顺序及焦点
            $.vote.focus = {}
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                html += "<div id='ImageContainer' style='width: 1280px;height: 285px; left:0px; top:336px; position: absolute;'></div><div class='textNew'></div><img class='ImgNew' src='images/focus-2015-07-23-3.gif'/><div id='mask'></div>";
                if( typeof option.external.before == 'string' ) html += option.external.before;
                if( typeof option.vote != 'undefined' ){
                    html += "<div id='votePop' class='voteContainer' style='visibility:hidden'><div id='phoneNumber' class='phoneNumberInput' ></div></div>";
                    for(var i=0; i < option.vote.length; i++) {
                        if(typeof option.vote[i].item == 'undefined' )
                            focusable[option.vote[i].blocked].voteId = option.vote[i].id;
                        else
                            focusable[option.vote[i].blocked].items[option.vote[i].item].voteId = option.vote[i].id;
                    };
                }
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                if(typeof option.external.after == 'string' ) html += option.external.after;
                html += "<div id='TitleContainer' style='position: absolute;width: 1280px;height:156px;left:0px;top:450px;'></div>"
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
                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; }
                document.body.innerHTML = html;
            }
            $.buildUserInterface({flowed:[0],popup:undefined,vote:undefined,video:undefined,position:undefined,external:{
                before:'<div style="width:1175px;height:193px;position:absolute;left: 42px;top:249px;background:transparent url(images/mask-2015-07-23.png) no-repeat fixed 0px 0px;"></div>',
                after:'<div style="width:1193px;height:312px;position: absolute;left: 44px;top:305px;background:transparent url(images/mask-2015-07-23.png) no-repeat fixed 0px -200px;"></div>'}});
            if( focusable.length == 2 ) { blocked = focusable.length - 1;}
            if( blocked == 0 ) { blocked = focusable[0].count; }
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if( blocked == focusable.length - 2 ) { if( focusable[focusable.length-2].focus == 0 && !$.vote.voted )  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
            if( typeof focusable[blocked].popuped == 'boolean' ) $("popuped").style.visibility = "hidden";
            if( typeof focusable[blocked].vote == 'boolean' || typeof focusable[blocked].popuped == 'boolean' ){
                if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                blocked = focusable[blocked].backed;
                focused(focusable[blocked].focus, true);
                return;
            }
            top.window.location.href = blocked == focusable.length - 1 && focusable[blocked].focus == 0 || EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            //首页，返回
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
                    top.window.location.href = $.current() + item.link;
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/" + (isKorean ? "hj" : "high" ) + "_TV_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2015-07-23.jpg') no-repeat;" onUnload="exit();"></body>
</html>