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
var ftpb,smbb,usrFile,all_str,root,part_count,responseUserDirCfg,responsePartList;
function initValue(){
	var f=document.storage_adduser;
	ftpb=responseUserDirCfg['ftpBuild'];
	smbb=responseUserDirCfg['smbBuild'];
	usrFile=responseUserDirCfg['creatDir'];
	all_str=responseUserDirCfg['AdmUsers'];
	root=responseUserDirCfg['Login'];
	showPartList();
	$("#div_ftp, #div_smb, #div_usr_file").hide();
	f.adduser_ftp[0].disabled = true;
	f.adduser_ftp[1].disabled = true;
	f.adduser_smb[0].disabled = true;
	f.adduser_smb[1].disabled = true;
	f.adduser_file[0].disabled = true;
	f.adduser_file[1].disabled = true;
	
	if (ftpb == "1"){
		$("#div_ftp").get(0).style.display = "";
		f.adduser_ftp[0].disabled = false;
		f.adduser_ftp[1].disabled = false;
	}else{
		f.adduser_ftp[1].checked = true;
	}
	
	if (smbb == "1"){
		$("#div_smb").get(0).style.display = "";
		f.adduser_smb[0].disabled = false;
		f.adduser_smb[1].disabled = false;
	}else{
		f.adduser_smb[1].checked = true;
	}
	
	if (usrFile == "1"){
		$("#div_usr_file").get(0).style.display = "";
		f.adduser_file[0].disabled = false;
		f.adduser_file[1].disabled = false;
	}
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
function saveChanges(){
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
	var f=document.storage_adduser;
	if (!checkVaildVal.IsVaildUsbString(f.adduser_name.value, MM_username,8,lang,2)) return false;
	if (!checkVaildVal.IsVaildString(f.adduser_pw.value, MM_password,1)) return false;
	var p = all_str.split(";");
	for(i=0; i<p.length;i++){
		var q=p[i].split(",");
		if(q[0] == f.adduser_name.value){
			alert(JS_msg101);
			return false
		}
	}
	
	if(f.adduser_name.value == "anonymous" || f.adduser_name.value == root){
		alert(JS_msg101);
		return false;
	}
	
	if(f.adduser_file[0].checked){
		var h = 0;
	    if(part_count == 1){
	       	if (f.disk_part.checked == true)
	       		h=1;
	    }
	    else{
	       	for(i=0;i<part_count;i++){
				if (f.disk_part[i].checked == true){
					h = 1;
					break;
				}
			}
	 	}

		if (!h){
			alert(JS_msg103);
			return false;
		}
	}
	return true;
}
function addUserClose(){
	opener.location.reload();
}
function submit_apply(){
	if (saveChanges() == true){
		document.storage_adduser.submit();	
   		setTimeout("window.close()",300);
	}
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
	initValue();
});

function doSubmit(parm){	
	if (saveChanges()==false)
		return false;
		
	var postVar ={"topicurl":"setting/storageAddUser"};
	postVar['adduser_name']  = $('input[name="adduser_name"]').val();
	postVar['adduser_pw']  = $('input[name="adduser_pw"]').val();
	postVar['adduser_ftp']  = $(':radio[name="adduser_ftp"]:checked').val();
	postVar['adduser_smb']  = $(':radio[name="adduser_smb"]:checked').val();
	postVar['adduser_file']  = $(':radio[name="adduser_file"]:checked').val();
	postVar['disk_part']  = $(':radio[name="disk_part"]:checked').val();
	uiPost(postVar);
	setTimeout("window.close()",300);
}
</script>
</head>
<body onUnload="addUserClose()" class="mainbody">
<table width=600><tr><td>
<form method=post name="storage_adduser" action="/goform/StorageAddUser">
<input type="hidden" name="submit-url" value="/usb/usb_basic_user.asp">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_usb_adduser)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_username)</script></td>
<td><input type=text name=adduser_name maxlength=8 value=""></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_password)</script></td>
<td><input type="password" name="adduser_pw" maxlength="16" value=""></td>
</tr>
<tr id="div_ftp" style="display:none"> 
<td class="item_left"><script>dw(MM_usb_userftp)</script></td>
<td><input type=radio name=adduser_ftp value="1" checked><script>dw(MM_yes)</script>
<input type=radio name=adduser_ftp value="0" ><script>dw(MM_no)</script></td>
</tr>
<tr id="div_smb" style="display:none"> 
<td class="item_left"><script>dw(MM_usb_usersmb)</script></td>
<td><input type=radio name=adduser_smb value="1" checked><script>dw(MM_yes)</script>
<input type=radio name=adduser_smb value="0" ><script>dw(MM_no)</script></td>
</tr>
<tr id="div_usr_file" style="display:none"> 
<td class="item_left"><script>dw(MM_add_home_dir)</script></td>
<td><input type=radio name=adduser_file value="1" checked><script>dw(MM_yes)</script>
<input type=radio name=adduser_file value="0" ><script>dw(MM_no)</script></td>
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