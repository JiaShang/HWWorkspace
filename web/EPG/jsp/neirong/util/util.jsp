<%--
    公共函数类
--%>
<%@ page language="java" pageEncoding="GBK" %>
<%@ page import="java.lang.annotation.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.reflect.Field" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelp" %>
<%@ page import="org.apache.abdera.writer.StreamWriter" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="com.huawei.iptvmw.adc.bean.adm.Service" %>
<%@ page import="java.util.regex.Pattern" %>
<%!
    private final static String errorUrlRedirect = "/EPG/jsp/defaultHD/en/InforDisplay.jsp?ERRORCODE=014";
    protected String error;


    @Target({ElementType.FIELD})
    @Documented
    @Retention(RetentionPolicy.RUNTIME)
    public @interface Define {
        public abstract String name() default "";

        public String alias() default "";
    }

    public final static class StringUtil {
        /**
         * 将数组转换成字符串，简单起见应该用Arrays.toString(Object[] arr)
         * @param arrObjects    对象数组
         * @param joinString    隔开每个内容的字符串
         * @return 转换结果
         */
        private static String displayArray(final Object[] arrObjects, final String joinString) {
            StringBuilder sb = new StringBuilder();
            final String constStr = "『「（“‘([{《";
            for (int i = 0; i < arrObjects.length; i++) {
                sb.append(arrObjects[i]);
                if (i + 1 < arrObjects.length) sb.append(joinString);
            }
            String str = sb.toString();
            char ch = str.charAt(str.length() - 1);
            if (constStr.indexOf(ch) >= 0)
                str = str.substring(0, str.length() - 1);
            return str;
        }

        public static int length(final String src) {
            if (null == src || src.length() == 0) return 0;
            StringReader sr = new StringReader(src);
            try {
                int read = 0, count = 0;
                while ((read = sr.read()) != -1)
                    count += read < 256 ? 1 : 2;
                sr.close();
                return count;
            } catch (IOException e) {
                //e.printStackTrace();
                return 0;
            }
        }

        /***
         * 限制字符串长度（以字符长度为单位，不是字符个数。假设半角的长度为1，全角为2）
         * @param src 源字符串
         * @param maxByteCharLength 最大字符串长度
         * @return
         * @throws IOException
         */
        public static String limitStringLength(final String src, final int maxByteCharLength) {
            if (null == src || src.length() == 0) return src;

            StringReader sr = new StringReader(src);
            int read = 0;
            List<Character> arrayList = new ArrayList<Character>();
            int byteCharCount = 0, shortCharCount = 0;

            try {
                //循环完成后有三种情况，分隔符代表最长限制：	a|		啊|		口|阿
                while ((read = sr.read()) != -1) {
                    if (read < 256)
                        byteCharCount++;
                    else
                        shortCharCount++;

                    arrayList.add((char) read);
                    if (byteCharCount + (shortCharCount << 1) >= maxByteCharLength) {
                        read = sr.read();
                        break;
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

            int charLen = byteCharCount + (shortCharCount << 1);
            if (read != -1) {
                //后面还有字符，丢弃字符直到少于等于maxByteCharLength - endingStringByteLength位，补充endingString
                if (charLen > maxByteCharLength) {
                    arrayList.remove(arrayList.size() - 1);
                    arrayList.remove(arrayList.size() - 1);
                } else if (charLen == maxByteCharLength) {
                    if (arrayList.remove(arrayList.size() - 1) < 256) {
                        arrayList.remove(arrayList.size() - 1);
                    }
                }
                return displayArray(arrayList.toArray(), "");
            } else {
                if (charLen > maxByteCharLength) {
                    arrayList.remove(arrayList.size() - 1);
                    arrayList.remove(arrayList.size() - 1);
                    return displayArray(arrayList.toArray(), "");
                } else {
                    return displayArray(arrayList.toArray(), "");
                }
            }
        }
    }

    public final static class Utils {
        /**
         *  返回类中,带有 Define 描述 的字段
         * @param clazz
         * @return
         */
        public final static HashMap<String, String> getDeclaredAnnotations(Class clazz) {
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
            return map;
        }

        /**
         *
         * @param imagePath
         * @param request
         * @return
         */
        private final static boolean pictureExist(String imagePath, HttpServletRequest request) {
            //拼接图片的服务器段路径
            String filePath = request.getRealPath("/") + "jsp/" + imagePath;

            File image = new File(filePath);

            return (image.exists() && !image.isDirectory());
        }


        public final static String pictureUrl(String defaultPath, Object urls, String type, HttpServletRequest request) {
            return pictureUrl(defaultPath,urls,type,0,request);
        }

        /**
         * 如果取到图片路径，且物理上存在该图片，返回该图片路径<br>
         * 如果取到图片路径，但物理上不存在该图片，返回默认路径<br>
         * 如果取不到该图片路径，返回默认路径<br>
         *
         * @param defaultPath 默认图片路径
         * @param type 目标图片类型  参数: 0 缩略图，1 海报 ，2 剧照 ，3 图标
         * 4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ，
         * 10 频道名字图片 ， 11 其他
         * @param index 在图片索引顺序
         * @param urls，可以是String，如果是String直接检测图片连接地址是否存在，否则按 typeId来检测地址是否存在
         * @return picPath 返回的路径
         */
        public final static String pictureUrl(String defaultPath, Object urls, String type, int index, HttpServletRequest request) {

            //如果没有取到任何图片时,返回默认图片.
            if (urls == null) return defaultPath;
            String tempUri = "";

            Map posterPath = (HashMap) urls;

            //图片类型有:  0 缩略图，1 海报 ，2 剧照 ，3 图标, 4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ， 10 频道名字图片 ， 11 其他
            String[] picArray = (String[]) posterPath.get(type);
            if (null == picArray || picArray.length <= index) return defaultPath;
            tempUri = picArray[index];

            tempUri = tempUri.replace("../../", "");

            if (! pictureExist(tempUri, request))
                return defaultPath;

            tempUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/" + "jsp/" + tempUri;
            return tempUri;
        }


        public final static <T> T parse(T t, Object item) {

            HashMap<String, Object> hash = (HashMap) item;

            Class clazz = t.getClass();
            HashMap<String, String> defines = getDeclaredAnnotations(clazz);
            if (hash != null && defines != null) {
                for (Map.Entry<String, String> entry : defines.entrySet()) {
                    try {
                        //if(! map.containsKey(entry.getKey())) continue;
                        Field field = clazz.getDeclaredField(entry.getValue());
                        Object value = hash.get(entry.getKey());

                        if (value == null) continue;

                        boolean accessible = field.isAccessible();
                        if (!accessible)
                            field.setAccessible(true);

                        field.set(t, value);

                        field.setAccessible(accessible);
                    } catch (Throwable e) {
                    }
                }
            }
            return t;
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

    /**
     *  栏目信息
     */
    public class Column {
        @Define(name = "TYPE_ID")
        private String id;
        @Define(name = "TYPE_NAME")
        private String name;
        @Define(name = "TYPE_INTRODUCE")
        private String introduce;
        @Define(name = "TYPE_PICPATH")
        private String picture;
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

        /**
         * 子栏目ID
         */
        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * 子栏目名称
         */
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        /**
         * 子栏目介绍
         */
        public String getIntroduce() {
            return introduce;
        }

        public void setIntroduce(String introduce) {
            this.introduce = introduce;
        }

        /**
         * 子栏目对应的图片
         */
        public String getPicture() {
            return picture;
        }

        public void setPicture(String picture) {
            this.picture = picture;
        }

        /**
         * 子栏目对应的URL
         */
        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        /**
         * 子栏目类型
         * 0 : 视频VOD
         * 1 : 视频频道
         * 2 : 音频频道
         * 3 : 频道
         * 4 : 音频 AOD
         * 10 : VOD
         * 300 : 节目
         */
        public int getChildrenType() {
            return childrenType;
        }

        public void setChildrenType(int childrenType) {
            this.childrenType = childrenType;
        }

        /**
         * 多海报信息
         * key (String) 为海报位置
         * value (String[]) 为多张海报,
         * 0 : 缩略图
         * 1 : 海报
         * 2 : 剧照
         * 3 : 图标
         * 4 : 标题图
         * 5 : 广告图
         * 6 : 草图
         * 7 : 背景图
         * 9 : 频道图
         * 10 : 频道黑白图
         * 12 : 频道名字图片
         * 99 : 其它
         */
        public Map<String, String[]> getPosters() {
            return posters;
        }

        public void setPosters(Map<String, String[]> posters) {
            this.posters = posters;
        }

        /**
         * 是否定制栏目:
         * 1 : 定制栏目
         * 0 :非定制栏目
         */
        public int getIsCustom() {
            return isCustom;
        }

        public void setIsCustom(int isCustom) {
            this.isCustom = isCustom;
        }

        /**
         * 子栏目的附加类型:
         * 0 : 党建栏目
         * 1 : 教学计划
         */
        public String getAddonType() {
            return addonType;
        }

        public void setAddonType(String addonType) {
            this.addonType = addonType;
        }

        /**
         * 栏目生效开始时间 (格式: YYYMMDDhhmmss)
         */
        public String getStartTime() {
            return startTime;
        }

        public void setStartTime(String startTime) {
            this.startTime = startTime;
        }

        /**
         * 栏目生效结束时间 (格式: YYYMMDDhhmmss)
         */
        public String getEndTime() {
            return endTime;
        }

        public void setEndTime(String endTime) {
            this.endTime = endTime;
        }

        /**
         * 是否为必修的教学计划:
         * 0 : 必修
         * 1 : 选修
         */
        public String getIsRequiredCourse() {
            return isRequiredCourse;
        }

        public void setIsRequiredCourse(String isRequiredCourse) {
            this.isRequiredCourse = isRequiredCourse;
        }

        public Column parse(Object item) {
            HashMap map = (HashMap) item;
            Column column = new Column();
            Class clazz = column.getClass();
            HashMap<String, String> defines = Utils.getDeclaredAnnotations(clazz);
            if (map != null && defines != null) {
                for (Map.Entry<String, String> entry : defines.entrySet()) {
                    if (!map.containsKey(entry.getKey())) continue;
                    try {
                        Field field = clazz.getDeclaredField(entry.getValue());
                        field.set(column, map.get(entry.getKey()));
                    } catch (Throwable e) {
                    }
                }
            }

            return column;
        }
    }

    /**
     *  连续剧信息
     */
    public class Vod {
        @Define(name = "VODID", alias = "vodId")
        private int id = 0;
        @Define(name = "VODNAME", alias = "vodName")
        private String name;
        @Define(name = "INTRODUCE")
        private String introduce;
        @Define(name = "PICPATH")
        private String picture;
        @Define(name = "RELFLAG")
        private int flag = 0;
        @Define(name = "ISSITCOM")
        private int isSitcom;
        @Define(name = "POSTERPATHS")
        private Map<String, String[]> posters = new HashMap();
        @Define(name = "DEFINITION")
        private int definition;

        /**
         * 节目编号
         */
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        /**
         * 节目名称
         */
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        /**
         * 影片介绍
         */
        public String getIntroduce() {
            return introduce;
        }

        public void setIntroduce(String introduce) {
            this.introduce = introduce;
        }

        /**
         * 影片海报路径
         */
        public String getPicture() {
            return picture;
        }

        public void setPicture(String picture) {
            this.picture = picture;
        }

        /**
         * 影片上下线标志
         *
         * 1 : 最新上线影片
         * 2 : 普通影片
         * 3 : 即将下线影片
         */
        public int getFlag() {
            return flag;
        }

        public void setFlag(int flag) {
            this.flag = flag;
        }

        /**
         * 多海报信息
         * key (String) 为海报位置
         * value (String[]) 为多张海报,
         * 0 : 缩略图
         * 1 : 海报
         * 2 : 剧照
         * 3 : 图标
         * 4 : 标题图
         * 5 : 广告图
         * 6 : 草图
         * 7 : 背景图
         * 9 : 频道图
         * 10 : 频道黑白图
         * 12 : 频道名字图片
         * 99 : 其它
         */
        public Map<String, String[]> getPosters() {
            return posters;
        }

        public void setPosters(Map posters) {
            this.posters = posters;
        }

        /**
         * 连续剧类型:
         *
         * 0 : 非连续剧父类
         * 1 : 连续剧父类
         */
        public int getIsSitcom() {
            return isSitcom;
        }

        public void setIsSitcom(int isSitcom) {
            this.isSitcom = isSitcom;
        }

        /**
         * 高清标识, 1 高清, 2,标清
         */
        public int getDefinition() {
            return definition;
        }

        public void setDefinition(int definition) {
            this.definition = definition;
        }
    }

    /**
     * 影片详细信息
     *
     */
    public class Film {
        @Define(name = "VODID")
        private int id;
        @Define(name = "VODNAME")
        private String name;
        @Define(name = "DIRECTOR")
        private String director;
        @Define(name = "ACTOR")
        private String actor;
        @Define(name = "INTRODUCE")
        private String introduce;
        @Define(name = "PICPATH")
        private String picture;
        @Define(name = "ISASSESS")
        private int isAssess;
        @Define(name = "ASSESSID")
        private int assessId;
        @Define(name = "FATHERVODID")
        private int parentVodId;
        @Define(name = "ISSITCOM")
        private int isSitcom;
        @Define(name = "SERVICEID")
        private String[] serviceId;
        @Define(name = "AREAIDS")
        private int[] areas;
        @Define(name = "ELAPSETIME")
        private int elapseTime;
        @Define(name = "VODPRICE")
        private String price;
        @Define(name = "SEARCHCODE")
        private String searchCode;
        @Define(name = "STARTTIME")
        private String startTime;
        @Define(name = "ENDTIME")
        private String endTime;
        @Define(name = "RELFLAG")
        private int flag;
        @Define(name = "CONTENTTYPE")
        private int contentType;
        @Define(name = "POSTERPATHS")
        private Map<String, String[]> posters;
        @Define(name = "CASTMAP")
        private Map<Integer, String[]> cast;
        @Define(name = "THEMENAMES")
        private String theme;
        @Define(name = "TYPE")
        private String type;
        @Define(name = "KEYWORDS")
        private String keywords;
        @Define(name = "TAGS")
        private String tags;
        @Define(name = "SUBVODIDLIST")
        private List childrenList;
        @Define(name = "SUBVODNUMLIST")
        private List childrenIdList;
        @Define(name = "SUPVODIDSET")
        private HashSet parentVodList;
        @Define(name = "CODE")
        private String code;
        @Define(name = "allTypeId")
        private String[] allTypeId;
        @Define(name = "SPNAME")
        private String spName;
        @Define(name = "DEFINITION")
        private int definition;

        /**
         * 节目编号
         */
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        /**
         * 影片名称
         */
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        /**
         * 导演名字
         */
        public String getDirector() {
            return director;
        }

        public void setDirector(String director) {
            this.director = director;
        }

        /**
         * 主演名字
         */
        public String getActor() {
            return actor;
        }

        public void setActor(String actor) {
            this.actor = actor;
        }

        /**
         * 影片介绍
         */
        public String getIntroduce() {
            return introduce;
        }

        public void setIntroduce(String introduce) {
            this.introduce = introduce;
        }

        /**
         * 海报路径
         */
        public String getPicture() {
            return picture;
        }

        public void setPicture(String picture) {
            this.picture = picture;
        }

        /**
         * 是否含有片花
         */
        public int getIsAssess() {
            return isAssess;
        }

        public void setIsAssess(int isAssess) {
            this.isAssess = isAssess;
        }

        /**
         * 片花对应的VOD节目编号
         */
        public int getAssessId() {
            return assessId;
        }

        public void setAssessId(int assessId) {
            this.assessId = assessId;
        }

        /**
         * 如果内容有和父集绑定,显示绑定的父集中的一个,如果没有为 -1;
         */
        public int getParentVodId() {
            return parentVodId;
        }

        public void setParentVodId(int parentVodId) {
            this.parentVodId = parentVodId;
        }

        /**
         * 连续剧类型:
         *
         * 0 : 非连续剧父类
         * 1 : 连续剧父类
         */
        public int getIsSitcom() {
            return isSitcom;
        }

        public void setIsSitcom(int isSitcom) {
            this.isSitcom = isSitcom;
        }

        /**
         * 服务编号
         */
        public String[] getServiceId() {
            return serviceId;
        }

        public void setServiceId(String[] serviceId) {
            this.serviceId = serviceId;
        }

        /**
         * 所属区域数组
         */
        public int[] getAreas() {
            return areas;
        }

        public void setAreas(int[] areas) {
            this.areas = areas;
        }

        /**
         * 影片时长
         */
        public int getElapseTime() {
            return elapseTime;
        }

        public void setElapseTime(int elapseTime) {
            this.elapseTime = elapseTime;
        }

        /**
         * 影片价格
         */
        public String getPrice() {
            return price;
        }

        public void setPrice(String price) {
            this.price = price;
        }

        /**
         * 搜索代码
         */
        public String getSearchCode() {
            return searchCode;
        }

        public void setSearchCode(String searchCode) {
            this.searchCode = searchCode;
        }

        /**
         * 影片开始时间
         */
        public String getStartTime() {
            return startTime;
        }

        public void setStartTime(String startTime) {
            this.startTime = startTime;
        }

        /**
         * 影片结束时间
         */
        public String getEndTime() {
            return endTime;
        }

        public void setEndTime(String endTime) {
            this.endTime = endTime;
        }

        /**
         * 影片上下线标志
         *
         * 1 : 最新上线影片
         * 2 : 普通影片
         * 3 : 即将下线影片
         */
        public int getFlag() {
            return flag;
        }

        public void setFlag(int flag) {
            this.flag = flag;
        }

        /**
         * 影片类型:
         *
         * 0, 视频点播
         * 1, 音频点播
         */
        public int getContentType() {
            return contentType;
        }

        public void setContentType(int contentType) {
            this.contentType = contentType;
        }

        /**
         * 多海报信息
         * key (String) 为海报位置
         * value (String[]) 为多张海报,
         * 0 : 缩略图
         * 1 : 海报
         * 2 : 剧照
         * 3 : 图标
         * 4 : 标题图
         * 5 : 广告图
         * 6 : 草图
         * 7 : 背景图
         * 9 : 频道图
         * 10 : 频道黑白图
         * 12 : 频道名字图片
         * 99 : 其它
         */
        public Map<String, String[]> getPosters() {
            return posters;
        }

        public void setPosters(Map<String, String[]> posters) {
            this.posters = posters;
        }

        /**
         * 演职人员信息:
         * key : 角色类型
         * value : 演职人员类型
         */
        public Map<Integer, String[]> getCast() {
            return cast;
        }

        public void setCast(Map<Integer, String[]> cast) {
            this.cast = cast;
        }

        /**
         * 主题名称, 多个主题之间用"," 分隔
         */
        public String getTheme() {
            return theme;
        }

        public void setTheme(String theme) {
            this.theme = theme;
        }

        /**
         * 内容关键字, 文广 CMS 传入
         */
        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        /**
         * 关联标签, 文广 CMS 传入
         */
        public String getKeywords() {
            return keywords;
        }

        public void setKeywords(String keywords) {
            this.keywords = keywords;
        }

        /**
         * 内容类型, 文广 CMS 传入
         */
        public String getTags() {
            return tags;
        }

        public void setTags(String tags) {
            this.tags = tags;
        }

        /**
         * 点播内容的子集列表
         */
        public List getChildrenList() {
            return childrenList;
        }

        public void setChildrenList(List childrenList) {
            this.childrenList = childrenList;
        }

        /**
         * 点播内容所包含的子集列表对应的集号, 和上面是一一对应的
         */
        public List getChildrenIdList() {
            return childrenIdList;
        }

        public void setChildrenIdList(List childrenIdList) {
            this.childrenIdList = childrenIdList;
        }

        /**
         * 该内容绑定的父集编号的集合
         */
        public HashSet getParentVodList() {
            return parentVodList;
        }

        public void setParentVodList(HashSet parentVodList) {
            this.parentVodList = parentVodList;
        }

        /**
         *  VOD 的 MediaCode
         */
        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }

        /**
         * VOD所属于栏目 的 ID 列表
         */
        public String[] getAllTypeId() {
            return allTypeId;
        }

        public void setAllTypeId(String[] allTypeId) {
            this.allTypeId = allTypeId;
        }

        /**
         * 影片 SP 名称
         */
        public String getSpName() {
            return spName;
        }

        public void setSpName(String spName) {
            this.spName = spName;
        }

        /**
         * 高清标识, 1 高清, 2,标清
         */
        public int getDefinition() {
            return definition;
        }

        public void setDefinition(int definition) {
            this.definition = definition;
        }
    }

    public class IllegalResultException extends Exception {
        public IllegalResultException(String message) {
            super(message);
        }
    }

    private void checkList(List list) throws IllegalResultException {
        if (list == null || list.size() != 2)
            throw new IllegalResultException("Invalid list result by invoke method!");

        HashMap map = (HashMap) list.get(0);
        if (((Integer) map.get("COUNTTOTAL")).intValue() < 0)
            throw new IllegalResultException("Invalid 'count total' by invoke  method!");
    }

    /**
     *
     * @param id 栏目ID
     * @param length 单次查询记录的最大数量
     * @param station 从 station 参数指定位置开始获取影片列表
     * @param isVod false, 查询栏目, true, 查询 vod
     * @return List 如果查询的结果是有效的结果,返回 有效结果的 List, 否则抛出异常
     * @throws IllegalResultException 如果查询的结果是无效抛出异常
     */
    private List<?> getChildren(MetaData metaHelper, String id, int length, int station, boolean isVod) throws IllegalResultException {

        List<?> list = isVod ? metaHelper.getVodListByTypeId(id, length, station) : metaHelper.getTypeListByTypeId(id, length, station);

        checkList(list);

        list = (List<?>) list.get(1);
        return list;
    }

    /**
     *
     * @param id 栏目ID
     * @param length 单次查询记录的最大数量
     * @param station 从 station 参数指定位置开始获取影片列表
     * @return List 如果查询的结果是有效的结果,返回 有效结果的 List, 否则抛出异常
     * @throws IllegalResultException 如果查询的结果是无效抛出异常
     */
    public List<Column> getTypeList(MetaData metaHelper, String id, int length, int station) throws IllegalResultException {
        List<?> list = getChildren(metaHelper, id, length, station, false);
        if (list == null || list.size() == 0) return null;
        List<Column> columns = new ArrayList<Column>();
        for (int i = 0; i < list.size(); i++) {
            columns.add(Utils.parse(new Column(), list.get(i)));
        }
        return columns;
    }

    /**
     *
     * @param id 栏目ID
     * @param length 单次查询记录的最大数量
     * @param station 从 station 参数指定位置开始获取影片列表
     * @return List 如果查询的结果是有效的结果,返回 有效结果的 List, 否则抛出异常
     * @throws IllegalResultException 如果查询的结果是无效抛出异常
     */
    public List<Vod> getVodList(MetaData metaHelper, String id, int length, int station) throws IllegalResultException {
        List<?> list = getChildren(metaHelper, id, length, station, true);
        if (list == null || list.size() == 0) return null;
        List<Vod> vodList = new ArrayList<Vod>();
        for (int i = 0; i < list.size(); i++) {
            vodList.add(Utils.parse(new Vod(), list.get(i)));
        }
        return vodList;
    }

    /**
     *
     * @param name 影片名称
     * @param length 单次查询的最大数量
     * @param start 查询的起始位置
     * @param asSubVod 是否包含子集 0,不包含,1 包含
     * @return
     */
    public List<Vod> searchList(ServiceHelp helper, String name, int start, int length, int asSubVod, int searchType) throws Throwable {
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
        checkList(list);
        list = (List<?>) list.get(1);
        List<Vod> results = new ArrayList<Vod>();
        for (int i = 0; i < list.size(); i++) {
            Vod vod = new Vod();
            vod = Utils.parse(vod, list.get(i));
            if (!results.contains(vod))
                results.add(vod);
        }
        return results;
    }

    public <T> T getDetailInfo(MetaData metaHelper, String id, T t) {
        try {
            Map map = null;
            String className = t.getClass().getSimpleName();
            if (className.equalsIgnoreCase("Vod") || className.equalsIgnoreCase("Film")) {
                map = metaHelper.getVodDetailInfo(Integer.parseInt(id));
            } else if (className.equalsIgnoreCase("Column")) {
                map = metaHelper.getTypeInfoByTypeId(id);
            }
            return map == null || map.size() == 0 ? null : Utils.parse(t, map);
        } catch (Throwable e) {

        }
        return null;
    }
    //public Map getVodDetailInfo(int vodId)
    //ServiceHelpHWCTC help = new ServiceHelpHWCTC(request);
%>
