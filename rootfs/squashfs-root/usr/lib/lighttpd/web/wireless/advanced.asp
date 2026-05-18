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
var WiFiOff,v_WirelessMode,v_ApCliEnable, v_HardwareModel;

function initValue(){
	setJSONValue({
		'BGProtection'			:	responseJson['BGProtection'],
		'BeaconPeriod'			:	responseJson['BeaconPeriod'],
		'DtimPeriod'			:	responseJson['DtimPeriod'],
		'FragThreshold'			:	responseJson['FragThreshold'],
		'RTSThreshold'			:	responseJson['RTSThreshold'],
		'TxPower'				:	responseJson['TxPower'],
		'MaxStaNum'				:	responseJson['MaxStaNum'],
		'KickOutTxRetries'		:	responseJson['KickOutTxRetries'],	
		'NoForwarding'			:	responseJson['NoForwarding'],
		'TxBurst'				:	responseJson['TxBurst'],
		'HT_BSSCoexistence'		:	responseJson['HT_BSSCoexistence'],	
		'WmmCapable'			:	responseJson['WmmCapable'],
		'ShortGI'				:	responseJson['ShortGI'],
		'TxPreamble'			:	responseJson['TxPreamble'],
		'Sensitivity'			:	(responseJson['Sensitivity']=="")?0:responseJson['Sensitivity']
	});
	
	if(1 == WiFiIdx)
	{
		$('#g5_none_sensitivity').hide();
	}else{
		$('#g5_none_sensitivity').show();
	}
	
	v_WiFiOff=responseJson['WiFiOff'];
	v_WirelessMode=responseJson['WirelessMode'];
	
	if (WiFiIdx==0){
		if (v_WirelessMode==9||v_WirelessMode==6)
			$("#div_2040_coexit").show();
		else
			$("#div_wmm_capable").show();
	}
	
	if (v_WirelessMode<5){
		$("#TxBurst").val("0");
		$("#div_tx_burst").hide();
	}

	if (v_WiFiOff==1){
		$(":input").attr('disabled',true);
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

	var postVar = { topicurl : "setting/getWiFiAdvancedConfig"};
	postVar['WiFiIdx']=WiFiIdx;
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
	if (!checkVaildVal.IsVaildNumberRange($('#BeaconPeriod').val(), MM_beacon, 20, 999)) return false;
	if (!checkVaildVal.IsVaildNumberRange($('#DtimPeriod').val(), MM_data_beacon_rate, 1, 255)) return false;
	if (!checkVaildVal.IsVaildNumberRange($('#FragThreshold').val(), MM_fragment, 256, 2346)) return false;	
	if (!checkVaildVal.IsVaildNumberRange($('#RTSThreshold').val(), MM_rts, 1, 2347)) return false;	
	if (!checkVaildVal.IsVaildNumberRange($('#MaxStaNum').val(), MM_max_staNum, 0, 64)) return false;
	if (!checkVaildVal.IsVaildNumberRange($('#KickOutTxRetries').val(), MM_KickOutTxRetries, 0, 100)) return false;
	if (!checkVaildVal.IsVaildNumberRange($('#Sensitivity').val(), MM_sensitivity, 0, 50)) return false;
	
	return true;
}

function doSubmit(){
	if (saveChanges()==false)
		return false;	
		
	var postVar ={"topicurl":"setting/setWiFiAdvancedConfig"};
	postVar['BGProtection'] = $('#BGProtection').val();
	postVar['BeaconPeriod'] = $('#BeaconPeriod').val();
	postVar['DtimPeriod'] = $('#DtimPeriod').val();
	postVar['FragThreshold'] = $('#FragThreshold').val();
	postVar['RTSThreshold']  = $('#RTSThreshold').val();
	postVar['TxPower'] = $('input[name="TxPower"]:checked').val();
	postVar['MaxStaNum'] = $('#MaxStaNum').val();
	postVar['KickOutTxRetries'] = $('#KickOutTxRetries').val();
	postVar['NoForwarding'] = $('#NoForwarding').val();	
	postVar['TxBurst'] = $('#TxBurst').val();
	postVar['HT_BSSCoexistence'] = $('#HT_BSSCoexistence').val();
	postVar['WmmCapable'] = $('#WmmCapable').val();
	postVar['TxPreamble'] = $('input[name="TxPreamble"]:checked').val();
	postVar['Sensitivity']  = $('#Sensitivity').val();
	postVar['ShortGI'] = $('input[name="ShortGI"]:checked').val();
	postVar['WiFiIdx']=WiFiIdx;
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form name="wirelessAdvanced" id="wirelessAdvanced">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_advanced_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_advanced_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr> 
<td class="item_left"><script>dw(MM_bgp_mode)</script></td>
<td><select name="BGProtection" id="BGProtection">
<option value=0><script>dw(MM_auto)</script></option>
<option value=1><script>dw(MM_on)</script></option>
<option value=2><script>dw(MM_off)</script></option>
</select></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_beacon)</script></td>
<td><input type=text name="BeaconPeriod" id="BeaconPeriod" size=5 maxlength=3> ms 
<font color="#808080">(<script>dw(MM_range)</script> 20 - 999, <script>dw(MM_default)</script> 100)</font></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_data_beacon_rate)</script>(DTIM)</td>
<td><input type=text name="DtimPeriod" id="DtimPeriod" size=5 maxlength=3> ms 
<font color="#808080">(<script>dw(MM_range)</script> 1 - 255, <script>dw(MM_default)</script> 1)</font></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_TxPreamble)</script></td>
<td><input type=radio name="TxPreamble" id="TxPreamble" value="0"><script>dw(MM_long_TxPreamble)</script>&nbsp;&nbsp;
<input type=radio name="TxPreamble" id="TxPreamble" value="1"><script>dw(MM_short_TxPreamble)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_GuardInterval)</script></td>
<td><input type=radio name="ShortGI" id="ShortGI" value="0"><script>dw(MM_longGI)</script>&nbsp;&nbsp;
<input type=radio name="ShortGI" id="ShortGI" value="1"><script>dw(MM_shortGI)</script></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_fragment)</script></td>
<td><input type=text name="FragThreshold" id="FragThreshold" size=5 maxlength=4> 
<font color="#808080">(<script>dw(MM_range)</script> 256 - 2346, <script>dw(MM_default)</script> 2346)</font></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_rts)</script></td>
<td><input type=text name="RTSThreshold" id="RTSThreshold" size=5 maxlength=4> 
<font color="#808080">(<script>dw(MM_range)</script> 1 - 2347, <script>dw(MM_default)</script> 2347)</font></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_tx_power)</script></td>
<td><input type=radio name="TxPower" id="TxPower" value="100">100%&nbsp;&nbsp;
<input type=radio name="TxPower" id="TxPower" value="75">75%&nbsp;&nbsp;
<input type=radio name="TxPower" id="TxPower" value="50">50%&nbsp;&nbsp;
<input type=radio name="TxPower" id="TxPower" value="35">35%&nbsp;&nbsp;
<input type=radio name="TxPower" id="TxPower" value="15">15%&nbsp;&nbsp;
</td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_max_staNum)</script></td>
<td><input type=text name="MaxStaNum" id="MaxStaNum" size=5 maxlength=3>
<font color="#808080">(<script>dw(MM_range)</script> 0 - 64, 0 : <script>dw(MM_disabled_function)</script>)</font></td>
</tr>
<tr id="g5_none_sensitivity" style="display:none"> 
<td class="item_left"><script>dw(MM_sensitivity)</script></td>
<td><input type=text name="Sensitivity" id="Sensitivity" size=5 maxlength=4> 
<font color="#808080">(<script>dw(MM_range)</script>0 - 50, <script>dw(MM_default)</script> 0)</font></td>
</tr>
<td class="item_left"><script>dw(MM_KickOutTxRetries)</script></td>
<td><input type=text name="KickOutTxRetries" id="KickOutTxRetries" size=5 maxlength=3>
<font color="#808080">(<script>dw(MM_range)</script> 0 - 100, 0 : <script>dw(MM_disabled_function)</script>)</font></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_ap_isolated)</script></td>
<td><select name="NoForwarding" id="NoForwarding">
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="div_tx_burst">
<td class="item_left"><script>dw(MM_tx_burst)</script></td>
<td><select name="TxBurst" id="TxBurst">
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="div_2040_coexit" style="display:none"> 
<td class="item_left"><script>dw(MM_2040_coexistence)</script></td>
<td><select name="HT_BSSCoexistence" id="HT_BSSCoexistence">
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="div_wmm_capable" style="display:none">
<td class="item_left"><script>dw(MM_wmm_capable)</script></td>
<td><select name="WmmCapable" id="WmmCapable">
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="right"><script>dw('<input type=button class=button id="apply" value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>
