<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/menu.css" type="text/css">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript">
var responseJson;
var v_Opmode,v_WiFiOff,v_WirelessMode,v_Channel,v_CountryCode,v_HT_BW;
var v_SSID,v_HideSSID,v_AuthMode,v_EncrypType,v_KeyType,v_KeyStr,v_WPAPSK;
var v_wscBt,v_WscEabled,v_only5G,v_vlanid,v_countryCodeBt;
var v_ScheduleEn_wifi;
ChannelList_24G = new Array(14);
ChannelList_24G[0] = "1";
ChannelList_24G[1] = "2";
ChannelList_24G[2] = "3";
ChannelList_24G[3] = "4";
ChannelList_24G[4] = "5";
ChannelList_24G[5] = "6";
ChannelList_24G[6] = "7";
ChannelList_24G[7] = "8";
ChannelList_24G[8] = "9";
ChannelList_24G[9] = "10";
ChannelList_24G[10] = "11";
ChannelList_24G[11] = "12";
ChannelList_24G[12] = "13";
ChannelList_24G[13] = "14";

var HT5GExtCh = new Array(22);
HT5GExtCh[0] = new Array(1, "40"); // channel 36's extension channel
HT5GExtCh[1] = new Array(0, "36"); // channel 40's
HT5GExtCh[2] = new Array(1, "48"); // channel 44's
HT5GExtCh[3] = new Array(0, "44"); // channel 48's
HT5GExtCh[4] = new Array(1, "56"); // channel 52's
HT5GExtCh[5] = new Array(0, "52"); // channel 56's
HT5GExtCh[6] = new Array(1, "64"); // channel 60's
HT5GExtCh[7] = new Array(0, "60"); // channel 64's
HT5GExtCh[8] = new Array(1, "104"); // channel 100's
HT5GExtCh[9] = new Array(0, "100"); // channel 104's
HT5GExtCh[10] = new Array(1, "112"); // channel 108's
HT5GExtCh[11] = new Array(0, "108"); // channel 112's
HT5GExtCh[12] = new Array(1, "120"); // channel 116's
HT5GExtCh[13] = new Array(0, "116"); // channel 120's
HT5GExtCh[14] = new Array(1, "128"); // channel 124's
HT5GExtCh[15] = new Array(0, "124"); // channel 128's
HT5GExtCh[16] = new Array(1, "136"); // channel 132's
HT5GExtCh[17] = new Array(0, "132"); // channel 136's
HT5GExtCh[18] = new Array(1, "153"); // channel 149's
HT5GExtCh[19] = new Array(0, "149"); // channel 153's
HT5GExtCh[20] = new Array(1, "161"); // channel 157's
HT5GExtCh[21] = new Array(0, "157"); // channel 161's

function CreateCountryCode(){
 	var new_options,new_values;
/*
	if(WiFiIdx == 0){
		new_options = [MM_usa,MM_japan,MM_france,MM_taiwan,MM_brazil,MM_china,MM_china];
		new_values  = ['US','JP','FR','TW','BR','CN','IR'];
	}else{	
		new_options = [MM_usa,MM_japan,MM_france,MM_taiwan,MM_brazil,MM_china,MM_china];
		new_values  = ['US','JP','FR','TW','BR','CN','IR'];	
	}
*/
	if("CUSTOM_810R_EN" == responseJson['CUSTOM'])
	{
		if(WiFiIdx == 0){
		new_options = [MM_usa,MM_china_europe,MM_other];
		new_values  = ['US','CN','AU'];
		}else{	
			new_options = [MM_usa,MM_china_europe,MM_other];
			new_values  = ['US','CN','AU'];	
		}
	}
	else
	{
		if(WiFiIdx == 0){
			new_options = [MM_usa_canada,MM_china_europe,MM_japan];
			new_values  = ['US','CN','JP'];
		}else{	
			new_options = [MM_usa_canada,MM_china_europe,MM_japan];
			new_values  = ['US','CN','JP'];	
		}
	}
	
 	CreateOptions('CountryCode',new_options,new_values);
}
 
function CreateWirelessMode(){	
	var new_options,new_values;
	
	if(v_only5G == "1"){
		new_options = ['802.11A','802.11A/N','802.11A/N/AC'];
		new_values  = ['2','8','14'];
	}
	else{
		if(WiFiIdx == "0"){
			new_options = ['2.4 GHz (B)','2.4 GHz (G)','2.4 GHz (B+G+N)'];
			new_values  = ['1','4','9'];
		}else{	
			new_options = ['802.11A','802.11A/N','802.11A/N/AC'];
			new_values  = ['2','8','14'];		
		}
	}
	CreateOptions("WirelessMode",new_options,new_values);
}

function CreateEncrypType(){
	var new_options,new_values;
	switch($("#security_mode").val()){
		case "NONE":
			new_values  = ["NONE"];
			new_options = [MM_disable];
			break;
		case "OPEN":
		case "SHARED":
			new_values  = ["WEP64","WEP128"];
			new_options = ["WEP64","WEP128"];
			break;
		case "WPAPSK":
			new_values  = ["TKIP","AES"];
			new_options = ["TKIP","AES"];
			break;
		default:
			new_values  = ["TKIP","AES","TKIPAES"];
			new_options = ["TKIP","AES","TKIP/AES"];
			break;
	}
	CreateOptions('encryp_type', new_options, new_values);
}

function CreateAuthMode(){
	var new_values, new_options;
	new_values  = ['NONE','OPEN','SHARED','WPAPSK','WPA2PSK','WPAPSKWPA2PSK'];
	new_options = [MM_disable,'WEP-'+MM_open_system,'WEP-'+MM_shared_key, 'WPA-PSK','WPA2-PSK','WPA/WPA2-PSK'];
	CreateOptions('security_mode', new_options, new_values);
}

function updateAuthMode(){
	$("#div_encryp_type, #div_key_format, #div_wep_key, #div_wpa_key").hide();
	$("#KeyStr, #WPAPSK").attr("disabled", true);

	CreateEncrypType();
	
	var auth=$("#security_mode").val();	
	switch(auth){
		case "NONE":
			supplyValue("encryp_type", "NONE");
			break;
		case "OPEN":
		case "SHARED":
			$("#div_encryp_type, #div_key_format, #div_wep_key").show();
			$("#KeyStr").attr("disabled", false);	
				
			setJSONValue({
				"encryp_type"  : "WEP64",
				"key_format"   : "1",
				"KeyStr"       : ""
			});
			updateEncrypType();
			break;
		default:
			$("#div_encryp_type, #div_key_format, #div_wpa_key").show();
			$("#WPAPSK").attr("disabled", false);
			
			if(auth=="WPAPSK"){
				supplyValue("encryp_type","AES");
			}else if(auth=="WPA2PSK"){
				supplyValue("encryp_type","AES");
			}else{
				supplyValue("encryp_type","TKIPAES");
			}
			supplyValue("key_format","1");
			supplyValue("WPAPSK","");
			updateEncrypType();
			break;
	}
}

function updateKeyFormat(){
	var security_mode = $('#security_mode')[0].selectedIndex;
	var encryp_type = $('#encryp_type')[0].selectedIndex;
	var key_format = $('#key_format')[0].selectedIndex;
	
	if (security_mode == 1 || security_mode == 2){
		if (encryp_type == 0){
			if (key_format == 0)
				$("#KeyStr").attr("maxlength", 10);
			else
				$("#KeyStr").attr("maxlength", 5);
		}else{
			if (key_format == 0)
				$("#KeyStr").attr("maxlength", 26);
			else
				$("#KeyStr").attr("maxlength", 13);
		}			
	}else{
		if (key_format == 0)
			$("#WPAPSK").attr("maxlength", 64);
		else
			$("#WPAPSK").attr("maxlength", 63);
	}
}

function updateEncrypType(){
	updateKeyFormat();
}

function setAuthMode(){
	if (v_AuthMode=="NONE"){
		supplyValue("security_mode", "NONE");
	}else{
		supplyValue("security_mode", v_AuthMode);
	}

	$("#div_encryp_type, #div_key_format, #div_wep_key, #div_wpa_key").hide();
	$("#KeyStr, #WPAPSK").attr("disabled", true);
	CreateEncrypType();
	setEncrypType();
}

function setEncrypType(){
	switch($("#security_mode").val()){
		case "NONE":
			supplyValue("encryp_type", "NONE");
			break;
		case "OPEN":
		case "SHARED":
			$("#div_encryp_type, #div_key_format, #div_wep_key").show();
			$("#KeyStr").attr("disabled", false);			
			if (v_KeyStr.length==5||v_KeyStr.length==10)
				supplyValue("encryp_type", "WEP64");
			else
				supplyValue("encryp_type", "WEP128");		
			supplyValue("key_format",v_KeyType);
			if ($('#key_format')[0].selectedIndex==0)
				supplyValue("KeyStr",v_KeyStr.toLowerCase());	
			else
				supplyValue("KeyStr",v_KeyStr);
			updateEncrypType();
			break;
		default:
			$("#div_encryp_type, #div_key_format, #div_wpa_key").show();
			$("#WPAPSK").attr("disabled", false);
			supplyValue("encryp_type",v_EncrypType);			
			supplyValue("key_format",v_KeyType);
			if ($('#key_format')[0].selectedIndex==0)
				supplyValue("WPAPSK",v_WPAPSK.toLowerCase());
			else
				supplyValue("WPAPSK",v_WPAPSK);
			updateEncrypType();
			break;
	}
}

function CreateChannel(){
	var new_options,new_values;
	var CountryCode=$("#CountryCode").val();
	if(v_only5G == "1")
	{
		switch(CountryCode){	
			case 'BR':
				new_options = [MM_auto_select,'36','40','44','48','52','56','60','64','149','153','157','161','165'];
				new_values  = ['0','36','40','44','48','52','56','60','64','149','153','157','161','165'];
				break;
			case 'CN':
			case 'IR':
				new_options = [MM_auto_select,'149','153','157','161','165'];
				new_values  = ['0','149','153','157','161','165'];
				break;
			case 'FR':
				new_options = [MM_auto_select,'36','40','44','48','52','56','60','64'];
				new_values  = ['0','36','40','44','48','52','56','60','64'];
				break;
			case 'JP':
				new_options = [MM_auto_select,'36','40','44','48'];
				new_values  = ['0','36','40','44','48'];
				break;
			case 'AU':
				new_options = [MM_auto_select,'36','40','44','48','52','56','60','64','100','104','108','112','116','120','124','128','132','136','140','149','153','157','161','165'];
				new_values  = ['36','40','44','48','52','56','60','64','100','104','108','112','116','120','124','128','132','136','140','149','153','157','161','165'];
				break;
			case 'TW':
				new_options = [MM_auto_select,'52','56','60','64'];
				new_values  = ['0','52','56','60','64'];
				break;
			case 'US':
			default:
				new_options = [MM_auto_select,'36','40','44','48','52','56','60','64','100','104','108','112','116','120','124','128','132','136','140','149','153','157','161','165'];
				new_values  = ['0','36','40','44','48','52','56','60','64','100','104','108','112','116','120','124','128','132','136','140','149','153','157','161','165'];
				break;
		}
	}
	else{
		if(WiFiIdx == "0"){
			switch(CountryCode){
				case 'FR':
				case 'BR':
				case 'CN':
				case 'IR':
					new_options = [MM_auto_select,'1','2','3','4','5','6','7','8','9','10','11','12','13'];
					new_values  = ['0','1','2','3','4','5','6','7','8','9','10','11','12','13'];
					break;
				case 'JP':
					new_options = [MM_auto_select,'1','2','3','4','5','6','7','8','9','10','11','12','13','14'];
					new_values  = ['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14'];
					break;
				case 'AU':
					new_options = [MM_auto_select,'1','2','3','4','5','6','7','8','9','10','11','12','13'];
					new_values  = ['0','1','2','3','4','5','6','7','8','9','10','11','12','13'];
					break;
				case 'US':
				case 'TW':
				default:
					new_options = [MM_auto_select,'1','2','3','4','5','6','7','8','9','10','11'];
					new_values  = ['0','1','2','3','4','5','6','7','8','9','10','11'];
					break;
			}	
		}else{//5G	
			switch(CountryCode){	
				case 'BR':
					new_options = [MM_auto_select,'36','40','44','48','52','56','60','64','149','153','157','161','165'];
					new_values  = ['0','36','40','44','48','52','56','60','64','149','153','157','161','165'];
					break;
				case 'CN':
				case 'IR':
					var band = $("#HT_BW").val();
					if(band=="0"){
						new_options = [MM_auto_select,'149','153','157','161','165'];
						new_values  = ['0','149','153','157','161','165'];
					}else{
						new_options = [MM_auto_select,'149','153','157','161'];
						new_values  = ['0','149','153','157','161'];
					}
					break;
				case 'FR':
					new_options = [MM_auto_select,'36','40','44','48','52','56','60','64'];
					new_values  = ['0','36','40','44','48','52','56','60','64'];
					break;
				case 'JP':
					new_options = [MM_auto_select,'36','40','44','48'];
					new_values  = ['0','36','40','44','48'];
					break;
				case 'TW':
					new_options = [MM_auto_select,'52','56','60','64'];
					new_values  = ['0','52','56','60','64'];
					break;
				case 'AU':
				new_options = [MM_auto_select,'36','40','44','48','52','56','60','64','100','104','108','112','116','120','124','128','132','136','140','149','153','157','161','165'];
				new_values  = ['36','40','44','48','52','56','60','64','100','104','108','112','116','120','124','128','132','136','140','149','153','157','161','165'];
					break;
				case 'US':
				default:
					new_options = [MM_auto_select,'36','40','44','48','52','56','60','64','100','104','108','112','116','120','124','128','132','136','140','149','153','157','161','165'];
					new_values  = ['0','36','40','44','48','52','56','60','64','100','104','108','112','116','120','124','128','132','136','140','149','153','157','161','165'];
					break;
			}		
		}
	}
	CreateOptions("Channel",new_options,new_values);
}

function CountryCodeOnChange(){
	CreateChannel();
}

function wirelessModeChange(){
	var wmode = $("#WirelessMode").val();
	var f=document.wirelessBasic;
	if (wmode == 1 || wmode == 4 || wmode == 9 ){
		$("#HT_BW").val("1");
		f.HT_BW.options[2] = null;
	}else if(wmode==2){
		f.HT_BW.options[1]= null;
		f.HT_BW.options[1]= null;
	}else if(wmode ==8){
		f.HT_BW.options[1] = null;
		f.HT_BW.options[1] = new Option("20/40MHz","1");
		$("#HT_BW").val("1");
		
	}else{
		f.HT_BW.options[1] = null;
		f.HT_BW.options[1] = new Option("20/40MHz","1");
		f.HT_BW.options[2] = null;
		f.HT_BW.options[2] = new Option("80MHz","2");
		$("#HT_BW").val("2");
	}
	if (wmode == 2 || wmode == 8 || wmode == 9 || wmode == 14){
		$("#div_bandwidth").show();
	}else{
		$("#div_bandwidth").hide();	
	}

	ChannelOnChange();
}

function ChannelOnChange(){
	var ch = $("#Channel").val();
	if ( ch == '165' )
	{
		supplyValue("HT_BW","0");
		
		setDisabled("#HT_BW",true);
	}
	else
	{
		setDisabled("#HT_BW",false);
	}
}

function BandOnChange()
{
	var ch=$("#Channel").val();
	var band=$("#HT_BW").val();
	CreateChannel();
	if(band!=0&&ch==165)
		supplyValue("Channel",0);
	else
		supplyValue("Channel",ch);	
}

function setChannel(){
	var CntyCd=v_CountryCode;
	var ChIdx=1*v_Channel;
	var PhyMode=1*v_WirelessMode;

	if ((PhyMode == 0) || (PhyMode == 1) || (PhyMode == 4) || (PhyMode == 6) || (PhyMode == 7) || (PhyMode == 9)){
		if ((CntyCd == 'US' || CntyCd == 'TW') && (ChIdx < 1 || ChIdx > 11)){
			supplyValue("Channel","0");
		}else if ((CntyCd == 'FR' || CntyCd == 'IE' || CntyCd == 'HK') && (ChIdx < 1 || ChIdx > 13)){
			supplyValue("Channel","0");
		}else if (CntyCd == 'JP' && (ChIdx < 1 || ChIdx > 14)){
			supplyValue("Channel","0");
		}else{
			if (ChIdx < 1 || ChIdx > 14)
				supplyValue("Channel","0");
			else
				supplyValue("Channel",ChIdx);
		}
	}else if ((PhyMode == 2) || (PhyMode == 8) || (PhyMode == 11) || (PhyMode == 14) || (PhyMode == 15)){
		if (CntyCd == 'HK' && (ChIdx < 36 || (ChIdx > 64 && ChIdx < 149) || ChIdx > 165)){
			supplyValue("Channel","0");
		}else if (CntyCd == 'IE' && (ChIdx < 36 || (ChIdx > 64 && ChIdx < 100) || ChIdx > 140)){
			supplyValue("Channel","0");
		}else if (CntyCd == 'FR' && (ChIdx < 36 || ChIdx > 64)){
			supplyValue("Channel","0");
		}else if (CntyCd == 'JP' && (ChIdx < 36 || ChIdx > 48)){
			supplyValue("Channel","0");
		}else if (CntyCd == 'US' && (ChIdx < 36 || (ChIdx > 64 && ChIdx < 100) || (ChIdx > 140 && ChIdx < 149) || ChIdx > 165)){
			supplyValue("Channel","0");
		}else if (CntyCd == 'TW' && (ChIdx < 52 || ChIdx > 64)){
			supplyValue("Channel","0");
		}else{
			if (ChIdx < 36 || (ChIdx > 64 && ChIdx < 100) || (ChIdx > 140 && ChIdx < 149) || ChIdx > 165)
				supplyValue("Channel","0");
			else
				supplyValue("Channel",ChIdx);
		}
	}
}

function initValue(){
	v_WiFiOff=responseJson['WiFiOff'];
	v_WirelessMode=responseJson['WirelessMode'];
	v_Channel=responseJson['Channel'];
	v_CountryCode=responseJson['CountryCode'];
	v_SSID=responseJson['SSID'];
	v_HideSSID=responseJson['HideSSID'];
	v_AuthMode=responseJson['AuthMode'];
	v_EncrypType=responseJson['EncrypType'];
	v_KeyType=responseJson['KeyType'];
	v_KeyStr=responseJson['KeyStr'];
	v_WPAPSK=responseJson['WPAPSK'];
	v_HT_BW=responseJson['HT_BW'];
	v_wscBt=responseJson['wscBt'];
	v_WscEabled='1';
	v_Opmode=responseJson['OperationMode'];
	v_only5G=responseJson['only_5g'];
	v_vlanid=responseJson['vlanid'];
	v_countryCodeBt=responseJson['countryCodeBt'];
	v_ScheduleEn_wifi=responseJson['ScheduleEn_wifi'];
	
	CreateCountryCode();
	CreateWirelessMode();
	CreateAuthMode();

	setJSONValue({
		'WiFiOff'			  :	v_WiFiOff,
		'SSID'				  :	v_SSID,
		'HideSSID'            : v_HideSSID,
		'HT_BW'            	  : v_HT_BW,
		'CountryCode'         :	v_CountryCode,
		'WirelessMode'        :	v_WirelessMode,
		'vlanid'			  :	v_vlanid,
		'security_mode'       : v_AuthMode,
		'encryp_type'         : v_EncrypType,
		'KeyStr'         	  : v_KeyStr,
		'WPAPSK'         	  : v_WPAPSK		
	});
	CreateChannel();
	setChannel();
	setAuthMode();
	wirelessModeChange();
	setJSONValue({
		'HT_BW'            	  : v_HT_BW
	});
	if (v_WiFiOff==0){
		$("#div_wireless_setting").show();
	}else{
		$("#div_wireless_setting").hide();
	}
	if (v_countryCodeBt==1){
		$("#div_countrycode_setting").show();
	}else{
		$("#div_countrycode_setting").hide();
	}
	
	if(v_Opmode==2 || v_Opmode==3){
		setDisabled("#Channel",true);
	}else{
		setDisabled("#Channel",false);
	}

	if(v_Opmode==0 || v_Opmode==2){
		$("#div_vlanid0").show();
	}else{
		$("#div_vlanid0").hide();
	}
	
	if(v_WiFiOff==1 && v_ScheduleEn_wifi==1){
		$('#WiFiOff').attr('disabled', true);
	}
	
}

var WiFiIdx="0";
var responseJsonIdx;
var wifiFlag=0;
$(function(){
	var postVarBuilt = { "topicurl" : "setting/getWebWlanIdx"};
    postVarBuilt = JSON.stringify(postVarBuilt);
	$.ajax({  
       	type : "post",  
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarBuilt,  
        async : false,  
        success : function(Data){
			responseJsonIdx = JSON.parse(Data);
			wifiFlag=responseJsonIdx['webWlanIdx'];
		}
    }); 
	
	if(top.frames[0].wifiSelect == 1 || wifiFlag == 1)
		WiFiIdx = "1";

	var postVar = { topicurl : "setting/getWiFiBasicConfig"};
	postVar["WiFiIdx"] = WiFiIdx;
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
});

function saveChanges(){
	if (!checkVaildVal.IsVaildSSID($("#SSID").val(), MM_ssid)) return false;
	if (!checkVaildVal.IsVaildNumberRange($('#vlanid').val(), MM_vlanid, 0, 4094)) return false;
	if($("#HideSSID").val()==1){
		if(!confirm(JS_msg86)) return false;
		v_WscEabled="0";
	}

	var security_mode = $('#security_mode').val();
	var encryp_type = $('#encryp_type').val();
	var key_format = $('#key_format').val();

	if (security_mode == "OPEN" || security_mode == "SHARED"){
		var wepkey=$("#KeyStr").val();
		if (key_format == 0){//Hex
			if (encryp_type == "WEP64"){//10hex
				if (wepkey.length != 10){
					alert(JS_msg21);
					return false;
				}				
				if (!checkVaildVal.IsVaildWiFiPass(wepkey, MM_wepkey, "hex")) return false;
			}else if (encryp_type == "WEP128"){//26hex
				if (wepkey.length != 26){
					alert(JS_msg22);
					return false;
				}				
				if (!checkVaildVal.IsVaildWiFiPass(wepkey, MM_wepkey, "hex")) return false;
			}
			supplyValue("KeyType", "0");
		}else{
			if (encryp_type == "WEP64"){
				if (wepkey.length != 5){
					alert(JS_msg19);
					return false;
				}
			}else if (encryp_type == "WEP128"){
				if (wepkey.length != 13){
					alert(JS_msg20);
					return false;
				}
			}
			if (!checkVaildVal.IsVaildWiFiPass(wepkey, MM_wepkey, "ascii")) return false;		
			supplyValue("KeyType", "1");
		}	
		
		setJSONValue({
			"AuthMode"     : security_mode,
			"EncrypType"   : "WEP"
		});
		if(Number(v_wscBt)!=0){
			
			if(!confirm(JS_msg26)){
				return false;
			}else{
				v_WscEabled="0";
			}
		}
	}else if (security_mode == "WPAPSK" || security_mode == "WPA2PSK" || security_mode == "WPAPSKWPA2PSK"){
		var wpakey=$("#WPAPSK").val();
		if (key_format == 0){//64 Hex
			if (wpakey.length != 64){
				alert(JS_msg25);
				return false;
			}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey, MM_wpakey, "hex")) return false;
			supplyValue("KeyType", "0");
		}else{
			if (wpakey.length < 8 || wpakey.length > 63){
				alert(JS_msg24);
				return false;
			}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey, MM_wpakey, "ascii"))	return false;
			supplyValue("KeyType", "1");
		}

		setJSONValue({
			"AuthMode"     : security_mode,
			"EncrypType"   : encryp_type
		});
		if (security_mode == "WPAPSK"){
			if(Number(v_wscBt)!=0){
				if(!confirm(JS_msg27_1))
					return false;
				else{
					v_WscEabled="0";
				}
			}		
		}
		else {
			if (encryp_type == "TKIP"){
				if(Number(v_wscBt)!=0){					
					if(!confirm(JS_msg27))
						return false;
					else{
						v_WscEabled="0";
					}
				}		
			}
		}
	}else{
		setJSONValue({
			"AuthMode"     : "NONE",
			"EncrypType"   : "NONE",
			"KeyType"      : "1"
		});
	}
	return true;
}

function doSubmit(){
	if (saveChanges()==false)
		return false;
			
	var postVar ={"topicurl":"setting/setWiFiBasicConfig"};
	postVar['SSID'] = $('#SSID').val();
	postVar['WirelessMode'] = $('#WirelessMode').val();
	postVar['Channel'] = $('#Channel').val();
	postVar['CountryCode'] = $('#CountryCode').val();
	postVar['HideSSID'] = $('#HideSSID').val();
	postVar['AuthMode'] = $('#AuthMode').val();
	postVar['EncrypType'] = $('#EncrypType').val();
	postVar['KeyType'] = $('#KeyType').val();
	postVar['KeyStr'] = $('#KeyStr').val();
	postVar['WPAPSK'] = $('#WPAPSK').val();
	postVar['HT_BW'] = $('#HT_BW').val();
	postVar['addEffect'] = "0";
	postVar["WiFiIdx"] = WiFiIdx;
	postVar["WscEabled"]=v_WscEabled;
	postVar['vlanid'] = $('#vlanid').val();
	uiPost(postVar);
	
}

function updateState(){
	var postVar ={"topicurl":"setting/setWiFiBasicConfig"};
	postVar['WiFiOff'] = $('#WiFiOff').val();
	postVar["WiFiIdx"] = WiFiIdx;
	postVar["addEffect"] = "1";	
	//uiPost(postVar);
	uiPostWlBasic(postVar);
}
function uiPostWlBasic(postVar){
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		setTimeout("parent.menu.location.reload();","3000");
		setTimeout("resetForm();","3500");
	});
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form name="wirelessBasic" id="wirelessBasic">
<input type="hidden" name="AuthMode" id="AuthMode">
<input type="hidden" name="EncrypType" id="EncrypType">
<input type="hidden" name="KeyType" id="KeyType">
<input type="hidden" name="addEffect" id="addEffect" value="0">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_basic_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_basic_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_radio_onoff)</script></td>
<td><select name="WiFiOff" id="WiFiOff" onChange="updateState()">
<option value="0"><script>dw(MM_enable)</script></option>
<option value="1"><script>dw(MM_disable)</script></option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<div id="div_wireless_setting" style="display:none">
<table border=0 width="100%">
<tr> 
<td class="item_left"><script>dw(MM_ssid)</script></td>
<td><input type="text" name="SSID" id="SSID" maxlength=32></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_band)</script></td>
<td><select name="WirelessMode" id="WirelessMode" onChange="wirelessModeChange()"></select></td>
</tr>
<tr id="div_countrycode_setting" style="display:none"> 
<td class="item_left"><script>dw(MM_region)</script></td>
<td><select name="CountryCode" id="CountryCode" onChange="CountryCodeOnChange()"></select></td>
</tr>
<tr id="div_broadcast_ssid">
<td class="item_left"><script>dw(MM_broadcast_ssid)</script></td>
<td><select name="HideSSID" id="HideSSID">
<option value="1"><script>dw(MM_disable)</script></option>
<option value="0"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_channel)</script></td>
<td><select name="Channel" id="Channel" onChange="ChannelOnChange()"></select></td>
</tr>
<tr id="div_bandwidth" style="display:none">
<td class="item_left"><script>dw(MM_band_width)</script></td>
<td><select name="HT_BW" id="HT_BW" onChange="BandOnChange()">
<option value="0">20MHz</option>
<option value="1">20/40MHz</option>
<option value="2">80MHz</option>
</select></td>
</tr>
<tr id="div_vlanid0" style="display:none"> 
<td class="item_left"><script>dw(MM_vlanid)</script></td>
<td><input type="text" name="vlanid" id="vlanid" size=10 maxlength=5>
<font color="#808080">(<script>dw(MM_range)</script> 0 - 4094, 0 : <script>dw(MM_disabled_function)</script>)</font></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_security_mode)</script></td>
<td><select name="security_mode" id="security_mode" onChange="updateAuthMode()"> 
</select></td>
</tr>
<tr id="div_encryp_type" style="display:none"> 
<td class="item_left"><script>dw(MM_encryp_type)</script></td>
<td><select name="encryp_type" id="encryp_type" onChange="updateEncrypType()">
</select></td>
</tr>
<tr id="div_key_format" style="display:none"> 
<td class="item_left"><script>dw(MM_key_format)</script></td>
<td><select name="key_format" id="key_format" onChange="updateKeyFormat()">
<option value="0">Hex</option>
<option value="1">ASCII</option>
</select></td>
</tr>
<tr id="div_wep_key" style="display:none"> 
<td class="item_left"><script>dw(MM_key)</script></td>
<td><input type="text" name="KeyStr" id="KeyStr" maxlength="26"></td>
</tr> 
<tr id="div_wpa_key" style="display:none">
<td class="item_left"><script>dw(MM_key)</script></td>
<td><input type="text" name="WPAPSK" id="WPAPSK" maxlength="64"></td>
</tr>
</table>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button name="apply" id="apply" value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</div>
</form>  
<script>showFooter()</script>
</body></html>
