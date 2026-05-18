<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/common.js"></script>
<script>
var authNum=<% getAuthUserNum(); %>;

function saveChanges()
{
	if (authNum >= 10) {
		alert(JS_max_entry_2);
		return false;
	}
	
	var f=document.formCsAuth;
	if(!isBlankEmpty(f.authUser.value)) {
		alert(JS_username_empty);
		f.authUser.focus();
		return false ;
	}
		
	if(!isBlankEmpty(f.authPass.value)) {
		alert(JS_password_empty);
		f.authPass.focus();
		return false ;
	}
	
	if(authNum>0){
		for(var i=1; i<=authNum; i++){
			if(f.authUser.value == $("td_csuser"+i).innerHTML){
				alert(JS_conflict_user);
				return false;
			}
		}
	}	
	alert(JS_register_ok);
  	return true;
}
</script>
</head>

<body class="mainbody">
<table width="600"><tr><td>
<form action=/goform/formCsAuth method=POST name="formCsAuth">
<input type="hidden" value="/auth/auth_user_add.asp" name="submit-url">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_authuser_add)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_authuser_add)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_username)</script></td>
<td><input type="text" name="authUser" maxlength="30"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_password)</script></td>
<td><input type="text" name="authPass" maxlength="30"></td>
</tr>
</table>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="center"><script>dw('<input type="submit" class="button" value="'+BT_apply+'" name="addCsAuth" onClick="return saveChanges()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" onClick="resetForm()">')</script></td>
</tr>
</table>
</form>

<div style="display:none">
<table border=0 width="100%">
<% getCsAuth_List(); %>
</table>
</div>

</td></tr></table>
</body>
</html>