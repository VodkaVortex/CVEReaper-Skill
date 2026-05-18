<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript">
var responseJson,v_usb_state,v_smbenabled,v_smbwg,v_smbnetbios,v_username,all_str,rules_num;
function initValue(){
	v_usb_state=responseJson['UsbFlag'];
	v_smbenabled=responseJson['SmbEnabled'];
	v_smbwg=responseJson['HostName'];
	v_smbnetbios=responseJson['SmbNetBIOS'];
	v_username=responseJson['username']
	all_str=responseJson['AdmUsers'];
	rules_num=responseJson['SmbRuleNums'];
	
	if(responseJson['usb_sdcardBt']==1)
		supplyValue("usbdevice_check", MSG_sdcard_check);
	else
		supplyValue("usbdevice_check", MSG_usb_check);
	
	if (v_usb_state == 0){	
		$("#div_no_usbdivice").show();
		$("#div_usbdivice").hide();
	} 
	else {	
		$("#div_no_usbdivice").hide();
		$("#div_usbdivice").show();
	}
	
	$("#showUsername").html(v_username);
	
    setDisabled("#smb_workgroup,#smb_netbios,#add,#del",true);
	
	if (v_smbenabled == "1"){
		setJSONValue({
			"smb_enabled"      : "1",
			"smb_workgroup"    : v_smbwg,
			"smb_netbios"      : v_smbnetbios
		});
		setDisabled("#smb_workgroup,#smb_netbios,#add,#del",false);
	}
	else{
		supplyValue("smb_enabled","0");
	}
	$("#div_body").show();
	showTab();
}
function showTab(){	
	var smbUsers=responseJson['SmbUsers'].replace(/;/gi,",");
	smbUsers=smbUsers.split(",");
	var trNode;
 	var smbTab=$("#div_showsmb").get(0);
	for(var i=0,k=0;i<rules_num;i++,k+=3){
		trNode=smbTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML=(i+1)+"<input type=checkbox id=delRule"+i+ ">";	
		trNode.insertCell(1).innerHTML=	smbUsers[k+2].replace(eval("/&/gi"),'&amp;');
		trNode.insertCell(2).innerHTML=	smbUsers[k+1].replace(eval("/&/gi"),'&amp;');
		trNode.insertCell(3).innerHTML="/"+smbUsers[k].replace(eval("/&/gi"),'&amp;');	
	}
}
function deleteClick(){
	var flg=0;
   	var postVar ={"topicurl":"setting/setSmbInit"};
	postVar['hiddenButton']  = "delete";
    for (i=0; i< rules_num; i++){
		var tmp = $("#delRule"+i).get(0);
		if (tmp.checked == true){
			postVar['delRule'+i]= i;
			flg=1
		}
	}
	if(flg==0){
		alert(JS_msg36);
	 	event.returnValue = false;
	}
	if(flg==1){
		uiPost(postVar);
	}
}
function saveChanges(){	
	if ($(':radio[name="smb_enabled"]:checked').val()== "1"){	
		if (!checkVaildVal.IsVaildUserString($("#smb_workgroup").val(), MM_workgroup)) return false;				
		if (!checkVaildVal.IsVaildUserString($("#smb_netbios").val(), MM_netbios)) return false;
	}	
	return true;
}
function smb_enable_switch(_flg){
	if (_flg== "0")
		setDisabled("#smb_workgroup,#smb_netbios,#add,#del",true);
	else
	   setDisabled("#smb_workgroup,#smb_netbios,#add,#del",false);
}
function open_diradd_window(){
	var cnt = 0;
	var p = all_str.split(";");
	for(i=0; i<p.length;i++){
		var q=p[i].split(",");
		if(q[3] == 1) cnt++;
	}
	if(rules_num == 10){
		alert(JS_msg112);
		return false;
	}	
	window.open("usb_smbAdd.asp","Samba_Dir_Add","toolbar=no, location=no, scrollbars=yes, resizable=no, width=640, height=440");
}
$(function(){
	var postVar = { topicurl : "setting/getSmbCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);
		}
    });		
	initValue();
});
function doSubmit(parm){
	if (parm == "apply"){		
		if (saveChanges()==false)
			return false;
			
		var postVar ={"topicurl":"setting/setSmbInit"};
		postVar['hiddenButton']  = parm;
		postVar['SmbEnabled']  = $(':radio[name="smb_enabled"]:checked').val();
		postVar['HostName']  = $('#smb_workgroup').val();
		postVar['SmbNetBIOS']  = $('#smb_netbios').val();
		uiPost(postVar);
	
	}else if(parm == "delete"){
		deleteClick();
	}
}
</script>
</head>

<body class="mainbody" id="div_body" style="display:none">
<script>showToper()</script>
<script>showContainer()</script>
<div id="div_no_usbdivice" style="display:none">
<table border=0 width="100%">
<tr><td><img src="../graphics/warning.gif" align="absmiddle">&nbsp;&nbsp;<span id="usbdevice_check">&nbsp;</span>&nbsp;&nbsp;
<script>dw('<input type=button class=button value="'+BT_refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</div>

<div id="div_usbdivice">
<form id=storage_smb name=storage_smb >
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_samba_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_samba_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr> 
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><input type=radio name=smb_enabled value="1" onClick="smb_enable_switch(1)"><script>dw(MM_enable)</script>
<input type=radio name=smb_enabled value="0" onClick="smb_enable_switch(0)" ><script>dw(MM_disable)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_workgroup)</script></td>
<td><input type=text id=smb_workgroup name=smb_workgroup maxlength=15 value="WORKGROUP"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_netbios)</script></td>
<td><input type=text id=smb_netbios name=smb_netbios maxlength=15 value="NETBIOS"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick=doSubmit(\"apply\")>')</script></td></tr>
</table>

<br>
<table id="smbinfo" border=0 width="100%" style="">
<tr><td colspan="4"><b><script>dw(MM_sharing_dir_list)</script></b></td></tr>
<tr><td colspan="4"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center">&nbsp;</td>
<td class="item_center"><b><script>dw(MM_allows_users)</script></b></td>
<td class="item_center"><b><script>dw(MM_dir_path)</script></b></td>
<td class="item_center"><b><script>dw(MM_dir_name)</script></b></td>
</tr>
<td align="center">--</td>
<td align="center"><span id="showUsername"></span></td>
<td align="center">/media</td>
<td align="center">/media</td>
<tbody id="div_showsmb"></tbody>
</table>

<table border=0 width="100%" style=""> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class="button" id="add" name="add" value="'+BT_add+'" onClick="open_diradd_window()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type=button class="button" id="del" name="del" value="'+BT_delete+'" onClick=doSubmit(\"delete\")>')</script></td></tr>
</table>
</form>
</div>
<script>showFooter()</script>
</body></html>