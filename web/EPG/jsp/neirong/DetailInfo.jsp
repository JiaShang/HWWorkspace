<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="page-view-size" content="1280*720">
    <title></title>
    <style>
        a {color: olivedrab;text-decoration: none;font-size: 16px;}
        ul{padding:0px; margin:0px;display:block; width:240px;float: left;}
        li{list-style:none;margin:0px;padding:0px;padding:4px 6px;width:239px;overflow:hidden;}
    </style>
    <script language="javascript" type="text/javascript">
        try {
            iPanel.eventFrame.initPage(window);
            E.is_HD_vod = true;
        } catch (e) {
        }
    </script>
</head>
<body style="margin:20px 40px;color: olivedrab;">
<div>
    <%
        String strId = "10000100000000010000000000903413";
        MetaData metaHelper = new MetaData(request);
        Film film = new Film();
        List<Vod> list = searchList(new ServiceHelp(request),strId,0,100,0,SearchType.FOREIGNSN);
        film = getDetailInfo(metaHelper, Integer.toString(list.get(0).getId()),film);
        out.write(film.getName() + ":" + film.getTags() + "<br/>");
    %>
</div>
</body>
</html>
