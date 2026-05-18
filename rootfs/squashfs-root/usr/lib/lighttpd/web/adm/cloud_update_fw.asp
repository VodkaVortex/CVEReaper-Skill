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
var responsecloudVerJson,responseCloudStatus,currVersion;
var responsecloudDownJson;
function checkFirmwareClick(){
	setDisabled("#upgrade",true);
	var postVar = { topicurl : "setting/getCloudFWInfo"};
	postVar['updateAction']="getAllFWInfo";
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responsecloudVerJson = JSON.parse(Data);
		}
    });		
	initValue();
	setDisabled("#upgrade",false);
	return true;
}
function downloadCloudFw(versionId){
	var postVar = { topicurl : "setting/cloudUpdate"};
	postVar['updateAction']="post";
	postVar['newVersionId']=""+versionId;
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : true,  
        success : function(Data){
			//responsecloudDownJson = JSON.parse(Data);
		}
    });		
	return true;
}
function updateFW2Flash(versionId){
	var postVar = { topicurl : "setting/updateFw2Flash"};
	postVar['newVersionId']=""+versionId;
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : true,  
        success : function(Data){
			//responsecloudDownJson = JSON.parse(Data);
		}
    });		
	return true;
}
function updateFW(th,verID){
	currVersion=verID;
	$('span[name="download"]').hide();
	$("#span"+currVersion).show();
	$('input[name="cloudVersion"]').attr("disabled",true);
//	setDisabled("#btn"+currVersion,true);
	$("#span"+currVersion).html("<img style='width:15px;height:15px;' src='../style/load.gif'></img>");
	if(cloudUpdate.status==3){
		fw2flashStart=1;
		updateFW2Flash(verID);
	}else{
		$('input[name="cloudVersion"]').attr('value',MM_downloaded);
		cloudUpdate.status=1;
		fw2flashStart=0;
		downloadCloudFw(verID);
		getDownloadStatus();
	}
}
//status 1:下载中；2:下载失败；3：下载成功
var cloudUpdate={timer:'0',status:'0'};
var fw2flashStart=0;
function getDownloadStatus(){
	var downloadFlage;
	var postVar = { topicurl : "setting/getCloudUpdateStatus"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : true,  
        success : function(Data){
			try{
				responseCloudStatus = JSON.parse(Data);
				showCloudStatus();
				cloudUpdate.timer=setTimeout(getDownloadStatus,"5000");
			}catch(e){
				cloudUpdate.timer=setTimeout(getDownloadStatus,"5000");
			}
		},
		error: function() {
           cloudUpdate.timer=setTimeout(getDownloadStatus,"5000");
        }
    });
}
function showCloudStatus(){
	var downloadFlage=parseInt(responseCloudStatus['cloudFileDown']);
	var fw2FlashStatus=parseInt(responseCloudStatus['fw2FlashStatus']);
	if(cloudUpdate.status==1){
		if(downloadFlage==3){
			$("#btn"+currVersion).attr('value',BT_upgrade);
			$('input[name="cloudVersion"]').removeAttr('disabled');
			$("#span"+currVersion).hide();
			//setDisabled("#btn"+currVersion,false);
			clearTimeout(cloudUpdate.timer);
			cloudUpdate.status=3;
			return;
		}else if(downloadFlage==2){
			//setDisabled("#btn"+currVersion,false);
			$('input[name="cloudVersion"]').removeAttr('disabled');
			$("#span"+currVersion).html("<label style='color:red'>"+MM_cloud_downloadFail+"</label>");
			clearTimeout(cloudUpdate.timer);
			return;
		}else if(downloadFlage==4){
			//setDisabled("#btn"+currVersion,false);
			$('input[name="cloudVersion"]').removeAttr('disabled');
			$("#span"+currVersion).html("<label style='color:red'>"+MM_cloud_networkErr+"</label>");
			clearTimeout(cloudUpdate.timer);
			return;
		}
	}else if(cloudUpdate.status==3 && fw2flashStart==1){
		if(fw2FlashStatus==1){
			fw2flashStart=0;
			$('input[name="cloudVersion"]').removeAttr('disabled');
			alert(MM_cloud_fw2flash1);
		}else if(fw2FlashStatus==2){
			fw2flashStart=0;
			$('input[name="cloudVersion"]').removeAttr('disabled');
			alert(MM_cloud_fw2flash2);
		}else if(fw2FlashStatus==3){
			fw2flashStart=0;
			$('input[name="cloudVersion"]').removeAttr('disabled');
			alert(MM_cloud_fw2flash3);
		}else if(fw2FlashStatus==4){
			fw2flashStart=0;
			$('input[name="cloudVersion"]').removeAttr('disabled');
			alert(MM_cloud_fw2flash4);
		}else if(fw2FlashStatus==0){
			fw2flashStart=0;
			$('input[name="cloudVersion"]').removeAttr('disabled');
			alert(MM_cloud_fw2flash5);
			top.location.reload();
		}
	}
}
function initValue(){	
	var trNode,btnValue;
	$("#cloudFWList").html("");
	var urlFilterListTab=$("#cloudFWList").get(0);
	for(var i=0;i<responsecloudVerJson.length;i++){
		trNode=urlFilterListTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML=(i-0+1);responsecloudVerJson[i].ID;		
		trNode.insertCell(1).innerHTML=responsecloudVerJson[i].version;
/*		if(parseInt(responseCloudStatus['cloudFileDown'])==3){
			btnValue=BT_upgrade;
		}else
			btnValue=MM_downloaded;
		}*/
		trNode.insertCell(2).innerHTML='<input type=\"button\" onClick="updateFW(this,'+responsecloudVerJson[i].ID+')" name="cloudVersion" value=\"'+MM_downloaded+'\" id=\"btn'+responsecloudVerJson[i].ID+'\"><span id=\"span'+responsecloudVerJson[i].ID+'\" style="display:none;" name="download"></span>';	
	}
}
$(function(){
	var postVar = { topicurl : "setting/getCloudFWInfo"};
	postVar['updateAction']="getAllFWInfo";
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responsecloudVerJson = JSON.parse(Data);
		}
    });		
	initValue();
});
</script>
</head>

<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="uploadFirmware">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_cloud)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_upgrade_cloudFw)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_cloud_check)</script></td>
<td><script>dw('<input type="button" class=button value="'+MM_cloud_checkNewFile+'" name="upgrade" id="upgrade" onClick="checkFirmwareClick()">')</script></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class="hidden bline"></td></tr>
</table>

<table border=0 width="100%">
<tr><td colspan="3"><b><script>dw(MM_cloud_fw_table)</script></b></td></tr>
<tr><td colspan="3"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_cloud_fwversion)</script></b></td>
<td class="item_center"><b><script>dw(MM_cloud_option)</script></b></td>
</tr>
<tbody id="cloudFWList"></tbody>
<tr><td colspan="3"><hr size=1 noshade align=top class=bline></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>
