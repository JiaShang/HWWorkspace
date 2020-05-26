<%--
    ����������
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
         * ������ת�����ַ����������Ӧ����Arrays.toString(Object[] arr)
         * @param arrObjects    ��������
         * @param joinString    ����ÿ�����ݵ��ַ���
         * @return ת�����
         */
        private static String displayArray(final Object[] arrObjects, final String joinString) {
            StringBuilder sb = new StringBuilder();
            final String constStr = "����������([{��";
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
         * �����ַ������ȣ����ַ�����Ϊ��λ�������ַ������������ǵĳ���Ϊ1��ȫ��Ϊ2��
         * @param src Դ�ַ���
         * @param maxByteCharLength ����ַ�������
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
                //ѭ����ɺ�������������ָ�����������ƣ�	a|		��|		��|��
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
                //���滹���ַ��������ַ�ֱ�����ڵ���maxByteCharLength - endingStringByteLengthλ������endingString
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
         *  ��������,���� Define ���� ���ֶ�
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
            //ƴ��ͼƬ�ķ�������·��
            String filePath = request.getRealPath("/") + "jsp/" + imagePath;

            File image = new File(filePath);

            return (image.exists() && !image.isDirectory());
        }


        public final static String pictureUrl(String defaultPath, Object urls, String type, HttpServletRequest request) {
            return pictureUrl(defaultPath,urls,type,0,request);
        }

        /**
         * ���ȡ��ͼƬ·�����������ϴ��ڸ�ͼƬ�����ظ�ͼƬ·��<br>
         * ���ȡ��ͼƬ·�����������ϲ����ڸ�ͼƬ������Ĭ��·��<br>
         * ���ȡ������ͼƬ·��������Ĭ��·��<br>
         *
         * @param defaultPath Ĭ��ͼƬ·��
         * @param type Ŀ��ͼƬ����  ����: 0 ����ͼ��1 ���� ��2 ���� ��3 ͼ��
         * 4 ����ͼ ��5 ���ͼ �� 6 ��ͼ �� 7 ����ͼ �� 8 Ƶ��ͼƬ �� 9 Ƶ���ڰ�ͼƬ ��
         * 10 Ƶ������ͼƬ �� 11 ����
         * @param index ��ͼƬ����˳��
         * @param urls��������String�������Stringֱ�Ӽ��ͼƬ���ӵ�ַ�Ƿ���ڣ����� typeId������ַ�Ƿ����
         * @return picPath ���ص�·��
         */
        public final static String pictureUrl(String defaultPath, Object urls, String type, int index, HttpServletRequest request) {

            //���û��ȡ���κ�ͼƬʱ,����Ĭ��ͼƬ.
            if (urls == null) return defaultPath;
            String tempUri = "";

            Map posterPath = (HashMap) urls;

            //ͼƬ������:  0 ����ͼ��1 ���� ��2 ���� ��3 ͼ��, 4 ����ͼ ��5 ���ͼ �� 6 ��ͼ �� 7 ����ͼ �� 8 Ƶ��ͼƬ �� 9 Ƶ���ڰ�ͼƬ �� 10 Ƶ������ͼƬ �� 11 ����
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
        //ӰƬ���ƣ����룩
        public final static int FILMCODE = 1;
        //ӰƬ���ƣ����ֻ���ĸ��
        public final static int FILMNAME = 2;
        //����Ա����
        public final static int ACTOR = 3;
        //����Ա��������
        public final static int CASTCODE = 6;
        //����
        public final static int DIRECTOR = 4;
        //�ⲿID
        public final static int FOREIGNSN = 5;
    }

    /**
     *  ��Ŀ��Ϣ
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
         * ����ĿID
         */
        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * ����Ŀ����
         */
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        /**
         * ����Ŀ����
         */
        public String getIntroduce() {
            return introduce;
        }

        public void setIntroduce(String introduce) {
            this.introduce = introduce;
        }

        /**
         * ����Ŀ��Ӧ��ͼƬ
         */
        public String getPicture() {
            return picture;
        }

        public void setPicture(String picture) {
            this.picture = picture;
        }

        /**
         * ����Ŀ��Ӧ��URL
         */
        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        /**
         * ����Ŀ����
         * 0 : ��ƵVOD
         * 1 : ��ƵƵ��
         * 2 : ��ƵƵ��
         * 3 : Ƶ��
         * 4 : ��Ƶ AOD
         * 10 : VOD
         * 300 : ��Ŀ
         */
        public int getChildrenType() {
            return childrenType;
        }

        public void setChildrenType(int childrenType) {
            this.childrenType = childrenType;
        }

        /**
         * �ຣ����Ϣ
         * key (String) Ϊ����λ��
         * value (String[]) Ϊ���ź���,
         * 0 : ����ͼ
         * 1 : ����
         * 2 : ����
         * 3 : ͼ��
         * 4 : ����ͼ
         * 5 : ���ͼ
         * 6 : ��ͼ
         * 7 : ����ͼ
         * 9 : Ƶ��ͼ
         * 10 : Ƶ���ڰ�ͼ
         * 12 : Ƶ������ͼƬ
         * 99 : ����
         */
        public Map<String, String[]> getPosters() {
            return posters;
        }

        public void setPosters(Map<String, String[]> posters) {
            this.posters = posters;
        }

        /**
         * �Ƿ�����Ŀ:
         * 1 : ������Ŀ
         * 0 :�Ƕ�����Ŀ
         */
        public int getIsCustom() {
            return isCustom;
        }

        public void setIsCustom(int isCustom) {
            this.isCustom = isCustom;
        }

        /**
         * ����Ŀ�ĸ�������:
         * 0 : ������Ŀ
         * 1 : ��ѧ�ƻ�
         */
        public String getAddonType() {
            return addonType;
        }

        public void setAddonType(String addonType) {
            this.addonType = addonType;
        }

        /**
         * ��Ŀ��Ч��ʼʱ�� (��ʽ: YYYMMDDhhmmss)
         */
        public String getStartTime() {
            return startTime;
        }

        public void setStartTime(String startTime) {
            this.startTime = startTime;
        }

        /**
         * ��Ŀ��Ч����ʱ�� (��ʽ: YYYMMDDhhmmss)
         */
        public String getEndTime() {
            return endTime;
        }

        public void setEndTime(String endTime) {
            this.endTime = endTime;
        }

        /**
         * �Ƿ�Ϊ���޵Ľ�ѧ�ƻ�:
         * 0 : ����
         * 1 : ѡ��
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
     *  ��������Ϣ
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
         * ��Ŀ���
         */
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        /**
         * ��Ŀ����
         */
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        /**
         * ӰƬ����
         */
        public String getIntroduce() {
            return introduce;
        }

        public void setIntroduce(String introduce) {
            this.introduce = introduce;
        }

        /**
         * ӰƬ����·��
         */
        public String getPicture() {
            return picture;
        }

        public void setPicture(String picture) {
            this.picture = picture;
        }

        /**
         * ӰƬ�����߱�־
         *
         * 1 : ��������ӰƬ
         * 2 : ��ͨӰƬ
         * 3 : ��������ӰƬ
         */
        public int getFlag() {
            return flag;
        }

        public void setFlag(int flag) {
            this.flag = flag;
        }

        /**
         * �ຣ����Ϣ
         * key (String) Ϊ����λ��
         * value (String[]) Ϊ���ź���,
         * 0 : ����ͼ
         * 1 : ����
         * 2 : ����
         * 3 : ͼ��
         * 4 : ����ͼ
         * 5 : ���ͼ
         * 6 : ��ͼ
         * 7 : ����ͼ
         * 9 : Ƶ��ͼ
         * 10 : Ƶ���ڰ�ͼ
         * 12 : Ƶ������ͼƬ
         * 99 : ����
         */
        public Map<String, String[]> getPosters() {
            return posters;
        }

        public void setPosters(Map posters) {
            this.posters = posters;
        }

        /**
         * ����������:
         *
         * 0 : �������縸��
         * 1 : �����縸��
         */
        public int getIsSitcom() {
            return isSitcom;
        }

        public void setIsSitcom(int isSitcom) {
            this.isSitcom = isSitcom;
        }

        /**
         * �����ʶ, 1 ����, 2,����
         */
        public int getDefinition() {
            return definition;
        }

        public void setDefinition(int definition) {
            this.definition = definition;
        }
    }

    /**
     * ӰƬ��ϸ��Ϣ
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
         * ��Ŀ���
         */
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        /**
         * ӰƬ����
         */
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        /**
         * ��������
         */
        public String getDirector() {
            return director;
        }

        public void setDirector(String director) {
            this.director = director;
        }

        /**
         * ��������
         */
        public String getActor() {
            return actor;
        }

        public void setActor(String actor) {
            this.actor = actor;
        }

        /**
         * ӰƬ����
         */
        public String getIntroduce() {
            return introduce;
        }

        public void setIntroduce(String introduce) {
            this.introduce = introduce;
        }

        /**
         * ����·��
         */
        public String getPicture() {
            return picture;
        }

        public void setPicture(String picture) {
            this.picture = picture;
        }

        /**
         * �Ƿ���Ƭ��
         */
        public int getIsAssess() {
            return isAssess;
        }

        public void setIsAssess(int isAssess) {
            this.isAssess = isAssess;
        }

        /**
         * Ƭ����Ӧ��VOD��Ŀ���
         */
        public int getAssessId() {
            return assessId;
        }

        public void setAssessId(int assessId) {
            this.assessId = assessId;
        }

        /**
         * ��������к͸�����,��ʾ�󶨵ĸ����е�һ��,���û��Ϊ -1;
         */
        public int getParentVodId() {
            return parentVodId;
        }

        public void setParentVodId(int parentVodId) {
            this.parentVodId = parentVodId;
        }

        /**
         * ����������:
         *
         * 0 : �������縸��
         * 1 : �����縸��
         */
        public int getIsSitcom() {
            return isSitcom;
        }

        public void setIsSitcom(int isSitcom) {
            this.isSitcom = isSitcom;
        }

        /**
         * ������
         */
        public String[] getServiceId() {
            return serviceId;
        }

        public void setServiceId(String[] serviceId) {
            this.serviceId = serviceId;
        }

        /**
         * ������������
         */
        public int[] getAreas() {
            return areas;
        }

        public void setAreas(int[] areas) {
            this.areas = areas;
        }

        /**
         * ӰƬʱ��
         */
        public int getElapseTime() {
            return elapseTime;
        }

        public void setElapseTime(int elapseTime) {
            this.elapseTime = elapseTime;
        }

        /**
         * ӰƬ�۸�
         */
        public String getPrice() {
            return price;
        }

        public void setPrice(String price) {
            this.price = price;
        }

        /**
         * ��������
         */
        public String getSearchCode() {
            return searchCode;
        }

        public void setSearchCode(String searchCode) {
            this.searchCode = searchCode;
        }

        /**
         * ӰƬ��ʼʱ��
         */
        public String getStartTime() {
            return startTime;
        }

        public void setStartTime(String startTime) {
            this.startTime = startTime;
        }

        /**
         * ӰƬ����ʱ��
         */
        public String getEndTime() {
            return endTime;
        }

        public void setEndTime(String endTime) {
            this.endTime = endTime;
        }

        /**
         * ӰƬ�����߱�־
         *
         * 1 : ��������ӰƬ
         * 2 : ��ͨӰƬ
         * 3 : ��������ӰƬ
         */
        public int getFlag() {
            return flag;
        }

        public void setFlag(int flag) {
            this.flag = flag;
        }

        /**
         * ӰƬ����:
         *
         * 0, ��Ƶ�㲥
         * 1, ��Ƶ�㲥
         */
        public int getContentType() {
            return contentType;
        }

        public void setContentType(int contentType) {
            this.contentType = contentType;
        }

        /**
         * �ຣ����Ϣ
         * key (String) Ϊ����λ��
         * value (String[]) Ϊ���ź���,
         * 0 : ����ͼ
         * 1 : ����
         * 2 : ����
         * 3 : ͼ��
         * 4 : ����ͼ
         * 5 : ���ͼ
         * 6 : ��ͼ
         * 7 : ����ͼ
         * 9 : Ƶ��ͼ
         * 10 : Ƶ���ڰ�ͼ
         * 12 : Ƶ������ͼƬ
         * 99 : ����
         */
        public Map<String, String[]> getPosters() {
            return posters;
        }

        public void setPosters(Map<String, String[]> posters) {
            this.posters = posters;
        }

        /**
         * ��ְ��Ա��Ϣ:
         * key : ��ɫ����
         * value : ��ְ��Ա����
         */
        public Map<Integer, String[]> getCast() {
            return cast;
        }

        public void setCast(Map<Integer, String[]> cast) {
            this.cast = cast;
        }

        /**
         * ��������, �������֮����"," �ָ�
         */
        public String getTheme() {
            return theme;
        }

        public void setTheme(String theme) {
            this.theme = theme;
        }

        /**
         * ���ݹؼ���, �Ĺ� CMS ����
         */
        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        /**
         * ������ǩ, �Ĺ� CMS ����
         */
        public String getKeywords() {
            return keywords;
        }

        public void setKeywords(String keywords) {
            this.keywords = keywords;
        }

        /**
         * ��������, �Ĺ� CMS ����
         */
        public String getTags() {
            return tags;
        }

        public void setTags(String tags) {
            this.tags = tags;
        }

        /**
         * �㲥���ݵ��Ӽ��б�
         */
        public List getChildrenList() {
            return childrenList;
        }

        public void setChildrenList(List childrenList) {
            this.childrenList = childrenList;
        }

        /**
         * �㲥�������������Ӽ��б��Ӧ�ļ���, ��������һһ��Ӧ��
         */
        public List getChildrenIdList() {
            return childrenIdList;
        }

        public void setChildrenIdList(List childrenIdList) {
            this.childrenIdList = childrenIdList;
        }

        /**
         * �����ݰ󶨵ĸ�����ŵļ���
         */
        public HashSet getParentVodList() {
            return parentVodList;
        }

        public void setParentVodList(HashSet parentVodList) {
            this.parentVodList = parentVodList;
        }

        /**
         *  VOD �� MediaCode
         */
        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }

        /**
         * VOD��������Ŀ �� ID �б�
         */
        public String[] getAllTypeId() {
            return allTypeId;
        }

        public void setAllTypeId(String[] allTypeId) {
            this.allTypeId = allTypeId;
        }

        /**
         * ӰƬ SP ����
         */
        public String getSpName() {
            return spName;
        }

        public void setSpName(String spName) {
            this.spName = spName;
        }

        /**
         * �����ʶ, 1 ����, 2,����
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
     * @param id ��ĿID
     * @param length ���β�ѯ��¼���������
     * @param station �� station ����ָ��λ�ÿ�ʼ��ȡӰƬ�б�
     * @param isVod false, ��ѯ��Ŀ, true, ��ѯ vod
     * @return List �����ѯ�Ľ������Ч�Ľ��,���� ��Ч����� List, �����׳��쳣
     * @throws IllegalResultException �����ѯ�Ľ������Ч�׳��쳣
     */
    private List<?> getChildren(MetaData metaHelper, String id, int length, int station, boolean isVod) throws IllegalResultException {

        List<?> list = isVod ? metaHelper.getVodListByTypeId(id, length, station) : metaHelper.getTypeListByTypeId(id, length, station);

        checkList(list);

        list = (List<?>) list.get(1);
        return list;
    }

    /**
     *
     * @param id ��ĿID
     * @param length ���β�ѯ��¼���������
     * @param station �� station ����ָ��λ�ÿ�ʼ��ȡӰƬ�б�
     * @return List �����ѯ�Ľ������Ч�Ľ��,���� ��Ч����� List, �����׳��쳣
     * @throws IllegalResultException �����ѯ�Ľ������Ч�׳��쳣
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
     * @param id ��ĿID
     * @param length ���β�ѯ��¼���������
     * @param station �� station ����ָ��λ�ÿ�ʼ��ȡӰƬ�б�
     * @return List �����ѯ�Ľ������Ч�Ľ��,���� ��Ч����� List, �����׳��쳣
     * @throws IllegalResultException �����ѯ�Ľ������Ч�׳��쳣
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
     * @param name ӰƬ����
     * @param length ���β�ѯ���������
     * @param start ��ѯ����ʼλ��
     * @param asSubVod �Ƿ�����Ӽ� 0,������,1 ����
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
