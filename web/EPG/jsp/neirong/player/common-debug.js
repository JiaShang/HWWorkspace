;(function (win) {
    //字符串扩展
    String.prototype.trim = function () { return this.replace(/(^\s*)|(\s*$)/g, ""); };
    String.prototype.ltrim = function () { return this.replace(/(^\s*)/g, ""); };
    String.prototype.rtrim = function () { return this.replace(/(\s*$)/g, ""); };
    String.prototype.endWith = function (str) {
        if (str == null || str == "" || this.length == 0 || str.length > this.length) return false;
        return this.substring(this.length - str.length) === str;
    };
    String.prototype.startWith = function (str) {
        if (str == null || str == "" || this.length == 0 || str.length > this.length) return false;
        return this.substr(0, str.length) === str;
    };
    String.prototype.isEmpty = function () { return (/^\s*$/.test(this)); };
    //ISO-8859-1 编码字符串长度
    String.prototype.calcLength = function () {
        var str = this.replace(/[ ]*$/g, "");
        var len = 0;
        for (var i = 0; i < str.length; i++) {
            var ch = str.charCodeAt(i);
            if (ch <= 0x7F) len++;
            else if (ch <= 0x07FF) len += 2;
            else if (ch <= 0xFFFF) len += 3;
            else if (ch <= 0x1FFFFF) len += 4;
            else if (ch <= 0x3FFFFFF) len += 5;
            else len += 6;
        }
        return len;
    };
    //根据ISO-8859-1 编码, 取从start,长度为lengnth的子串
    String.prototype.calcString = function (start, length) {
        var str = this.replace(/[ ]*$/g, "");
        var len = 0;
        //TODO: 字符串取子串
        return str;
    };
    String.prototype.query = function (key) {
        var rs = new RegExp("(\\?|&)" + key + "=([^&]*?)(&|$)", "gi").exec(this);
        if (typeof rs === 'undefined' || rs === null) return "";
        return rs[2];
    };
    String.prototype.pad = function (length, paddingChar, rightToLeft) {
        paddingChar = paddingChar || ' ';
        if (paddingChar.length > 1) paddingChar = paddingChar.substr(0, 1);
        else if (paddingChar.length == 0) paddingChar = ' ';
        length = length - this.length;
        if (length <= 0) return this;
        var padding = '';
        for (var i = 0; i < length; i++) padding += paddingChar;
        if (rightToLeft) return this + padding;
        return padding + this;
    };
    String.prototype.padLeft = function (length, paddingChar) { return this.pad(length, paddingChar, false); };
    String.prototype.padRight = function (length, paddingChar) { return this.pad(length, paddingChar, true); };
    Object.prototype.extend = function (o) { for (var name in o) this[name] = o[name]; };
    //日期格式化， 调用方法：var currentTime = (new Date()).format("yyyy-MM-dd hh:mm:ss");
    Date.prototype.Format = function (fmt) {
        var o = {
            "M+": this.getMonth() + 1,
            "d+": this.getDate(),
            "h+": this.getHours(),
            "m+": this.getMinutes(),
            "s+": this.getSeconds(),
            "q+": Math.floor((this.getMonth() + 3) / 3),
            "S": this.getMilliseconds()
        };
        if (/(y+)/.test(fmt))
            fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt))
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    };
    //数组扩展
    Array.prototype.clear = function () { this.length = 0; };
    Array.prototype.insertAt = function (index, o) { this.splice(index, 0, o); };
    Array.prototype.insertAllAt = function (index, o) { for (var i = 0; i < o.length; i++) this.splice(index + i, 0, o[i]); };
    Array.prototype.pushAll = function (items) { for (var i = 0; i < items.length; i++) this.push(items[i]); };
    Array.prototype.removeAt = function (index) { this.splice(index, 1); };
    Array.prototype.remove = function (o) {
        var index = this.indexOf(o);
        if (index >= 0) this.removeAt(index);
    };

    var SYSTEM_BUSY_RETRY_LATER = decodeURIComponent('%E7%B3%BB%E7%BB%9F%E5%BF%99%2C%E8%AF%B7%E7%A8%8D%E5%80%99%E9%87%8D%E8%AF%95%E3%80%82');
    var GET_VOD_RTSP_ADDR_ERROR = decodeURIComponent('%E8%8E%B7%E5%8F%96%E7%82%B9%E6%92%AD%E5%9C%B0%E5%9D%80%E5%A4%B1%E8%B4%A5%EF%BC%9A');
    var STATIC_SUCCESS_STR = decodeURIComponent('%E6%88%90%E5%8A%9F');
    var STATIC_FAIL_STR = decodeURIComponent('%E5%A4%B1%E8%B4%A5');
    if (typeof iPanel === "undefined") {
        document.onkeydown = function (event) {
            win.debug("=======>>>>> OnKeydown :", event.keyCode, ' <<<<<=======');
            switch (event.keyCode) {
                case 19:                                    //P60 中的 上
                case 38: cursor.call("onMoveUp"); break;    //上光标键
                case 20:                                    //P60 中的 下
                case 40: cursor.call("onMoveDown"); break;  //下光标键
                case 21:                                    //P60 中的 左
                case 37: cursor.call("onMoveLeft"); break;  //左光标键
                case 22:                                    //P60 中的 右
                case 39: cursor.call("onMoveRight"); break; //右光标键
                case 33: cursor.call("onPageUp"); break;    //PageUp
                case 34: cursor.call("onMoveDown"); break;  //PageDown
                case 66:                                    //P60 中的 OK
                case 13: cursor.call("select"); break;      //选择回车键
                case 4:                                     //P60 中的返回
                case 8:                                     // Backspace 键执行返回
                case 46: cursor.call("goBack"); break;      //DEL 键退出
                case 36:
                case 458: cursor.call("goHome"); break;     //HOME 键执行 HOME 功能
                default:
                    var code = event.keyCode;
                    if (code >= 48 && code <= 57) {    //如果按数字键,执行输入功能.
                        var ch = String.fromCharCode(code);
                        cursor.call("input", ch);
                    }
                    break;
            }
            event.preventDefault();
            return false;
        };
        //下列事件,模拟机顶盒播放操作.
        document.addEventListener("iPanelEvent", function (e) {
            //参数通过 e.detail 传递过来.
            var args = e.detail;
            if (typeof  args === 'undefined') return;
            switch (args.code) {
                //如果播放地址串加载成功，播放视频流
                case "VOD_PREPAREPLAY_SUCCESS":
                    media.AV.play();
                    break;
                //如果播放完成，播放下一条
                case "EIS_VOD_PROGRAM_END":
                    cursor.call("nextVideo");
                    break;
                //页面加载完成
                case "EIS_MISC_HTML_OPEN_FINISHED":
                    cursor.call("htmlOpenFinished");
                    break;
                default:
                    break;
            }
        });
        win.iPanel = {
            isComputer: true,
            eventFrame: {
                portalUrl: undefined,
                initPage: function (o) {},
                /**
                 * 此方法，来点盒子与3.0盒子均可使用
                 */
                exitToHomePage: function () {
                    //如果是P60，则无 exitToHomePage 函数，故执行此函数时，实际调用 finish 函数
                    if( iPanel.mediaType == "P60" ) {
                        sysmisc.finish();
                    }
                }
            },
            getGlobalVar: function (name) {},
            setGlobalVar: function (name, value) {},
            debug: function (message) {
                console.log(message);
            }
        };
        win.media = {
            AV: {
                type: undefined,
                open: function (url, type) {
                    media.AV.type = type;
                    win.debug("iPanel play prepared (" + type + "):" + url);
                    //触发播放地址加载成功事件
                    cursor.fireEvent("VOD_PREPAREPLAY_SUCCESS");
                },
                //当 paly
                play: function () {
                    //如果打开的流是 VOD, 15秒后触发播放完成事件
                    if (media.AV.type === 'VOD') {
                        (function (duration) {
                            media.AV.duration = duration = duration / 1000;
                            var elapsed = 0;
                            if (!media.AV.timer) {
                                media.AV.timer = setInterval(function () {
                                    elapsed++;
                                    if (elapsed >= duration) {
                                        clearInterval(media.AV.timer);
                                        cursor.fireEvent("EIS_VOD_PROGRAM_END");
                                        media.AV.elapsed = elapsed = 0;
                                        media.AV.timer = undefined;
                                        return;
                                    }
                                    media.AV.elapsed = elapsed;
                                }, 1000);
                            }
                        })(60 * 1000 * 1);
                    }
                },                                //当暂停后，resume 时，实际上执行 play 既可.
                pause: function () {},            //暂停
                close: function () {},
                elapsed: 20,                      //播放时长
                duration: 100,                    //总时长
                backward: function (speed) {},    //快退
                forward: function (speed) {},     //快进
                seek: function(time){}            //时间格式为HH:mm:ss格式
            },
            picture: {alpha: 80},
            video: {
                setPosition: function (left, top, width, height) {},   //小屏播放
                fullScreen: function () {},                        //全屏播放
            },
            sound: {
                up : function() {},
                down : function() {},
                resume : function() {},
                mute : function() {}
            }
        };
        win.CA = {
            card: {
                serialNumber: (function(){
                    if ( iPanel.mediaType == "P60" )  return sysmisc.getSn(); //P60盒子
                    if ( iPanel.mediaType == "GW" ) return iPanelGatewayHelper.getCaCard(); //网关
                    return "9950000001424641";
                })()
            }
        };
        win.DVB = {
            playAV: function (frequey, serviceId) {},
            stopAV: function () {}
        };
        iPanelGatewayHelper = {
            getCaCard: function () {
                return CA.card.serialNumber;
            },
            playLive: function (serviceId, isHideChannel) {}, //播放直播频道，serviceId 是字符串类型，isHideChannel 是否隐藏频道。
            play: function (vodId) {                          //点播华为VOD视频，内部ID
            },
            getPlayUrl: function (vodId /*String 字符串类型*/) {
                //通过传入恒云或华为影片id获取对应影片的播放地址
                //Js调用iPanelGatewayHelper.getPlayUrl("123456");或
                //iPanelGatewayHelper.getPlayUrl("ObjectID@VODItem:123456_0");
                //成功返回 playUrl String	影片的播放地址
            },
            getEPGServerUrl: function () {//win.EPGUrl = iPanel.eventFrame.pre_epg_url;
            },
            getEPGServerCookie: function () {                  //获取华为EPG服务器Cookie（主线程调用可能会阻塞，最好在子线程中调用）
            },
            launchApk: function (
                pkg, /*String	要启动应用的包名*/
                cls, /*String 要启动应用的类名*/
                params  /*String 要传入启动应用的参数，格式:key1;value1;key2;value2，不需要传入参数时传''即可*/
            ) {},
            getInnerVodId: function (vodId) {
                //通过下面的地址可以把VOD的外部ID转换成内部ID
                var url = this.getEPGServerUrl() + "jsp/defaultHD/en/getContentId.jsp?vodId=" + vodId;
            }
        };
        win.E = {is_HD_vod: false};
    };
    win.link = win.link || location.href;
    win.debug = function(){
        var message = "COMMONJS :";
        for( var i = 0; i < arguments.length ; i ++ ) message += String( arguments[i] );
        if( iPanel.mediaType == "P60" ) {
            if( link.query('debug') != '' ) {
                sysmisc.showToast(message);
            } else {
                console.log (message);
            }
        } else {
            if( link.query('debug') != '' && iPanel.mediaType == "HD3.0" ) {
                alert(message);
            } else {
                iPanel.debug (message);
            }
        }
    };
    win.debug('COMMONJS location.href =======>>>>>> (', win.link, ')  <<<<<=======' );
    win.$ = function (objectId) {
        if (document.getElementById && document.getElementById(objectId)) {
            return document.getElementById(objectId);
        } else if (document.all && document.all(objectId)) {
            return document.all(objectId);
        } else if (document.layers && document.layers[objectId]) {
            return document.layers[objectId];
        } else {
            return false;
        }
    };
    var evalJS = function(func, strJS, isJSON){
        if( typeof isJSON == 'undefined' || isJSON == true ) {
            if( /^\s*\<html\>/g.test(strJS) ) { tooltip(); return ; }
            try {
                debug('AJAX =======>>>>>> [[[ ', iPanel.mediaType == 'PC' ? strJS : ' BEGIN RUNNING evalJS(...)', ' ]]]');
                func(eval("(" + strJS + ")"));
            } catch (e) { win.debug(decodeURIComponent('%E8%A7%A3%E6%9E%90%E6%95%B0%E6%8D%AE%E6%97%B6%E5%87%BA%E7%8E%B0%E9%94%99%E8%AF%AF%EF%BC%81%EF%BC%9A'),e);  }
            debug('AJAX =======>>>>>> [[[ END RUNNING evalJS(...) ]]]');
        } else {
            func( strJS );
        }
    };
    /**
     * options中,headers 格式为:[{key:value},{key:value}]
     * options中,当method为POST时, data 格式为JSON格式.
     */
    var _ajax = function (url, callback, options) {
        if (typeof  url === 'undefined') return;
        options = options || {};
        var _options = {
            method: 'GET',
            sync: true,
            //请求失败
            fail: function (message) { win.debug(message); },
            //请求编码,默认为utf-8
            charset: 'utf-8',
            //设置超时 15秒
            timeout: 15000,
            //请求频率
            frequency: undefined,
            //请求头, 格式为[{key:value},{key:value}]
            headers: undefined,
            username: undefined,
            password: undefined
        };

        for (var name in _options) options[name] = options[name] || _options[name];

        var headers = options.headers || [];

        if (headers.length === 0) {
            headers.push({"key": "Content-Type", "value": "text/plain;charset=" + options.charset});
        }

        var createXmlHttpRequest = function () {
            var xhr = false;
            try {
                xhr = new XMLHttpRequest();
            } catch (exception) {
                try {
                    xhr = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (exception) {
                    try {
                        xhr = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (exception) {
                        return false;
                    }
                }
            }
            return xhr;
        };
        var request = createXmlHttpRequest();
        //定时器
        var timer = -1;
        //请求次数
        var counter = 0;
        var requestTimeout = function () {
            request.abort();
            if (typeof options.fail === 'function') {
                options.fail('TimeOut');
            } else {
                iPanel.deubg("AJAX REQUEST TIMEOUT !");
            }
        };
        request.onreadystatechange = function () {
            var state = request.readyState;
            var status = request.status;
            if (state <= 2) {
                win.debug("AJAX STATE CHANGED : " + state + ", STATUS :" + status + "!");
            } else if (state === 3) {
                if (status == 401) {
                    win.debug("AJAX AUTHENTICATION FAILED, NEED CORRECT USERNAME AND PASSWORD !");
                    return;
                }
                win.debug("AJAX STATE CHANGED : " + state + ", STATUS :" + status + "!");
            } else if (state === 4) {
                clearTimeout(timer);
                //HTTP 204(no content)    表示响应执行成功，但没有数据返回，浏览器不用刷新，不用导向新页面。
                //HTTP 205(reset content) 表示响应执行成功，重置页面（Form表单），方便用户下次输入。
                if (status === 200 || status == 204) {
                    var responseText = request.responseText;
                    if (typeof callback === 'function') {
                        evalJS(callback, request.responseText);
                    } else {
                        win.debug("AJAX SUCCESS : " + responseText);
                    }
                } else {
                    win.debug("AJAX STATE WITH 4, BUT STATUS IS : " + status);
                }
            }
        };
        if( iPanel.mediaType == 'PC' ) {
            request.withCredentials = true;
            var dbgHost = location.protocol + '//' + location.hostname + location.port;
            url += ( url.indexOf('?') >= 0 ? '&' : '?' ) + 'ISPCDBG=1&DBGHOST=' + encodeURIComponent(dbgHost);
        }

        if (typeof options.username !== 'undefined' && typeof  options.password !== 'undefined') {
            request.open(options.method, url, options.sync, options.username, options.password);
        } else {
            request.open(options.method, url, options.sync);
        }

        for (var i = 0; i < headers.length; i++) {
            var header = headers[i];
            request.setRequestHeader(header.key, header.value);
        }

        var data = options.data || null;
        request.send(data);

        timer = setTimeout(requestTimeout, options.timeout);
    };

    iPanel.mediaType = (function(){
        if( typeof iPanel != 'undefined' && typeof iPanel.isComputer == 'undefined' ) {
            if ( typeof iPanel.eventFrame.systemId == 'undefined' ) return 'HD3.0';
            if ( iPanel.eventFrame.systemId == 1 ) return 'P30';
            if ( iPanel.eventFrame.systemId == 2 ) return "GW";
        } else if( typeof sysmisc != 'undefined' && typeof sysmisc.isComputer == 'undefined' ) {
            return 'P60';
        } else {
            return 'PC';
        }
    })();
    var tooltip = function(message) {
        message = message || decodeURIComponent(GET_VOD_RTSP_ADDR_ERROR);
        if( iPanel.mediaType == 'P60' ) sysmisc.showToast(message);
        else if( iPanel.mediaType == 'GW' ) iPanel.debug(message);
        else alert(message);
    };
    //如果是3.0 或者来点终端此参数一定存在, 如果网关或P60或者电脑则不存在此参数
    //如果是电脑或者P60, 则前面已初始化iPanel
    win.EPGUrl = win.EPGUrl || iPanel.eventFrame.pre_epg_url || (( iPanel.mediaType == "P60" ? ( ( win.address = ( win.address || sysmisc.getEnv('epg_address','') ) ) + '/EPG/' ) : ( iPanel.isComputer || iPanel.eventFrame.systemId !== 2 ? "http://192.168.65.93:8082/EPG/" : iPanelGatewayHelper.getEPGServerUrl() ) ) + 'jsp');
    win.debug( "media Type:" , iPanel.mediaType,", EPGUrl ====>>> ", win.EPGUrl );
    if( iPanel.mediaType == "P60" || iPanel.isComputer ) {
        var Base64 = function(){
            var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
            var _utf8_encode = function (str) {
                str = str.replace(/\r\n/g, "\n");
                var text = "";
                for (var n = 0; n < str.length; n++) {
                    var c = str.charCodeAt(n);
                    if (c < 128) {
                        text += String.fromCharCode(c);
                    } else if ((c > 127) && (c < 2048)) {
                        text += String.fromCharCode((c >> 6) | 192);
                        text += String.fromCharCode((c & 63) | 128);
                    } else {
                        text += String.fromCharCode((c >> 12) | 224);
                        text += String.fromCharCode(((c >> 6) & 63) | 128);
                        text += String.fromCharCode((c & 63) | 128);
                    }
                }
                return text;
            };
            var _utf8_decode = function (text) {
                var string = "";
                var i = 0;
                var c = 0, c1 = 0, c2 = 0, c3 = 0;
                while (i < text.length) {
                    c = text.charCodeAt(i);
                    if (c < 128) {
                        string += String.fromCharCode(c);
                        i++;
                    } else if ((c > 191) && (c < 224)) {
                        c2 = text.charCodeAt(i + 1);
                        string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                        i += 2;
                    } else {
                        c2 = text.charCodeAt(i + 1);
                        c3 = text.charCodeAt(i + 2);
                        string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                        i += 3;
                    }
                }
                return string;
            };
            this.encode = function (input) {
                var output = "";
                var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
                var i = 0;
                input = _utf8_encode(input);
                while (i < input.length) {
                    chr1 = input.charCodeAt(i++);
                    chr2 = input.charCodeAt(i++);
                    chr3 = input.charCodeAt(i++);
                    enc1 = chr1 >> 2;
                    enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                    enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                    enc4 = chr3 & 63;
                    if (isNaN(chr2)) {
                        enc3 = enc4 = 64;
                    } else if (isNaN(chr3)) {
                        enc4 = 64;
                    }
                    output = output +
                        _keyStr.charAt(enc1) + _keyStr.charAt(enc2) +
                        _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
                }
                return output;
            };
            this.decode = function (input) {
                var output = "";
                var chr1, chr2, chr3;
                var enc1, enc2, enc3, enc4;
                var i = 0;
                input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
                while (i < input.length) {
                    enc1 = _keyStr.indexOf(input.charAt(i++));
                    enc2 = _keyStr.indexOf(input.charAt(i++));
                    enc3 = _keyStr.indexOf(input.charAt(i++));
                    enc4 = _keyStr.indexOf(input.charAt(i++));
                    chr1 = (enc1 << 2) | (enc2 >> 4);
                    chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                    chr3 = ((enc3 & 3) << 6) | enc4;
                    output = output + String.fromCharCode(chr1);
                    if (enc3 != 64)output = output + String.fromCharCode(chr2);
                    if (enc4 != 64)output = output + String.fromCharCode(chr3);
                }
                output = _utf8_decode(output);
                return output;
            };
        };
        win.base64 = new Base64();
        var AndroidHtml5 = {
            idCounter: 0, // 参数序列计数器
            OUTPUT_RESULTS: {}, // 输出的结果
            CALLBACK_SUCCESS: {}, // 输出的结果成功时调用的方法
            CALLBACK_FAIL: {}, // 输出的结果失败时调用的方法
            callNative: function (cmd, type,args, success, fail) {
                var key = "ID_" + (++this.idCounter);
                win.debug("cmd:" + JSON.stringify(cmd));

                if (typeof success != 'undefined') {
                    AndroidHtml5.CALLBACK_SUCCESS[key] = success;
                } else {
                    AndroidHtml5.CALLBACK_SUCCESS[key] = function (result) {};
                }

                if (typeof fail != 'undefined') {
                    AndroidHtml5.CALLBACK_FAIL[key] = fail;
                } else {
                    AndroidHtml5.CALLBACK_FAIL[key] = function (result) {};
                }
                sysmisc.async(JSON.stringify(cmd), type,JSON.stringify(args),key);
                return this.OUTPUT_RESULTS[key];
            },
            callWebService: function (url, nameSpace, methodName, serviceName, property,success,fail) {
                var key = "ID_" + (++this.idCounter);
                if (typeof success != 'undefined') {
                    AndroidHtml5.CALLBACK_SUCCESS[key] = success;
                } else {
                    AndroidHtml5.CALLBACK_SUCCESS[key] = function (result) {};
                }

                if (typeof fail != 'undefined') {
                    AndroidHtml5.CALLBACK_FAIL[key] = fail;
                } else {
                    AndroidHtml5.CALLBACK_FAIL[key] = function (result) {};
                }
                var property_string = JSON.stringify(property);
                sysmisc.asyncWebService(url, nameSpace, methodName, serviceName, property_string,key);
                return this.OUTPUT_RESULTS[key];
            },
            callBackJs: function (result, type,key) {
                if(type == "json"){
                    this.OUTPUT_RESULTS[key] = result;
                    var status = result.status;
                    win.debug(status);
                    if (status == 200) {
                        win.debug(typeof this.CALLBACK_SUCCESS[key]);
                        if (typeof this.CALLBACK_SUCCESS[key] != "undefined") {
                            //setTimeout("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']("+result.message+")", 0);
                            AndroidHtml5.CALLBACK_SUCCESS[key](result.message);
                        }
                    } else {
                        if (typeof this.CALLBACK_FAIL != "undefined") {
                            setTimeout("AndroidHtml5.CALLBACK_FAIL['" + key + "']("+result.message+")", 0);
                        }
                    }
                }
                else{
                    win.debug('result key:' + key);
                    this.OUTPUT_RESULTS[key] = result;
                    var obj = JSON.parse(result);
                    var message = base64.decode(obj.message);
                    win.debug('result message:' + message);
                    var status = obj.status;
                    if (status == 200) {
                        if (typeof this.CALLBACK_SUCCESS[key] != "undefined") {
                            setTimeout("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']('" + message + "')", 0);
                        }
                    } else {
                        if (typeof this.CALLBACK_FAIL != "undefined") {
                            setTimeout("AndroidHtml5.CALLBACK_FAIL['" + key + "']('" + message + "')", 0);
                        }
                    }
                }
            },
            callWebServiceBackJs: function (result,key) {
                this.OUTPUT_RESULTS[key] = result;
                win.debug(key);
                win.debug(typeof(result));
                var obj = JSON.parse(result);
                var status = obj.code;
                win.debug(status);
                if (status == 200) {
                    win.debug(typeof this.CALLBACK_SUCCESS[key]);
                    if (typeof this.CALLBACK_SUCCESS[key] != "undefined") {
                        win.debug(typeof("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']('" + result + "')"));
                        setTimeout("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']('" + result + "')",0);
                    }
                } else {
                    if (typeof this.CALLBACK_FAIL != "undefined") {
                        win.debug("AndroidHtml5.CALLBACK_FAIL['" + key + "']('" + result + "')");
                        setTimeout("AndroidHtml5.CALLBACK_FAIL['" + key + "']('" + result + "')",0);
                    }
                }
            }
        };
        //var exec_asyn = function exec_asyn(service, action,type, args, success, fail) {
        var exec_asyn = function (service, action,type, args, success, fail) {
            var json = {
                "service": service,
                "action": action
            };
            var result = AndroidHtml5.callNative(json, type,args, success, fail);
        };
        var bridge = {};
        bridge.getwebservice = function(url, nameSpace, methodName, serviceName, property,success,fail){
            AndroidHtml5.callWebService(url, nameSpace, methodName, serviceName, property,success,fail);
        };
        bridge.get = function (url, mediatype, header, success, fail) {
            exec_asyn("request", "", "json",{
                    "url": url,
                    "method": "get",
                    "mediatype": mediatype
                },
                success, function(){
                    sysmisc.showToast(SYSTEM_BUSY_RETRY_LATER);
                });
        };
        bridge.post = function (url, mediatype, header, body, success, fail) {
            exec_asyn("request", "","json", {
                    "url": url,
                    "method": "post",
                    "mediatype": mediatype,
                    "body": body,
                    "header": header
                },
                success, function(){
                    sysmisc.showToast(SYSTEM_BUSY_RETRY_LATER);
                });
        };
        bridge.ajax = function (method,url,mediatype,header,body,success,fail) {
            if(arguments.length < 4){/*兼容旧传参格式url,success,body*/
                bridge.ajax('post',method,'text/xml',null,mediatype,url,null);
                return;
            };
            var o = {
                "url": url,
                "method": method.toLowerCase(),
                "mediatype": mediatype || "application/json",
                "body": body || null,
                "header": header || null
            };
            if (method != 'post') {
                delete o.body;
                delete o.header;
            };
            exec_asyn("request","","json",o,
                success || function(){ sysmisc.showToast("success"); },
                fail || function(){ sysmisc.showToast(SYSTEM_BUSY_RETRY_LATER); }
            );
        };
        bridge.getstring = function (url, mediatype, header, success, fail) {
            exec_asyn("request", "", "string",{
                    "url": url,
                    "method": "get",
                    "mediatype": mediatype
                },
                success, function(){
                    sysmisc.showToast(SYSTEM_BUSY_RETRY_LATER);
                });
        };
        bridge.poststring = function (url, mediatype, header, body, success, fail) {
            exec_asyn("request", "", "string",{
                    "url": url,
                    "method": "post",
                    "mediatype": mediatype,
                    "body": body,
                    "header": header
                },
                success,function(){
                    sysmisc.showToast(SYSTEM_BUSY_RETRY_LATER);
                });
        };
        bridge.ajaxstring = function (method,url,mediatype,header,body,success,fail) {
            if(arguments.length < 4){/*兼容旧传参格式url,success,body*/
                bridge.ajax('post',method,'text/xml',null,mediatype,url,null);
                return;
            };
            var o = {
                "url": url,
                "method": method.toLowerCase(),
                "mediatype": mediatype || "application/json",
                "body": body || null,
                "header": header || null
            };
            if (method!='post') {
                delete o.body;
                delete o.header;
            };
            exec_asyn("request","","string",o,
                success || function(){
                    sysmisc.showToast("success");
                },
                fail || function(){
                    sysmisc.showToast(SYSTEM_BUSY_RETRY_LATER);
                }
            );
        };
        bridge.version=2;
        win.bridge = bridge;
        win.AndroidHtml5 = AndroidHtml5;

        if( typeof win.mixplayer === 'undefined' ){
            win.mixplayer = win.dvbplayer = {
                /**
                 *
                 * @param x 播放器左上角的x坐标，该值为坐标相对于屏幕宽度的百分比，精确度小数 点后3位
                 * @param y
                 * @param width 播放器的宽度，该值为坐标相对于屏幕宽度的百分比，精确度小数点后3位
                 * @param heigh
                 */
                create: function(x, y, width, heigh) {return 1;},
                stop: function( playerId ){},
                destroy : function (playerId) {},
                /**
                 * 0 播放器尚未创建或释放
                 * 1 播放器已创建
                 * 2 播放器开始播放
                 * 3 播放器暂停
                 * 4 播放器错误
                 * 5 播放器停止
                 * 6 播放器快进
                 * 7 播放器快退
                 * @param playerId
                 */
                getState: function (playerId) {},
                resize: function (playerId,x, y, width, heigh) {}
            };
            /**
             * @param playerId
             * @param url 播放串
             * @param seekTime 影片播放的起始位置，单位为秒，最小从影片初始位置0开始播放,时 移以及通用起播请传"0"
             */
            win.mixplayer.playUrl = function(playerId, url,seekTime) {};
            win.mixplayer.pause = function(playerId){}; //0 成功，-1 失败
            win.mixplayer.getCurrent = function(playerId){return 0;}; //获取当前播放位置，以秒为单位
            win.mixplayer.seekTo = function(playerId,seconds){return 0;}; //跳转指定播放位置进行播放,以秒为单位。0 成功, -1 失败
            win.mixplayer.resume = function(playerId){return 0;}; //恢复播放 0 成功, -1 失败
            win.mixplayer.scale = function(playerId,scale){return 0;}; //按照指定倍速播放, 整数：成功， -1：失败
            win.mixplayer.getDuration = function(playerId){return 0;}; //得到当前播放片源总时长
            win.mixplayer.voiceDown = function(){}; //降低音量
            win.mixplayer.voiceUp = function(){}; //增大音量
            win.mixplayer.getMaxVoice = function(){return 100;}; //获取系统最大音量值
            win.mixplayer.getCurrentVoice = function(){return 30;}; //获取系统当前音量值
            win.mixplayer.getAutoMode = function(){}; //获取当前系统声道模式 0 立体声；1 左声道；2 右声道；3 混合音
            win.mixplayer.setAutoMode = function(mode){}; //设置当前系统声道模式 0 立体声；1 左声道；2 右声道；3 混合音
            win.mixplayer.setStopMode = function(mode){};
            /**
             * @returns 0 成功, -1 失败
             */
            win.dvbplayer.playElements = function(playerId, transportId, serviceId, networkId){return 0;};
            /**
             * @param dvbUrl dvbelement://706000.6875.64.8.0.0.0.0.0.0
             * 详细说明:"dvbelement://" +Frequency + "." + SymbolRate + "." + Modulation + "." + serviceid+ "." + pmtpid + "." +pcrpid + ". " + VideoType" + "." + "VideoPID" + "." + "AudioType" + "." + "AudioPID"
             * Frequency 为频 点频率，单位为MHz;  不是 KHz
             * SymbolRate 为符号率，单位为K, Symbol/s, 可填0，系统取默认值为6875;
             * Modulation 为 调制方式，可填0，系统取默认值64QAM;
             * serviceid 为业务ID号;
             * pmtpid 为 PMT PID ,可填0，默认对应serviceid 的PMT PID;
             * pcrpid为 PCR PID ,可填0，默认对应serviceid的PCR PID;
             * VideoType 为视频类型，可填0，系统默认取该业务下PID值最小的视频流类型。如果该业务为纯音频业务，该值为-1;
             * VideoPID 为视频PID,可填0，系统默认 取该业务下PID值最小的视频流。如果该业务为纯音频业务，该值为-1;
             * AudioType 为音频类型，可填0，系统默认 取该业务下PID值最小的音频类型
             * AudioPID 为音频PID，可填0，系统默认取该业务下PID值最小的音频流。
             * @returns 0 成功, -1 失败
             */
            win.dvbplayer.playFrequency = function(dvbUrl){return 0;};
        }
    }
    if( typeof sysmisc == 'undefined' ) {
        win.sysmisc = {
            isComputer : true,
            getSn : function(){},
            getSoftVersion : function() {},
            getHardVersion : function() {},
            getMac : function(){},
            //设置需要显示在最前的图层,video为视频层，其它为web层
            bringToForeground : function(type){},
            finish : function(){},
            getEnv : function(key,defVal){},
            path_back : function() {},
            object_save : function(search, url) {},
            path_sav : function (data) {},
            showToast : function(message){}
        };
    }
    win.ajax = function(url, callback, options) {
        options = options || {};
        if( iPanel.mediaType == "P60" && !url.startWith("/") )
        {
            var cookie = url.startWith( win.EPGUrl ) ? ('[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid','') + '"}]') : '';
            win.debug("AJAX -> " + url );
            bridge.ajax('post', url, 'text/xml', cookie, null, function(rst){
                var callbackJSON = typeof options.json == 'undefined' || options.json == true;
                if (callbackJSON) {
                    if( /\<html\>/g.test(rst) ) {
                        sysmisc.showToast(SYSTEM_BUSY_RETRY_LATER);
                    } else if (typeof callback === 'function') {
                        evalJS(callback, rst);
                    }
                } else {
                    win.debug("Bridge ajax success: " + rst);
                    if (typeof callback === 'function') {
                        evalJS(callback, rst, false);
                    }
                }
            }, function(e){
                win.debug("Bridge ajax ERROR: " + e);
            });
        } else {
            win.debug("AJAX -> " + url );
            _ajax(url, callback, options);
        }
    };

    var Cursor = function (params) {
        //用来临时绶存数据
        this.consigned = undefined;
        this.blocked = 0;
        //记录焦页面分块数据
        this.focusable = [];
        //播放速度，默认为正常速度，当为负数时表示快退，为正数时表示为快进
        this.speed = 0;
        //当前播放视频在列表中的位置顺序
        this.playIndex = 0;
        //当前播放列表，有可能为空，如果为空时，播放完成以后直接退出播放页，
        this.playList = undefined;
        this.fullmode = false;
        this.options = {};
        this.voteId = 0;

        this.EPGflag = link.query("EPGflag");
        this.isKorean = !link.query("isKorean").isEmpty();
        this.isWestern = !link.query("isWestern").isEmpty();
        this.appendURL = this.backUrl = '';
        this.href = link;
        var that = this;
        /**
         * 把 整数秒 转换成 hh:MM:ss 格式
         * @param seconds
         * @returns {*}
         */
        var sec_to_time = function (seconds) {
            if (!seconds || seconds == null) { return "00:00:00"; }
            var hour = parseInt(seconds / 3600);
            if (hour < 10) { hour = "0" + hour; }
            seconds = seconds % 3600;
            var minute = parseInt(seconds / 60);
            if (minute < 10) { minute = "0" + minute; }
            var second = seconds % 60;
            if (second < 10) { second = "0" + second; }
            return hour + ":" + minute + ":" + second;
        };
        var p60_path_save = function(){
            var search = location.search;
            var baseUrl = location.href.replace(search, '');
            if( search.startsWith('?') ) search = search.substr(1);
            search = search.query('currFoucs') == '' ? ( search + ( search.length > 0 ? '&' : '' ) + 'currFoucs=' + that.getCurrFocus() ) : ( search.replace('currFoucs=' + search.query('currFoucs'), 'currFoucs=' + that.getCurrFocus() ));
            if ( link.query('backURL') != '' && search.query('backURL') == '' ) search += '&backURL=' + link.query('backURL');
            win.debug('CALL sysmisc.object_save("', search, '", "', baseUrl, '");');
            sysmisc.object_save( search , baseUrl);
        };
        var time_to_sec = function (time) {
            var hour = time.split(':')[0];
            var min = time.split(':')[1];
            var sec = time.split(':')[2];
            return Number(hour*3600) + Number(min*60) + Number(sec);
        };
        //通过 SPAN 来计算一个字符串占有多少个象素宽度
        var calcStringPixels = function (str, fontSize, callback) {
            var element = $("calcPixels");
            if (!element) {
                element = document.createElement("div");// 设置不可见, 如果是display:none则无法取长度
                element.style.visibility = "hidden";
                element.style.position = "absolute";
                element.style.width = "2500px";
                element.style.height = "45px";
                element.style.left = "0px";
                element.style.top = "-50px";
                element.style.color = "transparent";
                element.style.backgroundColor = "transparent";
                document.body.appendChild(element);
                var html = "<span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: " + fontSize + "px'>" + str + "</span><span id='calcOffsetLeft'>&nbsp;</span>";
                element.innerHTML = html;
            } else {
                element = $("calcPixels");
                element.style.fontSize = String(fontSize) + 'px';
                element.innerHTML = str;
            }
            var calc = function () {
                element = $("calcOffsetLeft");
                if (undefined == element.offsetLeft) {
                    that.calcTimer = setTimeout(calc, 4);
                    return;
                }
                if (typeof callback === 'function') {
                    callback(element.offsetLeft);
                }
                $("calcPixels").innerHTML = '';
            };
            if (that.calcTimer) clearTimeout(that.calcTimer);
            that.calcTimer = setTimeout(calc, 4);
        };
        var enumObj = function (o) {
            for (var i in o) {
                if (typeof o[i] === 'object') enumObj(o[i]);
            }
        };
        this.events = [];
        //专题或页面跳转
        this.linkto = function (uri) {
            var url = '';
            if (uri.indexOf("wasu.cn/") > 0 && iPanel.mediaType != 'P60') {
                url = win.EPGUrl + "/defaultHD/en/Category.jsp?url=" + uri;
            } else if (!uri.startWith('http')) {
                url += that.current() + uri;
            } else {
                url = uri;
                url += url.indexOf("?") > 0 ? '&' : '?';
                url += 'backURL=';
                var focusStr = link.query('currFoucs');
                var backUrl = link.query('backURL');
                if( ! backUrl.isEmpty() ) that.href = link.replace('backURL=' + backUrl , '');
                if ( focusStr != '') {
                    that.href = link.replace(focusStr, that.getCurrFocus());
                } else {
                    that.href += (link.indexOf("?") >= 0 ? "&" : "?") + "currFoucs=" + that.getCurrFocus();
                }
                url += encodeURIComponent( that.href ) + ( ! backUrl.isEmpty() ? ('#|#' + backUrl ) : '');
            }
            win.debug("=======>>>>> LINK TO : ", url ,' <<<<<=======');
            return url;
        };
        this.functions = {
            play: function () {
                media.AV.play();
            },
            phoneValidate: function () {
                var reg = /^1[3|4|5|7|8][0-9]\d{8}$/gi;
                return !reg.test(that.phoneNumber);
            },
            nextVideo: function () {},
            htmlOpenFinished: function () {},
            show: function () {
                win.debug(decodeURIComponent('show%20%E5%87%BD%E6%95%B0%E9%9C%80%E8%A6%81%E9%87%8D%E8%BD%BD%EF%BC%81'))
            },
            move: function (index) {},
            onMoveUp: function () { that.call('move', 11); },
            onMoveDown: function () { that.call('move', -11); },
            onMoveLeft: function () { that.call('move', -1); },
            onMoveRight: function () { that.call('move', 1); },
            press: function (key) {},
            selectItem : function( item ){
                var typeId = item.typeId;
                var url = '';
                win.debug("SelectAct -> SELECT ITEM('NAME:" , item.name , "','isSitcom:" , item.isSitcom , "','mediaType:" , iPanel.mediaType , "');");
                if (typeof item.linkandr === 'string' && iPanel.eventFrame.systemId) {
                    var linkAndr = item.linkandr;
                    if (iPanel.eventFrame.systemId === 1) {
                        iPanel.IOControlWrite("startAPK", linkAndr);
                    } else if (iPanel.eventFrame.systemId === 2) {
                        var pkg = linkAndr.substr(0, linkAndr.indexOf(","));
                        linkAndr = linkAndr.substr(linkAndr.indexOf(",") + 1);
                        var cls = linkAndr.substr(0, linkAndr.indexOf(","));
                        var params = linkAndr.substr(linkAndr.indexOf(",") + 1);
                        win.debug("SelectAct -> iPanelGatewayHelper.launchApk('" + pkg + "','" + cls + "','" + params + "');");
                        iPanelGatewayHelper.launchApk(pkg, cls, params);
                    }
                    return;
                } else if (typeof item.linkto === 'string' || typeof item.linkP60 === 'string') {
                    var uri = item.linkto;
                    if( iPanel.mediaType == 'P60' && typeof iPanel.linkP60 == 'string' ) uri = item.linkP60;
                    url = that.linkto( uri );
                } else {
                    win.debug("play select item ");
                    if (item.isSitcom === 0) {
                        if( iPanel.mediaType == "P60" ){
                            win.debug("P60 Play Item -> Before Ajax Invoke!");
                            ajax( win.EPGUrl + '/defaultHD/en/go_authorization.jsp?typeId=-1&playType=1' + ( typeof item.parentId == 'undefined' ? '' : ( '1&parentVodId=' + String( item.parentId ) ) ) + '&progId=' + item.id + '&contentType=0&business=1&baseFlag=0&startTime=0', function(rst){
                                if( rst.playFlag === "1") {
                                    var url = 'http://aoh5.cqccn.com/h5_vod/player/index.html?name=' + encodeURI(item.name) + '&rtsp=' + base64.encode(rst.playUrl) + '&reportUrl=' + base64.encode(rst.reportUrl) + '&vodId=' + item.id + '&flag=1&type=SP';
                                    win.debug(" ===> NAME : [" , item.name , "], PLAY : [" , rst.playUrl , "], REPORT : [" , rst.reportUrl , "], PlayURL : [" , url , "]");
                                    p60_path_save();
                                    top.window.location.href = url;
                                } else {
                                    sysmisc.showToast(SYSTEM_BUSY_RETRY_LATER);
                                }
                            }); return;
                        } else if ( iPanel.mediaType == "GW" ) {
                            win.debug("iPanelGatewayHelper.play('" + String(item.id) + "');");
                            iPanelGatewayHelper.play(String(item.id));
                        } else {
                            win.debug("P30 OR HD3.0 Play Item -> Before Ajax Invoke!");
                            url = that.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.id + "&contentType=0&startTime=0&business=1";
                        }
                    } else {
                        if(iPanel.mediaType == 'P60') {
                            p60_path_save();
                            url = 'http://aoh5.cqccn.com/h5_vod/vod/detail.html?vod_id=' + item.id;
                        } else if (iPanel.mediaType == 'HD3.0' || iPanel.mediaType == 'P30' || iPanel.mediaType == 'GW'){
                            var detailPage = 'vod/tv_detail.jsp';
                            if (that.isKorean) detailPage = 'hjzq/hj_tvDetail.jsp';
                            else if (that.isWestern) detailPage = 'western/eu_tvDetail.jsp';
                            url = that.current() + "/EPG/jsp/defaultHD/en/hddb/" + detailPage + "?vodId=" + item.id + "&typeId=" + typeId;
                        }
                    }
                }
                window.location.href = url;
            },
            selectAct: function () {
                if (that.focusable.length <= 0) return;
                var blocked = that.blocked;
                var focus = that.focusable[blocked].focus;
                var typeId = that.focusable[blocked].typeId;
                var item = that.focusable[blocked].items[focus];
                item.typeId = typeId;
                that.call('selectItem', item);
            },
            goBackAct: function () {
                win.debug('=======>>>>> GO BACK (MediaType:',iPanel.mediaType,',EPGFlag:"', that.EPGflag, '",backURL:"', that.backUrl ,'") <<<<<=======');
                if (!that.EPGflag.isEmpty() || typeof that.backUrl === 'undefined' || that.backUrl.isEmpty() || that.backUrl.indexOf('Category.jsp') >= 0) {
                    if ( iPanel.mediaType == "P60" ){
                        sysmisc.finish();
                        //如果是来点盒子，或者家庭网关，使用此方法退出到首页
                    } else if ( iPanel.mediaType == "P30" || iPanel.mediaType == "GW") {
                        iPanel.eventFrame.exitToHomePage();
                    } else
                        top.window.location.href = iPanel.eventFrame.portalUrl;
                    return;
                }
                var url = that.backUrl;
                if ( that.appendURL != '' && that.appendURL != 'undefined') url += '&backURL=' + that.appendURL;
                win.debug('=======>>>>> GO BACK LINK TO : ',  url , ' <<<<<=======' );
                top.window.location.href = url;
            },
            select: function () {
                that.call('selectAct');
            },
            goBack: function () {
                that.call('goBackAct');
            },
            goHome: function () {
                //如果是来点盒子，或者家庭网关，使用此方法退出到首页
                if (typeof iPanel.eventFrame.systemId !== 'undefined') {
                    iPanel.eventFrame.exitToHomePage();
                } else {
                    top.window.location.href = iPanel.eventFrame.portalUrl;
                }
            }
        };
        /**
         * 获取 posters 中的图片
         * @param posters 包含图象的对象
         * @param type 0 缩略图，1 海报 ，2 剧照 ，3 图标, 4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ， 10 频道名字图片 ， 11 其他
         * @param defaultPic 默认图片
         * @param index 图片中的顺序
         */
        this.pictureUrl = function (posters, type, defaultPic, index) {
            var pic = defaultPic || '';
            if (typeof posters === 'undefined' || typeof type === 'undefined') return pic;
            var arr = posters[type];
            if (typeof arr === 'undefined') return pic;
            index = index || 0;
            return arr[index];
        };
        this.getPlayList = function (list) {
            var playList = [];
            var getRedirectList = function (redirectId, name, id) {
                var result = [];
                for (var i = list.length - 1; i > 0; i--) {
                    var item = list[i];
                    if (redirectId == item.id) {
                        list[i].redirected = true;
                        return getList(list[i], list[i].name || name, id);
                    }
                }
                return result;
            };
            var getList = function (element, from, fromId) { //from 保存的是名称, 如果为系列剧时, 还需要保存 当前剧集的ID, 把剧集的ID保存在 parentId中
                that.sitcoms = [];
                var typeId = element.id || element.typeId;
                var items = element.data || element.items;
                var result = [];
                if (typeof items !== 'undefined') {
                    for (var i = 0; i < items.length; i++) {
                        var item = items[i];
                        //如果是专题
                        if (typeof item.linkto === 'string') continue;

                        if (typeof item.redirect === 'string') {
                            result = result.concat(getRedirectList(item.redirect, item.name, item.id));
                            continue;
                        }

                        if (item.isSitcom === 0) {
                            var o = {name: item.name, typeId: item.typeId || typeId, id: item.id};
                            if (typeof from !== 'undefined') {
                                o.original = from;
                                o.originId = fromId;
                            }
                            result.push(o);
                        } else if (typeof item.childrenList !== 'undefined') {
                            that.sitcoms.push(item);
                            var childrenIdList = item.childrenIdList;
                            var childrenList = item.childrenList;
                            for (var j = 0; j < childrenList.length; j++) //index 存放的是索引顺序，有可能第10个并不是 第10集
                                result.push({original: item.name, index: j, name: item.name + decodeURIComponent('%20(%E7%AC%AC') + childrenIdList[j] + decodeURIComponent('%E9%9B%86)'), typeId: typeId, id: childrenList[j], parentId: item.id});
                        }
                    }
                }
                return result;
            };
            if (typeof list !== 'undefined')
                for (var i = 0; i < list.length; i++) {
                    var item = list[i];
                    if (item.redirected) continue;
                    playList = playList.concat(getList(item));
                }
            return playList;
        };
        /**
         * vote.target: 投票目标,一般为 item.name
         * that.voteId:投票ID
         * vote.limit:每天最多投票 x 票
         * vote.limitPer: 每个人最多投票 x 票
         * @param vote
         */
        this.commiting = false;
        this.sendVote = function (vote) {
            vote = vote || {};
            if (!that.voteId && !vote.id) return;
            that.voteId = vote.id || that.voteId;
            if ( that.commiting || typeof  vote.target === 'undefined') return;
            if ( typeof that.phoneNumber === 'undefined') that.phoneNumber = '0';
            that.commiting = true;
            var url = "http://" + (typeof iPanel.isComputer === 'undefined' ? "ivote.vod.cqcnt.com:8080" : "192.168.18.249:8080") + (vote.repeat ? ("/voteNew/external/addVote6.ipanel?icid=" + CA.card.serialNumber +
                    "&phone=" + that.phoneNumber +
                    "&classifyID=" + that.voteId +
                    "&voteCount=" + vote.limit +
                    "&contentNum=" + vote.limitPer + "&content=" + encodeURIComponent(vote.target)) :
                    ("/voteNew/external/addVote.ipanel?icid=" + CA.card.serialNumber +
                        "&repeat=false&phone=" + that.phoneNumber +
                        "&classifyID=" + that.voteId +
                        "&content=" + encodeURIComponent(vote.target))
            );
            ajax(url, function (result) {
                if (typeof vote.callback == 'function') {
                    vote.callback(result);
                };
                that.commiting = false;
            }, {charset: "GBK"});
        };
        this.voteResult = function (o) {
            try {
                if (that.voteId === 0) return;
                o = o || {};
                var block = o.block || 0;
                var callback = o.callback || null;
                var url = 'http://' + (typeof iPanel.isComputer === 'undefined' ? "ivote.vod.cqcnt.com:8989" : "192.168.18.249:8989") + '/VoteStatistics/getVoteInfo?classifyID=' + that.voteId;
                ajax( url, function (results) {
                    if (typeof results != 'undefined') {
                        results.sort(function () {
                            function sort(a, b) {
                                var compare = function (a, b) {
                                    if (a > b) return 1;
                                    if (a < b) return -1;
                                    return 0;
                                };
                                return compare(a.num, b.num);
                            }
                        });
                        for (var j = 0; j < results.length; j++) {
                            var name = results[j].name;
                            for (var i = 0; i < that.focusable[block].items.length; i++) {
                                if (name != that.focusable[block].items[i].name) continue;
                                that.focusable[block].items[i].voteCount = results[j].num;
                                break;
                            }
                        }
                        if (callback == null) { that.call("show"); } else { callback(results); }
                    }
                });
            } catch (e) {}
        };
        this.getCurrFocus = function () {
            var focusStr = that.blocked + ",";
            for (var i = 0; i < that.focusable.length; i++)
                focusStr += that.focusable[i].focus + ",";
            focusStr += that.playIndex;
            if (typeof that.consigned !== 'undefined') {
                if (!isNaN(that.consigned)) focusStr += "," + that.consigned;
                else for (var i = 0; i < that.consigned.length; i++) focusStr += "," + that.consigned[i];
            }
            return focusStr;
        };
        this.current = function () {
            return win.EPGUrl + "/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + that.getCurrFocus() + "&url="
        };
        this.elapsedSeconds = function () {
            if (this.starter === 'undefined' || isNaN(this.starter)) return 0;
            var time = new Date().getTime();
            return parseInt(Math.floor((time - this.starter) / 1000.0));
        };
        this.fireEvent = function (name) {
            var args = {"code": name};
            var evt = document.createEvent("CustomEvent");
            evt.initCustomEvent("iPanelEvent", false, false, args);
            document.dispatchEvent(evt);
        };
        this.secondsToTime = sec_to_time;
        this.timeToSeconds = time_to_sec;
        this.calcStringPixels = calcStringPixels;
        this.marquee = function (str, font, id, width) {
            that.calcStringPixels(str, font, function (pixelsWidth) {
                var innerHTML = pixelsWidth > width ? ('<marquee class="marqueed" scrollamount="10">' + str + "</marquee>") : str;
                $(id).innerHTML = innerHTML;
            });
        };
        this.initialize = function (params) {
            params = params || {};
            this.options.extend(params);
            if (typeof this.options['init'] === 'function') this.options['init'](that);
            if (typeof this.options['initCursor'] === 'function') this.options['initCursor'](that);
            if ( that.backUrl == '' || that.backUrl == undefined ) {
                that.backUrl = link.query('backURL');
                var index = that.backUrl.indexOf('#|#');
                if( index > 0 ) {
                    that.appendURL = that.backUrl.substr( index + 3 );
                    that.backUrl = that.backUrl.substr(0, index );
                }
                that.backUrl = decodeURIComponent(that.backUrl);
            }
        };
        this.call = function (name, args) {
            var fn = this.options[name];
            if (typeof fn !== 'function') fn = this.functions[name];
            if (typeof fn !== 'function') fn = this[name];
            if (typeof fn === 'function') {
                return fn(args);
            } else {
                var message = decodeURIComponent('%E5%87%BD%E6%95%B0%20') + name + decodeURIComponent('()%20%E6%9C%AA%E5%AE%9A%E4%B9%89%3B');
                win.debug(message);
            }
        };
    };
    var MuxPlayer = function(){
        var PLAY = decodeURIComponent('%E6%92%AD%E6%94%BE');
        var PAUSE = decodeURIComponent('%E6%9A%82%E5%81%9C');
        var STOP = decodeURIComponent('%E5%81%9C%E6%AD%A2');
        var FORWARD = decodeURIComponent('%E5%BF%AB%E8%BF%9B');
        var BACKWARD = decodeURIComponent('%E5%BF%AB%E9%80%80');

        this.playerId = undefined; //PlayId, P60使用，
        this.playType = "VOD";   //如果是直播不使用快进快退暂停功能
        this.status = STOP;       //播放，暂停，停止，快进，快退，错误
        this.speed = 1;
        this.length = undefined;
        this.position = undefined;
        var that = this;
        var convertPos = function(left,top,width,height){
            var p = {x:0,y:0,w:1,h:1};
            p.x = ( typeof left != 'undefined' ? left : typeof that.position.left != 'undefined' && !that.fullmode ? that.position.left : 0 ) / 1280.0;
            p.y = ( typeof top != 'undefined' ? top : typeof that.position.top != 'undefined' && !that.fullmode ? that.position.top : 0 ) / 720.0;
            p.w = ( typeof width != 'undefined' ? width : typeof that.position.width != 'undefined' && !that.fullmode ? that.position.width : 1280 ) / 1280.0;
            p.h = ( typeof height != 'undefined' ? height : typeof that.position.height != 'undefined' && !that.fullmode ? that.position.height : 720 ) / 720.0;

            win.debug("convert position ( x: ", p.x, ', p.y: ', p.y, ', p.w: ', p.w, ', p.h: ', p.h);
            return p;
        };
        this.setPosition = function(left,top,width,height){
            win.debug("CALL [setPosition] => media position : (x:", left, ",y:", top, ",width:", width, ",height:" , height,")");
            that.fullmode = false;
            this.position = {left:left, top:top, width:width, height:height};
            if ( iPanel.mediaType !== "P60" ) {
                media.video.setPosition(left,top,width,height);
            } else {
                if( typeof that.playerId === 'undefined' ) return;
                var p = convertPos(left,top,width,height);
                if( that.playType == "LIVE" ){
                    dvbplayer.resize(that.playerId,p.x,p.y,p.w,p.h);
                } else {
                    mixplayer.resize (that.playerId,p.x,p.y,p.w,p.h);
                }
            }
        };
        that.seekTo = function(seconds) {
            if( that.playType == "LIVE" || that.mediaType == 'P60' && that.playerId != undefined ) return;
            if ( iPanel.mediaType !== "P60" ) {
                media.AV.seek(cursor.secondsToTime( seconds ));
            } else {
                mixplayer.seekTo(that.playerId, seconds);
            }
        };
        this.getStatus = function(){
            return that.status;
        };
        this.backward = function(speed){
            if( that.playType == "LIVE" || that.mediaType == 'P60' && that.playerId != undefined ) return;
            that.speed = speed;
            if ( iPanel.mediaType !== "P60" ) {
                media.AV.backward(speed);
            } else {
                mixplayer.scale(that.playerId, -speed);
            }
            that.status = BACKWARD;
        };
        this.forward = function(speed){
            if( that.playType == "LIVE" || that.mediaType == 'P60' && that.playerId != undefined ) return;
            that.speed = speed;
            if ( iPanel.mediaType !== "P60" ) {
                media.AV.forward(speed);
            } else {
                mixplayer.scale(that.playerId, speed);
            }
            that.status = FORWARD;
        };
        this.elapsed = function(){
            var ela = 0;
            if( that.playType == "LIVE" || that.mediaType == 'P60' && that.playerId != undefined ) return ela;
            debug("VOD ELAPSED : " ,ela = ( iPanel.mediaType !== "P60" ? media.AV.elapsed : mixplayer.getCurrent(that.playerId) ) || ela);
            return ela;
        };
        this.duration  = function(){
            var dur = 0;
            if( that.playType == "LIVE" || that.mediaType == 'P60' && that.playerId != undefined ) return dur;
            debug("VOD DURATION : " ,dur = ( iPanel.mediaType !== "P60" ? media.AV.duration : mixplayer.getDuration(that.playerId) ) || dur);
            return dur;
        };
        this.voiceUp = function(){
            if ( iPanel.mediaType !== "P60" ) {
                media.sound.up();
            } else {
                if( that.playType == "LIVE" || that.playerId != undefined ) return;
                mixplayer.voiceUp();
            }
        };
        this.voiceDown = function(){
            if ( iPanel.mediaType !== "P60" ) {
                media.sound.down();
            } else {
                if( that.playType == "LIVE" || that.playerId != undefined ) return;
                mixplayer.voiceDown();
            }
        };
        this.fullScreen = function() {
            win.debug("CALL [fullScreen] ==> video play in full screen!");
            that.fullmode = true;
            if( iPanel.mediaType != 'P60' ) {
                if( iPanel.mediaType == "GW" ) {
                    media.video.setPosition(0,0,1280,720);
                } else {
                    media.video.fullScreen();
                }
            } else if( iPanel.mediaType == 'P60' ){
                sysmisc.bringToForeground("video");
                if( that.playerId != undefined ){
                    var p = convertPos(0,0,1280,720);
                    if( that.playType == "LIVE" ){
                        dvbplayer.resize(that.playerId,p.x,p.y,p.w,p.h);
                    } else {
                        mixplayer.resize (that.playerId,p.x,p.y,p.w,p.h);
                    }
                }
            }
        };
        this.resume = function(){
            if( that.playType == "LIVE" ) return;
            if ( iPanel.mediaType !== "P60" ) {
                media.AV.play();
            } else if( that.playType == 'P60' ) {
                sysmisc.bringToForeground("web");
                if( that.playerId != undefined ) mixplayer.resume(that.playerId);
            }
            that.status = PLAY;
            debug("player.resume ==> playType: ", that.playType, ",player.status = ", that.status);
        };
        this.pause = function() {
            if( that.playType == "LIVE" ) return;
            if ( iPanel.mediaType !== "P60" ) {
                media.AV.pause();
            } else {
                if( that.playerId != undefined ) mixplayer.pause(that.playerId);
            }
            that.status = PAUSE;
        };
        this.close = function(){
            if ( iPanel.mediaType !== "P60" ) {
                if( that.playType == "LIVE" ) {
                    DVB.stopAV();
                }
                media.AV.close();
            } else {
                if( that.playerId != undefined ) {
                    if( that.playType == "LIVE" ) {
                        dvbplayer.stop(that.playerId);
                    } else {
                        mixplayer.stop(that.playerId);
                    }
                }
            }
            that.status = STOP;
        };
        //options 为一个对象：
        //position: {left,top,width,height}
        //typeId: 栏目ID， 或-1;
        //vodId:  视频的ID，可以是内部ID，也可以是外部ID
        //idType: 如果idType不为空，说明播放的为外部ID
        //arguments.callee 函数本身
        this.play = function(o){
            o = o || {};
            that.playType = typeof o.vodId !== 'undefined' ? 'VOD' : 'LIVE';
            if( typeof o.position != 'undefined' ) that.setPosition(o.position.left,o.position.top,o.position.width,o.position.height);
            win.debug("media Type:" , iPanel.mediaType , ', playType:', that.playType);
            var delegate = function(rst){
                if(typeof o.callback !== 'function') return;
                o.callback(rst);
            };
            //如果vodId存在，那么播放点播
            if( typeof o.vodId !== 'undefined') {
                o.typeId = o.typeId || -1;
                o.startTime = String(o.startTime || 0);
                if( iPanel.mediaType !== "GW" ) {
                    var url = win.EPGUrl + '/defaultHD/en/go_authorization.jsp?typeId=' + o.typeId;
                    url += typeof o.parentId != 'undefined' ? ( '&playType=11&parentVodId=' + String( o.parentId ) ) : ('&playType=1');
                    url += '&progId=' + o.vodId + "&contentType=0&business=1&baseFlag=0";
                    url += ( String(o.vodId).length > 8 || typeof o.idType != 'undefined' ? "&idType=FSN" : "");
                    url += "&startTime=" + o.startTime;
                    ajax(url, function(rst){
                        if( rst.playFlag === "1") {
                            var rtsp = rst.playUrl.split("^")[4];
                            if( iPanel.mediaType !== "P60" ){
                                media.AV.open(rtsp,"VOD");
                            } else {
                                that.rtsp = rtsp;
                                if( that.playerId === undefined ) {
                                    var p = convertPos();
                                    that.playerId = mixplayer.create(p.x, p.y, p.w, p.h);
                                    that.startTime = o.startTime;
                                } else {
                                    mixplayer.playUrl(that.playerId, rtsp, o.startTime );
                                }
                            }
                        } else {
                            win.debug(GET_VOD_RTSP_ADDR_ERROR , url);
                        }
                        delegate(rst);
                    });
                    return;
                } else {
                    var open = function(id){
                        var http = iPanelGatewayHelper.getPlayUrl(id);
                        media.AV.open(http,"HTTP");
                        delegate(http);
                        debug("GW PLAY ID: ", id, " ==> URL: ", http);
                    };
                    if( o.idType !== 'FSN'){
                        open(o.vodId); return;
                    };
                    ajax(win.EPGUrl + '/neirong/player/detail.jsp?id=' + o.vodId, function(rst){ open(rst.id); });
                }
            } else {
                var frequency = o.frequency || '';
                var serviceId = o.serviceId || '';
                var uri = '';
                var msg = "=======>>>>> DVB PLAY ERROR ( serviceId or frequency IS EMPTY ) <<<<<=======";
                if( frequency == '' || serviceId == ''){
                    win.debug(msg); delegate(msg); return;
                }
                if( iPanel.mediaType == "HD3.0" || iPanel.mediaType == "P30") {
                    //alert('mediaType: ' + iPanel.mediaType + ',frequency: ' + frequency + ",serviceId:" + serviceId);
                    DVB.playAV(frequency,serviceId);
                } else if( iPanel.mediaType == "GW" ) {
                    var mod = Math.floor(Number(serviceId) / 100);
                    uri = 'http://192.168.1.202:18080/D_40992_' + mod + "_" + serviceId;
                    media.AV.open(uri,"HTTP");
                } else if( iPanel.mediaType == "P60" ) {
                    that.dvbUri = uri = 'dvbelement://' + String( Number(frequency) / 10 ) + ".6875.64." + String( serviceId) + '.0.0.0.0.0.0';
                    win.debug(decodeURIComponent('=======>>>>>%20P60%20%E7%9B%B4%E6%92%AD%E5%9C%B0%E5%9D%80%3A'), uri , ' <<<<<=======');
                    if( that.playerId === undefined ) {
                        var p = convertPos();
                        that.playerId = dvbplayer.create(p.x, p.y, p.w, p.h);
                    } else {
                        win.debug(decodeURIComponent('=======>>>>>%20P60%E7%9B%B4%E6%92%AD%E6%92%AD%E6%94%BE%E5%99%A8%E8%B0%83%E7%94%A8%20( playerId:'), that.playerId ,", Uri:", that.dvbUri , ' ) => ', dvbplayer.playFrequency(that.dvbUri) == 0 ? STATIC_SUCCESS_STR : STATIC_FAIL_STR, ' <<<<<=======');
                    }
                } else {
                    msg = "=======>>>>> DVB PLAY ERROR ( invalid mediaType ) <<<<<=======";
                    win.debug(msg); delegate(msg);return;
                }
                delegate();
            }
        };
        //退出页面时执行此代码
        this.exit = function(){
            try {
                DVB.stopAV(0);
                media.AV.close();
                if ( iPanel.mediaType == "P60" ) {         //如果是P60执行清理
                    if( that.playerId != undefined ) {
                        if ( that.playType == 'LIVE' ){       // 小窗口打开了直播窗口
                            dvbplayer.stop(that.playerId);
                            dvbplayer.destroy(that.playerId);
                        } else {
                            mixplayer.stop(that.playerId);         // 停止
                            mixplayer.destroy(that.playerId);      // 销毁
                        }
                        that.P60PlayerCreated = that.playerId = undefined;
                    }
                }
            } catch (e) {
                win.debug("page closed error : " + e );
            }
        };
        var evt = function(e){
            var type = e.type;
            var subtype = e.subtype;
            win.debug("TYPE ==> ", type, ", SUBTYPE ==> ", type);
            if( type == 0 ) {
                switch (subtype) {
                    case 0 :
                        if( typeof player.P60PlayerCreated == 'undefined') {
                            player.P60PlayerCreated = true;
                            if( player.playType  == 'VOD' ) {
                                win.debug(decodeURIComponent('P60%E7%82%B9%E6%92%AD%E6%92%AD%E6%94%BE%E5%99%A8%E8%B0%83%E7%94%A8%20( playerId:'), that.playerId ,", rtsp:", player.rtsp , ", startTime:" ,player.startTime , ' ) ====>>>> ', mixplayer.playUrl(that.playerId, player.rtsp, player.startTime ) == 0 ? STATIC_SUCCESS_STR : STATIC_FAIL_STR);
                            } else if( player.playType == 'LIVE' ) {
                                win.debug(decodeURIComponent('P60%E7%9B%B4%E6%92%AD%E6%92%AD%E6%94%BE%E5%99%A8%E8%B0%83%E7%94%A8%20( playerId:'), that.playerId ,", Uri:", that.dvbUri , ' ) ====>>>> ', dvbplayer.playFrequency(that.dvbUri) == 0 ? STATIC_SUCCESS_STR : STATIC_FAIL_STR) ;
                            }
                        }
                        break;   //创建播放器成功
                    case 1 : //播放成功
                        if( that.playType == 'VOD' ) dvbplayer.setStopMode(2);
                        break;
                    case 2 :
                        if( typeof cursor != "undefined" ) {
                            if( player.playType  == 'VOD' ) {
                                win.debug(decodeURIComponent('----------------------%20P60%E8%A7%86%E9%A2%91%E6%92%AD%E6%94%BE%E7%BB%93%E6%9D%9F%20%20-------------------'));
                                that.exit();
                                cursor.call("nextVideo");
                            }
                        }
                        break;   //播放结束
                    case 4 : break;   //前端数据停播
                    case 5 : break;   //未知
                    case 10 : break;  //销毁成功
                    case 11 : break;  //网络已恢复
                    case 12 : break;  //网络连接断开
                    case 10 : break;  //播放器网络内部出现问题
                    default : break;
                }
            } else if(type == 1){
                switch (subtype) {
                    case 100 : break; //播放失败
                    case 105 : break; //解码失败
                    case 107 : break; //rtsp交互失败
                    case 109 : break; //媒体源无效
                    default : break;
                }
            } else if( type == 2 ) {
                switch (subtype) {
                    case 0 : break; //成功
                    case 9 : sysmisc.showToast(decodeURIComponent('%E8%AF%A5%E8%8A%82%E7%9B%AE%E6%97%A0%E6%8E%88')); break; //1008 该节目无授
                    case 10 : break; //节目解密失败
                    case 12 : break; //区域不正确
                    case 33 : break; //机顶盒被冻结
                    case 50 : break; //节目属于其它CA系统加扰
                    default : break;
                }
            }
        };
        if( iPanel.mediaType == 'P60') {
            win.debug(decodeURIComponent('----------------------%20%E8%AE%BE%E7%BD%AEP60%2C%20onEvent%20%20-------------------'));
            win.onEvent = that.event = evt;
        }
    };
    /*初始化页面*/
    try {
        iPanel.eventFrame.initPage(win);
        E.is_HD_vod = true;
    } catch( e ) {}

    win.cursor = new Cursor();
    win.player = new MuxPlayer();
    win.onload = function () {
        if (iPanel.mediaType == 'PC' ) cursor.fireEvent("EIS_MISC_HTML_OPEN_FINISHED");
    };
    win.exit = function () {  //页面退出时执行清理
        player.exit();
    };
    win.eventHandler = function (eventObj, __type) {
        //其中大遥控器的收藏,节目,交互,广播键,没有键值
        var currentTime = new Date().getTime();
        var eventCode = String(eventObj.code);
        var hit = false;
        switch (eventObj.code) {
            //按下遥控器上下键进行光标移动操作，或直接忽略操作。
            case "KEY_UP" : cursor.call("onMoveUp"); hit = true; break;
            case "KEY_DOWN" : cursor.call("onMoveDown"); hit = true; break;
            //按下遥控器左右键进行光标移动操作，或进行快进快退。
            case "KEY_LEFT" : cursor.call("onMoveLeft"); hit = true; break;
            case "KEY_RIGHT" : cursor.call("onMoveRight"); hit = true; break;
            //使用遥控器按上一页时，播放前一条内容
            case "KEY_PAGE_UP" : cursor.call("onPageUp"); hit = true; break;
            case "KEY_PAGE_DOWN" : cursor.call("onPageDown"); hit = true; break;
            //当按回车键时，
            case "KEY_SELECT" : cursor.call("select"); hit = true; break;
            case "KEY_NUMERIC" : cursor.call("input", eventObj.args.value); hit = true; break;
            //在播放器页面中，按返回键，退出键，均退出播放器
            case "KEY_BACK" : cursor.call("goBack"); hit = true; break;
            //小遥控器的电视键,大遥控器的退出键
            case "KEY_EXIT" : cursor.call("goBack"); hit = true; break;
            case "KEY_MENU" : cursor.call("goHome"); hit = true; break;
            //如果播放地址串加载成功，播放视频流
            case "VOD_PREPAREPLAY_SUCCESS" : cursor.call("play"); hit = true; break;
            //如果播放完成，播放下一条
            case "EIS_VOD_PROGRAM_END" :
                if (typeof cursor.events[eventCode] != "undefined" && currentTime - cursor.events[eventCode] < 4000) return;
                cursor.call("nextVideo");
                hit = true; break;
            //小遥控器的#键,大遥控器的设置键
            case "KEY_SET" : cursor.call("press", "SET"); hit = true; break;
            //小遥控器的*键,大遥控器的咨讯键.
            case "KEY_BROADCAST" : cursor.call("press", 'STAR'); hit = true; break;
            //特殊功能键
            case "KEY_RED" : cursor.call("press", "RED"); hit = true; break;
            case "KEY_BLUE" : cursor.call("press", "BLUE"); hit = true; break;
            case "KEY_GREEN" : cursor.call("press", "GREEN"); hit = true; break;
            case "KEY_YELLOW" : cursor.call("press", "YELLOW"); hit = true; break;
            case "KEY_F1" : cursor.call("press", "F1"); hit = true; break;
            case "KEY_F2" : cursor.call("press", "F2"); hit = true; break;
            case "KEY_F3" : cursor.call("press", "F3"); hit = true; break;
            case "KEY_IME" : cursor.call("press", "F4"); hit = true; break;
            //INFO 键被按下
            case "KEY_INFO" : cursor.call("press", 'INFO'); hit = true; break;
            //大遥控器的 MAIL 键被按下
            case "KEY_MAIL" : cursor.call("press", 'MAIL'); hit = true; break;
            //回看键被按下
            case "KEY_PLAYBACK" : cursor.call("press", 'PLAYBACK'); hit = true; break;
            //大遥控器的广播键被按下
            case "KEY_AUDIO" : cursor.call("press", 'AUDIO'); hit = true; break;
            //声道键被按下
            case "KEY_AUDIO_MODE" : cursor.call("press", 'AUDIO_MODE'); hit = true; break;
            //静音键被按下
            case "KEY_MUTE" : cursor.call("press", 'MUTE'); hit = true; break;
            //TV+ 键被按下, 大遥控器的马赛克键,大遥控器的点播键
            case "KEY_VOD" : cursor.call("press", 'VOD'); hit = true; break;
            //页面加载完成
            case "EIS_MISC_HTML_OPEN_FINISHED" : cursor.call("htmlOpenFinished"); hit = true; break;
            default : break;
        }
        cursor.events[eventCode] = currentTime;
        if (hit) return false;
        return eventObj.args.type;
    };
})(window);