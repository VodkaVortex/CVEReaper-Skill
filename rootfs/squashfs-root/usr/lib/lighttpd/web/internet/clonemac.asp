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
var responseJson,responseMacJson,v_cloneMac,v_defaultMac,v_enCloneMac;
var http_request=false;
function doFillMyMAC(){
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
			var macArr = http_request.responseText;
			var mac=macArr.split(":");
			$("#mac1").val(mac[0]);
			$("#mac2").val(mac[1]);
			$("#mac3").val(mac[2]);
			$("#mac4").val(mac[3]);
			$("#mac5").val(mac[4]);
			$("#mac6").val(mac[5]);
		} 
	}
}
function cloneMacClick(){
	supplyValue("macCloneEnbl",1);
	setDisabled("#factoryMacBtn",false);
	setDisabled("#cloneMacBtn",true);
	var postVar = { topicurl : "setting/getStationMacByIp"};
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseMacJson = JSON.parse(Data);							
		}
    });	
	fillMyMAC();
}
function fillMyMAC(){
	var macArr = responseMacJson['stationMac'];
	var mac=macArr.split(":");
	$("#mac1").val(mac[0]);
	$("#mac2").val(mac[1]);
	$("#mac3").val(mac[2]);
	$("#mac4").val(mac[3]);
	$("#mac5").val(mac[4]);
	$("#mac6").val(mac[5]);
}
function factoryMacClick(){
	supplyValue("macCloneEnbl",0);
	supplyValue("macCloneMac",v_defaultMac);
	var macArr= $("#macCloneMac").val().split(":");
	$("#mac1").val(macArr[0]);
	$("#mac2").val(macArr[1]);
	$("#mac3").val(macArr[2]);
	$("#mac4").val(macArr[3]);
	$("#mac5").val(macArr[4]);
	$("#mac6").val(macArr[5]);
	setDisabled("#factoryMacBtn",true);
	setDisabled("#cloneMacBtn",false);
}
function showMac(){
	var currMac=(v_enCloneMac==1?v_cloneMac:v_defaultMac);
	supplyValue("macCloneEnbl",v_enCloneMac);
	supplyValue("macCloneMac",currMac);
	var macArr=currMac.split(":");
	$("#mac1").val(macArr[0]);
	$("#mac2").val(macArr[1]);
	$("#mac3").val(macArr[2]);
	$("#mac4").val(macArr[3]);
	$("#mac5").val(macArr[4]);
	$("#mac6").val(macArr[5]);
	if(v_enCloneMac ==1){
		setDisabled("#factoryMacBtn",false);
		setDisabled("#cloneMacBtn",true);
	}else{
		setDisabled("#factoryMacBtn",true);
		setDisabled("#cloneMacBtn",false);
	}
}
function saveChanges(){	
	setJSONValue({
		'macCloneMac'	:	combinMAC2($("#mac1").val(),$("#mac2").val(),$("#mac3").val(),$("#mac4").val(),$("#mac5").val(),$("#mac6").val())
	});

	if ($("#macCloneMac").val() != ""){if (!checkVaildVal.IsVaildMacAddr($("#macCloneMac").val(), MM_macaddr))return false;} 
	return true;
}
function initValue(){	
	v_cloneMac      =  responseJson['macCloneMac'];
	v_defaultMac    =  responseJson['wanDefMac'];
	v_enCloneMac    =  responseJson['macCloneEnabled'];
 	
	if (v_enCloneMac == 1) {
		setDisabled("#factoryMacBtn",false);
	  	setDisabled("#cloneMacBtn",true);
		supplyValue("macCloneMac",v_cloneMac);
	}else {		
		setDisabled("#factoryMacBtn",true);
		setDisabled("#cloneMacBtn",false);
		supplyValue("macCloneMac",v_defaultMac);
	}

	if (v_cloneMac != "") {
		cloneMac_tmp=v_cloneMac.split(":");
		$("#mac1").val(cloneMac_tmp[0]);
		$("#mac2").val(cloneMac_tmp[1]);
		$("#mac3").val(cloneMac_tmp[2]);
		$("#mac4").val(cloneMac_tmp[3]);
		$("#mac5").val(cloneMac_tmp[4]);
		$("#mac6").val(cloneMac_tmp[5]);
	}
	
	showMac();
}
$(function(){
	var postVar = { topicurl : "setting/getCloneMacConfig"};
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
	if(saveChanges()==false)
		return false;
		
	var postVar ={"topicurl":"setting/setCloneMacConfig"};
	postVar['macCloneEnbl']=$('#macCloneEnbl').val();
	postVar['macCloneMac']=$('#macCloneMac').val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="wanCfg" id="wanCfg">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_clone_mac_settings)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_macaddr_clone)</script></td>
<td><input type="hidden" id="macCloneEnbl" name="macCloneEnbl"><input type="hidden" name="macCloneMac" id="macCloneMac">
<input type="text" style="width:28px" maxlength="2" name="mac1" id="mac1" onFocus="this.select();" onKeyUp="HWKeyUp('mac',1,event);" onKeyDown="return HWKeyDown('mac', 1,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac2" id="mac2" onFocus="this.select();" onKeyUp="HWKeyUp('mac',2,event);" onKeyDown="return HWKeyDown('mac', 2,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac3" id="mac3" onFocus="this.select();" onKeyUp="HWKeyUp('mac',3,event);" onKeyDown="return HWKeyDown('mac', 3,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac4" id="mac4" onFocus="this.select();" onKeyUp="HWKeyUp('mac',4,event);" onKeyDown="return HWKeyDown('mac', 4,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac5" id="mac5" onFocus="this.select();" onKeyUp="HWKeyUp('mac',5,event);" onKeyDown="return HWKeyDown('mac', 5,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac6" id="mac6" onFocus="this.select();" onKeyUp="HWKeyUp('mac',6,event);" onKeyDown="return HWKeyDown('mac', 6,event)">
<script>dw('<input type="button" class=button4 id=cloneMacBtn name=cloneMacBtn value="'+BT_clone_mac+'" onClick="cloneMacClick()">&nbsp;&nbsp;\
<input type="button" class=button4 id=factoryMacBtn name=factoryMacBtn value="'+BT_factory_mac+'" onClick="factoryMacClick()">')</script></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>