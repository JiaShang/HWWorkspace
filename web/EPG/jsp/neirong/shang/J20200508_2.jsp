<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>

<%--
//  一横排专区模板, 默认5个方框
typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;
lft:LEFT坐标;不填为默认坐标
tp:TOP坐标;不填为默认坐标
cl:文字颜色;不填为默认为 fee5f0
fc:焦点文字颜色;不填为默认为 fdfa00
bo:背景框颜色;不填为默认为 ffffff
bc:焦点框颜色;不填为默认为 fdfa00
ct:显示数量;每行显示条目个数，默认为５个;
st:样式，如果 st 为1时，焦点文字背景为黑色，盖住了图片;
wh: 元素图片的宽度
ht: 元素图片的高度
ml: 两个元素之间的距离
mt: 元素和文字之间的距离
mh: 上下两排元素之间的高度
bd: 边框的宽度，默认为 6
row:多少行，pageCount 显示结果为 row * ct
bg:背景图片，如果带bg参数时，不需要加 images/ 系统自动加上
fs:font-size， 字体大小
pic:图片类型，默认为海报.
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114702";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "images/J20200117ListBg.jpg" : inner.pictureUrl("",column.getPosters(),"7");
    String[] sc = {};
    String bo = null,bc = null,fc = null,cl = null;
    Integer tp = null,ct=null,lt=null,st=null,wh=null,ht=null,ml=null,mh = null,mt=null,bd = null, row = null, fs = null,pic=null, cat = null,maxTitleLen = null,direct=null;
    lt = inner.getInteger("lft", inner.getInteger("lt", 89));
    ct = inner.getInteger("ct", 5);
    tp = inner.getInteger("tp", 383);
    cl = inner.get("cl", "fee5f0");
    fc = inner.get("fc", "fdfa00");
    bo = inner.get("bo", "transparent");
    bc = inner.get("bc", "fdfa00");
    st = inner.getInteger("st", 0);
    wh = inner.getInteger("wh",178);
    ht = inner.getInteger("ht",232);
    ml = inner.getInteger("ml",30);
    mh = inner.getInteger("mh",0);
    mt = inner.getInteger("mt",st == 1 ? -33 : 8);
    bd = inner.getInteger("bd",6);
    fs = inner.getInteger("fs",22);
    row = inner.getInteger("row",1);
    pic = inner.getInteger("pic",1);
    cat = !isNumber( inner.get("cat") ) ? 0 : Integer.valueOf(inner.get("cat"));
    maxTitleLen = !isNumber( inner.get("maxTitleLen") ) ? 6 : Integer.valueOf(inner.get("maxTitleLen"));
    sc = isEmpty( inner.get( "sc" )) ? new String[8] : inner.get("sc").split("\\,");
    direct = !isNumber( inner.get("direct") ) ? 0 : Integer.valueOf(inner.get("direct"));
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .listName{
            position: absolute;
            width: <%=wh %>px;
            height: 50px;
            color:#<%=cl %>;
            font-size:<%=fs %>px;
            background-color: transparent;
            overflow: hidden;
            text-align: center;
            line-height: 50px;
            padding: <%=bd %>px;
        }
        img{
            position: absolute;
            width: <%=wh %>px;
            height: <%=ht %>px;
            left: <%=bd %>px;
            top:  <%=bd %>px;
        }
        .list{
            position: absolute;
            background-color: transparent;
            width: <%=wh+2*bd %>px;
            height: <%=ht+2*bd %>px;
            visibility: hidden;
        }
        #list{
            position: absolute;
            left: <%=lt %>px;
            top: <%=tp %>px;
            width:<%=(wh + ml) * ct %>px;
            height:<%=(tp + mh)* row %>px;
        }
        #scrollLower{
            position: absolute;
            left: <%= sc[0]%>px;
            top: <%= sc[1]%>px;
            height: <%= sc[2]%>px;
            width: 5px;
            background-color:#<%= sc[3]%>;
            visibility: hidden;
        }
        #scrollUpper {
            position: absolute;
            top: 0px;
            height: 100px;
            width: 25px;
            left: -10px;
            visibility: hidden;
            background-color:#<%= sc[4]%>;
            color: #fffbfb;
            font-size: 22px;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
    <script language="javascript" type="text/javascript">
        <!--
        var listBox = null;
        var listData = [];
        var posters = [];
        var adBgImgs = [];
        var maxTitleLen = <%= maxTitleLen%>;
        var scrollFlag = <%= sc[5]%>;
        var scrollWay = <%= sc[6]%>;
        var scrollData = <%= sc[7]%>;
        var row = <%=row %>;
        var ct = <%=ct %>;
        cursor.initialize({
            data: [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
            focused: [<%= inner.getPreFoucs() %>],
            init: function () {
                cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
                cursor.backUrl = '<%= backUrl %>';
                cursor.enlarged = 0;
                for (var i = 0; i < this.data.length; i++) {
                    var o = this.data[i];
                    cursor.focusable[i] = {};
                    cursor.focusable[i].typeId = o["id"];
                    cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                    cursor.focusable[i].items = o["data"];
                    for( var j = 0; j < cursor.focusable[i].items.length; j ++) {
                        if (typeof cursor.focusable[i].items[j].posters != 'undefined') {
                            if (typeof cursor.focusable[i].items[j].posters['5'] != 'undefined') {
                                cursor.focusable[i].items[j] = {
                                    'name': o["data"][j].name,
                                    'linkto': '/EPG/jsp/neirong/shang/J20200420List.jsp?typeId=' + o["id"] + '&blocked=' + i + '&focus=' + j + "&direct=" +<%=direct%>,
                                    'posters': o["data"][j].posters
                                };
                                // adBgImgs = cursor.focusable[i].items[j].posters['5'];
                            } else if (typeof cursor.focusable[i].items[j].posters['99'] != 'undefined') {
                                var namePos = cursor.focusable[i].items[j].name.indexOf("&name=");
                                var name = cursor.focusable[i].items[j].name.substring(namePos + 6);
                                var linkTo = cursor.focusable[i].items[j].name.substring(0, namePos);
                                cursor.focusable[i].items[j] = {
                                    'name': name,
                                    'linkto': linkTo,
                                    'posters': o["data"][j].posters
                                };
                            }
                        }
                        if( <%=cat %> ){
                            var name = cursor.focusable[i].items[j].name;
                            var star = name.indexOf("：");  //不存在返回-1
                            star++;
                            var end = name.indexOf("（") <=0 ? name.length : name.indexOf("（");
                            cursor.focusable[i].items[j].name = name.substring(0,end);  //substring取前不取后
                        }
                    }
                }
                <%--var column = <%= inner.writeObject(column)%>;--%>
                <%--posters = column.posters['1'];--%>
                <%--bgImgs = column.posters['7'];--%>
                setTimeout(function(){ cursor.call('show');initList();cursor.call('getFocus');},150);
            },
            move : function(index){
                //上 11，下 -11，左 -1，右 1
                // if(cursor.enlarged ==1) return;
                switch (index) {
                    case 11:    //上
                        if( row > 1){
                            if (listBox.position > (ct-1) ){
                                cursor.call('loseFocus');
                                listBox.changeList(-ct);
                            }
                        }
                        break;
                    case -11:   //下
                        if( row > 1){
                            if ((listBox.position + ct) < listBox.dataSize ){
                                cursor.call('loseFocus');
                                listBox.changeList(ct);
                            }else if ( Math.floor(listBox.position/ct) < Math.floor((listBox.dataSize-1)/ct) ) {
                                cursor.call('loseFocus');
                                listBox.changeList(listBox.dataSize-1-listBox.position);
                            }
                        }
                        break;
                    case -1:    //左
                        if( row > 1){
                            if (listBox.focusPos%ct !=0){
                                cursor.call('loseFocus');
                                listBox.changeList(-1);
                            }
                        }else {
                            if( listBox.position > 0){
                                cursor.call('loseFocus');
                                listBox.changeList(-1);
                            }
                        }

                        break;
                    case 1:     //右
                        if( row > 1){
                            if (listBox.focusPos%ct !=ct-1 && listBox.position < listBox.dataSize-1){
                                cursor.call('loseFocus');
                                listBox.changeList(1);
                            }
                        }else {
                            if( listBox.position < listBox.dataSize-1){
                                cursor.call('loseFocus');
                                listBox.changeList(1);
                            }
                        }
                        break;
                }
                cursor.focusable[0].focus = listBox.position;
                scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
                cursor.call('getFocus');
            },
            lazyShow : function(){
                //var focus = listBox.position;
                var blocked = cursor.blocked;
                var focus = cursor.focusable[blocked].focus;
                var id = String( listBox.focusPos );
                var text = $('listName' + id).innerText;
                if ( text.indexOf("...") != -1 ) {
                    $('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + cursor.focusable[blocked].items[focus].name + '</marquee>';
                }
            },
            show : function(){
                for (var i = 0; i < row; i++) {
                    for (var j = 0; j < ct; j++) {
                        var id=i*ct + j;
                        $("list"+String(id)).style.visibility = 'visible';
                        $("list"+String(id)).style.left = <%=lt %>+j*(<%=wh + ml %>)+"px";
                        $("list"+String(id)).style.top = <%=tp %>+i*(<%=ht + mh +50 %>)+"px";
                        $("listName"+String(id)).style.top = <%=ht %>+"px";
                        <%--$("listName"+String(id)).style.top = <%=tp + ht %>+i*(<%=ht + mh +50 %>)+"px";--%>
                        <%--$("listName"+String(id)).style.left = <%=lt %>+j*(<%=wh + ml %>)+"px";--%>
                        $("listImg"+String(id)).src = "images/global_tm.gif";
                        $("list"+String(id)).style.backgroundColor = "transparent";
                    }
                }
            },
            getFocus : function(){
                var bc = "<%=bc %>";
                if( bc == "transparent"){
                    $("list"+String(listBox.focusPos)).style.backgroundColor = "<%=bc %>";
                }else {
                    $("list"+String(listBox.focusPos)).style.backgroundColor = "#<%=bc %>";
                }
                $("listName"+String(listBox.focusPos)).style.color = "#<%=fc %>";
                scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);
                cursor.call('lazyShow');
            },
            loseFocus : function(){
                var bo = "<%=bo %>";
                if( bo == "transparent"){
                    $("list"+String(listBox.focusPos)).style.backgroundColor = "<%=bo %>";
                }else {
                    $("list"+String(listBox.focusPos)).style.backgroundColor = "#<%=bo %>";
                }
                $("listName"+String(listBox.focusPos)).style.color = "#<%=cl %>";
                $("listName" + String(listBox.focusPos)).innerText = getStrChineseLength(listData[listBox.position].name) > maxTitleLen?subStr(listData[listBox.position].name,maxTitleLen,"..."):listData[listBox.position].name;
            },
        });
        function initList(){
            var blocked = cursor.blocked;
            listData = cursor.focusable[blocked].items;
            var pageCount = row*ct;
            var startPos = cursor.focusable[blocked].focus;
            listBox = new showList(pageCount,listData.length,startPos,127,window);
            listBox.showType =0 ;
            listBox.haveData = function(List){
                if ( typeof listData[List.dataPos].posters == "undefined"){
                    $("listImg"+String(List.idPos)).src = "images/defaultImg.png";
                }else {
                    if (typeof listData[List.dataPos].posters['1'] != 'undefined'){   //海报图
                        $("listImg"+String(List.idPos)).src = listData[List.dataPos].posters['1'][0];
                    }else if (typeof listData[List.dataPos].posters['5'] != 'undefined'){   //广告图
                        $("listImg"+String(List.idPos)).src = listData[List.dataPos].posters['5'][0];
                    }else if (typeof listData[List.dataPos].posters['99'] != 'undefined'){   //其他图
                        $("listImg"+String(List.idPos)).src = listData[List.dataPos].posters['99'][0];
                    }else {
                        $("listImg"+String(List.idPos)).src = "images/defaultImg.png";
                    }
                }
                $("listName"+List.idPos).innerText = getStrChineseLength(listData[List.dataPos].name) > maxTitleLen?subStr(listData[List.dataPos].name,maxTitleLen,"..."):listData[List.dataPos].name;
                $("listImg"+List.idPos).style.color = "transparent";
                var bo = "<%=bo %>";
                if( bo == "transparent"){
                    $("list"+String(List.idPos)).style.backgroundColor = "<%=bo %>";
                }else {
                    $("list"+String(List.idPos)).style.backgroundColor = "#<%=bo %>";
                }
                $("listName"+String(List.idPos)).style.color = "#<%=cl %>";
            }
            listBox.notData = function(List){
                $("listImg"+List.idPos).src = "images/global_tm.gif";
                $("listName"+List.idPos).innerText = "";
                $("list"+List.idPos).style.backgroundColor = "transparent";
            };
            listBox.startShow();
            if (row <= 1){
                scrollFlag = 0;
            }
            initScroll(listBox.dataSize,pageCount,listBox.listPage);
        }
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200414ListBg.jpg)" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="focus" style="position: absolute;width: 319px;height: 197px;left: 148px;top: 178px; overflow:hidden; background: url('images/J20200414ListFocus.png') no-repeat; visibility: hidden; z-index: 1;" ></div>
<%--<div id="scroll" style="position: absolute;width: 24px;height: 92px;left: 1206px;top: 150px; overflow:hidden; background: url('images/J20200414ListScroll.png') no-repeat; visibility: visible;" ></div>--%>
<div id="scrollLower" style="z-index: 1; ">
    <div id="scrollUpper" style="z-index: 2;"></div>
</div>
<div id="list">
    <div id="list0" class="list">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="list">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName"></div>
    </div>
    <div id="list5" class="list">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName"></div>
    </div>
    <div id="list6" class="list">
        <img id="listImg6" class="listImg"/>
        <div id="listName6" class="listName"></div>
    </div>
    <div id="list7" class="list">
        <img id="listImg7" class="listImg"/>
        <div id="listName7" class="listName"></div>
    </div>
    <div id="list8" class="list">
        <img id="listImg8" class="listImg"/>
        <div id="listName8" class="listName"></div>
    </div>
    <div id="list9" class="list">
        <img id="listImg9" class="listImg"/>
        <div id="listName9" class="listName"></div>
    </div>
    <div id="list10" class="list">
        <img id="listImg10" class="listImg"/>
        <div id="listName10" class="listName"></div>
    </div>
    <div id="list11" class="list">
        <img id="listImg11" class="listImg"/>
        <div id="listName11" class="listName"></div>
    </div>
</div>
</body>
</html>