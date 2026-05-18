<html>
<head>
<title></title>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style/normal_ws.css" rel="stylesheet" type="text/css">
<link href="style/style.css" rel="stylesheet" type="text/css">
<link href="style/line.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="">
<script language="javascript" src="js/jquery.min.js"></script>
<script language="javascript" src="js/json2.min.js"></script>
<script language="javascript" src="js/jcommon.js"></script>
<script language="javascript">
var responseJson;
var v_LanguageType,v_MultiLangSupport,v_HelpBuild,v_fmVersion,v_ProductModel,v_Title;
var v_OperationMode,v_wifiDualband,v_wanConnectionMode,v_wanConnectStatus,v_wanConnectCheck,v_lanip;
var v_l2tpBt,v_pptpBt,v_3gBt;
var v_wanip,v_wanmask,v_wangateway,v_wanpridns,v_wansecdns,v_pptp_server,v_l2tp_server,v_dial3gchoicetype,v_wan_pppoe_user,v_wan_pppoe_pass;
var v_5gWiFiOff,v_5gSSID,v_5gAuthMode,v_5gEncrypType,v_5gKeyType,v_5gWEPKeyStr,v_5gWPAKey;
var v_WiFiOff,v_SSID,v_AuthMode,v_EncrypType,v_KeyType,v_WEPKeyStr,v_WPAKey;

function setValAttr(objectID){
	$("#"+objectID).focus();	
}

function updateConnectionType(){
	$("#div_static_ip, #div_pppoe,#div_pptp,#div_l2tp").hide();
	if ($("#wanConnectionMode").val()=="static")
		$("#div_static_ip").show();
	else if ($("#wanConnectionMode").val()=="pppoe")	
		$("#div_pppoe").show();
	else if ($("#wanConnectionMode").val()=="pptp")
		$("#div_pptp").show();
	else if ($("#wanConnectionMode").val()=="l2tp")
		$("#div_l2tp").show();
}

//5g
function update5gAuthMode(){
	$("#div_wlan_5g_wepkey").hide();
	$("#div_wlan_5g_wpakey").hide();
	if ($('#rai_SELECT_AuthMode').val()=="WPA2PSK"){
		$("#div_wlan_5g_wpakey").show();
		$("#rai_WPAPSK").val(v_5gWPAKey);
	}
}

function update5gWifiRadio(){ 
	if ($('#rai_WiFiOff')[0].selectedIndex == 0){
		$("#div_wlan_5g_ssid").hide();
		$("#div_wlan_5g_authmode").hide();
		$("#div_wlan_5g_wepkey").hide();
		$("#div_wlan_5g_wpakey").hide();
	}else{
		$("#div_wlan_5g_ssid").show();
		$("#div_wlan_5g_authmode").show();
		update5gAuthMode();
	}
}

//2.4g
function updateAuthMode(){
	$("#div_wlan_wepkey").hide();
	//$("#div_wlan_wpakey").hide();
	if ($('#SELECT_AuthMode').val()=="WPA2PSK"){
		$("#div_wlan_wpakey").show();
		$("#WPAPSK").val(v_WPAKey);
	}
}

function updateWifiRadio(){ 
	if ($('#WiFiOff')[0].selectedIndex == 0){
		$("#div_wlan_ssid").hide();
		$("#div_wlan_authmode").hide();
		$("#div_wlan_wepkey").hide();
		$("#div_wlan_wpakey").hide();
	}else{
		$("#div_wlan_ssid").show();
		$("#div_wlan_authmode").show();
		updateAuthMode();
	}
}

function changePasswordType(val){
	if (val==1){
		$("#div_pppoe_pass2").hide();
		$("#div_pppoe_pass3").show();
		setValAttr("wan_pppoe_pass3");
	}
	else if (val==2) {
		$("#div_l2tp_pass2").hide();//p
		$("#div_l2tp_pass3").show();//t
		$("#l2tpPass3").val("");
		$("#l2tpPass3").focus();
	}else if (val==3) {
		$("#div_pptp_pass2").hide();//p
		$("#div_pptp_pass3").show();//t
		$("#pptpPass3").val("");
		$("#pptpPass3").focus();
	}
}

function createWanOptions(flag){
	var new_options,new_values;
	switch(flag){
		case 0:
			new_options = [MM_staticip,"DHCP","PPPoE"];
			new_values  = ['static','dhcp','pppoe'];
			break;
		case 1:
			new_options = [MM_staticip,"DHCP","PPPoE","L2TP","PPTP"];
			new_values  = ['static','dhcp','pppoe','l2tp','pptp'];
			break;
		case 2:
			new_options = [MM_staticip,"DHCP","PPPoE","L2TP"];
			new_values  = ['static','dhcp','pppoe','l2tp'];
			break;
		case 3:
			new_options = [MM_staticip,"DHCP","PPPoE","PPTP"];
			new_values  = ['static','dhcp','pppoe','pptp'];
			break;
		default:
			new_options = [MM_staticip,"DHCP","PPPoE"];
			new_values  = ['static','dhcp','pppoe'];
			break;
	}
	CreateOptions('wanConnectionMode',new_options,new_values);
}

function initValue(){	
	v_wanConnectionMode=responseJson['wanConnectionMode'];
	v_wanConnectStatus=responseJson['wanConnectStatus'];	
	v_lanip=responseJson['lanIp'];
	v_wanip=responseJson['wan_ipaddr'];
	v_wanmask=responseJson['wan_netmask'];
	v_wangateway=responseJson['wan_gateway'];
	v_wanpridns=responseJson['wanDNS1'];
	v_wansecdns=responseJson['wanDNS2'];
	v_wanConnectCheck=responseJson['wanConnectCheck'];

	v_l2tpb=responseJson['l2tpBt'];
	v_pptpb=responseJson['pptpBt'];
	v_l2tpMode      =  responseJson['wan_l2tp_mode'];
	v_l2tp_server   =  responseJson['wan_l2tp_server'];
	v_pptpMode      =  responseJson['wan_pptp_mode'];
	v_pptp_server   =  responseJson['wan_pptp_server'];
	
	v_OperationMode=responseJson['OperationMode'];
	v_wifiDualband=responseJson['wifiDualband'];
	
	v_LanguageType=responseJson['LanguageType'];
	v_MultiLangSupport=responseJson['MultiLangBuilt'];
	v_HelpBuild=responseJson['HelpBuilt'];		
	v_fmVersion=responseJson['fmVersion'];
	v_ProductModel=responseJson['ProductModel'];
	
	//5g
	if(v_wifiDualband==1){
		v_5gWiFiOff=responseJson['rai_WiFiOff'];
		v_5gSSID=responseJson['rai_SSID'];
		v_5gAuthMode=responseJson['rai_AuthMode'];
		v_5gEncrypType=responseJson['rai_EncrypType'];
		v_5gKeyType=responseJson['rai_KeyType'];
		v_5gWEPKeyStr=responseJson['rai_KeyStr'];//wep
		v_5gWPAKey=responseJson['rai_WPAPSK'];//wpa
	}
	
	//2.4g
	v_WiFiOff=responseJson['WiFiOff'];
	v_SSID=responseJson['SSID'];
	v_AuthMode=responseJson['AuthMode'];
	v_EncrypType=responseJson['EncrypType'];
	v_KeyType=responseJson['KeyType'];
	v_WEPKeyStr=responseJson['KeyStr'];//wep
	v_WPAKey=responseJson['WPAPSK'];//wpa
	v_l2tp_server=responseJson['wan_l2tp_server'];

	if (v_l2tpb==1 && v_pptpb==1) 
		createWanOptions(1);
	else if (v_l2tpb==1 && v_pptpb==0) 
		createWanOptions(2); 
	else if (v_l2tpb==0 && v_pptpb==1)
		createWanOptions(3); 
	else
		createWanOptions(0);

	if (v_wanip !="") decomIP($(":input[name=ip]"),v_wanip,1);
	if (v_wanmask !="") decomIP($(":input[name=mask]"),v_wanmask,1);
	if (v_wangateway !="") decomIP($(":input[name=gateway]"),v_wangateway,1);
	if (v_wanpridns !="") decomIP($(":input[name=pridns]"),v_wanpridns,1);
	if (v_wansecdns !="") decomIP($(":input[name=secdns]"),v_wansecdns,1);	
	setJSONValue({
		'wan_pppoe_user'	:	responseJson['wan_pppoe_user'],
		'wan_pppoe_pass2'	:	responseJson['wan_pppoe_pass'],
		'wanConnectionMode'	:	responseJson['wanConnectionMode'],
		
		'l2tpUser'      :   responseJson['wan_l2tp_user'],
		'l2tpPass2'	    :   responseJson['wan_l2tp_pass'],
		'l2tpPass3'	    :   responseJson['wan_l2tp_pass'],
		// 'l2tpServer'    :   decomIP(responseJson['wan_l2tp_server']),

		'pptpUser'      :   responseJson['wan_pptp_user'],
		'pptpPass2'	    :   responseJson['wan_pptp_pass'],
		'pptpPass3'	    :   responseJson['wan_pptp_pass']
	});

	if (v_pptp_server !="") decomIP($(":input[name=pptp_server]"),v_pptp_server,1);
	if (v_l2tp_server !="") decomIP($(":input[name=l2tp_server]"),v_l2tp_server,1);

	updateConnectionType();
	$("#div_pppoe_pass2").show();
	$("#div_pppoe_pass3").hide();
	
	setJSONValue({
		'rai_WiFiOff'	:	responseJson['rai_WiFiOff'],
		'rai_SSID'		:	responseJson['rai_SSID'],
		'WiFiOff'		:	responseJson['WiFiOff'],
		'SSID'			:	responseJson['SSID']
	});
	
	//5g
	if(v_wifiDualband==1){
		if (v_5gEncrypType.split(";")[0]=="NONE")
			$("#rai_SELECT_AuthMode").val("NONE");
		else if (v_5gEncrypType.split(";")[0]=="WEP")
			$("#rai_SELECT_AuthMode").val("NONE");
		else if (v_5gAuthMode.split(";")[0]=="WPAPSK")
			$("#rai_SELECT_AuthMode").val("WPA2PSK");
		else if (v_5gAuthMode.split(";")[0]=="WPA2PSK")
			$("#rai_SELECT_AuthMode").val("WPA2PSK");
		else if (v_5gAuthMode.split(";")[0]=="WPAPSKWPA2PSK")
			$("#rai_SELECT_AuthMode").val("WPA2PSK");
		else
			$("#rai_SELECT_AuthMode").val("NONE");
	}
	update5gAuthMode();
	update5gWifiRadio();
		
	//2.4g
	if(1){
		if (v_EncrypType.split(";")[0]=="NONE")
			$("#SELECT_AuthMode").val("NONE");
		else if (v_EncrypType.split(";")[0]=="WEP")
			$("#SELECT_AuthMode").val("NONE");
		else if (v_AuthMode.split(";")[0]=="WPAPSK")
			$("#SELECT_AuthMode").val("WPA2PSK");
		else if (v_AuthMode.split(";")[0]=="WPA2PSK")
			$("#SELECT_AuthMode").val("WPA2PSK");
		else if (v_AuthMode.split(";")[0]=="WPAPSKWPA2PSK")
			$("#SELECT_AuthMode").val("WPA2PSK");
		else
			$("#SELECT_AuthMode").val("NONE");	
	}
	updateAuthMode();
	//updateWifiRadio();

	if (v_wifiDualband == "1"){
		$("#div_5g_wireless").show();
		$("#div_5g_wireless_name").show();
		$("#div_wireless_name").show();
	}

	v_Title=responseJson['Title'];
 	if(v_Title!="")	top.document.title=v_Title;
		
	var tmp;
	if(v_ProductModel==""){
		tmp = MM_firmware+"  "+v_fmVersion;
	}else{
		tmp = v_ProductModel+"    ("+MM_firmware+"  "+v_fmVersion+")";
	}
	$("#ProductModel").html(tmp);	
	//$("#HelpUrl").attr("href", 'http://'+responseJson['HelpUrl']);
	$("#HelpUrl").attr("href", MM_customer_url);	

	/*if (v_LanguageType == "cn") {
		$("#help").attr("src","style/help_ch_s.gif");
	}
	else if (v_LanguageType == "cnt") {
		$("#help").attr("src","style/help_cnt.gif");
	}
	else if (v_LanguageType == "en") {
		$("#help").attr("src","style/help_eng.gif");
	}*/

	if (v_MultiLangSupport.split(";").length > 1) $("#div_multi_language").show();
	
	if (v_HelpBuild == "1") $("#div_help").show();

	if (v_wanConnectionMode=="static"){
		$("#div_wan_connect_mode").html(MM_staticip+"&nbsp;"+MM_mode);
	}else if (v_wanConnectionMode=="pppoe"){
		$("#div_wan_connect_mode").html("PPPOE"+"&nbsp;"+MM_mode);
	}else if (v_wanConnectionMode=="pptp"){
		$("#div_wan_connect_mode").html("PPTP"+"&nbsp;"+MM_mode);
	}else if (v_wanConnectionMode=="l2tp"){
		$("#div_wan_connect_mode").html("L2TP"+"&nbsp;"+MM_mode);
	}else{
		$("#div_wan_connect_mode").html("DHCP"+"&nbsp;"+MM_mode);
	}

	$("#wanConnectionMode").val(v_wanConnectionMode);

	
	if (v_wanConnectStatus=="MM_disconnected_info1"){
		$("#div_wan_connect_status").html(MM_disconnected_info1);
	}else if (v_wanConnectStatus=="MM_disconnected_info2"){
		$("#div_wan_connect_status").html(MM_disconnected_info2);
	}else if (v_wanConnectStatus=="MM_disconnected_info3"){
		$("#div_wan_connect_status").html(MM_disconnected_info3);
	}else if (v_wanConnectStatus=="MM_disconnected_info4"){
		$("#div_wan_connect_status").html(MM_disconnected_info4);
	}else if (v_wanConnectStatus=="MM_connected"){
		$("#div_wan_connect_status").html(MM_connected);
	}else if (v_wanConnectStatus=="MM_disconnected"){
		$("#div_wan_connect_status").html(MM_disconnected);
	}else if (v_wanConnectStatus=="MM_unknown"){
		$("#div_wan_connect_status").html(MM_unknown);
	}
	
	if(v_wanConnectCheck=="0") $("#wanAutoConBTN").hide();	
	updateConnectionType();

	document.getElementById("div_main").style.height = document.body.offsetHeight-181+"px";
	document.getElementById("div_main").style.height = document.body.clientHeight-181+"px";//for firefox
}

$(function(){
	var postVar = { topicurl : "setting/getEasyWizardCfg"};
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);	
		}
    });
	initValue();
	showLanguageOption();
});

function saveChanges(){	
	$("#wan_ipaddr").val(combinIP($(":input[name=ip]")));
	$("#wan_netmask").val(combinIP($(":input[name=mask]")));
	$("#wan_gateway").val(combinIP($(":input[name=gateway]")));
	$("#wan_primary_dns").val(combinIP($(":input[name=pridns]")));
	$("#wan_secondary_dns").val(combinIP($(":input[name=secdns]")));
	
	setJSONValue({					
		'l2tpServer'	:	combinIP($(":input[name=l2tp_server]")),			
		'pptpServer'	:	combinIP($(":input[name=pptp_server]"))
	});
	
	var wanConnectionMode = $("#wanConnectionMode").val();
	if (wanConnectionMode == "static") {
		if (!checkVaildVal.IsVaildIpAddr($("#wan_ipaddr").val(), MM_ipaddr)) return false;  
		if (!checkVaildVal.IsSameIp($("#wan_ipaddr").val(), v_lanip)){alert(JS_msg44);return false;}
		if (!checkVaildVal.IsVaildMaskAddr($("#wan_netmask").val(), MM_netmask)) return false;
		if (!checkVaildVal.IsVaildIpAddr($("#wan_gateway").val(), MM_default_gateway)) return false;   
		if (!checkVaildVal.IsIpSubnet($("#wan_gateway").val(), $("#wan_netmask").val(), $("#wan_ipaddr").val())){alert(JS_msg45);return false;}		
		if ($("#wan_gateway").val() == $("#wan_ipaddr").val()){alert(JS_msg46);return false;}
		if (!checkVaildVal.IsVaildIpAddr($("#wan_primary_dns").val(), MM_pridns)) return false;  
		if ($("#wan_secondary_dns").val() != ""){if(!checkVaildVal.IsVaildIpAddr($("#wan_secondary_dns").val(), MM_secdns)) return false;}
	}else if (wanConnectionMode == "pppoe") {
		if ($("#wan_pppoe_pass3").val()=="") supplyValue("wan_pppoe_pass3",$("#wan_pppoe_pass2").val());
		if (!checkVaildVal.IsVaildString($("#wan_pppoe_user").val(), MM_username,1)){setValAttr("wan_pppoe_user");return false;}
		if (!checkVaildVal.IsVaildString($("#wan_pppoe_pass3").val(), MM_password,1)){setValAttr("wan_pppoe_pass3");return false;}
		supplyValue("wan_pppoe_pass",$("#wan_pppoe_pass3").val());
	}else if (wanConnectionMode == "pptp") {
		if ($("#pptpPass3").val()=="") supplyValue("pptpPass3",$("#pptpPass").val());
		if (!checkVaildVal.IsVaildString($("#pptpUser").val(), MM_username,1)){setValAttr("pptpUser");return false;}
		if (!checkVaildVal.IsVaildString($("#pptpPass3").val(), MM_password,1)){setValAttr("pptpPass3");return false;}
		supplyValue("pptpPass",$("#pptpPass3").val());
		if (!checkVaildVal.IsVaildIpAddr($("#pptpServer").val(), "PPTP "+MM_server_ipaddr))return false;
	}else if (wanConnectionMode == "l2tp") {
		if ($("#l2tpPass3").val()=="") supplyValue("l2tpPass3",$("#l2tpPass").val());
		if (!checkVaildVal.IsVaildString($("#l2tpUser").val(), MM_username,1)){setValAttr("l2tpUser");return false;}
		if (!checkVaildVal.IsVaildString($("#l2tpPass3").val(), MM_password,1)){setValAttr("l2tpPass3");return false;}
		supplyValue("l2tpPass",$("#l2tpPass3").val());
		if (!checkVaildVal.IsVaildIpAddr($("#l2tpServer").val(),"L2TP" + MM_server_ipaddr))return false;
	}
	
	//5g
	if (v_wifiDualband == 1) {
		if ($('#rai_WiFiOff')[0].selectedIndex == 1){	
			if (!checkVaildVal.IsVaildSSID($("#rai_SSID").val(), MM_ssid)) return false;
	
			//var rai_SELECT_AuthMode     = $('#rai_SELECT_AuthMode').val();
			//var rai_KeyStr         	 	= $('#rai_KeyStr').val();
			var rai_WPAPSK         	 	= $('#rai_WPAPSK').val();
			
			if (rai_WPAPSK.length < 8 || rai_WPAPSK.length > 63){alert(JS_msg24);return false;}
			setJSONValue({
				"rai_AuthMode"     : "WPAPSKWPA2PSK",
				"rai_EncrypType"   : "AES",
				"rai_KeyType"      : "1"
			});
	
			/*if (rai_SELECT_AuthMode == "WEP"){
				if (rai_KeyStr.length != 10){alert(JS_msg21);return false;}				
				if (!checkVaildVal.IsVaildWiFiPass(rai_KeyStr, MM_wepkey, "hex")) return false;
				
				setJSONValue({
					"rai_AuthMode"     : "OPEN",
					"rai_EncrypType"   : "WEP"
				});

				if(!confirm(JS_msg26)){
					return false;
				}else{
					v_WscEabled="0";
				}
			}else if (rai_SELECT_AuthMode == "WPAPSK" || rai_SELECT_AuthMode == "WPA2PSK" || rai_SELECT_AuthMode == "WPAPSKWPA2PSK"){
				if (rai_WPAPSK.length < 8 || rai_WPAPSK.length > 63){alert(JS_msg24);return false;}
				if (!checkVaildVal.IsVaildWiFiPass(rai_WPAPSK, MM_wpakey, "ascii")) return false;
							
				setJSONValue({
					"rai_AuthMode"     : rai_SELECT_AuthMode,
					"rai_EncrypType"   : "AES",
					"rai_KeyType"      : "1"
				});
			}else{
				setJSONValue({
					"rai_AuthMode"     : "NONE",
					"rai_EncrypType"   : "NONE",
					"rai_KeyType"      : "0"
				});
			}*/
		}
		else {
			setJSONValue({
				"rai_AuthMode"     : v_5gAuthMode,
				"rai_EncrypType"   : v_5gEncrypType,
				"rai_KeyType" 	   : v_5gKeyType,
				"rai_KeyStr"       : v_5gWEPKeyStr,
				"rai_WPAPSK"	   : v_5gWPAKey,
				"rai_SSID"		   : v_5gSSID
		   });
		}
		
		$("#dualband").val("1");
	}
	
	//2.4g
	if ($('#WiFiOff')[0].selectedIndex == 1){	
		if (!checkVaildVal.IsVaildSSID($("#SSID").val(), MM_ssid)) return false;
		
		//var SELECT_AuthMode     = $('#SELECT_AuthMode').val();
		//var KeyStr         	 	= $('#KeyStr').val();
		var WPAPSK         	 	= $('#WPAPSK').val();
		if (WPAPSK.length < 8 || WPAPSK.length > 63){alert(JS_msg24);return false;}
		setJSONValue({
			"AuthMode"     : "WPAPSKWPA2PSK",
			"EncrypType"   : "AES",
			"KeyType" 	   : "1"
		});
		
		/*if (SELECT_AuthMode == "WEP"){
			if (KeyStr.length != 10){alert(JS_msg21);return false;}				
			if (!checkVaildVal.IsVaildWiFiPass(KeyStr, MM_wepkey, "hex")) return false;
			
			setJSONValue({
				"AuthMode"     : "OPEN",
				"EncrypType"   : "WEP",
				"KeyType" 	   : "0"
			});
			
			if(!confirm(JS_msg26)){
				return false;
			}else{
				v_WscEabled="0";
			}
		}else if (SELECT_AuthMode == "WPAPSK" || SELECT_AuthMode == "WPA2PSK" || SELECT_AuthMode == "WPAPSKWPA2PSK"){
			if (WPAPSK.length < 8 || WPAPSK.length > 63){alert(JS_msg24);return false;}
			if (!checkVaildVal.IsVaildWiFiPass(WPAPSK, MM_wpakey, "ascii")) return false;		
			setJSONValue({
				"AuthMode"     : SELECT_AuthMode,
				"EncrypType"   : "AES",
				"KeyType" 	   : "1"
			});
		}else{		
			setJSONValue({
				"AuthMode"     : "NONE",
				"EncrypType"   : "NONE",
				"KeyType"      : "0"
			});
		}*/
	}
	else {	
		setJSONValue({
			"AuthMode"     : v_AuthMode,
			"EncrypType"   : v_EncrypType,
			"KeyType" 	   : v_KeyType,
			"KeyStr"       : v_WEPKeyStr,
			"WPAPSK"	   : v_WPAKey,
			"SSID"		   : v_SSID
		});
	}
	return true;
}

function doSubmit(){	
	if (saveChanges()==false)
		return false;	
	
	var postVar = {"topicurl":"setting/setEasyWizard"};
	postVar['wanConnectionMode'] = $('#wanConnectionMode').val();
	postVar['wan_ipaddr'] = $('#wan_ipaddr').val();
	postVar['wan_netmask'] = $('#wan_netmask').val();
	postVar['wan_gateway'] = $('#wan_gateway').val();
	postVar['wan_primary_dns'] = $('#wan_primary_dns').val();
	postVar['wan_secondary_dns'] = $('#wan_secondary_dns').val();
	postVar['wan_pppoe_user'] = $('#wan_pppoe_user').val();
	postVar['wan_pppoe_pass'] = $('#wan_pppoe_pass').val();
	
	postVar['pptpServer']=$('#pptpServer').val();
	postVar['pptpUser']=$("#pptpUser").val();
	postVar['pptpPass']=$('#pptpPass3').val();
	postVar['l2tpServer']=$('#l2tpServer').val();
	postVar['l2tpUser']=$("#l2tpUser").val();
	postVar['l2tpPass']=$('#l2tpPass3').val();

	//5g
	if (v_wifiDualband == 1) {
		postVar['rai_WiFiOff'] = $('#rai_WiFiOff').val();
		postVar['rai_SSID'] = $('#rai_SSID').val();
		postVar['rai_AuthMode'] = $('#rai_AuthMode').val();
		postVar['rai_EncrypType'] = $('#rai_EncrypType').val();
		postVar['rai_KeyType'] = $('#rai_KeyType').val();
		postVar['rai_KeyStr'] = $('#rai_KeyStr').val();
		postVar['rai_WPAPSK'] = $('#rai_WPAPSK').val();
	}
	//2.4g
	postVar['WiFiOff'] = $('#WiFiOff').val();
	postVar['SSID'] = $('#SSID').val();
	postVar['AuthMode'] = $('#AuthMode').val();
	postVar['EncrypType'] = $('#EncrypType').val();
	postVar['KeyType'] = $('#KeyType').val();
	postVar['KeyStr'] = $('#KeyStr').val();
	postVar['WPAPSK'] = $('#WPAPSK').val();
	postVar['dualband'] = $('#dualband').val();
	
	uiPost2(postVar);
}

function waitpage(){
	$("#div_wizard_setting").hide();
	$("#div_wait").show();
}

var lanip='',wtime=0;
function uiPost2(postVar){
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		var responseJson = JSON.parse(Data);
		lanip=responseJson['lan_ip'];
		wtime=responseJson['wtime'];
		waitpage();
		do_count_down2();
	});
}

function do_count_down2(){
	document.getElementById("show_sec").innerHTML = wtime;
	if(wtime == 0) {parent.location.href='http://'+lanip+'/wizard_connect_state.asp'; return false;}
	if(wtime > 0) {wtime--;setTimeout('do_count_down2()',1000);}
}

function uiPost3(postVar){
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		var responseJson = JSON.parse(Data);
		lanip=responseJson['lan_ip'];
		wtime=responseJson['wtime'];
		waitpage();
		do_count_down3();
	});
}

function do_count_down3(){
	document.getElementById("show_sec").innerHTML = wtime;
	if(wtime == 0) {parent.location.href='http://'+lanip+'/portal.asp'; return false;}
	if(wtime > 0) {wtime--;setTimeout('do_count_down3()',1000);}
}

function clickAdvanced(){window.location.href="/home.asp?timestamp="+(new Date()).valueOf();}

var conresponseJson;
function wanAutoConnect(){
	$("#wanAutoConBTN").attr('disabled',true);
	$(":input").attr('disabled',true);
	var postVar = { topicurl : "setting/connectAutoCheck"};
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
				conresponseJson = JSON.parse(Data);										
		}
    });	
	initWanConnect();
}

function initWanConnect(){
	var wanType=conresponseJson['reserv'];
	$("#wanPortStatus").html("");
	if(/static/ig.test(wanType))
		supplyValue("wanConnectionMode","static");
	else if(/dhcp/ig.test(wanType))
		supplyValue("wanConnectionMode","dhcp");
	else if(/pppoe/ig.test(wanType))
		supplyValue("wanConnectionMode","pppoe");
	else if(/linkDown/ig.test(wanType))
		$("#wanPortStatus").html(MM_wan_connect_status);
	else
		supplyValue("wanConnectionMode","static");

	updateConnectionType();
	$("#wanAutoConBTN").attr('disabled',false);
	$(":input").attr('disabled',false);
}
</script>
</head>
<body style="overflow-x:hidden">
<div id="div_wizard_setting">
<form method=post>
<input type="hidden" name="dualband" id="dualband" value="0">
<table height="96" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="top_left">&nbsp;</td>
<td class="top_center">&nbsp;</td>
<td class="top_right" align="right">&nbsp;</td>
</tr>
</table>

<table height="44" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td class="first_table"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="title_down_left" id="ProductModel"></td>
<td class="title_down_center">&nbsp;</td>
<td class="title_down_right" align="right"><span id="div_multi_language" style="display:none"><select id="languageOption"></select>&nbsp;&nbsp;</span>
<span id="div_help" style="display:none"><a id="HelpUrl" href="http://www.totolink.cn" target="_blank" style="position: relative;"><img id="help" src="../style/help_custom.gif" border="0" align="absmiddle"><span style="position: absolute;right: 12px;bottom:-2px;color: #fff;font-weight: bold;"><script>dw(MM_help)</script></span></a></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table></td>
<td width="6"></td>
</tr>
</table>

<table id="div_main" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td valign="top" class="first_table">
<table border=0 width="700" align="center">
<tr><td colspan="2" height="45"></td></tr>
<tr><td colspan="2" class="content_title"><script>dw(MM_wizard)</script></td></tr>
<tr>
<td class="content_help"><script>dw(MSG_wizard)</script></td>
<td align="right"><script>dw('<input type=button class=button_big value="'+BT_advanced_setup+'" onClick="clickAdvanced()">')</script></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<div align="center">
<div id="div_router_setting">
<br><br>
<fieldset>
<legend><script>dw(MM_connection_status)</script></legend>
<table border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_connection_status)</script></td>
<td>&nbsp;&nbsp;<span id="div_wan_connect_mode"></span>&nbsp;&nbsp;<span style="color:#ff0000" id="div_wan_connect_status"></span></td>
</tr>
</table>
</fieldset>
<br><br>

<fieldset>
<legend><script>dw(MM_internet_setting)</script></legend>
<table border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2">WAN <script>dw(MM_connection_type)</script></td>
<td>&nbsp;&nbsp;<select id="wanConnectionMode" name="wanConnectionMode" onChange="updateConnectionType()">
</select><script>dw('&nbsp;&nbsp;&nbsp;<input type=button style="cursor:pointer" id=wanAutoConBTN value="'+BT_wanAutoConnect+'" onClick="wanAutoConnect();">')</script>
&nbsp;&nbsp;&nbsp;<label id="wanPortStatus" style="color: red;"></label>
</td>
</tr>
</table>

<table id="div_static_ip" style="display:none" border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ipaddr)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="wan_ipaddr" name="wan_ipaddr">
<input type="text" style="width:33px" maxlength="3" id="ip1" name="ip" onKeyDown="return ipVali(event,this.name,0);" >. 
<input type="text" style="width:33px" maxlength="3" id="ip2" name="ip" onKeyDown="return ipVali(event,this.name,1);" >. 
<input type="text" style="width:33px" maxlength="3" id="ip3" name="ip" onKeyDown="return ipVali(event,this.name,2);" >. 
<input type="text" style="width:33px" maxlength="3" id="ip4" name="ip" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_netmask)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="wan_netmask" name="wan_netmask">
<input type="text" style="width:33px" maxlength="3" id="mask1" name="mask" onKeyDown="return ipVali(event,this.name,0);" >.
<input type="text" style="width:33px" maxlength="3" id="mask2" name="mask" onKeyDown="return ipVali(event,this.name,1);" >. 
<input type="text" style="width:33px" maxlength="3" id="mask3" name="mask" onKeyDown="return ipVali(event,this.name,2);" >. 
<input type="text" style="width:33px" maxlength="3" id="mask4" name="mask" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_default_gateway)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="wan_gateway" name="wan_gateway">
<input type="text" style="width:33px" maxlength="3" id="gateway1" name="gateway" onKeyDown="return ipVali(event,this.name,0);" >. 
<input type="text" style="width:33px" maxlength="3" id="gateway2" name="gateway" onKeyDown="return ipVali(event,this.name,1);" >. 
<input type="text" style="width:33px" maxlength="3" id="gateway3" name="gateway" onKeyDown="return ipVali(event,this.name,2);" >. 
<input type="text" style="width:33px" maxlength="3" id="gateway4" name="gateway" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_pridns)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="wan_primary_dns" name="wan_primary_dns">
<input type="text" style="width:33px" maxlength="3" id="pridns1" name="pridns" onKeyDown="return ipVali(event,this.name,0);" >. 
<input type="text" style="width:33px" maxlength="3" id="pridns2" name="pridns" onKeyDown="return ipVali(event,this.name,1);" >. 
<input type="text" style="width:33px" maxlength="3" id="pridns3" name="pridns" onKeyDown="return ipVali(event,this.name,2);" >. 
<input type="text" style="width:33px" maxlength="3" id="pridns4" name="pridns" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_secdns)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="wan_secondary_dns" name="wan_secondary_dns">
<input type="text" style="width:33px" id="secdns1" maxlength="3" name="secdns" onKeyDown="return ipVali(event,this.name,0);" >. 
<input type="text" style="width:33px" maxlength="3" id="secdns2" name="secdns" onKeyDown="return ipVali(event,this.name,1);" >. 
<input type="text" style="width:33px" maxlength="3" id="secdns3" name="secdns" onKeyDown="return ipVali(event,this.name,2);" >. 
<input type="text" style="width:33px" maxlength="3" id="secdns4" name="secdns" onKeyDown="return ipVali(event,this.name,3);" >(<script>dw(MM_optional)</script>)</td>
</tr>
</table>

<table id="div_pppoe" style="display:none" border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_username)</script></td>
<td>&nbsp;&nbsp;<input type="text" id="wan_pppoe_user" name="wan_pppoe_user" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_password)</script></td>
<td><input type="hidden" id="wan_pppoe_pass" name="wan_pppoe_pass">
<span id="div_pppoe_pass2">&nbsp;&nbsp;<input type="password" id="wan_pppoe_pass2" name="wan_pppoe_pass2" maxlength="32" onFocus="changePasswordType(1)"></span>
<span id="div_pppoe_pass3" style="display:none">&nbsp;&nbsp;<input type="text" id="wan_pppoe_pass3" name="wan_pppoe_pass3" maxlength="32"></span></td>
</tr>
</table>

<table id="div_l2tp" style="display:none" border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_server_ipaddr)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="l2tpServer" name="l2tpServer">
<input type="text" style="width:33px" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,0);" >. 
<input type="text" style="width:33px" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,1);" >. 
<input type="text" style="width:33px" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,2);" >. 
<input type="text" style="width:33px" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_username)</script></td>
<td>&nbsp;&nbsp;<input type="text"id="l2tpUser" name="l2tpUser" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_password)</script></td>
<td><input type="hidden" id="l2tpPass" name="l2tpPass">
<span id="div_l2tp_pass2">&nbsp;&nbsp;<input type=password id="l2tpPass2" name="l2tpPass2" maxlength="32" onFocus="changePasswordType(2)"></span>
<span id="div_l2tp_pass3" style="display:none">&nbsp;&nbsp;<input type=text id="l2tpPass3" name="l2tpPass3" maxlength="32"></span></td>
</tr>
</table>

<table id="div_pptp" style="display:none" border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_server_ipaddr)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="pptpServer" name="pptpServer">
<input type="text" style="width:33px" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,0);" >. 
<input type="text" style="width:33px" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,1);" >. 
<input type="text" style="width:33px" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,2);" >. 
<input type="text" style="width:33px" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_username)</script></td>
<td>&nbsp;&nbsp;<input type="text" id="pptpUser" name="pptpUser" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_password)</script></td>
<td><input type="hidden" id="pptpPass" name="pptpPass">
<span id="div_pptp_pass2">&nbsp;&nbsp;<input type=password id="pptpPass2" name="pptpPass2" maxlength="32" onFocus="changePasswordType(3)"></span>
<span id="div_pptp_pass3" style="display:none">&nbsp;&nbsp;<input type=text id="pptpPass3" name="pptpPass3" maxlength="32"></span></td>
</tr>
</table>

</fieldset>

<span id="div_5g_wireless" style="display:none">
<br><br>
<fieldset>
<legend><span id="div_5g_wireless_name" style="display:none">5G</span> <script>dw(MM_wireless_setting)</script></legend>
<input type="hidden" name="rai_AuthMode" id="rai_AuthMode">
<input type="hidden" name="rai_EncrypType" id="rai_EncrypType">
<input type="hidden" name="rai_KeyType" id="rai_KeyType">
<table border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_radio_onoff)</script></td>
<td>&nbsp;&nbsp;<select id="rai_WiFiOff" name="rai_WiFiOff" onChange="update5gWifiRadio()">
<option value="1"><script>dw(MM_disable)</script></option>
<option value="0"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="div_wlan_5g_ssid">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ssid)</script></td>
<td>&nbsp;&nbsp;<input type="text" id="rai_SSID" name="rai_SSID" size="32" maxlength="32"></td>
</tr>
<tr id="div_wlan_5g_authmode">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_security_mode)</script></td>					 
<td>&nbsp;&nbsp;<select id="rai_SELECT_AuthMode" name="rai_SELECT_AuthMode" onChange="update5gAuthMode();">
<option value="NONE"><script>dw(MM_none_security)</script></option>
<option value="WPA2PSK">WPA2-PSK</option>
</select></td>
</tr>
<tr id="div_wlan_5g_wepkey" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_key)</script></td>
<td>&nbsp;&nbsp;<input type="text" id="rai_KeyStr" name="rai_KeyStr" maxlength="10"></td>
</tr>
<tr id="div_wlan_5g_wpakey" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_key)</script></td>
<td>&nbsp;&nbsp;<input type="text" id="rai_WPAPSK" name="rai_WPAPSK" size="32" maxlength="63"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td colspan="2" align="center"><script>dw(MB_pwd_length)</script></td>
</tr>
</table>
</fieldset>
</span>

<br><br>
<fieldset>
<legend><span id="div_wireless_name" style="display:none">2.4G</span> <script>dw(MM_wireless_setting)</script></legend>
<input type="hidden" name="AuthMode" id="AuthMode">
<input type="hidden" name="EncrypType" id="EncrypType">
<input type="hidden" name="KeyType" id="KeyType">
<table border=0 width="100%">
<tr style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_radio_onoff)</script></td>
<td>&nbsp;&nbsp;<select id="WiFiOff" name="WiFiOff" onChange="updateWifiRadio()">
<option value="1"><script>dw(MM_disable)</script></option>
<option value="0"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="div_wlan_ssid">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ssid)</script></td>
<td>&nbsp;&nbsp;<input type="text" id="SSID" name="SSID" size="32" maxlength="32"></td>
</tr>
<tr id="div_wlan_authmode" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_security_mode)</script></td>					 
<td>&nbsp;&nbsp;<select id="SELECT_AuthMode" name="SELECT_AuthMode" onChange="updateAuthMode();">
<option value="NONE"><script>dw(MM_none_security)</script></option>
<option value="WPA2PSK">WPA2-PSK</option>
</select></td>
</tr>
<tr id="div_wlan_wepkey" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_key)</script></td>
<td>&nbsp;&nbsp;<input type="text" id="KeyStr" name="KeyStr" maxlength="10"></td>
</tr>
<tr id="div_wlan_wpakey">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_key)</script></td>
<td>&nbsp;&nbsp;<input type="text" id="WPAPSK" name="WPAPSK" size="32" maxlength="63"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td colspan="2" align="center"><script>dw(MB_pwd_length)</script></td>
</tr>
</table>
</fieldset>
</div>
</div>

<table border=0 width="700" align="center">
<tr><td height="10"></td></tr>
<tr>
<td class="content_help">&nbsp;</td>
<td align="right"><script>dw('<input type=button class=button_big value="'+BT_apply+'" name="save" onClick="doSubmit()">')</script></td>
</tr>
</table>
</td>
<td width="6"></td>
</tr>
</table>

<table height="41" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bottom_left">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_center1">
<script>
	var curDate = new Date();
	dw(MM_Copyright_Left)+document.write(curDate.getFullYear())+dw(MM_Copyright_Right);
</script>
</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_right">&nbsp;</td>
</tr>
</table>
</form>

</div>

<div id="div_wait" style="display:none">
<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
<center>
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_change_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><script>dw(JS_msg75)</script></td></tr>
<tr><td><script>dw(MM_please_wait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table></td></tr></table>
</center>
</div>
</body>
</html>
