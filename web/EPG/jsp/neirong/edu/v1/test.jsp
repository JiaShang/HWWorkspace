<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.net.io.Util" %>
<%@ include file="../../util/util.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");
    MetaData helper = new MetaData(request);
    Column column = getDetailInfo(helper,id, new Column());
    out.print("Id:" +  column.getId() + "<br/>" );
    out.print("Name:" +  column.getName() + "<br/>" );
    out.print("AddonType:" +  column.getAddonType() + "<br/>" );
    out.print("EndTime:" +  column.getEndTime() + "<br/>" );
    out.print("Introduce:" +  column.getIntroduce() + "<br/>" );
    out.print("Url:" +  column.getUrl() + "<br/>" );
    out.print("StartTime:" +  column.getStartTime() + "<br/>" );
%>