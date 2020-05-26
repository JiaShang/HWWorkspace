<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.net.io.Util" %>
<%@ include file="../../util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String parentId = "10000100000000090000000000106149";
    String id = request.getParameter("id");
    String tp = request.getParameter("tp");
    String pg = request.getParameter("page");
    String size = request.getParameter("size");
    String max = request.getParameter("max");
    String ls = request.getParameter("list");

    int st = StringUtils.isEmpty( pg ) ? 0 : Integer.parseInt( pg );
    int sz = StringUtils.isEmpty( size ) ? 10 : Integer.parseInt( size );
    int mx = StringUtils.isEmpty( max ) ? 36 : Integer.parseInt( max );
    String name = "";
    MetaData helper = new MetaData(request);
    if ( !StringUtils.isEmpty(tp) ) {
        if( tp.equalsIgnoreCase("vod")  ) {
            List<?> list = getVodList( helper, id, 999, 0);
            int l = list == null ? 0 : list.size();
            out.clear();
            out.print("({length:" + l  + ",typeId:\"" + id + "\", items: [");
            for( int i = st * sz; i < ( st + 1 ) * sz && i < list.size(); i++ ){
                Vod vod = (Vod)list.get(i);
                vod.setName(vod.getName());
                out.print("{mid:" + vod.getId() + ",");
                out.print("text:\"" + vod.getName().replaceAll("\"","&qute;") + "\",");
                out.print("length:" + StringUtil.length( vod.getName() ) + ",");
                out.print("shortText:\"" + StringUtil.limitStringLength( vod.getName(), mx ).replaceAll("\"","&qute;") + "\",");
                out.print("playType:" + vod.getIsSitcom() );
                if(! StringUtils.isEmpty( ls ))
                    out.println(",picture:\"" + Utils.pictureUrl("images/defaultImgList.jpg",vod.getPosters(),"1", request ) + "\"");
                out.print("}" + (( i + 1 < ( st + 1 ) * sz) && ( i + 1 < list.size() ) ? "," : ""));
            }
            out.print("]");
            String pic = request.getParameter("pic");
            if( ! StringUtils.isEmpty( pic )) {
                String col = request.getParameter("col");
                String picture = StringUtils.isEmpty( col ) ? "" : ("images/defaultImgColumn" + col + ".jpg");
                Column column = getDetailInfo(helper, id, new Column() );
                if( column != null ) {
                    picture = Utils.pictureUrl( picture, column.getPosters(), "5", request);
                    name = column.getName().replaceAll("\"","&qute;");
                }
                out.print(",picture:\"" + picture + "\"");
            }
            out.print(",name:\"" + name + "\"");
            out.print("});");
        }
    } else {
        if( tp.equalsIgnoreCase("vod")  ){
            out.print("({length:0,typeId:\"" + id + "\", items: [], name:\"\"");
            String pic = request.getParameter("pic");
            if( ! StringUtils.isEmpty( pic )){
                String col = request.getParameter("col");
                out.print(",picture:\"images/defaultImgColumn" + col + ".jpg\"");
            }
            out.print("});");
        }
    }
%>