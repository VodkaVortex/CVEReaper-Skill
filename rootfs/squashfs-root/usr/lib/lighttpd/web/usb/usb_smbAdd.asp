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
var responseDirList;
var path_count = 0;
var responseJson,v_AllStr,v_SmbStr;
function CheckAlreadyConfig(){
	var f=document.smb_adddir;
	var user_count = 0;
	var p = v_AllStr;
	for(i=0; i<p.length;i++){
		var q=p[i].split(",");
		if(q[2] == 1) user_count++;
	}

	if(user_count == 1){
		var p = v_SmbStr;
		for(i=0; i<p.length;i++){
			var q=p[i].split(",");			
			if(q[2] == f.allow_user.value){
				alert(JS_msg102);
				return false;
			}
		}
	}else{
		for(i=0;i<user_count;i++){
			if (f.allow_user[i].checked == true){
				var p = v_SmbStr;
				for(j=0; j<p.length;j++){
					var q=p[j].split(",");
					if(q[2] == f.allow_user[i].value){
						alert(JS_msg102);
						return false;
					}
				}
			}
		}
	}
	return true;
}
function saveChanges(){
	var f=document.smb_adddir;
	var cnt = 0;
	
	if (!checkVaildVal.IsVaildUserString($("#dir_name").val(), MM_smbdir_name)) return false;

	var p = v_AllStr;
	for(i=0; i<p.length;i++){		
		var q=p[i].split(",");
		if(q[3] == 1) cnt++;
	}

	if(cnt==1){		
		if (f.allow_user.checked == false){			
			alert(JS_msg104);
			return false;
		}
	}else if(cnt >1){		
		for(i=0;i<cnt;i++){
			if (f.allow_user[i].checked == true)
				break;
		}
		if (i == cnt){			
			alert(JS_msg104);
			return false;
		}
	}

	if (path_count <= 0){		
		alert(JS_msg106);
		return false;
	}else if (path_count == 1){		
		if (f.dir_path.checked == false){
			alert(JS_msg105);
			return false;
		}
	}else if (path_count > 1){		
		for(i=0;i<path_count;i++){
			if (f.dir_path[i].checked == true)
				break;
		}
		
		if (i == path_count){			
			alert(JS_msg105);
			return false;
		}
	}

	if(!CheckAlreadyConfig()) return false;		
	return true;
}
function submit_apply(){
	if (saveChanges() == true){
		var postVar ={"topicurl":"setting/setSmbAdd"};
		postVar['dir_name']	  =  $("#dir_name").val();
		postVar['dir_path']	  =  $(":radio[name=dir_path]:checked").val();
		postVar['allow_user'] =  $(":radio[name=allow_user]:checked").val();
		uiPost(postVar);
			
		setTimeout("opener.location.reload(); window.close()",1000);
	}
}
$(function(){
	var postVar = { topicurl : "setting/getSmbAddCfg"};
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
function showAllDir(){
	var dirTab = $("#div_showalldir").get(0);
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
function initValue(){
	v_AllStr=responseJson['AdmUsers'].split(';');
	v_SmbStr=responseJson['SmbUsers'].split(';');
	var tmp_rule="";
	var tmp_name="";
	var userEntity;

	for(var i=0;i<v_AllStr.length;i++){
		userEntity=v_AllStr[i].split(',');
		if(userEntity[3]=="1"){
			tmp_name=userEntity[0];
			tmp_rule+='<input type="radio" name="allow_user" value="'+tmp_name+'">'+tmp_name+ '<br />&nbsp;';
		}
	}
	$("#div_access_user").append(tmp_rule);

	showAllDir();
}
</script>
</head>
<body class="mainbody">
<table width=600><tr><td>
<form name="smb_adddir" >
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_add_smbdir)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr> 
<td class="item_left"><script>dw(MM_smbdir_name)</script></td>
<td><input type=text id=dir_name name=dir_name maxlength=16 value=""></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_access_user)</script></td>
<td id="div_access_user">&nbsp;</td>
</tr>
</table>

<br>
<table border=0 width="100%">
<tr><td colspan="3" class="item_head"><script>dw(MM_access_path)</script></td></tr>
<tr><td colspan="3"><hr size=1 noshade align=top class=bline></td></tr>
<tr>
<td>&nbsp;</td>
<td><b><script>dw(MM_dir_path)</script></b></td>
<td><b><script>dw(MM_partition)</script></b></td>
</tr>
<tbody id="div_showalldir"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="submit_apply()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type=button class=button value="'+BT_close+'" onClick="window.close()">')</script></td></tr>
</table>
</form>
</td></tr></table>
</body></html>