<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113881";

//    infos.add(new ColumnInfo(typeId, 0, 8));
    List<Column> columns = inner.getList(typeId, 30 , 0 , new Column());
    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
        infos.add(new ColumnInfo(columns.get(i).id, 0, 8));
    }

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        /*.listName{*/
        /*    width: 300px;*/
        /*    height: 60px;*/
        /*    top: 210px;*/
        /*    color: #ffffff;*/
        /*    font-size:24px;*/
        /*    background-color: transparent;*/
        /*    overflow: hidden;*/
        /*    text-align: center;*/
        /*    line-height: 60px;*/
        /*}*/
        img{
            position: relative;
            left: 5px;
            top: 5px;
        }
        .list{
            position: absolute;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
    <script language="javascript" type="text/javascript">
    <!--
    var listBox = null;
    var listData = [];
    var posters = [];
    var bgImgs = [];
    cursor.initialize({
        data: [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused: [<%= inner.getPreFoucs() %>],
        init: function () {
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl = '<%= backUrl %>';
            cursor.blockedNum = this.data.length;
            for (var i = 0; i < this.data.length; i++) {
                var o = this.data[i];
                posters[i] = new Array();
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                cursor.focusable[i].items = o["data"];
                for(var j = 0; j < cursor.focusable[i].items.length; j++){
                    if((typeof cursor.focusable[i].items[j].posters!== "undefined")&&(typeof cursor.focusable[i].items[j].posters['4']!== "undefined")){
                        posters[i][j] = cursor.focusable[i].items[j].posters['4'][0];
                    }else{
                        posters[i][j] = "images/defaultImg.png";
                    }
                }
            }
            var column = <%= inner.writeObject(column)%>;
            bgImgs = column.posters['7']
            setTimeout(function(){ initList();cursor.call('show');},150);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
        var blocked = cursor.blocked;
        var focus = cursor.focusable[blocked].focus;
        cursor.call('loseFocus');
        switch (index) {
            case 11:    //上
                if( listBox.focusPos > 2 && listBox.focusPos < 6){
                    listBox.focusPos = 0;
                    cursor.focusable[blocked].focus = listBox.focusPos;
                }else if(listBox.focusPos >= 6){
                    listBox.focusPos = listBox.focusPos - 5;
                    cursor.focusable[blocked].focus = listBox.focusPos;
                }else {
                    if (blocked > 0){
                        blocked--;
                        cursor.blocked = blocked;
                        if(listBox.focusPos == 0 ){
                            listBox.focusPos = 3;
                        }else if(listBox.focusPos>0){
                            listBox.focusPos = listBox.focusPos+5;
                        }
                        cursor.focusable[blocked].focus = listBox.focusPos;
                        initList();
                    }
                }
                break;
            case -11:   //下
                if( listBox.focusPos == 0){
                    listBox.focusPos = listBox.focusPos + 3;
                    cursor.focusable[blocked].focus = listBox.focusPos;
                }else if(listBox.focusPos < 3){
                    listBox.focusPos = listBox.focusPos + 5;
                    cursor.focusable[blocked].focus = listBox.focusPos;
                }else {
                    if(blocked < cursor.blockedNum-1){
                        blocked++;
                        cursor.blocked = blocked;
                        if(listBox.focusPos>5){
                            listBox.focusPos = listBox.focusPos-5;

                        }else  if(listBox.focusPos<6){
                            listBox.focusPos = 0;
                        }
                        cursor.focusable[blocked].focus = listBox.focusPos;
                        initList();
                    }
                }
                break;
            case -1:    //左
                if( listBox.focusPos != 0 && listBox.focusPos != 3){
                    listBox.focusPos--;
                    cursor.focusable[blocked].focus = listBox.focusPos;
                }
                break;
            case 1:     //右
                if( listBox.focusPos != 2 && listBox.focusPos != 7){
                    listBox.focusPos++;
                    cursor.focusable[blocked].focus = listBox.focusPos;
                }
                break;
        }
        cursor.call('show');
        },
        show : function(){
            // $("list"+ String(listBox.focusPos)).style.border = "5px solid #ffcc00";
            $("list"+ String(listBox.focusPos)).style.backgroundColor = "#ffcc00";
        },
        loseFocus : function(){
            // $("list"+ String(listBox.focusPos)).style.border = "5px solid transparent";
            $("list"+ String(listBox.focusPos)).style.backgroundColor = "transparent";
        },
    });
    function initList(){
        listBox = new showList(8,posters[cursor.blocked].length,cursor.focusable[cursor.blocked].focus,127,window);
        listBox.showType =0 ;
        listBox.haveData = function(List){
            $("listImg"+String(List.idPos)).src = posters[cursor.blocked][List.dataPos];
            // $("list"+ String(List.idPos)).style.border = "5px solid transparent";
        }
        listBox.notData = function(List){
            $("listImg"+List.idPos).src = "images/global_tm.gif";
        };
        listBox.startShow();
        $("body").style.backgroundImage = "url("+bgImgs[cursor.blocked]+")";
    }
    -->
    </script>
</head>
<body id="body" leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="list" style="position: absolute;width: 1100px;height: 600px;left: 50px;top: 145px;">
    <div id="list0" class="list" style="left: 46px; top: 16px;width: 641px;height: 248px;">
        <img id="listImg0" class="listImg" width="631" height="238"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list" style="left: 715px; top: 16px;width: 196px;height: 249px;">
        <img id="listImg1" class="listImg" width="186" height="239"/>
        <div id="listName1" class="listName"></div>
    </div>
    <div id="list2" class="list" style="left: 937px; top: 16px;width: 196px;height: 249px;">
        <img id="listImg2" class="listImg" width="186" height="239"/>
        <div id="listName2" class="listName"></div>
    </div>
    <div id="list3" class="list" style="left: 46px; top: 274px;width: 196px;height: 249px;">
        <img id="listImg3" class="listImg" width="186" height="239"/>
        <div id="listName3" class="listName"></div>
    </div>
    <div id="list4" class="list" style="left: 270px; top: 274px;width: 196px;height: 249px;">
        <img id="listImg4" class="listImg" width="186" height="239"/>
        <div id="listName4" class="listName"></div>
    </div>
    <div id="list5" class="list" style="left: 491px; top: 274px;width: 196px;height: 249px;">
        <img id="listImg5" class="listImg" width="186" height="239"/>
        <div id="listName5" class="listName"></div>
    </div>
    <div id="list6" class="list" style="left: 715px; top: 274px;width: 196px;height: 249px;">
        <img id="listImg6" class="listImg" width="186" height="239"/>
        <div id="listName6" class="listName"></div>
    </div>
    <div id="list7" class="list" style="left: 937px; top: 274px;width: 196px;height: 249px;">
        <img id="listImg7" class="listImg" width="186" height="239"/>
        <div id="listName7" class="listName"></div>
    </div>
</div>
</body>
</html>