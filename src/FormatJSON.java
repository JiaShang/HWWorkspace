import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.sleepycat.persist.impl.SimpleFormat;
import jdk.nashorn.internal.runtime.regexp.joni.Regex;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by admin on 2/22/17.
 */
public class FormatJSON {
    public static void main( String[] args ) {
        /*JsonParser parser=new JsonParser();  //创建JSON解析器
        try {

            File file = new File("/home/admin/Downloads/media/hddb_topic.txt");
            FileInputStream stream = new FileInputStream(file);
            byte[] buffer = new byte[(int)file.length()];
            stream.read(buffer,0,buffer.length);
            stream.close();
            String jsonStr = new String( buffer, "GB2312");
            JsonObject object=(JsonObject) parser.parse(jsonStr);
            JsonArray array=object.get("data").getAsJsonArray();    //得到为json的数组
            buffer = null;
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            Pattern pattern = Pattern.compile(".*S(\\d{8})\\.jsp*");
            String date = "2016-01-01";
            for(int i=0;i<array.size();i++){
                JsonObject subObject=array.get(i).getAsJsonObject();
                String element = "{\r\n\t\"id\":" + ( i + 1 ) + ",\r\n";
                element += "\t\"name\":\"" + subObject.get("name").getAsString() + "\",\r\n";
                String url = subObject.get("url").getAsString();
                element += "\t\"url\":\"" + url + "\",\r\n";
                Matcher matcher = pattern.matcher( element );
                if( matcher.find() ) {
                    String dt = matcher.group(1);
                    date = dt.substring(0,4) + "-" + dt.substring(4,6) + "-" + dt.substring(6,8);
                }
                element += "\t\"uptime\":\"" + date + "\"\r\n},";


                System.out.println(element);
            }

        } catch (Exception e ) {

        }*/

        /*String str = "这是一个测试呼的";
        System.out.println(str.substring(0,4));*/
        String[] commands = {" rm -rf /home/iptv/epg/epg-tomcat/tomcat-6.0.18/webapps/EPG/jsp/defaultHD/en/hddb/zuiCQ/img/index_poster04.jpg"," rm -rf /home/iptv/epg/epg-tomcat/tomcat-6.0.18/webapps/EPG/jsp/defaultHD/en/hddb/zuiCQ/img/ksc_poster.jpg"};
        String[] servers = "192.168.74.9|192.168.74.8|192.168.74.13|192.168.74.12|192.168.74.11|192.168.74.10|192.168.13.99|192.168.13.63|192.168.13.62|192.168.13.220|192.168.13.22|192.168.13.218|192.168.13.217|192.168.13.216|192.168.13.215|192.168.13.214|192.168.13.213|192.168.13.212|192.168.13.211|192.168.13.210|192.168.13.21|192.168.13.209|192.168.13.208|192.168.13.207|192.168.13.206|192.168.13.205|192.168.13.190|192.168.13.189|192.168.13.188|192.168.13.187|192.168.13.186|192.168.13.185|192.168.13.184|192.168.13.183|192.168.13.178|192.168.13.177|192.168.13.176|192.168.13.175|192.168.13.173|192.168.13.172|192.168.13.170|192.168.13.169|192.168.13.168|192.168.13.167|192.168.13.166|192.168.13.165|192.168.13.164|192.168.13.163|192.168.13.162|192.168.13.161|192.168.13.133|192.168.110.187|192.168.110.186|192.168.110.185|192.168.110.184|192.168.110.183|192.168.110.182|192.168.110.181|192.168.110.180|192.168.110.179|192.168.110.178|192.168.110.177|192.168.110.176|192.168.110.175|192.168.110.174|192.168.110.173|192.168.110.172|192.168.110.171|192.168.110.170|192.168.110.169|192.168.110.168|192.168.110.167|192.168.110.166|192.168.110.165|192.168.110.164|192.168.110.163|192.168.110.162|192.168.110.161|192.168.110.160|192.168.110.159|192.168.110.158|192.168.110.157|192.168.110.156|192.168.110.155|192.168.110.154|192.168.110.152|192.168.110.151|192.168.110.150|192.168.110.149|192.168.110.148|192.168.110.147|192.168.110.146|192.168.110.145|192.168.110.144|192.168.110.143|192.168.110.142|192.168.110.141|192.168.110.140|192.168.110.139|192.168.110.138|192.168.110.137|192.168.110.136|192.168.110.135|192.168.110.134|192.168.110.133|192.168.110.132|192.168.115.4|192.168.115.5|192.168.115.6|192.168.115.7|192.168.115.8|192.168.115.9|192.168.115.10|192.168.115.11|192.168.115.12|192.168.115.13|192.168.115.14|192.168.115.15|192.168.115.68|192.168.115.69|192.168.115.70|192.168.115.71|192.168.115.72|192.168.115.73|192.168.115.74|192.168.115.75|192.168.115.76|192.168.115.77|192.168.115.78|192.168.115.79|192.168.115.80|192.168.115.81|192.168.115.82|192.168.110.153|192.168.13.134|192.168.65.20|192.168.115.16|192.168.115.17|192.168.115.18|192.168.115.19|192.168.115.20|192.168.115.21|192.168.115.22|192.168.115.23|192.168.115.24|192.168.115.25|192.168.115.26|192.168.115.27|192.168.115.83|192.168.115.84|192.168.115.85|192.168.115.86|192.168.115.87|192.168.115.88|192.168.115.89|192.168.115.90|192.168.115.91|192.168.115.92|192.168.115.93|192.168.115.94|192.168.13.108|192.168.65.22".split("\\|");
        for( int i = 0; i < servers.length; i ++ ){
            System.out.println("ssh root@" + servers[i] + commands[0]);
            System.out.println("ssh root@" + servers[i] + commands[1]);
            System.out.println();
        }

    }
}
