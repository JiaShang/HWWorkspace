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
    </style>3000000720150126000300-30000007
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
        String strId = request.getParameter("id");
        String type = request.getParameter("tp");
        ServiceHelp metaHelper = new ServiceHelp(request);
        List<Vod> list = searchList(metaHelper,strId,0,100,0,SearchType.FOREIGNSN);
        for(Vod vod : list)
            out.write(vod.getName() + ":" + vod.getId() + "<br/>");
    %>
</div>
</body>
</html>
