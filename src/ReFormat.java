import com.huawei.basetype.soap.bean.Message;
import com.huawei.iptvmw.epg.mashup.util.StringUtil;
import com.sleepycat.je.log.FileReader;
import com.sun.javafx.binding.StringFormatter;
import com.sun.xml.internal.messaging.saaj.util.ByteOutputStream;
import org.apache.xerces.utils.regex.Match;

import java.io.*;
import java.security.MessageDigest;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by admin on 14-11-14.
 */
public class ReFormat {
    public static void main(String[] args) throws Throwable{
        /*File folder = new File("/workspace/sources/Java/HWWorkspace/HWWorkspace//web/EPG/jsp/neirong");
        File[] files = folder.listFiles();
        ByteOutputStream outputStream = new ByteOutputStream();
        Pattern pattern = Pattern.compile("<style>([\\S\\s]*?)</style>");
        for(File file : files){
            if(file.isDirectory())continue;
            byte[] buffer = new byte[4096];
            FileInputStream stream = new FileInputStream(file);
            int len = 0;
            while ((len = stream.read(buffer)) > 0)
                outputStream.write(buffer,0,len);
            stream.close();
            outputStream.flush();
            buffer = outputStream.getBytes();
            String content = new String(buffer,"utf-8");
            String style = "";
            content = content.substring(0, content.indexOf("</html>") + 7);
            Matcher matcher = pattern.matcher(content);
            if(matcher.find())
                style = matcher.group(1);

            if(style != null && !style.equalsIgnoreCase("")){
                style = style.replaceAll("\\s+"," ").replaceAll("\\}","}\n    ");
                style = "\n    " + style.substring(0,style.length() - "    ".length());
                System.out.print(style);
                content = content.replace(matcher.group(1),style);
            }

            FileOutputStream out = new FileOutputStream(file);
            content = new String(content.getBytes("GBK"),"gb2312");
            out.write(content.getBytes("gb2312"));
            out.flush();
            out.close();
        }*/
        /*
        String[] areas = ("渝中区\n" +
                "大渡口\n" +
                "江北区\n" +
                "沙坪坝\n" +
                "九龙坡\n" +
                "南岸区\n" +
                "北碚区\n" +
                "渝北区\n" +
                "巴南区\n" +
                "涪陵区\n" +
                "长寿区\n" +
                "江津区\n" +
                "合川区\n" +
                "永川区\n" +
                "南川区\n" +
                "綦江区\n" +
                "大足区\n" +
                "潼南县\n" +
                "铜梁县\n" +
                "荣昌县\n" +
                "璧山县\n" +
                "万盛\n" +
                "双桥\n" +
                "万州区\n" +
                "梁平县\n" +
                "城口县\n" +
                "丰都县\n" +
                "垫江县\n" +
                "忠县\n" +
                "开县\n" +
                "云阳县\n" +
                "奉节县\n" +
                "巫山县\n" +
                "巫溪县\n" +
                "黔江区\n" +
                "武隆县\n" +
                "石柱县\n" +
                "秀山县\n" +
                "酉阳县\n" +
                "彭水县").split("\n");
        System.out.println(areas.length);
        String content = "";
        for(String str: areas ){
            content += "md D:\\FTP\\" + str + "\\区县视窗\r\n";
        }

        FileOutputStream outputStream = new FileOutputStream("/home/admin/Downloads/FTP/创建目录.bat");
        outputStream.write(content.getBytes("GB2312"));
        outputStream.flush();
        outputStream.close();


        byte[] pwd ;
        MessageDigest md5 = MessageDigest.getInstance("MD5");

        content = "";
        Random random = new Random(System.currentTimeMillis());

        String[] areas1 = ("渝中\n" +
                "大渡口\n" +
                "江北\n" +
                "沙坪坝\n" +
                "九龙坡\n" +
                "南岸\n" +
                "北碚\n" +
                "渝北\n" +
                "巴南\n" +
                "涪陵\n" +
                "长寿\n" +
                "江津\n" +
                "合川\n" +
                "永川\n" +
                "南川\n" +
                "綦江\n" +
                "大足\n" +
                "潼南\n" +
                "铜梁\n" +
                "荣昌\n" +
                "璧山\n" +
                "万盛\n" +
                "双桥\n" +
                "万州\n" +
                "梁平\n" +
                "城口\n" +
                "丰都\n" +
                "垫江\n" +
                "忠县\n" +
                "开县\n" +
                "云阳\n" +
                "奉节\n" +
                "巫山\n" +
                "巫溪\n" +
                "黔江\n" +
                "武隆\n" +
                "石柱\n" +
                "秀山\n" +
                "酉阳\n" +
                "彭水").split("\n");

        int ix = 0;
        for(String str: areas1 ){

            pwd = str.getBytes("utf-8");
            // 使用指定的字节更新摘要
            md5.update(pwd);
            // 获得密文
            byte[] md = md5.digest();
            String password = toString(md,4,random.nextBoolean());
            content += str + " " + password + "\r\n";

            outputStream = new FileOutputStream("/home/admin/Downloads/FTP/" + str + ".ini");
            md5.update(password.getBytes());
            outputStream.write(MessageFormat.format(settings,"D:\\FTP\\" + areas[ix++], toString(md5.digest())).replaceAll("\n","\r\n").getBytes("UTF8"));
            outputStream.flush();
            outputStream.close();
        }

        outputStream = new FileOutputStream("/home/admin/Downloads/FTP/密码.txt");
        outputStream.write(content.getBytes("UTF8"));
        outputStream.flush();
        outputStream.close();*/


        /*File file = new File("/workspace/download/New Folder/1321213.txt");
        FileInputStream stream = new FileInputStream(file);
        byte[] buffer = new byte[(int)file.length()];
        stream.read(buffer);
        stream.close();
        String bufferStr = new String(buffer,"gbk");
        buffer = null;
        Pattern pattern = Pattern.compile("颜色分类：([^<]*)(?:(（)?\\d*粒.*?(）)?)");
        Matcher match = pattern.matcher(bufferStr);
        ArrayList<String> list = new ArrayList<String>();
        while (match.find()){
            String str = match.group(1).replaceAll("\\d+","").replaceAll("（", "");
            if( list.contains( str ))
                System.out.println( str + ": " + "重复");
            else
                list.add(str);
        }

        for(String str : list ) System.out.println(str);*/

        String[] servicesIds = "3,4,54,17,71,52,67,141,68,104,139,252,244,251,23,22,164,165,176,53,14,46,270,34,35,50,45,20,162,18,248,150,29,144,253,106,19,250,174,88,85,155,102,154,157,153,138,63,9,11,12,247,131,90,92,101,93,83,133,145,94,103,249,96,151,147,97,152,105,142,136,129,140,110,125,77,76,148,132,62,109,158,111,149,113,246,245,267,268,257,178,269,166,167,254,55,177,169,170,171,260,266,265,259,264,263,262,261,255,258,256".split(",");
        for ( String servicesId : servicesIds ) {
            int count = 0;
            for ( String service : servicesIds ) {
                if( service.equalsIgnoreCase( servicesId )) count ++;
            }
            if( count > 1 ) {
                System.out.println( servicesId );
            }
        }

/*

        File file = new File("/workspace/sources/Java/HWWorkspace/HWWorkspace/upgrade/Channel.txt");
        FileInputStream stream = new FileInputStream(file);
        byte[] buffer = new byte[(int)file.length()];
        stream.read(buffer,0,buffer.length);
        stream.close();
        String[] channels = new String(buffer, "utf-8").replaceAll("\n",";").split(";");
        buffer = null;

        String ids = "";

         for (String line : channels ) {
            line = line.trim();
            if(StringUtil.isEmpty( line )) continue;
            String[] params = line.split(" ");
            if( params.length > 5 ) {
                params[3] += " " + params[4];
                params[4] = params[5];
            }

            String insert = MessageFormat.format("IF EXISTS ( SELECT ID FROM [Channel] WHERE [ServicesId] = {1} ) BEGIN UPDATE [Channel] SET [Source] = {2},[Name] = ''{0}'',[ReFilePattern] = ''{3}'',[IsReplay] = 1,[VODID] = ''{4}'' WHERE [ServicesId] = {1} END ELSE BEGIN INSERT INTO [Channel] ([Name],[ServicesID],[Source],[FilePattern],[IsReplay],[ReFilePattern],[VODID]) VALUES (''{0}'',{1},{2},''{3}'',1,''{3}'',''{4}''); END;",
                params[1], params[4], params[2], params[3],params[0]
            );

            ids += params[4] + ",";
           System.out.println( insert );
        }
        System.out.println( ids );*/
        String sql = "";
        String[] ids = "3,4,54,17,71,52,67,141,68,104,139,252,244,251,23,22,164,165,176,53,14,46,270,34,35,50,45,20,162,18,248,150,29,144,253,106,19,250,174,88,85,155,102,154,157,153,138,63,9,11,12,247,131,90,92,101,93,83,133,145,94,103,249,96,151,147,97,152,105,142,136,129,140,110,125,77,76,148,132,62,109,158,111,149,113,246,245,267,268,257,178,269,166,167,254,55,177,169,170,171,260,266,265,259,264,263,262,261,255,258,256".split(",");
        for (String id : ids) {
            String insert = MessageFormat.format("IF EXISTS ( SELECT ID FROM [Role] WHERE [Channel] = {0} AND [User] = 9 AND [IsReplay] = 0 ) BEGIN UPDATE [Role] SET [Right] = ''E:1,1:1'' WHERE [Channel] = {0} AND [User] = 9 AND [IsReplay] = 0  END ELSE BEGIN INSERT INTO [Role] VALUES (9,{0},''E:1,1:1'',0); END;\n", id);
            sql += insert;
            insert = MessageFormat.format("IF EXISTS ( SELECT ID FROM [Role] WHERE [Channel] = {0} AND [User] = 9 AND [IsReplay] = 1 ) BEGIN UPDATE [Role] SET [Right] = ''E:1,1:1'' WHERE [Channel] = {0} AND [User] = 9 AND [IsReplay] = 1  END ELSE BEGIN INSERT INTO [Role] VALUES (9,{0},''E:1,1:1'',1); END;\n", id);
            sql += insert;
        }

        System.out.println(sql);
    }

    private static final String settings = "[Account]\n" +
            "AccessList0=/,{0},RWDA,FDMRI---\n" +
            "CreationDate=2015/03/24 12:17:26\n" +
            "Enabled=-1\n" +
            "IncomingFXPAllowed=0\n" +
            "OutgoingFXPAllowed=0\n" +
            "Password=MD5:{1}\n" +
            "PasswordEnabled=-1\n" +
            "Address=\n" +
            "ByPassDomainMaxClients=0\n" +
            "ByPassDomainMaxConnectionsPerIP=0\n" +
            "CanChangePassword=-1\n" +
            "City=\n" +
            "Company=\n" +
            "CWDMessageFile=\n" +
            "DisabledCommands=\n" +
            "Email=\n" +
            "ExcludedListOptions=\n" +
            "ExpirationDate=2015/03/24\n" +
            "ExpirationEnabled=0\n" +
            "Fax=\n" +
            "Group=\n" +
            "HideHiddenFiles=0\n" +
            "LogEnabled=-1\n" +
            "Notes=\n" +
            "PhoneHome=\n" +
            "PhoneWork=\n" +
            "QuotaCheckOnLogin=-1\n" +
            "QuotaEnabled=0\n" +
            "RatioEnabled=0\n" +
            "RealName=\n" +
            "SecureOnly=0\n" +
            "SessionTimeOutEnabled=0\n" +
            "TimeOfDayAccess0=-1,07:00:00-19:00:00\n" +
            "TimeOfDayAccess1=-1,07:00:00-19:00:00\n" +
            "TimeOfDayAccess2=-1,07:00:00-19:00:00\n" +
            "TimeOfDayAccess3=-1,07:00:00-19:00:00\n" +
            "TimeOfDayAccess4=-1,07:00:00-19:00:00\n" +
            "TimeOfDayAccess5=-1,07:00:00-19:00:00\n" +
            "TimeOfDayAccess6=-1,07:00:00-19:00:00\n" +
            "TimeOfDayAccessEnabled=0\n" +
            "TimeOutEnabled=-1\n" +
            "TransferLimitDownloadEnabled=0\n" +
            "TransferLimitType=never\n" +
            "TransferLimitUploadEnabled=0\n" +
            "WelcomeMessageFile=\n" +
            "StatsDownloaded=\n" +
            "StatsLastIP=\n" +
            "StatsLastLogin=\n" +
            "StatsLastUsername=\n" +
            "StatsLogin=\n" +
            "StatsUploaded=\n" +
            "Scripts0=Log downloads.vbs\n" +
            "Scripts1=Log uploads.vbs\n" +
            "Scripts2=SiteCommands.vbs";
    private static String toString(byte[] bytes){
        return toString(bytes,bytes.length,false);
    }
    //50000
    private static String toString(byte[] bytes, int length, boolean lowerCase){
        char hexDigits[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','a','b','c','d','e','f'};

        char[] chars = new char[length * 2];
        int k = 0;
        for (int i = 0; i < length; i++) {
            byte byte0 = bytes[i];
            int index = byte0 >>> 4 & 0xf;
            if( index >= 10 && lowerCase) {
                chars[k++] =  hexDigits[index + 6];
            } else {
                chars[k++] = hexDigits[index];
            }
            index = byte0 & 0xf;
            if( index >= 10 && lowerCase) {
                chars[k++] =  hexDigits[index + 6];
            } else {
                chars[k++] = hexDigits[index];
            }
        }

        return new String(chars);
    }
}
