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
var usb_state;
var dir_count=0;
var part_count=0;
var Waiting=false;
var responseUserDirCfg,responsePartList,responseUsbList;
function showListTable(){
	$("#ListTable").show();
}
function hiddenWaitTable(){
	$("#WaitTable").hide();
}
function initValue(){
	usb_state=responseUserDirCfg['UsbFlag'];
	dir_count=responsePartList.length-1;
	showAllDir();
	showUsbInfoList();
	
	if(responseUserDirCfg['usb_sdcardBt']==1)
		supplyValue("usbdevice_check", MSG_sdcard_check);
	else
		supplyValue("usbdevice_check", MSG_usb_check);
	
	if (usb_state == 0){
		$("#div_no_usbdivice").show();
		$("#div_usbdivice, #diskinfo, #WaitTable").hide();
	}else{
		setTimeout('showListTable()',1000);
		$("#div_no_usbdivice").hide();
		$("#div_usbdivice, #diskinfo").show();
		setTimeout('hiddenWaitTable()',1000);
	}
}
function showAllDir(){
	var dirTab = $("#showDirList").get(0);
	var trNode;
	for(var i=1;i<responsePartList.length;i++){
		trNode=dirTab.insertRow(-1);
		trNode.align="left";
		trNode.insertCell(0).innerHTML='<input type=\"radio\" name=\"dir_path\" value=\"'+responsePartList[i].dirName+'\">';
		trNode.insertCell(1).innerHTML=responsePartList[i].dirName.replace(eval("/&/gi"),'&amp;');
		trNode.insertCell(2).innerHTML='<input type=\"hidden\" name=\"dir_part\" value=\"'+responsePartList[i].part+'\">'+responsePartList[i].part;
	}
}
function showUsbInfoList(){
	var userListTab=$("#showUsbInfoList").get(0);
	var trNode;
	var usbinfo=responseUsbList[1].usbInfo;
	var usbinfo1 = usbinfo.split('#');
	for(var i = 0;i<usbinfo1.length-1;++i){ 
		mySplitResults=usbinfo1[i].split("?");
		trNode=userListTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML=mySplitResults[0];
		trNode.insertCell(1).innerHTML=mySplitResults[1];
		trNode.insertCell(2).innerHTML=mySplitResults[2];
		trNode.insertCell(3).innerHTML=mySplitResults[3];	
		trNode.insertCell(4).innerHTML=mySplitResults[4];	
	}
}
function checkSelect(){
	var f=document.storage_disk_adm;
	if (dir_count <= 0){
		alert(JS_msg106);
		return false;
	}else if (dir_count == 1){
		if (f.dir_path.checked == false){
			alert(JS_msg105);
			return false;
		}
		f.selectDirIndex.value = 0;
	}else{
		for(i=0;i<dir_count;i++){
			if (f.dir_path[i].checked == true){
				f.selectDirIndex.value = i;
				break;
			}
		}
		if (i == dir_count){
			alert(JS_msg105);
			return false;
		}
	}	
	return true;
}
function submit_apply(parm){
	if (parm == "delete"){
		if (!checkSelect())	return false;
		document.storage_disk_adm.hiddenButton.value = parm;
		document.storage_disk_adm.submit();
	}
}
function open_diskadd_window(){
	window.open("usb_basic_diskAdd.asp","storage_disk_add","toolbar=no, location=no, scrollbars=yes, resizable=no, width=640, height=440");
}
$(function(){
	var postVar = { topicurl : "setting/getUserDirCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseUserDirCfg = JSON.parse(Data);
		}
    });
	
	var postVar = { topicurl : "setting/ShowAllDir"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responsePartList = JSON.parse(Data);
		}
    });
	
	var postVar = { topicurl : "setting/getUsbInfo"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseUsbList = JSON.parse(Data);
		}
    });
	initValue();
});
function doSubmit(){	
	if (checkSelect()==false)
		return false;
		
	var postVar ={"topicurl":"setting/storageDiskAdm"};
	postVar['hiddenButton']  = "delete";
	postVar['dir_path']  = $(':radio[name="dir_path"]:checked').val();
	uiPost(postVar);
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

<div id="WaitTable">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_disk_loading)</script></td></tr>
</table>
</div>

<div id="ListTable" style="display:none">
<div id="div_usbdivice">
<form method=post name=storage_disk_adm action="/goform/storageDiskAdm">
<input type=hidden name="submit-url" value="/usb/usb_basic_disk.asp">
<input type=hidden name=hiddenButton value="">
<input type=hidden name=selectDirIndex value="">
<input type=hidden name=selectPartIndex value="">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_disk_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_disk_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_center">&nbsp;</td>
<td class="item_center"><b><script>dw(MM_dir_path)</script></b></td>
<td class="item_center"><b><script>dw(MM_partition)</script></b></td>
</tr>
<tbody id="showDirList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_add+'" onClick="open_diskadd_window()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type=button class=button value="'+BT_delete+'" onClick=doSubmit()>')</script></td></tr>
</table>

<div id="diskinfo">
<br>
<table width=700 border=0>
<tr><td colspan=5 class=item_head><b><script>dw(MM_partition_using_status)</script></b></td></tr>
<tr><td colspan=5><hr size=1 noshade align=top class=bline></td></tr>
<tr align=center>
<td class="item_center"><b><script>dw(MM_partition_name)</script></b></td>
<td class="item_center"><b><script>dw(MM_total_size)</script></b></td>
<td class="item_center"><b><script>dw(MM_used_size)</script></b></td>
<td class="item_center"><b><script>dw(MM_free_size)</script></b></td>
<td class="item_center"><b><script>dw(MM_usage_percentage)</script></b></td>
</tr>
<tbody id="showUsbInfoList"></tbody>
<tr><td colspan=5><hr size=1 noshade align=top class=bline></td></tr>
</table>
</div>
</form>
</div>
</div>
<script>showFooter()</script>
</body></html>