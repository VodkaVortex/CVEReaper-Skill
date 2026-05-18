var setWizardCfg_flag = 0;

function setCookie(name,value){
    var Days = 30;
    var exp = new Date();
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}

function getCookie(name){
    var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
    if(arr=document.cookie.match(reg))
        return unescape(arr[2]);
    else
        return null;
}

function getLoginCfg(){
    var postVar={"topicurl" : "setting/getLanguageCfg"};
    postVar=JSON.stringify(postVar);
    $.ajax({  
        type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
            var rJson=JSON.parse(Data);
            setCookie("languageType", rJson.LanguageType);//将LanguageType存入Cookie,变量名称为languageType。
            setCookie("productName", rJson.ProductModel);
            setCookie("fmVersion", rJson.fmVersion);  

            if (rJson["login_flag"]=="2"){
                $('#err_msg').html(JS_msg52);
            }else if (rJson["login_flag"]=="3"){
                $('#err_msg').html(JS_msg53);
            }
        }
    });   
}

function getDial(val){
    var postVar={"topicurl" : "setting/getSysStatusUICfg"};
    postVar=JSON.stringify(postVar);
    $.ajax({  
        type : "post",
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : true,  
        success : function(Data){
            var rJson=JSON.parse(Data);
			setJSONValue({
				'myip'    :   rJson['wanIp'],
				'mymask'  :   rJson['wanMask'],
				'mygw'    :   rJson['wanGW'],
				'mydns'   :   rJson['wanDNS1']
			});
        }
    });
}

function startDial(){
    var postVar={"topicurl":"setting/getSysStatusUICfg"};
    postVar=JSON.stringify(postVar);
    $.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){getDial("DHCP");});
    location.href="internet.asp?ret=1";
}

function getWizardCfg(flag){
    var postVar={"topicurl" : "setting/getEasyWizardCfg"};
    postVar=JSON.stringify(postVar);
    if(flag==1){
        $.ajax({  
            type : "post",  
            url : " /cgi-bin/cstecgi.cgi",  
            data : postVar,  
            async : false,  
            success : function(Data){
                var rJson=JSON.parse(Data);  
				setJSONValue({
					'lanip'     	:   rJson['lanIp'],
					'pppoe_user'    :   rJson['wan_pppoe_user'],
					'pppoe_pass'    :   rJson['wan_pppoe_pass'],
					'wanip'     	:   rJson['wan_ipaddr'],
					'wanmask'   	:   rJson['wan_netmask'],
					'wangw'     	:   rJson['wan_gateway'],
					'wandns'    	:   rJson['wanDNS1']
				});
            }
        }); 
        if($("#wanip").val()==""){
           setJSONValue({
                'wandns'         :   ""
            });
        }
	}else{
        $.ajax({  
            type : "post",  
            url : " /cgi-bin/cstecgi.cgi",  
            data : postVar,  
            async : false,  
            success : function(Data){
                var rJson=JSON.parse(Data);  
				setJSONValue({
					'wifissid'   :   rJson['SSID'],
					'wifikey'    :   rJson['WPAPSK']
				});
            }
        }); 
    }
}