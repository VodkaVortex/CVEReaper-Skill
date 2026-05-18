<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/common.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script>
var adsTmpl;
var responseJsonCus;
function showTmpl(){
	var showTmplList = document.getElementById("showTmplList");
	if(adsTmpl!=""){
		var adsList=adsTmpl.split(",");
		var trNum=adsList.length/4;
		if(adsList.length%4)
			trNum++;
		for(var i=0,j=0;j<trNum;j++){
			trNode=showTmplList.insertRow(-1);
			trNode2=showTmplList.insertRow(-1);
			for(var k=0;k<4;k++,i++){
				if(/http:/ig.test(adsList[i]))return;
				var valueStr=adsList[i];
				if(valueStr == ""){
					trNode.insertCell(k).innerHTML='&nbsp;';
					trNode2.insertCell(k).innerHTML='&nbsp;';
				}else{
					trNode.insertCell(k).innerHTML='<a href="/auth/pageCustom.asp?tmpl='+valueStr+'" title="" onclick="openEditer()"><img src="/'+valueStr+'/'+valueStr+'.jpg" border="0" align="absmiddle" style="cursor:pointer;width:132;height:117px;" ></a>';
					trNode2.insertCell(k).innerHTML=valueStr;
				}
			}
		}
	
	}
}

function openEditer(name){
}
function initCusList(){
	for(var i=1;i<responseJsonCus.length;i++){
		adsTmpl+=responseJsonCus[i].URL+",";
	}
	showTmpl();
}
$(function(){
	var postVarAds = { topicurl : "setting/getCustomization_List"};
    postVarAds = JSON.stringify(postVarAds);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarAds,  
        async : true,  
        success : function(Data){
			responseJsonCus = JSON.parse(Data);
			initCusList();			
		}
    });	
});
</script>
</head>

<body class="mainbody">
<table width="600"><tr><td>
<form action=/goform/formCsAuth method=POST name="formCsAuth">
<input type="hidden" value="/auth/authContent.asp" name="submit-url">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_auth_content)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_auth_content)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="100%">
<tr><td class="item_head" colspan="3"><script>dw(MM_ads_template)</script></td></tr>
<tr><td colspan="4"><hr size=1 noshade align=top></td></tr>
<tbody id="showTmplList"></tbody>
</table>

<table border=0 width="100%" style="display:none;">
<tr><td class="item_head" colspan="3"><script>dw(MM_ads_customTemplate)</script></td></tr>
<tr><td colspan="4"><hr size=1 noshade align=top></td></tr>
<tr align=center>
<td class="item_center"><a href="/auth/pageCustom.asp?tmpl=cate" title="" onclick="openEditer('cate')"><img id="cate" src="" name="cate" border="0" align="absmiddle" style="cursor:pointer" ></a></td>
<td class="item_center"><a href="/auth/pageCustom.asp?tmpl=scenery" title=""  onclick="openEditer('scenery')"><img id="scenery" src="" name="scenery" border="0" align="absmiddle" style="cursor:pointer" ></a></td>
<td class="item_center"><a href="/auth/pageCustom.asp?tmpl=hotel" title=""  onclick="openEditer('hotel')"><img id="hotel" src="" name="hotel" border="0" align="absmiddle" style="cursor:pointer" ></a></td>
<td class="item_center"><a href="/auth/pageCustom.asp?tmpl=bar" title=""  onclick="openEditer('bar')"><img id="bar" src="" name="bar" border="0" align="absmiddle" style="cursor:pointer" ></a></td>
</tr>
<tr align=center>
<td class="item_center"><b><script>dw(MM_ads_cate)</script></b></td>
<td class="item_center"><b><script>dw(MM_ads_scenery)</script></b></td>
<td class="item_center"><b><script>dw(MM_ads_hotel)</script></b></td>
<td class="item_center"><b><script>dw(MM_stop_bar)</script></b></td>
</tr>
</table>

</form>

</td></tr></table>
</body>
</html>