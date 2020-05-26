;(function (win) {
    var Base64 = {
        _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", encode: function (input) {
            var output = "";
            var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
            var i = 0;
            input = Base64._utf8_encode(input);
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
                output = output + this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
            }
            return output;
        }, decode: function (input) {
            var output = "";
            var chr1, chr2, chr3;
            var enc1, enc2, enc3, enc4;
            var i = 0;
            input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
            while (i < input.length) {
                enc1 = this._keyStr.indexOf(input.charAt(i++));
                enc2 = this._keyStr.indexOf(input.charAt(i++));
                enc3 = this._keyStr.indexOf(input.charAt(i++));
                enc4 = this._keyStr.indexOf(input.charAt(i++));
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
            output = Base64._utf8_decode(output);
            return output;
        }, _utf8_encode: function (string) {
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
        }, _utf8_decode: function (utftext) {
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
    var AndroidHtml5 = {
        idCounter: 0,
        OUTPUT_RESULTS: {},
        CALLBACK_SUCCESS: {},
        CALLBACK_FAIL: {},
        callNative: function (cmd, type, args, success, fail) {
            var key = "ID_" + (++this.idCounter);
            console.log("cmd:" + JSON.stringify(cmd))
            if (typeof success != 'undefined') {
                AndroidHtml5.CALLBACK_SUCCESS[key] = success;
            } else {
                AndroidHtml5.CALLBACK_SUCCESS[key] = function (result) {
                };
            }
            if (typeof fail != 'undefined') {
                AndroidHtml5.CALLBACK_FAIL[key] = fail;
            } else {
                AndroidHtml5.CALLBACK_FAIL[key] = function (result) {
                };
            }
            window.sysmisc.async(JSON.stringify(cmd), type, JSON.stringify(args), key);
            return this.OUTPUT_RESULTS[key];
        },
        callWebService: function (url, nameSpace, methodName, serviceName, property, success, fail) {
            var key = "ID_" + (++this.idCounter);
            if (typeof success != 'undefined') {
                AndroidHtml5.CALLBACK_SUCCESS[key] = success;
            } else {
                AndroidHtml5.CALLBACK_SUCCESS[key] = function (result) {
                };
            }
            if (typeof fail != 'undefined') {
                AndroidHtml5.CALLBACK_FAIL[key] = fail;
            } else {
                AndroidHtml5.CALLBACK_FAIL[key] = function (result) {
                };
            }
            var property_string = JSON.stringify(property);
            window.sysmisc.asyncWebService(url, nameSpace, methodName, serviceName, property_string, key);
            return this.OUTPUT_RESULTS[key];
        },
        callBackJs: function (result, type, key) {
            if (type == "json") {
                this.OUTPUT_RESULTS[key] = result;
                var status = result.status;
                console.log(status);
                if (status == 200) {
                    console.log(typeof this.CALLBACK_SUCCESS[key]);
                    if (typeof this.CALLBACK_SUCCESS[key] != "undefined") {
                        AndroidHtml5.CALLBACK_SUCCESS[key](result.message);
                    }
                } else {
                    if (typeof this.CALLBACK_FAIL[key] != "undefined") {
                        console.log("CALLBACK_FAIL");
                        setTimeout("AndroidHtml5.CALLBACK_FAIL['" + key + "'](" + result.status + ")", 0);
                    }
                }
            } else {
                console.log('result key:' + key)
                this.OUTPUT_RESULTS[key] = result;
                var obj = JSON.parse(result);
                var message = Base64.decode(obj.message);
                console.log('result message:' + message)
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
        callWebServiceBackJs: function (result, key) {
            this.OUTPUT_RESULTS[key] = result;
            console.log(key);
            console.log(typeof(result));
            var obj = JSON.parse(result);
            var status = obj.code;
            console.log(status);
            if (status == 200) {
                console.log(typeof this.CALLBACK_SUCCESS[key]);
                if (typeof this.CALLBACK_SUCCESS[key] != "undefined") {
                    console.log(typeof("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']('" + result + "')"));
                    setTimeout("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']('" + result + "')", 0);
                }
            } else {
                if (typeof this.CALLBACK_FAIL != "undefined") {
                    console.log("AndroidHtml5.CALLBACK_FAIL['" + key + "']('" + result + "')");
                    setTimeout("AndroidHtml5.CALLBACK_FAIL['" + key + "']('" + result + "')", 0);
                }
            }
        }
    };
    var exec_asyn = function(service, action, type, args, success, fail) {
        var json = {"service": service, "action": action};
        var result = AndroidHtml5.callNative(json, type, args, success, fail);
    }
    var bridge = {}
    bridge.getwebservice = function (url, nameSpace, methodName, serviceName, property, success, fail) {
        AndroidHtml5.callWebService(url, nameSpace, methodName, serviceName, property, success, fail);
    }
    bridge.get = function (url, mediatype, header, success, fail) {
        exec_asyn("request", "", "json", {"url": url, "method": "get", "mediatype": mediatype}, success, function () {
            sysmisc.showToast("系统忙,请稍后重试。");
        })
    }
    bridge.post = function (url, mediatype, header, body, success, fail) {
        exec_asyn("request", "", "json", {
            "url": url,
            "method": "post",
            "mediatype": mediatype,
            "body": body,
            "header": header
        }, success, function () {
            sysmisc.showToast("系统忙,请稍后重试。");
        })
    }
    bridge.ajax = function (method, url, mediatype, header, body, success, fail) {
        if (arguments.length < 4) {
            bridge.ajax('post', method, 'text/xml', null, mediatype, url, null)
            return;
        }
        var o = {
            "url": url,
            "method": method.toLowerCase(),
            "mediatype": mediatype || "application/json",
            "body": body || null,
            "header": header || null
        };
        if (method != 'post') {
            delete o.body;
        }
        ;
        exec_asyn("request", "", "json", o, success || function () {
                sysmisc.showToast("success");
            }, fail || function () {
                sysmisc.showToast("系统忙,请稍后重试。");
            })
    }
    bridge.getstring = function (url, mediatype, header, success, fail) {
        exec_asyn("request", "", "string", {"url": url, "method": "get", "mediatype": mediatype}, success, function () {
            sysmisc.showToast("系统忙,请稍后重试。");
        })
    }
    bridge.poststring = function (url, mediatype, header, body, success, fail) {
        exec_asyn("request", "", "string", {
            "url": url,
            "method": "post",
            "mediatype": mediatype,
            "body": body,
            "header": header
        }, success, function () {
            sysmisc.showToast("系统忙,请稍后重试。");
        })
    }
    bridge.ajaxstring = function (method, url, mediatype, header, body, success, fail) {
        if (arguments.length < 4) {
            bridge.ajax('post', method, 'text/xml', null, mediatype, url, null)
            return;
        }
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
        }
        ;
        exec_asyn("request", "", "string", o, success || function () {
                sysmisc.showToast("success");
            }, fail || function () {
                sysmisc.showToast("系统忙,请稍后重试。");
            })
    }
    bridge.version = 2;
    window.bridge = bridge;
    window.AndroidHtml5 = AndroidHtml5;
})(window);

function Base64() {
    // private property
    var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

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
    var _utf8_encode = function(string) {
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
    var _utf8_decode = function(utftext) {
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
};