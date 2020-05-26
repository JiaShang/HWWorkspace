<%@ page language="java" pageEncoding="GBK"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelp" %>
<%!
/* ��ĸ���� */
private static final String[] caseChar = {"a", "b", "c", "d", "e", "f", "g",
  "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
  "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I",
  "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
  "X", "Y", "Z",
  "`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "~",
  "!", "@", "#", "$", "%", "^", "&;", "*", "(", ")", "_", "+", "&",
  "[", "]", ";", "'", ".", "/", "\\", "{", "}", ":", "\"", "<", ">",
  "?", "|", "~", "��", "��", "#", "��", "%", "����", "��", "��", "��", "����",
  " ", "��", "��", "��"};

/* ��ĸ��������� */
private static final int[] pxChar = {10, 10, 9, 10, 10, 6, 10,
  10, 5, 5, 9, 5, 14, 10, 10, 10, 10, 7, 9, 6, 10,
  9, 12, 9, 9, 9, 11, 11, 12, 12, 11, 11, 13, 12, 6,
  9, 11, 10, 14, 12, 13, 11, 13, 12, 11, 11, 12, 11, 16,
  11, 11, 11,
  7, 10, 10, 10, 10, 10, 10, 10, 10,
  10, 10, 6, 11, 11, 6, 22, 11, 10, 20, 10, 16, 10, 7, 7, 11, 11, 11,
  6, 6, 6, 5, 6, 7, 4, 7, 7, 6, 4, 11, 11, 10, 6, 11, 10, 17, 11, 19,
  17, 36, 19, 19, 19, 19, 6, 10, 12, 12};

/* ����IpanelĬ���ֺ��·�Ӣ����ĸ��ʾ������ */
private static final int perChar_en = 6;

/* ����IpanelĬ���ֺ���������ʾ������ */
private static final int perChar_cn = 17;

/**
 * ������ı����ʽ��ȡ�ַ���
 *
 * @param targetStr ���ȡ���ַ���
 * @param enCoding �����ʽ
 * @param nlen ��ȡ�ĳ���
 * @throws UnsupportedEncodingException
 */
public List subString(String targetStr, String enCoding, int nLen) throws UnsupportedEncodingException
{
  // ������Ч���ж�
  targetStr = (null == targetStr) ? "" : targetStr.trim();
  enCoding = (null == enCoding) ? "" : enCoding.trim();
  // ֻ����GBK��UTF-8�����ַ���
  if ("".equals(targetStr))
  {
    return null;
  }
  if (!"GBK".equalsIgnoreCase(enCoding) && !"UTF-8".equalsIgnoreCase(enCoding))
  {
    return null;
  }

  // Ŀ���ַ���
  targetStr = new String(targetStr.getBytes(enCoding), enCoding);

  // ���صĽ��
  List result = new ArrayList();
  StringBuffer perLine = new StringBuffer(1024);
  int n = 0;
  int tempN = 0;
  char tempChar;
  for (int i = 0; i < targetStr.length(); i++)
  {
    tempChar = targetStr.charAt(i);
    perLine.append(tempChar);

    for (int j = 0; j < caseChar.length; j++)
    {
      if (caseChar[j].charAt(0) == tempChar)
      {
        tempN = pxChar[j];
        break;
      }
    }

    // �ж��Ƿ�ΪAscii�ַ�
    if (isLetter(tempChar))
    {
      n += (tempN == 0) ? perChar_en : tempN;
    }
    else
    {
      n += (tempN == 0) ? perChar_cn : tempN;
    }

    // û�ж�ȡһ�����ַ���
    if (n > nLen || i == targetStr.length() - 1)
    {
      result.add(perLine.toString());
      n = 0;
      perLine = new StringBuffer();
    }
    tempN = 0;
  }
  return result;
}

/**
 * �ж�һ���ַ���Asscii�ַ����������ַ�
 *
 * @param c ��Ҫ�����жϵ��ַ�
 * @return �Ƿ���Asscii�ַ�
 */
private boolean isLetter(char c)
{
  int k = 0x80;
  return c / k == 0 ? true : false;
}

/**
 * ��ȡҳ�溣����������commom�ļ����е��ļ�
 * @param HttpServletRequest request �������
 * @param String prefix ǰ׺
 * @param String typeId Ҫ��ȡ���ļ�������
 * @return String ���ļ����ڵ�ʱ�򷵻��ļ������ƣ�����ļ��������򷵻�һ��"false"���ַ���
 * **/
public String hasPicture(HttpServletRequest request,String prefix,String typeId)
{
  String resultStr = request.getContextPath()+"/jsp/images/universal/film/common/"+prefix+typeId+".gif";
  return resultStr;
}

/*
 * ��ȡ�Ϸ��ľ�̬ͼƬ����
 * @param int numҪ��ʾ�ľ�̬ͼƬ����
 * @param String folder ��/jsp/images/universal/film/�¶�Ӧ�ľ����ļ���
 */
public List getStaticPic(int num, String folder, HttpServletRequest request)
{
  //�õ��������ĸ�·��
  String rootPath = getClass().getClassLoader().getResource("").getPath();
  String filePath = rootPath+"/jsp/images/universal/film/"+folder+"/";
  //���ݻ�ȡ��ͼƬ·�����ҵ��ļ��л�ȡ����
  File file = new File(filePath);
  String[] picList = file.list();
  String[] picNewList = null;
  int getPicNum = 0;//�õ�����ʵͼƬ����

  //ȡ��picList�ĳ���
  if(null != picList)
  {
    int j=0;
    getPicNum = picList.length;
    picNewList = new String[getPicNum];
    //�ѷ���Ҫ���ͼƬ���·�װһ��
    for(int i=0; i<getPicNum; i++)
    {
      //�ж��Ƿ���һjpg��gif��β������Ǿͷ���������
      if(picList[i].endsWith(".jpg") == true || picList[i].endsWith(".gif") == true)
      {
        picNewList[j] = picList[i];
        j++;
      }
    }
    getPicNum = j;
  }
  //��ʾ��ͼƬ����
  int factPicNum = getPicNum;
  if(getPicNum > num)
  {
    factPicNum = num;
  }

  String tempPath = request.getContextPath()+"/jsp/images/universal/film/"+folder+"/";
  List staticPicList = new ArrayList();
  String path;
  //��·���б��װ��һ��list��
  for(int i=0; i<factPicNum; i++)
  {
    path = "";
    //ƴװ·������Ϊ����webserver��ʹ�ã�������Ҫ�������·��
    path = tempPath+picNewList[i];
    path=path.replaceAll("//","/");
    staticPicList.add(path);
  }
  return staticPicList;
}

/**
*��ȡ�ַ�������ȡ�󲻼ӵ�ķ���
*@param String �������ַ���
*@param int ��ʾ�ַ�����󳤶�
*/
public String subString(String entireStr,int len)
{
  //��ȡ��Ŀ���ƣ���Ŀ���Ƴ���������len���ַ�֮��
  if(entireStr.length()>len)
  {
    entireStr = entireStr.substring(0,len);
  }
  return entireStr;
}

/**
*��ȡ�ַ�������ȡ�ַ�����ӵ�ķ���
*@param String �������ַ���
*@param int ��ʾ�ַ�����󳤶�
*/
public String subString1(String entireStr,int len)
{
  //��ȡ��Ŀ���ƣ���Ŀ���Ƴ���������len���ַ�֮��
  if(null == entireStr)
  {
    return "";
  }
  if(entireStr.length()>len)
  {
    entireStr = entireStr.substring(0,len-1)+"...";
  }
  return entireStr;
}

/*
*��ȡ���õ�logo·��
*@param String ������Ŀid+logo��Ψһ��ʾlogo
*/
public String getLogoPath(String typeId,HttpServletRequest request)
{
  String logo = request.getContextPath()+"/jsp/images/universal/film/logo/"+typeId+"logo.gif";
  return logo;
}

/**
* ȡ�������Ϣ
* @param String typeId ��Ŀ��id
* @param int ��ȡ������Ŀ��id����ȣ��������������ֵ0����Ĭ��Ϊ6λ
* @return bullVo �������
*/
public String getBulletin(int len,String typeId,HttpServletRequest request,
                          HttpServletResponse response)throws Exception
{
  MetaData metaData = new MetaData(request);
  List bullList = null;
  List blist = null;
  try
  {
    bullList = metaData.getBulletin();
    if ((bullList != null) && (bullList.size() > 0))
    {
      Map map = (HashMap) bullList.get(0);
      int totalcount = ((Integer) map.get("COUNTTOTAL")).intValue();
      if (totalcount > 0)
      {
        blist = (ArrayList) bullList.get(1);
      }
    }
  }
  catch(Exception e)
  {
    return "";
  }
  if (null != blist)
  {  
    String content = null;
    String title = null;
    for (int i = 0; i < blist.size(); i++)
    {
      Map bull = (Map)blist.get(i);
      content = (String)bull.get("BULLETIN_CONTENT");
      title = (String)bull.get("BULLETIN_TITLE");
      
      // ��ȡ�������ǰ�����ֲ��֣��Ƚ��Ƿ��ָ������Ŀ���һ��
      title = getHeadNum(title).trim();
      typeId = typeId.trim();
      if (title.equals(typeId))
      {
        content = content.replaceAll(" ", "&nbsp;");
        return content;
      }
    }
  }
  return "";
}

/** �������ã���ȡ�����е�ǰ������ */
/** ������s��Ҫ��ȡ���ַ��� */
/** ����ֵ����ȡ����ַ��� */
private String getHeadNum(String s)
{
  String character = "";
  String validString = "0123456789";
  StringBuffer resultStr = new StringBuffer();

  if(null == s || s.length() == 0)
  {
    return resultStr.toString();
  }
  else
  {
    for (int i = 0; i < s.length(); i++)
    {
      character = s.substring(i, i + 1);
      if(validString.indexOf(character) == -1)
      {
        break;
      }
      else
      {
        resultStr.append(character);
      }
    }
    return resultStr.toString();
  }
}

/**
 * ���ȡ��ͼƬ·�����������ϴ��ڸ�ͼƬ�����ظ�ͼƬ·��<br>
 * ���ȡ��ͼƬ·�����������ϲ����ڸ�ͼƬ������Ĭ��·��<br>
 * ���ȡ������ͼƬ·��������Ĭ��·��<br>
 *
 * @param targetPath Ŀ��ͼƬ·��
 * @param defaultPath Ĭ��ͼƬ·��
 * @param type Ŀ��ͼƬ����  ����:0 vod������1 adv����
 * @param request �������
 * @return resultPath ���ص�·��
 */
public static String getPicPath(
                                String targetPath,
                                String defaultPath,
                                int type,
                                HttpServletRequest request)
{
  // ��Ҫ���ص�·��
  String resultPath = targetPath;
  // Ŀ��ͼƬ���Ͷ�Ӧ��·��
  String[] type_target = {"images/universal/film",
                          "images/universal/adv"
                          };

  // Ŀ��ͼƬ������
  if (type < 0 || type > 2)
  {
      return defaultPath;
  }

  // Ŀ��·�����Ϊ��
  if (null == targetPath || "".equals(targetPath.trim()))
  {
      return defaultPath;
  }

  // ���������jpg, gif, bmp, png ������Ĭ��ͼƬ
  String temp_path = targetPath;
  temp_path = temp_path.toUpperCase();
  if (temp_path.lastIndexOf(".GIF") == -1
      && temp_path.lastIndexOf(".JPG") == -1
      && temp_path.lastIndexOf(".BMP") == -1
      && temp_path.lastIndexOf(".PNG") == -1)
  {
    return defaultPath;
  }

  // vod��adv ��Ӧ���ļ�������
  int folderNum = targetPath.lastIndexOf(type_target[type]);
  if(folderNum > 0) // �����VOD��ADV��Ӧ���ļ���
  {
    String folderPath = targetPath.substring(folderNum);
    {
      // ƴ��·��
      String pagePath = request.getRealPath("./");
      String joinPath = pagePath + "/jsp/" + folderPath;

      File imagesFile = new File(joinPath);
      // ���ͼƬ·����Ŀ¼
      if(imagesFile.isDirectory())
      {
        return defaultPath;
      }
      if(!imagesFile.exists())
      {
        resultPath = defaultPath;
      }
      else
      {
        resultPath = targetPath;
      }
    }
  }
  else // �����滻ΪĬ��ͼƬ
  {
    resultPath = defaultPath;
  }

  return resultPath;
}

/**
 * �жϻ�ȡ�ĺ�����LOGO�����λͼƬ�Ƿ����
 * @param request �������
 * @return boolean ·���Ƿ����
 */
public static boolean isImageExist(
                                String imagePath,
                                HttpServletRequest request)
{
  //�����ȡ��ͼƬ·��
  imagePath = imagePath.replace("../../","");
  
  
  //ƴ��ͼƬ�ķ�������·��
  String rootPath = request.getRealPath("/");
  String filePath = rootPath+"jsp/" + imagePath;
  
  
  File image = new File(filePath);
  
  return (image.exists() && !image.isDirectory());
}

/**
 * ���ȡ��ͼƬ·�����������ϴ��ڸ�ͼƬ�����ظ�ͼƬ·��<br>
 * ���ȡ��ͼƬ·�����������ϲ����ڸ�ͼƬ������Ĭ��·��<br>
 * ���ȡ������ͼƬ·��������Ĭ��·��<br>
 *
 * @param typeId ͼƬ���ڵ���Ŀ
 * @param defaultPath Ĭ��ͼƬ·��
 * @param type Ŀ��ͼƬ����  ����:0 ����ͼ��1 ���� ��2 ���� ��3 ͼ�� 
 * 4 ����ͼ ��5 ���ͼ �� 6 ��ͼ �� 7 ����ͼ �� 8 Ƶ��ͼƬ �� 9 Ƶ���ڰ�ͼƬ ��
 * 10 Ƶ������ͼƬ �� 11 ����
 * @param request �������
 * @return picPath ���ص�·��
 */
public static String getPicPath(
                                String typeId,
                                String defaultPath,
                                String type,
                                HttpServletRequest request)
{
  MetaData metaData = new MetaData(request);
  Map typeInfo = metaData.getTypeInfoByTypeId(typeId);
  if (null == typeInfo)
  {
    return defaultPath;
  }
  Map posterPath = (HashMap)typeInfo.get("POSTERPATHS");
  if (null == posterPath)
  {
    return defaultPath;
  }
  String [] picArray = (String [])posterPath.get(type);
  if (null == picArray)
  {
    return defaultPath;
  }
  String picPath = picArray[0];
  String temppicPath = picPath.replace("../../","");
  picPath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"+"jsp/"+temppicPath;
  if(!isImageExist(temppicPath,request))
  {
    return defaultPath;
  }
  
  return picPath;
}


/*
*��ȡǿ���Ƽ�����
*/
 public List getBlockbusterDataList (String typeId, int length, int station,HttpServletRequest request,
                                    HttpServletResponse response)throws Exception
{
  //��ȡ���ݵĶ���MetaData
  MetaData meta = new MetaData(request);

  //���ú�̨�Ľӿ������ǿ���Ƽ�������
    List blockbusterList = null;
    //ǿ���Ƽ������б�
    List blockList = null;

    try
    {
      blockbusterList = meta.getVodListByTypeId(typeId, length, station);
      if(null != blockbusterList)
      {
        Map blockMap = (Map)blockbusterList.get(0);
        Integer count = (Integer)blockMap.get("COUNTTOTAL");
        if(count.intValue() > 0)
        {
          blockList = (List)blockbusterList.get(1);
        }
      }
    }
    catch(Exception e)
    {
      blockList = null;
    }
  return blockList;
}

/*
*������Ŀid��Ϊ����ⲿ�������ȡ���·��
*@param String ��Ŀid��Ϊ���λ�ı��
*@param HttpServletRequest �������
*@param length ȡ���ݵĳ���
*@param station ȡ���ݵ���ʼλ��
*@return ���ع��·��List,���򷵻�null
*/
public List getPosterPaths(String typeId , int length, int station, HttpServletRequest request)
{
  String requesturl = request.getRequestURI();
  // ��ҳ
  if(requesturl.indexOf("Category.jsp") != -1)
  {
    ServiceHelp serHelp = new ServiceHelp(request);
    MetaData meta = new MetaData(request);

    //��ѯ��ֵҵ���б�
    List vasList = meta.getVasListByTypeId(typeId, length, station);
    if(null != vasList)
    {
      Map countMap = (Map)vasList.get(0);
      int count = ((Integer)countMap.get("COUNTTOTAL")).intValue();
      //�����������0
      if(count > 0)
      {
        List list = new ArrayList();
        List tempVasList = (List)vasList.get(1);
        for(int i = 0; i < tempVasList.size(); i ++)
        {
          //��ֵҵ�����
          Map vasObj = (Map)tempVasList.get(i);
          //��ȡ��ֵҵ������Id
          int vasId = ((Integer)vasObj.get("VASID")).intValue();
          String url = serHelp.getVasUrl(vasId);
          if(null != url)
          {
            url = request.getContextPath() + "/jsp/images/universal/adv/" + url;
          }
          list.add(url);
        }
        return list;
      }
  }
    return null;
  }
  else
  {
  MetaData meta = new MetaData(request);

  ArrayList picList = new ArrayList();

  Map typeInfo = meta.getTypeInfoByTypeId(typeId);

  if(null != typeInfo && typeInfo.size() > 0)
  {
    Map posters = (Map)typeInfo.get("POSTERPATHS");

    if(null != posters && posters.size() > 0)
    {
      Iterator it = posters.keySet().iterator();

      if(it.hasNext())
      {
        String[] pics = (String[])posters.get((String) it.next());
        if(pics != null && pics.length > 0)
        {
          int lenx = (station + length > pics.length) ? pics.length : (station + length);
          for(int i = station; i < lenx; i++)
          {
            picList.add(pics[i]);
          }
        }
      }
    }
  }
  return picList;
  }
}

  
/*
 * �жϵ�ǰvod�Ƿ�ɲ�
 * @param HttpServletRequest request �������
 * @param definition vod֧�ֵ�ý�岥�Ÿ�ʽ 1 ���� 2 ����
 *
 */
public boolean applyHD(HttpServletRequest req,int definition)
{
  String tempDecodemode = (String)req.getSession().getAttribute("decodemode");
  String [] decodemodeArray = tempDecodemode.split(";");
  int length = decodemodeArray.length;
  int temp = 0;
  if(null != decodemodeArray && length > 0)
  {
    for(int i = 0 ; i < length ; i++)
    {
      if(decodemodeArray[i].endsWith("HD"))
      {
        temp = 1;
        break;
      }
    }
  }
  if( 1 == temp || (temp == 0 && 2 == definition))
  {
    return true;
  }
  return false;
}

/*
 * �жϵ�ǰvod�Ƿ�ɲ�
 * @param HttpServletRequest request �������
 * @param definition vod֧�ֵ�ý�岥�Ÿ�ʽ 1 ���� 2 ����
 *
 */
public boolean applyHD(HttpServletRequest req,int definition,String vediaType)
{
  String tempDecodemode = (String)req.getSession().getAttribute("decodemode");
  String [] decodemodeArray = tempDecodemode.split(";");
  int length = decodemodeArray.length;
  int temp = 0;
  int temp1= 0;
  
  if(null != decodemodeArray && length > 0)
  {
    for(int i = 0 ; i < length ; i++)
    {
      if(decodemodeArray[i].endsWith("HD"))
      {
        temp = 1;
        break;
      }
/*      if(decodemodeArray[i].startsWith(vediaType.substring(0,3)))
      {
        temp1 = 3;
      }*/
      //��MPEG2����MPEG4ת����MPEG-2MPEG-4
      if("MPEG2".equals(vediaType))
      {
        vediaType = "MPEG-2";
      }
      else if("MPEG4".equals(vediaType))
      {
        vediaType = "MPEG-4";
      }
      else if("".equals(vediaType))
      {
        vediaType = "MPEG-2";
      }
      if(decodemodeArray[i].equals(vediaType))
      {
        temp1 = 3;
      }
      else
      {
        temp1 = 4;
      }
    }
  }
 
  if( 1 == temp || (temp1 == 3 && definition == 2))
  {
    return true;
  }
  return false;
}

/*
*��ȡǿ���Ƽ�����·��
*/
public String getPosterByMap(Map poster) 
{
	String picPath = "";
	//��ȡ������Ϣmap {�������ͣ�{���򣬱��溣��·����list}} ·��	
	if(null != poster && poster.size() > 0)
	{
		Set set = poster.keySet();
		Iterator it = set.iterator();
		if (it.hasNext()) 
		{
			HashMap typeMap = (HashMap) poster.get(it.next());
			set = typeMap.keySet();
			it = set.iterator();
			if (it.hasNext()) 
			{
				ArrayList picList = (ArrayList) typeMap.get(it.next());
				if (picList != null && !picList.isEmpty()) 
				{
					picPath = (String) picList.get(0);
				}
			}
		}
	}
	return picPath;
}
%>
