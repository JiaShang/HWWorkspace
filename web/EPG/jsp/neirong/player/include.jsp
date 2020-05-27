<%@ page import="java.io.IOException" %>
<%@ page import="java.net.URLDecoder" %>
<%@ include file="common.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%!
    InnerUtils inner = null;
    public final class ColumnInfo{
        private String typeId;
        private String name = null;
        private int station = 0;
        private int length = 99;

        public ColumnInfo(){}

        public ColumnInfo(String name, String typeId, int station, int length)  {
            this( typeId,station, length);
            this.setName(name);
        }

        public ColumnInfo(String typeId, int station, int length) {
            this.setTypeId(typeId);
            this.setStation(station);
            this.setLength(length);
        }

        public String getTypeId() {
            return typeId;
        }

        public void setTypeId(String typeId) {
            this.typeId = typeId;
        }

        public int getStation() {
            return station;
        }

        public void setStation(int station) {
            this.station = station;
        }

        public int getLength() { return length; }

        public void setLength(int length) {
            this.length = length;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }
    private List<Result> queryWithSubscribe(List<Vod> list){
        List<Result> results = new ArrayList<Result>();
        if( list != null)
        for(int j = 0; j < list.size(); j ++){
            Vod vod = list.get(j);
            if(isEmpty(vod.getRedirect())) continue;
            results.add(inner.getVodList(vod.getRedirect(),0,199));
        }
        return results;
    }
%>
<%
    inner = new InnerUtils(request, response);

    //必须要先添加当前页面路径,然后再执行 getBackUrl,否则返回顺序会出错!
    //HuaWeiSavedChche.
    String rmCache = inner.get("RMCache","");

    String backUrl = inner.get("rmChs");
    String[] rmChars = null;
    if( ! isEmpty(backUrl) ) {
        backUrl = URLDecoder.decode(backUrl, "UTF-8");
        int len = backUrl.length();
        rmChars = new String[(int)Math.floor( len / 2.0 )];
        for( int i = 0 ; i + 1 < len; i += 2 ) rmChars[ i / 2 ] = "\\" + backUrl.charAt(i) + ".*?" + "\\" + backUrl.charAt(i + 1);
    }
    backUrl = "";
    if( isEmpty( rmCache ) ) {
        inner.addCacheUrl();
        backUrl = inner.getBackUrl();
    } else {
        inner.turnPage.removeLast();
    }
    List<ColumnInfo> infos = new ArrayList<ColumnInfo>();
%>