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
var rules_num=0;
var responseJson,v_WiFiOff,v_AccessPolicy,v_AccessControlList,v_AclCommentList; 

function showButton(show){
	if (show==1){
		setDisabled("#add, #scan", false);
	}else if (show==2){
		setDisabled("#add, #scan", true);
	}else if (show==3){
		setDisabled("#mac1, #mac2, #mac3, #mac4, #mac5, #mac6, #comment", true);
		setDisabled("#add, #scan", true);
	}else if (show==4){
		setDisabled("#del_sel, #del_reset", true);
	}else if (show==5){
		setDisabled("#del_sel, #del_reset", false);
	}
}
function initValue(){   
	showButton(1);
	
	setJSONValue({
		'AccessPolicy'		:	responseJson['AccessPolicy0'],
		'AccessControlList'	:	responseJson['AccessControlList0'],
		'WiFiIdx'           :   WiFiIdx
	});
	
	v_WiFiOff=responseJson['WiFiOff'];
	v_AccessPolicy=responseJson['AccessPolicy0'];
	v_AccessControlList=responseJson['AccessControlList0'];
	v_AclCommentList=responseJson['AclCommentList'];
	
	if (v_AccessPolicy==0){
		showButton(3);
		showButton(4);
	}else{
		showButton(5);
	}
	if(v_AccessPolicy==1){
		$("#scan").hide();
	}else{
		$("#scan").show();
	}
	if(v_WiFiOff==1){
		$(":input").attr('disabled',true);
	}

	if(v_AccessControlList!=""){
		var acldata = new Array();
		var commentdata = new Array();
		acldata=v_AccessControlList.substring(0,v_AccessControlList.length).split(";");
		commentdata=v_AclCommentList.replace(/\$/g,"").split(";");
		rules_num = acldata.length;				
		var strTmp="",i;
		for (i=0; i<acldata.length; i++){	
			strTmp="<tr align=\"center\">\n";
			strTmp+="<td class=\"item_center2\">"+(i+1)+"</td>\n";
			strTmp+="<td class=\"item_center2\">"+acldata[i]+"</td>\n";
			strTmp+="<td class=\"item_center2\">"+commentdata[i]+"</td>\n";
			strTmp+="<td class=\"item_center2\"><input type=checkbox id=DR"+i+" name=DR"+i+"></td>\n";
			strTmp+="</tr>\n";
			$("#div_acllist").append(strTmp);
		}
	}
	
	if (rules_num == 0){
		showButton(4);
	}
}

var WiFiIdx="0";
var responseJsonIdx;
var wifiFlag=0;
$(function(){
	var postVarBuilt = { "topicurl" : "setting/getWebWlanIdx"};
    postVarBuilt = JSON.stringify(postVarBuilt);
	$.ajax({  
       	type : "post",  
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarBuilt,  
        async : false,  
        success : function(Data){
			responseJsonIdx = JSON.parse(Data);
			wifiFlag=responseJsonIdx['webWlanIdx'];
		}
    }); 
	
	if(top.frames[0].wifiSelect == 1 || wifiFlag == 1)
		WiFiIdx = "1";

	var postVar = { topicurl : "setting/getWiFiAclAddConfig"};
	postVar["WiFiIdx"] = WiFiIdx;
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

function updateState(){	
	if($("#AccessPolicy").val()==1){
		if(confirm(JS_msg133)){			
			$("#AccessPolicy").val(responseJson['AccessPolicy0']);
			showButton(1);
			showButton(4);
			return false;
		}
	}else if($("#AccessPolicy").val()==2){
		if(confirm(JS_msg134)){
			$("#AccessPolicy").val(responseJson['AccessPolicy0']);
			showButton(5);
			showButton(2);
			return false;
		}
	}
/*	
	if($("#AccessPolicy").val()==1){
		if(Number(v_wscBt)!=0){
			if(!confirm(MSG_wps_disabled)){
				$("#AccessPolicy").val(responseJson['AccessPolicy0']);
				return false;
			}
		}
	}
*/	
	var postVar ={"topicurl":"setting/setWiFiAclAddConfig"};
	postVar['AccessPolicy']= $("#AccessPolicy").val();
	postVar['addEffect'] = "1";
	postVar["WiFiIdx"] = WiFiIdx;
	uiPost(postVar);
}	

function deleteClick(){
	var flg=0;
	var postVar ={"topicurl":"setting/setWiFiAclDeleteConfig"};
	for (i=0; i< rules_num; i++) {	
		var tmp =$("#DR"+i).get(0);
		if (tmp.checked == true) {
			var DR=i;	
			postVar['DR'+i]= DR;
			flg=1;
		}
	}
	
	if (flg==0){
		alert(JS_msg36);
		return false;
	}		
	postVar["WiFiIdx"] = WiFiIdx;	
	uiPost(postVar);
}

function saveChanges(){
	if (rules_num >= 10){
		alert(JS_msg28);
		return false;
	}

	var mac_tmp=combinMAC2($("#mac1").val(),$("#mac2").val(),$("#mac3").val(),$("#mac4").val(),$("#mac5").val(),$("#mac6").val());
	$("#mac_address").val(mac_tmp);
	if($("#AccessPolicy").val()!=0){if(!checkVaildVal.IsVaildMacAddr($("#mac_address").val())) return false;}
		
	var p = v_AccessControlList.substring(0,v_AccessControlList.length).split(";");
	for (var j=0; j<p.length; j++) {		
		if (($("#mac_address").val()==p[j])||($("#mac_address").val().toLowerCase()==p[j].toLowerCase())) {
			alert(JS_msg29);
			return false;
		}
	}
	if ($("#comment").val()!=""){if (!checkVaildVal.IsVaildString($("#comment").val(), MM_comment,2)) return false;}
	return true;
}

function doSubmit(){
	if (saveChanges()==false)
		return false; 
	
	var postVar ={"topicurl":"setting/setWiFiAclAddConfig"};
	postVar['mac_address'] = $("#mac_address").val();
	postVar['AccessPolicy'] = $("#AccessPolicy").val();
	postVar['comment'] = $("#comment").val();
	postVar['addEffect'] = "0";
	postVar["WiFiIdx"] = WiFiIdx;	
	uiPost(postVar);
}

function open_acl_list(){
	openWindow("aclinfo.asp","_blank",700,400);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form name="wirelessAclAdd" id="wirelessAclAdd">
<input type="hidden" id="AccessControlList" name="AccessControlList">
<input type="hidden" id="addEffect" name="addEffect" value="0">
<input type="hidden" id="WiFiIdx" name="WiFiIdx" value="0">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_acl_setting) ;</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_acl_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_auth_mode)</script></td>
<td><select name="AccessPolicy" id="AccessPolicy" onChange="updateState()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_allow_list)</script></option>
<option value="2"><script>dw(MM_deny_list)</script></option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<br />
<table border=0 width="100%">
<tr><td colspan="2"><b><script>dw(MM_add_rule)</script></b></td></tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
<tr>
<td class="item_left"><script>dw(MM_macaddr)</script></td>
<td id="macAddr"><input type="hidden" id="mac_address" name="mac_address">
<input type="text" style="width:28px" maxlength="2" name="mac1" id="mac1" onFocus="this.select();" onKeyUp="HWKeyUp('mac',1,event);" onKeyDown="return HWKeyDown('mac', 1,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac2" id="mac2" onFocus="this.select();" onKeyUp="HWKeyUp('mac',2,event);" onKeyDown="return HWKeyDown('mac', 2,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac3" id="mac3" onFocus="this.select();" onKeyUp="HWKeyUp('mac',3,event);" onKeyDown="return HWKeyDown('mac', 3,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac4" id="mac4" onFocus="this.select();" onKeyUp="HWKeyUp('mac',4,event);" onKeyDown="return HWKeyDown('mac', 4,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac5" id="mac5" onFocus="this.select();" onKeyUp="HWKeyUp('mac',5,event);" onKeyDown="return HWKeyDown('mac', 5,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac6" id="mac6" onFocus="this.select();" onKeyUp="HWKeyUp('mac',6,event);" onKeyDown="return HWKeyDown('mac', 6,event)">
<script>dw('<input id=scan type=button value="'+BT_scan+'" onClick="open_acl_list()">')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_comment)</script></td>
<td><input type="text" id="comment" name="comment" maxlength="20"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_add+'" id=add onClick="doSubmit()">')</script></td></tr>
</table>
</form>

<form name="wirelessAclDel" id="wirelessAclDel">
<table border=0 width="100%" id="div_acllist">
<tr><td colspan="4"><b><script>dw(MM_acl_setting_table);dw(JS_msg59)</script></b></tr>
<tr><td colspan="4"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center" >
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_macaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_delete+'" id="del_sel" onClick="deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" id="del_reset" onClick="resetForm()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>