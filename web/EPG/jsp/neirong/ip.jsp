<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    String ip = request.getHeader("X-Forwarded-For");
    String localAddr = "127.0.0.1";
    if (ip == null || ip.length() == 0 || ip.equalsIgnoreCase(localAddr) || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0 || ip.equalsIgnoreCase(localAddr) || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("WL-Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0 || ip.equalsIgnoreCase(localAddr) || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("HTTP_CLIENT_IP");
    }
    if (ip == null || ip.length() == 0 || ip.equalsIgnoreCase(localAddr) || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("HTTP_X_FORWARDED_FOR");
    }
    if (ip == null || ip.length() == 0 || ip.equalsIgnoreCase(localAddr) || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getRemoteAddr();
    }
    out.println( ip );
%>
</body>
</html>
