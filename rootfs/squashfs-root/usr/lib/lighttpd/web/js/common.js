var getElements=function(name){	return document.getElementsByName(name);}

function getById(id){with(document){return getElementById(id);	}}
function getByName(name){with(document){return getElementsByName(name);}}

function showLanguageLabel(){
	//document.write("<div id=\"waitfor\"><span>Set Tips</span></div>");
	document.write("<div id=\"languageDiv\" style=\"display:none\"><table width=172 border=0 cellpadding=3 cellspacing=0>\
	<tr><td colspan=2 height=22></td></tr>\
	<tr><td class=\"languageTitle\" onclick=\"clickEnglish(1)\">"+MM_english+"</a></td>\
	<td><img id=\"language_en\" src=\"../style/language_check.gif\" border=0></td></tr>\
	<tr><td colspan=2 height=8></td></tr>\
	<tr><td class=\"languageTitle\" onclick=\"clickChinese(1)\">"+MM_chinese_simplified+"</a></td>\
	<td><img id=\"language_cn\" src=\"../style/language_no_check.gif\" border=0></td></tr>\
	</table></div>");
	window.onscroll = moveLanguagePosition;
}

function moveLanguagePosition(){
	document.getElementById("languageDiv").style.pixelTop = document.body.scrollTop;
}

function clickEnglish(val){
//	parent.frames["menu"].document.langCfg.langType.value = "en";
//	parent.frames["menu"].document.langCfg.submit();
	var postVar = { topicurl : "setting/setLanguageCfg"};
	postVar['langType'] = "en";
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			top.location.reload();
		}
   	});	
	if (val==1)
		parent.frames["view"].document.getElementById("languageDiv").style.display = "none";
}

function clickChinese(val){
//	parent.frames["menu"].document.langCfg.langType.value = "cn";
//	parent.frames["menu"].document.langCfg.submit();
	var postVar = { topicurl : "setting/setLanguageCfg"};
	postVar['langType'] = "cn";
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			top.location.reload();
		}
   	});	
	if (val==1)
		parent.frames["view"].document.getElementById("languageDiv").style.display = "none";
}
function resetForm(){
	location=location; 
}
function selectAll(obj){
	for(var i = 0;i<obj.elements.length;i++){
		if(obj.elements[i].type == "checkbox")	
			obj.elements[i].checked = true;
	}
}

function selectUnAll(obj){
	for(var i = 0;i<obj.elements.length;i++){
		if(obj.elements[i].type == "checkbox" )	{
			if(!obj.elements[i].checked) 
				obj.elements[i].checked = true;
			else 
				obj.elements[i].checked = false;
		}
	}
}

function getRefToDivNest(divID,oDoc){
  	if( !oDoc ) { oDoc = document; }
  	if( document.layers ) {
		if( oDoc.layers[divID] ) { return oDoc.layers[divID]; } else {
		for( var x = 0, y; !y && x < oDoc.layers.length; x++ ) {
			y = getRefToDivNest(divID,oDoc.layers[x].document); }
		return y; } }
  	if( document.getElementById ) { return document.getElementById(divID); }
  	if( document.all ) { return document.all[divID]; }
  	return document[divID];
}

function progressBar(oBt,oBc,oBg,oBa,oWi,oHi,oDr){
  	MWJ_progBar++; this.id = 'MWJ_progBar' + MWJ_progBar; this.dir = oDr; this.width = oWi; this.height = oHi; this.amt = 0;
  	//write the bar as a layer in an ilayer in two tables giving the border
  	document.write('<span id="progress_div" style="display:none"><table border="0" cellspacing="0" cellpadding="'+oBt+'">'+
	'<tr><td bgcolor="'+oBc+'">'+
		'<table border="0" cellspacing="0" cellpadding="0"><tr><td height="'+oHi+'" width="'+oWi+'" bgcolor="'+oBg+'">' );
  	if( document.layers ) {
		document.write('<ilayer height="'+oHi+'" width="'+oWi+'"><layer bgcolor="'+oBa+'" name="MWJ_progBar'+MWJ_progBar+'"></layer></ilayer>' );
  	} 
	else {
		document.write('<div style="position:relative;top:0px;left:0px;height:'+oHi+'px;width:'+oWi+';">'+
			'<div style="position:absolute;top:0px;left:0px;height:0px;width:0;font-size:1px;background-color:'+oBa+';" id="MWJ_progBar'+MWJ_progBar+'"></div></div>' );
  	}
  	document.write('</td></tr></table></td></tr></table></span>\n' );
  	this.setBar = resetBar; //doing this inline causes unexpected bugs in early NS4
  	this.setCol = setColour;
}

function resetBar(a,b){
  	//work out the required size and use various methods to enforce it
  	this.amt = ( typeof( b ) == 'undefined' ) ? a : b ? ( this.amt + a ) : ( this.amt - a );
  	if( isNaN( this.amt ) ) { this.amt = 0; } if( this.amt > 1 ) { this.amt = 1; } if( this.amt < 0 ) { this.amt = 0; }
  	var theWidth = Math.round( this.width * ( ( this.dir % 2 ) ? this.amt : 1 ) );
	//alert(theWidth);
  	var theHeight = Math.round( this.height * ( ( this.dir % 2 ) ? 1 : this.amt ) );
  	var theDiv = getRefToDivNest( this.id ); if( !theDiv ) { window.status = 'Progress: ' + Math.round( 100 * this.amt ) + '%'; return; }
  	if( theDiv.style ) { theDiv = theDiv.style; theDiv.clip = 'rect(0px '+theWidth+'px '+theHeight+'px 0px)'; }
 	var oPix = document.childNodes ? 'px' : 0;
  	theDiv.width = theWidth + oPix; theDiv.pixelWidth = theWidth; theDiv.height = theHeight + oPix; theDiv.pixelHeight = theHeight;
  	if( theDiv.resizeTo ) { theDiv.resizeTo( theWidth, theHeight ); }
  	theDiv.left = ( ( this.dir != 3 ) ? 0 : this.width - theWidth ) + oPix; theDiv.top = ( ( this.dir != 4 ) ? 0 : this.height - theHeight ) + oPix;
}

function setColour(a){
  	//change all the different colour styles
  	var theDiv = getRefToDivNest( this.id ); if( theDiv.style ) { theDiv = theDiv.style; }
  	theDiv.bgColor = a; theDiv.backgroundColor = a; theDiv.background = a;
}

function openWindow(url,windowName,wide,high){
	if (document.all)
		var xMax = screen.width, yMax = screen.height;
	else if (document.layers)
		var xMax = window.outerWidth, yMax = window.outerHeight;
	else
	   var xMax = 640, yMax=500;
	
	var xOffset = (xMax - wide)/2;
	var yOffset = (yMax - high)/3;
	var settings='width='+wide+',height='+high+',screenX='+xOffset+',screenY='+yOffset+',top='+yOffset+',left='+xOffset+',resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes';
	var win=window.open(url, windowName, settings);
	win.opener = window;
}
function atoi(s,n){
    i=1;
    if (n!=1) {
        while (i!=n && s.length!=0){
            if (s.charAt(0)=='.') i++;
            s = s.substring(1);
        }
        if (i!=n) return -1;
    }
    for (i=0; i<s.length; i++){
        if (s.charAt(i)=='.'){ 
			s=s.substring(0, i); 
			break; 
		}
    }
    if (s.length==0) return -1;
    return parseInt(s, 10);
}
function isEmpty(s){
	if(s=="") return 0;
	return 1;
}
function isSsid(s){
	for (var i=0; i<s.length; i++) {
		if (s.charAt(i) == '\'' || s.charAt(i) == '\"' || s.charAt(i) == '\/' || s.charAt(i) == '\\')
			return 0;
		else
	        continue;
	}
	return 1;
}
function isString(s){
	for (var i=0; i<s.length; i++) {
		if (s.charAt(i) == '\'' || s.charAt(i) == '\"' || s.charAt(i) == '\/' || s.charAt(i) == '\\' || s.charAt(i) == ' ' || s.charAt(i) == ';' || s.charAt(i) == ',')
			return 0;
		else
	        continue;
	}
	return 1;
}
function isFirstZero(v){
	for (var i=0; i<v.length; i++) {
		if (v.length>1 && v.charAt(0)=='0')
			return 0;
	}
	return 1;
}
function isNumber(v){
	if (!isFirstZero(v)) return 0;
	for (var i=0; i<v.length; i++) {
    		if (v.charAt(i) >= '0' && v.charAt(i) <= '9')
			continue;		
		return 0;
  	}
	return 1;
}
function isNumberMsg(s,m){
	if(!isNumber(s)) {alert(m+JS_msg9); return 0;}
	return 1;
}
function isNumberRange(s,min,max){
	if(parseInt(s)<min||parseInt(s)>max) return 0;
	return 1;
}
function isBlankMsg(s,m){
	if(!isEmpty(s)) {alert(m+JS_msg1); return 0;}    
	if(/.*[\u4e00-\u9fa5]+.*$/.test(s)){alert(m+JS_msg2); return 0;}
	if(/[^\x00-\xff]/.test(s)){ alert(m+JS_msg2);return 0;}
	if(!isString(s)) {alert(m+JS_71); return 0;}
	return 1;
}
function isBlankMsg2(s,m){
	if(!isEmpty(s)) {alert(m+JS_msg9); return 0;}
	if(!isNumber(s)) {alert(m+JS_msg9); return 0;}
	return 1;
}
function isValidSsidMsg(s,m){
	if(!isEmpty(s)) {alert(m+JS_msg1); return 0;}
	if(/.*[\u4e00-\u9fa5]+.*$/.test(s)){alert(m+JS_msg2); return 0;}
	if(/[^\x00-\xff]/.test(s)){ alert(m+JS_msg2);return 0;}
	if(!isSsid(s)) {alert(m+JS_3); return 0;}
	return 1;
}
function isHex(s){
	for (var i=0; i<s.length; i++) {
    		if ( (s.charAt(i) >= '0' && s.charAt(i) <= '9') || (s.charAt(i) >= 'a' && s.charAt(i) <= 'f') || (s.charAt(i) >= 'A' && s.charAt(i) <= 'F'))
			continue;		
		return 0;
  	}
	return 1;
}
function isHexMsg(s,m){
	if(!isHex(s)) {
		 alert(m+JS_msg23); 
		 return 0;
		}
	return 1;
}
function isHexMsg2(s,m,len1,len2){
	if(!isHex(s)||len1!=len2) {
		 alert(m+JS_181+len2+JS_182); 
		 return 0;
		}
	return 1;
}
function isPort(s){
	if(!isNumber(s)) return 0;
	if(parseInt(s)<1||parseInt(s)>65535) return 0;
	return 1;
}
function isPort2(s){
	if(!isNumber(s)) return 0;
	if(parseInt(s)<1024||parseInt(s)>65535) return 0;
	return 1;
}
function isPortMsg(s){
	if(!isEmpty(s)) {alert(JS_112); return 0;}
	if(!isPort(s)) {alert(JS_113); return 0;}
	return 1;
}
function isRemotePortMsg(s){
	if(!isEmpty(s)) {alert(JS_112); return 0;}
	if(!isPort2(s)) {alert(JS_130); return 0;}
	return 1;
}
function isPortRange(s1,s2){
	if(parseInt(s1)>parseInt(s2)) {alert(JS_114); return 0;}
	return 1;
}
function isMac(s){
	if(s.length!=17) return 0;	
	for (var i=0; i<s.length; i++) {
    	if ((s.charAt(i) >= '0' && s.charAt(i) <= '9') || (s.charAt(i) >= 'a' && s.charAt(i) <= 'f') || (s.charAt(i) >= 'A' && s.charAt(i) <= 'F') || (s.charAt(i) == ':'))
			continue;	
		return 0;
  	}	
	if(s.split(":").length!=6) return 0;	
	if((s.toUpperCase()=="FF:FF:FF:FF:FF:FF")||(s.toUpperCase()=="00:00:00:00:00:00")) return 0;
	for(var k=0;k<s.length;k++){if((s.charAt(1)&0x01)||(s.charAt(1).toUpperCase()=='B')||(s.charAt(1).toUpperCase()=='D')||(s.charAt(1).toUpperCase()=='F')) return 0;}
	return 1;
}
function isMacMsg(s,m){
	if(!isEmpty(s)) {alert(m+JS_115); return 0;}
	if(!isMac(s)) {alert(m+JS_msg99); return 0;}
	return 1;
}
function isIpCharset(s){
	for (var i=0; i<s.length; i++) {
    	if ((s.charAt(i) >= '0' && s.charAt(i) <= '9') || (s.charAt(i) == '.'))
			continue;		
		return 0;
  	}	
	var v=s.split(".");
	if(v.length!=4) return 0;
	return 1;
}
function ipTest(s,n,min,max){
	var d=atoi(s,n);
	if(d<min||d>max) return 0;
	return 1;
}
function isIpAddr(s){
	if(!isIpCharset(s)) return 0;
	if(!ipTest(s,1,1,255)||!ipTest(s,2,0,255)||!ipTest(s,3,0,255)||!ipTest(s,4,1,254)) return 0;
	return 1;
}
function isIpAddrMsg(s,m){
	if(!isEmpty(s)) {alert(m+JS_msg1); return 0;}
	if(!isIpAddr(s)) {alert(m+JS_142); return 0;}
	return 1;
}
function maskTest(s,n){
  	var d=atoi(s,n);
  	if(!(d==0||d==128||d==192||d==224||d==240||d==248||d==252||d==254||d==255)) return 0;
  	return 1;
}
function isMaskAddr(s){
	if(!isIpCharset(s)) return 0;
	if(!maskTest(s,1)||!maskTest(s,2)||!maskTest(s,3)||!maskTest(s,4)) return 0;
	return 1;
}
function isMaskAddrMsg(s,m){
	if(!isEmpty(s)) {alert(m+JS_msg1); return 0;}
	if(!isMaskAddr(s)) {alert(m+JS_143); return 0;}
	return 1;
}
function isIpSubnet(s1,mn,s2){
  	var ip1=s1.split(".");
   	var ip2=s2.split(".");
   	var ip3=mn.split(".");
   	//if(ip1.length!=4||ip2.length!=4||ip3.length!=4) return 0;
   	for(var k=0;k<=3;k++){
		if((ip1[k]&ip3[k])!=(ip2[k]&ip3[k])) return 0;
	}
   	return 1;
}
function isIpSubnet2(s1, s2){
  	ip1 = s1.replace(/\.\d{1,3}$/,".");
  	ip2 = s2.replace(/\.\d{1,3}$/,".");
  	if (ip1==ip2) return 0;
	return 1;
}
function isIpRange(s1,s2){
	var ip1=s1.split(".");
	var ip2=s2.split(".");
	//if(ip1.length!=4||ip2.length!=4) return 0;
	for(var k=0;k<4;k++){
		var a=Number(ip1[3]);
		var b=Number(ip2[3]);
      	if(a>=b) {alert(JS_msg41); return 0;}
	}
	return 1;
}
function isServerIp(s) {
	if (!isString(s) && !isIpAddr(s)) return 0;
	return 1;
}
function decomIP(ipa,ips,nodef){
	var re = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
	if (re.test(ips)){
		var d =  ips.split(".");
		for (i = 0; i < 4; i++){
			ipa[i].value=d[i];
			if (!nodef) ipa[i].defaultValue=d[i];
		}
		return true;
	}
	return false;
}

function decomIP2(ipa,ips,nodef){
	var re = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
	if (re.test(ips)){
		var d =  ips.split(".");
		for (i = 0; i < 3; i++){
			ipa[i].value=d[i];
			if (!nodef) ipa[i].defaultValue=d[i];
		}
		return true;
	}
	return false;
}

function decomMAC(ma,macs,nodef){
    var re = /^[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}$/;
    if (re.test(macs)||macs=='') {
		if (ma.length!=6){
			ma.value=macs;
			return true;
		}
		if (macs!='') var d=macs.split(":");
		else var d=['','','','','',''];
        for (i = 0; i < 6; i++){
            ma[i].value=d[i];
			if (!nodef) ma[i].defaultValue=d[i];
		}
        return true;
    }
    return false;
}

function combinIP(d){
	if (d.length!=4) return d.value;
    var ip=d[0].value+"."+d[1].value+"."+d[2].value+"."+d[3].value;
    if (ip=="...")
        ip="";
    return ip;
}
function combinMAC(m){
    var mac=m[0].value.toUpperCase()+":"+m[1].value.toUpperCase()+":"+m[2].value.toUpperCase()+":"+m[3].value.toUpperCase()+":"+m[4].value.toUpperCase()+":"+m[5].value.toUpperCase();
    if (mac==":::::")
        mac="";
    return mac;
}

function combinMAC2(m1,m2,m3,m4,m5,m6){
    var mac=m1.toUpperCase()+":"+m2.toUpperCase()+":"+m3.toUpperCase()+":"+m4.toUpperCase()+":"+m5.toUpperCase()+":"+m6.toUpperCase();
    if (mac==":::::")
        mac="";
    return mac;
}

function checkDate(str) {
	var month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	var week = [MM_week7, MM_week1, MM_week2, MM_week3, MM_week4, MM_week5, MM_week6];
	
	if ((str.substring(4,5)) == " ") str = str.replace(" ","");
	else str = str;
	
	var t = str.split(" ");	
	for (var j=0; j<12; j++){
		if (t[0] == month[j]) t[0] = j + 1;
	}	
	return t[2] + "-" + t[0] + "-" + t[1];
}

function scheduleSyncTime(form_name){
	var currentTime = new Date();

	var seconds = currentTime.getSeconds();
	var minutes = currentTime.getMinutes();
	var hours = currentTime.getHours();
	var month = currentTime.getMonth() + 1;
	var day = currentTime.getDate();
	var year = currentTime.getFullYear();

	var seconds_str = " ";
	var minutes_str = " ";
	var hours_str = " ";
	var month_str = " ";
	var day_str = " ";
	var year_str = " ";

	if(seconds < 10)
		seconds_str = "0" + seconds;
	else
		seconds_str = ""+seconds;

	if(minutes < 10)
		minutes_str = "0" + minutes;
	else
		minutes_str = ""+minutes;

	if(hours < 10)
		hours_str = "0" + hours;
	else
		hours_str = ""+hours;

	if(month < 10)
		month_str = "0" + month;
	else
		month_str = ""+month;

	if(day < 10)
		day_str = "0" + day;
	else
		day_str = day;

	var tmp1 = month_str + day_str + hours_str + minutes_str + year + " ";
	var tmp2 = hours_str +":"+ minutes_str +":"+seconds_str;
	form_name.CurTime1.value = tmp1;
	form_name.CurTime2.value = tmp2;
}
function scheduleWeek(form_name){
	if (form_name.week_all.checked == true) {
		form_name.week_1.disabled = true;
		form_name.week_2.disabled = true;
		form_name.week_3.disabled = true;
		form_name.week_4.disabled = true;
		form_name.week_5.disabled = true;
		form_name.week_6.disabled = true;
		form_name.week_7.disabled = true;

		form_name.week_1.checked = true;
		form_name.week_2.checked = true;
		form_name.week_3.checked = true;
		form_name.week_4.checked = true;
		form_name.week_5.checked = true;
		form_name.week_6.checked = true;
		form_name.week_7.checked = true;		
	} 
	else {		
		form_name.week_1.disabled = false;
		form_name.week_2.disabled = false;
		form_name.week_3.disabled = false;
		form_name.week_4.disabled = false;
		form_name.week_5.disabled = false;
		form_name.week_6.disabled = false;
		form_name.week_7.disabled = false;

		form_name.week_1.checked = false;
		form_name.week_2.checked = false;
		form_name.week_3.checked = false;
		form_name.week_4.checked = false;
		form_name.week_5.checked = false;
		form_name.week_6.checked = false;
		form_name.week_7.checked = false;
	}
}
function scheduleTime(form_name){
	if (form_name.time_all.checked == true) {
		form_name.time_h1.disabled = true;
		form_name.time_h2.disabled = true;
		form_name.time_m1.disabled = true;
		form_name.time_m2.disabled = true;
	} 
	else {
		form_name.time_h1.disabled = false;
		form_name.time_h2.disabled = false;
		form_name.time_m1.disabled = false;
		form_name.time_m2.disabled = false;
	}
}
function scheduleWeekCheck(form_name){
	var i;
	if (form_name.week_all.checked == false){
		for(i=1;i<=7;i++){			
			if(eval("form_name.week_"+i+".checked") == true)
				return 0;
		}
		alert(JS_msg97);
		return 1;
	}
	return 0;
}
function scheduleTimeRangeCheck(val, flag){	
	var t = /[^0-9]{1,2}/;	
	if (t.test(val)){
		alert(JS_msg9);
		return 0;
	}		
	if (flag == 1)	{	//hour
		if (parseInt(val) < 0 || parseInt(val) > 23){  
			alert(JS_msg94);
			return 0;
		}
	}
	else {	//minute
		if (parseInt(val) < 0 || parseInt(val) > 59){  
			alert(JS_msg95);
			return 0;
		}
	}
	return 1;
}
function scheduleTimeCmpCheck(v1, v2, v3, v4){
	if(v1.length==2 && v1.charAt(0) == 0)
		v1 = v1.charAt(1);
	if(v2.length==2 && v2.charAt(0) == 0)
		v2 = v2.charAt(1);
	if(v3.length==2 && v3.charAt(0) == 0)
		v3 = v3.charAt(1);
	if(v4.length==2 && v4.charAt(0) == 0)
		v4 = v4.charAt(1);
	
	if (parseInt(v1) > parseInt(v2)){
		alert(JS_msg96);
		return 0;
	}

	if (parseInt(v1) == parseInt(v2)) {
		if (parseInt(v3) > parseInt(v4)){
			alert(JS_msg96);
			return 0;
		}
	}
	return 1;
}
function scheduleTimeCheck(form_name){
	if (form_name.time_all.checked == false) {
		if (!scheduleTimeRangeCheck(form_name.time_h1.value, 1))	 return 1;
		if (!scheduleTimeRangeCheck(form_name.time_h2.value, 1))	 return 1;
		if (!scheduleTimeRangeCheck(form_name.time_m1.value, 0))	 return 1;
		if (!scheduleTimeRangeCheck(form_name.time_m2.value, 0))	 return 1;
		if (!scheduleTimeCmpCheck(form_name.time_h1.value, form_name.time_h2.value, form_name.time_m1.value, form_name.time_m2.value))	 return 1;
	}
	return 0;
}
function scheduleTimeRangeCheck2(form_name){
	if (!scheduleTimeCmpCheck(form_name.time_h1.value, form_name.time_h2.value, form_name.time_m1.value, form_name.time_m2.value))	 return 1;
	return 0;
}
function scheduleShowWeek(w){
	var tmp="";
	var flag = 0;
	if(parseInt(w)>=254)
		tmp = MM_week1+","+MM_week2+","+MM_week3+","+MM_week4+","+MM_week5+","+MM_week6+","+MM_week7
		//tmp = "Mon,Tue,Wed,Thu,Fri,Sat,Sun";
	else{
		if(parseInt(w) & (0x1<<1)){
			tmp=MM_week1;
			flag=1;
		}
		if(parseInt(w) & (0x1<<2)){
			if(flag == 1){
				tmp +=","+MM_week2;
			}
			else{
				tmp=MM_week2;
				flag=1;
			}
		}
		if(parseInt(w) & (0x1<<3)){
			if(flag == 1){
				tmp +=","+MM_week3;
			}
			else{
				tmp=MM_week3;
				flag=1;
			}
		}
		if(parseInt(w) & (0x1<<4)){
			if(flag == 1){
				tmp +=","+MM_week4;
			}
			else{
				tmp=MM_week4;
				flag=1;
			}
		}
		if(parseInt(w) & (0x1<<5)){
			if(flag == 1){
				tmp +=","+MM_week5;
			}
			else{
				tmp=MM_week5;
				flag=1;
			}
		}
		if(parseInt(w) & (0x1<<6)){
			if(flag == 1){
				tmp +=","+MM_week6;
			}
			else{
				tmp=MM_week6;
				flag=1;
			}
		}
		if(parseInt(w) & (0x1<<7)){
			if(flag == 1){
				tmp +=","+MM_week7;
			}
			else{
				tmp=MM_week7;
			}
		}
	}
	return tmp;
}

/*
0-9	: 48-57 & 96-105
Back: 8
Tab	: 9
Shif: 16
Del	: 46
<-	: 37
->	: 39
.	: 110 & 190
F5	: 116
*/
//e->input event; o->input object; i->input number
function setFocusFirst(obj){
	if(obj.createTextRange){//IE
		var txt = obj.createTextRange();
		txt.moveStart('character',obj.value.length);
		txt.collapse(true);
		txt.select();
	}
	else
		obj.focus();
}
function setFocusLast(obj){
	if(obj.setSelectionRange){//FF
		obj.setSelectionRange(0,0);
		obj.focus();
	}
	else
		obj.focus();
}
function setFocusAll(obj){
	if(obj.createTextRange){//IE
		var txt = obj.createTextRange();
		txt.moveStart("character", 0);
		txt.moveEnd("character", obj.value.length);
		txt.select();
	}
	else if(obj.setSelectionRange){//FF
		obj.setSelectionRange(0,obj.value.length);
		obj.focus();
	}
}
function ipVali(e, n, i){
	var co = e.keyCode;
	var sh = e.shiftKey;
	var inputs = document.getElementsByName(n);
	if(co==8 || co==16 || co==46 || (co>=48 && co<=57) || (co>=96 && co<=105) || co==116){
		if(sh && co >=48 && co <=57)
			return false;
		if(co==8){
			if((inputs[i].value=="") && (inputs[i-1] != null))
				setFocusFirst(inputs[i-1]);//末尾
			return true;
		}
		if(co==46){
			if((inputs[i].value=="") && (inputs[i+1] != null))
				setFocusLast(inputs[i+1]);//前
			return true;	
		}
		/*if(inputs[i].value.length>=3){
			if(inputs[i+1] != null)
				setFocusAll(inputs[i+1]);
		}*/
	}
	else if(co==9 || co==37 || co==39 || co==110 || co==190){
		if(co==9) return true;
		if(co==37){
			if(inputs[i].value != "")
				return true;
			else if(inputs[i-1] != null)
				inputs[i-1].focus();
			return false;
		}
		if(co==39){
			if(inputs[i].value != "")
				return true;
			else if(inputs[i+1] != null)
				inputs[i+1].focus();
			return false;
		}
		if(co==110 || co==190){
			if(inputs[i].value.length>0 && inputs[i+1]!=null)
				setFocusAll(inputs[i+1]);
			return false;
		}
	}
	else{
		return false;	
	}
}
function ipVali2(n, i){
	var inputs = document.getElementsByName(n);
	if(inputs[i].value<0 || inputs[i].value>255){		
		alert(JS_msg60);
		setFocusAll(inputs[i]);
		return false;
	}		
}
function HWKeyUp(prefix,idx){
	var obj=document.getElementsByName(prefix+idx);
	var nextidx = idx + 1;
	var keynum;

   	if(window.event)
		keynum = event.keyCode;
	else if(e.which) // Netscape/Firefox/Opera
		keynum = event.which;

	if(keynum == 9 || keynum == 8) return;

	if(obj[0].value.length == 2){
		obj=document.getElementsByName(prefix+nextidx);
		if(obj[0]) obj[0].focus();
		return;
	}
}
function CheckHex(keynum){
	if( ( (keynum >= 96) && (keynum <= 105) )||( (keynum >= 48) && (keynum <= 57) )||( (keynum >= 65) && (keynum <= 70) ) ) 		     return true;
	return false;
}
function HWKeyDown(prefix,idx){
	var obj=document.getElementsByName(prefix+idx);
	var previdx = idx - 1;

    if(window.event)
		keynum = event.keyCode;
	else if(e.which) // Netscape/Firefox/Opera
		keynum = event.which;

	if((keynum == 9)||(keynum == 46)||(keynum == 8)){
		if(obj[0].value.length == 0 && event.keyCode == 8){
			obj=document.getElementsByName(prefix+previdx);
			if(obj[0]) obj[0].focus();
		}
		return 1;
	}
	return CheckHex(keynum);
}
function userBrowser(){  
    var browserName=navigator.userAgent.toLowerCase();
    if(/msie/i.test(browserName) && !/opera/.test(browserName)){   
        return "IE";  
    }else if(/firefox/i.test(browserName)){   
        return "Firefox";  
    }else if(/chrome/i.test(browserName) && /webkit/i.test(browserName) && /mozilla/i.test(browserName)){  
        return "Chrome";  
    }else if(/opera/i.test(browserName)){  
        return "Opera";  
    }else if(/webkit/i.test(browserName) &&!(/chrome/i.test(browserName) && /webkit/i.test(browserName) && /mozilla/i.test(browserName))){  
        return "Safari";  
    }else{  
        return "unKnow";  
    }  
}
function stopDefault( e ) {
	if ( e && e.preventDefault )
		e.preventDefault();
	else
		window.event.returnValue = false;
	return false;
}
function IP2Decimal(ipv4){
	var aIPsec=ipv4.split("."); 
	for(var i=0;i<4;i++){
		if(parseInt(aIPsec[i])<16)
			aIPsec[i]="0"+parseInt(aIPsec[i]).toString(16);
		else
			aIPsec[i]=parseInt(aIPsec[i]).toString(16);
	}
	var nIPaddr=parseInt("0x"+aIPsec[0]+aIPsec[1]+aIPsec[2]+aIPsec[3]);
	return nIPaddr;
}
function checkIpGw(ip, nm,gw){
	if((IP2Decimal(ip)&IP2Decimal(nm))!=(IP2Decimal(gw)&IP2Decimal(nm))){
		return false;
	}
    return true;
}
/*get os info*/
function detectOS() {
    var sUserAgent = navigator.userAgent;
    var isWin = (navigator.platform == "Win32") || (navigator.platform == "Windows");
    var isMac = (navigator.platform == "Mac68K") || (navigator.platform == "MacPPC") || (navigator.platform == "Macintosh") || (navigator.platform == "MacIntel");
    if (isMac) return "Mac";
    var isUnix = (navigator.platform == "X11") && !isWin && !isMac;
    if (isUnix) return "Unix";
    var isLinux = (String(navigator.platform).indexOf("Linux") > -1);
    if (isLinux) return "Linux";
    if (isWin) {
        var isWin2K = sUserAgent.indexOf("Windows NT 5.0") > -1 || sUserAgent.indexOf("Windows 2000") > -1;
        if (isWin2K) return "Win2000";
        var isWinXP = sUserAgent.indexOf("Windows NT 5.1") > -1 || sUserAgent.indexOf("Windows XP") > -1;
        if (isWinXP) return "WinXP";
        var isWin2003 = sUserAgent.indexOf("Windows NT 5.2") > -1 || sUserAgent.indexOf("Windows 2003") > -1;
        if (isWin2003) return "Win2003";
        var isWinVista= sUserAgent.indexOf("Windows NT 6.0") > -1 || sUserAgent.indexOf("Windows Vista") > -1;
        if (isWinVista) return "WinVista";
        var isWin7 = sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 7") > -1;
        if (isWin7) return "Win7";
		var isWin8 = sUserAgent.indexOf("Windows NT 6.2") > -1 || sUserAgent.indexOf("Windows 7") > -1;
        if (isWin8) return "Win8";
    }
    return "other";
}
	
var Cookie = {
    Get : function(name){
        var arrStr = document.cookie.split("; ");
        for(var i = 0;i < arrStr.length;i ++){
            var temp = arrStr[i].split("=");
            if(temp[0] == name) 
                return unescape(temp[1]);
        }
        return null;
    },     

    Set : function(name, value, hours, path){
        var str = name + "=" + escape(value);

        if(hours != undefined && hours > 0){
            var date = new Date();
            var ms = hours * 3600 * 1000;
            date.setTime(date.getTime() + ms);
            str += "; expires=" + date.toGMTString();
        }
		 
        if(path == undefined){
			path = "/";
		}
        str += "; path=" + path;
        
        document.cookie = str;
    },    

    Delete :function(name, path){
        var date = new Date();
		var str;
        date.setTime(date.getTime() - 10000);
		
        if(path == undefined){
            path = "/";
		}
        str += "; path=" + path;
        document.cookie = name + "=; expires=" + date.toGMTString() + str;
    }
}
function checkStringValue(paramer){
	var filenamev=paramer;
	if(/\\/g.test(filenamev)){
		var tmpStr=filenamev.replace(/\\/g,"|");	
		filenamev=tmpStr.substring(tmpStr.lastIndexOf("|")+1);
	}
	if(/[^\d\.\-\_\a-zA-Z\u4E00-\u9FA5]/g.test(filenamev)){		
		alert(JS_131);
		return false;
	}	
	return true;
}
var isIE = /msie/i.test(navigator.userAgent) && !window.opera;       
function fileChange(target){       
    var fileSize = 0; 
	var size=0;	
    if (isIE && !target.files) {    
      var filePath = target.value;    
     /* var fileSystem = new ActiveXObject("Scripting.FileSystemObject");       
      var file = fileSystem.GetFile (filePath);    
      fileSize = file.Size;  
	  var obj_img = document.getElementById('tempimg');  
      obj_img.dynsrc=filePath;  
      filesize = obj_img.fileSize; 	  */
	  fileSize=1;
    } else {   
     fileSize = target.files[0].size;    
    }  
    size = fileSize / 1024;   
	var freeDisk=Cookie.Get("freeDisk");
    if(size>freeDisk){ 
		alert(MM_disk_info);  
		target.value="";
		return false;
    } 
	return true;
 }     
/* check the ip or mask */
function checkIpMask(IPorMask,msg,type)
{
	var exp=/^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
	if(IPorMask == "" || IPorMask == null){  
		alert(JS_127+JS_141);
        return false;  
    } 
	var reg = IPorMask.match(exp);

	if(reg==null)
	{
		alert(msg)
		return false;
	}
	else
	{
		if(RegExp.$1 != parseInt(RegExp.$1).toString() ||
		RegExp.$2 != parseInt(RegExp.$2).toString()||
		RegExp.$3 != parseInt(RegExp.$3).toString()||
		RegExp.$4 != parseInt(RegExp.$4).toString())
		{
			alert(msg);
			return false;
		}
		if(type==1){  //1 for mask
			var part1,part2,part3,part4;
			function maskPartCheck(part){
				var maskPart=[0,128,192,224,240,248,252,254,255];
				for(var i in maskPart){
					if(part ==  maskPart[i]){
						return true;
					}
				}
				return false;
			}
			if(maskPartCheck(RegExp.$1)&&maskPartCheck(RegExp.$2)&&maskPartCheck(RegExp.$3)&&maskPartCheck(RegExp.$4)){
				if(RegExp.$1<255){
					if(RegExp.$2==0&&RegExp.$3==0&&RegExp.$4==0){
						return true;
					}else{
						alert(msg);
						return false;
					}
				}
				if(RegExp.$2<255){
					if(RegExp.$3==0&&RegExp.$4==0){
						return true;
					}else{
						alert(msg);
						return false;
					}
				}
				if(RegExp.$3<255){
					if(RegExp.$4==0){
						return true;
					}else{
						alert(msg);
						return false;
					}
				}		
			}else{
				alert(msg);
				return false;
			}
		}
		return true;
	}
}
 //check empty input and space input
function blankCheck(v,m)
{	
	if ((v.length==0) || (v.indexOf(" ") >= 0)){alert(m+JS_141); return 0;}
	return 1;
}

function disableButton (button) {
  if (document.all || document.getElementById)
    button.disabled = true;
  else if (button) {
    button.oldOnClick = button.onclick;
    button.onclick = null;
    button.oldValue = button.value;
    button.value = 'DISABLED';
  }
}

function enableButton (button) {
  if (document.all || document.getElementById)
    button.disabled = false;
  else if (button) {
    button.onclick = button.oldOnClick;
    button.value = button.oldValue;
  }
}

function skip () { this.blur(); }
function disableTextField (field) {
  if (document.all || document.getElementById)
    field.disabled = true;
  else {
    field.oldOnFocus = field.onfocus;
    field.onfocus = skip;
  }
}

function enableTextField (field) {
  if (document.all || document.getElementById)
    field.disabled = false;
  else {
    field.onfocus = field.oldOnFocus;
  }
}

function disableAllButton()
{
	var forms = document.forms;
	for (var j = 0; j < forms.length; j++) {
		var selectForm = document.forms[j];
		var control = document.forms[j].elements; 
		for (var i = 0; i < control.length; i++) {
			if (control[i].type == "button" || control[i].type == "reset" || control[i].type == "submit") {
				control[i].disabled = true;
			}
		}
	}
}

function enableAllButton()
{
	var forms = document.forms;
	for (var j = 0; j < forms.length; j++) {
		var selectForm = document.forms[j];
		var control = document.forms[j].elements; 
		for (var i = 0; i < control.length; i++) {
			if (control[i].type == "button" || control[i].type == "reset" || control[i].type == "submit") {
				control[i].disabled = false;
			}
		}
	}
}
//check port
function isPort(v) 
{
   	if (!isNumber(v)) return 0;          
   	if ((parseInt(v)<1)||(parseInt(v)>65535)) return 0;
   	return 1;
}

function portCheck(v,m) 
{
   	if (!isEmpty(v)) {alert(m+JS_164); return 0;}
	
   	if (!isPort(v)) {alert(JS_msg175); return 0;}         
   	return 1;
}
/* check the network status */
var checkNetwork={

	instance:function(gourl,interval){
		this.goURL=gourl;
		this.interval=interval;
	},
	
	successFun:function(data)
	{
		if(data=="" || data==null)
			this.detectload();
		else
			window.location.href=this.goURL;
	},
	
	failFun:function(readyState,status)
	{
		win78reload();
	},
	
	detectload:function()
	{
		setTimeout(function(){Ajax.getInstance('/login.asp','',0,this.successFun,this.failFun);Ajax.get();},this.interval);
	}
}

function getMaskLength(ipv4)
{
	var aIPsec=ipv4.split("."); 
	var len=0;
	for(var i=0;i<4;i++){
		aIPsec[i]=parseInt(aIPsec[i]).toString(2);
	}
	var nIPaddr=aIPsec[0].toString()+aIPsec[1].toString()+aIPsec[2].toString()+aIPsec[3].toString();
	for(i=0;i<nIPaddr.length;i++){
		if(nIPaddr.charAt(i)==1)
			len++;
	}
	return len;
}

function validateDigitKey(str)
{	
   	for (var i=0; i<str.length; i++) {
    		if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') )
			continue;
		return 0;
  	}
  	return 1;
}

function isChineseChar(str)
{
	if (/.*[^\x00-\xff]+.*$/.test(str)) return 0;
	return 1;
}

function isBlankEmpty(str)
{
	if (str=="") return 0;
	if (!isChineseChar(str)) return 0;
	return 1;
}
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423   
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18   
Date.prototype.Format = function(fmt)   
{ //author: meizz   
  var o = {   
    "M+" : this.getMonth()+1,     
    "d+" : this.getDate(),   
    "h+" : this.getHours(),           
    "m+" : this.getMinutes(),        
    "s+" : this.getSeconds(),     
    "q+" : Math.floor((this.getMonth()+3)/3), 
    "S"  : this.getMilliseconds()   
  };   
  if(/(y+)/.test(fmt))   
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
  for(var k in o)   
    if(new RegExp("("+ k +")").test(fmt))   
  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));   
  return fmt;   
}  
///////////////////////////////////////////////////////////////////////////////
///////////jquery///////////////
function supplyValue(Name,Value){
	var node;
	node= $("#"+Name);
	if(node[0]==undefined)
	 	node=$("input[name="+Name+"]");
	 
	var bigType = node[0].tagName || node.get(0).tagName;
	switch(bigType){
		case 'TD' : {}
		case 'DIV' : {}
		case 'SPAN' : {
			node.html(Value);
			break;
		}
		case 'SELECT' : {
			node.val(Value);
			break;
		}
		case 'INPUT' : {
			var smallType = node[0].type;			
			switch(smallType){
				case 'text':
				case 'hidden':
				case 'password':{
					node.val(Value);
					break;
				}
				case 'radio' : {
					$("input:radio[name="+Name+"][value="+Value+"]").attr("checked","true");
					break;
				}
				case 'checkbox' : {
					if(Value==1)
					 	node.attr("checked",true); 
					else
					  	node.attr("checked",false); 
					break;
				}
			}
		}
	}
}
function setJSONValue(array_json){
	if(typeof array_json != 'object'){ return false;}
	var element;
	
	for(var i in array_json){
		element = $("#"+i) || $("input[name="+i+"]");
		if(element != null){
			supplyValue(i,array_json[i]);
		}
	}
}

function setDisabled(objId,bool){
	$(objId).attr("disabled",bool);
}
function CreateOptions(nodeName,optionValue,valueArray){
	var Node = document.getElementById(nodeName),valueOptions;
	
	$('#'+nodeName).empty();
	Node.options.length = 0;
	if(valueArray == undefined){
		valueOptions = optionValue;
	} else {
		valueOptions = valueArray;
	}
	
	for(var i = 0; i < optionValue.length; i++){
		Node.options[i] = new Option(optionValue[i]);
		Node.options[i].value = valueOptions[i];
		
	}
}
function refresh_all(){
	alert(JS_msg47);
	self.setTimeout("top.location.reload();", 90000);
}

function uiPost(postVar)
{
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		var responseJson = JSON.parse(Data);
		if("90"==responseJson['wtime']){
			refresh_all();
		}else{
			setTimeout("resetForm();","3000");
		}
	});
}

/*-----------check value---------------*/
var checkVaildVal={
	isNumber : function(str){
		var re=/^[0-9]*$/;
		if(!re.test(str)) 
			return 0;	
		return 1;
	},
	
	IsVaildNumber : function (str,msg){
		if(str==""){
			alert(msg+JS_msg1);	
			return 0;
		} 
		if(!checkVaildVal.isNumber(str)){
			alert(msg+JS_msg9);
			return 0;   
		}  
		return 1;
	},
	
	IsVaildNumberRange : function (str,msg,min,max){
		if(str==""){
			alert(msg+JS_msg1);	
			return 0;
		} 
		if(!checkVaildVal.isNumber(str)){
			alert(msg+JS_msg9);
			return 0;   
		}  
		if((parseInt(str)<min)||(parseInt(str)>max)){
			alert(msg+JS_msg10+min+"-"+max+JS_msg11);
			return 0;   
		} 
		return 1;
	},
	
	isAllChar : function (str){
		if(/[\xB7]/.test(str))	
			return 0;
		if(/[^\x00-\xff]/.test(str))
			return 0;
		return 1;
	},
	
	isHex : function (str){
		var re=/[^A-Fa-f0-9]/;
		if(re.test(str)) 
			return 0;
		return 1;	
	},
	isEnOrDig : function (str){
		var re=/[^A-Za-z0-9]/;
		if(re.test(str)) 
			return 0;
		return 1;	
	},
	isString : function(str){
		var re1=/[^\x20-\x7D]/;
		var re2=/[\x20\x22\x24\x25\x27\x2F\x3B\x3C\x3E\x5C\x60]/;
		if(re1.test(str)||re2.test(str))
			return 0;
		return 1;
	},
	isCommentString : function(str){
		var re1=/[^\x20-\x7D]/;
		var re2=/[\x20\x22\x24\x25\x27\x2C\x2F\x3B\x3C\x3E\x5C\x60]/;
		if(re1.test(str)||re2.test(str))
			return 0;
		return 1;
	},
		
	isSSID : function(str){
		var re1=/[^\x20-\x7D]/;
		var re2=/[\x22\x24\x25\x27\x2F\x3B\x3C\x3E\x5C\x60]/;
		if(re1.test(str)||re2.test(str))
			return 0;
		return 1;
	},
	
	strTrim : function(str){
		str=str.replace(/^[\x20]*/,"");
		str=str.replace(/[\x20]*$/,"");
		str=str.replace(/[\x20]+/g," ");
		return str;
	},

	IsVaildUserString : function (str,msg){
		if((str=="") || (str.indexOf(" ") >= 0)){
			alert(msg+JS_msg73);
			return 0;
		}
		if(!checkVaildVal.isEnOrDig(str)){
			alert(msg+JS_msg74);
			return 0;   
		} 
		return 1;
	},

	IsVaildString : function (str,msg,flag){
		if(flag==1&&str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		if(!checkVaildVal.isAllChar(str)){
			alert(msg+JS_msg2);
			return 0;   
		} 
		if(flag==1 && !checkVaildVal.isString(str)){
			alert(msg+JS_msg6);	  
			if(str.length>32){
				alert(msg+JS_msg3);
				return 0;
			}
			return 0;
		}
		else if(flag==2 && !checkVaildVal.isCommentString(str)){
			alert(msg+JS_msg78);	  
			if(str.length>20){
				alert(msg+JS_msg4);
				return 0;
			}
			return 0;
		}
		else if(flag==3 && !checkVaildVal.isString(str)){
			alert(msg+JS_msg6);	  
			if(str.length>128){
				alert(msg+JS_msg5);
				return 0;
			}
			return 0;
		}
		return 1;
	},

	IsVaildSSID : function (str,msg){
		var countChinese=0;
		if(str==""){
			alert(msg+JS_msg1);
			return 0;
		}

	//	if(!checkVaildVal.isAllChar(str)){
	//		alert(msg+JS_msg2);
	//		return 0;   
	//	} 

		if(str.length>32){
			alert(msg+JS_msg3);
			return 0;
		}

		if(!checkVaildVal.ischkHalf(str)){			
			alert(msg+JS_msg129);
			return 0;
		}
		for (var i=0;i<=str.split("").length;i++){
		    if(/.*[^\u0000-\u00FF]+.*$/.test(str.split("")[i]))
		    countChinese++;
		}
		if(str.length>32-(countChinese*2)){
		    alert(JS_msg130);
		    return 0;
		}
		if(!checkVaildVal.isSSID(str)){
				
			alert(msg+JS_msg129);
			return 0;
		}
		//中文标点符号Unicode
		var reg1 = /[\uff08\uff09\u3014\u3015\u3010\u3011\u2014\u2026\u2013\uff0e\u300a\u300b\u3008\u3009\u00b7\u00d7]/;
		var reg2=/[\u3002\uff1f\uff01\uff0c\u3001\uff1b\uff1a\u300c\u300d\u300f\u2018\u2019\u201c\u201d]/;
		if(reg1.test(str)||reg2.test(str)){
			alert(msg+JS_msg129);
			return 0;
		}
		if(str.split("")[0]==" "||str.split("")[str.length-1]==" "){
			alert(msg+JS_msg8);
			return 0;
		}
		return 1;
	},

	IsVaildWiFiPass : function (str,msg,flag){
		if(str==""){
			alert(msg+JS_msg1);	
			return 0;
		} 
		if(flag=="ascii"&&!checkVaildVal.isString(str)){
				alert(msg+JS_msg6);
			return 0;  
		}
		if(flag=="hex"&&!checkVaildVal.isHex(str)){
			alert(msg+JS_msg23);
			return 0;
		}  
		return 1;
	},

	isRptSSID : function(str){
		var re1=/[^\x20-\x7D]/;
		if(re1.test(str)) return 0;
		return 1;
	},

	IsVaildRptSSID : function (str,msg){
		if(str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		if(!checkVaildVal.isAllChar(str)){
			alert(msg+JS_msg2);
			return 0;   
		}  
		if(str.length>32){
			alert(msg+JS_msg3);
			return 0;
		}
		if(!checkVaildVal.isRptSSID(str)){
			alert(msg+JS_msg2);
			return 0;   
		} 
		if(str.split("")[0]==" "||str.split("")[str.length-1]==" "){
			alert(msg+JS_msg8);
			return 0;
		}
		return 1;
	},
	
	isPort : function(str){
		if(!checkVaildVal.isNumber(str)) 
			return 0;
		if (parseInt(str)<1||parseInt(str)>65535) 
			return 0;
		return 1;
	},
	
	IsVaildPort : function (str,msg){
		if(str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		if(!checkVaildVal.isPort(str)){
			alert(msg+JS_msg18);
			return 0;
		}
		return 1;
	},
	
	isMAC : function (str){
		//var re=/[A-Fa-f0-9]{12}/;
		var re=/[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}/;
		if(!re.test(str))
			return 0;
		return 1;
	},
	
	IsVaildMacAddr : function (str){
		if(str.length!=17){
			alert(JS_msg16);
			return 0;
		}
		if(!checkVaildVal.isMAC(str)){
			alert(JS_msg16);
			return 0;
		}
		if(str=="00:00:00:00:00:00"||str.toUpperCase()=="FF:FF:FF:FF:FF:FF"){
			alert(JS_msg14);
			return 0;
		}
		for(var k=0;k<str.length;k++) {
			if((str.charAt(1)&0x01)||(str.charAt(1).toUpperCase()=='B')||(str.charAt(1).toUpperCase()=='D')||(str.charAt(1).toUpperCase()=='F')) {
				alert(JS_msg17);
				return 0;
			}
		}
		return 1;
	},
	
	IsVaildIpAddr : function (str, msg){
		var re=/^(?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))$/;
		var buf;
		if(str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		if(!re.test(str)){
			alert(msg+JS_msg61);
			return 0;
		}
		buf=str.split(".");
		if(buf[3]<1||buf[3]>254){		
			alert(msg+JS_msg62);
			return 0;		
		}
		return 1;
	},
	
	isIP : function(str){
		var re=/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
		var buf;
		if(!re.test(str)) 
			return 0;
		buf=str.split(".");	
		for(i=0;i<4;i++){
			if(buf[i]<0||buf[i]>255)
				return 0;
		}
		return 1;
	},
	
	isMask : function (str){	
		if(!checkVaildVal.isIP(str)) 
		   return 0;
		var buf=str.split(".");
		if(!(buf[3]==0||buf[3]==128||buf[3]==192||buf[3]==224||buf[3]==240||buf[3]==248||buf[3]==252||buf[3]==254 ))	  
			return 0;
		if(!(buf[2]==0||buf[2]==128||buf[2]==192||buf[2]==224||buf[2]==240||buf[2]==248||buf[2]==252||buf[2]==254||buf[2]==255 )) 
			return 0;
		if(!(buf[1]==0||buf[1]==128||buf[1]==192||buf[1]==224||buf[1]==240||buf[1]==248||buf[1]==252||buf[1]==254||buf[1]==255 )) 
			return 0;
		if(!( buf[0]==128||buf[0]==192||buf[0]==224||buf[0]==240||buf[0]==248||buf[0]==252||buf[0]==254||buf[0]==255 )) 
			return 0;
		return 1;
	},
	
	IsVaildMaskAddr : function(str,msg){
		if(str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		if(!checkVaildVal.isIP(str)){
			alert(msg+JS_msg61);
			return 0;
		}
		var buf=str.split(".");
		if(buf[0]==255&&buf[1]==255&&buf[2]==255){
			if(!(buf[3]==0||buf[3]==128||buf[3]==192||buf[3]==224||buf[3]==240||buf[3]==248||buf[3]==252||buf[3]==254)){
				alert(msg+JS_msg63);
				return 0;
			}
		}
		if(buf[0]==255&&buf[1]==255&&buf[3]==0){
			if(!(buf[2]==0||buf[2]==128||buf[2]==192||buf[2]==224||buf[2]==240||buf[2]==248||buf[2]==252||buf[2]==254||buf[2]==255 )){
				alert(msg+JS_msg64);
				return 0;
			}
		}
		if(buf[0]==255&&buf[2]==0&&buf[3]==0){
			if(!(buf[1]==0||buf[1]==128||buf[1]==192||buf[1]==224||buf[1]==240||buf[1]==248||buf[1]==252||buf[1]==254||buf[1]==255 )){
				alert(msg+JS_msg65);
				return 0;
			}
		}
		if(buf[1]==0&&buf[2]==0&&buf[3]==0){
			if(!( buf[0]==128||buf[0]==192||buf[0]==224||buf[0]==240||buf[0]==248||buf[0]==252||buf[0]==254||buf[0]==255 )){
				alert(msg+JS_msg66);
				return 0;
			}
		}
		if(!((buf[0]==255&&buf[1]==255&&buf[2]==255)||(buf[0]==255&&buf[1]==255&&buf[3]==0)||(buf[0]==255&&buf[2]==0&&buf[3]==0)||(buf[1]==0&&buf[2]==0&&buf[3]==0))){
			alert(msg+JS_msg67);
			return 0;
		}
		return 1;
	},

	IsIpRange : function (startIP,endIP){
		var ip1=startIP.split(".");
		var ip2=endIP.split(".");
		if(Number(ip1[0])>Number(ip2[0])){
			alert(JS_msg41); 
			return 0;
		}
		if(ip1[0]==ip2[0]){
			if(Number(ip1[1])>Number(ip2[1])){
				alert(JS_msg41); 
				return 0;
			}
		}
		if(ip1[0]==ip2[0]&&ip1[1]==ip2[1]){
			if(Number(ip1[2])>Number(ip2[2])){
				alert(JS_msg41); 
				return 0;
			}
		}
		
		if(ip1[0]==ip2[0]&&ip1[1]==ip2[1]&&ip1[2]==ip2[2]){
			if(Number(ip1[3])>Number(ip2[3])){		
				alert(JS_msg41); 
				return 0;
			}
		}		
		return 1;
	},

	IsIpSubnet : function (s1,mn,s2){
		var ip1=s1.split(".");
		var ip2=s2.split(".");
		var ip3=mn.split(".");
		for(var k=0;k<=3;k++){
			if((ip1[k]&ip3[k])!=(ip2[k]&ip3[k])) return 0;
		}
		return 1;
	},

	IsSameIp : function (s1, s2){
		ip1 = s1.replace(/\.\d{1,3}$/,".");
		ip2 = s2.replace(/\.\d{1,3}$/,".");
		if (ip1==ip2) return 0;
		return 1;
	}	
}