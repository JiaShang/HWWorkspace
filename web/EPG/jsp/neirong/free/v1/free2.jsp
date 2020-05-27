<%@ page language="java" import="com.huawei.iptvmw.epg.bean.MetaData" pageEncoding="UTF-8" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%!
    /**
     *
     * @param posterMap
     * @param type  //图片类型有:  0 缩略图，1 海报 ，2 剧照 ，3 图标, 4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ， 10 频道名字图片 ， 11 其他
     * @param index
     * @return
     */
    private String getPicture(Object posterMap, int type, int index) {
        String defaultPic = "../../neirong/images/default_preview_lb.png";
        //如果没有取到任何图片时,返回一张默认图片.
        if (posterMap == null) {
            return defaultPic;
        } else {
            Map posterPath = (HashMap) posterMap;
            //图片类型有:  0 缩略图，1 海报 ，2 剧照 ，3 图标, 4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ， 10 频道名字图片 ， 11 其他
            String[] picArray = (String[]) posterPath.get(String.valueOf(type));
            //每一种图片可能会传多个图片,如果传多个图片时 index 值有效,
            //默认取第一张图片. 索引下村为:  0, 当 index = 1时,表示取第二张图片
            //此下标 和 后台无关,后台可以设置图片顺序,实际使用时, 如果只上传一张图片,即使后台上传图片时设置 大于 1的顺序时, 也用 0 来取.
            if (null == picArray || picArray.length <= index) return defaultPic;
            return picArray[index];
        }
    }

    private void print(JspWriter out, String message) {
        try {
            out.println("<!-- " + message + " -->");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
%>
<%

    String typeId = request.getParameter("typeId");
    String pageNoStr = request.getParameter("page");
    if (pageNoStr == null || page.equals("")) {
        pageNoStr = "1";
    }

    int pageNo = Integer.valueOf(pageNoStr);//当前页码
    int perPageSize = 12;//每页项数
    int offset = perPageSize * (pageNo - 1);//偏移量

    MetaData meta = new MetaData(request);
    TurnPage turnPage = new TurnPage(request);
    try {
        String fcr = request.getParameter("ifcor");
        String playBack = request.getParameter("for_play_back");
        if (null == playBack) {
            if (null == fcr) {
                turnPage.addUrl();
            } else {
                turnPage.removeLast();
                turnPage.addUrl();
            }
        } else {
            turnPage.removeLast();
        }
    } catch (Exception e) {
    }

    List result = meta.getVodListByTypeId(typeId, perPageSize, offset);//接口2.11

    Map map1 = (result != null && result.size() > 0) ? (Map) result.get(0) : null;
    int total = map1 != null ? Integer.valueOf(map1.get("COUNTTOTAL").toString()) : 0;//总项数
    int pageSize = total / perPageSize + ((total % perPageSize == 0) ? 0 : 1);//总页数
    boolean hasPrevious = pageNo > 1 ? true : false;//是否有上一页
    boolean hasNext = pageSize > pageNo ? true : false;//是否有下一页
    int nextPage = pageNo + 1 > pageSize ? pageSize : pageNo + 1;
    int previousPage = pageNo > 1 ? pageNo - 1 : 1;

    List vodList = (result != null && result.size() > 1) ? (List) result.get(1) : Collections.emptyList();

    String typeName = "";
    if (typeId.equals("10000100000000090000000000108722")) {
        typeName = "纪实";
    } else if (typeId.equals("10000100000000090000000000108723")) {
        typeName = "电影";
    } else if (typeId.equals("10000100000000090000000000108724")) {
        typeName = "电视剧";
    } else if (typeId.equals("10000100000000090000000000108725")) {
        typeName = "综艺";
    } else if (typeId.equals("10000100000000090000000000108806")) {
        typeName = "少儿";
    }

    String filePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/" + "jsp/";
    Map typeMap = meta.getTypeInfoByTypeId(typeId);//接口2.14
    String titleName = typeMap.get("INTRODUCE") == null ? "" : typeMap.get("INTRODUCE").toString();

    for (int i = 0; i < vodList.size(); i++) {
        Map vodMap = (Map) vodList.get(i);
        String defaultPath = getPicture(vodMap.get("POSTERPATHS"), 1, 0);
        defaultPath = filePath + defaultPath.replace("../../", "");
        vodMap.put("PICPATH", defaultPath);
    }
%>
<!doctype html>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <meta charset="utf-8">
    <title>免费专区1</title>
    <style media="screen">
        body,
        div {
            padding: 0px;
            margin: 0px;
        }

        #kuang0 {
            position: absolute;
            border: 2px solid #fff;
            width: 136px;
            height: 41px;
            left: 1054px;
            top: 12px;
            border-radius: 50px;
            display: none;
        }

        #kuang1 {
            position: absolute;
            left: -8px;
            top: 40px;
            z-index: 99;
        }

        #kuang1 div {
            position: relative;
            top: -36px;
            text-align: center;

        }

        .top-bg {
            position: absolute;
            top: 0;
            left: 0;
            z-index: 99;
        }

        .logo {
            position: absolute;
            top: 30px;
            left: 86px;
        }

        .new-title {
            position: absolute;
            top: 32px;
            left: 216px;
            font-size: 18px;
            color: #BCCDF9;
        }

        .jifen-logo {
            position: absolute;
            top: 26px;
            left: 1058px;
        }

        #main {
            height: 648px;
            width: 1280px;
            overflow: hidden;
            position: absolute;
            top: 90px;
            left: 0px;
        }

        #title {
            position: absolute;
            font-size: 20px;
            color: #fff;
            left: 88px;
            width: 100px;
        }

        .page {
            position: absolute;
            left: 1126px;
            font-size: 20px;
            color: #BEC4E6;
            width: 100px;
        }

        #page span {
            color: #fff;
        }

        #f1 span, #f2 span, #f3 span, #f4 span, #f5 span, #f6 span, #f7 span, #f8 span, #f9 span, #f10 span, #f11 span, #f12 span {
            position: relative;
        }

        #f1 span div, #f2 span div, #f3 span div, #f4 span div, #f5 span div, #f6 span div, #f7 span div, #f8 span div, #f9 span div, #f10 span div, #f11 span div, #f12 span div {
            position: absolute;
            height: 32px;
            line-height: 32px;
            background: rgba(0, 0, 0, 0.5);
            text-align: center;
            bottom: 16px;
            left: 9px;
            width: 157px;
            color: #fff;
        }

        .content {
            width: 193px;
            height: 275px;
            position: absolute;
        }

        .contentImg {
            width: 181px;
            height: 223px;
            position: absolute;
            left: 6px;
            top: 7px;
        }

        .opacity {
            width: 181px;
            height: 32px;
            position: absolute;
            left: 6px;
            bottom: 45px;
            background: url("images/free/opacity.png") no-repeat;
            text-align: center;
            line-height: 32px;
            color: white;
        }

        .kuangImg {
            width: 193px;
            height: 275px;
            position: absolute;
            top: 0;
            left: 0;
            visibility: hidden;
        }

        .contentText {
            width: 100%;
            text-align: center;
            color: black;
            position: absolute;
            left: 0;
            bottom: 13px;
            visibility: hidden;
            height: 18px;
            overflow: hidden;
        }
    </style>
    <script type="text/javascript" language="javascript">
        try{
            function debug(message, recall) {
                message = "FREEJS :" + message;
                if( typeof console !== 'undefined' ) {
                    console.log (message);
                } else if( typeof iPanel !== 'undefined' ) {
                    iPanel.debug (message);
                }
            };
            var isP60 = typeof sysmisc != 'undefined';
            if( isP60 ) {
                var appendJS = function(path){
                    var script = document.createElement('script');
                    script.src = path;
                    script.type = 'text/javascript';
                    document.getElementsByTagName('head')[0].appendChild(script);
                };
                appendJS("js/bridge.js");
                appendJS("js/getUrl.js");
            }
        } catch( e ) {};
    </script>
</head>

<body background="images/free/bg.jpg" topmargin="0" leftmargin="0" bottommargin="0">
<div class="top-bg"><img src="images/free/top-bg.png" alt=""></div>
<div class="logo"><img src="images/free/logo.png" alt=""></div>
<div id="titleName" class="new-title"></div>
<%--<div class="jifen-logo"><img src="images/free/jifen.png" alt=""></div>--%>

<div id="kuang0"></div>

<div id="main">

    <div id="title"></div>
    <div class="page"><span id="page">1</span>/<span id="TotalPage">15页</span></div>

    <div id="content_1" class="content focus" style="left: 45px;top: 40px;visibility: hidden;">
        <img id="contentImg_1" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_1_opacity" class="opacity"></div>
        <img id="content_1_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_1_contentText" class="contentText"></div>
    </div>
    <div id="content_2" class="content focus" style="left: 245px;top: 40px;visibility: hidden;">
        <img id="contentImg_2" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_2_opacity" class="opacity"></div>
        <img id="content_2_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_2_contentText" class="contentText"></div>
    </div>
    <div id="content_3" class="content focus" style="left: 445px;top: 40px;visibility: hidden;">
        <img id="contentImg_3" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_3_opacity" class="opacity"></div>
        <img id="content_3_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_3_contentText" class="contentText"></div>
    </div>
    <div id="content_4" class="content focus" style="left: 645px;top: 40px;visibility: hidden;">
        <img id="contentImg_4" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_4_opacity" class="opacity"></div>
        <img id="content_4_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_4_contentText" class="contentText"></div>
    </div>
    <div id="content_5" class="content focus" style="left: 845px;top: 40px;visibility: hidden;">
        <img id="contentImg_5" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_5_opacity" class="opacity"></div>
        <img id="content_5_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_5_contentText" class="contentText"></div>
    </div>
    <div id="content_6" class="content focus" style="left: 1045px;top: 40px;visibility: hidden;">
        <img id="contentImg_6" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_6_opacity" class="opacity"></div>
        <img id="content_6_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_6_contentText" class="contentText"></div>
    </div>

    <div id="content_7" class="content focus" style="left: 45px;top: 330px;visibility: hidden;">
        <img id="contentImg_7" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_7_opacity" class="opacity"></div>
        <img id="content_7_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_7_contentText" class="contentText"></div>
    </div>
    <div id="content_8" class="content focus" style="left: 245px;top: 330px;visibility: hidden;">
        <img id="contentImg_8" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_8_opacity" class="opacity"></div>
        <img id="content_8_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_8_contentText" class="contentText"></div>
    </div>
    <div id="content_9" class="content focus" style="left: 445px;top: 330px;visibility: hidden;">
        <img id="contentImg_9" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_9_opacity" class="opacity"></div>
        <img id="content_9_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_9_contentText" class="contentText"></div>
    </div>
    <div id="content_10" class="content focus" style="left: 645px;top: 330px;visibility: hidden;">
        <img id="contentImg_10" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_10_opacity" class="opacity"></div>
        <img id="content_10_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_10_contentText" class="contentText"></div>
    </div>
    <div id="content_11" class="content focus" style="left: 845px;top: 330px;visibility: hidden;">
        <img id="contentImg_11" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_11_opacity" class="opacity"></div>
        <img id="content_11_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_11_contentText" class="contentText"></div>
    </div>
    <div id="content_12" class="content focus" style="left: 1045px;top: 330px;visibility: hidden;">
        <img id="contentImg_12" class="contentImg" src="/EPG/jsp/neirong/images/translateBg.png">
        <div id="content_12_opacity" class="opacity"></div>
        <img id="content_12_kuangImg" class="kuangImg" src="images/free/cheng-kuang.png">
        <div id="content_12_contentText" class="contentText"></div>
    </div>
</div>

<script src="js/global.js"></script>
<script>
    var typeId = '<%=typeId%>';
    var typeName = '<%=typeName%>';
    var titleName = '<%=titleName%>';
    var linkStr = '/EPG/jsp/neirong/free/v1/free2.jsp';
    var linkStr1 = '/EPG/jsp/neirong/free/v1/free.jsp?hide=1';
    var pageHolder = {
        pageNo: <%=pageNo%>,
        pageSize: <%=pageSize%>,
        hasPrevious: <%=hasPrevious%>,
        hasNext: <%=hasNext%>,
        nextPage: <%=nextPage%>,
        previousPage: <%=previousPage%>,
    }

    var vodArray = [];

    <% for(int i = 0; i < vodList.size(); i++){
        Map vodMap = (Map)vodList.get(i);
    %>
    vodArray.push({
        id: <%=vodMap.get("VODID").toString()%>,
        name: '<%=vodMap.get("VODNAME").toString()%>',
        pic: '<%=vodMap.get("PICPATH").toString()%>',
        isSitcom: '<%=vodMap.get("ISSITCOM").toString()%>'
    });
    <%} %>
    var moveBottom = 0;

    function current() {
        return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?url=";
    };

    function playMovie(item) {
        //top.window.location.href = current() + "/EPG/jsp/neirong/player/playerAd.jsp?typeId=" + typeId + "&playType=1" + "&progId=" + item.id + "&baseFlag=0&contentType=0&business=1";
        if ( isP60 ) { //P60的播放方式
            try {
                getRTSP(item.name, String(item.id), '-1', 1);
            } catch( e ) { };
        } else { // 3.0 和来点的播放调用
            //注释为贴片广告处理，暂未使用
            top.window.location.href = current() + "/EPG/jsp/neirong/player/playerAd.jsp?typeId=" + typeId + "&playType=1" + "&progId=" + item.id + "&baseFlag=0&contentType=0&business=1";
        }
    }

    window.onload = function () {
        if ( typeof iPanel === 'undefined') iPanel = { eventFrame : {} };
        tgo.init({});
        tgo.$keyEvent.up = function () {
            var nextFocus = tgo.focusMove({
                axis: 'y', direction: 'reduce'
            });
            if (nextFocus.style.visibility == "hidden") {
                return
            }
            if (nextFocus) {
                focus(nextFocus)
            }
            moveBottom++;
            if (pageHolder.hasPrevious && moveBottom % 2 == 1) {
//          router.replace({path:location.href,query:{pageNo:pageHolder.pageNo}});
//          window.location.reload();
                window.location.href = linkStr + '?page=' + pageHolder.previousPage + '&typeId=' + typeId;
            }
        };

        tgo.$keyEvent.down = function () {
            var nextFocus = tgo.focusMove({
                axis: 'y', direction: 'add'
            });
            if (nextFocus.style.visibility == "hidden") {
                return
            }
            if (nextFocus) {
                focus(nextFocus);
            }
            moveBottom++;
            if (pageHolder.hasNext && moveBottom % 2 == 0) {
//          router.replace({path:location.href,query:{pageNo:pageHolder.pageNo}});
                window.location.href = linkStr + '?page=' + pageHolder.nextPage + '&typeId=' + typeId;
//          window.location.reload();
            }
        };

        tgo.$keyEvent.left = function () {
            var nextFocus = tgo.focusMove({
                axis: 'x', direction: 'reduce'
            });
            if (nextFocus.style.visibility == "hidden") {
                return
            }
            if (nextFocus) {
                focus(nextFocus)
            }
        };

        tgo.$keyEvent.right = function () {
            var nextFocus = tgo.focusMove({
                axis: 'x', direction: 'add'
            });
            if (nextFocus.style.visibility == "hidden") {
                return
            }
            if (nextFocus) {
                focus(nextFocus)
            }
        };
        tgo.$keyEvent.back = function () {
            window.location.href = linkStr1;
        };

        tgo.$keyEvent.ok = function () {
            if (vodArray[tgo.currentFocus.title].isSitcom == 0) {
                playMovie (vodArray[tgo.currentFocus.title]); return;
            } else if (vodArray[tgo.currentFocus.title].isSitcom == 1) {
                var url = '';
                var detail = function(){
                    if( ! isP60 ) {
                        //注释为贴片广告
                        //top.window.location.href = current() + "/EPG/jsp/defaultHD/en/hddb/vod/tv_detail" + ( iPanel.eventFrame.systemId == undefined ? '_ad' : '')  + ".jsp?vodId=" + vodArray[tgo.currentFocus.title].id + "&typeId=" + typeId;
                        //top.window.location.href = current() + "/EPG/jsp/defaultHD/en/hddb/vod/tv_detail.jsp?vodId=" + vodArray[tgo.currentFocus.title].id + "&typeId=" + typeId;
                        top.window.location.href = current() + "/EPG/jsp/defaultHD/en/hddb/vod/tv_detail_ad.jsp?vodId=" + vodArray[tgo.currentFocus.title].id + "&typeId=" + typeId;
                    } else {
                        sysmisc.path_sav(location.href);
                        top.window.location.href = "http://aoh5.cqccn.com/h5_vod/vod/detail.html?vod_id=" + vodArray[tgo.currentFocus.title].id;
                    }
                };
                var sitcom = function( data ){
                    for (var i = 0; i < data.length; i++) {
                        var is = true;
                        if (vodArray[tgo.currentFocus.title].name == data[i].name) {
                            var link = data[i].url;
                            if (!link.startWith('http')) {
                                top.window.location.href = current() + link;
                            } else if (link.indexOf("wasu.cn/") > 0) {
                                top.window.location.href = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/Category.jsp?url=" + link;
                            } else {
                                url = '';
                                url = link;
                                url += url.indexOf("?") > 0 ? '&' : '?';
                                url += 'backURL=';
                                if (url.startWith("http://epgServer") && typeof iPanel != 'undefined') url = url.replace("http://epgServer", iPanel.eventFrame.pre_epg_url);
                                var requestUrl = window.location.href;
                                url += encodeURIComponent(requestUrl);
                                top.window.location.href = url;
                            }
                            is = false;
                            break;
                        }
                    }
                    if (is) detail();
                };
                url = '/EPG/jsp/defaultHD/en/hddb/hddb_topic_andr.txt';
                if( isP60 ) {
                    var cookie = '[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid', '') + '"}]';
                    url = sysmisc.getEnv('epg_address', '') + url;
                    //method,url,mediatype,header,body,success,fail
                    bridge.ajax('post', url, 'text/xml', cookie, '', function (resp) {
                        if( /\<html\>/g.test(resp) ) {
                            detail();
                            sysmisc.showToast('请求服务器异常!');
                        } else {
                            resp = resp.trim().replace(/[\r\n]/g, "");
                            resp = eval('(' + resp + ')');
                            sitcom(resp.data);
                        }
                    },function(){ sysmisc.showToast('请求服务器异常!'); });
                } else {
                    var xhr = new XMLHttpRequest();
                    xhr.open('get', url );
                    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                    xhr.onreadystatechange = function () {
                        if (xhr.readyState == 4 && xhr.status == 200) {
                            var data = xhr.responseText;
                            var length = data.length;
                            var start = data.indexOf("{");
                            data = data.substr(start, length - start);
                            data = eval('(' + data + ')');
                            sitcom(data.data);
                        }
                    };
                    xhr.send(null);
                }
            }
        };


        $("title").innerText = typeName;
        $("page").innerText = pageHolder.pageNo;
        $("TotalPage").innerText = pageHolder.pageSize;
        $("titleName").innerText = titleName.substring(0, 40);
        for (var i = 0; i < vodArray.length; i++) {
            loadContent(
                i + 1,
                vodArray[i].pic,
                vodArray[i].name,
                i
            );
        }
        tgo.currentFocus = $("content_1");
        focus(tgo.currentFocus);
    };

    function loadContent(num, imgUrl, str, skip) {
        $("content_" + num).style.visibility = "visible";
        $("contentImg_" + num).src = imgUrl;
        $("content_" + num + "_opacity").innerText = str.substring(0, 9);
        $("content_" + num + "_contentText").innerText = str;
        $("content_" + num).title = skip;
    }

    function focus(ele) {
        $(tgo.currentFocus.id + "_kuangImg").style.visibility = "hidden";
        $(tgo.currentFocus.id + "_contentText").style.visibility = "hidden";
        $(tgo.currentFocus.id + "_opacity").style.visibility = "visible";
        $(ele.id + "_opacity").style.visibility = "hidden";
        $(ele.id + "_kuangImg").style.visibility = "visible";
        $(ele.id + "_contentText").style.visibility = "visible";
        tgo.currentFocus = ele;
    }
</script>
</body>
</html>