<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelp" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.lang.annotation.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="net.sf.json.util.PropertyFilter" %>
<%@ page import="net.sf.json.util.JSONUtils" %>
<%@ page import="java.io.*" %>

<%!
/**
 * 定义一个内部类 InnerUtils
 */
public final class Result {
    private String id = "";
    private boolean success = true;
    private String message = "";
    private Integer total = null;
    private Object data;

    public Result() {}

    public Result(String id) {
        this.setId(id);
    }

    public Result(String id, Object data) {
        this.setId(id);
        this.setSuccess(true);
        this.setData(data);
    }

    public Result(String id, String message) {
        this.setId(id);
        this.setSuccess(false);
        this.setData(null);
        this.setMessage(message);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        if (data == null) this.data = null;
        else if (JSONUtils.isArray(data)) {
            this.data = data;
        } else {
            List<Object> list = new ArrayList<Object>();
            list.add(data);
            this.data = data;
        }
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public Integer getTotal() {
        return total;
    }
}

final JsonConfig JSConfig = new JsonConfig();

public final class Rectangle {
    public int left = 0;
    public int top = 0;
    public int width = 0;
    public int height = 0;

    public Rectangle() {}

    @Override
    public String toString() {
        JSONObject json = JSONObject.fromObject(this, JSConfig);
        return json.toString();
    }
}

final static Pattern patternStringEmpty = Pattern.compile("^\\s{0,}$", Pattern.CASE_INSENSITIVE);

public final static boolean isEmpty(String str) {
    if (null == str || "NULL".equalsIgnoreCase(str)) return true;
    Matcher matcher = patternStringEmpty.matcher(str);
    return matcher.matches();
}

final static Pattern patternStringIsNumber = Pattern.compile("^\\d{1,}$", Pattern.CASE_INSENSITIVE);

public final static boolean isNumber(String str) {
    if (null == str) return false;
    Matcher matcher = patternStringIsNumber.matcher(str);
    return matcher.matches();
}

public final class InnerUtils {

    private HttpServletRequest request;
    private HttpServletResponse response;

    private String encoding = "utf-8";

    private String withId = null;
    private boolean special = false;
    private boolean withSubscribe = false;
    private boolean isDebug = false;
    private boolean isDetail = false;
    private int total = 0;

    private boolean initWithSubscribe = false;
    private boolean initWithSpecials = false;
    private HashMap<String, String> specials = new HashMap<String, String>();
    private HashMap<String, String> withs = new HashMap<String, String>();
    private HashMap<String, String> sitcoms = new HashMap<String, String>();
    protected MetaData metaData;
    protected TurnPage turnPage;

    public InnerUtils(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;

        metaData = new MetaData(request);
        turnPage = new TurnPage(request);
        isDebug = !isEmpty(get("debug"));
        isDetail = request.getRequestURI().endsWith("detail.jsp");

        JSConfig.setJsonPropertyFilter(new PropertyFilter() {
            public boolean apply(Object source, String name, Object value) {
            if (value == null || value instanceof String && ((String) value).equals("") || value instanceof List && ((List) value).size() == 0 || value instanceof Map && ((Map) value).size() == 0 ) {
                return true;
            }
            return false;
            }
        });
    }

    /**
     * 获取 URL 中的参数
     *
     * @param parameter
     * @return
     */
    public String get(String parameter) {
        return get(parameter, "");
    }

    public String get(String parameter, String defaultValue) {
        String value = request.getParameter(parameter);
        return isEmpty(value) ? defaultValue : value;
    }

    public int getInteger(String parameter) {
        return getInteger(parameter, 0);
    }

    public int getInteger(String parameter, int defaultValue) {
        String value = get(parameter);
        return isNumber(value) ? Integer.parseInt(value) : defaultValue;
    }

    public Rectangle getRectangle(String parameter) {
        String val = get(parameter);
        Rectangle rect = new Rectangle();
        if (!isEmpty(val)) {
            String[] values = val.split("\\,");
            rect.left = values.length <= 0 || !isNumber(values[0]) ? 0 : Integer.parseInt(values[0]);
            rect.top = values.length <= 1 || !isNumber(values[1]) ? 0 : Integer.parseInt(values[1]);
            rect.width = values.length <= 2 || !isNumber(values[2]) ? 0 : Integer.parseInt(values[2]);
            rect.height = values.length <= 3 || !isNumber(values[3]) ? 0 : Integer.parseInt(values[3]);
        }
        return rect;
    }

    public void setEncoding(String encoding) {
        this.encoding = encoding;
    }

    public String getBrowserInfo() {
        return isEmpty(request.getHeader("User-Agent")) ? "" : request.getHeader("User-Agent");
    }

    /**
     * 处理服务器暂存的，当前链接的数据
     */
    public void addCacheUrl() {
        //检测当前访问页　和　最后一个页面是否相同, 如果不相同
        String playBack = get("for_play_back");
        String fcr = get("ifcor");
        if (isEmpty(playBack)) {
            if (isEmpty(fcr)) turnPage.addUrl();
            else {
                turnPage.removeLast();
                turnPage.addUrl();
            }
        } else {
            turnPage.removeLast();
        }
    }

    public String getPreFoucs() {
        String value = "";
        String[] focus = turnPage.getPreFoucs() ;
        if( focus == null || focus.length == 0 ) {
            value = get("currFoucs");
            if( !isEmpty( value )) focus = value.split("\\,");
        }
        value = "";
        if (null != focus) {
            for (int i = 0; i < focus.length; i++) {
                value += focus[i] + (i + 1 >= focus.length ? "" : ",");
            }
        }
        return isEmpty(value) ? "" : value;
    }

    /**
     * 1. 首先检测是否包含 backURL参数,如果有,返回backURL
     * 2.
     */
    public String getBackUrl() {
        String url = request.getParameter("backURL");
        if (isEmpty(url)) url = turnPage.go(-1);
        return url;
    }

    /**
     * @param imagePath
     * @return
     */
    private final boolean pictureExist(String imagePath) {
        //拼接图片的服务器段路径
        String filePath = request.getRealPath("/jsp/" + imagePath);

        File image = new File(filePath);

        return (image.exists() && !image.isDirectory());
    }


    public final String pictureUrl(String defaultPath, Object urls, String type) {
        return pictureUrl(defaultPath, urls, type, 0);
    }

    /**
     * 如果取到图片路径，且物理上存在该图片，返回该图片路径<br>
     * 如果取到图片路径，但物理上不存在该图片，返回默认路径<br>
     * 如果取不到该图片路径，返回默认路径<br>
     *
     * @param defaultPath                                默认图片路径
     * @param type                                       目标图片类型  参数: 0 缩略图，1 海报 ，2 剧照 ，3 图标
     *                                                   4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ，
     *                                                   10 频道名字图片 ， 11 其他
     * @param index                                      在图片索引顺序
     * @param urls，可以是String，如果是String直接检测图片连接地址是否存在，否则按 typeId来检测地址是否存在
     * @return picPath 返回的路径
     */
    public final String pictureUrl(String defaultPath, Object urls, String type, int index) {
        //如果没有取到任何图片时,返回默认图片.
        if (urls == null) return defaultPath;
        String tempUri = "";

        Map posterPath = (HashMap) urls;

        //如果强制转换 urls 对象失败,返回默认图片
        if (null == posterPath) return defaultPath;

        //图片类型有:  0 缩略图，1 海报 ，2 剧照 ，3 图标, 4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ， 10 频道名字图片 ， 11 其他
        String[] picArray = (String[]) posterPath.get(type);
        if (null == picArray || picArray.length <= index) return defaultPath;
        tempUri = picArray[index];

        tempUri = tempUri.replace("../../", "");

        if (!pictureExist(tempUri)) return defaultPath;

        tempUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/" + "jsp/" + tempUri;
        return tempUri;
    }

    /**
     * 根据电视剧的子集，获取子集的外部ID
     * @param list
     * @return
     */
    public List getChildList( List list){
        List childList = null;
        if( list != null && list.size() > 0 ) {
        	childList = new ArrayList();
            debug("VOD.PARENTID.SIZE : ", list.size());
            for( int child = 0 ; child < list.size() && child < 100; child ++ ) {
                Vod v = getDetail(String.valueOf(list.get(child)), new Vod());
                childList.add(v.getCode());
            }
        }
        return childList;
    }

    public void getParentId(Object item){
        String parentId = String.valueOf( ReflectUtil.getValue( item, "parentVodId") );
        if( ! ( isEmpty( parentId ) || parentId.equalsIgnoreCase("-1") ) ) {
            if( sitcoms.containsKey( parentId ) ) {
            	ReflectUtil.setField( item,"parentVodId", sitcoms.get( parentId ) );
            } else {
                Vod p = getDetail( parentId , new Vod());
                sitcoms.put( parentId, p.getCode() );
                ReflectUtil.setField( item,"parentVodId", p.getCode() );
            }
        }
    }

    public List getAllChildList(List<Vod> list){
    	for( int i = 0 ; list != null && i < list.size(); i ++ ){
            if( !isDetail || list.get(i).isSitcom != 1) continue;
            list.get(i).setChildrenList( getChildList( list.get(i).getChildrenList() ) );
        }
    	return list;
    }

    public Result getTypeDetail(String id) {
        return new Result(id, getDetail(id, new Column()));
    }

    /**
     * 获取指定栏目ID的 从 start 开始的 length 个字栏目
     *
     * @param typeId 栏目ID
     * @param start  开始位置
     * @param length 获取个数
     * @return
     */
    public Result getTypeList(String typeId, int start, int length) {
        Result result = new Result(typeId);
        try {
            List<Column> columns = getList(typeId, length, start, new Column());
            result.setSuccess(true);
            result.setData(columns);
        } catch (Throwable e) {
            result.setSuccess(false);
            result.setMessage(e.getMessage());
        }
        return result;
    }

    public Result getVodDetail(String id) {
        return getVodDetail(id, false);
    }

    public Result getVodDetail(String id, boolean isFSN) {
        Film film = new Film();
        film = !isFSN ? getDetail(id, film) : getFSNDetail(id, film);
        return new Result(id, film);
    }

    /**
     * 从栏目为 typeId 的栏目中,获取 从 start 开始,长度为 length 的 影片信息
     *
     * @param typeId
     * @param start
     * @param length
     * @return
     */
    public Result getVodList(String typeId, int start, int length) {
        Result result = new Result(typeId);
        try {
            List<Vod> vodList = getList(typeId, length, start, new Vod());
            result.setSuccess(true);
            result.setData(vodList);
        } catch (Throwable e) {
            result.setSuccess(false);
            result.setMessage(e.getMessage());
        }
        return result;
    }

    /**
     * @param id      栏目ID
     * @param length  单次查询记录的最大数量
     * @param station 从 station 参数指定位置开始获取影片列表
     * @return List 如果查询的结果是有效的结果,返回 有效结果的 List, 否则抛出异常
     */
    public <T> List<T> getList(String id, int length, int station, T t) {
        try {
            String[] clazzs = t.getClass().getName().split("\\$");
            String clazzName = clazzs[clazzs.length - 1];

            List<?> list = null;
            if (clazzName.equalsIgnoreCase("Vod")) {
                list = metaData.getVodListByTypeId(id, length, station);
            } else if (clazzName.equalsIgnoreCase("Column")) {
                list = metaData.getTypeListByTypeId(id, length, station);
            }

            if (list == null || list.size() != 2) {
                debug("①无法获得数据列表, 栏目ID：", id);
                return null;
            }

            HashMap map = (HashMap) list.get(0);
            total = ((Integer) map.get("COUNTTOTAL")).intValue();
            if ( total < 0 ) {
                debug("①当前调用方式返回错误的结果, 总集数小于0!");
                return null;
            }

            list = (List<?>) list.get(1);
            if (list.size() == 0) return null;

            List<T> results = new ArrayList<T>();

            /*****  初始化专题,系列剧  ********/
            if( this.special && ! this.initWithSpecials){
                try {
                    this.initWithSpecials = true;
                    String realPath = request.getRealPath("/jsp/defaultHD/en/hddb/hddb_topic_andr.txt");
                    File f = new File(realPath);
                    FileInputStream stream = new FileInputStream(f);
                    byte[] buffer = new byte[(int) f.length()];
                    stream.read(buffer, 0, buffer.length);
                    stream.close();
                    String fileContent = new String(buffer, "UTF-8");
                    JSONObject json = JSONObject.fromObject(fileContent);
                    JSONArray array = (JSONArray) json.get("data");
                    for (int i = 0; i < array.size(); i++) {
                        JSONObject element = (JSONObject) array.get(i);
                        String name = element.get("name").toString();
                        String link = element.get("url").toString();
                        this.specials.put(name, link);
                    }
                } catch (Throwable e) {
                    write(e.getMessage());
                }
            }

            if( this.withSubscribe && !this.initWithSubscribe){
                this.initWithSubscribe = true;
                List<Column> columns = getList(this.withId, 200, 0, new Column());
                for (Column column : columns) {
                    this.withs.put(column.getName(), column.getId());
                    this.debug("Subscribe:" ,column.getName() ,":", column.getId());
                }
            }

            /********* 结束初始化专题,系列剧 *************/
            for (int i = 0; i < list.size(); i++) {
                T x = (T) ((Bean) t).instance();
                x = ReflectUtil.parse(list.get(i), x);
                if (clazzName.equalsIgnoreCase("Vod")) {
                    Vod vod = (Vod) x;//sitcoms
                    if( isDetail ) {
                    	if( vod.isSitcom == 1 ){
                            //如果是电视剧，保存短ID， 和长ID
                            sitcoms.put( String.valueOf( vod.getId() ), vod.getCode() );
                            vod.setChildrenList( getChildList( vod.getChildrenList() ) );
                        } else {
                            getParentId(vod);
                        }
                    }
                    debug("withSubscribe:" ,withSubscribe ,":", vod.getName());
                    if (special && specials.containsKey(vod.getName())) {
                        vod.setLinkto(String.valueOf(specials.get(vod.getName())));
                    } else if (withSubscribe && withs.containsKey(vod.getName())) {
                        vod.setRedirect(String.valueOf(withs.get(vod.getName())));
                    }
                    results.add((T) vod);
                } else if (special && clazzName.equalsIgnoreCase("Column")) {
                    Column column = (Column) x;
                    if (specials.containsKey(column.getName())) {
                        column.setLinkto(String.valueOf(specials.get(column.getName())));
                    }
                    results.add((T) column);
                } else {
                    results.add(x);
                }
            }
            return results;
        } catch (Throwable e){
        	/*
        	try {
                ByteArrayOutputStream output = new ByteArrayOutputStream();
                e.printStackTrace(new PrintStream(output));
                output.flush();
                debug("程序出现错误, 详细信息：", output.toString("UTF-8"));
                output = null;
            } catch (Throwable x){}
            */
        }
        return null;
    }

    private List<?> getList(String id, int length, int station, boolean isVod) throws IllegalResultException {
        return getList(id, length, station , isVod ? new Vod() : new Column());
    }

    /**
     * @param name 影片名称
     * @param asSubVod 是否包括子集
     * @param searchType 1：影片名称（代码），2：影片名称（汉字或字母），3：按演员名称， 4:导演, 5：外部ID, 6:按演员搜索代码
     * @return
     * @throws Throwable
     */
    private List search(String name, int asSubVod, int searchType) throws Throwable {
        return search( name, 2, 999, 0, searchType );
    }

    /**
     * @param name 影片名称
     * @param asSubVod 是否包括子集
     * @param start 查询的起始位置
     * @param length 单次查询最大数量
     * @param searchType 1：影片名称（代码），2：影片名称（汉字或字母），3：按演员名称， 4:导演, 5：外部ID, 6:按演员搜索代码
     * @return
     * @throws Throwable
     */
    private List search(String name, int start, int length, int asSubVod, int searchType) throws Throwable {
        ServiceHelp helper = new ServiceHelp(request);

        List list = null;
        if (searchType == SearchType.FILMNAME)
            list = helper.searchFilmsByName(name, start, length, asSubVod);
        else if (searchType == SearchType.FILMCODE)
            list = helper.searchFilmsByCode(name, start, length, asSubVod);
        else if (searchType == SearchType.ACTOR)
            list = helper.searchFilmsByActor(name, start, length, asSubVod);
        else if (searchType == SearchType.DIRECTOR)
            list = helper.searchFilmsByDirector(name, start, length, asSubVod);
        else if (searchType == SearchType.FOREIGNSN)
            list = helper.searchFilmById(name);
        else if (searchType == SearchType.CASTCODE)
            list = helper.searchCastByCastCode(name, start, length);

        if (list == null || list.size() == 0) return null;
        if (list.size() != 2) {
            debug("②无法获得数据列表!");
            return null;
        }
        HashMap map = (HashMap) list.get(0);
        total = ((Integer) map.get("COUNTTOTAL")).intValue();
        if ( total <= 0 ) {
        	debug("②当前调用方式返回错误的结果, 总集数小于0!");
        	return null;
        }

        list = (List<?>) list.get(1);
        List results = new ArrayList();
        for (int i = 0; i < list.size(); i++) {
            results.add(ReflectUtil.parse(list.get(i), new Vod()));
        }
        return results;
    }

    /**
     * 获取影片或栏目的详细信息
     *
     * @param id
     * @param t
     * @return
     */
    public <T> T getDetail(String id, T t) {
        try {
            Map map = null;
            String className = t.getClass().getSimpleName();
            //如果是影片，需要查询子集的ID
            if ( className.equalsIgnoreCase("Vod") || className.equalsIgnoreCase("Film") ) {
                map = metaData.getVodDetailInfo(Integer.parseInt(id));
                if( map == null || map.size() == 0) return  null;
                t = ReflectUtil.parse(map, t);
                if( isDetail ) {
                	if( String.valueOf(ReflectUtil.getValue( t, "isSitcom")).equalsIgnoreCase("1") ){
                        sitcoms.put(String.valueOf(ReflectUtil.getValue( t, "id")), String.valueOf(ReflectUtil.getValue( t, "code")));
                        List children = getChildList( (List) ReflectUtil.getValue( t, "childrenList") );
                        ReflectUtil.setField(t, "childrenList", children );
                    } else {
                        getParentId( t );
                    }
                }
                return t;
            }
            //如果是栏目，直接返回
            map = metaData.getTypeInfoByTypeId(id);
            return map == null || map.size() == 0 ? null : ReflectUtil.parse(map, t);
        } catch (Throwable e) { }
        return null;
    }

    /**
     * 获取影片或栏目的详细信息
     *
     * @param id
     * @param t
     * @return
     */
    public <T> T getFSNDetail(String id, T t) {
        try {
            Map map = metaData.getContentDetailInfoByForeignSN(id, 0);
            if( map == null || map.size() == 0) return  null;
            t = ReflectUtil.parse(map, t);
            String className = t.getClass().getSimpleName();
            if( isDetail && ( className.equalsIgnoreCase("Vod") || className.equalsIgnoreCase("Film") ) ) {
                List children = getChildList( (List) ReflectUtil.getValue( t, "childrenList") );
                if( children != null ) ReflectUtil.setField(t, "childrenList", children );
            }
            return t;
        } catch (Throwable e) { }
        return null;
    }

    /**
     * 获取影片或栏目的详细信息
     *
     * @param id
     * @return
     */
    public Map getDetail(String id, boolean isVod) {
        try {
            return isVod ? metaData.getVodDetailInfo(Integer.parseInt(id)) : metaData.getTypeInfoByTypeId(id);
        } catch (Throwable e) {
        }
        return null;
    }

    public void write(Result result) {
        write(result, true);
    }

    public void write(Result result, boolean withHeader) {
        if (withHeader) setJsonHeader(encoding);
        write(resultToString(result));
    }

    public String writeObject(Object obj, String[] regexStrs ) {
        String resultStr = "";
        try {
            JSONObject json = JSONObject.fromObject(obj, JSConfig);
            resultStr = json.toString();

            if (!isEmpty(resultStr)) {
                String requestStr = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/" + "jsp/images/";
                resultStr = resultStr.replaceAll("\\.\\.\\/\\.\\.\\/images\\/", requestStr);
            }
            if( regexStrs != null && regexStrs.length > 0 ) {
                for(String regexStr : regexStrs ) {
                    if( isEmpty( regexStr) ) continue;
                    resultStr = resultStr.replaceAll(regexStr, "");
                }
            }
        } catch (Throwable e) {
            try {
                ByteArrayOutputStream stream = new ByteArrayOutputStream();
                PrintWriter pw = new PrintWriter(stream);
                e.printStackTrace(pw);
                pw.flush();
                pw.close();
                resultStr = stream.toString();
                stream.close();
            } catch (Throwable ex) {
            }
        }
        return resultStr;
    }

    public String writeObject(Object obj) {
       return writeObject(obj, null);
    }

    public String resultToString(Result result) {
        return writeObject(result, null);
    }

    public String resultToString(Result result, String[] arr) {
        return writeObject(result, arr);
    }

    public void write(String html) {
        try {
            PrintWriter writer = response.getWriter();
            writer.write(html);
            writer.flush();
        } catch (Throwable e) {
        }
    }

    public void setJsonHeader(String encoding) {
        response.reset();
        response.setCharacterEncoding(encoding);
        response.setHeader("Content-Type", "application/json;charset=" + encoding);
        if( !isEmpty( get("ISPCDBG") ) ){
            response.setHeader("Access-Control-Allow-Credentials","true");
            response.setHeader("Access-Control-Allow-Origin",get("DBGHOST"));
        }
    }

    public void setWithId(String typeId) {
        this.withId = typeId;
        withSubscribe = !isEmpty(typeId);
        this.debug("SET : withSubscribe", withSubscribe);
    }

    public void setSpecial(boolean special) {
        this.special = special;
    }

    public List getSitcomList(String vodId){
        return metaData.getSitcomList(vodId, 999, 0);
    }

    public void debug(Object... message) {
        if (!isDebug || message == null) return;
        StringBuilder builder = new StringBuilder();
        builder.append( isDetail ? "/**" : "<!--");
        for (int i = 0; i < message.length; i++) builder.append(message[i]);
        builder.append(isDetail ? "**/" : "-->\n");
        write(builder.toString());
    }
}

public final static class ReflectUtil {

    private final static HashMap<String, String> getDeclaredAnnotations(Class clazz) {
        HashMap<String, String> map = new HashMap<String, String>();
        Field[] fields = clazz.getDeclaredFields();
        for (Field field : fields) {
            if (field.isAnnotationPresent(Define.class)) {
                Define define = field.getAnnotation(Define.class);
                if (define != null && !map.containsKey(define.name())) {
                    map.put(define.name(), field.getName());

                    if (define.alias().equalsIgnoreCase("")) continue;
                    map.put(define.alias(), field.getName());
                }
            }
        }
        Class superClass = clazz.getSuperclass();
        if( !superClass.getSimpleName().equalsIgnoreCase("object") ){
        	map.putAll( getDeclaredAnnotations( superClass ));
        }
        return map;
    }

    private final static <T> T parse(Object item, T t) {

        HashMap<String, Object> hash = (HashMap) item;

        //以下为一种实例化方式,不过由于是内部的内部类,所以不适宜使用此方法
        //Class<T> clazz
        //T t = (T)clazz.instance();
        Class<?> clazz = t.getClass();

        HashMap<String, String> defines = getDeclaredAnnotations(clazz);
        if (hash != null && defines != null) {
            for (Map.Entry<String, String> entry : defines.entrySet()) {
                try {
                    //if(! map.containsKey(entry.getKey())) continue;
                    Field field = getField(clazz, entry.getValue());
                    Object value = hash.get(entry.getKey());

                    if (value == null) continue;

                    boolean accessible = field.isAccessible();
                    if (!accessible) field.setAccessible(true);

                    field.set(t, value);

                    field.setAccessible(accessible);
                } catch (Throwable e) {}
            }
        }
        return t;
    }

    public final static Object createInstance(Class<?> clazz) {
        try {
            Constructor<?> constructor = clazz.getDeclaredConstructor();
            Object record = constructor.newInstance();
            return record;
        } catch (Throwable e) {
        }
        return null;
    }

    public final static Field getField(Class clazz, String fieldName) {
        try {
            return clazz.getDeclaredField(fieldName);
        } catch (NoSuchFieldException e) {
            Class superClass = clazz.getSuperclass();
            if (superClass != null) return getField(superClass, fieldName);
            return null;
        }
    }

    public final static Object getValue( Object o , String fieldName) {
        return getValue(o, fieldName, null);
    }
    public final static Object getValue( Object o , String fieldName, InnerUtils inner) {
        try {
            Field field = getField( o.getClass(), fieldName );
            if( field == null ) return null;
            boolean accessible = field.isAccessible();
            if (!accessible) field.setAccessible(true);
            return field.get( o );
        } catch (Throwable e) { }
        return null;
    }

    public final static <T> boolean setField(T t, String fieldName, Object value) {
        try {
            if (t == null || isEmpty(fieldName)) return false;

            Class<?> clazz = t.getClass();
            Field field = getField(clazz, fieldName);
            if (field == null) return false;

            boolean accessible = field.isAccessible();
            field.setAccessible(true);
            field.set(Modifier.isStatic(field.getModifiers()) ? null : t, value);
            field.setAccessible(accessible);

            return true;
        } catch (Exception e) { }
        return false;
    }

    public final static <T> Object invoke(T t, String methodName, Object... args) {
        try {
            Class<?>[] parameterTypes = new Class<?>[0];
            Method method = null;
            if (args != null) {
                Class clazz = t.getClass();
                Method[] methods = clazz.getDeclaredMethods();
                int override = 0;
                for (Method mod : methods) {
                    if (mod.getName().equalsIgnoreCase(methodName) && args.length == mod.getParameterTypes().length) {
                        method = mod;
                        if (++override <= 1) continue;
                        method = null;
                        break;
                    }
                }
                if (method == null) {
                    parameterTypes = new Class<?>[args.length];
                    for (int i = 0; i < args.length; i++) {
                        parameterTypes[i] = args[i] == null ? Object.class : args[i].getClass();
                    }
                    method = getMethod(t.getClass(), methodName, parameterTypes);
                    for (int i = args.length - 1; i >= 0 && method == null; i--) {
                        parameterTypes[i] = Object.class;
                        method = getMethod(t.getClass(), methodName, parameterTypes);
                    }
                }
            } else {
                method = getMethod(t.getClass(), methodName, parameterTypes);
            }
            return method == null ? null : method.invoke(t, args);
        } catch (Exception e) {
        }
        return null;
    }

    public final static Method getMethod(Class clazz, String methodName, Class<?>... parameterTypes) {
        try {
            return clazz.getDeclaredMethod(methodName, parameterTypes);
        } catch (NoSuchMethodException e) {

            Class superClass = clazz.getSuperclass();
            if (superClass != null) return getMethod(superClass, methodName, parameterTypes);

            return null;
        }
    }

    public final static <T> T getEnumEntity(Class<T> T, Object value) {
        if (!T.isEnum()) return null;
        T[] items = T.getEnumConstants();
        T item = null;
        if (value.getClass().getName().equalsIgnoreCase("java.lang.String")) {
            String val = (String) value;
            for (T t : items) {
                if (!((Enum) t).name().equalsIgnoreCase(val)) continue;
                item = t;
                break;
            }
        } else {
            Number val = (Number) value;
            for (T t : items) {
                if (val.intValue() != ((Enum) t).ordinal()) continue;
                item = t;
                break;
            }
        }

        return item;
    }
}

@Target({ElementType.FIELD})
@Documented
@Retention(RetentionPolicy.RUNTIME)
public @interface Define {
    public abstract String name() default "";

    public String alias() default "";
}

public final class IllegalResultException extends Exception {
    public IllegalResultException(String message) {
        super(message);
    }
}

public interface Bean {
    Bean instance();

    String getName();

    Map<String, String[]> getPosters();
}

public final class Column implements Bean {
    @Define(name = "TYPE_ID")
    private String id;
    @Define(name = "TYPE_NAME")
    private String name;
    @Define(name = "TYPE_INTRODUCE")
    private String introduce;
    //@Define(name = "TYPE_PICPATH")
    //private String picture;
    @Define(name = "TYPE_URL")
    private String url;
    @Define(name = "SUBJECT_TYPE")
    private int childrenType;
    @Define(name = "POSTERPATHS")
    private Map<String, String[]> posters;
    @Define(name = "CUSTOMBUILDABLE")
    private int isCustom;
    @Define(name = "ADDONTYPE")
    private String addonType;
    @Define(name = "STARTTIME")
    private String startTime;
    @Define(name = "ENDTIME")
    private String endTime;
    @Define(name = "ISREQUIERDCOURSE")
    private String isRequiredCourse;

    private String linkto = null;

    public Column instance () {
        return new Column();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIntroduce() {
        return introduce;
    }

    public void setIntroduce(String introduce) {
        this.introduce = introduce;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public int getChildrenType() {
        return childrenType;
    }

    public void setChildrenType(int childrenType) {
        this.childrenType = childrenType;
    }

    public Map<String, String[]> getPosters() {
        return posters;
    }

    public void setPosters(Map<String, String[]> posters) {
        this.posters = posters;
    }

    public int getIsCustom() {
        return isCustom;
    }

    public void setIsCustom(int isCustom) {
        this.isCustom = isCustom;
    }

    public String getAddonType() {
        return addonType;
    }

    public void setAddonType(String addonType) {
        this.addonType = addonType;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getIsRequiredCourse() {
        return isRequiredCourse;
    }

    public void setIsRequiredCourse(String isRequiredCourse) {
        this.isRequiredCourse = isRequiredCourse;
    }

    public String getLinkto() {
        return linkto;
    }

    public void setLinkto(String linkto) {
        this.linkto = linkto;
    }
}

public class Vod implements Bean {
    @Define(name = "VODID", alias = "vodId")
    private int id = 0;
    @Define(name = "VODNAME", alias = "vodName")
    private String name;
    @Define(name = "CODE")
    private String code;
    @Define(name = "ISSITCOM")
    private int isSitcom;
    @Define(name = "RELFLAG")
    private int flag = 0;
    @Define(name = "POSTERPATHS")
    private Map<String, String[]> posters = null;
    @Define(name = "DEFINITION")
    private int definition;
    @Define(name = "FATHERVODID")
    private Object parentVodId;
    @Define(name = "CONTENTTYPE")
    private int contentType;
    @Define(name = "SUPVODIDSET")
    private HashSet parentVodList;
    @Define(name = "SUBVODIDLIST")
    private List childrenList;
    @Define(name = "SUBVODNUMLIST")
    private List childrenIdList;
    @Define(name = "STARTTIME")
    private String startTime;
    @Define(name = "ENDTIME")
    private String endTime;
    @Define(name = "VODPRICE")
    private String price;
    @Define(name = "TAGS")
    private String tags;
    @Define(name = "INTRODUCE")
    private String introduce;

    private String redirect = null;
    private String linkto = null;

    public Vod instance() {
        return new Vod();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIntroduce() {
        return introduce;
    }

    public void setIntroduce(String introduce) {
        this.introduce = introduce;
    }

    public int getFlag() {
        return flag;
    }

    public void setFlag(int flag) {
        this.flag = flag;
    }

    public int getIsSitcom() {
        return isSitcom;
    }

    public void setIsSitcom(int isSitcom) {
        this.isSitcom = isSitcom;
    }

    public Map<String, String[]> getPosters() {
        return posters;
    }

    public void setPosters(Map<String, String[]> posters) {
        this.posters = posters;
    }

    public int getDefinition() {
        return definition;
    }

    public void setDefinition(int definition) {
        this.definition = definition;
    }

    public List getChildrenList() {
        return childrenList;
    }

    public void setChildrenList(List childrenList) {
        this.childrenList = childrenList;
    }

    public List getChildrenIdList() {
        return childrenIdList;
    }

    public void setChildrenIdList(List childrenIdList) {
        this.childrenIdList = childrenIdList;
    }

    public String getRedirect() {
        return redirect;
    }

    public void setRedirect(String redirect) {
        this.redirect = redirect;
    }

    public String getLinkto() {
        return linkto;
    }

    public void setLinkto(String linkto) {
        this.linkto = linkto;
    }

    public Object getParentVodId() {
        return parentVodId;
    }

    public void setParentVodId(Object parentVodId) {
        this.parentVodId = parentVodId;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public HashSet getParentVodList() {
        return parentVodList;
    }

    public void setParentVodList(HashSet parentVodList) {
        this.parentVodList = parentVodList;
    }

    public int getContentType() {
        return contentType;
    }

    public void setContentType(int contentType) {
        this.contentType = contentType;
    }
}

public final class Film extends Vod implements Bean {
    @Define(name = "DIRECTOR")
    private String director;
    @Define(name = "ACTOR")
    private String actor;
    @Define(name = "ISASSESS")
    private int isAssess;
    @Define(name = "ASSESSID")
    private int assessId;
    @Define(name = "SERVICEID")
    private String[] serviceId;
    @Define(name = "AREAIDS")
    private int[] areas;
    @Define(name = "ELAPSETIME")
    private int elapseTime;
    @Define(name = "SEARCHCODE")
    private String searchCode;
    @Define(name = "CASTMAP")
    private Map<Integer, String[]> cast;
    @Define(name = "THEMENAMES")
    private String theme;
    @Define(name = "TYPE")
    private String type;
    @Define(name = "KEYWORDS")
    private String keywords;
    @Define(name = "SITCOMNUM")
    private int sitcomTotal;
    @Define(name = "allTypeId")
    private String[] allTypeId;
    @Define(name = "SPNAME")
    private String spName;

    public Film instance() {
        return new Film();
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getActor() {
        return actor;
    }

    public void setActor(String actor) {
        this.actor = actor;
    }

    public int getIsAssess() {
        return isAssess;
    }

    public void setIsAssess(int isAssess) {
        this.isAssess = isAssess;
    }

    public int getAssessId() {
        return assessId;
    }

    public void setAssessId(int assessId) {
        this.assessId = assessId;
    }

    public String[] getServiceId() {
        return serviceId;
    }

    public void setServiceId(String[] serviceId) {
        this.serviceId = serviceId;
    }

    public int[] getAreas() {
        return areas;
    }

    public void setAreas(int[] areas) {
        this.areas = areas;
    }

    public int getElapseTime() {
        return elapseTime;
    }

    public void setElapseTime(int elapseTime) {
        this.elapseTime = elapseTime;
    }

    public String getSearchCode() {
        return searchCode;
    }

    public void setSearchCode(String searchCode) {
        this.searchCode = searchCode;
    }

    public Map<Integer, String[]> getCast() {
        return cast;
    }

    public void setCast(Map<Integer, String[]> cast) {
        this.cast = cast;
    }

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getKeywords() {
        return keywords;
    }

    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    public int getSitcomTotal() {
        return sitcomTotal;
    }

    public void setSitcomTotal(int sitcomTotal) {
        this.sitcomTotal = sitcomTotal;
    }

    public String[] getAllTypeId() {
        return allTypeId;
    }

    public void setAllTypeId(String[] allTypeId) {
        this.allTypeId = allTypeId;
    }

    public String getSpName() {
        return spName;
    }

    public void setSpName(String spName) {
        this.spName = spName;
    }
}

public final static class SearchType {
    //影片名称（代码）
    public final static int FILMCODE = 1;
    //影片名称（汉字或字母）
    public final static int FILMNAME = 2;
    //按演员名称
    public final static int ACTOR = 3;
    //按演员搜索代码
    public final static int CASTCODE = 6;
    //导演
    public final static int DIRECTOR = 4;
    //外部ID
    public final static int FOREIGNSN = 5;
}
%>