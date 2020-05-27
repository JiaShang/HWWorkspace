import java.io.*;

public final class FilterTxt {
    public static void main(String[] args){
        FilterTxt filter = new FilterTxt();
        filter.Lisp(new File("/Users/admin/Desktop/shuju"));
    }

    private void Lisp(File file){
        File[] files = file.listFiles();
        for( File f : files ) {
            if(f.isDirectory()){
                Lisp( f );
                continue;
            }

            filter( f );
        }
    }

    private void filter(File file){
        try {
            BufferedReader reader = new BufferedReader( new FileReader( file ) );
            BufferedWriter writer = new BufferedWriter( new FileWriter( file.getAbsolutePath() + "-out.txt" ));
            String line = null;
            while ( ( line = reader.readLine() ) != null ) {
                if( line.indexOf("null") > 0 ) {
                    writer.write(line + "\n");
                }
            }
            writer.flush();
            writer.close();
            reader.close();
        } catch (Throwable e){
            e.printStackTrace();
        }
    }
}
