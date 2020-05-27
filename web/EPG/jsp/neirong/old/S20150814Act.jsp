<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    final List<String[]> questions = new ArrayList<String[]>();
    final int popItemMaxCharLength = 12;
    String fromEPG = "";

    questions.add(new String[]{"八路军在（ ）中击毙了“名将之花”之称的日军中将阿部规秀中将。","平型关大捷","雁门关伏击战","黄土岭战斗","C","1"});
    questions.add(new String[]{"中国共产党最早成立的敌后抗日根据地是（ ）","晋冀鲁豫抗日根据地","晋绥抗日根据地","晋察冀抗日根据地","C","2"});
    questions.add(new String[]{"1946年4月29日，设在东京的（ ）对28名日本甲级战犯正式起诉，并判处其中7名甲级战犯为死刑。","海牙国际法庭","纽伦堡军事法庭","远东国际军事法庭","C","3"});
    questions.add(new String[]{"1942年，毛泽东就抗日根据地的经济建设，指出：“（ ），是我们的经济工作和财政工作的总方针”。","惩前毖后，治病救人","发展经济，保障供给","减租减息","B","4"});
    questions.add(new String[]{"日本发动的（ ），是中国人民抗日战争的起点，同时揭开了世界反法西斯战争的序幕。","万宝山事件","九一八事变","一二八事变","B","5"});
    questions.add(new String[]{"1940年8月创办的（ ），是中国共产党历史上第一所培养科技人才的大学。","鲁迅艺术学院","延安炮兵学校","延安自然科学院","C","6"});
    questions.add(new String[]{"最早开始反法西斯战争的是（ ）。","西班牙","埃塞俄比亚","中国","C","7"});
    questions.add(new String[]{"1938年5月，毛泽东发表了著名的（ ），成为指导中国抗战的纲领性文献。","《论持久战》","《中国革命战争的战略问题》","《实践论》","A","8"});
    questions.add(new String[]{"1942年9月7日，毛泽东在为《解放日报》写的社论《一个极其重要的政策》中，特地表扬了（ ）的“精兵简政”工作。","陕甘宁边区","苏皖边区","晋冀鲁豫边区","A","9"});
    questions.add(new String[]{"1940年4月，晋冀豫抗日根据地成立了以（ ）为书记的太行军政委员会，统一领导太行、太岳、冀南三区。","邓小平","刘伯承","聂荣臻","A","10"});
    questions.add(new String[]{"1941年11月在陕甘宁边区第二届参议会第一次会议上，（ ）首先倡议提出“精兵简政”政策。","黄炎培","李鼎铭","续范亭","B","11"});
    questions.add(new String[]{"八路军出师华北抗日前线对日军作战取得的首次重大胜利是（ ）。","平型关大捷","台儿庄大捷","昆仑关大捷","A","12"});
    questions.add(new String[]{"1937年9月22日，国民党中央通讯社发表（ ）；次日，蒋介石发表谈话，事实上承认了中国共产党在全国的合法地位，标志着抗日民族统一战线的形成。","《中共中央为日军进攻卢沟桥通电》","《中共中央为公布国共合作宣言》","《中国共产党抗日救国十大纲领》","B","13"});
    questions.add(new String[]{"为了巩固抗日根据地，进一步巩固和扩大抗日民族统一战线，中共中央要求各根据地在政权建设中普遍贯彻执行的原则是（ ）。","民主选举原则","统一战线原则","“三三制”原则","C","14"});
    questions.add(new String[]{"整个抗日战争期间，中国军民伤亡总数在（ ）万以上，直接经济损失超过1000亿美元，间接经济损失5000亿美元。","2100","900","3500","C","15"});
    questions.add(new String[]{"将毛泽东思想作为党的指导思想写入党章的是（ ）。","遵义会议","中共七大","中共六大","B","16"});
    questions.add(new String[]{"中国共产党在抗日战争时期为调节各抗日阶级经济利益而实行的土地政策是（ ）。","耕者有其田","剥夺地主土地","减租减息","C","17"});
    questions.add(new String[]{"（ ）是八路军在敌后战场发动的规模最大、持续时间最长的战略性战役，也是在国际法西斯侵略气焰极度嚣张、中国抗战面临严峻考验的关键时刻的一次具有重大意义的战略行动。","百团大战","平型关大捷","冀中区“五一”反“扫荡”战役","A","18"});
    questions.add(new String[]{"1935年12月，在中国共产党的领导下，由北平学联组织的一次大规模的抗日爱国示威游行，史称（ ）。","一二一运动","一二九运动","反饥饿反内战运动","B","19"});
    questions.add(new String[]{"1941年12月9日，根据太平洋战争爆发后的严峻形势，中共中央政治局决定成立负责海外工作的机构是（ ）。","中共中央海外工作委员会","中央军事外事组","南方局外事组","A","20"});

    List<Integer> list = new ArrayList<Integer>();
    Random random = new Random(System.currentTimeMillis());
    while ( list.size() < 10 ) {
        int index = (int)Math.floor(random.nextDouble() * 20);
        if( list.indexOf( index ) >= 0 || index >= 20 ) continue;
        list.add( index );
    }
    Collections.sort(list);
    //TODO:每次需要修改
    int focused = 0, area = 0;

    String value = "";
    String backUrl = "";

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
        } else{
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

    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>有 奖 竞 答</title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2015-08-14-Act.png') no-repeat fixed;background-position: 0px 0px;}
        .btnICan {width:170px;height:44px;left:555px;top:562px;background-position: 0px 0px;}

        .flowed {width:1280px;height:720px;left:0px;top:0px;position:absolute;background:transparent url('images/focus-2015-08-14-Act.png') no-repeat fixed 0px 0px;}
        .flowedQuestionContainer {width:560px;height:263px;left:347px;top:213px;position:absolute;padding:22px;}

        .question { font-size:18px;line-height:28px; color: #333333; margin:0px 0px 10px 0px; }
        .answer {height: 34px; width:560px;}

        .answerItem {background:transparent url('images/mask-2015-08-14-Act.png') no-repeat fixed;background-position: 0px 0px;}
        .answerLeft,.answerFocusLeft {width:10px;height:34px;}
        .answerCenter,.answerFocusCenter{height:34px;color: #333333;line-height: 30px;}
        .answerRight,.answerFocusRight {width:10px;height:34px;}
        .answerFocusLeft {background-position:-4px -104px;}
        .answerFocusCenter{background-repeat: repeat-x;background-position:0px -55px;color: #ffffff;}
        .answerFocusRight {background-position:-156px -104px;}

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

        .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:120px; width:161px;height:41px; background-position: 0px 0px;}
        .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:120px; width:161px; height:41px; background-position: 0px -42px;}
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
            { focus:0, items: [ {name:'我要答题',style:'mask btnICan'} ]},
            <%
            value = "";
            if( list != null && list.size() > 0){
                value += "{focus:0,vote:true,items:[";
                for(int i = 0; i < list.size() ; i++){
                    String[] quest = questions.get(list.get(i));
                    String str = "{ question:\"" + (i + 1) + "、" + quest[0] + "\"," +
                                   "a:\"A、" + quest[1] + "\"," +
                                   "b:\"B、" + quest[2] + "\"," +
                                   "c:\"C、" + quest[3] + "\"," +
                                   "o:" + quest[5] + "," +
                              "answer:\"" + quest[4] + "\"" + "}" ;
                            str += ( i + 1 < list.size()  ? "," : "");
                    value += str;
                }
                value += "]},";
                out.write(value);
            }
            %>
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
                    blocked == focusable.length - 1 && (focus == 0 && arrows[1] == 0 && index == -1 || arrows[0] == 0 && index == 11 || index == -11 || focus == 1 && index == 1 ) ||
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
                    if( blocked == 0 && ( index == 1 || index == -1 || index == 11 ) || blocked == 1 && ( index == 1 || index == -1 || index == 11 && focusable[1].index == 0 || index == -11 && focusable[1].index == 2 )) return;
                    if( blocked == 0 ) {
                        blocked = focusable.length - 1; focus = focusable[blocked].focus;
                    } else if(blocked == 1){
                        focusable[blocked].index += index > 0 ? -1 : 1;
                        flowedShow(blocked);
                    } else if ( blocked == focusable.length - 1 ){
                        blocked = 0; focus = 0;
                    }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                //if(typeof focusable.flowed != 'undefined' ) for( var z = 0; z < focusable.flowed.length; z++ ) if( z != blocked) flowedShow(z);
                if( blocked == focusable.length - 2 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];
            if(typeof item != 'undefined' && typeof item.style == 'string' )
                $('mask').className = item.style;
            if( focusable[blocked].popuped ) $.popupShow();
        }
        var flowedShow = function(index){
            var focus = focusable[1].focus;
            var item = focusable[1].items[focus];
            var index = focusable[1].index;
            var html = '';
            html += '<div class="question">' + item.question + '</div>';
            html += getAnswerHtml(item.a,0,index);
            html += getAnswerHtml(item.b,1,index);
            html += getAnswerHtml(item.c,2,index);
            $("flowedQuestionContainer").innerHTML = html;
        }
        var getAnswerHtml = function(answer, order ,index){
            var html = '<div class="answer">';
            if( order == index ){
                html += '<span class="answerItem answerFocusLeft"></span>';
                html += '<span class="answerItem answerFocusCenter">' + answer + '</span>';
                html += '<span class="answerItem answerFocusRight"></span>';
            } else {
                html += '<span class="answerLeft"></span>';
                html += '<span class="answerCenter">' + answer + '</span>';
                html += '<span class="answerRight"></span>';
            }
            html += '</div>'
            return html;
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
            $.vote.mask = 'visible';
            $.vote.phone = undefined;
            $.vote.tooltiped = false;
            $.vote.error = "手机号码不正确！";
            $.vote.fail = "您已参与过答题活动！";
            $.vote.success = "";
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
                $.vote.mask = $("mask").style.visibility;
                $("mask").style.visibility = "hidden";
                $("votePop").style.visibility = "visible";
                $("votePop").style.backgroundPosition = "0px 0px";
            };
            $.vote.hidden = function(className){
                $.vote.status = false;
                $.vote.tooltiped = false;
                $.vote.current = undefined;
                $("mask").style.visibility = $.vote.mask;
                $("votePop").style.visibility = "hidden";
            };
            $.vote.tooltip = function(message){
                if( typeof  message == 'undefined' ) message = $.vote.error;
                $.vote.status = false;
                $.vote.tooltiped = true;
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
                if(typeof option.external.before == 'string') html += option.external.before;
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='flowed' style='visibility: hidden'><div id='flowedQuestionContainer' class='flowedQuestionContainer'></div></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                if( typeof option.vote != 'undefined' ){
                    html += "<div id='votePop' class='voteContainer' style='visibility:hidden'><div id='phoneNumber' class='phoneNumberInput' ></div></div>";
                    for(var i=0; i < option.vote.length; i++) {
                        if(typeof option.vote[i].item == 'undefined' )
                            focusable[option.vote[i].blocked].voteId = option.vote[i].id;
                        else
                            focusable[option.vote[i].blocked].items[option.vote[i].item].voteId = option.vote[i].id;
                    };
                }
                html += "<div id='mask'></div>";
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
                if(typeof option.external.after == 'string' ) html += option.external.after;
                document.body.innerHTML = html;
            }
            $.buildUserInterface({flowed:[1],popup:undefined,vote:[{blocked:1 ,item:undefined,id: 233}],video:undefined,position:undefined,external:{after:undefined,before:undefined}});
            if( focusable.length == 2 ) {blocked = focusable.length - 1;}

            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if( blocked == focusable.length - 2) {
                if(focusable[focusable.length-2].focus == 0 && !$.vote.voted)  {
                    $.vote.delete("phoneNumber"); return;
                } else  $.vote.hidden();
            }
            if( blocked == 1 || blocked == focusable.length - 2) {
                $("flowed").style.visibility = 'hidden';
                focusable[1].focus = 0;
                focusable[1].index = 0;
                focusable[1].result = 0;
                blocked = 0;
                $("mask").style.visibility = 'visible';
                focused(0,true);
                return;
            }
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
            if( blocked == 0 ) {
                blocked = 1;
                $("mask").style.visibility = 'hidden';
                $("flowed").style.visibility = 'visible';
                focusable[1].index = 0;
                focusable[1].result = 0;
                flowedShow(1);
                return;
            }
            if( blocked == 1 ) {
                if( focusable[1].focus < 10 ) {
                    var ix = focusable[1].index;
                    var result = ix == 0 ? 'A' : ( ix == 1 ? 'B' : 'C' );
                    focusable[1].result += ( result == focusable[1].items[focusable[1].focus].answer ? 1 : 0);
                    focusable[1].focus += 1;
                    focusable[1].index = 0;
                    flowedShow(1);
                }
                if( focusable[1].focus >= 10 ) {

                    var message = "全部答对";
                    $.vote.success = "答题完成，恭喜你答对了全部问题！";

                    if( focusable[1].result < 10 ){
                        message = "未完全答对";
                        $.vote.success = "答题完成，恭喜你答对了&nbsp;" + focusable[1].result + "&nbsp;道问题！";
                    }

                    $.vote.current = {};
                    $.vote.current.id = 233;
                    $.vote.current.message = message;
                    focusable[focusable.length - 2].backed = 1;
                    blocked = focusable.length - 2;
                    focusable[blocked].focus = 0;
                    $.vote();
                    focused(0, true);
                }
                return;
            }
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2015-08-14-Act.jpg') no-repeat;" onUnload="exit();"></body>
</html>