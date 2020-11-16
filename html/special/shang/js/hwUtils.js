;(function (w) {
    function ajaxClass(_url, _successCallback, _failureCallback, _completeCallback, _urlParameters, _callbackParams, _async, _charset, _timeout, _frequency, _requestTimes, _frame) {
        this.url = _url || "";
        this.successCallback = _successCallback || function (_xmlHttp, _params) {
            };
        this.failureCallback = _failureCallback || function (_xmlHttp, _params) {
            };
        this.completeCallback = _completeCallback || function (_xmlHttp, _params) {
            };
        this.urlParameters = _urlParameters || "";
        this.callbackParams = _callbackParams || null;
        this.async = typeof(_async) == "undefined" ? true : _async;
        this.charset = _charset || null;
        this.timeout = _timeout || 30000;
        this.frequency = _frequency || 5000;
        this.requestTimes = _requestTimes || 0;
        this.frame = _frame || window;
        this.timer = -1;
        this.counter = 0;
        this.method = "GET";
        this.headers = null;
        this.username = "";
        this.password = "";
        this.needEval = false;
        this.createXmlHttpRequest = function () {
            var xmlHttp = null;
            try {
                xmlHttp = new XMLHttpRequest();
            } catch (exception) {
                try {
                    xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (exception) {
                    try {
                        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (exception) {
                        return false;
                    }
                }
            }
            return xmlHttp;
        };
        this.xmlHttp = this.createXmlHttpRequest();
        this.requestData = function (_method, _headers, _username, _password) {
            this.frame.clearTimeout(this.timer);
            this.method = typeof(_method) == "undefined" ? "GET" : (_method.toLowerCase() == "post") ? "POST" : "GET";
            this.headers = typeof(_headers) == "undefined" ? null : _headers;
            this.username = typeof(_username) == "undefined" ? "" : _username;
            this.password = typeof(_password) == "undefined" ? "" : _password;
            var target = this;
            var data = null;
            this.xmlHttp.onreadystatechange = function () {
                target.stateChanged();
            };
            if (this.method == "POST") {
                var url = encodeURI(this.url);
                data = this.urlParameters;
            } else {
                var url = this.url + (((this.urlParameters != "" && this.urlParameters.indexOf("?") == -1) && this.url.indexOf("?") == -1) ? ("?" + this.urlParameters) : this.urlParameters);
            }
            if (this.username != "") {
                this.xmlHttp.open(this.method, url, this.async, this.username, this.password);
            } else {
                this.xmlHttp.open(this.method, url, this.async);
            }
            var contentType = false;
            if (this.headers != null) {
                for (var key in this.headers) {
                    if (key.toLowerCase() == "content-type") {
                        contentType = true;
                    }
                    this.xmlHttp.setRequestHeader(key, this.headers[key]);
                }
            }
            if (!contentType) {
                this.xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            }
            if (this.charset != null) {
                this.xmlHttp.overrideMimeType("text/html; charset=" + this.charset);
            }
            this.xmlHttp.send(data);
            this.timer = this.frame.setTimeout(function () {
                target.checkStatus();
            }, this.timeout);
        };
        this.stateChanged = function () {
            var target = this;
            if (this.xmlHttp.readyState < 2) {
                target.iDebug("[xmlHttp] readyState=" + this.xmlHttp.readyState);
            } else {
            }
            if (this.xmlHttp.readyState == 2) {
            } else if (this.xmlHttp.readyState == 3) {
            } else if (this.xmlHttp.readyState == 4) {
                this.frame.clearTimeout(this.timer);
                if (this.xmlHttp.status == 200 || this.xmlHttp.status == 204) {
                    this.success();
                } else {
                    this.failed();
                }
                this.complete();
            }
        };
        this.success = function () {
            if (!this.xmlHttp.responseText) return;
            if (this.needEval) {
                var res = eval("(" + this.xmlHttp.responseText + ")");
            } else {
                var res = "";
            }
            if (this.callbackParams == null) {
                this.successCallback(this.xmlHttp, res);
            } else {
                this.successCallback(this.xmlHttp, res, this.callbackParams);
            }
            this.counter = 0;
        };
        this.failed = function () {
            if (this.callbackParams == null) {
                this.failureCallback(this.xmlHttp);
            } else {
                this.failureCallback(this.xmlHttp, this.callbackParams);
            }
            this.counter = 0;
        };
        this.complete = function () {
            if (this.callbackParams == null) {
                this.completeCallback(this.xmlHttp);
            } else {
                this.completeCallback(this.xmlHttp, this.callbackParams);
            }
            this.counter = 0;
        };
        this.checkStatus = function () {
            if (this.xmlHttp.readyState != 4) {
                if (this.counter < this.requestTimes) {
                    this.requestAgain();
                } else {
                    this.failed();
                    this.complete();
                    this.requestAbort();
                }
            }
        };
        this.requestAgain = function () {
            this.requestAbort();
            var target = this;
            this.frame.clearTimeout(this.timer);
            this.timer = this.frame.setTimeout(function () {
                target.counter++;
                target.requestData(target.method, target.headers, target.username, target.password);
            }, this.frequency);
        };
        this.requestAbort = function () {
            this.frame.clearTimeout(this.timer);
            this.xmlHttp.onreadystatechange = function () {
            };
            this.xmlHttp.abort();
        };
        this.addParameter = function (_json) {
            var url = this.url;
            var str = this.urlParameters;
            for (var key in _json) {
                if (url.indexOf("?") != -1) {
                    url = "";
                    if (str == "") {
                        str = "&" + key + "=" + _json[key];
                    } else {
                        str += "&" + key + "=" + _json[key];
                    }
                    continue;
                }
                if (str == "") {
                    str += "?";
                } else {
                    str += "&";
                }
                str += key + "=" + _json[key];
            }
            this.urlParameters = str;
            return str;
        };
        this.getResponseXML = function () {
            if (this.xmlHttp.responseXML != null) {
                return this.xmlHttp.responseXML;
            } else if (this.xmlHttp.responseText.indexOf("<\?xml") != -1) {
                return typeof(DOMParser) == "function" ? (new DOMParser()).parseFromString(this.xmlHttp.responseText, "text/xml") : (new ActivexObject("MSXML2.DOMDocument")).loadXML(this.xmlHttp.responseText);
            }
            return null;
        };
        this.iDebug = function (str) {
            if (navigator.appName.indexOf("iPanel") != -1) {
                iPanel.debug(str);
            } else if (navigator.appName.indexOf("Opera") != -1) {
                opera.postError(str);
            } else if (navigator.appName.indexOf("Netscape") != -1 || navigator.appName.indexOf("Google") != -1) {
                console.log(str);
            }
        }
    };
    window.ajaxClass = ajaxClass;
})(window);

/* 兼容不支持JSON的浏览器 */
if (!window.JSON) {
    window.JSON = {
        stringify: function (obj) {
            var result = "";
            for (var key in obj) {
                if (typeof obj[key] == "string") {
                    // 如果属性值是String类型，属性值需要加上双引号
                    result += "\"" + key + "\":\"" + obj[key] + "\",";
                } else if (obj[key] instanceof RegExp) {
                    // 如果属性是正则表达式，属性值只保留一对空大括号{}
                    result += "\"" + key + "\":{},";
                } else if (typeof obj[key] == "undefined" || obj[key] instanceof Function) {
                    // 如果属性值是undefined, 该属性被忽略。忽略方法。
                } else if (obj[key] instanceof Array) {
                    // 如果属性值是数组
                    result += "\"" + key + "\":[";
                    var arr = obj[key];
                    for (var item in arr) {
                        if (typeof arr[item] == "string") {
                            // 如果数组项是String类型，需要加上双引号
                            result += "\"" + arr[item] + "\",";
                        } else if (arr[item] instanceof RegExp) {
                            // 如果属数组项是正则表达式，只保留一对空大括号{}
                            result += "{},";
                        } else if (typeof arr[item] == "undefined" || arr[item] instanceof Function) {
                            // 如果数组项是undefined, 则显示null。如果是函数，则显示null?。
                            result += null + ",";
                        } else if (arr[item] instanceof Object) {
                            //如果数组项是对象(非正则，非函数，非null)，调用本函数处理
                            result += this.stringify(arr[item]) + ",";
                        } else {
                            result += arr[item] + ",";
                        }
                    }
                    result = result.slice(0, -1) + "],"

                } else if (obj[key] instanceof Object) {
                    // 如果属性值是对象(非null，非函数，非正则)，调用本函数处理
                    result += "\"" + key + "\":" + this.stringify(obj[key]) + ",";
                } else {
                    result += "\"" + key + "\":" + obj[key] + ",";
                }
            }
            // 去除最后一个逗号,两边加{}
            return "{" + result.slice(0, -1) + "}";
        },
        parse: function (_str) {
            var obj = eval("(" + _str + ")");
            return obj;
        }
    };
}
;

var hwUtils = (function () {
    var URLS = {
        GO_AUTHORIZATION: "/defaultHD/en/go_authorization.jsp",
        GO_AUTH: "/defaultHD/en/go_auth.jsp",
        VOD_LIST_DATA: "/defaultHD/en/datajspHD/android_getVodList_data.jsp",
        TV_DETAIL_DATA: "/defaultHD/en/datajspHD/android_getTvDetail_data.jsp",
        P30_PLAY_PAGE: "/defaultHD/en/hidden_detail.jsp",
        P30_DETAIL_PAGE: function (playType) {
            return "/defaultHD/en/hddb/vod/" + (playType == "11" ? "tv_detail" : "film_detail") + ".jsp";
        },
        P60_DETAIL_PAGE: "http://aoh5.cqccn.com/h5_vod/vod/detail.html",
        P60_PLAY_PAGE: "http://aoh5.cqccn.com/h5_vod/player/index.html"
    };
    var ERROR_MSG = {
        NO_EPG_URL: "没有EPG URL",
        NO_PERMISSIONS: "无权限，请先进行购买"
    };

    var autoSetIdType = false;
    var jsLoaded = false;
    var P60 = "P60", iPanel30 = "iPanel30", iPanel30Advanced = "iPanel30Advanced", otherBrowser = "unknown";
    var browserType = otherBrowser;
    var p60AjaxJsPath = null;
    var userAgent = navigator.userAgent.toLowerCase();
    if (!window.iDebug) {
        iDebug = function () {
        };
    }
    function getBrowserType() {
        if (userAgent.indexOf("ipanel") != -1) {
            browserType = userAgent.indexOf("advanced") != -1 ? iPanel30Advanced : iPanel30;
        } else if (typeof sysmisc != "undefined") {
            browserType = P60;
        }
        return browserType;
    }

    getBrowserType();
    function loadScript(_url, _successCallBack, _failCallBack, _completeCallback) {
        if (!_url) return;
        var script = document.createElement('script');
        script.type = "text/JavaScript";
        script.async = "true";
        script.src = _url;
        script.onload = function () {
            iDebug("hwutilsNew.js--fn:loadScript success");
            _successCallBack && _successCallBack();
            _completeCallback && _completeCallback();
        }
        script.onerror = function () {
            iDebug("hwutilsNew.js--fn:loadScript error");
            _failCallBack && _failCallBack();
            _completeCallback && _completeCallback();
        }
        document.body.appendChild(script);
    }

    function getEpgUrl() {
        switch (browserType) {
            case P60:
                var p60Epg = sysmisc.getEnv('epg_address', '');
                if (!p60Epg) {
                    return false;
                }
                return p60Epg + "/EPG/jsp";
                break;
            case iPanel30:
            case iPanel30Advanced:
                return iPanel.eventFrame.pre_epg_url;
                break;
            default:
                break;
        }
        return false;
    }

    function getP60Cookie() {// P60专用
        var cookie = '[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid', '') + '"}]';
        iDebug("hwutilsNew.js--fn:getP60Cookie--P60Cookie = " + cookie);
        return cookie;
    }

    function joinStr(e) {
        var t = [];
        for (var i in e) {
            // t[t.length] = i + "=" + encodeURIComponent(e[i])
            t[t.length] = i + "=" + e[i];
        }
        // return t.join("&").replace(/%20/g, "+").replace(/%25/g, "%")
        return t.join("&")
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

    function dynamicsP60Ajax(type, url, successCallback, failureCallback) {
        bridge.ajax(type, url, 'text/xml', getP60Cookie(), '', function (resp) {
            var jsonStr = resp.trim().replace(/[\r\n]/g, "");
            successCallback(jsonStr);
        }, function (resp) {
            failureCallback(resp);
        });
    }

    function dynamicsAjax(o) {
        if (typeof o != "object" || !o.url) {
            return;
        }
        var params = o.params || {};
        var successCallback = o.success || function () {
            };
        var failureCallback = o.error || function () {
            };
        var type = o.type || o.method;
        if (!getEpgUrl()) {
            failureCallback(ERROR_MSG.NO_EPG_URL);
            return;
        }
        var url = o.url.replace("{HWEPGURL}", getEpgUrl());
        switch (browserType) {
            case iPanel30:
            case iPanel30Advanced:
                type = type == "post" ? "post" : "get";
                var ajaxObj = new ajaxClass();
                ajaxObj.url = url;
                ajaxObj.addParameter(params);
                ajaxObj.successCallback = function (xhr) {
                    successCallback(xhr.responseText);
                }
                ajaxObj.failureCallback = function (xhr) {
                    failureCallback(xhr.responseText);
                }
                ajaxObj.requestData(type);
                break;
            case P60:
                url = urlJoin(url, joinStr(params));
                iDebug("hwUtils.js--fn:dynamicsAjax--url = " + url);
                if (o.p60Type) {
                    type = o.p60Type;
                }
                type = type == "get" ? "get" : "post";//p60默认post
                if (!jsLoaded && p60AjaxJsPath) {
                    loadScript(p60AjaxJsPath, function () {
                        jsLoaded = true;
                        dynamicsP60Ajax(type, url, successCallback, failureCallback);
                    }, function (dataStr) {
                        failureCallback(dataStr);
                    });
                } else {
                    dynamicsP60Ajax(type, url, successCallback, failureCallback);
                }
                break;
            default:
                break;
        }
    }

    //vodId, playType, parentVodId, idType
    function getAuthObject(vod_id, playType, _parentVodId, idType) {
        vod_id = vod_id + "";
        var p = {
            playType: playType ? playType : '1', // 1为电影 11为剧集,如果不传默认为电影
            progId: vod_id, // 影片的ID(可传内部与外部ID)
            contentType: 0,
            business: 1,
            typeId: '-1',
        }
        if (_parentVodId) {
            p.parentVodId = _parentVodId;
        }
        if (autoSetIdType) {
            if (vod_id.length > 7) {
                p.idType = "FSN";
            }
        } else if (idType) {
            p.idType = idType;
        }
        return p;
    }


    function getGoAuthorization(vodId, playType, parentVodId, idType, successCallback, failureCallback) {
        if (typeof vodId == "object") {
            var tmpObj = vodId;
            playType = tmpObj.playType;
            parentVodId = tmpObj.parentVodId;
            successCallback = tmpObj.success;
            failureCallback = tmpObj.error;
            vodId = tmpObj.vodId;
            idType = tmpObj.idType;
        }
        var url = getEpgUrl() + URLS.GO_AUTHORIZATION;
        var params = getAuthObject(vodId, playType, parentVodId, idType);
        iDebug("hwUtilsNew.js--fn:getGoAuthorizatio--url = " + url + ";; params = " + JSON.stringify(params));
        dynamicsAjax({
            url: url,
            params: params,
            success: function (dataStr) {
                successCallback && successCallback(dataStr);
            },
            error: function (dataStr) {
                failureCallback && failureCallback(dataStr);
            }
        });
    }

    function getGoAuth(vodId, playType, parentVodId, idType, successCallback, failureCallback) {
        if (typeof vodId == "object") {
            var tmpObj = vodId;
            playType = tmpObj.playType;
            parentVodId = tmpObj.parentVodId;
            successCallback = tmpObj.success;
            failureCallback = tmpObj.error;
            vodId = tmpObj.vodId;
            idType = tmpObj.idType;
        }
        var url = getEpgUrl() + URLS.GO_AUTH;
        var params = getAuthObject(vodId, playType, parentVodId, idType);
        iDebug("hwUtilsNew.js--fn:getGoAuth--url = " + url + ";; params = " + JSON.stringify(params));
        dynamicsAjax({
            url: url,
            params: params,
            success: function (dataStr) {
                if (/\<body\>/g.test(dataStr)) {
                    failureCallback && failureCallback(ERROR_MSG.NO_PERMISSIONS);
                } else {
                    successCallback && successCallback(dataStr);
                }

            },
            error: function (dataStr) {
                failureCallback && failureCallback(dataStr);
            }
        });
    }


    function getGoAuthorizationWithPlayParamsObj(o) {
        getGoAuthorization({
            vodId: o.vodId,
            playType: o.playType,
            parentVodId: o.parentVodId,
            idType: o.idType,
            success: function (dataStr) {
                if (/\<body\>/g.test(dataStr)) {
                    o.error && o.error(ERROR_MSG.NO_PERMISSIONS);
                } else {
                    var jsonObj = eval("(" + dataStr + ")");
                    if (jsonObj.playFlag) {
                        var paramsArr = jsonObj.playUrl.split("^");
                        var playParams = {
                            vodId: paramsArr[0],
                            playType: paramsArr[1],
                            playUrl: paramsArr[4],
                            videoName: paramsArr[7],
                            duration: paramsArr[8]
                        };
                        o.success && o.success(playParams, jsonObj);
                    } else {
                        o.error && o.error(jsonObj);
                    }
                }
            },
            error: function (dataStr) {
                o.error && o.error(dataStr);
            }
        });
    }

    function getVodListObject(centerTypeId, pageNo, showNums, imgType) {
        var p = {
            centerTypeId: centerTypeId,
            pageNo: pageNo || 0,
            showNums: showNums || 10
        }
        if (imgType) {
            p.imgType = imgType;
        }
        return p;
    }


    function getVodListData(centerTypeId, pageNo, showNums, imgType, successCallback, failureCallback) {
        if (typeof centerTypeId == "object") {
            var tmpObj = centerTypeId;
            pageNo = tmpObj.pageNo;
            showNums = tmpObj.showNums;
            imgType = tmpObj.imgType;
            successCallback = tmpObj.success;
            failureCallback = tmpObj.error;
            centerTypeId = tmpObj.centerTypeId;
        }
        var url = getEpgUrl() + URLS.VOD_LIST_DATA;
        var params = getVodListObject(centerTypeId, pageNo, showNums, imgType);
        iDebug("hwUtilsNew.js--fn:getVodListData--url = " + url + ";; params = " + JSON.stringify(params));
        dynamicsAjax({
            url: url,
            params: params,
            success: function (dataStr) {
                successCallback && successCallback(dataStr);
            },
            error: function (dataStr) {
                failureCallback && failureCallback(dataStr);
            }
        });
    }

    function getTvDetailObj(vodId, typeId, idType, imgType) {
        var p = {
            typeId: typeId || -1,
            vodId: vodId
        }
        if (imgType) {
            p.imgType = imgType;
        }
        if (autoSetIdType) {
            if (("" + vodId).length > 7) {
                p.idType = "FSN";
            }
        } else if (idType) {
            p.idType = idType;
        }
        return p;
    }


    function getTvDetailData(vodId, typeId, idType, imgType, successCallback, failureCallback) {
        if (typeof vodId == "object") {
            var tmpObj = vodId;
            typeId = tmpObj.typeId;
            imgType = tmpObj.imgType;
            successCallback = tmpObj.success;
            failureCallback = tmpObj.error;
            vodId = tmpObj.vodId;
            idType = tmpObj.idType;
        }
        var url = getEpgUrl() + URLS.TV_DETAIL_DATA;
        //vodId, typeId, idType, imgType
        var params = getTvDetailObj(vodId, typeId, idType, imgType);
        iDebug("hwUtilsNew.js--fn:getTvDetailData--url = " + url + ";; params = " + JSON.stringify(params));
        dynamicsAjax({
            url: url,
            params: params,
            success: function (dataStr) {
                successCallback && successCallback(dataStr);
            },
            error: function (dataStr) {
                failureCallback && failureCallback(dataStr);
            }
        });
    }

    //vodId, typeId, playType, baseFlag, duration, backUrl
    //vodId, typeId, playType, baseFlag, duration, idType, backUrl
    function getHiddenObjStr(vodId, typeId, playType, baseFlag, duration, idType, backUrl) {
        var p = {
            vodId: vodId || "",
            typeId: typeId || "-1",
            playType: playType || "1", //1电影， 11电视剧
        };
        if (autoSetIdType) {
            if (("" + vodId).length > 7) {
                p.idType = "FSN";
            }
        } else if (idType) {
            p.idType = idType;
        }

        if (typeof baseFlag != "undefined") {
            p.baseFlag = baseFlag;
        }
        if (duration) {
            p.duration = duration;
        }
        p.appBackUrl = encodeURIComponent(backUrl);
        return p;
    }

    function jumpHiddenDetail(vodId, typeId, playType, baseFlag, duration, backUrl, idType, failureCallback) {
        if (typeof vodId == "object") {
            var tmpObj = vodId;
            vodId = tmpObj.vodId;
            typeId = tmpObj.typeId;
            playType = tmpObj.playType;
            baseFlag = tmpObj.baseFlag;
            duration = tmpObj.duration;
            backUrl = tmpObj.backUrl;
            failureCallback = tmpObj.error;
            idType = tmpObj.idType;
        }
        vodId = vodId + "";
        typeId = typeId || "-1";
        playType = playType || "1";
        baseFlag = baseFlag || "";
        duration = duration || "";
        backUrl = backUrl || window.location.href;
        getGoAuthorization({//进入播放页，前先检查是否有权限，如果有权限才跳转播放。
            vodId: vodId,
            playType: playType,
            idType: idType,
            success: function (dataStr) {
                var json = eval("(" + dataStr + ")");
                if (json.playUrl) {
                    var url = getEpgUrl() + URLS.P30_PLAY_PAGE;
                    var params = getHiddenObjStr(vodId, typeId, playType, baseFlag, duration, idType, backUrl);
                    var jumpUrl = urlJoin(url, joinStr(params));
                    iDebug("hwUtilsNew.js--fn:jumpHiddenDetail--jumpUrl = " + jumpUrl + ";; params = " + JSON.stringify(params));
                    window.location.href = jumpUrl;
                } else {
                    failureCallback && failureCallback(dataStr);
                }
            },
            error: function (dataStr) {
                failureCallback && failureCallback(dataStr);
            }
        });
    }

    function jumpP30Player(vodId, typeId, playType, baseFlag, duration, backUrl, idType, failureCallback){
        if (typeof vodId == "object") {
            var tmpObj = vodId;
            vodId = tmpObj.vodId;
            typeId = tmpObj.typeId;
            playType = tmpObj.playType;
            baseFlag = tmpObj.baseFlag;
            duration = tmpObj.duration;
            backUrl = tmpObj.backUrl;
            failureCallback = tmpObj.error;
            idType = tmpObj.idType;
        }
        vodId = vodId + "";
        typeId = typeId || "-1";
        playType = playType || "1";
        baseFlag = baseFlag || "";
        duration = duration || "";
        backUrl = backUrl || window.location.href;
        var url = getEpgUrl() + URLS.P30_PLAY_PAGE;
        var params = getHiddenObjStr(vodId, typeId, playType, baseFlag, duration, idType, backUrl);
        var jumpUrl = urlJoin(url, joinStr(params));
        var chongqingJumpFrame = document.getElementById("tipsFrame");
        if(chongqingJumpFrame != null) {
            chongqingJumpFrame.src = jumpUrl;
        }
    }

    function jumpP30Detail(vodId, typeId, playType, backUrl) {//跳转详情页，不判断卡号是否有权限，直接跳转
        if (typeof vodId == "object") {
            var tmpObj = vodId;
            vodId = tmpObj.vodId;
            typeId = tmpObj.typeId;
            backUrl = tmpObj.backUrl;
            playType = tmpObj.playType;
        }
        typeId = typeId || "-1";
        backUrl = backUrl || window.location.href;
        var url = getEpgUrl() + URLS.P30_DETAIL_PAGE(playType);
        var params = {vodId: vodId, typeId: typeId, appBackUrl: encodeURIComponent(backUrl)};
        var jumpUrl = urlJoin(url, joinStr(params));
        iDebug("hwUtilsNew.js--fn:jumpP30Detail--jumpUrl = " + jumpUrl + ";; params = " + JSON.stringify(params));
        window.location.href = jumpUrl;
    }

    function jumpTvDetail(vodId, typeId, backUrl) {
        jumpP30Detail(vodId, typeId, "11", backUrl);
    }

    function jumpFilmDetail(vodId, typeId, backUrl) {
        jumpP30Detail(vodId, typeId, "1", backUrl);
    }


    function jumpP60Detail(vodId, playType, parentVodId, idType, backUrl, failureCallback) {
        //playType: 11：电视剧 1：电影
        if (typeof vodId == "object") {
            var tmpObj = vodId;
            vodId = tmpObj.vodId;
            playType = tmpObj.playType;
            parentVodId = tmpObj.parentVodId;
            backUrl = tmpObj.backUrl;
            failureCallback = tmpObj.error;
            idType = tmpObj.idType;
        }
        backUrl = backUrl || window.location.href;
        getGoAuth({
            vodId: vodId,
            playType: playType,
            idType: idType,
            success: function (dataStr) {
                var json = eval("(" + dataStr + ")");
                if (json.playUrl) {
                    sysmisc.path_sav(backUrl);
                    var jumpUrl = null;
                    if (playType == 11) {
                        parentVodId = json.parentVodId;
                        jumpUrl = URLS.P60_DETAIL_PAGE + '?vod_id=' + parentVodId + '&variety=teleplay';
                    } else {
                        jumpUrl = URLS.P60_DETAIL_PAGE + '?vod_id=' + vodId + '&variety=movie';
                    }
                    iDebug("hwUtilsNew.js--fn:jumpP60Detail--jumpUrl = " + jumpUrl);
                    window.location.href = jumpUrl;
                } else {
                    failureCallback && failureCallback(json);
                }
            },
            error: function (dataStr) {
                failureCallback && failureCallback(dataStr);
            }
        });
    }

    function jumpP60Player(name, vodId, playType, idType, time, backUrl, failureCallback) {
        //playType: 11：电视剧 1：电影
        if (typeof name == "object") {
            var tmpObj = name;
            name = tmpObj.name;
            vodId = tmpObj.vodId;
            playType = tmpObj.playType;
            time = tmpObj.time;
            backUrl = tmpObj.backUrl;
            failureCallback = tmpObj.error;
            idType = tmpObj.idType;
        }
        backUrl = backUrl || window.location.href;
        getGoAuth({
            vodId: vodId,
            playType: playType,
            idType: idType,
            success: function (dataStr) {
                var json = eval("(" + dataStr + ")");
                if (json.playUrl) {
                    var rtsp = json.playUrl;
                    if (!name) {
                        name = rtsp.split("^")[7];
                    }
                    var reportUrl = json.reportUrl;
                    var base = new Base64();
                    sysmisc.path_sav(backUrl);
                    var url = URLS.P60_PLAY_PAGE;
                    var params = {
                        name: encodeURI(name),
                        rtsp: base.encode(rtsp),
                        reportUrl: base.encode(reportUrl),
                        vodId: vodId,
                        flag: playType == 11 ? "0" : "1",//flag: 0：电视剧 1：电影 2：综艺 3：其他
                        time: time
                    };
                    var jumpUrl = urlJoin(url, joinStr(params));
                    iDebug("hwUtilsNew.js--fn:jumpP60Player--url = " + jumpUrl + ";; params = " + JSON.stringify(params));
                    window.location.href = jumpUrl;
                } else {
                    failureCallback && failureCallback(json.message);
                }
            },
            error: function (dataStr) {
                failureCallback && failureCallback(dataStr);
            }
        });
    }

    function setJsPath(o) {
        o = o || {};
        if (!jsLoaded) {
            p60AjaxJsPath = o.p60;
        }
    }

    function autoLoadJs(jsArr, successCallback, failureCallback) {
        jsArr = jsArr || [];
        var len = jsArr.length;
        if (len === 0) {
            successCallback();
        } else {
            var jsPath = jsArr[0];
            jsArr.splice(0, 1);
            loadScript(jsPath, function () {
                autoLoadJs(jsArr, successCallback, failureCallback);
            }, function () {
                failureCallback();
            })
        }
    }

    function ajaxIsNotHw(url, data, method, headers, success, error) {
        //ajax工具，不是华为请求ajax，不要混用
        if (typeof url == "object") {
            var tmpObj = url;
            url = tmpObj.url;
            data = tmpObj.data;
            method = tmpObj.method || tmpObj.type;
            headers = tmpObj.headers;
            success = tmpObj.success;
            error = tmpObj.error;
        }
        data = data || {};
        method = method == "post" ? "post" : "get";
        success = success || function () {
            };
        error = error || function () {
            };
        if (!url) {
            error("没有请求地址");
            return;
        }
        switch (browserType) {
            case P60:
                if (method == "get") {
                    url = urlJoin(url, joinStr(data));
                }
                iDebug("hwUtilsNew.js--fn:ajaxUtils--url = " + url);
                if (!jsLoaded && p60AjaxJsPath) {
                    loadScript(p60AjaxJsPath, function () {
                        jsLoaded = true;
                        ajaxIsNotHwP60(url, method, data, headers, success, error)
                    }, function (dataStr) {
                        error(dataStr);
                    });
                } else {
                    ajaxIsNotHwP60(url, method, data, headers, success, error);
                }
                break;
            default:
                var ajaxObj = new ajaxClass();
                ajaxObj.url = url;
                ajaxObj.addParameter(data);
                ajaxObj.successCallback = function (xhr) {
                    success(xhr.responseText);
                };
                ajaxObj.failureCallback = function (xhr) {
                    error(xhr.responseText);
                };
                ajaxObj.requestData(method, headers);
                break;
        }
    }

    function ajaxIsNotHwP60(url, method, data, headers, success, error) {
        var o = {
            "url": url,
            "method": method.toLowerCase(),
            "mediatype": headers ? headers["Content-Type"] : "text/xml",
            "body": data || null,
            "header": headers || null
        };
        if (method != 'post') {
            delete o.body;
        }
        var json = {"service": "request", "action": ""};
        var result = AndroidHtml5.callNative(json, "string", o, success, error);
    }

    function getComments() {
        var comments = "风险:部分浏览器不支持script.onload事件，执行aotoLoadJs函数后，回调函数可能不会被执行。";
        return comments;
    }

    function printComments() {
        iDebug(getComments());
    }

    return {
        setAjaxJsPath: setJsPath,
        autoLoadJs: autoLoadJs,//未验证
        getGoAuthorization: getGoAuthorization,
        getVodListData: getVodListData,
        getTvDetailData: getTvDetailData,
        jumpP30Detail: jumpP30Detail,
        jumpP60Detail: jumpP60Detail,
        jumpP30Player: jumpP30Player,
        jumpP60Player: jumpP60Player,
        jumpHiddenDetail: jumpHiddenDetail,
        jumpTvDetail: jumpTvDetail,
        jumpFilmDetail: jumpFilmDetail,
        getGoAuth: getGoAuth,
        dynamicsAjax: dynamicsAjax,
        getEpgUrl: getEpgUrl,
        getGoAuthorizationWithPlayParamsObj: getGoAuthorizationWithPlayParamsObj,
        getComments: getComments,
        printComments: printComments,
        ajaxIsNotHw: ajaxIsNotHw
    };
})();

// chongqingJumpFrame这个iframe加载的鉴权页面在鉴权不通过时会调用主页面的showTipWindow函数，所以这里补充一个
if (!window.showTipWindow) {
    window.showTipWindow = function(msg, type) {
        if (typeof showTips == "function") {
            // 鉴权页面是gbk的，返回的数据需要进行如下处理才可以在utf-8页面正常呈现
            if (typeof(document.getElementById("tips")) != 'undefined') {
                document.getElementById("tips").innerText = "";
            }
            msg = iPanel.getDisplayString(msg);

            showTips(msg, true);
        }
    };
}

if (typeof(document.getElementById("tips")) != 'undefined') {
    document.getElementById("tips").style.backgroundColor = "#000000"; // 重庆有款盒子不支持rgba的写法，在这里临时改下
    document.getElementById("tips").style.color = "#ffffff"; // 重庆还不支持#fff这种颜色3位简写
    document.getElementById("tips").style.webkitTransitionDuration = "300ms"; // 重庆有款盒子对于2d属性解析有问题，会导致提示框被2d元素盖住，所以给提示框加个2d
}

function specialGoBack() {
    if (typeof iPanel != "undefined") {
        if (iPanel.eventFrame.systemId == 1) { 
            iPanel.eventFrame.exitToHomePage();
        } else if (iPanel.eventFrame.portal_url) {
            iPanel.mainFrame.location.href = iPanel.eventFrame.portal_url; 
        } else {
            history.back();
        }
    } else if (typeof sysmisc != "undefined") {
        var pathSave = sysmisc.path_back();
        if (pathSave && pathSave.indexOf("http") === 0) {
            window.location.href = pathSave;
        } else {
            sysmisc.finish();
        }
    } else {
        history.back();
    }
}

