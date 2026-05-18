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
var v_DMZEnable,v_DMZAddress,v_lanNetmask,v_lanIp,v_stationIP;
function saveChanges(){
	supplyValue("DMZAddress", v_lanIp.replace(/\.\d{1,3}$/,".")+$("#dmzip4").val());
	if ($("#DMZEnabled").val() == "1") {
		var DMZAddress=$("#DMZAddress").val();
		if (!checkVaildVal.IsVaildIpAddr(DMZAddress, MM_host_ipaddr)) return false;		
		if (!checkVaildVal.IsIpSubnet(DMZAddress, v_lanNetmask, v_lanIp)) {alert(JS_msg38);	return false;}		
		if (DMZAddress == v_lanIp) {alert(JS_msg39);return false;}
	}	
	return true;
}
function selectMyIP(){
	if ($("#DMZMyIP").is(":checked"))
		supplyValue("dmzip4", $("#myip").html().split(".")[3]);
	else if(v_DMZAddress ==""||v_DMZAddress =="undefined")
    	supplyValue("dmzip4", "");
	else
		supplyValue("dmzip4", v_DMZAddress.split(".")[3]);
}  
function updateState(){
	if ($("#DMZEnabled").val() == 1){
		$("#div_dmzip,#div_pcip").show();
		setDisabled("#DMZMyIP,#dmzip4",false);
	}else {
		$("#div_dmzip,#div_pcip").hide();
		setDisabled("#DMZMyIP,#dmzip4",true);
	}
}
function initValue(){
	v_DMZEnable=responseJson['DMZEnable'];
	v_DMZAddress=responseJson['DMZAddress'];
	v_lanNetmask=responseJson['lanNetmask'];
	v_lanIp=responseJson['lanIp'];
	v_stationIP=responseJson['stationIP'];
	
	supplyValue("DMZEnabled",v_DMZEnable);
	supplyValue("myip",v_stationIP);
	
	if (v_DMZEnable == "0"){
		$("#div_dmzip,#div_pcip").hide();
		setDisabled("#DMZMyIP,#dmzip4",true);
	}else {
		$("#div_dmzip,#div_pcip").show();
		setDisabled("#DMZMyIP,#dmzip4",false);
	}
	
	if (v_DMZAddress != "") supplyValue("dmzip4",v_DMZAddress.split(".")[3]);
	if (v_lanIp !="") decomIP2($(":input[name=ips]"),v_lanIp,0);
}
$(function(){
	var postVar = { topicurl : "setting/getDMZCfg"};
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
function doSubmit(){
	if(!saveChanges()) return false;
	var postVar ={"topicurl":"setting/setDMZCfg"};
	postVar['DMZEnabled'] = $("#DMZEnabled").val();
	postVar['DMZAddress'] = $("#DMZAddress").val();
	postVar['week_all'] = "ON";
	postVar['time_all'] = "ON";
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form id="dmzCfg" name="dmzCfg">
<input type="hidden" id="DMZAddress" name="DMZAddress">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_dmz_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_dmz_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select id="DMZEnabled" name="DMZEnabled" onChange="updateState()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="div_dmzip" style="display:none">
<td class="item_left"><script>dw(MM_host_ipaddr)</script></td>
<td><input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" maxlength="3" id="dmzip4" name="dmzip4"></td>
</tr>
<tr id="div_pcip" style="display:none">
<td class="item_left">&nbsp;</td>
<td><input type="checkbox" id="DMZMyIP" name="DMZMyIP" onClick="selectMyIP()"> <script>dw(MM_currentPC)</script> <span id="myip"></span></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="return doSubmit();">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>