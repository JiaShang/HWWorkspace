<%
    /**
     * 返回 JSON 对象
     *
     * 参数说明:
     *   id:        栏目id 或影片的父集Id, 当 id 为空时,显示帮助文档
     *   action:    获取类型: 0, 子栏目, 1, 绑定影片类容, 2, 获取栏目的详细信息, 3 获取影片或连续剧父集的详细内容
     *   charset:   返回内容编码,  utf-8 或者 gbk
     *   pageSize:  每页条数, 如果此参数为空,默认为200个,
     *   page:      页数, 如果此参数为空,默认为 1,
     *   special:   是否检查专题, 当指定special参数时, 检查到内容为连续剧父集时, 查询是否有同名的专题,如果有, 通过 linkto 返回专题链接地址.
     *   with:      栏目id ,当检查到有with参数时, 从 with 指定的栏目下查找对应相同名称的栏目, 如果有, 通过 redirect 取值.
     *   struct:    打印输出当前查询的数据结构.
     */

%>
<%@ include file="common.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%!
    class Query {
        InnerUtils inner;
        public Query(HttpServletRequest request, HttpServletResponse response){
            inner = new InnerUtils(request, response);
        }

        public void process(){
            String encoding = inner.get("charset");
            if( isEmpty(encoding) || !encoding.equalsIgnoreCase("gbk")) encoding = "utf-8";

            inner.setEncoding( encoding );

            String id = inner.get("id");
            String struct = inner.get("struct");
            Result result = new Result();
            result.setId(id);
            result.setSuccess(false);
            if( isEmpty( id ) ) {
                //result.message = "参数 typeId 为空! ";
                //inner.write( result );
                writeReadme( );
                return;
            }

            if( !isNumber( id ) ){
                result.setMessage("参数 id:("  + id + ") 格式错误, id 应为纯数字! ");
                inner.write( result );
                return;
            }

            String action = inner.get("action");
            if( isEmpty( action ) ) action = "0";
            else {
                if( !isNumber( action )) {
                    result.setMessage("参数 action:("  + action + ") 格式错误, action 应为纯数字! ");
                    inner.write( result );
                    return;
                }

                if( action.compareTo("3") > 0 ) {
                    result.setMessage("参数 action:("  + action + ") 错误, action 值为 0 - 3! ");
                    inner.write( result );
                    return;
                }
            }


            String pageSize = inner.get("pageSize");
            if( isEmpty( pageSize ) ) pageSize = "200";
            else {
                if( !isNumber( pageSize )) {
                    result.setMessage("参数 action:("  + pageSize + ") 格式错误, pageSize 应为纯数字! ");
                    inner.write( result );
                    return;
                }

                if( pageSize.compareTo("200") > 0 ) pageSize = "200";
            }

            String page = inner.get("page");
            if( isEmpty( page ) ) page = "1";
            else {
                if( !isNumber( page )) {
                    result.setMessage("参数 action:("  + page + ") 格式错误, page 应为纯数字! ");
                    inner.write( result );
                    return;
                }
            }

            int act = Integer.parseInt( action ) ;

            int nPage = Integer.parseInt( page );
            int nLength = Integer.parseInt( pageSize);
            int station = ( nPage - 1 ) * nLength;

            result.setSuccess(true);
            String para = inner.get("special");
            if( isEmpty( struct )){
                switch ( act ) {
                    case 0:
                        inner.setSpecial(! isEmpty( para ));
                        if( isEmpty( inner.get("withChildren")))
                        {
                            result = inner.getTypeList(id, station, nLength );
                        } else {
                            try{
                                List<Result> list = new ArrayList<Result>();
                                List<Column> columns = inner.getList(id, 99, 0, new Column());

                                para = inner.get("with");
                                if(isNumber( para )) inner.setWithId( para );

                                list.add(new Result(id, columns));
                                for (Column column : columns ) {
                                    list.add(inner.getVodList(column.getId(), 0, 199) );
                                }
                                result.setData( list );
                                result.setSuccess( true );
                            } catch (Throwable e){
                                result.setSuccess( false );
                                result.setMessage( e.getMessage() );
                            }
                        }
                        inner.write( result );
                        break;
                    case 1:
                        inner.setSpecial(! isEmpty( para ));
                        para = inner.get("with");
                        if(isNumber( para )) inner.setWithId( para );
                        result = inner.getVodList(id, station, nLength );
                        inner.write( result );
                        break;
                    case 2:
                        result = inner.getTypeDetail(id);
                        inner.write( result );
                        break;
                    case 3:
                        result = inner.getVodDetail(id);
                        inner.write( result );
                        break;
                    default:break;
                }
            } else {
                HashMap<String, Object> map = null;
                switch ( act ) {
                    case 0:
                    case 1:
                        try{
                            List<?> list = inner.getList(id, 1,0, act == 1);
                            if( null != list ) map = (HashMap)list.get(0);
                        } catch (Throwable e) {}
                        break;
                    case 2:
                    case 3:
                        //当 action 为3时表示获取的是影片或父集的详细信息
                        map = (HashMap)inner.getDetail(id, act == 3);
                        break;
                    default:break;
                }

                writeStruct( map );
            }
        }

        private void writeStruct(HashMap<String, Object> map ){

            String html = "<html>";
            html += "<head>";
            html += "<title>查询结果返回结构说明</title>";
            html += "</head>";
            html += "<body style='font-size:16px;'>";
            html += "<div>";
            if( map == null || map.size() == 0) {
                html += "<h3>当前查询返回结果为空!</h3>";
            } else {
                html += "<h3>当前查询返回结构为:</h3>";
                html += "<div>";
                for (Map.Entry<String, Object> entry : map.entrySet() ) {
                    html += " " + entry.getKey() + ":";
                    html += ( entry.getValue() == null ? "NULL" : entry.getValue().getClass().getSimpleName() )+ "</br>";
                }
            }
            html += "</div>";
            html += "</body>";
            html += "</html>";

            inner.write(html);
        }

        private void writeReadme(){
            String html = "<html>";
            html += "<head>";
            html += "<title>接口说明</title>";
            html += "</head>";
            html += "<body style='font-size:16px;'>";
            html += "<h3>Query.jsp 接口参数说明:</h3>";
            html += "<div>";
            html += "<p style='text-indent:2em'>id: 栏目id 或影片的父集Id, 当 id 为空时,显示帮助文档</p>";
            html += "<p style='text-indent:2em'>with: 栏目id ,当检查到有with参数时, 从 with 指定的栏目下查找对应相同名称的栏目</p>";
            html += "<p style='text-indent:2em'>withChildren: 当查询栏目时,是否查询子栏目内容, 为空是不查询,否则查询</p>";
            html += "<p style='text-indent:2em'>special: 查询同名专题</p>";
            html += "<p style='text-indent:2em'>action: 获取类型: 0, 子栏目, 1, 绑定影片类容, 2, 获取栏目的详细信息, 3 获取影片或连续剧父集的详细内容</p>";
            html += "<p style='text-indent:2em'>charset: 返回内容编码,  utf-8 或者 gbk, 当参数为空或者不为GBK时,默认使用UTF-8编码</p>";
            html += "<p style='text-indent:2em'>pageSize: 每页条数, 如果此参数为空,默认为200个</p>";
            html += "<p style='text-indent:2em'>page:页数, 如果此参数为空,默认为 1</p>";
            html += "<p style='text-indent:2em'>返回说明:当 typeId 不为空时,返回 JSON 对象</p>";
            html += "</div>";
            html += "</body>";
            html += "</html>";

            inner.write(html);
        }
    }
%>
<%
    Query query = new Query(request, response);
    query.process();
%>

