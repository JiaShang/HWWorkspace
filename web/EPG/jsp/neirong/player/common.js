;(function (win) {
    //�ַ�����չ
    String.prototype.trim = function () { return this.replace(/(^\s*)|(\s*$)/g, ''); };
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
    //ISO-8859-1 �����ַ�������
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
    //����ISO-8859-1 ����, ȡ��start,����Ϊlengnth���Ӵ�
    String.prototype.calcString = function (start, length) {
        var str = this.replace(/[ ]*$/g, "");
        var len = 0;
        //TODO: �ַ���ȡ�Ӵ�
        return str;
    };
    String.prototype.query = function (key) {
        var rs = new RegExp('(\\?|&)' + key + '=([^&]*?)(&|$)', 'gi').exec(this);
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
    //���ڸ�ʽ���� ���÷�����var currentTime = (new Date()).format("yyyy-MM-dd hh:mm:ss");
    Date.prototype.Format = function (fmt) {
        var o = {
            'M+': this.getMonth() + 1,
            'd+': this.getDate(),
            'h+': this.getHours(),
            'm+': this.getMinutes(),
            's+': this.getSeconds(),
            'q+': Math.floor((this.getMonth() + 3) / 3),
            'S': this.getMilliseconds()
        };
        if (/(y+)/.test(fmt))
            fmt = fmt.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt))
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[k]).length)));
        return fmt;
    };
    //������չ
    Array.prototype.clear = function () { this.length = 0; };
    Array.prototype.insertAt = function (index, o) { this.splice(index, 0, o); };
    Array.prototype.insertAllAt = function (index, o) { for (var i = 0; i < o.length; i++) this.splice(index + i, 0, o[i]); };
    Array.prototype.pushAll = function (items) { for (var i = 0; i < items.length; i++) this.push(items[i]); };
    Array.prototype.removeAt = function (index) { if (isNaN(index) || index >= this.length) return false; this.splice(index, 1); };
    Array.prototype.remove = function (o) {
        var index = this.indexOf(o);
        if (index >= 0) this.removeAt(index);
    };

    var SYSTEM_BUSY_RETRY_LATER = decodeURIComponent('%E7%B3%BB%E7%BB%9F%E5%BF%99%2C%E8%AF%B7%E7%A8%8D%E5%80%99%E9%87%8D%E8%AF%95%E3%80%82');
    var GET_VOD_RTSP_ADDR_ERROR = decodeURIComponent('%E8%8E%B7%E5%8F%96%E7%82%B9%E6%92%AD%E5%9C%B0%E5%9D%80%E5%A4%B1%E8%B4%A5%EF%BC%9A');
    var STATIC_SUCCESS_STR = decodeURIComponent('%E6%88%90%E5%8A%9F');
    var STATIC_FAIL_STR = decodeURIComponent('%E5%A4%B1%E8%B4%A5');
    var TECH_SERVE_STR = decodeURIComponent('%E8%AF%B7%E4%B8%8E%E6%8A%80%E6%9C%AF%E4%BA%BA%E5%91%98%E8%81%94%E7%B3%BB%EF%BC%81');
    win.navigator = win.navigator || {};
    win.navigator.appName = win.navigator.appName || 'computer';

    win.isP60 = typeof sysmisc != 'undefined';
    win.isComputer = typeof sysmisc == 'undefined' && typeof iPanel == 'undefined';
    win.IPTV = typeof iPanelJavaInspector != 'undefined';
    win.HD30 = typeof iPanel != 'undefined' && typeof iPanel.eventFrame.systemId == 'undefined' && typeof iPanelJavaInspector == 'undefined';
    win.isGW = typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 2;
    win.isP30 = typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 1;
    win.debug = function(){
        var message = 'COMMONJS :';
        for( var i = 0; i < arguments.length ; i ++ ) message += String( arguments[i] );
        if( link.query('debug') != '' ){
            if ( win.isP60 ){
                sysmisc.showToast(message);
            } else if( win.isComputer || win.IPTV ){
                console.log(message);
            } else {
                alert(message);
            }
        } else {
            if( typeof console != 'undefined' ) {
                console.log ( message );
            } else {
                iPanel.debug( message );
            }
        }
    };
    win.handlers = function (event) {
        win.debug('=======>>>>> OnKeydown :', event.keyCode, ' <<<<<=======');
        switch (event.keyCode) {
            case 19:                                    //P60 �е� ��
            case 38: cursor.call('onMoveUp'); break;    //�Ϲ���
            case 20:                                    //P60 �е� ��
            case 40: cursor.call('onMoveDown'); break;  //�¹���
            case 21:                                    //P60 �е� ��
            case 37: cursor.call('onMoveLeft'); break;  //�����
            case 22:                                    //P60 �е� ��
            case 39: cursor.call('onMoveRight'); break; //�ҹ���
            case 33: cursor.call('onPageUp'); break;    //PageUp
            case 34: cursor.call('onPageDown'); break;  //PageDown
            case 66:                                    //P60 �е� OK
            case 13: cursor.call('select'); break;      //ѡ��س���
            case 4:                                     //P60 �еķ���
            case 8:                                     // Backspace ��ִ�з���
            case 46: cursor.call('goBack'); break;      //DEL ���˳�
            case 36:
            case 458: cursor.call('goHome'); break;     //HOME ��ִ�� HOME ����
            case 13001:                                 //IPTV, ready�����ò��ŵ�ַ�����Ϣ����
                if( typeof player.instance != 'undefined' )
                    player.instance.play( 2 );
                break;
            case 13003:                                 //���ųɹ�
                cursor.call('play');
                break;
            case 13015:                                 //�������
                player.exit();
                cursor.call('nextVideo');
                break;
            default:
                var code = event.keyCode;
                if (code >= 48 && code <= 57) {    //��������ּ�,ִ�����빦��.
                    var ch = String.fromCharCode(code);
                    cursor.call("input", ch);
                }
                break;
        }
        event.preventDefault();
        return false;
    };
    if (typeof iPanel === 'undefined') {
        document.onkeydown = win.handlers;
        //�����¼�,ģ������в��Ų���.
        document.addEventListener('iPanelEvent', function (e) {
            //����ͨ�� e.detail ���ݹ���.
            var args = e.detail;
            if (typeof  args === 'undefined') return;
            switch (args.code) {
                //������ŵ�ַ�����سɹ���������Ƶ��
                case 'VOD_PREPAREPLAY_SUCCESS':
                    media.AV.play();
                    break;
                //���������ɣ�������һ��
                case 'EIS_VOD_PROGRAM_END':
                    cursor.call('nextVideo');
                    break;
                //ҳ��������
                case 'EIS_MISC_HTML_OPEN_FINISHED':
                    cursor.call('htmlOpenFinished');
                    break;
                default:
                    break;
            }
        });
        win.iPanel = {
            isComputer: true,
            eventFrame: {
                portal_url: undefined,
                initPage: function (o) {},
                /**
                 * �˷��������������3.0���Ӿ���ʹ��
                 */
                exitToHomePage: function () {
                    //�����P60������ exitToHomePage ��������ִ�д˺���ʱ��ʵ�ʵ��� finish ����
                    if( win.isP60 ) {
                        sysmisc.finish();
                    }
                },
                ServiceGroupID:'',
                netType:''
            },
            getGlobalVar: function (name) {
                try {
                    var __arr, reg = new RegExp('(^| )' + name + '=([^;]*)(;|$)');
                    if( __arr = document.cookie.match(reg) ){
                        return unescape(__arr[2]);
                    }
                } catch (e) {}
                return '';
            },
            setGlobalVar: function (name, value) {
                try {
                    var day = 30,date = new Date();
                    date.setTime(date.getTime() + day * 24 * 60 * 60 * 1000);
                    document.cookie = name + "=" + escape(value) + ";expires=" + date.toGMTString();
                } catch (e) {}
            },
            /**
             * @param cmd "startAPK"
             * @param value "����,����,����1###����1��ֵ###����2###����2��ֵ......###����N###����N��ֵ"
             */
            IOControlWrite: function(cmd, value){},
            ioctlRead:function(){return false;},
            debug: function (message) {
                console.log(message);
            }
        };
        win.media = {
            AV: {
                type: undefined,
                open: function (url, type) {
                    media.AV.type = type;
                    win.debug('iPanel play prepared (' + type + '):' + url);
                    //�������ŵ�ַ���سɹ��¼�
                    cursor.fireEvent('VOD_PREPAREPLAY_SUCCESS');
                },
                play: function () {
                    //����򿪵����� VOD, 15��󴥷���������¼�
                    if (media.AV.type === 'VOD') {
                        (function (duration) {
                            media.AV.duration = duration = duration / 1000;
                            var elapsed = 0;
                            if (!media.AV.timer) {
                                media.AV.timer = setInterval(function () {
                                    elapsed++;
                                    if (elapsed >= duration) {
                                        clearInterval(media.AV.timer);
                                        cursor.fireEvent('EIS_VOD_PROGRAM_END');
                                        media.AV.elapsed = elapsed = 0;
                                        media.AV.timer = undefined;
                                        return;
                                    }
                                    media.AV.elapsed = elapsed;
                                }, 1000);
                            }
                        })(60 * 1000 * 1);
                    }
                },                                //����ͣ��resume ʱ��ʵ����ִ�� play �ȿ�.
                pause: function () {},            //��ͣ
                close: function () {},
                elapsed: 20,                      //����ʱ��
                duration: 100,                    //��ʱ��
                backward: function (speed) {},    //����
                forward: function (speed) {},     //���
                seek: function(time){}            //ʱ���ʽΪHH:mm:ss��ʽ
            },
            picture: {alpha: 80},
            video: {
                setPosition: function (left, top, width, height) {},   //С������
                fullScreen: function () {},                        //ȫ������
            },
            sound: {
                up : function() {},
                down : function() {},
                resume : function() {},
                mute : function() {}
            }
        };
        win.DVB = {
            playAV: function (frequey, serviceId) {},
            stopAV: function () {}
        };
        win.iPanelGatewayHelper = win.iPanelGatewayHelper || {
            //TODO: ȱ�ٻ�ȡ groupId �� netType ��������
            getCaCard: function () { return '9950000001424641'; },
            playLive: function (serviceId, isHideChannel) {}, //����ֱ��Ƶ����serviceId ���ַ������ͣ�isHideChannel �Ƿ�����Ƶ����
            play: function (vodId) {},
            getPlayUrl: function (vodId /*String �ַ�������*/) {
                //ͨ��������ƻ�ΪӰƬid��ȡ��ӦӰƬ�Ĳ��ŵ�ַ
                //Js����iPanelGatewayHelper.getPlayUrl("123456");��
                //iPanelGatewayHelper.getPlayUrl("ObjectID@VODItem:123456_0");
                //�ɹ����� playUrl String   ӰƬ�Ĳ��ŵ�ַ
            },
            getEPGServerUrl: function () {},                    //win.EPGUrl = iPanel.eventFrame.pre_epg_url;
            getEPGServerCookie: function () {},                 //��ȡ��ΪEPG������Cookie�����̵߳��ÿ��ܻ���������������߳��е��ã�
            launchApk: function (
                pkg, /*String   Ҫ����Ӧ�õİ���*/
                cls, /*String Ҫ����Ӧ�õ�����*/
                params  /*String Ҫ��������Ӧ�õĲ�������ʽ:key1;value1;key2;value2������Ҫ�������ʱ��''����*/
            ) {},
            getInnerVodId: function (vodId) {
                //ͨ������ĵ�ַ���԰�VOD���ⲿIDת�����ڲ�ID
                var url = this.getEPGServerUrl() + 'jsp/defaultHD/en/getContentId.jsp?vodId=' + vodId;
            }
        };
        win.E = {is_HD_vod: true};
    };
    if(typeof iPanelJavaInspector === 'undefined' ) {
        win.iPanelJavaInspector = {};
        if( typeof hardware === 'undefined' ) {
            hardware = {
                STB: {
                    serialNumber : '9950000001424641',
                    sVersion : '',                      //����汾
                    hVersion : '',                      //Ӳ���汾
                }
            }
        }
        if( typeof network === 'undefined') {
            network = {
                IPAddress : '',
                MACAddress : ''
            }
        }
        if( typeof iPanel.getVSP === 'undefined' ) {
            iPanel.getVSP = function(){};
            iPanel.getVodAuthObject = function(){
                //��ȡ�����ļ���ַ
                //var region_code = tmpObj.region_code;  //���ص�ַ
                //var region_name = tmpObj.region_name;  //��������
                //var street_code = tmpObj.street_code;  //�����ַ
                //var street_name = tmpObj.street_name;  //��������
                //var community_code = tmpObj.community_code;  //������ַ
                //var community_name = tmpObj.community_name;  //��������
                //var village_code = tmpObj.village_code;      //С����ַ
                //var village_name = tmpObj.village_name;      //С������
            };
            iPanel.openMediaDetail = function(id,column_id){}  //ý��id���ݹ涨ֻ���ջ�Ϊ�ⲿ id,  ��Ŀid���粻��Ĭ�ϡ�-1��
            iPanel.openMediaPlay = function(id, column_id, extras,extrasType){
                //ӰƬ��תͳһ�����������õ㲥��Ȩ���Կ����ܡ�
                //flagType     0��ʹ��AAA ��Ȩ,  1��ʹ�� VOD ��Ȩ
                //playType     1����Ӱ��2���缯
                //isOutId      true���ⲿid��false�� �ڲ� id
                //baseFlag     0�����£�1�����ε㲥��2�����ε�+���£�Ϊ0����ͳһ���������̣�Ϊ1�� 2ʱ��ԭ���ε㲥�������̣���3����ѣ�4������ȯ���� ��ȯ����Ȩ��
                //items        ��ʼ���ŵļ�������ӰĬ��Ϊ1
                //initSeek     ��ʼ���ŵĺ�����������30000
                //isPush       ���д�initSeek ʱ���̶�Ϊtrue
                //previewFlag  �Ƿ�֧��Ԥ����0��֧�֣�1֧��
                //previewTime  ��playType Ϊ1����Ƶʱ���� previewtime ����Ԥ��ʱ��
                //previewItem  ��Ԥ���ļ�������playType Ϊ2 �缯ʱ ���� previewitem�����Ԥ���ļ���������֧��Ԥ ��1~5��������д5�����Ŵ��ڸü���ʱ��� �ݼ�Ȩ�����������������������ţ�
                //orderProduct ��Ҫ�����Ĳ�ƷID��ͳһ����ҳ���ã�
                //authProduct  ��Ҫ��Ȩ�Ĳ�ƷID��AAA ��Ȩ�ã�
                //spCode       AAA ��Ȩ��
                //appCode      AAA ��Ȩ��
                //appKey       AAA ��¼�ã�signature= ��spCode+appCode+userNo+password+ appKey��,��˵������˳��32λ MD5����
                //appId        ͳһ����ҳ����
                //sessionId    spCode+{���ź�4 λ}+{yymmddHHmiss}+{3 λ�����}
            }
            iPanel.openLivePlay = function (type, channel) {
                //type     6��Ƶ�� id����ΪƵ��id����2��Ƶ���ţ�3��Ƶ������
                //channel  Ƶ������
                //iPanel.openLivePlay(6, "10058");
                //iPanel.openLivePlay(2, "1");
                //iPanel.openLivePlay(3, "�㽭����");
            }
            iPanel.openTimeShift = function(type, channel){
                //type     6��Ƶ�� id����ΪƵ��id����2��Ƶ���ţ�3��Ƶ������
                //channel  Ƶ������
                //iPanel.openLivePlay(6, "10058");
                //iPanel.openLivePlay(2, "1");
                //iPanel.openLivePlay(3, "�㽭����");
            }
            iPanel.misc = {
                goBackApp : function () { },                     //�ر�����������ϼ�apk
                startOtherApp : function (name, extras) {
                    //name  ֧��"����"��"����/����"��ʽ
                    //name  ��չ������json����(ֵ֧���ַ��������ͣ�booleanֵ)
                    //iPanel.misc.startOtherApp("com.ipanel.test/com.ipanel.test.TestActivity",{"startMo de":"background","duration":100});
                }
            }
        }
        if( typeof win.MediaPlayer === 'undefined' ) {
            win.MediaPlayer = {
                getPlayerInstanceID : function() { },
                unbindPlayerInstance: function(instanceId){ },                  //�˳�����ҳ��ʱֹͣ�����
                bindPlayerInstance : function(instanceId){ },
                setVideoDisplayMode : function( mode ){ },                      //0:ʹ�����ô��ڲ�����1:ʹ��Ĭ��ȫ����С
                setVideoDisplayArea : function ( left,top,width,height ) { },
                refresh : function () { },                                      //ʹ���ò�����Ч
                setMediaSource : function ( playUrl ) { },                      //���ŵ�ַ
                stop : function(){ },
                play : function(){ },
                pause : function(){ }

                /*
                var mp = new MediaPlayer();
                var instanceId = mp.getPlayerInstanceID();
                mp.bindPlayerInstance(instanceId);
                mp.setVideoDisplayMode(0);
                mp.setVideoDisplayArea(0, 0, 700, 500);//left,top,width,height
                mp.refresh();//ʹ���ò�����Ч
                var playUrl = 'igmp://234.5.1.6:12345';//��ȡ�������½ڻ�ȡ��Ϊ�㲥��ַ����
                mp.setMediaSource(playUrl);
                */
            }

            //��Ϊ�㲥��Ȩ��ȡ���ŵ�ַ����
            //epgUrl +"/VSP/V3/PlayVOD";
            //��ȡ��Ϊý�� id����Ϊ��Ȩ�ӿ���Ҫʹ��
            //epgUrl +"/VSP/V3/QueryVOD";

        }
    } else {
        document.onkeydown = document.onirkeypress = document.onsystemevent = win.handlers;
    }
    win.link = win.link || location.href;
    /*�����е�MAC��ַ*/
    win.iPanel.MAC = (function() {
        var defaultMac = '00:00:00:00:00:00';
        if ( win.HD30 || win.isP30 ) return iPanel.ioctlRead("NTID") || network.ethernets[0].MACAddress;
        if ( win.isP60 )  return sysmisc.getMac();              //P60����
        if ( win.isGW ) return defaultMac;                      //����
        if ( win.IPTV ) return network.MACAddress;              //IPTV
        return defaultMac;
    })();
    /*�����е�IP��ַ*/
    win.iPanel.IpAddress = (function() {
        var defaultIp = '0.0.0.0';
        if ( win.HD30 || win.isP30 ) return iPanel.ioctlRead("IP") || network.ethernets[0].IPs[0].address;
        if ( win.isP60 )  return sysmisc.getEnv("dhcp.eth0.ipaddress",defaultIp);       //P60����
        if ( win.isGW ) return defaultIp;                                                   //����
        if ( win.IPTV ) return  network.IPAddress;                                          //IPTV
        return defaultIp;
    })();
    /*�����е����к�*/
    win.iPanel.cardId = (function() {
        if ( win.HD30 || win.isP30 ) return iPanel.ioctlRead("ICID") || CA.card.cardId;
        if ( win.isP60 )  return sysmisc.getSn();               //P60����
        if ( win.isGW ) return '';                              //����
        if ( win.IPTV ) return hardware.STB.serialNumber;       //IPTV������û�е�����ȡ���кŵĽӿڣ�����ֱ���û����п��Ŵ��档
        return "";
    })();
    /*�����еĿ���*/
    win.iPanel.serialNumber = (function() {
        if ( win.HD30 || win.isP30 ) return CA.card.serialNumber;
        if ( win.isP60 )  return sysmisc.getEnv('persist.sys.CARDID', sysmisc.getChipId());//P60����
        if ( win.isGW ) return iPanelGatewayHelper.getCaCard(); //����
        if ( win.IPTV ) return hardware.STB.serialNumber;       //IPTV������
        return "9950000001424641";
    })();
    /*�����п��ŵ�GroupId*/
    win.iPanel.groupId = (function() {
        var defaultGroupId = '32768';
        if ( win.HD30 || win.isP30 ) return iPanel.eventFrame.ServiceGroupID;
        if ( win.isP60 )  return sysmisc.getEnv('service.group.id', defaultGroupId );//P60����
        if ( win.isGW ) return defaultGroupId; //����
        if ( win.IPTV ) return '';
        return defaultGroupId;
    })();
    /*�����е�netType*/
    win.iPanel.netType = (function() {
        var defaultNetType = 'Cable';
        if ( win.HD30 || win.isP30 ) return iPanel.eventFrame.netType;
        if ( win.isP60 )  return defaultNetType;//P60����
        if ( win.isGW ) return defaultNetType;  //����
        if ( win.IPTV ) return '';
        return defaultNetType;
    })();
    win.iPanel.HD30Adv = typeof navigator != 'undefined' && typeof navigator.userAgent == 'string' && navigator.userAgent.indexOf('3.0 Advanced') > 0;
    win.iPanel.mediaType = (function(){
        if( win.HD30 ) return win.iPanel.HD30Adv ? 'NEW30' : 'HD30';
        if( win.isP30 ) return 'P30';
        if( win.isGW ) return 'GW';
        if( win.isP60 ) return 'P60';
        if( win.IPTV ) return 'IPTV';
        if( win.isComputer ) return 'PC';
        return 'HD30';
    })();
    win.debug('location.href =======>>>>>> (', win.link, ', serialNumber :', win.iPanel.serialNumber , ')  <<<<<=======' );
    win.query = function(key){return win.link.query(key);};
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
    var evalJS = function(func, strJS, option){
        var isJSON = option.eval;
        if( typeof isJSON == 'undefined' || isJSON == true ) {
            if( /^\s*\<html\>/g.test(strJS) ) { if( option.fail != 'function' ) { tooltip( SYSTEM_BUSY_RETRY_LATER ); return ;} return option.fail( { msg: err }); }
            try {
                debug('AJAX =======>>>>>> [[[ >>>>', ( win.isComputer || win.IPTV ? strJS : ' BEGIN RUNNING evalJS(...)' ), ' ]]]');
                if( strJS.substr(0,1) != '('  || strJS.substr(strJS.length - 1, 1) != ')' ) strJS = "(" + strJS + ")";
                func( eval( strJS ) );
            } catch (e) {
                var err = decodeURIComponent('%E6%9C%8D%E5%8A%A1%E5%99%A8%E8%BF%94%E5%9B%9E%E6%95%B0%E6%8D%AE%E5%87%BA%E7%8E%B0%E6%9C%AA%E7%9F%A5%E9%94%99%E8%AF%AF%EF%BC%8C%E6%9C%AA%E8%83%BD%E6%88%90%E5%8A%9F%E8%A7%A3%E6%9E%90%EF%BC%8C%E8%AF%B7%E8%BF%94%E5%9B%9E%E5%90%8E%E5%86%8D%E8%AF%95%EF%BC%81');
                debug(err, e);
                if( typeof option.fail == 'function' ) option.fail( { msg: err } );
            }
            debug('AJAX <<<<<<======= [[[ END RUNNING evalJS(...) ]]]');
        } else {
            func( strJS );
        }
    };
    var AJAX_TIMEOUT = 5000;
    var timerAjax = undefined;
    /**
     * options��,headers ��ʽΪ:[{key:value},{key:value}]
     * options��,��methodΪPOSTʱ, data ��ʽΪJSON��ʽ.
     */
    var _ajax = function (url, callback, option) {
        if (typeof  url === 'undefined') return;
        option = option || {};
        var _options = {
            method: 'GET',
            eval: true,             //�Ƿ�Է��ؽ�����м���ȡֵ
            sync: true,
            charset: 'utf-8',       //�������,Ĭ��Ϊutf-8
            timeout: AJAX_TIMEOUT,          //���ó�ʱ 2 ��
            frequency: undefined,   //����Ƶ��
            headers: undefined,     //����ͷ, ��ʽΪ[{key:value},{key:value}]
            username: undefined,
            password: undefined
        };

        for (var name in _options) if(typeof option[name] == 'undefined' ) option[name] = _options[name];
        var headers = option.headers || [ {"key": "Content-Type", "value": "text/plain;charset=" + option.charset} ];

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
                    } catch (exception) { }
                }
            }
            return xhr;
        };
        var request = createXmlHttpRequest();
        request.onreadystatechange = function () {
            var state = request.readyState;
            var status = request.status;
            if (state <= 2) {
                win.debug("AJAX STATE CHANGED : " + state + ", STATUS :" + status + "!");
            } else if (state === 3) {
                if (status == 401) {
                    win.debug("AJAX AUTHENTICATION FAILED, NEED CORRECT USERNAME AND PASSWORD !"); return;
                }
                win.debug("AJAX STATE CHANGED : " + state + ", STATUS :" + status + "!");
            } else if (state === 4) {
                if( timerAjax ) { clearTimeout(timerAjax); timerAjax = undefined; }
                //HTTP 204(no content)    ��ʾ��Ӧִ�гɹ�����û�����ݷ��أ����������ˢ�£����õ�����ҳ�档
                //HTTP 205(reset content) ��ʾ��Ӧִ�гɹ�������ҳ�棨Form�����������û��´����롣
                if (status === 200 || status == 204) {
                    var responseText = request.responseText;
                    if (typeof callback === 'function') {
                        evalJS(callback, request.responseText, option );
                    } else {
                        win.debug("AJAX SUCCESS : " + responseText);
                    }
                } else {
                    win.debug("AJAX STATE WITH 4, BUT STATUS IS : " + status);
                }
            }
        };
        if( win.isComputer ) {
            request.withCredentials = true;
            url = buildUrlMark(url) + 'ISPCDBG=1&DBGHOST=' + encodeURIComponent(location.origin);
        }
        request.open(option.method, url, option.sync, typeof option.username !== 'undefined' ? option.username : null, typeof  option.password !== 'undefined' ? option.password : null);
        request.timeout = option.timeout;
        request.ontimeout = function ( e ) {
            request.abort();
            if( timerAjax ) { clearTimeout(timerAjax); timerAjax = undefined; }
            if (typeof option.fail === 'function') option.fail( { error: e, stack: 'FAIL: ON TIMEOUT INNER' } );
            debug("AJAX REQUEST TIMEOUT !");
        };
        request.onload = function(e){ debug("AJAX ONLOAD EVENT ===>", e); };
        request.onerror = function(e){ if( timerAjax ) { clearTimeout(timerAjax); timerAjax = undefined; } if (typeof option.fail === 'function') option.fail(  { error: e, stack: 'FAIL: ON ERROR' }  ); debug("AJAX ERROR EVENT ===>", e); };
        for (var i = 0; i < headers.length; i++) {
            var header = headers[i];
            request.setRequestHeader(header.key, header.value);
        }
        var data = option.data || null;
        request.send(data);
    };
    win.tooltip = win.tooltip || function() {
        var args = arguments;
        var lisp = function(){ var msg = '';for( var i = 0; i < args.length ; i ++ ) msg += String( args[i] ); return msg; };
        var message = typeof args == 'undefined' || args.length == 0 ? decodeURIComponent(GET_VOD_RTSP_ADDR_ERROR) : lisp();
        if( win.isP60 ) sysmisc.showToast(message);
        else if( win.IPTV || iPanel.HD30Adv ) {
            var element = $("tooltipDivId");
            if(!element) {
                element = document.createElement("div");// ���ò��ɼ�, �����display:none���޷�ȡ����
                element.style.width = "640px";
                element.style.height = "360px";
                element.style.left = "320px";
                element.style.top = "180px";
                element.style.position = "absolute";
                element.style.zIndex = "9999";
                element.style.visibility = element.style.overflow = "hidden";
                element.style.backgroundColor = "black";
                element.style.color = "white";
                element.style.fontSize = '22px';
                element.innerHTML = message;
                document.body.appendChild( element )
            } else {
                element.style.visibility = 'visible';
                element.innerHTML = message;
            }
        } else if( win.isGW ) iPanel.debug(message);
        else setTimeout(function(){alert(message);},500);
    };
    //�����3.0 ���������ն˴˲���һ������, ������ػ�P60���ߵ����򲻴��ڴ˲���
    //����ǵ��Ի���P60, ��ǰ���ѳ�ʼ��iPanel
    win.EPGUrl = win.EPGUrl || iPanel.eventFrame.pre_epg_url || (( win.isP60 ? ( ( win.address = ( win.address || sysmisc.getEnv('epg_address','') ) ) + '/EPG/' ) : ( iPanel.isComputer || iPanel.eventFrame.systemId !== 2 ? "http://192.168.14.102:8082/EPG/" : iPanelGatewayHelper.getEPGServerUrl() ) ) + 'jsp');
    win.debug( "media Type:" , iPanel.mediaType,", EPGUrl ====>>> ", win.EPGUrl );
    if( win.isP60 || win.isComputer || win.IPTV ) {
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
        if( !win.IPTV ){
            var AndroidHtml5 = {
                idCounter: 0, // �������м�����
                OUTPUT_RESULTS: {}, // ����Ľ��
                CALLBACK_SUCCESS: {}, // ����Ľ���ɹ�ʱ���õķ���
                CALLBACK_FAIL: {}, // ����Ľ��ʧ��ʱ���õķ���
                callNative: function (cmd, type,args, success, fail) {
                    var key = "ID_" + (++this.idCounter);
                    win.debug("cmd:" + JSON.stringify(cmd));

                    if (typeof success != 'undefined') {
                        AndroidHtml5.CALLBACK_SUCCESS[key] = success;
                    } else {
                        AndroidHtml5.CALLBACK_SUCCESS[key] = function (result) {};
                    }

                    if (typeof fail != 'undefined') {
                        AndroidHtml5.CALLBACK_FAIL[key] = function(e){ fail({error: e, stack : 'FAIL: ON callNative'}); };
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
                        AndroidHtml5.CALLBACK_FAIL[key] = function(e){ fail({error: e, stack : 'FAIL: ON callWebService'}); };
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
                            if (typeof this.CALLBACK_SUCCESS[key] != 'undefined') {
                                //setTimeout("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']("+result.message+")", 0);
                                AndroidHtml5.CALLBACK_SUCCESS[key](result.message);
                            }
                        } else {
                            if (typeof this.CALLBACK_FAIL != 'undefined') {
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
                            if (typeof this.CALLBACK_SUCCESS[key] != 'undefined') {
                                setTimeout("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']('" + message + "')", 0);
                            }
                        } else {
                            if (typeof this.CALLBACK_FAIL != 'undefined') {
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
                        if (typeof this.CALLBACK_SUCCESS[key] != 'undefined') {
                            win.debug(typeof("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']('" + result + "')"));
                            setTimeout("AndroidHtml5.CALLBACK_SUCCESS['" + key + "']('" + result + "')",0);
                        }
                    } else {
                        if (typeof this.CALLBACK_FAIL != 'undefined') {
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
                if(arguments.length < 4){/*���ݾɴ��θ�ʽurl,success,body*/
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
                if(arguments.length < 4){/*���ݾɴ��θ�ʽurl,success,body*/
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
                exec_asyn("request","","string",o, success || function(){
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
                     * @param x ���������Ͻǵ�x���꣬��ֵΪ�����������Ļ��ȵİٷֱȣ���ȷ��С�� ���3λ
                     * @param y
                     * @param width �������Ŀ�ȣ���ֵΪ�����������Ļ��ȵİٷֱȣ���ȷ��С�����3λ
                     * @param heigh
                     */
                    create: function(x, y, width, heigh) {return 1;},
                    stop: function( playerId ){},
                    destroy : function (playerId) {},
                    /**
                     * 0 ��������δ�������ͷ�
                     * 1 �������Ѵ���
                     * 2 ��������ʼ����
                     * 3 ��������ͣ
                     * 4 ����������
                     * 5 ������ֹͣ
                     * 6 ���������
                     * 7 ����������
                     * @param playerId
                     */
                    getState: function (playerId) {},
                    resize: function (playerId,x, y, width, heigh) {}
                };
                /**
                 * @param playerId
                 * @param url ���Ŵ�
                 * @param seekTime ӰƬ���ŵ���ʼλ�ã���λΪ�룬��С��ӰƬ��ʼλ��0��ʼ����,ʱ ���Լ�ͨ�����봫"0"
                 */
                win.mixplayer.playUrl = function(playerId, url,seekTime) {};
                win.mixplayer.pause = function(playerId){}; //0 �ɹ���-1 ʧ��
                win.mixplayer.getCurrent = function(playerId){return 0;}; //��ȡ��ǰ����λ�ã�����Ϊ��λ
                win.mixplayer.seekTo = function(playerId,seconds){return 0;}; //��תָ������λ�ý��в���,����Ϊ��λ��0 �ɹ�, -1 ʧ��
                win.mixplayer.resume = function(playerId){return 0;}; //�ָ����� 0 �ɹ�, -1 ʧ��
                win.mixplayer.scale = function(playerId,scale){return 0;}; //����ָ�����ٲ���, �������ɹ��� -1��ʧ��
                win.mixplayer.getDuration = function(playerId){return 0;}; //�õ���ǰ����ƬԴ��ʱ��
                win.mixplayer.voiceDown = function(){}; //��������
                win.mixplayer.voiceUp = function(){}; //��������
                win.mixplayer.getMaxVoice = function(){return 100;}; //��ȡϵͳ�������ֵ
                win.mixplayer.getCurrentVoice = function(){return 30;}; //��ȡϵͳ��ǰ����ֵ
                win.mixplayer.getAutoMode = function(){}; //��ȡ��ǰϵͳ����ģʽ 0 ��������1 ��������2 ��������3 �����
                win.mixplayer.setAutoMode = function(mode){}; //���õ�ǰϵͳ����ģʽ 0 ��������1 ��������2 ��������3 �����
                win.mixplayer.setStopMode = function(mode){};
                /**
                 * @returns 0 �ɹ�, -1 ʧ��
                 */
                win.dvbplayer.playElements = function(playerId, transportId, serviceId, networkId){return 0;};
                /**
                 * @param dvbUrl dvbelement://706000.6875.64.8.0.0.0.0.0.0
                 * ��ϸ˵��:"dvbelement://" +Frequency + "." + SymbolRate + "." + Modulation + "." + serviceid+ "." + pmtpid + "." +pcrpid + ". " + VideoType" + "." + "VideoPID" + "." + "AudioType" + "." + "AudioPID"
                 * Frequency ΪƵ ��Ƶ�ʣ���λΪMHz;  ���� KHz
                 * SymbolRate Ϊ�����ʣ���λΪK, Symbol/s, ����0��ϵͳȡĬ��ֵΪ6875;
                 * Modulation Ϊ ���Ʒ�ʽ������0��ϵͳȡĬ��ֵ64QAM;
                 * serviceid Ϊҵ��ID��;
                 * pmtpid Ϊ PMT PID ,����0��Ĭ�϶�Ӧserviceid ��PMT PID;
                 * pcrpidΪ PCR PID ,����0��Ĭ�϶�Ӧserviceid��PCR PID;
                 * VideoType Ϊ��Ƶ���ͣ�����0��ϵͳĬ��ȡ��ҵ����PIDֵ��С����Ƶ�����͡������ҵ��Ϊ����Ƶҵ�񣬸�ֵΪ-1;
                 * VideoPID Ϊ��ƵPID,����0��ϵͳĬ�� ȡ��ҵ����PIDֵ��С����Ƶ���������ҵ��Ϊ����Ƶҵ�񣬸�ֵΪ-1;
                 * AudioType Ϊ��Ƶ���ͣ�����0��ϵͳĬ�� ȡ��ҵ����PIDֵ��С����Ƶ����
                 * AudioPID Ϊ��ƵPID������0��ϵͳĬ��ȡ��ҵ����PIDֵ��С����Ƶ����
                 * @returns 0 �ɹ�, -1 ʧ��
                 */
                win.dvbplayer.playFrequency = function(dvbUrl){return 0;};
            }
        }
    }
    if( typeof sysmisc == 'undefined' ) {
        win.sysmisc = {
            isComputer : true,
            getSn : function(){},
            getChipId : function(){},
            getSoftVersion : function() {},
            getHardVersion : function() {},
            runCommand : function(cmd){},
            getMac : function(){},
            //������Ҫ��ʾ����ǰ��ͼ��,videoΪ��Ƶ�㣬����Ϊweb��
            bringToForeground : function(type){},
            finish : function(){},
            getEnv : function(key,defVal){},
            path_back : function() {},
            object_save : function(search, url) {},
            path_sav : function (data) {},
            showToast : function(message){}
        };
    }
    win.ajax = function(url, callback, option) {
        option = option || {};
        try {
            if( typeof option.eval == 'unefined' ) option.eval = true;
            if( typeof option.json == 'unefined' ) option.json = true;
            if( typeof option.method == 'unefined' ) option.method = 'post';
            if( iPanel.mediaType == 'P60' && !url.startWith("/") )
            {
                var cookie = url.startWith( win.EPGUrl ) ? ('[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid','') + '"}]') : '';
                win.debug("AJAX -> " + url );
                var method = option.method || 'post';
                bridge.ajax(method, url, 'text/xml', cookie, null, function(rst){
                    win.debug('=======>>>>> Bridge ajax success <<<<<=======');
                    if( timerAjax ) { clearTimeout(timerAjax); timerAjax = undefined; }
                    if (typeof callback === 'function') {
                        evalJS(callback, rst, option);
                    }
                }, function(e){
                    if( timerAjax ) { clearTimeout(timerAjax); timerAjax = undefined; }
                    if (typeof option.fail === 'function') option.fail( { error: e, stack: 'FAIL: ON FAIL' } );
                    win.debug("Bridge ajax ERROR: " + e);
                });
            } else {
                win.debug("AJAX -> " + url );
                _ajax(url, callback, option);
            }
            if( isComputer || typeof option.fail == 'undefined' ) return;
            timerAjax = setTimeout(function(){ option.fail( { stack:'FAIL: ON TIMEOUT' } ); }, AJAX_TIMEOUT);
        } catch (e) {
            if( typeof option.fail != 'undefined' ) option.fail( { error: e,  stack:'THROW ON ERROR��' } );
        }
    };
    /*�˺�������Ҫ�����ò�ͬ��ʽ�������ݣ����ؽ��Ϊwindow.lazyLoadData*/
    win.loadData = function(url, callback, option){
        if( typeof url != 'string' ) return;
        option = option || { isScript : false};
        win.lazyLoadData = undefined;
        if( url.startWith(win.EPGUrl + '/neirong/player/detail.jsp') || option.isScript ){
            rst = { code: -1, success: false };
            var lazy = function (t) {
                if (typeof win.lazyLoadData === 'undefined') {
                    if ( t >= 5000 ) { // ��ʱʱ��5����
                        rst.msg =  decodeURIComponent('%E8%AF%B7%E6%B1%82%E6%95%B0%E6%8D%AE%E5%87%BA%E9%94%99%EF%BC%9A%E6%9C%8D%E5%8A%A1%E5%99%A8%E6%9C%AA%E5%9C%A8%E8%A7%84%E5%AE%9A%E7%9A%84%E6%97%B6%E9%97%B4%E5%86%85%E8%BF%94%E5%9B%9E%E6%95%B0%E6%8D%AE%EF%BC%8C%E8%AF%B7%E8%BF%94%E5%9B%9E%E5%90%8E%E5%86%8D%E8%AF%95%EF%BC%81');
                        if( typeof option.fail === 'function') return option.fail(rst);
                        if( typeof callback === 'function' ) return callback( rst );
                        return;
                    }
                    return setTimeout(function () { lazy( t + 50 ); }, 50);
                }
                if( typeof callback != 'function' ) return ;
                rst.success = typeof win.lazyLoadData['success'] != 'undefined' ? win.lazyLoadData['success'] : true; rst.code = 200;
                rst.code = typeof win.lazyLoadData['code'] != 'undefined' ? win.lazyLoadData['code'] : 200;
                rst.data = typeof win.lazyLoadData['data'] != 'undefined' ? win.lazyLoadData['data'] : win.lazyLoadData;
                callback( rst );
                win.lazyLoadData = undefined;
            };
            if( win.isP30 || win.HD30 ) {
                url += '&script=1';  win.appendJS(url);
            } else {
                win.ajax(url, function(rst){ win.lazyLoadData = rst; }, option);
            }
            setTimeout(function(){ lazy(0); }, 50);
            return;
        }
        win.ajax(url, callback, option );
    };
    win.buildUrlMark = function( str , refer ) {
        refer = refer || str;
        return str += refer.indexOf('?') > 0 ? '&' : '?';
    };
    /**
     * �� ������ ת���� hh:MM:ss ��ʽ
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
    var time_to_sec = function (time) {
        if( ! /^[:\d]+$/gi.test( time ) ) return 0;
        var parts = time.split(':');
        if( parts.length == 1 ) return parseInt( parts[0] );
        if( parts.length == 2 ) return parseInt( parts[0] )*60 + parseInt( parts[1] );
        return parseInt( parts[0] ) * 3600 + parseInt( parts[1] ) * 60 + parseInt( parts[2] );
    };
    win.buildPlayStartTime = function(o ){
        if( typeof o.startTime === 'undefined' || o.startTime == null ) return 0;
        if( typeof o.startTime === 'number' ) return o.startTime;
        if( typeof o.startTime === 'string' ) return time_to_sec( o.startTime );
        return 0;
    };
    win.convertVodId = function( id, callback ){
        ajax(win.EPGUrl + '/neirong/player/detail.jsp?id=' + id, function(rst){
            if(typeof callback != 'function') return;
            callback(rst);
        });
    };
    /**
     *  cursor.saveCurr, �ɱ�����,������.
     *  cursor.parseCurr, ���¸�ֵ����,������, �����¸�ֵ����ʱ�п���ͨ��AJAX����������ɺ����,���Դ˺���û���Զ�����.
     */
    var Cursor = function (params) {
        //������ʱ練�����
        this.consigned = undefined;
        this.blocked = 0;
        //��¼��ҳ��ֿ�����
        this.focusable = [];
        //�����ٶȣ�Ĭ��Ϊ�����ٶȣ���Ϊ����ʱ��ʾ���ˣ�Ϊ����ʱ��ʾΪ���
        this.speed = 0;
        //��ǰ������Ƶ���б��е�λ��˳��
        this.playIndex = 0;
        //��ǰ�����б��п���Ϊ�գ����Ϊ��ʱ����������Ժ�ֱ���˳�����ҳ��
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

        var buildSaveHref = function(){
            var search = win.link.indexOf('?') < 0 ? '' : win.link.substr(win.link.indexOf('?') );
            var baseUrl = win.link.replace( search, ''), indexCh = 0;
            var currSav = win.link.indexOf('PREFOUCS') >= 0 ? 'PREFOUCS' : 'currFoucs';
            indexCh = search.indexOf(currSav);
            if( indexCh < 0 ) {
                search = search + ( search.length > 0 ? ( search.endWith('?') ? '' : '&' ) : '?' ) + currSav + '=' + that.saveCurr();
            } else {
                var sav = search.query(currSav);
                //��� ����PREFOUCS �� currFoucs ͬʱ���ڣ���ɾ���� currFoucs
                indexCh = win.link.indexOf('currFoucs');
                if( win.link.indexOf('PREFOUCS') >= 0 && indexCh >= 0 ) {
                    search = search.replace( win.link.substr(indexCh, 1) + 'currFoucs=' + win.link.query('currFoucs'), '' );
                }
                if( sav != '' ) {  //URL �������б��潹��
                    search = search.replace( currSav + '=' + sav, currSav + '=' + that.saveCurr() );
                } else {
                    search += '&' + currSav + '=' + that.saveCurr();
                }
            }
            if ( link.query('backURL') != '' && search.query('backURL') == '' ) search += '&backURL=' + link.query('backURL');
            return baseUrl + search;
        };
        var p60_path_save = function( saveUrl ){
            if( typeof saveUrl !== 'string' ) saveUrl = buildSaveHref();
            //���д���, ��⵱ǰ����ĵ�ַ�Ƿ�Ϊ EPG�������ĵ�ַ,�����, ��Ϊ����·��
            if( saveUrl.startWith('/EPG/jsp/') ) saveUrl = win.EPGUrl + saveUrl.substr(8);
            win.debug('CALL sysmisc.path_sav("', saveUrl, '");');
            sysmisc.path_sav(saveUrl);
        };
        //ͨ�� SPAN ������һ���ַ���ռ�ж��ٸ����ؿ��
        var calcStringPixels = function (str, fontSize, callback) {
            var element = $("calcPixels");
            if (!element) {
                element = document.createElement("div");// ���ò��ɼ�, �����display:none���޷�ȡ����
                element.style.width = "2500px";
                element.style.height = "45px";
                element.style.left = "0px";
                element.style.top = "-50px";
                element.style.position = "absolute";
                element.style.zIndex = "0";
                element.style.visibility = element.style.overflow = "hidden";
                element.style.color =  element.style.backgroundColor = "transparent";
                var elements = document.body.children;
                document.body.insertBefore(element,elements[0]);
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
            for (var i in o) { if (typeof o[i] === 'object') enumObj(o[i]); }
        };
        this.events = [];
        //ר���ҳ����ת
        this.linkto = function (uri, backUrl) {
            var url = '';
            if( typeof uri == 'undefined' || uri.isEmpty()) return link;
            if (uri.indexOf("wasu.cn/") > 0 && !win.isP60) {
                url = win.EPGUrl + "/defaultHD/en/Category.jsp?url=" + uri;
            } else {
                var isSearch = uri.indexOf('searchIndex.jsp') > 0 || uri.indexOf('allSearch') > 0;
                if (! uri.startWith('http') ) {
                    if( uri.startWith("/EPG/jsp")) { //�������EPG��������
                        //��� ����PREFOUCS �� currFoucs ͬʱ���ڣ���ɾ���� currFoucs
                        var indexCh = win.link.indexOf('PREFOUCS');
                        if( indexCh >= 0 ) uri = uri.replace( uri.substr(indexCh, 1) + 'PREFOUCS=' + win.link.query('PREFOUCS'), '' );
                        url += isSearch ? ( win.EPGUrl + uri.substr(8) ) : ( that.current() + uri );
                    } else { //�������EPG��������
                        var port = location.port;
                        port = port == '' || port == 80 ? '' : (':' + port);
                        url = location.protocol + '//' + location.hostname + port + uri;
                    }
                } else if( (url = uri).startWith('http://epgServer') ) {
                    url = url.replace('http://epgServer', win.EPGUrl);
                }
                // url Ҫ��תҳ�ĵ�ַ�� link, ��ǰҳ�ĵ�ַ
                if( !url.startWith( win.EPGUrl ) || !link.startWith( win.EPGUrl ) || isSearch) {
                    url = buildUrlMark(url, uri);
                    if( typeof backUrl == 'undefined' ) {
                        var currSav = link.indexOf('PREFOUCS') >= 0 ? 'PREFOUCS' : 'currFoucs';
                        var focusStr = link.query(currSav);
                        backUrl = link.query('backURL');
                        if( ! backUrl.isEmpty() ) that.href = link.replace('backURL=' + backUrl , '');
                        that.href = focusStr != '' ? link.replace(focusStr, that.saveCurr()) : ( buildUrlMark(that.href) + currSav + "=" + that.saveCurr() );
                        if( isSearch ) {
                            //���������ҳ�����ز���Ϊ��epgBackurl, ����Ϊ��backURL��������ҳ����ʹ�� encodeURIComponent ����
                            if( that.href.startWith( win.EPGUrl) ) ajax( win.EPGUrl + '/neirong/player/include.jsp?RMCache=1');
                            that.href = buildUrlMark(that.href) + ( ( url.startWith( win.EPGUrl ) || link.startWith( win.EPGUrl ) ) && that.href.query('HWSCache') == '' ? 'HWSCache=0&' : '');//��ֹ��Ϊ��ӵ�����
                            if( !backUrl.isEmpty() ) that.href += 'backURL=' + backUrl;
                            if( iPanel.mediaType == 'P60' ) { p60_path_save( that.href ); return url; }
                            url += 'epgBackurl=' + that.href;
                        } else {
                            url +=  ( url.startWith( win.EPGUrl ) || link.startWith( win.EPGUrl ) ) && that.href.query('HWSCache') == '' ? 'HWSCache=0&' : '';
                            url += 'backURL=' + ( url.startWith(location.origin) ? (encodeURIComponent( that.href ) +  ( ! backUrl.isEmpty() ? ('#|#' + backUrl ) : '') ) : encodeURIComponent( buildUrlMark( that.href ) + ( backUrl.isEmpty() ? '' : ('backURL=' +  backUrl )) ) );
                        }
                    } else {
                        url += 'backURL=' + encodeURIComponent( backUrl );
                    }
                }
            }
            win.debug("=======>>>>> LINK TO : ", url ,' <<<<<=======');
            return url;
        };
        this.invokePlay = function( item, typeId, widget, saveUrl ){
            var id = undefined, parentId = undefined;
            if ( typeof item == 'undefined' ) return false;
            if( typeof item == 'string' || typeof item == "number") { id = item; typeId = typeId || '-1' } else { id = item.id; parentId = item.parentId; typeId = typeId || item.typeId || -1; }
            if( typeof id == 'undefined' ) return false;
            var idType = undefined;
            if( id.length > 8 ) idType = "FSN";
            if( typeof saveUrl == 'undefined' && !link.startWith( win.EPGUrl ) ) saveUrl = buildSaveHref();
            var buildUrl = iPanel.mediaType == 'IPTV' ? "" : (function(){
                var url = '';
                if( typeof saveUrl == 'undefined' || iPanel.mediaType == 'P60') {
                    url = win.EPGUrl + '/defaultHD/en/' + ( iPanel.mediaType == 'P60' ? 'go_a' : 'A' ) + 'uthorization.jsp?typeId=' + String( typeId ) +'&playType=1';
                    url += parentId == undefined ? '' : ( '1&parentVodId=' + parentId ) ;
                    url += '&progId=' + id + '&contentType=0&business=1&baseFlag=0&startTime=' + win.buildPlayStartTime(item);
                    url += idType == undefined ? '' : '&idType=FSN';
                } else {
                    url = win.EPGUrl + '/defaultHD/en/hidden_detail.jsp?typeId=' + String( typeId ) +'&playType=1';
                    url += parentId == undefined ? '' : '1' ; //����Ҫ�� parentVodId, �Զ�����
                    url += '&vodId=' + id + '&baseFlag=0&startTime=' + win.buildPlayStartTime(item);
                    url += idType == undefined ? '' : '&idType=FSN';
                    url += '&appBackUrl=' + encodeURIComponent(saveUrl);
                }
                return url;
            })();
            if( iPanel.mediaType != 'P60' && iPanel.mediaType != 'GW' && iPanel.mediaType != 'IPTV' ) {
                win.debug("P30 OR HD30 Play Item -> Before play invoke!");
                var url = that.current() + buildUrl;
                if( typeof widget != 'undefined' ) {
                    $(widget).src = url;
                } else {
                    window.location.href = url;
                }
            } else if ( iPanel.mediaType == 'GW' ) {
                var open = function( vodId ){
                    win.debug("iPanelGatewayHelper.play('" + vodId + "');");
                    iPanelGatewayHelper.play( String( vodId ) );
                };
                if( idType != 'FSN' ){ open( id ); return true; }
                convertVodId( id , function( rst ){ open( rst.id ); } );
            } else if( iPanel.mediaType == 'IPTV' ){
                win.debug("IPTV Play Item -> Before MediaPlay invoke, Id:", id,", typeId: ", typeId );
                var extrasType = {"initSeek":"long"};
                var extras = {"flagType":"1"};              //1, ʹ��VOD��Ȩ
                extras['playType'] = parentId == undefined ? '1' : '2';
                extras['isOutId'] = idType != 'FSN' ? false : true;
                extras['baseFlag'] = 0;//0�����£�1�����ε㲥��2�����ε�+���£��� Ϊ0����ͳһ���������̣�Ϊ1�� 2ʱ��ԭ�� �ε㲥�������̣���3����ѣ�4������ȯ���� ��ȯ����Ȩ��
                extras['items'] = '1'; //��ʼ���ŵļ�������ӰĬ��Ϊ1
                extras['initSeek'] = buildPlayStartTime(item); //��ʼ���ŵĺ�����������30000, buildPlayStartTime �������ص�λΪ��
                if( extras['initSeek'] != 0  ) {
                    extras['initSeek'] = extras['initSeek'] * 1000;
                    extras['isPush'] = true;
                }
                extras['previewFlag'] = 0;  // �Ƿ�֧��Ԥ����0��֧�֣�1֧��, ����ʹ��ԭ������Ȩ�����Բ�֧��Ԥ��
                extras['previewTime'] = 0;  // ��λ�루��playType Ϊ1����Ƶʱ���� previewtime ����Ԥ��ʱ����
                extras['orderProduct'] = 0;  //  �� String ��Ҫ�����Ĳ�ƷID��ͳһ����ҳ���ã�
                extras['authProduct'] = 0;  // �� String ��Ҫ��Ȩ�Ĳ�ƷID��AAA ��Ȩ�ã�
                extras['spCode'] = 0;  // �� String AAA ��Ȩ��
                extras['appCode'] = 0;  // �� String AAA ��Ȩ��
                extras['appKey'] = 0;  //  �� String AAA ��¼�ã�signature= ��spCode+appCode+userNo+password+ appKey��,��˵������˳��32λ MD5���� appId �� String ͳһ����ҳ����
                extras['sessionId'] = 0;  // �� String
                extras['spCode'] = 0;  // spCode+{���ź�4 λ}+{yymmddHHmiss}+{3 λ�����}
                iPanel.openMediaPlay(String(id), String(typeId), extras);
            } else if( iPanel.mediaType == 'P60' ){
                win.debug("P60 Play Item -> Before ajax invoke!");
                ajax( buildUrl , function(rst){
                    if( rst.playFlag === "1") {
                        var name = rst.playUrl.split("^")[7];
                        var uri = 'http://aoh5.cqccn.com/h5_vod/player/index.html?name=' + encodeURI( name ) + '&rtsp=' + base64.encode(rst.playUrl) + '&reportUrl=' + base64.encode(rst.reportUrl) + '&vodId=' + id + '&flag=1&type=SP';
                        win.debug(" ===> NAME : [" , name , "], PLAY : [" , rst.playUrl , "], REPORT : [" , rst.reportUrl , "], PlayURL : [" , uri , "] , saveUrl : [", saveUrl ,"]");
                        p60_path_save( saveUrl );
                        window.location.href = uri;
                    } else {
                        tooltip(GET_VOD_RTSP_ADDR_ERROR , typeof rst.message == 'string' ? rst.message : TECH_SERVE_STR);
                    }
                });
            }
            return true;
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
            selectItem  : function( item ){
                var typeId = item.typeId;
                var url = '';
                win.debug("SelectAct -> SELECT ITEM('NAME:" , item.name , "','isSitcom:" , item.isSitcom , "','mediaType:" , iPanel.mediaType , "');");
                //android �����ⲿ���� ������ʽ: startApk ��������
                if (typeof item.linkandr === 'string' && iPanel.eventFrame.systemId) {
                    var linkAndr = item.linkandr;
                    if (iPanel.mediaType == 'P30') {
                        iPanel.IOControlWrite("startAPK", linkAndr);
                    } else if (iPanel.mediaType == 'GW') {
                        var pkg = linkAndr.substr(0, linkAndr.indexOf(","));
                        linkAndr = linkAndr.substr(linkAndr.indexOf(",") + 1);
                        var cls = linkAndr.substr(0, linkAndr.indexOf(","));
                        var params = linkAndr.substr(linkAndr.indexOf(",") + 1);
                        win.debug("SelectAct -> iPanelGatewayHelper.launchApk('" + pkg + "','" + cls + "','" + params + "');");
                        iPanelGatewayHelper.launchApk(pkg, cls, params);
                    }
                    return;
                }
                //p60 �����ⲿ���� ������ʽ: am start ��������, ͨ���������ʱ���������š�
                //����sysmisc.runCommand("am start -a com.cw.settings.start --es url file:///android_asset/entry.html");
                //����sysmisc.runCommand("am start -n com.holyblade.platform2/com.holyblade.platform2.Platform");
                //����sysmisc.runCommand("am start -d tenvideo2://?action=7&video_name=��Ѷ��Ƶ&cover_id=086w61i1yf35jzh&is_child_mode=0");
                if( iPanel.mediaType == 'P60' && typeof item.linkP60Apk != 'undefined'  ){
                    win.debug("P60 call ===> am start ", item.linkP60Apk );
                    sysmisc.runCommand("am start " + item.linkP60Apk );
                    return;
                }
                if (typeof item.linkto === 'string' || typeof item.linkP60 === 'string') {
                    var uri = item.linkto;
                    if( iPanel.mediaType == 'P60' && typeof item.linkP60 == 'string' ) uri = item.linkP60;
                    url = that.linkto( uri );
                } else {
                    win.debug("play select item ");
                    if (item.isSitcom === 0) {
                        cursor.invokePlay( item, typeId ); return;
                    } else {
                        if( iPanel.mediaType == 'P60') {
                            p60_path_save();
                            url = 'http://aoh5.cqccn.com/h5_new/vodDetail/index.html?vod_id=' + item.id + '&idtype=0'; // &thirdCategoryid=typeId,�˲�����û�ã�P60������ĿID����������ᵼ�¾����޷���ȡ����
                        } else if (iPanel.mediaType == 'HD30' || iPanel.mediaType == 'NEW30' || iPanel.mediaType == 'P30' || iPanel.mediaType == 'GW'){
                            var detailPage = 'vod/tv_detail.jsp';
                            if (that.isKorean) detailPage = 'hjzq/hj_tvDetail.jsp';
                            else if (that.isWestern) detailPage = 'western/eu_tvDetail.jsp';
                            url = that.current() + '/EPG/jsp/defaultHD/en/hddb/' + detailPage + "?vodId=" + item.id + "&typeId=" + typeId;
                        } else if( iPanel.mediaType == 'IPTV' ) { //IPTV ��ӰƬ��ϸҳ
                            iPanel.openMediaDetail(item.id,typeId);  // ���typeId������Ĭ��Ϊ-1,���Բ��ö�typeId����У��
                        }
                    }
                }
                if( url.indexOf( 'HWSCache' ) > 0 ) {
                    ajax( win.EPGUrl + '/neirong/player/include.jsp?RMCache=1');
                    setTimeout(function(){window.location.href = url;},20);
                } else {
                    window.location.href = url;
                }
                debug("Jump to : ", url);
            },
            search : function( retUrl ){
                if( iPanel.mediaType == 'P30' || iPanel.mediaType == 'GW' ){
                    iPanel.IOControlWrite('startOtherApk','com.ipanel.chongqing_ipanelforhw,com.ipanel.join.cq.vod.searchpage.SearchPage');
                    return;
                }
                var searchUrl = iPanel.mediaType == 'P60' ? 'http://aoh5.cqccn.com/h5_vod/allSearch/index.html' : '/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp';
                window.location.href = that.linkto(searchUrl, retUrl);
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
                var element = $("tooltipDivId");
                if( element && element.style.visibility != 'hidden' ) { element.style.visibility = 'hidden'; return ; }
                var rmCache = link.query('HWSCache');
                if( !rmCache.isEmpty() ) { ajax( win.EPGUrl + '/neirong/player/include.jsp?RMCache=1'); }
                if (!that.EPGflag.isEmpty() || typeof that.backUrl === 'undefined' || that.backUrl.isEmpty() || that.backUrl.indexOf('Category.jsp') >= 0 && that.backUrl.indexOf("Category.jsp?url=") < 0) {
                    if ( iPanel.mediaType == 'P60' ) return sysmisc.finish();
                    //�����������ӣ����߼�ͥ���أ�ʹ�ô˷����˳�����ҳ
                    if ( iPanel.mediaType == 'P30' || iPanel.mediaType == 'GW') return iPanel.eventFrame.exitToHomePage();
                    if( iPanel.mediaType == 'IPTV' )  return iPanel.misc.goBackApp();
                    window.location.href = iPanel.eventFrame.portal_url;
                    return;
                }
                var url = that.backUrl;
                if ( that.appendURL != '' && that.appendURL != 'undefined') url += '&backURL=' + that.appendURL;
                win.debug('=======>>>>> GO BACK LINK TO : ',  url , ' <<<<<=======' );
                window.location.href = url;
            },
            select: function () {
                that.call('selectAct');
            },
            goBack: function () {
                that.call('goBackAct');
            },
            goHome: function () {
                //�����������ӣ����߼�ͥ���أ�ʹ�ô˷����˳�����ҳ
                if (iPanel.mediaType == 'P30' || iPanel.mediaType == 'GW') {
                    iPanel.eventFrame.exitToHomePage();
                } else if( iPanel.mediaType == 'HD30' || iPanel.mediaType == 'NEW30' ) {
                    window.location.href = iPanel.eventFrame.portal_url;
                } else if( iPanel.mediaType == 'P60' ) {
                    sysmisc.finish();
                } else {
                    that.call('goBackAct');
                }
            }
        };
        /**
         * ��ȡ posters �е�ͼƬ
         * @param posters ����ͼ��Ķ���
         * @param type 0 ����ͼ��1 ���� ��2 ���� ��3 ͼ��, 4 ����ͼ ��5 ���ͼ �� 6 ��ͼ �� 7 ����ͼ �� 8 Ƶ��ͼƬ �� 9 Ƶ���ڰ�ͼƬ �� 10 Ƶ������ͼƬ �� 11 ����
         * @param defaultPic Ĭ��ͼƬ
         * @param index ͼƬ�е�˳��
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
            var getList = function (element, from, fromId) { //from �����������, ���Ϊϵ�о�ʱ, ����Ҫ���� ��ǰ�缯��ID, �Ѿ缯��ID������ parentId��
                that.sitcoms = [];
                var typeId = element.id || element.typeId;
                var items = element.data || element.items;
                var result = [];
                if (typeof items !== 'undefined') {
                    for (var i = 0; i < items.length; i++) {
                        var item = items[i];
                        //�����ר��
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
                            for (var j = 0; j < childrenList.length; j++) //index ��ŵ�������˳���п��ܵ�10�������� ��10��
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
         * vote.target: ͶƱĿ��,һ��Ϊ item.name
         * that.voteId:ͶƱID
         * vote.limit:ÿ�����ͶƱ x Ʊ
         * vote.limitPer: ÿ�������ͶƱ x Ʊ
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
            var url = 'http://' + (typeof iPanel.isComputer === 'undefined' ? 'ivote.vod.cqcnt.com:8080' : '192.168.18.249:8080') + (vote.repeat ? ('/voteNew/external/addVote6.ipanel?icid=' + win.iPanel.serialNumber +
                    '&phone=' + that.phoneNumber +
                    '&classifyID=' + that.voteId +
                    '&voteCount=' + vote.limit +
                    '&contentNum=' + vote.limitPer + '&content=' + encodeURIComponent(vote.target)) :
                    ('/voteNew/external/addVote.ipanel?icid=' + win.iPanel.serialNumber +
                        '&repeat=false&phone=' + that.phoneNumber +
                        '&classifyID=' + that.voteId +
                        '&content=' + encodeURIComponent(vote.target))
            );
            ajax(url, function (result) {
                that.commiting = false;
                if (typeof vote.callback == 'function') {
                    vote.callback(result);
                };
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
        this.saveCurr = function () { //�˺���������
            var focusStr = that.blocked + ',';
            for (var i = 0; i < that.focusable.length; i++)
                focusStr += that.focusable[i].focus + ",";
            focusStr += that.playIndex;
            if (typeof that.consigned !== 'undefined') {
                if (!isNaN(that.consigned)) focusStr += "," + that.consigned;
                else for (var i = 0; i < that.consigned.length; i++) focusStr += "," + that.consigned[i];
            }
            return focusStr;
        };
        this.parseCurr = function(){};//�˺���������
        this.current = function () {
            return win.EPGUrl + '/defaultHD/en/SaveCurrFocus.jsp?currFoucs=' + that.saveCurr() + '&url='
        };
        this.elapsedSeconds = function () {
            if (this.starter === 'undefined' || isNaN(this.starter)) return 0;
            var time = new Date().getTime();
            return parseInt(Math.floor((time - this.starter) / 1000.0));
        };
        this.fireEvent = function (name) {
            var args = {"code": name};
            var evt = document.createEvent('CustomEvent');
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
            try {
                params = params || {};
                debug(decodeURIComponent('%E6%AD%A3%E5%9C%A8%E6%89%A7%E8%A1%8C%E9%A1%B5%E9%9D%A2%E8%84%9A%E6%9C%AC%E5%88%9D%E5%A7%8B%E5%8C%96...'));
                that.options.extend(params);
                if (typeof that.options['init'] === 'function') that.options['init'](that);
                if ( that.backUrl == '' || that.backUrl == undefined ) {
                    that.backUrl = link.query('backURL');
                    var index = that.backUrl.indexOf('#|#');
                    if( index > 0 ) {
                        that.appendURL = that.backUrl.substr( index + 3 );
                        that.backUrl = that.backUrl.substr(0, index );
                    } else {
                        that.appendURL = link.query('appendURL');
                    }
                    that.backUrl = decodeURIComponent(that.backUrl);
                }
            } catch (e) {
                debug(decodeURIComponent('%E6%89%A7%E8%A1%8C%E9%A1%B5%E9%9D%A2%E5%88%9D%E5%A7%8B%E5%8C%96%E5%A4%B1%E8%B4%A5%EF%BC%9A') + e);
            }
        };
        this.call = function (name, args) {
            var fn = this.options[name];
            if (typeof fn !== 'function') fn = this.functions[name];
            if (typeof fn !== 'function') fn = this[name];
            if (typeof fn === 'function')  return fn(args);
            else debug(decodeURIComponent('%E5%87%BD%E6%95%B0%20') + name + decodeURIComponent('()%20%E6%9C%AA%E5%AE%9A%E4%B9%89%3B'));
        };
    };
    var MuxPlayer = function(){
        this.PLAY = decodeURIComponent('%E6%92%AD%E6%94%BE');
        this.PAUSE = decodeURIComponent('%E6%9A%82%E5%81%9C');
        this.STOP = decodeURIComponent('%E5%81%9C%E6%AD%A2');
        this.FORWARD = decodeURIComponent('%E5%BF%AB%E8%BF%9B');
        this.BACKWARD = decodeURIComponent('%E5%BF%AB%E9%80%80');

        this.instance = undefined;
        this.playerId = undefined;  //PlayId, P60ʹ�ã�
        this.playType = "VOD";      //�����ֱ����ʹ�ÿ��������ͣ����
        this.status = this.STOP;    //���ţ���ͣ��ֹͣ����������ˣ�����
        this.playTime = undefined;  //���������ŵ�ʱ��
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

            win.debug('convert position ( x: ', p.x, ', p.y: ', p.y, ', p.w: ', p.w, ', p.h: ', p.h);
            return p;
        };
        this.fullScreen = function() {
            win.debug("CALL [fullScreen] ==> video play in full screen!");
            that.fullmode = true;
            this.position = {left:0, top:0, width:1280, height:720};
            if( iPanel.mediaType != 'P60' ) {
                if( iPanel.mediaType == 'HD30' || iPanel.mediaType == 'NEW30' || iPanel.mediaType == 'P30' || iPanel.mediaType == 'GW') {
                    media.video.fullScreen();
                } else if( iPanel.mediaType == 'IPTV' ) {
                    that.instance.setVideoDisplayMode( 1 );
                    that.instance.refresh();
                }
            } else if( iPanel.mediaType == 'P60' ){
                if( typeof that.playerId === 'undefined' ) {  return; }
                sysmisc.bringToForeground("video");
                var p = convertPos();
                win.debug(decodeURIComponent("%E6%92%AD%E6%94%BE%E5%99%A8%E7%B1%BB%E5%9E%8B"), "(", that.playType, ", Id: ", that.playerId, "),", decodeURIComponent("%E8%AE%BE%E7%BD%AE%E5%85%A8%E5%B1%8F%E6%92%AD%E6%94%BE"), decodeURIComponent( ( that.playType == 'LIVE' ? dvbplayer.resize(that.playerId,p.x,p.y,p.w,p.h) : mixplayer.resize (that.playerId,p.x,p.y,p.w,p.h) ) == 0 ? "%E6%88%90%E5%8A%9F" : "%E5%A4%B1%E8%B4%A5" ), "!!!" );
            }
        };
        this.setPosition = function(left,top,width,height){
            win.debug('CALL [setPosition] => media position : (x:', left, ',y:', top, ',width:', width, ',height:' , height,")");
            that.fullmode = false;
            that.position = {left:left, top:top, width:width, height:height};
            if ( iPanel.mediaType != 'P60' ) {
                if( iPanel.mediaType == 'IPTV' ) {
                    if( that.instance != undefined ) {
                        if( left == top && top == 0 && width == 1280 && height == 720 ){
                            that.instance.setVideoDisplayMode( 1 );
                        } else {
                            that.instance.setVideoDisplayMode( 0 );
                            that.instance.setVideoDisplayArea( left, top, width, height );
                        }
                        that.instance.refresh();
                    }
                } else {
                    if( left == top && top == 0 && width == 1280 && height == 720 ) media.video.fullScreen();
                    else  media.video.setPosition(left,top,width,height);
                }
            } else {
                if( typeof that.playerId === 'undefined' ) return;
                var p = convertPos(left,top,width,height);
                win.debug(decodeURIComponent('%E6%92%AD%E6%94%BE%E5%99%A8%E7%B1%BB%E5%9E%8B'), '(', that.playType, ', Id: ', that.playerId, '),', decodeURIComponent('%E8%AE%BE%E7%BD%AE%E5%B0%8F%E7%AA%97%E5%8F%A3%E6%92%AD%E6%94%BE'), decodeURIComponent( ( that.playType == 'LIVE' ? dvbplayer.resize(that.playerId,p.x,p.y,p.w,p.h) : mixplayer.resize (that.playerId,p.x,p.y,p.w,p.h) ) == 0 ? '%E6%88%90%E5%8A%9F' : '%E5%A4%B1%E8%B4%A5' ), '!!!' );
            }
        };
        that.seekTo = function(seconds) {
            if( that.playType == 'LIVE' || iPanel.mediaType == 'P60' && that.playerId == undefined ) return;
            if ( iPanel.mediaType !== 'P60' ) {
                if( iPanel.mediaType == 'IPTV' ) {
                    //TODO:
                } else {
                    media.AV.seek(cursor.secondsToTime( seconds ));
                }
            } else {
                mixplayer.seekTo(that.playerId, seconds);
            }
        };
        this.getStatus = function(){
            return that.status;
        };
        this.backward = function(speed){
            if( that.playType == 'LIVE' || iPanel.mediaType == 'P60' && that.playerId == undefined ) return;
            that.speed = speed;
            if ( iPanel.mediaType !== 'P60' ) {
                if( iPanel.mediaType == 'IPTV' ) {
                    //TODO:
                } else {
                    media.AV.backward(speed);
                }
            } else {
                mixplayer.scale(that.playerId, speed);
            }
            that.status = that.BACKWARD;
            win.debug( "=======>>>>> CALL backward() PLAYER STATUS: (", that.status, ') <<<<<=======');
        };
        this.forward = function(speed){
            if( that.playType == 'LIVE' || iPanel.mediaType == 'P60' && that.playerId == undefined ) return;
            that.speed = speed;
            if ( iPanel.mediaType !== 'P60' ) {
                if( iPanel.mediaType == 'IPTV' ) {
                    //TODO:
                } else {
                    media.AV.forward(speed);
                }
            } else {
                mixplayer.scale(that.playerId, speed);
            }
            that.status = that.FORWARD;
            win.debug( '=======>>>>> CALL forward() PLAYER STATUS: (', that.status, ') <<<<<=======');
        };
        this.elapsed = function(){
            var ela = 0;
            if( that.playType == 'LIVE' || iPanel.mediaType == 'P60' && that.playerId == undefined ) return ela;
            debug("VOD ELAPSED : " ,ela = ( iPanel.mediaType !== 'P60' ? media.AV.elapsed : mixplayer.getCurrent(that.playerId) ) || ela);
            return ela;
        };
        this.duration  = function(){
            var dur = 0;
            if( that.playType == 'LIVE' || iPanel.mediaType == 'P60' && that.playerId == undefined ) return dur;
            debug("VOD DURATION : " ,dur = ( iPanel.mediaType !== 'P60' ? media.AV.duration : mixplayer.getDuration(that.playerId) ) || dur);
            return dur;
        };
        this.voiceUp = function(){
            if ( iPanel.mediaType !== 'P60' ) {
                if( iPanel.mediaType == 'IPTV' ) {
                    //TODO:
                } else {
                    media.sound.up();
                }
            } else {
                if( that.playType == 'LIVE' || that.playerId == undefined ) return;
                mixplayer.voiceUp();
            }
        };
        this.voiceDown = function(){
            if ( iPanel.mediaType !== 'P60' ) {
                if( iPanel.mediaType == 'IPTV' ) {
                    //TODO:
                } else {
                    media.sound.down();
                }
            } else {
                if( that.playType == 'LIVE' || that.playerId == undefined ) return;
                mixplayer.voiceDown();
            }
        };
        this.resume = function(){
            if( that.playType == 'LIVE' || that.status == that.PLAY ) return;
            if ( iPanel.mediaType !== 'P60' ) {
                if( iPanel.mediaType == 'IPTV' ) {
                    that.instance.play(2);
                } else {
                    media.AV.play();
                }
            } else if( iPanel.mediaType == 'P60' ) {
                sysmisc.bringToForeground('web');
                if( that.playerId != undefined ) {
                    mixplayer.resume(that.playerId);
                    mixplayer.scale(that.playerId, 1);
                }
            }
            that.status = that.PLAY;
            win.debug( "=======>>>>> CALL resume() PLAYER STATUS: (", that.status, ') <<<<<=======');
        };
        this.pause = function() {
            if( that.playType == 'LIVE' ) return;
            if ( iPanel.mediaType !== 'P60' ) {
                if( iPanel.mediaType == 'IPTV' ) {
                    that.instance.pause();
                } else {
                    media.AV.pause();
                }
            } else {
                if( that.playerId != undefined ) mixplayer.pause(that.playerId);
            }
            that.status = that.PAUSE;
            win.debug( "=======>>>>> CALL pause() PLAYER STATUS: (", that.status, ') <<<<<=======');
        };
        this.close = function(){
            if ( iPanel.mediaType !== 'P60' ) {
                if( iPanel.mediaType == 'IPTV' ) {
                    if( that.instance != undefined ) {
                        that.instance.stop();
                        that.playerId = that.instance = undefined;
                    }
                } else {
                    if( that.playType == 'LIVE' ) {
                        DVB.stopAV();
                    }
                    media.AV.close();
                }
            } else {
                if( that.playerId != undefined ) {
                    if( that.playType == 'LIVE' ) {
                        dvbplayer.stop(that.playerId);
                    } else {
                        mixplayer.stop(that.playerId);
                    }
                }
            }
            that.status = that.STOP;
            win.debug( "=======>>>>> CALL close() PLAYER STATUS: (", that.status, ') <<<<<=======');
        };
        //options Ϊһ������
        //position: {left,top,width,height},
        //���ŵ㲥ʱ��typeId:(��ĿID�� ��-1),vodId:(��Ƶ��ID���������ڲ�ID��Ҳ�������ⲿID),idType:(���idType��Ϊ�գ�˵�����ŵ�Ϊ�ⲿID)
        //����ֱ��ʱ��frequency:Ƶ��(1870000),serviceId:serviceId
        //����ʱ��ʱ��channelId:Ƶ��ID,grogram:'��ĿID?'
        //arguments.callee ��������
        this.play = function(o){
            o = o || {};
            that.playType = (typeof o.vodId !== 'undefined' || typeof o.channelId !== 'undefined' || typeof o.url != 'undefined') ? 'VOD' : 'LIVE';
            if( typeof o.position != 'undefined' ) that.setPosition(o.position.left,o.position.top,o.position.width,o.position.height);
            win.debug("media Type:" , iPanel.mediaType , ', playType:', that.playType);
            var delegate = function(rst){
                that.status = that.PLAY;
                win.debug( '=======>>>>> CALL play() PLAYER STATUS: (', that.status, ') <<<<<=======');
                if(typeof o.callback !== 'function') return;
                o.callback(rst);
            };
            that.startTime = o.startTime = win.buildPlayStartTime( o );
            var openUrl = function(url){
                url = url || '';
                if( url.isEmpty() || ! ( url.startWith('rtsp') || url.startWith('http') ) ) return;
                if( iPanel.mediaType !== 'P60' && iPanel.mediaType != 'IPTV'){
                    var mode = url.startWith('rtsp') ? 'VOD' : 'HTTP';
                    media.AV.open(url, mode );
                } else if( iPanel.mediaType == 'P60') {
                    that.rtsp = url;
                    if( that.playerId === undefined ) {
                        var p = convertPos();
                        that.playerId = mixplayer.create(p.x, p.y, p.w, p.h);
                    } else {
                        mixplayer.playUrl(that.playerId, url, o.startTime );
                    }
                } else if( iPanel.mediaType == 'IPTV' ){
                    if( that.instance === undefined ) {
                        that.instance = new MediaPlayer();
                        that.playerId = that.instance.getPlayerInstanceID();
                        that.instance.bindPlayerInstance( that.playerId );
                    }
                    if( that.position.width == 1280 && that.position.height == 720 ){
                        that.instance.setVideoDisplayMode( 1 );
                    } else {
                        that.instance.setVideoDisplayMode( 0 );
                        that.instance.setVideoDisplayArea( that.position.left, that.position.top, that.position.width, that.position.height );
                    }
                    that.instance.refresh();
                    that.instance.setMediaSource( that.rtsp = url );
                }
            };
            //���vodId���ڣ���ô���ŵ㲥
            if( typeof o.vodId !== 'undefined' || typeof o.channelId !== 'undefined' || typeof o.url != 'undefined') {
                if( typeof o.url != 'undefined' ) {
                    openUrl( o.url );
                    return delegate( o );
                }
                var isVodPlay = typeof o.vodId !== 'undefined';
                var url = '';
                if( iPanel.mediaType !== 'GW' && iPanel.mediaType != 'IPTV' ) {
                    if( isVodPlay ){
                        o.typeId = o.typeId || -1;
                        url = win.EPGUrl + '/defaultHD/en/go_authorization.jsp?typeId=' + o.typeId;
                        url += typeof o.parentId != 'undefined' ? ( '&playType=11&parentVodId=' + String( o.parentId ) ) : ('&playType=1');
                        url += '&progId=' + o.vodId + "&contentType=0&business=1&baseFlag=0";
                        url += ( String(o.vodId).length > 8 || typeof o.idType != 'undefined' ? '&idType=FSN' : '');
                        url += "&startTime=" + o.startTime;
                    } else {
                        url = win.EPGUrl + '/tstvindex.jsp?User=&pwd=&ip=' + iPanel.IpAddress;
                        url += '&NTID=' + iPanel.MAC + "&CARDID=" + iPanel.serialNumber;
                        url += '&Version=1.0&lang=1&ChannelID=' + (o.channelId || '') + '&Prognum=' + (o.program || '0') + '&ServiceGroupID=' + iPanel.groupId;
                        url += '&supportnet=' + iPanel.netType + '&decodemode=H.264HD;MPEG-2HD&CA=1' + (iPanel.mediaType == 'P60' ? '&encrypt=0' : '');
                    }
                    ajax(url, function(rst){
                        if( !isVodPlay ) {
                            var reponseTxt = rst; rst = {};
                            var list = reponseTxt.split('\n');
                            rst.playFlag = list[0].split('=')[1]  == 0 ? "1" : "0";
                            if( rst.playFlag == "1" ) {
                                rst.playUrl = String(list[4].substr(list[4].indexOf('=') + 1));
                                win.debug('playUrl:', rst.playUrl );
                            }
                        }
                        if( rst.playFlag == "1") {
                            var rtsp = rst.playUrl.split("^")[4];
                            win.debug("RTSP:", rtsp );
                            openUrl( rtsp );
                        } else {
                            tooltip(GET_VOD_RTSP_ADDR_ERROR , typeof rst.message == 'string' ? rst.message : TECH_SERVE_STR);
                        }
                        delegate(rst);
                    }, { eval:isVodPlay } ); return;
                } else if( iPanel.mediaType == 'GW' || iPanel.mediaType == 'IPTV' ) {
                    if( isVodPlay ){
                        if( iPanel.mediaType == 'GW' ) {
                            var open = function(id){
                                var http = iPanelGatewayHelper.getPlayUrl(id);
                                openUrl( http );
                                delegate( http );
                                win.debug('GW PLAY ID: ', id, ' ==> URL: ', http);
                            };
                            if( o.idType !== 'FSN' && String(o.vodId).length <= 8 ){
                                open(o.vodId); return;
                            };
                            convertVodId(o.vodId, function( rst ){ open( rst.id ); } );
                        } else {
                            url = iPanel.getVSP() + '/VSP/V3/QueryVOD';
                            //�ڲ�ID Ϊ0�� �ⲿIDΪ��;
                            var idType = o.idType !== 'FSN' && String(o.vodId).length <= 8 ? 0 : 1;
                            ajax(url, function( ret ){
                                if(ret.result.retCode == '000000000')
                                {
                                    var vodId = ret.VODDetail.code;
                                    var mediaID = ret.VODDetail.mediaFiles[0].code;
                                    debug(decodeURIComponent('IPTV %E7%BB%88%E7%AB%AF%E8%AF%B7%E6%B1%82%E5%AA%92%E8%B5%84%E4%BF%A1%E6%81%AF%E6%97%B6%E8%BF%94%E5%9B%9E%EF%BC%8CVODID%EF%BC%9A'), vodId, "��%E5%AA%92%E8%B5%84%20Id%EF%BC%9A", mediaID);
                                    url = iPanel.getVSP() + '/VSP/V3/PlayVOD';
                                    ajax(url, function( rst ){
                                        if(rst.result.retCode == '000000000') {
                                            openUrl( rst.playURL );
                                            return delegate( rst );
                                        } else {
                                            debug(decodeURIComponent('IPTV %E8%AF%B7%E6%B1%82%E6%92%AD%E6%94%BE%E8%B0%83%E7%94%A8%E6%97%B6%E8%BF%94%E5%9B%9E%E5%A4%B1%E8%B4%A5%EF%BC%9A'), rst.result.retMsg );
                                        }
                                    }, {
                                        method : 'post',
                                        data : '{"VODID":"' + vodId + '","mediaID":"' + mediaID + '","IDType":' + idType + '}'
                                    })
                                } else {
                                    debug(decodeURIComponent('IPTV %E7%BB%88%E7%AB%AF%E5%9C%A8%E8%AF%B7%E6%B1%82%E5%AA%92%E8%B5%84%E4%BF%A1%E6%81%AF%E6%97%B6%E5%87%BA%E7%8E%B0%E9%94%99%E8%AF%AF%EF%BC%9A'), ret.result.retMsg );
                                    return delegate( ret );
                                }
                            }, {
                                method : 'post',
                                data : '{"VODID":"' + o.vodId + '","IDType":' + idType + '}'
                            });
                        }
                    } else {
                        tooltip(decodeURIComponent('GW%E6%9A%82%E4%B8%8D%E6%94%AF%E6%8C%81%E6%97%B6%E7%A7%BB%E6%92%AD%E6%94%BE'));
                    }
                }
            } else {
                var frequency = o.frequency || '';
                var serviceId = o.serviceId || '';
                var uri = '';
                var msg = "=======>>>>> DVB PLAY ERROR ( serviceId or frequency IS EMPTY ) <<<<<=======";
                if( frequency == '' || serviceId == ''){
                    win.debug(msg); delegate(msg); return;
                }
                if( iPanel.mediaType == 'HD30' || iPanel.mediaType == 'NEW30' || iPanel.mediaType == 'P30') {
                    DVB.playAV(frequency,serviceId);
                } else if( iPanel.mediaType == 'GW' ) {
                    var mod = Math.floor(Number(serviceId) / 100);
                    uri = 'http://192.168.1.202:18080/D_40992_' + mod + "_" + serviceId;
                    media.AV.open(uri,"HTTP");
                } else if( iPanel.mediaType == 'P60' ) {
                    that.dvbUri = uri = 'dvbelement://' + String( Number(frequency) / 10 ) + '.6875.64.' + String( serviceId) + '.0.0.0.0.0.0';
                    win.debug(decodeURIComponent('=======>>>>>%20P60%20%E7%9B%B4%E6%92%AD%E5%9C%B0%E5%9D%80%3A'), uri , ' <<<<<=======');
                    if( that.playerId === undefined ) {
                        var p = convertPos();
                        that.playerId = dvbplayer.create(p.x, p.y, p.w, p.h);
                    } else {
                        win.debug(decodeURIComponent('=======>>>>>%20P60%E7%9B%B4%E6%92%AD%E6%92%AD%E6%94%BE%E5%99%A8%E8%B0%83%E7%94%A8%20( playerId:'), that.playerId ,", Uri:", that.dvbUri , ' ) => ', dvbplayer.playFrequency(that.dvbUri) == 0 ? STATIC_SUCCESS_STR : STATIC_FAIL_STR, ' <<<<<=======');
                    }
                } else {
                    msg = '=======>>>>> DVB PLAY ERROR ( invalid mediaType ) <<<<<=======';
                    win.debug(msg); delegate(msg);return;
                }
                delegate();
            }
        };
        //�˳�ҳ��ʱִ�д˴���
        this.exit = function(){
            try {
                if ( iPanel.mediaType == 'P60' && that.playerId != undefined) {         //�����P60ִ������
                    if ( that.playType == 'LIVE' ){       // С���ڴ���ֱ������
                        dvbplayer.stop(that.playerId);
                        dvbplayer.destroy(that.playerId);
                    } else {
                        mixplayer.stop(that.playerId);         // ֹͣ
                        mixplayer.destroy(that.playerId);      // ����
                    }
                    that.instance = that.playerId = undefined;
                } else if( iPanel.mediaType == 'IPTV' ){
                    if( that.instance != undefined ) {
                        that.instance.stop();
                        that.instance.unbindPlayerInstance( that.playerId );
                        that.instance = that.playerId = undefined;
                    }
                } else {
                    DVB.stopAV(0);
                    media.AV.close();
                }
            } catch (e) {
                win.debug('=======>>>>> EXIT PLAY ERROR ( ' , e , ' ) <<<<<=======' );
            }
        };
        var evt = function(e){
            var type = e.type;
            var subtype = e.subtype;
            win.debug('TYPE ==> ', type, ', SUBTYPE ==> ', type);
            if( type == 0 ) {
                switch (subtype) {
                    case 0 :
                        if( typeof player.instance == 'undefined') {
                            player.instance = true;
                            var plst = -1;
                            if( player.playType  == 'VOD' ) {
                                win.debug(decodeURIComponent('P60%E7%82%B9%E6%92%AD%E6%92%AD%E6%94%BE%E5%99%A8%E8%B0%83%E7%94%A8%20 mixplayer.playUrl( playerId:'), that.playerId ,", Uri:", that.rtsp , ", startTime:" ,that.startTime , ' ) ====>>>> ', decodeURIComponent('%E8%BF%94%E5%9B%9E%E5%80%BC%EF%BC%9A'), plst = mixplayer.playUrl(that.playerId, that.rtsp, that.startTime ) , ',' , plst == 0 ? STATIC_SUCCESS_STR : STATIC_FAIL_STR);
                            } else if( player.playType == 'LIVE' ) {
                                win.debug(decodeURIComponent('P60%E7%9B%B4%E6%92%AD%E6%92%AD%E6%94%BE%E5%99%A8%E8%B0%83%E7%94%A8%20 dvbplayer.playFrequency( playerId:'), that.playerId ,", Uri:", that.dvbUri , ' ) ====>>>> ',decodeURIComponent('%E8%BF%94%E5%9B%9E%E5%80%BC%EF%BC%9A'),  plst = dvbplayer.playFrequency(that.dvbUri), ',' , plst == 0 ? STATIC_SUCCESS_STR : STATIC_FAIL_STR) ;
                            }
                        }
                        break;   //�����������ɹ�
                    case 1 : //���ųɹ�
                        if( that.playType == 'VOD' ) dvbplayer.setStopMode(2);
                        break;
                    case 2 :
                        if( typeof cursor != 'undefined' ) {
                            if( player.playType  == 'VOD' ) {
                                win.debug(decodeURIComponent('----------------------%20P60%E8%A7%86%E9%A2%91%E6%92%AD%E6%94%BE%E7%BB%93%E6%9D%9F%20%20-------------------'));
                                that.exit();
                                cursor.call('nextVideo');
                            }
                        }
                        break;   //���Ž���
                    case 4 : break;   //ǰ������ͣ��
                    case 5 : break;   //δ֪
                    case 10 : break;  //���ٳɹ�
                    case 11 : break;  //�����ѻָ�
                    case 12 : break;  //�������ӶϿ�
                    case 10 : break;  //�����������ڲ���������
                    default : break;
                }
            } else if(type == 1){
                switch (subtype) {
                    case 100 : break; //����ʧ��
                    case 105 : break; //����ʧ��
                    case 107 : break; //rtsp����ʧ��
                    case 109 : break; //ý��Դ��Ч
                    default : break;
                }
            } else if( type == 2 ) {
                switch (subtype) {
                    case 0 : break; //�ɹ�
                    case 9 : sysmisc.showToast(decodeURIComponent('%E8%AF%A5%E8%8A%82%E7%9B%AE%E6%97%A0%E6%8E%88')); break; //1008 �ý�Ŀ����
                    case 10 : break; //��Ŀ����ʧ��
                    case 12 : break; //������ȷ
                    case 33 : break; //�����б�����
                    case 50 : break; //��Ŀ��������CAϵͳ����
                    default : break;
                }
            }
        };
        if( iPanel.mediaType == 'P60') {
            win.debug(decodeURIComponent('----------------------%20%E8%AE%BE%E7%BD%AEP60%2C%20onEvent%20%20-------------------'));
            win.onEvent = that.event = evt;
        }
    };
    /*��ʼ��ҳ��*/
    try {
        iPanel.eventFrame.initPage(win);
        E.is_HD_vod = true;
    } catch( e ) {}

    win.cursor = new Cursor();
    win.player = new MuxPlayer();
    win.onload = function () {
        if (iPanel.mediaType == 'PC' ) cursor.fireEvent('EIS_MISC_HTML_OPEN_FINISHED');
    };
    win.exit = function () {  //ҳ���˳�ʱִ������
        player.exit();
    };
    win.eventHandler = function (eventObj, __type) {
        //���д�ң�������ղ�,��Ŀ,����,�㲥��,û�м�ֵ
        var currentTime = new Date().getTime();
        var eventCode = String(eventObj.code);
        var hit = false;
        switch (eventObj.code) {
            //����ң�������¼����й���ƶ���������ֱ�Ӻ��Բ�����
            case 'KEY_UP' : cursor.call('onMoveUp'); hit = true; break;
            case 'KEY_DOWN' : cursor.call('onMoveDown'); hit = true; break;
            //����ң�������Ҽ����й���ƶ�����������п�����ˡ�
            case 'KEY_LEFT' : cursor.call('onMoveLeft'); hit = true; break;
            case 'KEY_RIGHT' : cursor.call('onMoveRight'); hit = true; break;
            //ʹ��ң��������һҳʱ������ǰһ������
            case 'KEY_PAGE_UP' : cursor.call('onPageUp'); hit = true; break;
            case 'KEY_PAGE_DOWN' : cursor.call('onPageDown'); hit = true; break;
            //�����س���ʱ��
            case 'KEY_SELECT' : cursor.call('select'); hit = true; break;
            case 'KEY_NUMERIC' : cursor.call('input', eventObj.args.value); hit = true; break;
            //�ڲ�����ҳ���У������ؼ����˳��������˳�������
            case 'KEY_BACK' : cursor.call('goBack'); hit = true; break;
            case 'KEY_TV' : cursor.call('goBack'); hit = true; break;
            //Сң�����ĵ��Ӽ�,��ң�������˳���
            case 'KEY_EXIT' : cursor.call('goBack'); hit = true; break;
            case 'KEY_MENU' : cursor.call('goHome'); hit = true; break;
            //������ŵ�ַ�����سɹ���������Ƶ��
            case 'VOD_PREPAREPLAY_SUCCESS' : cursor.call('play'); hit = true; break;
            //���������ɣ�������һ��
            case 'EIS_VOD_PROGRAM_END' :
                if (typeof cursor.events[eventCode] != 'undefined' && currentTime - cursor.events[eventCode] < 4000) return;
                cursor.call('nextVideo');
                hit = true; break;
            //Сң������#��,��ң���������ü�
            case 'KEY_SET' : cursor.call('press', 'SET'); hit = true; break;
            //Сң������*��,��ң��������Ѷ��.
            case 'KEY_BROADCAST' : cursor.call('press', 'STAR'); hit = true; break;
            //���⹦�ܼ�
            case 'KEY_RED' : cursor.call('press', 'RED'); hit = true; break;
            case 'KEY_BLUE' : cursor.call('press', 'BLUE'); hit = true; break;
            case 'KEY_GREEN' : cursor.call('press', 'GREEN'); hit = true; break;
            case 'KEY_YELLOW' : cursor.call('press', 'YELLOW'); hit = true; break;
            case 'KEY_F1' : cursor.call('press', 'F1'); hit = true; break;
            case 'KEY_F2' : cursor.call('press', 'F2'); hit = true; break;
            case 'KEY_F3' : cursor.call('press', 'F3'); hit = true; break;
            case 'KEY_IME' : cursor.call('press', 'F4'); hit = true; break;
            //INFO ��������
            case 'KEY_INFO' : cursor.call('press', 'INFO'); hit = true; break;
            //��ң������ MAIL ��������
            case 'KEY_MAIL' : cursor.call('press', 'MAIL'); hit = true; break;
            //�ؿ���������
            case 'KEY_PLAYBACK' : cursor.call('press', 'PLAYBACK'); hit = true; break;
            //��ң�����Ĺ㲥��������
            case 'KEY_AUDIO' : cursor.call('press', 'AUDIO'); hit = true; break;
            //������������
            case 'KEY_AUDIO_MODE' : cursor.call('press', 'AUDIO_MODE'); hit = true; break;
            //������������
            case 'KEY_MUTE' : cursor.call('press', 'MUTE'); hit = true; break;
            //TV+ ��������, ��ң�����������˼�,��ң�����ĵ㲥��
            case 'KEY_VOD' : cursor.call('press', 'VOD'); hit = true; break;
            //ҳ��������
            case 'EIS_MISC_HTML_OPEN_FINISHED' : cursor.call('htmlOpenFinished'); hit = true; break;
            default : break;
        }
        cursor.events[eventCode] = currentTime;
        if ( hit ) return false;
        return eventObj;
    };
})(window);