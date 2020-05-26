function joinStr(e) {
    var t = [];
    for (var i in e) {
        t[t.length] = i + "=" + encodeURIComponent(e[i])
    }
    return t.join("&").replace(/%20/g, "+").replace(/%25/g, "%")
}

function urlJoin(e, t) {
    for (var i = 1, n = arguments.length; i < n; i++) {
        var s = arguments[i];
        if (s !== undefined) {
            if (s.indexOf("?") === 0 || s.indexOf("&") === 0) s = s.substr(1);
            var r = i > 1 ? "&" : e.indexOf("?") > -1 ? "&" : "?";
            e += r + s
        }
    }
    return e;
}

function setCookie(cname, cvalue, exdays) {
    if (exdays) {
        var d = new Date();
        d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
        var expires = "expires=" + d.toGMTString();
        document.cookie = cname + "=" + cvalue + "; " + expires;
    } else {
        document.cookie = cname + "=" + cvalue + ";"
    }
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i].trim();
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}
/**
 *查询url参数
 */
function getQueryStr(_url, _param) {
    var rs = new RegExp("(^|)" + _param + "=([^\&]*)(\&|$)", "g").exec(_url),
        tmp;
    if (tmp = rs) {
        return tmp[2];
    }
    return "";
}

/**
 * base 64加密
 */

function Base64() {
    // private property  
    _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    // public method for encoding  
    this.encode = function(input) {
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
    }

    // public method for decoding  
    this.decode = function(input) {
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
            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }
        }
        output = _utf8_decode(output);
        return output;
    }

    // private method for UTF-8 encoding  
    _utf8_encode = function(string) {
        string = string.replace(/\r\n/g, "\n");
        var utftext = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }
        return utftext;
    }

    // private method for UTF-8 decoding  
    _utf8_decode = function(utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;
        while (i < utftext.length) {
            c = utftext.charCodeAt(i);
            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if ((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i + 1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i + 1);
                c3 = utftext.charCodeAt(i + 2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }
        }
        return string;
    }
}

function format(item) {
    if (Number(item) < 10) {
        return '0' + item;
    } else {
        return item
    }
}

/**
 * 删除URL全部携带参数
 */
function delUrlAllArguments(address) {
    if (address.indexOf("?") != -1) {
        return address.split("?")[0];
    } else {
        return address;
    }
}

/**
 * 删除URL单个携带参数
 */
function delUrlArgument(address, name) {
    var baseUrl = address.split('?')[0] + "?";
    var query = address.split('?')[1];
    if (query.indexOf(name) > -1) {
        var obj = {};
        var arr = query.split("&");
        for (var i = 0; i < arr.length; i++) {
            arr[i] = arr[i].split("=");
            obj[arr[i][0]] = arr[i][1];
        };
        delete obj[name];
        var url = baseUrl + JSON.stringify(obj).replace(/[\"\{\}]/g, "").replace(/\:/g, "=").replace(/\,/g, "&");
        if (url.split('?')[1] == '') {
            url = url.split('?')[0];
        }
        return url;
    } else {
        return address;
    }
}

/* ***************************************取播放串********************************************** */

function getObject(vod_id, flag, _parentVodId) {
    var p = {
        playType: flag ? '1' : '11', // 1为电影 11为剧集
        progId: vod_id, // 影片的ID(可传内部与外部ID)
        contentType: 0,
        business: 1,
        idType: vod_id.length > 7 ? 'FSN' : '',
        typeId: '-1',
        parentVodId: _parentVodId ? _parentVodId : '',
    }
    return p;
}

/*function getNewRTSP(name, vod_id, flag, index, time, _parentVodId) {
    if (sysmisc.getEnv('epg_address', '') != '') {
        var url = urlJoin(sysmisc.getEnv('epg_address', '') + '/EPG/jsp/defaultHD/en/go_authorization.jsp', joinStr(getObject(vod_id, flag, _parentVodId)));
        iDebug(">>>p60 getNewRTSP-url===" + url);
        var cookie = '[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid', '') + '"}]';
        bridge.ajax('post', url, 'text/xml', cookie, '', function(resp) {
            iDebug(">>>p60 getNewRTSP-success");
            iDebug(">>>p60 getNewRTSP-success-resp===" + resp);
            var jsonStr = resp.trim().replace(/[\r\n]/g, "");
            iDebug(">>>p60 getNewRTSP-success-jsonstr===" + jsonStr);
            var json = eval("(" + jsonStr + ")");
            iDebug(">>>p60 getNewRTSP-success-json===" + json);
            if (json.playUrl) {
            	iDebug(">>>p60 getNewRTSP-success-json.playUrl===" + json.playUrl);
                var rtsp = json.playUrl;
                var _playUrl = rtsp.split("^")[4];
                playVideo(_playUrl);
                return rtsp;
                iDebug(">>>p60 getNewRTSP-succ-rtsp===" + rtsp);
            }
        }, function(resp) {
            iDebug(">>>p60 getNewRTSP-fail");
        })
    }
}
*/
function getRTSP(name, vod_id, flag, index, time, _parentVodId) { //flag: 0：电视剧 1：电影 2：综艺 3：其他
    if (sysmisc.getEnv('epg_address', '') != '') {
        var url = urlJoin(sysmisc.getEnv('epg_address', '') + '/EPG/jsp/defaultHD/en/go_auth.jsp', joinStr(getObject(vod_id, flag, _parentVodId)));
        var cookie = '[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid', '') + '"}]';
        bridge.ajax('post', url, 'text/xml', cookie, '', function(resp) {
            var jsonStr = resp.trim().replace(/[\r\n]/g, "");
            if (/\<html\>/g.test(jsonStr)) {
                sysmisc.showToast('认证失效，请重启机顶盒！');
            } else {
                var json = JSON.parse(jsonStr);
                if (json.playUrl) {
                    var rtsp = json.playUrl;
                    var reportUrl = json.reportUrl;
                    if (flag == false) {
                        var parentVodId = json.parentVodId;
                    }

                    var base = new Base64();
                    sysmisc.path_sav(location.href);
                    if (index) {
                        var gotoUrl = 'http://aoh5.cqccn.com/h5_vod/vod/detail.html?vod_id=' + _parentVodId + '&variety=teleplay';
                        location.href = gotoUrl;
                    } else {
                        var gotoUrl = 'http://aoh5.cqccn.com/h5_vod/player/index.html?name=' + encodeURI(name) + '&rtsp=' + base.encode(rtsp) + '&reportUrl=' + base.encode(reportUrl) + '&vodId=' + vod_id + '&flag=' + flag + '&time=' + time;
                        location.href = gotoUrl;
                    }
                } else {
                    sysmisc.showToast(json.message);
                }
            }
        }, function(resp) {})
    } else {
        sysmisc.showToast('认证失效，请重启机顶盒！');
    }
}