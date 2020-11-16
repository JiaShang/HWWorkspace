




//初始化posters
function initPosters(listData,flag,num,defalutImg){
    if (typeof listData[flag] == 'undefined'){
        listData[flag] = [];
    }
    for (var i = 0 ; i < num ;i++){
        if (typeof listData[flag][i] == 'undefined'){
            listData[flag][i] == defalutImg;
        }
    }
}
//截取name
function  cut(listData,startStr,endStr,flag) {
    if (flag != 1 ) {return;}
    for (var i = 0 ; i < liatData.length ; i++){
        var name = liatData[i].name;
        var star = name.indexOf(startStr);  //不存在返回-1
        star++;
        var end = name.indexOf(endStr) <=0 ? name.length : name.indexOf(endStr);
        liatData[i].name = name.substring(star,end);  //substring取前不取后
    }
}