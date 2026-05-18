<html>
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
<script language="javascript">
var part_count = 0,responsePartList;
function saveChanges(){
	var f=document.disk_adddir;
	var lang,nv;
	
	if (navigator.userLanguage) {
		nv = navigator.userLanguage.substring(0,2).toLowerCase();  
	} else {
		nv = navigator.language.substring(0,2).toLowerCase();  
	}
	
	if(nv.indexOf("cn")>=0)
		lang="cn";
	else
		lang="en";
	
	if (!checkVaildVal.IsVaildUsbString(f.adddir_name.value, MM_dir_name,16,lang,1)) return false;
	if (part_count <= 0){
		alert(JS_msg111);
		return false;
	}else if (part_count == 1){
		if (f.disk_part.checked == false){
			alert(JS_msg110);
			return false;
		}
	}else if (part_count > 1){
		for(i=0;i<part_count;i++){
			if (f.disk_part[i].checked == true)
				break;
		}
		if (i == part_count){
			alert(JS_msg110);
			return false;
		}
	}
	return true;
}
function submit_apply(){
	var f=document.disk_adddir;
	if (saveChanges() == true){
		f.hiddenButton.value = "add";
		f.submit();
		//opener.location.reload();
		setTimeout("window.close()",300);
	}
}
function doSubmit(){	
	if (saveChanges()==false)
		return false;
		
	var postVar ={"topicurl":"setting/storageDiskAdm"};
	postVar['hiddenButton']  = "add";
	postVar['adddir_name']  = $('input[name="adddir_name"]').val();
	postVar['disk_part']  = $(':radio[name="disk_part"]:checked').val();
	uiPost(postVar);	
	setTimeout("window.close()",300);
}
function showPartList(){
	var partTab = $("#showPartList").get(0);
	var trNode;
	part_count=responsePartList.length-1;
	for(var i=1;i<responsePartList.length;i++){
		trNode=partTab.insertRow(-1);
		trNode.align="left";
		trNode.insertCell(0).innerHTML='<input type="radio" name="disk_part" value="'+responsePartList[i].path+'">';
		trNode.insertCell(1).innerHTML=responsePartList[i].path;
	}
}
function addDirClose(){
	opener.location.reload();
}
$(function(){
	var postVar = { topicurl : "setting/getPartitionList"};
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
	showPartList();
});
</script>
</head>

<body onUnload="addDirClose()" class="mainbody">
<table width=600><tr><td>
<form method=post name="disk_adddir" action="/goform/storageDiskAdm">
<input type="hidden" name="submit-url" value="/usb/usb_basic_disk.asp">
<input type="hidden" name="hiddenButton" value="">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_usb_adddir)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr> 
<td class="item_left"><script>dw(MM_dir_name)</script></td>
<td><input type=text name=adddir_name maxlength=16 value=""></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_path)</script></td>
<td><table id="showPartList" style="border:0;"></table></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type=button class=button value="'+BT_close+'" onClick="window.close()">')</script></td></tr>
</table>
</form>
</td></tr></table>
</body></html>