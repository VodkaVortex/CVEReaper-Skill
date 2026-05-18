<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/menu.css" type="text/css">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<style>
a:link      { text-decoration:underline; color:#0000ff;}   
a:visited   { text-decoration:underline; color:#0000ff;}   
a:hover     { text-decoration:underline; color:#0000ff; font-weight:bold;} 
</style>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript">
var responseJson;
var v_WiFiOff,v_BssidNum,v_supportApNum,v_SSIDS,v_opmode;
var add_modify_flag=0;//0--->add, other is modify

function saveChanges(){	

	var ssid_num = parseInt(v_BssidNum);
	
	if (add_modify_flag == 0){//add ssid
		if (ssid_num > v_supportApNum){
			var almsg=JS_max_rules_1+v_supportApNum+JS_max_rules_2;
			alert(almsg);
			return false;
		}
		$("#SsidIdx").val(ssid_num);
		$("#BssidNum").val((ssid_num + 1));
	}else{//modify ssid
		$("#SsidIdx").val(add_modify_flag);
		$("#BssidNum").val(ssid_num);
	}
	
	if (!checkVaildVal.IsVaildSSID($("#ssid").val(), MM_ssid)) return false;
	if (!checkVaildVal.IsVaildNumberRange($('#vlanid').val(), MM_vlanid, 0, 4094)) return false;
	
	$("#HideSSID").val($("#hssid").val());
	$("#SSID1").val($("#ssid").val());
	$("#VLANID1").val($("#vlanid").val());
	
	var security_mode = $('#security_mode').val();
	var encryp_type = $('#encryp_type').val();
	var key_format = $('#key_format').val();
	
	if (security_mode == 'OPEN' || security_mode == 'SHARED'){	
		var wepkey=$("#wepkey").val();
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
		}	
		
		$("#AuthMode").val(security_mode);
		$("#EncrypType").val("WEP");
		$("#Key1Type").val(key_format);
		$("#Key1Str1").val($("#wepkey").val());
		$("#WPAPSK1").val("");
	}
	else if (security_mode=='WPAPSK' || security_mode=='WPA2PSK' || security_mode=='WPAPSKWPA2PSK'){
		var wpakey=$("#wpakey").val();
		if (key_format == 0){//64 Hex
			if (wpakey.length != 64){
				alert(JS_msg25);
				return false;
			}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey, MM_wpakey, "hex")) return false;
		}else{
			if (wpakey.length < 8 || wpakey.length > 63){
				alert(JS_msg24);
				return false;
			}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey, MM_wpakey, "ascii")) return false;
		}	
		
		$("#AuthMode").val(security_mode);
		$("#EncrypType").val(encryp_type);
		$("#Key1Type").val(key_format);
		$("#Key1Str1").val("");
		$("#WPAPSK1").val($("#wpakey").val());
	}
	else{
		$("#AuthMode").val("NONE");
		$("#EncrypType").val("NONE");
		$("#Key1Type").val("1");
		$("#Key1Str1, #WPAPSK1").val("");
	}
	return true;
}

function updateKeyFormat(){
	var security_mode = $('#security_mode')[0].selectedIndex;
	var encryp_type = $('#encryp_type')[0].selectedIndex;
	var key_format = $('#key_format')[0].selectedIndex;
	
	if (security_mode == 1 || security_mode == 2){
		if (encryp_type == 0){
			if (key_format == 0)
				$("#wepkey").attr("maxlength", 10);
			else
				$("#wepkey").attr("maxlength", 5);
		}else{
			if (key_format == 0)
				$("#wepkey").attr("maxlength", 26);
			else
				$("#wepkey").attr("maxlength", 13);
		}			
	}else{
		if (key_format == 0)
			$("#wpakey").attr("maxlength", 64);
		else
			$("#wpakey").attr("maxlength", 63);
	}
}

function updateEncrypType(){
	updateKeyFormat();
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
	$("#wepkey, #wpakey").attr("disabled", true);

	CreateEncrypType();
	
	var auth=$("#security_mode").val();
	switch(auth){
		case "NONE":
			supplyValue("encryp_type","NONE");
			break;
		case "OPEN":
		case "SHARED":
			$("#div_encryp_type, #div_key_format, #div_wep_key").show();
			$("#wepkey").val("").attr("disabled", false);	
				
			setJSONValue({
				"encryp_type"  : "WEP64",
				"key_format"   : "1"
			});
			updateEncrypType();
			break;
		default:
			$("#div_encryp_type, #div_key_format, #div_wpa_key").show();
			$("#wpakey").val("").attr("disabled", false);
			
			if(auth=="WPAPSK")
				supplyValue("encryp_type","AES");
			else if(auth=="WPA2PSK")
				supplyValue("encryp_type","AES");
			else
				supplyValue("encryp_type","TKIPAES");
			supplyValue("key_format","1");
			updateEncrypType();
			break;
	}
}

function deleteClick(){
	var del_count=0;
	var delarray = [];
	
	for(var i=1; i<v_BssidNum; i++){
		if($("#DR"+i).get(0).checked==true){
			del_count++;
			delarray.push(i);
		}
	}
	if(del_count==0){
		alert(JS_delete_select);
		return false;
	}
	
	for(var i=1;i<(v_BssidNum-1);i++){
		if($("#DR"+i).get(0).checked==true && $("#DR"+(i+1)).get(0).checked==false){
			alert(JS_invalid_delrule);
			return false;
		}
	}
	
	var postVar ={"topicurl":"setting/delWiFiMultipleConfig"};
	postVar['BssidNum'] = (v_BssidNum-del_count).toString();
	postVar["WiFiIdx"]  = WiFiIdx;
	postVar['SSIDNO'] = delarray.toString();
	
	uiPost(postVar);
	return true;
}

function modifyClick(index){
	$("#div_encryp_type, #div_key_format, #div_wep_key, #div_wpa_key").hide();
	$("#wepkey, #wpakey").attr("disabled", true);
	
	add_modify_flag=index;//modify	
	var tmp_ap=v_SSIDS[index-1];
	var ssid, vlanid, hssid, security_mode,encryp_type,key_format,hssid;
	
	ssid   = tmp_ap['SSID'];
	vlanid = tmp_ap['VLANID'];
	hssid  = tmp_ap['HideSSID'];
	encryp_type = tmp_ap['EncrypType'];
		
	if (tmp_ap['AuthMode']=="NONE") {
		security_mode = "NONE";
		encryp_type = "NONE";
	}else if (tmp_ap['AuthMode']=="OPEN" || tmp_ap['AuthMode']=="SHARED"){
		$("#div_encryp_type, #div_key_format, #div_wep_key").show();
		$("#wepkey").attr("disabled", false);
		$("#wepkey").val(tmp_ap['Key1Str1']);
		security_mode =	tmp_ap['AuthMode'];

		if (tmp_ap['Key1Str1'].length==5 || tmp_ap['Key1Str1'].length==10)
			encryp_type = "WEP64";
		else
			encryp_type = "WEP128";
			
		if (tmp_ap['Key1Type']==0)
			key_format = 0;
		else
			key_format = 1;
	}else if (tmp_ap['AuthMode']=="WPAPSK" || tmp_ap['AuthMode']=="WPA2PSK" || tmp_ap['AuthMode']=="WPAPSKWPA2PSK") {
		$("#div_encryp_type, #div_key_format, #div_wpa_key").show();
		$("#wpakey").attr("disabled", false);
		$("#wpakey").val(tmp_ap['WPAPSK1']);
		security_mode =	tmp_ap['AuthMode'];
		
		if (tmp_ap['Key1Type']==0)
			key_format = 0;
		else
			key_format = 1;
	}
	
	setJSONValue({
			'ssid'  		: ssid,
			'vlanid'  		: vlanid,
			'hssid' 		: hssid,
			'security_mode' : security_mode
	});
	
	CreateEncrypType();
	setJSONValue({
			'encryp_type'  : encryp_type,
			'key_format'   : key_format
	});
	updateEncrypType();
	$("#addmodify").val(BT_modify);
}

function CreatMultiSecurity(idx){
	var tmp="",tmp_ap=v_SSIDS[idx];
	if (tmp_ap['EncrypType']=="AES")
		tmp+="AES";
	else if (tmp_ap['EncrypType']=="TKIP")
		tmp+="TKIP";
	else if (tmp_ap['EncrypType']=="TKIPAES")
		tmp+="TKIP/AES";	
	
	var strTmp="";
	if (tmp_ap['AuthMode']=="NONE")
		strTmp+="<td class=\"item_center2\">"+MM_disable+"</td>\n";
	else if (tmp_ap['AuthMode']=="OPEN")
		strTmp+="<td class=\"item_center2\">WEP-"+MM_open_system+"</td>\n";
	else if (tmp_ap['AuthMode']=="SHARED")
		strTmp+="<td class=\"item_center2\">WEP-"+MM_shared_key+"</td>\n";
	else if (tmp_ap['AuthMode']=="WPAPSK")
		strTmp+="<td class=\"item_center2\">WPA-PSK"+"&nbsp;"+tmp+"</td>\n";
	else if (tmp_ap['AuthMode']=="WPA2PSK")
		strTmp+="<td class=\"item_center2\">WPA2-PSK"+"&nbsp;"+tmp+"</td>\n";
	else if (tmp_ap['AuthMode']=="WPAPSKWPA2PSK")
		strTmp+="<td class=\"item_center2\">WPA/WPA2-PSK"+"&nbsp;"+tmp+"</td>\n";
	return strTmp;
}

function CreatMultiAPlist(){
	if(v_BssidNum<=1) return false;
	
	var strTmp="",j=0;
	for(var i=0;i<v_SSIDS.length;i++){
		j=i+1;
		strTmp+="<tr align=\"center\">\n";
		strTmp+="<td class=\"item_center2\">"+j+"</td>\n";
		strTmp+="<td class=\"item_center2\"><a href='javascript:modifyClick("+j+")'>"+v_SSIDS[i]['SSID'].replace(eval("/ /gi"),'&nbsp;')+"</a></td>\n";
		strTmp+=CreatMultiSecurity(i);		
		strTmp+="<td class=\"item_center2\"><input type=checkbox id=DR"+j+" name=DR"+j+"></td>\n";
		strTmp+="</tr>\n";
	}
	
	$("#div_multiaplist").append(strTmp);
}
function initValue(){
	v_WiFiOff=responseJson['WiFiOff'];
	v_BssidNum=responseJson['BssidNum'];
	v_supportApNum=responseJson['MultiApNum'];
	v_SSIDS=responseJson['SSIDS'];
	v_opmode=responseJson['OperationMode'];
	
	$("#span_apnum").html(v_supportApNum);
	
	if (v_WiFiOff==1){
		$(":input").attr('disabled',true);
	}

	if(v_opmode == 1 || v_opmode == 3){
		$("#div_vlanid").hide();
	}
	else
	{
		$("#div_vlanid").show();
	}
	
	CreateAuthMode();
	CreatMultiAPlist();
	
	if (v_BssidNum == 1){
		$("#del_sel, #del_reset").attr("disabled", true);
	}
}

var WiFiIdx = "0";
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
		
	var postVar = { topicurl : "setting/getWiFiMultipleConfig"};
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

function doSubmit(flag){
	if (flag==1) {
		if (saveChanges()==false)
			return false;
	}else {
		deleteClick();
		return true;
	}
		
	var postVar ={"topicurl":"setting/setWiFiMultipleConfig"};
	postVar['BssidNum'] = $('#BssidNum').val();
	postVar["WiFiIdx"]  = WiFiIdx;
	postVar['SsidIdx']    = $('#SsidIdx').val();
	
	postVar['SSID1']    = $('#SSID1').val();
	postVar['HideSSID'] = $('#HideSSID').val();
	postVar['AuthMode'] = $('#AuthMode').val();
	postVar['EncrypType'] = $('#EncrypType').val();
	postVar['Key1Type'] = $('#Key1Type').val();
	postVar['Key1Str1'] = $('#Key1Str1').val();
	postVar['WPAPSK1']  = $('#WPAPSK1').val();
	if(v_opmode != 1 && v_opmode != 3){
		postVar['VLANID1']    = $('#VLANID1').val();
	}
	
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form name="wirelessMultipleAdd" id="wirelessMultipleAdd">
<input type="hidden" name="BssidNum" id="BssidNum">
<input type="hidden" name="SsidIdx" id="SsidIdx">
<input type="hidden" name="SSID1" id="SSID1">
<input type="hidden" name="VLANID1" id="VLANID1">
<input type="hidden" name="HideSSID" id="HideSSID">
<input type="hidden" name="AuthMode" id="AuthMode">
<input type="hidden" name="EncrypType" id="EncrypType">
<input type="hidden" name="Key1Type" id="Key1Type">
<input type="hidden" name="Key1Str1" id="Key1Str1">
<input type="hidden" name="WPAPSK1" id="WPAPSK1">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_multipleap_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_multipleap_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_ssid)</script></td>
<td><input type="text" name="ssid" id="ssid" maxlength=32></td>
</tr>
<tr id="div_vlanid" style="display:none"> 
<td class="item_left"><script>dw(MM_vlanid)</script></td>
<td><input type="text" name="vlanid" id="vlanid" size=10 maxlength=5 value="0">
<font color="#808080">(<script>dw(MM_range)</script> 0 - 4094, 0 : <script>dw(MM_disabled_function)</script>)</font></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_broadcast_ssid)</script></td>
<td><select name="hssid" id="hssid">
<option value="1"><script>dw(MM_disable)</script></option>
<option value="0" selected><script>dw(MM_enable)</script></option>
</select></td>
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
<td><input type="text" name="wepkey" id="wepkey" maxlength="26"></td>
</tr> 
<tr id="div_wpa_key" style="display:none"> 
<td class="item_left"><script>dw(MM_key)</script></td>
<td><input type="text" name="wpakey" id="wpakey" maxlength="64"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_add+'" id=addmodify onClick="doSubmit(1)">')</script></td></tr>
</table>
</form>

<form name="wirelessMultipleDel" id="wirelessMultipleDel">
<table border=0 width="100%" id="div_multiaplist">
<tr><td colspan="5"><b><script>dw(MM_multipleap_table)</script>&nbsp;&nbsp;(<script>dw(JS_msg89)</script><span id="span_apnum">2</span>)</b></td></tr>
<tr><td colspan="5"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_ssid)</script></b></td>
<td class="item_center"><b><script>dw(MM_security_mode)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
</table>
<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_delete+'" id="del_sel" onClick="doSubmit(0)">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" id="del_reset" onClick="resetForm()">')</script></td></tr>
</table> 
</form>
<script>showFooter()</script>
</body></html>