<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.net.io.Util" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");
    final Pattern pattern = Pattern.compile("[^\\d-]+");
    if(StringUtils.isEmpty(id) || pattern.matcher(id).find() ) {
        out.print( "{\"id\":-1,\"error\":\"id is not number\"}" );
        return;
    }

    MetaData helper = new MetaData(request);
    StringBuilder builder = new StringBuilder();
    if( id.length() > 10 ) {
        List<Vod> list = getVodList( helper, id, 999, 0);
        builder.append("[");
        for( int i = 0; i < list.size(); i++){
            Vod vod = list.get(i);
            builder.append("{\"id\":");
            builder.append(vod.id);
            builder.append(",\"name\":\"");
            builder.append(vod.getName().replaceAll("\"","&quot;"));
            builder.append("\",\"type\":");
            builder.append(vod.getIsSitcom());
            builder.append("}" + (i + 1 < list.size() ? ",":"") + "\r\n");
        }
        builder.append("]");
    } else {
        Film film = new Film();
        getDetailInfo(helper, id,film);
        builder.append("{\"id\":");
        builder.append(film.getId());
        builder.append(",\"name\":\"");
        builder.append(film.getName().replaceAll("\"","&quot;"));
        builder.append("\",\"type\":");
        builder.append(film.getIsSitcom());
        builder.append(",\"picpath\":\"");
        builder.append( Utils.pictureUrl("", film.getPosters(), "1", request) );
        builder.append("\",\"director\":\"");
        builder.append(StringUtils.isEmpty(film.getDirector()) ? "" : film.getDirector().replaceAll("\"","&quot;"));
        builder.append("\",\"actor\":\"");
        builder.append(StringUtils.isEmpty(film.getActor()) ? "" :film.getActor().replaceAll("\"","&quot;"));
        builder.append("\",\"introduce\":\"");
        builder.append(StringUtils.isEmpty(film.getIntroduce()) ? "" :film.getIntroduce().replaceAll("\"","&quot;"));
        builder.append("\"");
        if ( film.getIsSitcom() == 1 ){
            builder.append(",\"subvnumlist\":[");
            List list = helper.getSitcomList(id,200, 0);
            if (list != null && list.size() == 2 ) {
                list = (List) list.get(1);
                if( list != null && list.size() > 0 ) {
                    for ( int i = 0; i< list.size(); i++ )
                    {
                        Vod vod = Utils.parse( new Vod(), list.get(i));
                        builder.append("{\"id\":");
                        builder.append(vod.getId());
                        builder.append(",\"name\":\"");
                        builder.append(vod.getName().replaceAll("\"","&quot;"));
                        builder.append("\",\"js\":");
                        builder.append(i + 1);
                        builder.append("}" + (i + 1 < list.size() ? ",":"") + "\r\n");
                    }
                }
            }
            builder.append("]");
        }
        builder.append("}");
    }
    out.println(builder.toString());
%>