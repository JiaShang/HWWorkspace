<%@ page import="java.net.URLDecoder" %>
<%@ include file="include.jsp" %>
<%!
    //--------------------  如果党教改版完成，删除此处代码
    private HashMap<String, Result> withSubs = new HashMap<String, Result>();
    private void querySubscribe(String withId, List<Vod> list ){
    	if( list == null || list.size() <= 0) return ;
        inner.setWithId( withId );
        for( Vod vod : list ) {
            if( isEmpty(vod.getRedirect()) || withSubs.containsKey(vod.getRedirect()) ) continue;
            List<Vod> directs = inner.getList( vod.getRedirect(), 299, 0, new Vod() );
            withSubs.put( vod.getRedirect(), new Result(vod.getRedirect(), directs ));
        }
    }
    //--------------------  如果党教改版完成，删除止面的代码
%>
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
     *      为3时，根据输入的名字，搜索栏目或内容
     *      为4时，取电视剧子集信息
     * cn:  当act==1,act==2时,指定取子栏目的个数,默认为199个
     * fn:  当act==0,act==2时,指定取子栏目中VOD的个数
     * rmChs: 删除指定符号中的字符串
     * script: 如果 script 不为空，返回 var data = {}; 的 json 字符串
     *
     * sub: 当 act 为 3时，传递参数，不空空时，包括子集信息，否则不包含子集
     * stp: 当 act 为 3时，传递参数（为空时，按影片名称搜索），1：影片名称（代码），2：影片名称（汉字或字母），3：按演员名称， 4:导演, 5：外部ID, 6:按演员搜索代码
     * start: 当 act 为 3时，传递参数单次查询的起始位置
     * length: 当 act 为 3时，传递参数单次查询的最大数量
     * detail: 当 act 为 3时，detail 不为空时，且返回长度不超过200时，把影片转换成详情
     */
    inner.turnPage.removeLast();
    int cn = inner.getInteger("cn",199);
    int fn = inner.getInteger("fn",199);
    int start = inner.getInteger( "start", 0 );
    String id = inner.get("id");
    String action = inner.get("act");
    if( !isEmpty( inner.get("enc") ) ) { inner.setEncoding("GB18030");}

    inner.setJsonHeader(inner.encoding);

    //--------------------  如果党教改版完成，删除下面的
    //CommunistParty 如果是党教，会传递一个名为cp的参数;
    String withId = !isEmpty(inner.get("with")) ? inner.get("with") : "10000100000000090000000000108885"; //党教的系列剧，绑定在此栏目中
    String typeId = inner.get("typeId");
    if( isEmpty( typeId ) ) typeId = id;
    if( !isEmpty(inner.get("cp")) ) {
        List<Column> columnList = null;
        List<Vod> vodList = null;
        //列表有几种情况，第一种，直接绑定内容
        List results = new ArrayList();
        inner.setSpecial(!isEmpty(inner.get("spec")));
        //在player播放器中，会有三个参数,typeId, id , parentId;
        //当typeId和id同时存在时，取typeId进行取值，否则用id进行取值;
        //时政精读，需要从子栏目中的栏目中获取数据, act = 2
        columnList = inner.getList(typeId, cn, start, new Column());
        if( columnList != null ) {
            results.add( new Result(typeId, columnList) );
            for (Column column : columnList ) {
            	if( action.equalsIgnoreCase("2") ) {
                    List<Column> cols = inner.getList(column.id, 1, 0, new Column());
                    if( cols == null ) {
                        results.add(new Result(column.id, null));
                    } else {
                    	String subId = cols.get(0).id;
                        vodList = inner.getList(subId, fn, start, new Vod());
                        querySubscribe( withId, vodList );
                        results.add(new Result(subId, vodList));
                    }
                } else {
                    vodList = inner.getList(column.id, fn, start, new Vod());
                    querySubscribe( withId, vodList );
                    results.add(new Result(column.getId(), vodList));
                }
            }
        } else {
            vodList = inner.getList(typeId, fn, start, new Vod());
            querySubscribe( withId, vodList );
            results.add(new Result(id, vodList));
        }
        if( ! withSubs.isEmpty() ) results.addAll(Arrays.asList(withSubs.values().toArray()));
        inner.write(inner.writeObject( new Result( typeId, results ) ));
        return;
    }
    //--------------------  如果党教改版完成，删除止面的代码


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
    	//获取党教数据时，获取栏目下的栏目、栏目下的VOD内容、栏目下的栏目下的数据时，都有可能出现根据影片名称跳转的情况
        List list = new ArrayList();
        HashMap<String,Object> map = new HashMap<String, Object>();
        if( ! ( action.equalsIgnoreCase("3") || action.equalsIgnoreCase("4") ) ){
            Column column = null;
            inner.setSpecial(!isEmpty(inner.get("spec")));
            if( id.indexOf(',') < 0 ) {
                column = inner.getDetail(id, new Column());
                map.put("column", column);
                result.setSuccess(true);
                if( action.equalsIgnoreCase("0") ) { /*如果 act == 0 取绑定的VOD内容*/
                    list = inner.getList(id, fn, 0, new Vod());
                } else if(action.equalsIgnoreCase("1")) { /*如果act=1,仅取子栏目内容*/
                    list = inner.getList(id, cn ,0, new Column());
                } else if( action.equalsIgnoreCase("2")){ /*如果act=2,仅取子栏目内容*/
                    List<Column> columns = inner.getList(id, cn ,start, new Column());
                    if( columns != null ) {
                        list.add(new Result(id, columns));
                        for( Column col : columns ) {
                            List<Vod> films = inner.getList(col.getId(), fn, start, new Vod());
                            if( films != null ) {  //如果取不到栏目中绑定的影片数据，就取栏目下创建的子栏目数据
                                list.add(new Result(col.getId(), films));
                            } else {
                                List<Column> children = inner.getList(col.getId(), fn, start, new Column());
                                list.add(new Result( col.getId(), children ));
                            }
                        }
                    } else { //如果取不到栏目下的子栏目数据，就取栏目下绑定的VOD内容
                        columns = new ArrayList<Column>();
                        columns.add(column);
                        list.add(new Result(id, columns));
                        List<Vod> films = inner.getList(id, fn, start, new Vod());
                        if( films != null ) {
                            list.add(new Result(id, films));
                        }
                    }
                } else {
                    result.setSuccess(false);
                    result.setMessage(URLDecoder.decode("act%20%E5%8F%82%E6%95%B0%E9%94%99%E8%AF%AF111"));
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
                        List<Vod> films = inner.getList( str, fn, start, new Vod() );
                        //如果取不到栏目中绑定的影片数据，就取栏目下创建的子栏目数据
                        if( films != null ) {
                            list.add( new Result(str, films) );
                        } else {
                            List<Column> children = inner.getList(str, fn, start, new Column());
                            list.add(new Result( str, children ));
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
                        List<Column> cols = inner.getList(str, cn ,start, new Column());
                        if( cols != null ) {
                            lst.add(new Result(str, cols));
                            for( Column col : cols ) {
                                List children = inner.getList(col.getId(), fn , start, new Vod());
                                if( children != null ) {
                                    lst.add(new Result( col.getId(), children ));
                                } else {
                                    lst.add(new Result(col.getId(), inner.getList(col.getId(), fn , start, new Column())));
                                }
                            }
                            list.add(new Result( str, lst));
                        } else {
                            //如果取不到栏目中绑定的影片数据，就取栏目下创建的子栏目数据
                            List<Vod> films = inner.getList(str, fn, start, new Vod());
                            if( films != null && films.size() > 0 ) {
                                list.add(new Result(str, films));
                            } else {
                                list.add( new Result( str, null ) );
                            }
                        }
                    }
                    list.set(0, columns);
                    result.setData(list);
                }
            }
        } else if( action.equalsIgnoreCase("3") ) {
            int sub = isEmpty( inner.get("sub") ) ? 0 : 1;
            int stp = inner.getInteger( "stp", 2 );
            int length = inner.getInteger( "length", 999 );
            list = inner.search(id, start, length, sub, stp );
            result.setTotal( inner.total );
            result.setId(id);
            result.setData(list);
        } else if( action.equalsIgnoreCase("4") ) {
            Film film = id.length() <= 10 ? inner.getDetail(id, new Film()) : inner.getFSNDetail(id, new Film());
            List lst = inner.getSitcomList(String.valueOf(film.getId()));
            if (lst != null && lst.size() == 2 ) {
                lst = (List) lst.get(1);
                if( lst != null && lst.size() > 0 ) {
                    for ( int i = 0; i< lst.size(); i++ )
                    {
                        Vod v = ReflectUtil.parse( lst.get(i) , new Vod());
                        list.add( inner.getDetail( String.valueOf( v.getId() ), new Vod() ) );
                    }
                }
            }
            map.put("film", film);
            map.put("list", list);
            result.setData( map );
        }
        inner.write(inner.writeObject( result, rmChars ));
    }
%>