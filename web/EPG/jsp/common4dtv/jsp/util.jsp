<%@ page language="java" pageEncoding="GBK"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelp" %>
<%!
/* 字母集合 */
private static final String[] caseChar = {"a", "b", "c", "d", "e", "f", "g",
  "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
  "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I",
  "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
  "X", "Y", "Z",
  "`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "~",
  "!", "@", "#", "$", "%", "^", "&;", "*", "(", ")", "_", "+", "&",
  "[", "]", ";", "'", ".", "/", "\\", "{", "}", ":", "\"", "<", ">",
  "?", "|", "~", "！", "·", "#", "￥", "%", "……", "—", "（", "）", "——",
  " ", "。", "：", "，"};

/* 字母对象的像素 */
private static final int[] pxChar = {10, 10, 9, 10, 10, 6, 10,
  10, 5, 5, 9, 5, 14, 10, 10, 10, 10, 7, 9, 6, 10,
  9, 12, 9, 9, 9, 11, 11, 12, 12, 11, 11, 13, 12, 6,
  9, 11, 10, 14, 12, 13, 11, 13, 12, 11, 11, 12, 11, 16,
  11, 11, 11,
  7, 10, 10, 10, 10, 10, 10, 10, 10,
  10, 10, 6, 11, 11, 6, 22, 11, 10, 20, 10, 16, 10, 7, 7, 11, 11, 11,
  6, 6, 6, 5, 6, 7, 4, 7, 7, 6, 4, 11, 11, 10, 6, 11, 10, 17, 11, 19,
  17, 36, 19, 19, 19, 19, 6, 10, 12, 12};

/* 重庆Ipanel默认字号下非英文字母显示的像素 */
private static final int perChar_en = 6;

/* 重庆Ipanel默认字号下中文显示的像素 */
private static final int perChar_cn = 17;

/**
 * 按输出的编码格式截取字符串
 *
 * @param targetStr 需截取的字符串
 * @param enCoding 编码格式
 * @param nlen 截取的长度
 * @throws UnsupportedEncodingException
 */
public List subString(String targetStr, String enCoding, int nLen) throws UnsupportedEncodingException
{
  // 参数有效性判断
  targetStr = (null == targetStr) ? "" : targetStr.trim();
  enCoding = (null == enCoding) ? "" : enCoding.trim();
  // 只处理GBK和UTF-8两种字符集
  if ("".equals(targetStr))
  {
    return null;
  }
  if (!"GBK".equalsIgnoreCase(enCoding) && !"UTF-8".equalsIgnoreCase(enCoding))
  {
    return null;
  }

  // 目标字符串
  targetStr = new String(targetStr.getBytes(enCoding), enCoding);

  // 返回的结果
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

    // 判断是否为Ascii字符
    if (isLetter(tempChar))
    {
      n += (tempN == 0) ? perChar_en : tempN;
    }
    else
    {
      n += (tempN == 0) ? perChar_cn : tempN;
    }

    // 没行读取一定的字符串
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
 * 判断一个字符是Asscii字符还是其它字符
 *
 * @param c 需要进行判断的字符
 * @return 是否是Asscii字符
 */
private boolean isLetter(char c)
{
  int k = 0x80;
  return c / k == 0 ? true : false;
}

/**
 * 获取页面海报服务器中commom文件夹中的文件
 * @param HttpServletRequest request 请求对象
 * @param String prefix 前缀
 * @param String typeId 要获取的文件的名称
 * @return String 当文件存在的时候返回文件的名称，如果文件不存在则返回一个"false"的字符串
 * **/
public String hasPicture(HttpServletRequest request,String prefix,String typeId)
{
  String resultStr = request.getContextPath()+"/jsp/images/universal/film/common/"+prefix+typeId+".gif";
  return resultStr;
}

/*
 * 获取上方的静态图片数据
 * @param int num要显示的静态图片数量
 * @param String folder 在/jsp/images/universal/film/下对应的具体文件夹
 */
public List getStaticPic(int num, String folder, HttpServletRequest request)
{
  //得到服务器的根路径
  String rootPath = getClass().getClassLoader().getResource("").getPath();
  String filePath = rootPath+"/jsp/images/universal/film/"+folder+"/";
  //根据获取的图片路径来找到文件夹获取内容
  File file = new File(filePath);
  String[] picList = file.list();
  String[] picNewList = null;
  int getPicNum = 0;//得到的真实图片数量

  //取到picList的长度
  if(null != picList)
  {
    int j=0;
    getPicNum = picList.length;
    picNewList = new String[getPicNum];
    //把符合要求的图片重新封装一次
    for(int i=0; i<getPicNum; i++)
    {
      //判断是否是一jpg和gif结尾，如果是就放入数组中
      if(picList[i].endsWith(".jpg") == true || picList[i].endsWith(".gif") == true)
      {
        picNewList[j] = picList[i];
        j++;
      }
    }
    getPicNum = j;
  }
  //显示的图片数量
  int factPicNum = getPicNum;
  if(getPicNum > num)
  {
    factPicNum = num;
  }

  String tempPath = request.getContextPath()+"/jsp/images/universal/film/"+folder+"/";
  List staticPicList = new ArrayList();
  String path;
  //把路径列表封装到一个list中
  for(int i=0; i<factPicNum; i++)
  {
    path = "";
    //拼装路径，因为是在webserver下使用，所以需要的是相对路径
    path = tempPath+picNewList[i];
    path=path.replaceAll("//","/");
    staticPicList.add(path);
  }
  return staticPicList;
}

/**
*截取字符串，截取后不加点的方法
*@param String 完整的字符串
*@param int 显示字符的最大长度
*/
public String subString(String entireStr,int len)
{
  //截取栏目名称，栏目名称长度限制在len个字符之内
  if(entireStr.length()>len)
  {
    entireStr = entireStr.substring(0,len);
  }
  return entireStr;
}

/**
*截取字符串，截取字符串后加点的方法
*@param String 完整的字符串
*@param int 显示字符的最大长度
*/
public String subString1(String entireStr,int len)
{
  //截取栏目名称，栏目名称长度限制在len个字符之内
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
*获取配置的logo路径
*@param String 根据栏目id+logo来唯一标示logo
*/
public String getLogoPath(String typeId,HttpServletRequest request)
{
  String logo = request.getContextPath()+"/jsp/images/universal/film/logo/"+typeId+"logo.gif";
  return logo;
}

/**
* 取公告的信息
* @param String typeId 栏目的id
* @param int 获取公告栏目的id最长长度，如果不给定（赋值0），默认为6位
* @return bullVo 公告对象
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
      
      // 截取公告标题前面数字部分，比较是否跟指定的栏目编号一致
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

/** 函数作用：截取标题中的前端数字 */
/** 参数：s需要截取的字符串 */
/** 返回值：截取后的字符串 */
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
 * 如果取到图片路径，且物理上存在该图片，返回该图片路径<br>
 * 如果取到图片路径，但物理上不存在该图片，返回默认路径<br>
 * 如果取不到该图片路径，返回默认路径<br>
 *
 * @param targetPath 目标图片路径
 * @param defaultPath 默认图片路径
 * @param type 目标图片类型  参数:0 vod海报，1 adv海报
 * @param request 请求对象
 * @return resultPath 返回的路径
 */
public static String getPicPath(
                                String targetPath,
                                String defaultPath,
                                int type,
                                HttpServletRequest request)
{
  // 需要返回的路径
  String resultPath = targetPath;
  // 目标图片类型对应的路径
  String[] type_target = {"images/universal/film",
                          "images/universal/adv"
                          };

  // 目标图片的类型
  if (type < 0 || type > 2)
  {
      return defaultPath;
  }

  // 目标路径如果为空
  if (null == targetPath || "".equals(targetPath.trim()))
  {
      return defaultPath;
  }

  // 如果不是以jpg, gif, bmp, png ，返回默认图片
  String temp_path = targetPath;
  temp_path = temp_path.toUpperCase();
  if (temp_path.lastIndexOf(".GIF") == -1
      && temp_path.lastIndexOf(".JPG") == -1
      && temp_path.lastIndexOf(".BMP") == -1
      && temp_path.lastIndexOf(".PNG") == -1)
  {
    return defaultPath;
  }

  // vod，adv 对应的文件夹索引
  int folderNum = targetPath.lastIndexOf(type_target[type]);
  if(folderNum > 0) // 如果是VOD，ADV对应的文件夹
  {
    String folderPath = targetPath.substring(folderNum);
    {
      // 拼接路径
      String pagePath = request.getRealPath("./");
      String joinPath = pagePath + "/jsp/" + folderPath;

      File imagesFile = new File(joinPath);
      // 如果图片路径是目录
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
  else // 否则替换为默认图片
  {
    resultPath = defaultPath;
  }

  return resultPath;
}

/**
 * 判断获取的海报，LOGO，广告位图片是否存在
 * @param request 请求对象
 * @return boolean 路径是否存在
 */
public static boolean isImageExist(
                                String imagePath,
                                HttpServletRequest request)
{
  //处理获取的图片路径
  imagePath = imagePath.replace("../../","");
  
  
  //拼接图片的服务器段路径
  String rootPath = request.getRealPath("/");
  String filePath = rootPath+"jsp/" + imagePath;
  
  
  File image = new File(filePath);
  
  return (image.exists() && !image.isDirectory());
}

/**
 * 如果取到图片路径，且物理上存在该图片，返回该图片路径<br>
 * 如果取到图片路径，但物理上不存在该图片，返回默认路径<br>
 * 如果取不到该图片路径，返回默认路径<br>
 *
 * @param typeId 图片所在的栏目
 * @param defaultPath 默认图片路径
 * @param type 目标图片类型  参数:0 缩略图，1 海报 ，2 剧照 ，3 图标 
 * 4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ，
 * 10 频道名字图片 ， 11 其他
 * @param request 请求对象
 * @return picPath 返回的路径
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
*获取强档推荐链表
*/
 public List getBlockbusterDataList (String typeId, int length, int station,HttpServletRequest request,
                                    HttpServletResponse response)throws Exception
{
  //获取数据的对象MetaData
  MetaData meta = new MetaData(request);

  //调用后台的接口来获得强档推荐的链表
    List blockbusterList = null;
    //强档推荐数据列表
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
*根据栏目id作为广告外部编号来获取广告路径
*@param String 栏目id作为广告位的编号
*@param HttpServletRequest 请求对象
*@param length 取数据的长度
*@param station 取数据的起始位置
*@return 返回广告路径List,否则返回null
*/
public List getPosterPaths(String typeId , int length, int station, HttpServletRequest request)
{
  String requesturl = request.getRequestURI();
  // 首页
  if(requesturl.indexOf("Category.jsp") != -1)
  {
    ServiceHelp serHelp = new ServiceHelp(request);
    MetaData meta = new MetaData(request);

    //查询增值业务列表
    List vasList = meta.getVasListByTypeId(typeId, length, station);
    if(null != vasList)
    {
      Map countMap = (Map)vasList.get(0);
      int count = ((Integer)countMap.get("COUNTTOTAL")).intValue();
      //如果总数大于0
      if(count > 0)
      {
        List list = new ArrayList();
        List tempVasList = (List)vasList.get(1);
        for(int i = 0; i < tempVasList.size(); i ++)
        {
          //增值业务对象
          Map vasObj = (Map)tempVasList.get(i);
          //获取增值业务对象的Id
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
 * 判断当前vod是否可播
 * @param HttpServletRequest request 请求对象
 * @param definition vod支持的媒体播放格式 1 高清 2 标清
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
 * 判断当前vod是否可播
 * @param HttpServletRequest request 请求对象
 * @param definition vod支持的媒体播放格式 1 高清 2 标清
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
      //将MPEG2或者MPEG4转化成MPEG-2MPEG-4
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
*获取强档推荐海报路径
*/
public String getPosterByMap(Map poster) 
{
	String picPath = "";
	//获取海报信息map {海报类型，{领域，保存海报路径的list}} 路径	
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
