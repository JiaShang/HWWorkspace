<%@ page import="java.net.URLDecoder" %>
<%@ include file="include.jsp" %>
<%
    /**
     * 本页面参数说明:
     *
     * id : 栏目ID, 视频或影片的内部ID(也可以是外部ID)
     * enc: 调用返回的编码参数, 如果enc不为空,则使用GB18030编码,否则使用UTF8编码
     * idType: column(栏目),FSN(外部ID),inner(内部ID)
     * act: 为空时,取栏目,影片或连续剧的详细信息
     *      为0时,取栏目下绑定的VOD的内容
     *      为1时,取栏目下绑定的子栏目的内容.
     *      为2时,取栏目下的子栏目中(用cn指定子栏目个数)绑定的VOD的内容
     * cn:  当act==1,act==2时,指定取子栏目的个数,默认为199个
     * fn:  当act==0,act==2时,指定取子栏目中VOD的个数
     * rmChs: 删除指定符号中的字符串
     * script: 如果 script 不为空，返回 var data = {}; 的 json 字符串
     */
    inner.turnPage.removeLast();

    if( !isEmpty( inner.get("enc") ) ) { inner.setEncoding("GB18030");}
    String id = inner.get("id");
    String action = inner.get("act");
    boolean isScript = !isEmpty(inner.get("script"));
    inner.setJsonHeader(inner.encoding);

    Result result = new Result();
    if( isEmpty(id) || id.indexOf(',') >= 0 && isEmpty( action )) {
        result.setSuccess(false);
        result.setId( isEmpty(id) ? "empty" : id );
        result.setMessage(URLDecoder.decode(isEmpty(id) ? "%E5%8F%82%E6%95%B0%20id%20%E4%B8%8D%E8%83%BD%E4%B8%BA%E7%A9%BA" : "%E5%8F%82%E6%95%B0%20action%20%E4%B8%8D%E8%83%BD%E4%B8%BA%E7%A9%BA"));
        inner.write(result, true);
        return;
    }

    if( isEmpty( action ) ) {
        String idType = inner.get("idType");
        if( isEmpty(idType) || !idType.equalsIgnoreCase("FSN") && !idType.equalsIgnoreCase("column")){
            idType = isNumber(id) ? ( id.length() <= 8 ? "inner" : "column") : "FSN";
        }

        result = idType.equalsIgnoreCase("column") ? inner.getTypeDetail(id) : inner.getVodDetail(id, idType.equalsIgnoreCase("FSN"));
        result.setSuccess(result.getData() != null);
        inner.write(inner.writeObject( result.success ? result.getData() : result, rmChars));
    } else {
        List list = new ArrayList();
        HashMap<String,Object> map = new HashMap<String, Object>();
        Column column = null;
        int cn = inner.getInteger("cn",199);
        int fn = inner.getInteger("fn",199);
        inner.setSpecial(!isEmpty(inner.get("spec")));
        if( id.indexOf(',') < 0 ) {
            column = inner.getDetail(id, new Column());
            map.put("column", column);
            result.setSuccess(true);
            if( action.equalsIgnoreCase("0") ) { /*如果 act == 0 取绑定的VOD内容*/
                list = inner.getList(id, fn ,0,new Vod());
            } else if(action.equalsIgnoreCase("1")) { /*如果act=1,仅取子栏目内容*/
                list = inner.getList(id, cn ,0, new Column());
            } else if( action.equalsIgnoreCase("2")){ /*如果act=2,仅取子栏目内容*/
                List<Column> columns = inner.getList(id, cn ,0, new Column());
                list.add(new Result(id, columns));
                for( Column col : columns ) {
                    try {
                        List<Vod> films = inner.getList(col.getId(), fn , 0, new Vod());
                        if( films != null ) {  //如果取不到栏目中绑定的影片数据，就取栏目下创建的子栏目数据
                            list.add(new Result(col.getId(), films));
                        } else {
                            List<Column> children = inner.getList(col.getId(), fn, 0, new Column());
                            list.add(new Result( col.getId(), children ));
                        }
                    } catch (Throwable e){
                        list.add( new Result(col.getId(), e.getMessage()));
                    }
                }
            } else {
                result.setSuccess(false);
                result.setMessage(URLDecoder.decode("act%20%E5%8F%82%E6%95%B0%E9%94%99%E8%AF%AF"));
            }
            map.put("list", list);
            result.setData(map);
        } else {
            String[] ids = id.split("\\,");
            List<Column> columns = new ArrayList<Column>();
            list.add(null);
            if( action.equalsIgnoreCase( "0") || action.equalsIgnoreCase("1") ) {
                for( String str : ids) {
                    if( isEmpty( str ) ) continue;
                    column = inner.getDetail( str , new Column());
                    columns.add( column );
                    try {
                        List<Vod> films = inner.getList( str , fn , 0, new Vod());
                        if( films != null ) {  //如果取不到栏目中绑定的影片数据，就取栏目下创建的子栏目数据
                            list.add(new Result(str, films));
                        } else {
                            List<Column> children = inner.getList(str, fn, 0, new Column());
                            list.add(new Result( str, children ));
                        }
                    } catch (Throwable e){
                        list.add(new Result( str, e.getMessage() ));
                    }
                }
                list.set(0, columns);
                result.setData(list);
            } else {
                for( String str : ids) {
                    if( isEmpty( str ) ) continue;
                    column = inner.getDetail( str , new Column() );
                    columns.add( column );

                    List lst = new ArrayList();
                    try {
                        List<Column> cols = inner.getList(str, cn ,0, new Column());
                        lst.add(new Result(str, cols));
                        for( Column col : cols ) {
                            List children = null;
                            try {
                                children = inner.getList(col.getId(), fn , 0, new Vod());
                                if( children != null && children.size() > 0 ){
                                    lst.add(new Result(col.getId(), children));
                                    continue;
                                }
                            } catch (Throwable t){}

                            try {
                                lst.add(new Result(col.getId(), children = inner.getList(col.getId(), fn , 0, new Column())));
                            } catch (Throwable e){
                                lst.add(new Result( col.getId(), e.getMessage()));
                            }
                        }
                        list.add(new Result( str, lst));
                    } catch (Throwable t){
                        try{
                            list.add(new Result( str, inner.getList(str, cn , 0, new Vod())));
                        } catch (Throwable e){
                            list.add(new Result( str, t.getMessage() + ":::" + e.getMessage()));
                        }
                    }
                }
                list.set(0, columns);
                result.setData(list);
            }
        }
        if( isScript ) inner.write("window.lazyLoadData = ");
        inner.write(inner.writeObject( result, rmChars ));
        if( isScript ) inner.write(";");
    }
%>