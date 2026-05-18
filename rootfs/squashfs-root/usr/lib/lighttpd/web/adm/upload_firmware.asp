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
var MWJ_progBar = 0;
var time=0;
var delay_time=1500;
var loop_num=0;
var lanip="";
var v_cloudFw,v_pluginlist;
var JsonVerInfo,JsonResult,PlugCount=0;

function showPluginList()
{
	PlugCount=0;
	$("#uploadUserdata").hide();
	if(JsonVerInfo.CustomUpgrade!="1"){
		return false;
	}
	$("#div_pluginlist").empty();
	$("#uploadUserdata").show();
	$("#div_pluginlist").html("");
	v_pluginlist = JsonVerInfo['plugList'];
	if(v_pluginlist.length > 0)
	{
		var tb_tmp="",tmp,tmp_ap,pname;
		for(var i=0;i < v_pluginlist.length;i++){
			PlugCount++;
			tmp_ap=v_pluginlist[i];
			pname=tmp_ap['name'];
			tb_tmp+='<tr><td align="center">' + PlugCount + '</td>';
			tb_tmp+='<td align="center">' + pname + '</td>';
			tb_tmp+='<td align="center">' + tmp_ap['version'] + '</td>';
			tb_tmp+='<td align="center"><span id="newver_' + pname + '">&nbsp;</span></td>';
			tb_tmp+='<td align="center"><input type=button disabled value='+BT_upgrade+' id="upg_'+pname+'" onClick="cloud_upg_plugin(\''+pname+'\')">';
			tb_tmp+='&nbsp;&nbsp;<input type=button value='+BT_unmount+' id=unload_'+pname+' onClick="unloadUserdataClick(\''+pname+'\')">';
			tb_tmp+='<input type=hidden value="" id="cfg_'+pname+'" ></td></tr>';
		}
		$("#div_pluginlist").html(tb_tmp);
	}
	
	//show plugin check result
	if(JSON.stringify(JsonResult)=="{}"){
		return false;
	}
	if(JSON.stringify(JsonResult['newVersion'])==undefined)
		return false;
	var newVersion=JSON.parse(JsonResult['newVersion']);
	if(newVersion['plugin'].length > 0){
		var tb_tmp="",tmp,tmp_ap,pname;
		var pluginlist=newVersion['plugin'];
		for(var i=0;i < pluginlist.length;i++){
			tmp_ap=pluginlist[i];
			pname=tmp_ap['name'];
			var tmpver=tmp_ap['version'];
			if($("#newver_"+pname).length > 0){
				$("#newver_"+pname).html(tmpver);
				$("#cfg_"+pname).val(tmp_ap['url']+','+tmp_ap['magicid']);
				if(JSON.stringify(tmpver)!=undefined)
					$("#upg_"+pname).attr("disabled",false);
				continue;
			}
			
			PlugCount++;
			tb_tmp+='<tr><td align="center">' + PlugCount + '</td>';
			tb_tmp+='<td align="center">' + pname + '</td>';
			tb_tmp+='<td align="center"> &nbsp;</td>';
			tb_tmp+='<td align="center"><span id="newver_' + pname + '">'+tmpver+'</span></td>';
			tb_tmp+='<td align="center"><input type=button value='+BT_upgrade+' id="upg_'+pname+'" onClick="cloud_upg_plugin(\''+pname+'\')">';
			tb_tmp+='&nbsp;&nbsp;<input type=button disabled value='+BT_unmount+' id=unload_'+pname+' onClick="unloadUserdataClick(\''+pname+'\')">';
			tb_tmp+='<input type=hidden id="cfg_'+pname+'" value="'+tmp_ap['url']+','+tmp_ap['magicid']+'" ></td></tr>';
		}
		$("#div_pluginlist").append(tb_tmp);
	}
}
function showCheckResult()
{
	showPluginList();
	if(JSON.stringify(JsonResult)=="{}"){
		$("#div_fw_result").hide();
		return false;
	}
	else
	{
		$("#div_fw_result").show();
	}
	//show fw check result
	if(JsonResult['cloudFwStatus'] == "New"){
		var newVersion=JSON.parse(JsonResult['newVersion']);
		if(newVersion.length != 0){
			var svn = newVersion['svn'];
			var version = newVersion['version'];
			var tmpStr=MM_cloud_found_new_fw;
			tmpStr+="&nbsp;&nbsp;"+version+"."+svn+"&nbsp;&nbsp;";
			tmpStr+='<input type=button class=button value="'+BT_upgrade+'" onClick="cloud_update_fw()">';
			$("#span_fw_result").html(tmpStr);
		}
	}else if(JsonResult['cloudFwStatus'] == "UnNet"){
		$("#span_fw_result").html(MM_cloud_unnet);
	}else if(JsonResult['cloudFwStatus'] == "Update"){
		$("#span_fw_result").html(MM_cloud_updateing);
	}else{
		$("#span_fw_result").html(MM_cloud_fwlast);
	}
}

function initValue(){
	lanip=JsonVerInfo.LanIp;
	setJSONValue({
		"showVersion"   : JsonVerInfo.FirmwareVersion,
		"showbuilttime" : checkDate(JsonVerInfo.SysBuiltTime)
	});
	v_cloudFw=JsonVerInfo['cloudFw'];
	if(v_cloudFw=="1"){
		$("#div_cloud_check_button,#div_userdata_check_button,#div_fw_result").show();
	}else{
		$("#div_cloud_check_button,#div_userdata_check_button,#div_fw_result").hide();
	}
	
	JsonResult = {};
	showCheckResult();
}
$(function(){
	var postVar = { topicurl : "setting/FirmwareUpgrade"};
	postVar = JSON.stringify(postVar);
	var postVar1 = { topicurl : "setting/CloudSrvCheckResult"};
	postVar1 = JSON.stringify(postVar1);
	
	$.when( $.post( " /cgi-bin/cstecgi.cgi", postVar),
			$.post( " /cgi-bin/cstecgi.cgi", postVar1))
    .done(function( Data0, Data1 ) {
		JsonVerInfo = JSON.parse(Data0[0]);
		JsonResult = JSON.parse(Data1[0]);
		
		initValue();
    })
	.fail(function(){
		resetForm();
	});
});
function progress(){
  	if (loop_num == 3) {
		return false;
  	}
  	if (time < 1) 
		time = time + 0.033;
  	else {
		time = 0;
		loop_num++;
		$("#progress_div").hide();
  	}
  	setTimeout('progress()',delay_time);  
  	myProgBar.setBar(time); 
}

function checkFileName(filenameid){
	var fileval=$(filenameid).val();
	if (fileval == "") {
		alert(JS_msg81);
		return false;
	}	
	if (fileval.indexOf("web")<0&&fileval.indexOf("bin")<0&&fileval.indexOf("_uImage")<0) {
		alert(JS_msg81);
  		$(filenameid).focus();
  		return false;
  	}
	return true;
}
var upFW=1;
function uploadFirmwareClick(){
	if(!checkFileName("#filename")){
		return false;
	}
	var tmp=JS_msg141+JsonVerInfo.FlashSize+JS_msg142;
	if(!confirm(tmp)){
		return false;
	}
   	$("#uploadFirmware").submit();
  	$("#progress_div").show();   
  	progress();
	showMessage();
	$(":input").attr("disabled",true);
	return true;
}

function unloadUserdataClick(pname){
	var postVar ={"topicurl":"setting/setUnloadUserData"};
	postVar['plugin_name']=pname;
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		var responseJson = JSON.parse(Data);
		lanip=responseJson['lan_ip'];
		wtime=responseJson['wtime'];
		ShowRebootPage();
	});
	return true;
}

function uploadUserdataClick(){
	if(!checkFileName("#Userdatafilename")){
		return false;
	}
   	$("#uploadUserdata").submit();
  	$("#progress_div").show();   
  	progress();
	showMessage();
	upFW=0;
	$(":input").attr("disabled",true);
	return true;
}

var wtime=165;
function count_down(){
	wtime--;
	var msg_title="";
	$("#show_sec").html(wtime);
	if(wtime == 0) {parent.location.href='http://'+lanip+'/login.asp'; return false;}
	if(wtime > 0) {setTimeout('count_down()',1000);}
}

function ShowRebootPage()
{
	if(upFW==1)
		$("#td_wait_title").html(MM_upgrade_firmware);
	else
		$("#td_wait_title").html(MM_upgrade_userdata);
	count_down();
	
	$("#div_body_setting").hide();
	$("#div_wait").show();
}

function showMessage(){
	var iframeObj = document.getElementById("ifmShowMessage");
	var subObj="";
	var messJson="";
	try{
		subObj=(iframeObj.Document?iframeObj.Document.body:iframeObj.contentDocument.body);
		messJson=subObj.innerHTML.replace(/<(.*)>/ig,"");	
	}catch(e){
		alert(MM_cloud_fw2flash1);   
        resetForm();			
	}
	
	if(messJson!="" && messJson.indexOf("timeout") < 0 &&
		(messJson.indexOf("upgradeStatus")>=0||messJson.indexOf("upgradeERR1")>=0)){
		var responseJsonMsg=JSON.parse(messJson);
		if(responseJsonMsg['upgradeStatus']=="1"){
			if(upFW == 0){
				wtime=5;		
				setTimeout("ShowRebootPage();",5000);
			}else{
				setTimeout("ShowRebootPage();",15000);
			}
		}else{ 
			var message1,message2;
			if(responseJsonMsg['upgradeERR1'].indexOf("RFC1867")>0)
				message1=MM_cloud_fw2flash1;
			else
				message1=eval(responseJsonMsg['upgradeERR1']);
				
			if(responseJsonMsg['upgradeERR2']==undefined)
				message2="";
			else
				message2=eval(responseJsonMsg['upgradeERR2']);
	
			if(message1!=""){
				if(upFW==1)
					$("#td_error_title").html(MM_upgrade_uploadfwErr);
				else
					$("#td_error_title").html(MM_upgrade_userdataErr);
				$("#show_error_msg").html(message1+message2);
				
				$("#div_body_setting").hide();
				$("#div_error").show();
				$(":input").attr('disabled',false);
			}
		}
	}else{
		setTimeout("showMessage();",1000);
	}
}
function showMessageCloud(responseJsonMsg)
{
	if(responseJsonMsg['upgradeStatus']=="1"){
		if(upFW == 0){
			setTimeout("ShowRebootPage();",5000);
		}else{
			setTimeout("ShowRebootPage();",25000);
		}				
	}else{ 
		var message1,message2;
		if(responseJsonMsg['upgradeERR1'].indexOf("RFC1867")>0)
			message1=MM_cloud_fw2flash1;
		else
			message1=eval(responseJsonMsg['upgradeERR1']);
			
		if(responseJsonMsg['upgradeERR2']==undefined)
			message2="";
		else
			message2=eval(responseJsonMsg['upgradeERR2']);

		if(message1!=""){		
			if(upFW==1)
				$("#td_error_title").html(MM_upgrade_uploadfwErr);
			else
				$("#td_error_title").html(MM_upgrade_userdataErr);
			$("#show_error_msg").html(message1+message2);
			
			$("#div_body_setting").hide();
			$("#div_error").show();
			$(":input").attr('disabled',false);
		}
	}
}

function check_cloud_update_fw(){
	var postVar ={"topicurl":"setting/CloudSrvVersionCheck"};
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		JsonResult = JSON.parse(Data);
		$(":input").attr('disabled',false);
		showCheckResult();
	});
}

function cloud_update_fw(){
	var postVar ={"topicurl":"setting/setUpgradeFW"};
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);	
	$("#progress_div").show();   
  	progress();
	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		if( Data.indexOf("timeout")<0 ){
			var responseJson = JSON.parse(Data);
			showMessageCloud(responseJson);
		}else{
			setTimeout("ShowRebootPage();",5000);
		}
	});
}

function cloud_upg_plugin(pname)
{
	pval=$("#cfg_"+pname).val();
	var postVar ={"topicurl":"setting/CloudACMunualUpdateUserdata"};
	postVar['name']=pname;
	postVar['url']=pval.split(',')[0];
	postVar['magicid']=pval.split(',')[1];
	postVar = JSON.stringify(postVar);
	
	upFW=0;
	wtime=5;
	$(":input").attr('disabled',true);
	$("#progress_div").show();
  	progress();
	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		if( Data.indexOf("timeout")<0 ){
			var responseJson = JSON.parse(Data);
			showMessageCloud(responseJson);
		}else{
			setTimeout("ShowRebootPage();",5000);
		}
	});
	return true;
}
</script>
</head>

<body class="mainbody">
<span id="div_body_setting">
<div id="div_main">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post id="uploadFirmware" name="uploadFirmware" action="/cgi-bin/cstecgi.cgi?action=upload&setting/setUpgradeFW" enctype="multipart/form-data" target="ifmShowMessage">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_upgrade_firmware)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_upgrade_firmware)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_firmware_version)</script></td>
<td>
<span id="showVersion"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<span id="div_cloud_check_button" style="display:none"><script>dw('<input type=button class=button value="'+MM_cloud_checkNewVersion+'" onClick="check_cloud_update_fw()">')</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_build_time)</script></td>
<td><span id="showbuilttime"></span></td>
</tr>
<tr id="div_fw_result" style="display:none">
<td class="item_left"><script>dw(MM_cloud_checkresult)</script></td>
<td><span id="span_fw_result">&nbsp;</span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_local_upg)</script></td>
<td><input type="file" name="filename" id="filename" size="20" maxlength="256" style="width: 50%;" > <script>dw('<input type="button" class=button value="'+BT_upgrade+'" name="upgrade" id="upgrade" onClick="uploadFirmwareClick()">')</script></td>
</tr>
<tr><td colspan="3"><hr size=1 noshade align=top class=bline></td></tr>
</table>
</form>

<form method=post id="uploadUserdata" name="uploadUserdata" action="/cgi-bin/cstecgi.cgi?action=upload&setting/setUploadUserData" enctype="multipart/form-data" target="ifmShowMessage" style="display:none">
<table border=0 width="100%"> 
<tr><td class="content_title" colspan="2"><script>dw(MM_upgrade_userdata)</script></td></tr>
<tr id="div_content_help"><td class="content_help" colspan="2"><script>dw(MSG_upgrade_userdata)</script></td></tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
<td class="item_left"><script>dw(MM_local_upg)</script></td>
<td><input type="file" name="Userdatafilename" id="Userdatafilename" size="20" maxlength="256"> <script>dw('<input type="button" class=button value="'+BT_upgrade+'" name="upgrade" id="upgradeUserdata" onClick="uploadUserdataClick()">')</script></td>
</tr>
<tr>
<td class="item_left" colspan="2"><script>dw(MM_plugin_list)</script></td>
</tr>
</table>
<table border=0 width="100%">
<tr>
<td class="item_center" align="center">ID</td>
<td class="item_center" align="center"><script>dw(MM_plugin_name)</script></td>
<td class="item_center" align="center"><script>dw(MM_current_version)</script></td>
<td class="item_center" align="center"><script>dw(MM_cloud_checkNewVersion)</script></td>
<td class="item_center" align="center"><script>dw(MM_cloud_option)</script></td>
</tr>
<tbody id="div_pluginlist" ></tbody>
</table>
</form>

<script language="javascript1.2">
var myProgBar = new progressBar(
1,         //border thickness
'#ffffff', //border colour
'#ffffff', //background colour
'#000000', //bar colour
300,       //width of bar (excluding border)
15,        //height of bar (excluding border)
1          //direction of progress: 1 = right, 2 = down, 3 = left, 4 = up
);
</script>
<script>showFooter()</script>
</div>
<div id="div_showMessage" style="display:none">
<iframe id="ifmShowMessage" name="ifmShowMessage" src="" onload="" marginheight="0" marginwidth="0" frameBorder="0" width="100%" height="900;"></iframe>
</div>
</span>

<span id="div_wait" style="display:none">
<table border=0 width=700>
<tr><td class="content_title" id="td_wait_title" colspan=2><script>dw(MM_upgrade_firmware)</script></td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><span id=show_msg></span></td></tr>
<tr><td colspan=2><script>dw(MM_please_wait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table>
</span>

<span id="div_error" style="display:none">
<table border=0 width=700>
<tr><td class="content_title" id="td_error_title"><script>dw(MM_upgrade_uploadfwErr)</script></td></tr>
<tr><td ><hr size=1 noshade align=top class=bline></td></tr>
<tr><td class=msg_title id=show_error_msg><script>dw(MM_cloud_fw2flash1)</script></td></tr>
<tr><td >&nbsp;</td></tr>
<tr><td ><script>dw("<input type=button class=button id=apply value="+MM_back+' onClick="resetForm()">')</script></td></tr>
<tr><td ><hr size=1 noshade align=top class=bline></td></tr>
</table>
</span>
</body></html>
