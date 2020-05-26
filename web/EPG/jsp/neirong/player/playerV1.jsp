<%
/**
 *  播放器页面参数说明：
 *
 *  typeId: 不管是电视剧，还是电视剧，均需要传入当前电影或者电视剧所在栏目ID；
 *  vodId:  当前电影的ID，可以是内部ID，也可以是外部ID；
 *  contentType:  播放内容的类型，0：电影，1：电视剧；
 *  parentVodId:  当contentType = 1(电视剧)时，此参数必须不能为空；当contentType=-1时
 *  idType: FSN, 当idType为FSN时，表示当前为外部ID;此时不存在连续剧的播放方式；
 *          如果当前ID为外部ID时，typeId 值为-1，如果 idType不为-1时，则忽略外部ID，使用-1作为参数；
 *  queryUrl: 当idType为FSN时，表示为外部调用方式，外部调用需要播放上一集或下一集时，需要通过本URL进行上一集，下一集的内容查询；
 *          : 查询结果返回JSON对象，返回结果见附录；
 *          : queryUrl 返回结果为记录条数不能为超过30条，需支持page查询。
 *          : 当idType为FSN时，queryUrl又为空，不管method为何值，播放单集。
 *  method: 播放方式，0：单集播放，1，循环播放；
 *      0：单级播放，不管是电视剧，还是电影，均播放一集，然后返回到指定页面；
 *      1：循环播放，如果是电视剧，而循环播放子集内容，如果是电影，循环播放栏目中的内容；
 *     **　当循环播放时，传入参数说明：
 *       .1. 如果 contentType == 0（电影），则通过 query.jsp 查询当前栏目中绑定电影的总量，根据绑定顺序取出当前ID所在位置，前一条内容及后一条内容.
 *       .2. 如果 contentType == 0（电影），但是，下一条内容为连续剧，则顺序播放连续剧的剧集
 *       .3. 如果 contentType == 1（连续剧），查询连续剧当前第几集，顺序播放后面内容直至全部播放完成。
 *  startTime: 从startTime时开始播放，默认为0；
 *  baseFlag: 0 去掉基本包验证，这时自默认播放5分钟，5分钟后开起授权操作。
 *  　　　　　: 1 正常授权操作，如果未订购产品，默认显示订购窗口的界面
 *          : TODO:如果可以，转到订购界面，提示用户充值并定购。
 *　freeTime : 可免费观看时间，参数为纯数字，如果此参数为空，默认为 5 分钟；
 *
 *  backURL: 影片播放完以后，返回地址。需要使用 encodeURIComponent()编码
 *  ver:     播放器版本，默认为最后一个版本
 */

 /*
 *
 *  playType: 0，电影, 1，电视剧
 *  name:     电影或电视剧的名称
 *
 */
%>
<html lang="zh">
<head>
    <meta name="page-view-size" content="1280*720">
    <meta http-equiv="charset" content="UTF-8">
    <title>播放器</title>
    <style></style>
</head>
<body>

</body>
</html>