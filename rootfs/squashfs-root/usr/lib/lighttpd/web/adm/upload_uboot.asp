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
var responseJson,lanip="";

function initValue(){	
	lanip=responseJson.LanIp;
}
$(function(){
	var postVar = { topicurl : "setting/UbootUpgrade"};
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
	if (fileval.indexOf("boot")<0&&fileval.indexOf("bin")<0&&fileval.indexOf("img")<0) {
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
	var tmp=JS_msg141+0.25+JS_msg142;
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
function errorTips(msg1,msg2){
	var content_title="";
	if(upFW==1)
		content_title=MM_upgrade_uploadfwErr;
	else
		content_title=MM_upgrade_userdataErr;
	var str="";
	str+="<table width=700><tr><td><table border=0 width=\"700\"><tr>\n";
	str+="<td class='content_title'><b>"+content_title+"</b></td></tr>\n";
	str+="<tr><td><hr size=1 noshade align=top></td></tr></table><table border=0 width='700'>\n";
	str+="<tr><td>"+msg1+"</td></tr>\n";
	if(msg2!="")
		str+="<tr><td>"+msg2+"</td></tr>\n";
	str+="<tr><td colspan=2><hr size=1 noshade align=top></td></tr>\n";
	str+="<tr><td align='right' colspan=2>\n";
	str+="<input type=button class=button id=apply value="+MM_back+"  onClick=top.location.reload(true)></td></tr>\n";
	str+="</table></td></tr></table>\n";
	return str;
}
function showRebootMsg(){
	var msg_title="";
	if(upFW==1)
		msg_title=MM_upgrade_firmware;
	else
		msg_title=MM_upgrade_userdata;
	var str="";
	 	str+="<table width=700><tr><td><table border=0 width=\"100%%\">\n";
	 	str+="<tr><td style=\"font-weight:bold; font-size:14px;\">"+MM_change_setting+"</td></tr>\n";
	 	str+="<tr><td><hr size=1 noshade align=top></td></tr>\n";
 		str+="</table><table border=0 width=\"100%%\">\n";
 		str+="<tr><td rowspan=2 width=100 align=center><img src=\"/style/load.gif\" /></td>\n";
 		str+="<td class=msg_title>"+msg_title+"</td></tr>\n";
 		str+="<tr><td>"+MM_please_wait+"&nbsp;<span id=show_sec>"+wtime+"</span>&nbsp;"+MM_seconds+" ...</td></tr>\n";
 		str+="<tr><td colspan=2><hr size=1 noshade align=top></td></tr>\n";
 		str+="</table></td></tr></table>\n";
	return str;
}
var wtime=90;
function count_down(){
	wtime--;
	var iframeObj = document.getElementById("ifmShowMessage");
	var subObj=(iframeObj.Document?iframeObj.Document.body:iframeObj.contentDocument.body);
	subObj.innerHTML=showRebootMsg();
	if(wtime == 0) {parent.location.href='http://'+lanip+'/login.asp'; return false;}
	if(wtime > 0) {setTimeout('count_down()',1000);}
}
function showuploasuccess(){
	$("#div_main").hide();
	count_down();
	$("#div_showMessage").show();
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
	
	if(messJson!="" && messJson.indexOf("web_timeout!") < 0 &&
		(messJson.indexOf("upgradeStatus")>=0||messJson.indexOf("upgradeERR1")>=0)){
		var responseJsonMsg=JSON.parse(messJson);
		if(responseJsonMsg['upgradeStatus']=="1"){
			setTimeout("showuploasuccess();",5000);					
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
				$("#div_main").hide();
				$("#div_showMessage").show();
				subObj.innerHTML=errorTips(message1,message2);
			}
		}
	}else{
		setTimeout("showMessage();",1000);
	}
}
</script>
</head>

<body class="mainbody">
<div id="div_main">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post id="uploadFirmware" name="uploadFirmware" action="/cgi-bin/cstecgi.cgi?action=upload&setting/setUpgradeUboot" enctype="multipart/form-data" target="ifmShowMessage">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_upgrade_uboot)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_upgrade_uboot)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr style="display:none">
<td class="item_left"><script>dw(MM_firmware_version)</script></td>
<td id="showVersion"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_file)</script></td>
<td><input type="file" name="filename" id="filename" size="20" maxlength="256" > <script>dw('<input type="button" class=button value="'+BT_upgrade+'" name="upgrade" id="upgrade" onClick="uploadFirmwareClick()">')</script></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
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
<iframe id="ifmShowMessage" name="ifmShowMessage" src="#" onload="" marginheight="0" marginwidth="0" frameBorder="0" width="100%" height="900;"></iframe>
</div>
</body></html>
