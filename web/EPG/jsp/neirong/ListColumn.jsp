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
        String[] types = new String[]{"10000100000000090000000000104885", "10000100000000090000000000104585"};
        MetaData metaHelper = new MetaData(request);
        for( String type : types ){
            List<Vod> list = getVodList( metaHelper, type, 100, 0 );
            int i = 0;
            if(list == null || list.size() == 0)
            {
                out.write("无法获取内容(栏目ID:" + type + ")<br/><br/>");
                continue;
            }
            out.write("栏目ID:" + type + ")<br/>");
            for (Vod vod : list)
                out.write(vod.getName() + "&nbsp;(" + vod.getId() + ")&nbsp;&nbsp;&nbsp;");
            out.write("<br/><br/>");
        }
    %>
</div>
</body>
</html>
