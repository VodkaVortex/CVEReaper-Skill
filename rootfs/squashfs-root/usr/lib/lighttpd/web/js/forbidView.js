var icon_System_Status = "icon_System_Status";
var icon_Opmode = "icon_Opmode";
var icon_Network = "icon_Network";
var icon_Wireless = "icon_Wireless";
var icon_USB_Storage = "icon_USB_Storage";
var icon_Management = "icon_Management";
var icon_QoS = "icon_QoS";
var icon_Firewall = "icon_Firewall";

var NoSubMenu = 0;
var WithSubMenu = 1;

var cur_id=0;
var cur_sub_id=0;
var cur_menu = WithSubMenu;
var cur_icon = 0;

function Node(id, pid, name, url, submenu, icon) 
{
	this.id = id;
	this.pid = pid;
	this.name = name;
	this.url = url;
	this.submenu = submenu;
	this.icon =icon;
}

function Menu(objName) 
{
	this.obj = objName;
	this.aNodes = [];
}

// Adds a new node to the node array
Menu.prototype.add = function (id, pid, name, url, submenu, icon)
{   
    this.aNodes[this.aNodes.length] = new Node(id, pid, name,url, submenu, icon);
}

Menu.prototype.toString = function()
{
    var str = '';
  
    var n=0;
    var id='';
    var pid='';
    var name='';
    var url=''; 
    var submenu='';
    var icon='';
    for (n; n<this.aNodes.length; n++)
    {
        id = this.aNodes[n].id;
        pid = this.aNodes[n].pid;
        name = this.aNodes[n].name;
        url = this.aNodes[n].url;
        submenu = this.aNodes[n].submenu;
		icon = this.aNodes[n].icon;
		
        if(pid==0)
        {
            str += "<A href="+ url +" target = view >";
			str += "<div id ="+ id;
			if(submenu == NoSubMenu)
				str += " class=left_title onmouseover=My_T_Over(";
			else
				str += " class=left_title1 onmouseover=My_T_Over(";
            str += id + "," + submenu + "," + icon + ")";
            str += " onmouseout=My_T_Out(";
            str += id + "," + submenu + "," + icon +")";
            str += " onclick=My_Open_T(";
            str += id + "," + submenu + "," + icon + ")>";
			str += "<ul style='clear:both;'><li style='float:left;height:34px;'>";
			str += "<img id=img" + id + " src=\"style/" + icon +".png\" border=\"0\">";
			str += "</li>";
			str += "<li>"+ name + "</li></ul>";
            str += "</div></A><ul id=submenu_" + id + " class=dis >";
            str += "</ul>";
        }
        else
        {
			aid=id+"01";
            str = str.substring(0, str.length-5);  
            str += "<li style='clear:left;' id=" + id + "  class=left_link >";
            str += "<img src='style/submenu.png' algin='absmiddle'>&nbsp;&nbsp;";
            str += "<A href=" + url + " id=" + aid;
            str += " onclick=My_Open_A(" + id + "," + aid + ")";
			str += " hidefocus target=view > ";
            str += name;
            str += "</A>";
            str += "</li>";
            str += "</ul>";     
        }
    }
    return str;
}

function My_T_Over(id,foldval,icon)
{
    var x=document.getElementById(id);
	if(foldval==NoSubMenu)
	{
		document.getElementById("img"+id).src="style/"+icon+".png";
		x.className="left_title_over3";
	}
	else
	{
		if(cur_sub_id && (cur_id == id))
			x.className="left_title_over2";
		else
			x.className="left_title_over1";
	}
}

function My_T_Out(id,foldval,icon)
{
    var x=document.getElementById(id);
    if(cur_id==id)
    {
		if(foldval == NoSubMenu)
		{	
			document.getElementById("img"+id).src="style/"+icon+"_ON.png";
			x.className= "left_title_out3";
		}
		else
		{
			if (0==cur_sub_id && foldval == WithSubMenu)
				x.className= "left_title1";
			else
				x.className= "left_title_out2";
		}
    }
    else
    {
		if(foldval == NoSubMenu)
			x.className= "left_title";
		else
			x.className= "left_title1";
    }
}
function setWlanIdx(val){
	var postVar = { topicurl : "setting/setWebWlanIdx"};
	postVar['webWlanIdx'] = "'"+val+"'";
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : true,  
        success : function(Data){
		}
   	});	
}

function My_Open_T(id,submenu,icon)
{  
    var subnode;
    if(cur_id != id)
    {
		if(4==id){
			top.frames[0].wifiSelect=0;
			setWlanIdx(0);
		}else if(10==id){
			top.frames[0].wifiSelect=1;
			setWlanIdx(1);
		}
		
        if(cur_id != 0)
        {			
			if (cur_sub_id != 0)
            {
				try{subnode=document.getElementById(cur_sub_id + "01");
					subnode.style.color = "";
					subnode.style.fontWeight = "";
				}catch(e){};
            }
			
          	try{document.getElementById("submenu_"+cur_id).className="dis";}catch(e){};
		  	
			if(cur_menu == NoSubMenu)
			{
				try{document.getElementById(cur_id).className="left_title";}catch(e){};
		  	}
			else
			{
				try{document.getElementById(cur_id).className="left_title1";}catch(e){};
			}
        }
        
        try{document.getElementById("submenu_"+id).className="block";}catch(e){};
		
		if(submenu == NoSubMenu)
		{   
			if(cur_id != 0)
			{
				try{document.getElementById("img"+cur_id).src="style/"+cur_icon+".png";}catch(e){};
			}
			try{document.getElementById("img"+id).src="style/"+icon+"_ON.png";}catch(e){};
			try{document.getElementById(id).className ="left_title_out3";}catch(e){};
		}
		else 
		{
			if(cur_id != 0)
			{
				try{document.getElementById("img"+cur_id).src="style/"+cur_icon+".png";}catch(e){};
			}
			try{document.getElementById("img"+id).src="style/"+icon+"_ON.png";}catch(e){};
			try{document.getElementById(id).className ="left_title_over2";}catch(e){};
		}
		
        cur_id =id;
        cur_sub_id =cur_id+"01";
		cur_menu =submenu;
		cur_icon =icon;
        try{subnode=document.getElementById(cur_sub_id + "01");
			if (subnode != null)
			{
				subnode.style.color = "#0095c5";
				subnode.style.fontWeight = "700";
			}
			else
			{
				cur_sub_id=0;
			}
		}catch(e){};
    }
	else
	{
		var x=document.getElementById(id);
		if(submenu == NoSubMenu)
		{
			if(x.className = "left_title")
				x.className = "left_title_out3";
			try{document.getElementById("img"+id).src="style/"+icon+"_ON.png";}catch(e){};
		}
		else
		{
			if(cur_id != 0)
			{
				if(cur_id==id && 0==cur_sub_id)
				{
					try{document.getElementById("submenu_"+id).className="block";}catch(e){};
					
					if(submenu == NoSubMenu)
					{
						;
					}
					else
					{
						try{document.getElementById(id).className ="left_title_over2";}catch(e){};
						try{document.getElementById("img"+id).src="style/"+icon+"_ON.png";}catch(e){};
					}
					
					cur_id =id;
					cur_sub_id =cur_id+"01";
					cur_menu =submenu;
					cur_icon =icon;
					try{subnode=document.getElementById(cur_sub_id + "01");
						if (subnode != null)
						{
							subnode.style.color = "#0095c5";
							subnode.style.fontWeight = "700";
						}
						else
						{
							cur_sub_id=0;
						}
					}catch(e){};
				}
				else
				{
					if (cur_sub_id != 0)
					{
						try{subnode=document.getElementById(cur_sub_id + "01");
						subnode.style.color = "";
						subnode.style.fontWeight = "";}catch(e){};
						
						if(cur_id != 0)
						{
							try{document.getElementById("img"+cur_id).src="style/"+cur_icon+".png";}catch(e){};
						}
						
					}
					
					try{document.getElementById("submenu_"+cur_id).className="dis";}catch(e){};
					try{document.getElementById(cur_id).className="left_title1";}catch(e){};
					cur_sub_id=0;
				}
			}
		}
	}
	var x=document.getElementById(id);
	x.parentNode.href=addTimestamp(x.parentNode.href);
}

function addTimestamp(url){
	var _url = url;
	if(_url.indexOf('?') == -1){
		_url += '?timestamp=' + (new Date()).getTime();
	}else{
		if(_url.indexOf('timestamp') == -1)
			_url += "&timestamp=" + (new Date()).getTime();
		else
			_url=_url.replace(/timestamp=.*/ig,"timestamp=" + (new Date()).getTime());
	}
	return _url;
}

function My_Open_A(id,aid)
{
    var x=document.getElementById(aid);
    if(cur_sub_id!=0)
    {
        var old=document.getElementById(cur_sub_id + "01");
        old.style.color = "";
        old.style.fontWeight = "";
		old.style.textDecoration = "none";
    }
	if(id == '80301') counts=0;
    x.style.color = "#0095c5";
    x.style.fontWeight = "700";
	x.style.textDecoration = "underline";
	x.href=addTimestamp(x.href);
    cur_sub_id = id;
}

function addEventHandler(target, type, func)
{
	if (target.addEventListener) 
		target.addEventListener(type, func, false);
	else if (target.attachEvent) 
		target.attachEvent("on" + type, func);
	else 
		target["on" + type] = func;
}

var stopEvent = function(e)
{
    e = e || window.event;
    if(e.preventDefault) 
	{
      	e.preventDefault();
      	e.stopPropagation();
    }
	else
	{
      	e.returnValue = false;
      	e.cancelBubble = true;
    }
}
  
function resultFun(data)
{
	if(data.length>0)
	{
		top.location.href='/login.asp';
	}
}

addEventHandler(window, "load", function() 
{	
	try{var logoutNode=document.getElementById("913");
		addEventHandler(logoutNode, "click", function(e){
			if(confirm(JS_logout)){
				top.location.href='/formLogout.htm';
			}else{
				parent.frames["view"].window.location.reload();
			}
			e  = window.event || e; 
			var srcElement  =   e.srcElement || e.target; 
			if (window.event) {
				e.cancelBubble = true;
			}
			else {
				e.preventDefault();
				e.stopPropagation();
			}
			stopEvent(e);
		});
	}catch(e){} 
	} 
);

addEventHandler(document, "mousemove", function(){	try{top.frames['title'].pageTimeoutDeal();}catch(e){}});
