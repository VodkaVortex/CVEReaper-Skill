<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
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
var responseUserDirCfg="",responseUsbList="";
var usb_state=0;
var markPWD="";//mark current path
var MWJ_progBar = 0;
var time=0;
var delay_time=1500;
var loop_num=0;
function progress(){
  	if (loop_num == 3) {
		return false;
  	}
  	if (time < 1) 
		time = time + 0.033;
  	else {
		time = 0;
		loop_num++;
		$("#progress_div").hide();
  	}
  	setTimeout('progress()',delay_time);  
  	myProgBar.setBar(time); 
}
function showParentDir(pwd){
	var last=pwd.lastIndexOf('/');
	var parentDir=pwd.substring(0,last);
	last=parentDir.lastIndexOf('/');
	parentDir=parentDir.substring(0,last);
	return parentDir;
}
function showChangeDir(dir){
	$("#usb_dir_info").show();
	$("#usb_connect_status").hide();
	$("#mountButton").hide();
	if(dir.indexOf("media")<0)
		dir="/media/"+dir;
	if(dir=="/media"){
		resetForm();
		return false;
	}
	markPWD=dir;
	var postVarChangeDir ={"topicurl":"setting/getChangeDirCfg"};
	postVarChangeDir['curDir']=dir;
	postVarChangeDir = JSON.stringify(postVarChangeDir);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarChangeDir,  
        async : false,  
        success : function(Data){
			if(Data.indexOf("timeout")<0){
				responseDirList = JSON.parse(Data);
				var parentDir="";
				if(responseDirList.length!=0)
					parentDir=showParentDir(responseDirList[0].pwd);
				else 
					parentDir=showParentDir(markPWD);
				var strTmp="<tr><td colspan=3><img src=\"/graphics/back.gif\">&nbsp;&nbsp;<a href='#' onclick=showChangeDir('"+parentDir+"')>"+MM_parent_directory+"</a></td></tr>";
				for(var i=0;i<responseDirList.length;i++){
					strTmp+="<tr colspan=3>"
					if(responseDirList[i].mode=="dir"){
						strTmp+="<td><img src=\"/graphics/dir.gif\">&nbsp;&nbsp;<a id=dir"+i+" href='#' onclick=showChangeDir('"+responseDirList[i].pwd+"')>"+responseDirList[i].d_name+"</a></td>";
					}else{
						strTmp+="><td><img src=\"/graphics/text.gif\">&nbsp;&nbsp;<a id=dir"+i+" href='#' onclick=\"downloadFiles(this);\" name="+responseDirList[i].d_name+">"+responseDirList[i].d_name+"</a></td>";
					}	
					strTmp+="<td>"+responseDirList[i].size+"</td>";
					strTmp+="<td><input id=\"RemoveDIR\" onClick=\"delFiles('"+responseDirList[i].d_name+"')\" type=button id=RemoveDIR"+i+" value="+BT_remove+"></td>"
					strTmp+="</tr>";
				}
				strTmp+="<tr><td colspan=3><hr size=1 noshade align=top></td></tr>"
				$("#div_dirInfoList").html(strTmp);
			}
		}
    });	
}
function doMount(mountFlag){
	var postVar ={"topicurl":"setting/setMountCfg"};
	postVar['submit_code']  = mountFlag;
	uiPost(postVar);
}
function showUsbInfo(){
	var usb_connect_disk="";
	var usb_connect;
	var usbinfo;
	var mySplitResult;
	var diskpart="";
	usb_connect_disk='<table width=100% border=0>';
	usb_connect_disk+='<tr><td colspan="5" class="item_head">'+MM_shared_partitions+'</td></tr>';
	usb_connect_disk+='<tr><td colspan="5"><hr size=1 noshade align=top class=bline></td></tr>';
	usb_connect_disk+='<tr align="center">';
	usb_connect_disk+='<td class="item_center"><b>'+MM_partition_name+'</b></td>';
	usb_connect_disk+='<td class="item_center"><b>'+MM_total_size+'</b></td>';
	usb_connect_disk+='<td class="item_center"><b>'+MM_used_size+'</b></td>';
	usb_connect_disk+='<td class="item_center"><b>'+MM_free_size+'</b></td>';
	usb_connect_disk+='<td class="item_center"><b>'+MM_usage_percentage+'</b></td>';
	usb_connect_disk+='</tr>';
	diskpart=responseUsbList[1].usbInfo.split("#");
	if(diskpart.length>1){
		for(var i=0;i<diskpart.length-1;i++){
			usb_connect = diskpart[i];
			mySplitResult= usb_connect.split("?");
			if(mySplitResult[0]!='0'){	
				usb_connect_disk +='<tr align="center"><td><img src="/graphics/dir.gif">&nbsp;&nbsp;<a href="#" onclick="showChangeDir(\''+mySplitResult[0]+'\');">'+mySplitResult[0]+'</a></td>';
				usb_connect_disk +='<td>'+mySplitResult[1]+'</td><td>'+mySplitResult[2]+'</td><td>'+mySplitResult[3]+'</td><td>'+mySplitResult[4]+'</td></tr>';
			}else{
				usb_connect_disk +='<tr><td colspan=5><font color="#808080">'+JS_msg109+'</font></td></tr>';
			}
		}
		$("#div_no_usbdivice").hide();
		$("#div_usbdivice").show();
	}else{
		$("div_no_usbdivice").show();
		$("div_usbdivice").hide();
	}
	usb_connect_disk+='<tr><td colspan="5"><hr size=1 noshade align=top class=bline></td></tr>';
	usb_connect_disk+='</table>';
	$("#usb_connect_status").html(usb_connect_disk);
}
function initValue(){	
	usb_state=responseUserDirCfg['UsbFlag'];
	showUsbInfo();
	if(responseUserDirCfg['usb_sdcardBt']==1)
		supplyValue("usbdevice_check", MSG_sdcard_check);
	else
		supplyValue("usbdevice_check", MSG_usb_check);
	
	if (usb_state == 0){
	//	$("#div_no_usbdivice").show();
	//	$("#div_usbdivice").hide();
		$("#unmount").attr("disabled",true);
	}else{
		$("#div_no_usbdivice").hide();
		$("#div_usbdivice").show();
		$("#mount").attr("disabled",false);
		$("#unmount").attr("disabled",false);
	}
}
$(function(){
	var postVarDirCfg = { topicurl : "setting/getUserDirCfg"};
	postVarDirCfg = JSON.stringify(postVarDirCfg);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarDirCfg,  
        async : false,  
        success : function(Data){
			responseUserDirCfg = JSON.parse(Data);
		}
    });
	
	var postVarUsbInfo = { topicurl : "setting/getUsbInfo"};
	postVarUsbInfo = JSON.stringify(postVarUsbInfo);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarUsbInfo,  
        async : false,  
        success : function(Data){
			responseUsbList = JSON.parse(Data);
		}
    });
	initValue();
});
function uploadFiles(F){ 
	var filename=F.uploadedfile.value;
	if(filename.indexOf('/')>=0){
		var last=filename.lastIndexOf('/');
		filename=filename.substring(last+1,filename.length)
	}
	else if(filename.indexOf('\\')){
		var last=filename.lastIndexOf('\\');
		filename=filename.substring(last+1,filename.length);
	}
	if(filename == ""){
		alert(MM_name+JS_msg73);
		F.uploadedfile.focus();	
		return false; 
	}else {		
		if(filename.indexOf(' ')>=0){	
			alert(MM_name+JS_msg73);
			F.uploadedfile.focus();
			return false;
		}
		F.action="/cgi-bin/usb_uploadfile.cgi?action=httpfile_upload?"+markPWD+"/"+filename;
		progress();
		$("#progress_div").show();
		F.submit();
	}
}
function downloadFiles(th){
	var downFile=document.downloadFilesFrm;
	th.href="/cgi-bin/usb_downloadfile.cgi?action=httpfile_download?"+markPWD+"/"+th.name+"?"+userBrowser();
}
function  delFiles(del_file){
	var postVar={"topicurl":"setting/delUsbFile"};
	postVar['del_file']  = markPWD+"/"+del_file;
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<div id="div_no_usbdivice" style="display:none">
<table width=100% border=0> 
<tr><td><img src="../graphics/warning.gif" align="absmiddle">&nbsp;&nbsp;<span id="usbdevice_check">&nbsp;</span>&nbsp;&nbsp;
<script>dw('<input type=button class=button value="'+BT_refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</div>

<div id="div_usbdivice">
<form method="post" name="usb_mount">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_httpfiles_server)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_httpfiles_server)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<div id="usb_connect_status" ></div>

<table border=0 width="100%" id="mountButton"> 
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type="button" class="button" id="mount" name="mount" value="'+BT_mount+'" onClick=doMount("ON")>&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" id="unmount" name="unmount" value="'+BT_unmount+'" onClick=doMount("OFF")>')</script></td></tr>
</table>
</form>

<div id="usb_dir_info"  style="display:none">
<form name="downloadFilesFrm" method="get" >
<table width="100%" border=0>
<tr>
<td><script>dw(MM_name)</script></td>
<td><script>dw(MM_size)</script></td>
<td>&nbsp;</td>
</tr>
<tbody id="div_dirInfoList" ></tbody>
</table>
</form>

<form name="usb_upload" enctype="multipart/form-data"  method="post">
<script>dw(MM_select_file)</script>:<input id="uploadedfile" type="file" name="uploadedfile" >&nbsp;&nbsp;
<script>dw('<input id="Upload" class="button" onclick=uploadFiles(this.form) type=button name="Upload" value="'+MM_upload+'">')</script></p>
</form>
</div>
</div>
<script language="javascript1.2">
var myProgBar = new progressBar(
1,         //border thickness
'#ffffff', //border colour
'#ffffff', //background colour
'#000000', //bar colour
300,       //width of bar (excluding border)
15,        //height of bar (excluding border)
1          //direction of progress: 1 = right, 2 = down, 3 = left, 4 = up
);
</script>
<script>showFooter()</script>
</body></html>