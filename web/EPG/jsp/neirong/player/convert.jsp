<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="application/x-www-form-urlencoded;charset=UTF-8" language="java" %>
<%@ include file="include.jsp" %>
<%
    String txt = inner.get("txt");
    Result result = new Result();
    try {
        response.reset();
        if( !isEmpty( txt ) ) {
            result.message = new String(URLDecoder.decode(txt,"UTF-8").getBytes("UTF-8"), "GBK");
        }
    }catch (Throwable e){
        result.message = e.getMessage();
    }
    out.println(inner.resultToString(result));
    out.flush();
%>