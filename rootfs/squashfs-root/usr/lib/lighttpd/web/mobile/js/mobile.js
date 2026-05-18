/*------------start--------------*/
function isSSID(str) {
	if(/[\x22\x24\x25\x27\x2C\x2F\x3B\x3C\x3E\x5C\x60\x7E]/.test(str)) return 0;
	return 1;
}

function isAllChar(str) {
	if(/[^\x20-\x7D]/.test(str)) return 0;
	if(/[\x20\x22\x24\x25\x27\x2C\x2F\x3B\x3C\x3E\x5C\x60]/.test(str)) return 0;
	return 1;
}

function IsValidStr(objId,objMsg,type) {
	if (objId.val()=="") {
		if (type==0){
			$('#ppp_err_msg').show();
			$('#ppp_err_msg').html(objMsg+MB_msg_1);
		}else{
			$('#div_err').show();
			$('#err_msg').html(objMsg+MB_msg_1);
		}
		return false;
	}
	
	if (type==2&&(objId.val().length<8||objId.val().length>63)) {
		$('#div_err').show();
		$('#err_msg').html(MB_pwd_err);
		return false;
	}
	
	if (type==1) {//for SSID
		if (!isSSID(objId.val())){
			$('#div_err').show();
			$('#err_msg').html(objMsg+MB_msg_4);
			return false;
		}
	} else {
		if (!isAllChar(objId.val())){
			$('#ppp_err_msg').show();
			$('#ppp_err_msg').html(objMsg+MB_msg_5);
			return false;
		}
	}
	return true;
}

function isIP(str) {
	var re=/^(?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))$/;
	if(!re.test(str)) return 0;
	var buf=str.split(".");
	if(buf[3]<1||buf[3]>254) return 0;
	return 1;
}

function IsValidIP(objId,objMsg) {
	if (objId.val()=="") {
		$('#err_msg').show();
		$('#err_msg').html(objMsg+MB_msg_1);
		objId.focus();
		return false;
	}
	
	if (objId.val().split(".")[0]<1||objId.val().split(".")[0]==127||objId.val().split(".")[0]>223) {
		$('#err_msg').show();
		$('#err_msg').html(objMsg+MB_msg_2);
		objId.focus();
		return false;
	}
	
	if (!isIP(objId.val())){
		$('#err_msg').show();
		$('#err_msg').html(objMsg+MB_msg_2);
		objId.focus();
		return false;
	}
	return true;
}

function IsSameIP(objId_A,objId_B,objMsg) {
	if (objId_A.val()==objId_B.val()) {
		$('#err_msg').show();
		$('#err_msg').html(objMsg+MB_msg_3);
		objId_A.focus();
		return false;
	}
	return true;
}

function SameIp(s1, s2){
	ip1 = s1.replace(/\.\d{1,3}$/,".");
	ip2 = s2.replace(/\.\d{1,3}$/,".");
	if (ip1==ip2) return 0;
	return 1;
}

function isIPMask(str) {
	var re=/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
	if(!re.test(str)) return 0;
	var buf=str.split(".");	
	for(i=0;i<4;i++){
		if(buf[i]<0||buf[i]>255) return 0;
	}
	return 1;
}

function isMask(str) {
	if(!isIPMask(str)) return 0;
	var buf=str.split(".");
	var m0=buf[0],m1=buf[1],m2=buf[2],m3=buf[3];
	if(!(m3==0||m3==128||m3==192||m3==224||m3==240||m3==248||m3==252||m3==254))	return 0;
	if(!(m2==0||m2==128||m2==192||m2==224||m2==240||m2==248||m2==252||m2==254||m2==255)) return 0;
	if(!(m1==0||m1==128||m1==192||m1==224||m1==240||m1==248||m1==252||m1==254||m1==255)) return 0;
	if(!(m0==128||m0==192||m0==224||m0==240||m0==248||m0==252||m0==254||m0==255)) return 0;
	return 1;
}

function IsValidMask(objId,objMsg) {
	if (objId.val()=="") {
		$('#err_msg').show();
		$('#err_msg').html(objMsg+MB_msg_1);
		objId.focus();
		return false;
	}
	
	if (!isMask(objId.val())){
		$('#err_msg').show();
		$('#err_msg').html(objMsg+MB_msg_2);
		objId.focus();
		return false;
	}
	return true;
}

function IsIpSubnet(s1,mn,s2){
	var ip1=s1.split(".");
	var ip2=s2.split(".");
	var ip3=mn.split(".");
	for(var k=0;k<=3;k++){
		if((ip1[k]&ip3[k])!=(ip2[k]&ip3[k])) 			
			return 0;
	}
	return 1;
}
/*------------end--------------*/

function supplyValue(Name,Value){
	var node;
	node= $("#"+Name);
	if(node[0]==undefined)
	 	node=$("input[name="+Name+"]");
	 
	var bigType = node[0].tagName || node.get(0).tagName;
	switch(bigType){
		case 'TD' : {}
		case 'DIV' : {}
		case 'SPAN' : {
			node.html(Value);
			break;
		}
		case 'SELECT' : {
			node.val(Value);
			break;
		}
		case 'INPUT' : {
			var smallType = node[0].type;			
			switch(smallType){
				case 'text':
				case 'hidden':
				case 'password':{
					node.val(Value);
					break;
				}
				case 'radio' : {
					$("input:radio[name="+Name+"][value='"+Value+"']").prop("checked",true);
					break;
				}
				case 'checkbox' : {
					if(Value==1)
					 	node.attr("checked",true); 
					else
					  	node.attr("checked",false); 
					break;
				}
			}
		}
	}
}

function setJSONValue(array_json){
	if(typeof array_json != 'object'){ return false;}
	for(var i in array_json){
		var element = $("#"+i) || $("input[name="+i+"]");
		if(element != null){
			supplyValue(i,array_json[i]);
		}
	}
}

function CreateOptions(nodeName,optionValue,valueArray){
	var Node = document.getElementById(nodeName),valueOptions;
	$('#'+nodeName).empty();
	Node.options.length = 0;
	if(valueArray == undefined){
		valueOptions = optionValue;
	} else {
		valueOptions = valueArray;
	}
	for(var i = 0; i < optionValue.length; i++){
		Node.options[i] = new Option(optionValue[i]);
		Node.options[i].value = valueOptions[i];
	}
}

function addURLTimestamp(url){
	var _url = url;
	if(_url.indexOf('?') == -1){
		_url += '?timestamp=' + (new Date()).getTime();
	}else{
		if(_url.indexOf('timestamp') == -1){
			_url += "&timestamp=" + (new Date()).getTime();
		}else{
			_url=_url.replace(/timestamp=.*/ig,"timestamp=" + (new Date()).getTime());
		}
	}
	return _url;
}

function resetForm(){
	//location=location; 
	location.href=addURLTimestamp(location.href);
}

function gotoUrl(url){
	location.href=url;
}

function myBrowser(){
   	var userAgent = navigator.userAgent;
    var isOpera = userAgent.indexOf("Opera") > -1;
    if (isOpera){
        return "Opera";
    }
    if (userAgent.indexOf("Firefox") > -1){
        return "FF";
    }
    if (userAgent.indexOf("Chrome") > -1){
  		return "Chrome";
 	}
    if (userAgent.indexOf("Safari") > -1){
        return "Safari";
    }
    if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera){
        return "IE";
    }
	if (userAgent.toLowerCase().indexOf("trident") > -1 && userAgent.indexOf("rv") > -1){
		return "IE11";
	}	
}

function addTimestamp(url){
	var _url = url;
	if(_url.indexOf('?') == -1){
		_url += '?timestamp=' + (new Date()).getTime();
	}else{
		if(_url.indexOf('timestamp') == -1)
			_url += "&timestamp=" + (new Date()).getTime();
		else
			_url=_url.replace(/timestamp=.*/ig,"timestamp=" + (new Date()).getTime());
	}
	return _url;
}

var _globalCfg_;
function autoLangFun(){
	var applang=(navigator.language||navigator.browserLanguage||navigator.userLanguage||navigator.systemLanguage).toLowerCase();
    if(applang == "zh-tw"||applang == "zh-hk" || applang == 'zh-hant-tw'){
        applang = "cnt";
    }else if(applang == "zh-cn"||applang == "zh"||applang == "zh-sg"||applang == "zh-hans-cn"){
        applang = "cn";
    }else if(applang == "en"||applang == "en-us"||applang == "en-gb"){
        applang = "en";
    }else if(applang == "vi" || applang == 'vn' || applang == 'vi-vn'){
        applang = "vn";
    }else{
    	applang = "en";
    }
    var postVarBuilt = { "topicurl" : "setting/getLanguageCfg"};
    postVarBuilt = JSON.stringify(postVarBuilt);
	$.ajax({  
       	type : "post",  
        url : "/cgi-bin/cstecgi.cgi",
        data : postVarBuilt,
        async : false,
        success : function(Data){
			var data = JSON.parse(Data);
			_globalCfg_ = data;
			var lang = data.LanguageType;
			var isMultilang = true;
			if(data.MultiLangBuilt){
				if(data.MultiLangBuilt.split(";").length == 1)
					isMultilang = false;
			}
			if(data.autoFlag == "1" && lang != applang && isMultilang){
				lang = applang;
				var postVar = {topicurl : "setting/setLanguageCfg"};
				postVar.autoFlag = "1";
				postVar.langType = applang;
				postVar = JSON.stringify(postVar);
				$.ajax({  
			       	type : "post",  
			        url : " /cgi-bin/cstecgi.cgi",  
			        data : postVar
			   	});	
			}
			document.write("<script language=\"javascript\" src=\"/js/language_"+lang+".js\"></script>");
		}
    });
}

autoLangFun(); //语言自适应
