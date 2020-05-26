<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {};
    final int[] position = {11,0};
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    List<List<Vod>> list = null;

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

        // 返回时获取焦点信息数据
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
    <title>武隆区第一届政务之星评选</title>
    <style>
        .mask {width:202px;height:236px;position:absolute;background:transparent url('images/mask-2017-07-08.png') no-repeat;background-position: 0px 0px;}

        .mask1 {left:272px;top:177px;}
        .mask2 {left:459px;top:177px;}
        .mask3 {left:646px;top:177px;}
        .mask4 {left:832px;top:177px;}
        .mask5 {left:1019px;top:177px;}
        .mask6 {left:272px;top:435px;}
        .mask7 {left:459px;top:435px;}
        .mask8 {left:646px;top:435px;}
        .mask9 {left:832px;top:435px;}
        .mask10 {left:1019px;top:435px;}

        .text {width:81px;height:22px;font-size:22px;color:white;text-align:right;position:absolute;background:transparent none no-repeat 0px 0px;overflow: hidden;}
        .text1 {left:360px;top:398px;}
        .text2 {left:551px;top:398px;}
        .text3 {left:737px;top:398px;}
        .text4 {left:928px;top:398px;}
        .text5 {left:1112px;top:398px;}
        .text6 {left:360px;top:656px;}
        .text7 {left:551px;top:656px;}
        .text8 {left:737px;top:656px;}
        .text9 {left:928px;top:656px;}
        .text10 {left:1112px;top:656px;}

        .flowed {left: 0px;top:0px;width:1280px;height:720px;background:transparent none;position:absolute;}

        .after {left: 0px;top:0px;width:1280px;height:720px;background:transparent url('images/focusBg-2017-07-08.png') no-repeat 0px 0px;position:absolute;}
        .descript {position:absolute;width:421px;height: 383px;font-size:18px;line-height:20px;color:black;left:440px;top:151px;overflow: hidden;}

        .btnVoteNormal{width:129px;height:44px;left:499px;top:593px;background-position: -210px 0px;}
        .btnReturnNormal{width:129px;height:44px;left:653px;top:593px;background-position: -210px -100px;}
        .btnVote{width:129px;height:44px;left:499px;top:593px;background-position: -210px -50px;}
        .btnReturn{width:129px;height:44px;left:653px;top:593px;background-position: -210px -150px;}
        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/
        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"宋体";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}
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
            { focus:0,items : [
                {name:'丁春华',count:0,descript:'丁春华，男，区行政服务中心不动产窗口工作人员，他到不动产登记中心仅仅一年多，但是在一年多窗口工作的时间里，把为广大群众服务作为自己最高要求，他不断加强学习，钻研业务， 从最初的不懂很快成为精通业务的骨干，并以以良好仪容仪表和规范文明的服务用语展示自己的服务水平。他在工作中不断创新工作方法，把全心全意为人民服务这口号真正落实到实际工作中去，多次利用节假日为不方便到窗口办事的群众上门服务，这不仅增进了与群众之间的感情，而且受到群众的高度好评，2016年办理房屋登记2500件，林权登记280件。'},
                {name:'冯璐',count:0,descript:'冯璐，女，大学文化，武隆区不动产登记中心城镇房屋初始登记窗口工作人员。她在工作中树立了社会主义核心价值观，心中时时以严格的服务标准规范自己的言行，以真诚的服务态度接待办事群众。团结同事，不断加强学习，不断提高自己的业务水平及能力，立足于群众，用过硬的业务知识以实际行动践行行政服务中心高效服务。切实贯彻“放管服”，深刻理解其简政放权、放管结合、优化服务。在2016年工作中，完成1574笔大宗业务，其中：城镇房屋初始登记接件64笔、转移登记1499笔、在建工程变更登记11笔等。在依法按规办事的同时，高效服务，尽力避免办事企业群众来回跑腿，以良好的精神风貌，高质量的服务争做名合格的窗口服务工作者。'},
                {name:'彭小东',count:0,descript:'彭小东，男，自2005年在行政服务中心窗口工作，十多年来，他凭借坚定的理想信念，爱岗敬业，优质服务于群众，他认贯彻执行国家和市级非税收入法律法规以及《财政票据管理办法》，切实规范了财政票据使用，预防乱收费的行为发生，严格政策标准，坚持依法征收非税，做到应收尽。他充分发挥了非税中心为财政聚财、理财作用，为全区经济发展作出了一定的贡献。仅2016年，安装“新系统”行政事业单位开票点63个，共发放财政票据1，490，474套(本），核销财政票据878，535套(本），全区非税收入总计138，016万元(含基金收入)，由于工作成绩突出，先后多次被区行政服务中心或区级部门评为服务标兵、党员示范岗、优秀公务员。'},
                {name:'王蕾',count:0,descript:'王蕾，女，大学文化，中共党员，城乡建委窗口工作人员。该同志在武隆区行政审批服务中心窗口工作9年以来，能模范执行党的路线、方针、政策。她干一行爱一行，潜于钻研，以实际工作业绩，彰显为民情怀。截至目前累计办件3000余件，收取城市建设配套费2亿8千余万元，办结率达到100％；良好的树立了行政审批工作人员的形象，也得到了社会各界的好评，多次被评为“窗口先进个人”，“服务之星”，所在城乡建委窗口也多次被评为“红旗窗口”及“党员示范岗”。'},
                {name:'冯怡寒',count:0,descript:'冯怡寒，女，2016年9月进入重庆市武隆区地方税务局纳税服务中心工作，负责全县各所的票证管理和办公室内勤。上班时本着认真负责的态度办好每件事，下班后利用业余时间自学税法、财会等基础知识。在工作学习一个月后，便顺利通过了税收执法资格考试，成为了一名税务工作者。去年年末的元旦节冯怡寒就是在乡镇各所的查票订票中度过，她一直勤勤恳恳、任劳任怨的工作。把持原则:在情与法，公与私的交织碰撞中，坚持自我，努力弘扬爱岗敬业和无私奉献的精神，在政治上追求进步，在思想上寻求升华。'},
                {name:'罗树林',count:0,descript:'罗树林，男，进驻大厅发改委窗口多年。工作期间，严格遵守各项规章制度，工作兢兢业业，廉洁高效，热心为办事企业群众做好了政务服务工作。在窗口标准化建设中，严格规范审批服务行为，做好一次性告知，精简办事流程，缩短办理时限；努力创新工作模式，对符合我县规划发展的项目实行告知承诺，实施备案项目预约服务。2016年办理全区各类投资项目189件，其中重点项目及招商引资86件。'},
                {name:'杨乾坤',count:0,descript:'杨乾坤，女，大学文化，区行政服务中心工商窗口工作人员。在窗口工作中紧紧围绕“315”目标，坚持“三清四办五心六零”服务承诺，主动作为，确保了各项改革落地有声、改革措施推进有力，促进市场主体加快发展。她在商事制度改革中把减少前置项目、实行企业“五证合一”个体“两证合一”、推行网上审批系统、优化受理方式、推行个体工商户简易注销、率先在全市试点实施企业简易注销作为改革和服务群众的重点。截止目前，为全区新设各类市场主体3884户，累计发展27410户办理相关手续。'},
                {name:'梁婷婷',count:0,descript:'梁婷婷，女，区公安局行政审批窗口工作人员，从事公章刻制业、特种行业许可、民用爆炸物品和烟花爆竹购买、运输许可及户政审批边境证办理等行政审批事项的受理及相关政务服务工作。她在工作中以提高行政效能、革新便民服务理念为切入点，以推行各项便民利民措施为抓手，以提高服务质量、实现群众满意为目标。仅2016年，共受理行政审批事项6313件，解答群众咨询1000余人次。窗口按时办结率、现场办结率、群众满意率均为100%，无一投诉和问责。'},
                {name:'曾芳',count:0,descript:'曾芳，女，自参加工作以来，她能模范执行党的路线、方针、政策，遵守国家法律、法规，立足岗位、奋发进取，各项工作想在前、干在前，充分起到了模范带头作用。在业务上，勤于钻研，系统学习并掌握了环境管理知识，用以指导环评审批工作。为了保证我区的重点项目落地，及时与市级环评部门和项目建设单位接洽，多次协调市环保局，市环科院等有关单位，保证了我区仙女山机场项目、浩口电站等多个项目顺利的通过审批。2009年参加全国第一次污染源普查期间，吃苦耐劳，连续100多个日夜加班,顺利完成工作任务，表现出“特别能吃苦、特别能忍耐、特别能战斗、特别能奉献”的精神。在污染源普查、建设项目管理、生态保护、饮用水源保护、建设项目环保审批与管理等各项工作中，其精湛的业务，突出的业绩、廉洁的工作作风也得到大家的充分肯定，多次被环保部和区委区政府评为先进个人。'},
                {name:'许杰峰',count:0,descript:'许杰峰，男，大学文化，区行政服务中心交委（运管）窗口工作人员，他在窗口工作期间，积极简化企业与民众的办事流程，承诺规定期限内办结业，遵循“热情、高效、规范、严细、清廉”的服务原则，围绕提升交通形象、服务群众的工作目标，积极办理审批事项。2016年，交委运管及综合执法大队共办理许可服务事项5500余件，其中办理道路货运许可证件158件、从业资格证新办 49件，从业资格证年审3161件、运输车辆审验2127辆。按时办结率和满意率均达100%。'},
                {name:'李琼',count:0,descript:'李琼，女，区行政服务中心林业窗口工作人员。她在工作中力求热情为企业、群众着想，不让群众多跑路，经常不断学习业务知识和业务技能。不仅为全区重大项目服务，还经常参与区级其他单位和部门涉及林业用地或其他林业审批的协调工作。2016年共办理林地征占用审批85件，林木采伐许可11件，木材运输许可27件，陆生野生动物驯养繁殖许可23件，陆生野生动物经营许可28件，陆生野生动物运输许可5件，调运检疫71件，木材加工许可9件，种子苗木生产经营许可2件。'},
                {name:'许琼',count:0,descript:'许琼，女，区行政服务中心食药监窗口工作人员。自2014年4月到中心窗口工作以来，始终坚持依法行政、廉洁从政的服务原则，牢记“便民、规范、廉洁、高效”的服务宗旨，以满腔的工作热情和高度的敬业精神服务群众，切实打造群众满意服务窗口，本着“群众利益无小事”的原则，在平凡的岗位上释放出不平凡的能量。2016年，办结各项审批事项1672件，其中新办件1102件、延续203件、变更96件、注销265件、补发6件。'},
                {name:'陈烨',count:0,descript:'陈烨，女，2014年9月被聘为卫计委窗口工作人员。工作期间，她始终牢记“服务群众、服务企业、服务基层”的宗旨，以“为群众办好事、让群众好办事”为要求严于律己，兢兢业业。由于同事患病，经常请假复查，窗口多数时间只有她一人值守，在人员减少、工作量却不能减的情况下，只有靠效率、时间来保证。据统计，2016年，窗口接受群众咨询约3000人次，办理行政许可项目1154件次（另代发健康证7152张），她始终坚持长期“满负荷”工作甚至带病上岗，以业务精、效率高为保障，确保了各项工作的圆满完成，实现了数质并举，做到了“零差错”、“零超期”，从未发生与办事群众争吵等事件，始终保持零投诉。先后被评为年度“先进个人”，窗口被评为“红旗窗口”。陈烨同志充分展现了年轻人乐观向上、热爱生活、勇于担当、吃苦耐劳的精神风貌，为“90后”做出了表率。'}
            ]},
            { focus:0, vote:true, items : [
                {name:'',style:'mask btnVote',playType:-2},
                {name:'返回',style:'mask btnReturn'}
            ]},
            { focus:0, vote:true, items : [
                {name:'input'},
                {name:'确定',style:'btnSure'},
                {name:'取消',style:'btnCancel'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var isKorean = <%= isKorean%>;                   //是否为韩剧
        var columns = 5; rows = 2;              //定义行列，　几行几列
        var pageCount = columns * rows;
        Date.prototype.Format = function(fmt)
        {
            var o = {
                "M+" : this.getMonth()+1,
                "d+" : this.getDate(),
                "h+" : this.getHours(),
                "m+" : this.getMinutes(),
                "s+" : this.getSeconds(),
                "q+" : Math.floor((this.getMonth()+3)/3),
                "S"  : this.getMilliseconds()
            };
            if(/(y+)/.test(fmt))
                fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
            for(var k in o)
                if(new RegExp("("+ k +")").test(fmt))
                    fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
            return fmt;
        };
        var voteSwitch = (new Date()).Format("yyyy-MM-dd hh:mm:ss") < "2017-07-13 00:00:00";
        function focused(index,initilized){
            if( focusable.length <= 1 ) return;
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //上:11,下:-11,左-1,右1
                //如果焦点在投票上,按上下左右键时
                if( blocked == focusable.length - 1 ) return;
                else {
                     if( blocked == 0  && (
                         index == 11 && focus < columns || //按上光标键时
                         index == -1 && focus % columns == 0 || //按左光标键时
                         index == 1 && focus % columns == columns - 1 || //按右光标键时
                         index == -11 && ( ( columns == 1 && focus + 1 >= focusable[blocked].items.length ) || ( columns > 1 && ( Math.floor( focus / columns ) == Math.floor( focusable[blocked].items.length / columns ) )) ) //按下光标键时   && focus + columns != focusable[blocked].items.length (最后一个未对齐时)
                     ) || blocked == 1 && (index == 11 || index == -11 || index == -1 && focus == 0 || index == 1 && focus + 1 >= focusable[blocked].items.length )) return;
                     //TODO:当光标在首页、返回按钮上时，可同时按上，左键返回到列目中时，需要重写光标移动代码
                    if( blocked == 0 ) {
                        if( index == 1 || index == -1 ) focus += index;
                        else if( index == 11 ) focus -= columns;
                        else if( index == -11 ) focus += columns;
                        if( focus >= focusable[blocked].items.length ) { focus = focusable[blocked].items.length - 1 ; }
                    } else if( blocked == 1 ) {
                        focus += index;
                    }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                if( blocked == focusable.length - 1 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];

            if(typeof item != 'undefined' && typeof item.style == 'string' )
                $( blocked == focusable.length - 1 ? "maskVote" : "mask").className = item.style;

            for( var o in focusable.flowed ) flowedShow(focusable.flowed[o]);
        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            //每页显示数量
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;

            document.body.style.backgroundImage = 'url("images/bg-2017-07-08-' +  ( Math.floor(focus  / pageCount) + 1) + '.jpg")';
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='text text" + ( i % pageCount + 1 ) + "'>" + item.count + "</div>";
                if( blocked != index || i != focus ) continue;
                $("mask").className = "mask mask" + ( i % pageCount + 1 );
            }
            $("flowed").innerHTML = html;
        }
        var showUserItemInfo = function() {
            var desc = focusable[0].items[focusable[0].focus].descript;
            var html = '';
            if(voteSwitch) {
                $.vote.message = focusable[1].items[0].name = focusable[0].items[focusable[0].focus].name;
                html += '<div class="mask btnVoteNormal"></div><div class="mask btnReturnNormal"></div>';
            }
            html += '<div class="descript">' + desc + "</div>";
            $("after").innerHTML = html;
            $("after").style.visibility = 'visible';
            $("mask").className = focusable[1].items[focusable[1].focus].style;
        }
        var sortAndShow = function (index, results){
            for( var i = 0 ; i < results.length; i++ ) {
                var name = results[i].name;
                for( var j = 0; j < focusable[0].items.length ; j ++ ) {
                    if( name != focusable[0].items[j].name ) continue;
                    focusable[0].items[j].count = results[i].num;
                    break;
                }
            }
            var focus = focusable[0].focus;
            var items = focusable[0].items;
            var html = '';
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='text text" + ( i % pageCount + 1 ) + "'>" + (item.count == '' ? 0 : item.count) + "</div>";
            }
            $("flowed").innerHTML = html;
        }
        function queryVoteResult(){
            try {
                $.ajax('http://192.168.49.56:8989/VoteStatistics/getVoteInfo?classifyID=394',function(result){
                    sortAndShow(0,result);
                });
            } catch ( e ) {};
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
                        case 13:doEnter(); break;              //选择回车键
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
            $.video = {};
            $.video.id = undefined;
            $.video.position = undefined;
            $.video.play = function(){
                try{
                    if(typeof $.video.id != "string" || $.video.id.isEmpty() || typeof iPanel === 'undefined') return;
                                                                //go_authorization.jsp??typeId=-1&playType=11&parentVodId="+parentVodId+"&progId="+freeVodId+"&baseFlag=0&contentType=0&startTime=0&business=1;
                    var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + $.video.id + "&contentType=0&business=1&baseFlag=0";
                    $.ajax(rtspUrl,function(result){
                        if( result.playFlag === "1"){
                            var rtsp = result.playUrl.split("^")[4];
                            media.video.setPosition($.video.position[0],$.video.position[1],$.video.position[2],$.video.position[3]);
                            media.AV.open(rtsp,"VOD");
                        }
                    });
                } catch (e){}
            }

            $.vote = function (){
                if( $.vote.voted ) { if( !$.vote.tooltiped ) $.vote.tooltip($.vote.fail); else goBack();return; }
                //如果显示了提示框，取消提示框的显示，重新显示输入框
                //if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 1 && focusable[focusable.length - 1].focus == focusable[focusable.length - 1].items.length - 1 ) { goBack(); return; }
                else {
                    //必须 $.vote.current.message, $vote.current.id 都不为空时才进行投票
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = CA.card.serialNumber;
                    //点击量统计
                    //http://192.168.49.56:8080/voteNew/external/clickCount.ipanel?icid=8230003190017318&classifyID=100&content=44
                    //专题投票排序
                    var url = "http://192.168.49.56:8080/voteNew/external/addVote4.ipanel?icid=" + cardId + "&phone=13999999999&classifyID=" + $.vote.current.id + "&voteCount=15&content=" + encodeURIComponent($.vote.current.message);
                    $.ajax(url,function(result){
                        if(result.recode != '002' || result.result == false ){
                            $.vote.voted = result.result == false;
                            $.vote.tooltip($.vote.fail);
                        } else {
                            $.vote.voted = true;
                            $.vote.tooltip($.vote.success);
                            queryVoteResult();
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
            $.vote.error = "手机号码不正确！";
            $.vote.fail = "今日投票过多！";
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
            //用来记录输入电话号码框的数组顺序及焦点
            $.vote.focus = {}
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
                html += "<div id='mask'></div>";
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
                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; $.video.play();}
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
                        if( temp[1] == 'vodid' ) return temp[4]; //将断点时间取出，其他字段不要
                    }
                }
                return null;
            }
            if( !voteSwitch ) focusable[1].items = focusable[1].items.slice(1);
            $.buildUserInterface({flowed:[0],vote:[{blocked:1,item:undefined,id:394}],video:undefined,position:undefined,external:{after:'<div class="after" id="after" style="visibility: hidden"></div>',before:undefined}}); //
            focused(<%= focused %>, true);
            queryVoteResult();
        }
        function goBack(keyBack){
            if( blocked == 1 ) {
                blocked = 0;
                $("after").style.visibility = 'hidden';
                focused(focusable[0].focus, true);
                return;
            }
            if( focusable.length > 1 ) {
                if( blocked == focusable.length - 1 ) { if( focusable[blocked].focus == 0 && !$.vote.voted )  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
                if( typeof focusable[blocked].vote == 'boolean'){
                    if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                    blocked = focusable[blocked].backed;
                    focused(focusable[blocked].focus, true);
                    return;
                }
            }
            if(typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 1 ) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            if( blocked == 0 ) {
                blocked = 1; focusable[1].focus = 0;showUserItemInfo(); return;
            }
            if( blocked == 1 && (!voteSwitch && focusable[blocked].focus == 0 || voteSwitch && focusable[blocked].focus == 1  )) {
                blocked = 0;
                $("after").style.visibility = 'hidden';
                focused(focusable[0].focus, true);
                return;
            }
            //首页，返回
            if( blocked == focusable.length - 1 ) { $.vote(); return; }
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
                    $.vote.voted = $.vote.moreVote = false;
                    $.vote.current = {};
                    $.vote.current.id = focusable[blocked].voteId;
                    $.vote.current.message = typeof item.name == 'undefined' ? item.vote : item.name;
                    focusable[focusable.length - 1].backed = blocked;
                    blocked = focusable.length - 1;
                    focusable[blocked].focus = 0;
                    $.vote();
                    focused(0, true);
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
                case "KEY_NUMERIC":$.vote.input("phoneNumber", eventObj.args.value);break;
                case "KEY_BACK": goBack(true);break;
                case "KEY_EXIT":
                case "KEY_MENU":location.href = iPanel.eventFrame.portalUrl;return 0;break;
                case "VOD_PREPAREPLAY_SUCCESS":media.AV.play();break;
                case "EIS_VOD_PROGRAM_END":$.video.play();break;
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2017-07-08-1.jpg') no-repeat;" onUnload="exit();"></body>
</html>