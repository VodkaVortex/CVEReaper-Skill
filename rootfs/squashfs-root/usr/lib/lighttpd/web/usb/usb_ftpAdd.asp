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
var path_count = 0;
var any_en;
var all_str;
var ftp_str;
var responseFtpAdd,responseDirList;
function CheckAlreadyConfig()
{
	var f=document.ftp_adddir;
	var user_count = 0;
	var p = all_str.split(";");
	for(i=0; i<p.length;i++)
	{
		var q=p[i].split(",");
		if(q[2] == 1) user_count++;
	}

	if(user_count == 1)
	{
		var curUser;
		var p = ftp_str.split(";");
		for(i=0; i<p.length;i++)
		{
			var q=p[i].split(",");
			
			if(any_en == 0)
				curUser = f.allow_user.value
			else
				curUser = f.allow_user[0].value
				
			if(q[0] == curUser)
			{
				alert(JS_msg102);
				return false;
			}
		}
	}
	else
	{
		for(i=0;i<user_count;i++)
		{
			if (f.allow_user[i].checked == true)
			{
				var p = ftp_str.split(";");
				for(j=0; j<p.length;j++)
				{
					var q=p[j].split(",");
					if(q[0] == f.allow_user[i].value)
					{
						alert(JS_msg102);
						return false;
					}
				}
			}
		}
	}		

	return true;
}

function saveChanges()
{	
	var f=document.ftp_adddir;
	if(path_count <= 0)	
	{
		alert(JS_msg106);
		return false;
	}

	if(any_en == 0)
	{	//disalbe any
		var user_count = 0;
		var p = all_str.split(";");
		for(i=0; i<p.length;i++)
		{
			var q=p[i].split(",");
			if(q[2] == 1)
				user_count++;
		}

		var j=0;
		if(user_count == 1)	
		{
			if (f.allow_user.checked == true)
				j =1;
		}
		else
		{
			for(i=0;i<user_count;i++)
			{
				if (f.allow_user[i].checked == true)
				{
					j=1;
					break;
				}
			}
		}
		
		if (!j)
		{
			alert(JS_msg104);
			return false;
		}
	}

   	var h = 0;
    if(path_count == 1)
	{
       	if (f.dir_path.checked == true)
       		h=1;
    }
    else
	{
       	for(i=0;i<path_count;i++)
		{
			if (f.dir_path[i].checked == true)
			{
				h = 1;
				break;
			}
		}
    }

	if (!h)
	{
		alert(JS_msg105);
		return false;
	}

	if(!CheckAlreadyConfig()) return false;
	return true;
}
function submit_apply(){	
	if (saveChanges() == true){
		document.ftp_adddir.submit();
		opener.location.reload();
		setTimeout("window.close()",300);
	}
}
function addDirClose(){
	opener.location.reload();
}
function showAllDir(){
	var dirTab = $("#showDirList").get(0);
	var trNode;
	path_count=responseDirList.length-1;
	for(var i=1;i<responseDirList.length;i++){
		trNode=dirTab.insertRow(-1);
		trNode.align="left";
		trNode.insertCell(0).innerHTML='<input type=\"radio\" name=\"dir_path\" value=\"'+responseDirList[i].dirName+'\">';
		trNode.insertCell(1).innerHTML=responseDirList[i].dirName;
		trNode.insertCell(2).innerHTML='<input type=\"hidden\" name=\"dir_part\" value=\"'+responseDirList[i].part+'\">'+responseDirList[i].part;
	}
}
function showAllUser(){
	var userList = $("#showAllUser").get(0);
	var trNode,userEntity,items;
	var userEntitys=all_str.split(";");
	for(var i=0;i<userEntitys.length;i++){
		items=userEntitys[i].split(",");
		trNode=userList.insertRow(-1);
		trNode.align="left";
		if(items[2]=="1")
			trNode.insertCell(0).innerHTML='<input type=\"radio\" name=\"allow_user\" value=\"'+items[0]+'\">&nbsp;&nbsp;&nbsp;&nbsp;'+items[0];
	}
	if(0){//any_en=="1"
		trNode=userList.insertRow(-1);
		trNode.insertCell(0).innerHTML='<input type=\"radio\" checked name=\"allow_user\" value=\"anonymous\">&nbsp;&nbsp;&nbsp;&nbsp;anonymous';
	}
}
function initValue(){
	all_str=responseFtpAdd['AdmUsers'];
	ftp_str=responseFtpAdd['FtpUsers'];
	any_en=responseFtpAdd['FtpAnonymous'];
	showAllUser();
	showAllDir();
}
$(function(){
	var postVar = { topicurl : "setting/getFtpAddUserCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseFtpAdd = JSON.parse(Data);
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
			responseDirList = JSON.parse(Data);
		}
    });
	initValue();
});
function doSubmit(){	
	if (saveChanges()==false)
		return false;
		
	var postVar ={"topicurl":"setting/setFtpAddUser"};
	postVar['allow_user']  = $(':radio[name="allow_user"]:checked').val();
	postVar['dir_path']  = $(':radio[name="dir_path"]:checked').val();
	uiPost(postVar);	
	setTimeout("window.close();opener.location.reload();",1000);
}
</script>
</head>

<body onUnload="addDirClose()" class="mainbody">
<table width=600><tr><td>
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_add_ftpdir)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<form method=post name="ftp_adddir" action="/goform/Ftp_Add">
<input type="hidden" name="submit-url" value="/usb/usb_ftp.asp">
<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_access_user)</script></td>
<td><table id="showAllUser" style="border:0;"></table></td>
</tr>
</table>

<br>
<table border=0 width="100%">
<tr><td colspan="3" class="item_head"><script>dw(MM_access_path)</script></td></tr>
<tr><td colspan="3"><hr size=1 noshade align=top class=bline></td></tr>
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
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type=button class=button value="'+BT_close+'" onClick="window.close()">')</script></td></tr>
</table>
</form>
</td></tr></table>
</body></html>