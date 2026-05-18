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
var hotspotNum=0//getHotspotNum();
function saveChanges()
{
	if (hotspotNum >= 10) {
		alert(JS_max_entry_2);
		return false;
	}
	
	var f=document.formCsHotspot;
	if (!blankCheck(f.hotspotID.value, MM_hotspot_name)) 
		return false;
	if (!blankCheck(f.hotspotCode.value, MM_hotspot_code)) 
		return false;	
	
	if(hotspotNum>0){
		for(var i=1; i<=hotspotNum; i++){
			if(f.hotspotCode.value == $("td_hotspotcode"+i).innerHTML){
				alert(JS_conflict_code);
				return false;
			}
		}
	}	
	
  	return true;
}

function disableDelButton()
{
	var f=document.delCsHotspot;
	disableButton(f.delCsHotspot);
	disableButton(f.resetSel);
}

function Load_Setting()
{
	if (hotspotNum == 0)
		disableDelButton();
}
</script>
</head>

<body onLoad="Load_Setting()" class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<form action=/goform/formCsHotspot method=POST name="formCsHotspot">
<input type="hidden" value="/auth/hotspotserver.asp" name="submit-url">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_hotspot_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_hotspot_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_hotspot_name)</script></td>
<td><input type="text" name="hotspotID" maxlength="64" size="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_hotspot_code)</script></td>
<td><input type="text" name="hotspotCode" maxlength="64" size="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_hotspot_passTime)</script></td>
<td><input type="text" name="authPassTime" maxlength="64" size="32"><script>dw(MM_seconds)</script></td>
</tr>
</table>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="center"><script>dw('<input type="submit" class="button" value="'+BT_add+'" name="addCsHotspot" onClick="return saveChanges()">')</script></td>
</tr>
</table>
</form>

<br>
<form action=/goform/formCsHotspot method=POST name="delCsHotspot">
<input type="hidden" value="/auth/hotspotserver.asp" name="submit-url">
<table border=0 width="100%">
<tr><td class="item_head" colspan="5"><script>dw(MM_hotspot_list)</script>&nbsp;&nbsp;&nbsp;&nbsp;(<script>dw(JS_max_entry_5)</script>)</td></tr>
<tr><td colspan="5"><hr size=1 noshade align=top></td></tr>
<tr align=center><td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_hotspot_name)</script></b></td>
<td class="item_center"><b><script>dw(MM_hotspot_code)</script></b></td>
<td class="item_center"><b><script>dw(MM_hotspot_passTime)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td></tr>
<% getCsHotspot_List(); %>
</table>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="center"><script>dw('<input type="submit" class="button" value="'+BT_delete+'" name="delCsHotspot" onClick="return deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" name="resetSel" onClick="resetForm()">')</script></td>
</tr>
</table>
</form>

</td></tr></table>
</body>
</html>