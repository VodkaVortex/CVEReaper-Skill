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
function updateConfigClick(){
	var fileval=$("#filename").val();
	if (fileval == "") {
		alert(JS_msg80);
		return false;
	}
	if (fileval.indexOf(".dat")<0&&fileval.indexOf(".tar.gz")<0) {
		alert(JS_msg81);
		return false;
	}
	if(!confirm(JS_msg143)) return false;
	return true;
}
function fileChange(target,id) {     
	var fileSize = 0; 
	var isIE = /msie/i.test(navigator.userAgent) && !window.opera;         
	if (isIE && !target.files) {      
		var filePath = target.value;  
		try{   
		  	var fileSystem = new ActiveXObject("Scripting.FileSystemObject"); 
			var file = fileSystem.GetFile (filePath);  
			fileSize = file.Size;  
		}catch(e){} 	 
	} else {   		
		fileSize = target.files[0].size;  
	}    
	  
	var size = fileSize / (1024*1024); 
	if(size>1){   
		alert(MSG_config_big);   
		var file=document.getElementById(id);   
		file.outerHTML=file.outerHTML;
		return false;
	}      
}
function loadDefaultClick(){
	if ( !confirm(JS_msg85) ) 	return false;
	var postVar ={"topicurl":"setting/LoadDefSettings"};
	$("#show_msg").html(JS_msg84);
	uiPost2(postVar);
}
function rebootClick(){
	if ( !confirm(JS_msg82) ) 	return false;
	var postVar ={"topicurl":"setting/RebootSystem"};
	$("#show_msg").html(JS_msg83);
	uiPost2(postVar);
}
function waitpage(){
	$("#div_setting").hide();
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
		do_count_down();
	});
}
function do_count_down(){
	document.getElementById("show_sec").innerHTML = wtime;
	if(wtime == 0) {parent.location.href='http://'+lanip+'/home.asp'; return false;}
	if(wtime > 0) {wtime--;setTimeout('do_count_down()',1000);}
}
function errorTips(msg){
var str="";
	str+="<table width=700><tr><td><table border=0 width=\"700\"><tr>\n";
	str+="<td class='content_title'><b>"+MSG_config_tips+"</b></td></tr>\n";
	str+="<tr><td><hr size=1 noshade align=top></td></tr></table><table border=0 width='700'>\n";
	str+="<tr><td>"+eval(msg)+"</td></tr>\n";
	str+="<tr><td colspan=2><hr size=1 noshade align=top></td></tr>\n";
	str+="<tr><td align='right' colspan=2>\n";
	str+="<input type=button class=button id=apply value="+MM_back+"  onClick=top.frames['view'].location.reload(true)></td></tr>\n";
	str+="</table></td></tr></table>\n";
	return str;
}
var flag=0;
function showMessage(){
	var iframeObj = document.getElementById("ifmShowMessage");
	var subObj;
	var	messJson; 
	try{
		subObj=(iframeObj.Document?iframeObj.Document.body:iframeObj.contentDocument.body);
		messJson=subObj.innerHTML.replace(/<(.*)>/ig,"");	
	}catch(e){
		alert(MSG_config_big);   
        resetForm();
	}
	if(messJson!="" && messJson.indexOf("web_timeout!") < 0&&messJson.indexOf("settingERR")>=0){
		var responseJsonMsg=JSON.parse(messJson);
		var message=responseJsonMsg.settingERR;
		if(message=="1" &&flag==0){
			flag=1;	
			$("#div_setting").hide();
			$("#div_wait").show();
			var postVarReboot ={"topicurl":"setting/RebootSystem"};
			postVarReboot = JSON.stringify(postVarReboot);
			setTimeout('waitpage()',4000);
			$.post(" /cgi-bin/cstecgi.cgi",postVarReboot,
			function(Data){	
				var responseJson = JSON.parse(Data);
				lanip=responseJson['lan_ip'];
				wtime=responseJson['wtime'];
				do_count_down();
			});	
		}else{
			if(messJson.indexOf("web_timeout!")<0 &&flag==0){		
				if(message!=""){
					flag=1;			
					$("#div_setting").hide();
					$("#div_showMessage").show();			
					subObj.innerHTML=errorTips(message);
				}			
			}
		}		
	}
}
</script>
</head>
<body class="mainbody">
<div id="div_setting">
<script>showToper()</script>
<script>showContainer()</script>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_saveconf)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_saveconf)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<form method="post" name="ExportSettings" action="/cgi-bin/ExportSettings.sh">
<tr>
<td class="item_left"><script>dw(MM_save_config_file)</script></td>
<td><script>dw('<input type="submit" class="button_big" name="save" value="'+BT_save+'">')</script></td>
</tr>
</form>

<form method="post" name="ImportSettings" action="/cgi-bin/cstecgi.cgi?action=upload&setting/setUploadSetting" enctype="multipart/form-data" target="ifmShowMessage">
<tr>
<td class="item_left"><script>dw(MM_update_config_file)</script></td>
<td><input type="File"  id="filename" name="filename" size="20" maxlength="256" > 
<script>dw('<input type=submit class=button_big value="'+BT_update+'" onClick="return updateConfigClick()">')</script></td>
</tr>
</form>

<form method="post" name="LoadDefaultSettings">
<tr id="div_load_default">
<td class="item_left"><script>dw(MM_restore_factory_default)</script></td>
<td><script>dw('<input type="button" class=button_big name="restore" value="'+BT_restore+'" onClick="loadDefaultClick()">')</script></td>
</tr>
</form>

<form method="post" name="rebootSystem">
<tr>
<td class="item_left"><script>dw(MM_reboot_system)</script></td>
<td><script>dw('<input type="button" class=button_big value="'+BT_reboot+'" name="reboot" onClick="rebootClick()">')</script></td>
</tr>
</form>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>
<script>showFooter()</script>
</div>

<div id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_change_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><span id=show_msg></span></td></tr>
<tr><td><script>dw(MM_please_wait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table></td></tr></table>
</div>

<div id="div_showMessage" style="display:none">
<iframe id="ifmShowMessage" name="ifmShowMessage" src="#" onload="showMessage();" marginheight="0" marginwidth="0" frameBorder="0" width="100%" height="900;">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
</iframe>
</div>
</body></html>
