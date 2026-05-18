<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript" src="../js/ajax.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="JavaScript">
var dlna_enable,dlna_port,dlna_friend_name,dlna_scan,usb_state,rules_num,index,lan_ip;
var portStatus=1;
var responseDlnaCfg,responseDlnaDir,responseDlnaStatus;
function initValue(){
	dlna_enable=responseDlnaCfg['DlnaEnabled'];
	dlna_port=responseDlnaCfg['DlnaPort'];
	dlna_friend_name=responseDlnaCfg['DlnaName'];
	dlna_scan=responseDlnaCfg['DlnaScan'];
	usb_state=responseDlnaCfg['UsbFlag'];
	lan_ip=responseDlnaCfg['lanIp'];
	
	showDlnaDirList();
	if (!rules_num)
		setDisabled('dirdelete', false);
	else 
		setDisabled('dirdelete', true);
		
	if(responseDlnaCfg['usb_sdcardBt']==1)
		supplyValue("usbdevice_check", MSG_sdcard_check);
	else
		supplyValue("usbdevice_check", MSG_usb_check);
	
	if (usb_state == 0)	{
		$("#div_no_usbdivice").show();
		$("#div_usbdivice").hide();
	}else{
		$("#div_no_usbdivice").hide();
		$("div_usbdivice").show();
		setJSONValue({
			'DLNAPort'         : dlna_port,
			'friend_name'      : dlna_friend_name,
			'DLNAEnabled'      : dlna_enable,
			'rescan_h'         : dlna_scan
		});
	
		dlna_enable_switch();
		if($(':radio[name="DLNAEnabled"]:checked').val()){
			$("#AddDir, #DelDir").show();
		}else{
			$("#AddDir, #DelDir").hide();
		}
	}
	update_state();
}
function CheckValue(){
	var reg_l = /^\w+$/;
	if($(':radio[name="DLNAEnabled"]:checked').val()== 1){
		if ($("#DLNAPort").val() == ""){
			alert(MM_port+JS_msg18);
			$("#DLNAPort").focus();
			return false;
		}else if (!checkVaildVal.IsVaildPort($("#DLNAPort").val(),MM_port)){
			return false;	
		}else if(!portStatus){
			alert(MM_minidlna_setting+JS_msg115);
			return false;
		}	

		if ($("#friend_name").val() == ""){
			alert(JS_msg121);
			$("#friend_name").focus();
			return false;
		}else if(!reg_l.test($("#friend_name").val())){
			alert(JS_msg116);
			$("#friend_name").focus();
			return false;
		}
	}
	return true;
}
function CheckValue_dir(){
	if (rules_num >= 4){
		alert(JS_msg122);
		return false;
	}

	if($(':radio[name="DLNAEnabled"]:checked').val()== 1){
		if ($("#direct").val() == ""){
			alert(JS_msg123);
			$("#direct").focus();
			return false;
		}
	}
    $("#showlb").show();   
	return true;
}
function deleteClick(){
   	for(i=0; i< rules_num; i++) {
		var tmp = eval("document.DelDir.delRule"+i);
		if(tmp.checked == true)
			return true;
	}
	alert(JS_msg36);
	return false;
}
function dlna_enable_switch(){
	if ($(':radio[name="DLNAEnabled"]:checked').val()== 1){
		setDisabled("#DLNAPort, #friend_name, #rescan_h", false);
		$("#tr_div1, #tr_div2, #tr_div3").show();
	}else{
		setDisabled("#DLNAPort, #friend_name, #rescan_h", true);
		$("#tr_div1, #tr_div2, #tr_div3").hide();
	}
}
function open_diradd_window(){
	window.open("minidlna_add_dir.asp","media_path","toolbar=no, location=yes, scrollbars=yes, resizable=no, width=640, height=480")
}
function resultFun(data){
	if(data==1){
		portStatus=0;
	}else{
		portStatus=1;
	}
}
function checkPort(){
	var postVar ={"topicurl":"setting/checkPort"};
	postVar['port']  = $('input[name="DLNAPort"]').val();
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			var responseFtpCfg = JSON.parse(Data);
			resultFun(responseFtpCfg['portStatus']);
		}
    });
}
function checkPort2(){
	if($("#DLNAPort").val() !=dlna_port)
	checkPort();
}
function getMediaType(val){
	if(val=="ALL")
		return MM_any_media_type;
	else if(val=="V")
		return MM_video;
	else if(val=="P")
		return MM_image;
	else
		return MM_audio;
}
function showDlnaDirList(){
	var dirTab = $("#div_showDlna").get(0);
	var trNode;
	rules_num=0;
	for(var i=1;i<responseDlnaDir.length;i++){
		trNode=dirTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML=(rules_num+1)+'<input type=\"checkbox\" id=\"'+responseDlnaDir[i].delRuleName+'\" name=\"'+responseDlnaDir[i].delRuleName+'\" value=\"'+responseDlnaDir[i].delRuleName+'\" >';
		trNode.insertCell(1).innerHTML=responseDlnaDir[i].path;
		trNode.insertCell(2).innerHTML=getMediaType(responseDlnaDir[i].mediaType);
		rules_num++;
	}
}
$(function(){
	var postVar = { topicurl : "setting/getDlnaCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseDlnaCfg = JSON.parse(Data);
		}
    });
	
	var postVar = { topicurl : "setting/Dlna_Show"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseDlnaDir = JSON.parse(Data);
		}
    });
	initValue();
});
function update_state(){
	var postVar = { topicurl : "setting/Dlna_RefreshFileNum"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : true,  
        success : function(Data){
			responseDlnaStatus = JSON.parse(Data);
			var dlnanum=responseDlnaStatus['mediaNum'].split("?");
			setJSONValue({
				'div1' : dlnanum[0],
				'div2' : dlnanum[1],
				'div3' : dlnanum[2]
			});
		}
    });
	setTimeout("update_state()", 5000);
}
function doSubmit(){	
	if (CheckValue()==false)
		return false;
		
	var postVar ={"topicurl":"setting/Dlna_Init"};
	postVar['DLNAEnabled']  = $(':radio[name="DLNAEnabled"]:checked').val();
	postVar['DLNAPort']  = $('input[name="DLNAPort"]').val();
	postVar['rescan_h']  = $('input[name="rescan_h"]').get(0).checked?"ON":"";
	postVar['friend_name']  = $('input[name="friend_name"]').val();
	uiPost(postVar);
}
function dlnaAddDir(){	
	if (CheckValue_dir()==false)
		return false;
		
	var postVar ={"topicurl":"setting/Dlna_Add"};
	postVar['media_type']  = $('select[name="media_type"]').val();
	postVar['direct']  = $('input[name="direct"]').val();
	uiPost(postVar);
}
function doDelete(){	
	var flg=0;
	var postVar ={"topicurl":"setting/Dlna_Del"};
    for (i=0; i< rules_num; i++){
		var tmp = $("#delRule"+i).get(0);
		if (tmp.checked == true){
			postVar['delRule'+i]= i;
			flg=1;
		}
	}
	if(flg==0){
		alert(JS_msg128);
	 	event.returnValue = false;
	}
	
	if(flg==1){
		uiPost(postVar);
	}
}
</script>
</head>

<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<div id="div_no_usbdivice" style="display:none">
<table border=0 width="100%">
<tr><td><img src="../graphics/warning.gif" align="absmiddle">&nbsp;&nbsp;<span id="usbdevice_check">&nbsp;</span>&nbsp;&nbsp;
<script>dw('<input type=button class=button value="'+BT_refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</div>

<div id="div_usbdivice">
<form method=post name="DLNA"  id="DLNAPOST" action="/goform/Dlna_Init">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_minidlna_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_minidlna_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><input class=radio type=radio name="DLNAEnabled" value="1" onClick="dlna_enable_switch();checkPort2();"><script>dw(MM_enable)</script>
<input class=radio type=radio name="DLNAEnabled" value="0" onClick="dlna_enable_switch();checkPort2();" checked><script>dw(MM_disable)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_port)</script></td>
<td><input type=text id="DLNAPort" name="DLNAPort" maxlength=5 size="5" class="navi_text" onChange="checkPort();"></td>
</tr>
<tr style="display:none;"> 
<td class="item_left">TiVO</td>
<td><input class=radio type=radio name="TIVOEnabled" value="1" checked><script>dw(MM_enable)</script>
<input class=radio type=radio name="TIVOEnabled" value="0"><script>dw(MM_disable)</script> </td>
</tr>
<tr style="display:none;"> 
<td class="item_left">Reduzir Imagens JPEG muito grandes</td>
<td><input class=radio type=radio name="StrictDLNA" value="1" checked><script>dw(MM_enable)</script>
<input class=radio type=radio name="StrictDLNA" value="0"><script>dw(MM_disable)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_device_name)</script> </td>
<td><input type=text id="friend_name" name="friend_name" maxlength=32></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_mandatory)</script> </td>
<td><input type="checkbox"  id="rescan_h" name="rescan_h" value="ON"></td>
</tr>
<tr id="tr_div1">
<td class="item_left"><script>dw(MM_audio)</script></td>
<td ><span id="div1"></span></td>
</tr>
<tr id="tr_div2">
<td class="item_left"><script>dw(MM_video)</script></td>
<td ><span id="div2"></span></td>
</tr>
<tr id="tr_div3">
<td class="item_left"><script>dw(MM_image)</script></td>
<td ><span id="div3"></span></td>
</tr>
</table>
<br>
<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="setTimeout(doSubmit,250)">')</script></td></tr>
</table>
</form>

<form method=post name="DelDir" id="DelDir" style="display:none;" action="/goform/Dlna_Del">
<table border=0 width="100%">
<tr><td class="title3" colspan="3"><script>dw(MM_current_media_dir)</script></td></tr>
<tr><td colspan="3"><hr size=1 noshade align=top class=bline></td></tr>
<tr class="title4" align=center>
<td><script>dw(MM_index)</script></td>
<td><script>dw(MM_directory)</script></td>
<td><script>dw(MM_content_type)</script></td>
</tr>
<tbody id="div_showDlna"></tbody>
</table>

<br>
<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button onClick="return doDelete();" value="'+BT_delete+'"id="dirdelete" name="dirdelete" >')</script></td></tr>
</table>
</form>

<form method=post name="AddDir" id="AddDir" style="display:none;" action="/goform/Dlna_Add">
<table border=0 width="100%">
<tr><td class="title3" colspan="2"><script>dw(MM_add_media_dir)</script></td></tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
<tr>
<td class="item_left"><script>dw(MM_directory)</script></td>
<td><input type=text id="direct" name="direct" maxlength=128 size="32"> 
<script>dw('<input type="button" class="button" onClick="open_diradd_window();" value="'+BT_scan+'"/>')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_content_filter)</script></td>
<td><select class="list" id="media_type" name="media_type">
<option value="all"><script>dw(MM_any_media_type)</script></option>
<option value="audio"><script>dw(MM_audio)</script></option>
<option value="video"><script>dw(MM_video)</script></option>
<option value="images"><script>dw(MM_image)</script></option>
</select></td>
</tr>
<tr>
<td>&nbsp;</td>
<td><span id="showlb" style="display:none"><script>dw(MM_wait)</script></span></td>
</tr>
</table>

<br>
<table width=100% border=0 cellpadding=3 cellspacing=1> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_add+'" onClick="return dlnaAddDir();">')</script>
<span id="showlb" style="display:none"><script>dw(MM_wait)</script></span></td></tr>
</table>
</form>
</div>
<form method=post id="portcheckfrm" action="/goform/checkPort" style="display:none;">
<input type=text id="enabled" name="enabled" value="">
<input type=text id="port" name="port" value="">
</form>
<script>showFooter()</script>
</body></html>