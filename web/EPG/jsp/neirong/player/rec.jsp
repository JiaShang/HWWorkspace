<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelp" %>
<%@ page import="net.sf.json.util.PropertyFilter" %>
<%@ page import="net.sf.json.JsonConfig" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ include file="common.jsp" %>

<%!
    public class Channel {
    	/*录播节目编号*/
        @Define(name = "CHANNELID")
        private int channelId;
        /*录播节目名称*/
        @Define(name = "CHANNELNAME")
        private String channelName;
        /*录播时长*/
        @Define(name = "RECORDLENGTH")
        private int recordLen;
        /*频道序号*/
        @Define(name = "CHANNELINDEX")
        private int channelIndex;
        /*频道类型：1 视频 ，2 音频*/
        @Define(name = "CHANNELTYPE")
        private int channelType;

        public int getChannelId() {
            return channelId;
        }

        public void setChannelId(int channelId) {
            this.channelId = channelId;
        }

        public String getChannelName() {
            return channelName;
        }

        public void setChannelName(String channelName) {
            this.channelName = channelName;
        }

        public int getRecordLen() {
            return recordLen;
        }

        public void setRecordLen(int recordLen) {
            this.recordLen = recordLen;
        }

        public int getChannelIndex() {
            return channelIndex;
        }

        public void setChannelIndex(int channelIndex) {
            this.channelIndex = channelIndex;
        }

        public int getChannelType() {
            return channelType;
        }

        public void setChannelType(int channelType) {
            this.channelType = channelType;
        }
    }
    public class Program {
    	private String date;
    	private String startTime;
    	private String name;
    	private String endTime;
    	private String playUrl;
    	private String status;

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public String getStartTime() {
            return startTime;
        }

        public void setStartTime(String startTime) {
            this.startTime = startTime;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEndTime() {
            return endTime;
        }

        public void setEndTime(String endTime) {
            this.endTime = endTime;
        }

        public String getPlayUrl() {
            return playUrl;
        }

        public void setPlayUrl(String playUrl) {
            this.playUrl = playUrl;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }
    }
    private class RecReView{
        private HttpServletRequest request;
        private HttpServletResponse response;

        private MetaData metaData;
        private TurnPage turnPage;
        private ServiceHelp serviceHelp;


        private final JsonConfig JSConfig = new JsonConfig();

    	public RecReView( HttpServletRequest request, HttpServletResponse response ){
    		this.request = request;
    		this.response = response;
            metaData = new MetaData(request);
            turnPage = new TurnPage(request);
            serviceHelp = new ServiceHelp(request);

            JSConfig.setJsonPropertyFilter(new PropertyFilter() {
                public boolean apply(Object source, String name, Object value) {
                if (value == null || value instanceof String && ((String) value).equals("") || value instanceof List && ((List) value).size() == 0 || value instanceof Map && ((Map) value).size() == 0 ) {
                    return true;
                }
                return false;
                }
            });
        }
        private String get(String parameter) {
            return get(parameter, "");
        }

        private String get(String parameter, String defaultValue) {
            String value = request.getParameter(parameter);
            return isEmpty(value) ? defaultValue : value;
        }

        private void resetResponseHeader(){
            response.reset();
            response.setCharacterEncoding("utf-8");
            response.setHeader("Content-Type", "application/json;charset=utf-8");
            if( !isEmpty( get("ISPCDBG") ) ){
                response.setHeader("Access-Control-Allow-Credentials","true");
                response.setHeader("Access-Control-Allow-Origin",get("DBGHOST"));
            }
        }

        public void getChannels(){
    		List<Channel> channels = new ArrayList<Channel>();
            PrintWriter writer = null;
            resetResponseHeader();
            try {
                writer = response.getWriter();
                List list = metaData.getRecChan(999, 0);
                if (list == null || list.size() != 2) {
                    writer.write("/*①无法获得数据列表!*/");
                } else {
                    HashMap map = (HashMap) list.get(0);
                    int total = ((Integer) map.get("COUNTTOTAL")).intValue();
                    if ( total < 0 ) {
                        writer.write("/*①当前调用方式返回错误的结果, 总集数小于0!*/");
                    } else {
                        list = (List<?>) list.get(1);
                        if (list == null || list.size() == 0) {
                            writer.write("/*①获取记录列表时，返回数据为空!*/");
                        } else {
                            for(Object o : list) {
                                Channel channel = ReflectUtil.parse(o, new Channel());
                                channels.add( channel );
                            }
                            //JSONObject json = JSONObject.fromObject(channels, JSConfig);
                            JSONArray json = JSONArray.fromObject(channels, JSConfig);
                            writer.write(json.toString() );
                        }
                    }
                }
                writer.flush();
            } catch (Throwable e){
    			if( writer != null ) {
    				try {
    					e.printStackTrace(writer);
    					writer.flush();
                    } catch (Throwable x){}
                }
            }
        }

        private Program convertToProgram(String line){
    	    Program program = new Program();
            String[] parts = line.split( String.valueOf((char)0x7f) );
            if( parts.length > 6 ) {
                program.setDate( parts[0] );
                program.setStartTime( parts[1] );
                program.setName( parts[2] );
                program.setEndTime( parts[3] );
                program.setPlayUrl( parts[4] );
                program.setStatus( parts[parts.length - 2] );
            }
    	    return program;
        }

        private List<Program> getBills(int channelId){
            String[] array = metaData.getRecBill(channelId);
            List<Program> programs = new ArrayList();
            for( String line : array ){
            	programs.add( convertToProgram(line) );
            }
            return programs;
        }

        private Map getDetailInfo(int progId){
            return metaData.getProgDetailInfo( progId );
        }

        private void getProgram( int progId ) {
            resetResponseHeader();
            Program program = new Program();
            PrintWriter writer = null;
            try {
                Map map = getDetailInfo( progId );
                writer = response.getWriter();
                String time = String.valueOf(map.get("STARTTIME"));
                program.setDate(time.substring(0,4) + '-' + time.substring(4,6) + "-" + time.substring(6,8));
                program.setStartTime(time.substring(8,10) + ':' + time.substring(10,12) + ":" + time.substring(12));
                time = String.valueOf(map.get("ENDTIME"));
                program.setEndTime(time.substring(8,10) + ':' + time.substring(10,12) + ":" + time.substring(12));
                program.setName(String.valueOf(map.get("PROGRAMNAME")));
                program.setPlayUrl(String.valueOf(map.get("PROGRAMURL")));
                program.setStatus(String.valueOf(map.get("STATUS")));
                JSONObject json = JSONObject.fromObject(program, JSConfig);
                writer.write(json.toString() );
                writer.flush();
            } catch (Throwable e) {
                if( writer != null ) {
                    try {
                        e.printStackTrace(writer);
                        writer.flush();
                    } catch (Throwable x){}
                }
            }
        }

        private List<Program> getFilterBills(int channelId){
            String[] array = metaData.getRecBill(channelId);
            List<Program> programs = new ArrayList();
            for( String line : array ){
            	String[] parts = line.split( String.valueOf((char)0x7f) );
            	if( channelId == 50 && !parts[1].equalsIgnoreCase("19:00:00") || channelId == 312 && !parts[1].equalsIgnoreCase("18:30:00")) continue;
            	Program program = convertToProgram( line );
            	Map map = getDetailInfo( Integer.parseInt( parts[4] ) );
            	program.setPlayUrl( map.containsKey("PROGRAMURL") ? String.valueOf(map.get("PROGRAMURL")) : "" );
            	programs.add(0, program );
            }
            return programs;
        }

        public void getRecBills(String ids, boolean detail ){
            if( isEmpty(ids) ) return;
            PrintWriter writer = null;
            try {
                writer = response.getWriter();
                resetResponseHeader();
                String[] channelIds = ids.split("\\,");
                List list = new ArrayList();
                for(String channelId : channelIds){
                    if(isEmpty(channelId)) continue;
                    HashMap<String, List> map = new HashMap<String, List>();
                    if( !isNumber(channelId) ) {
                        map.put(channelId, new ArrayList());
                        continue;
                    }
                    int id = Integer.parseInt(channelId);
                    List<Program> programs = !detail && (id == 312 || id == 50) ? getFilterBills(id) : getBills(id);
                    map.put(channelId, programs);
                    list.add(map);
                }

                writer = response.getWriter();
                JSONArray json = JSONArray.fromObject(list, JSConfig);
                writer.write(json.toString() );
                writer.flush();
            } catch (Throwable e){
                if( writer != null ) {
                    try {
                        e.printStackTrace(writer);
                        writer.flush();
                    } catch (Throwable x){}
                }
            }
        }
    }
%>
<%
    /*
        参数说明：
            1. 如果不带参数，返回当前机顶盒可以进行回看的频道列表， 数组类型
            2. 如果 ids 不为空时，返回指定频道的回看节目单（7天）的数据, 当回看是 重庆卫视 312，中央一台时 50，仅返回新闻联播
                当ID是 473, 479,重庆卫视，CCTV-1时，且 detail 参数不为空时，返回这两个频道的全部节目单
            3. 当 progId 不为空时，查询单个节目的播出地址
    */
    RecReView reView = new RecReView(request, response);
    String ids = request.getParameter("ids");
    String progId = request.getParameter("progId");
    if( isEmpty( ids ) && isEmpty(progId) ) {
        reView.getChannels();
        return;
    }
    if( !isEmpty( progId ) ) {
        if( !isNumber( progId ) ) return;
        reView.getProgram( Integer.parseInt( progId ) );
        return;
    }
    reView.getRecBills(ids, !isEmpty( reView.get("detail")));
%>