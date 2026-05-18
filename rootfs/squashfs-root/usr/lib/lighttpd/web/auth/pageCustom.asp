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
var customPath='';//'<% getCfgGeneral(1, "customPath"); %>';
var NewDirName='';//'<% getCfgGeneral(1, "currcus_ads_tmpl"); %>'; //currcus_ads_tmpl
var editAds=0;
var tmplName="";
function openEditer(name){
	
}
function iframeAutoFit(){
	var iframeObj = document.getElementById("showAdsPage");
	iframeObj.height=(iframeObj.Document?iframeObj.Document.body.scrollHeight:iframeObj.contentDocument.body.offsetHeight)+20;
}
function Load_Setting()
{	
	var URLstr = location.href;
	tmplName = URLstr.split("=")[1];
	if(tmplName == ""||tmplName==undefined){
		tmplName=Cookie.Get("sysTmplName");
		if(tmplName!=""){
			document.getElementById("newAds").disabled=true;
		}
	}
	document.getElementById("showAdsPage").src="/"+tmplName+"/index.html";//tmplName+".html" //
	document.getElementById("tmplType").value=tmplName;
	Cookie.Set("sysTmplName",tmplName,1);
	Cookie.Set("customPath",customPath,1);
	Cookie.Set("newDirName",NewDirName,1);  //temp
	setTimeout(function(){iframeAutoFit();},1000);
}
function addClick(){
	var DirName = document.getElementById("customDirName").value;
	if(!isEmpty(DirName)){
		alert(MM_ads_template_name+JS_115);
		return false;
	}
	var pageNameDes = document.getElementById("customPageName").value;
	if(!isEmpty(pageNameDes)){
		alert(MM_ads_template_des+JS_115);
		return false;
	}
	Cookie.Set("newDirName",DirName,1);
	document.getElementById("editAction").value="New";
	document.getElementById("formCsAdsEdit").submit();
	return true;
}
function editClick(){
	if(editAds==0){
		document.getElementById("editAds").value=BT_save;
		editAds=1;
		document.getElementById("showAdsPage").src="/"+tmplName+"/index.html";//tmplName+".html";
	}else{
//		$("editAds").value=BT_edit;
//		editAds=0;
		//save
		document.getElementById("editAction").value="save";
		var tmplName1=Cookie.Get("sysTmplName");
		document.getElementById("tmplType").value=tmplName1;
		//Cookie.Set("sysTmplName","",1);
		
		var form_element = document.getElementById("formChangeImg");
		AddElements(form_element,"editAction","save");
		AddElements(form_element,"tmplType","cate");
		AddElements(form_element,"imgCount",form_element.elements.length);
		AddElements(form_element,"submit-url","/auth/pageCustom.asp");
		form_element.submit();
	}
	return true;
}
function viewClick(){
	var URLstr = location.href;
	tmplName = URLstr.split("=")[1];
	if(tmplName == ""||tmplName==undefined){
		tmplName=Cookie.Get("sysTmplName");
		if(tmplName!=""){
			document.getElementById("newAds").disabled=true;
		}
	}
	document.getElementById("showAdsPage").src="/"+NewDirName+"/index.html";
}
function backClick(){

}
function addImgPath(name,value){
	var sysTmpl=Cookie.Get("sysTmplName");
	var form_element = document.getElementById("formChangeImg");	
	AddElements(form_element,name,value);
}
var	AddElements = function(formObj,Name,Value){
		//var form_element = document.forms[0];
		var new_element = document.createElement('input');
		new_element.type = "hidden";
		new_element.name = Name;
		new_element.value = Value;
		formObj.appendChild(new_element);
	}
function chooseImg(){
	window.open("/usb/http_files.asp","Storage_User_Add","toolbar=no, location=no, scrollbars=yes, resizable=no, width=640, height=440");
}
</script>
</head>

<body class="mainbody" onload="Load_Setting();">
<table width="90%"><tr><td>
<form action="/goform/formCsAdsEdit" method=POST name="formCsAdsEdit" id="formCsAdsEdit">
<input type="hidden" value="/auth/pageCustom.asp" name="submit-url">
<input type="hidden" value="" name="tmplType" id="tmplType">
<input type="hidden" value="" name="editAction" id="editAction">
<input type="hidden" value="" name="imgCount" id="imgCount">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_auth_tempEditer)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_auth_content)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>
<div id="imgsPath"></div>
<table border=0 width="700">
<tr><td class="item_head" colspan="3"><script>dw(MM_ads_template_oper)</script></td></tr>
<tr><td colspan="4"><hr size=1 noshade align=top></td></tr>
<tr align=center>
<td class="item_center"><span><script>dw(MM_ads_template_name)</script>:</span><input type="text" name="customDirName" id="customDirName" size="16" maxlength="32">
<span><script>dw(MM_ads_template_des)</script>:</span><input type="text" name="customPageName" id="customPageName" size="16" maxlength="32">
<script>dw('<input type="button" class="button" value="'+BT_new+'" name="newAds" id="newAds" onClick="return addClick()">')</script></td>
<td class="item_center"><script>dw('<input type="button" class="button" value="'+BT_edit+'" id="editAds" name="editAds" onClick="return editClick()">')</script></td>
<td class="item_center"><script>dw('<input type="button" class="button" value="'+BT_view+'" name="viewAds" onClick="return viewClick()">')</script></td>
<td class="item_center"><a href="/auth/authContent.asp" title=""><script>dw('<input type="button" class="button" value="'+BT_back+'" name="backAds" onClick="return backClick()">')</script></a></td>
</tr>
<tr><td colspan="4"><hr size=1 noshade align=top></td></tr>
</table>

<iframe src="" id="showAdsPage" onload="iframeAutoFit();" marginheight="0" marginwidth="0" frameBorder="0" width="100%" height="100"></iframe>

</form>
<form action="/goform/formCsAdsEdit" method=POST name="formChangeImg" id="formChangeImg"></form>
</td></tr></table>
</body>
</html>