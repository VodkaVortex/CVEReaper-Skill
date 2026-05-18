<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>TOTOLINK</title>
    <link rel="shortcut icon" href="favicon.ico">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/csstyle.css">
    <script language="javascript" src="js/jquery-1.11.1.min.js"></script>
    <script language="javascript" src="js/mobile.js"></script>
	<style>
		.has-feedback .form-control{
			padding-right: 0;
			padding-left: 34px;
		}
		.form-control-feedback {
			left: 0;
			top: 30px !important;
			color: #999;
		}
	</style>
</head>
<body>
	<div class="container-fluid">
		<div class="container" align="center">
        	<div class="cs-h-30"></div>
			<img src="img/logo.png" class="img-responsive cs-logo">
		</div>
        
		<div id="cs_login">
            <div class="cs-h-30"></div>
            <div class="container col-xs-10 col-xs-offset-1">
                <div align="center">
                	<span class="cs-font-36"><script>dw(MB_welcome)</script></span>
                </div>
                <div class="cs-h-30"></div>
                <form method="post" id="login_frm" name="login_frm" action="/cgi-bin/cstecgi.cgi?action=login&flag=1">
                <div class="form-group has-feedback">
                    <label for="username"><script>dw(MB_username)</script></label>
                    <span class="form-control-feedback"><i class="glyphicon glyphicon-user"></i></span>
                    <input type="text" class="form-control input-lg" id="username" name="username" maxlength="32">
                </div>
                <div class="form-group has-feedback">
                    <label for="password"><script>dw(MB_password)</script></label>
                    <span class="form-control-feedback"><i class="glyphicon glyphicon-lock"></i></span>
                    <input type="password" class="form-control input-lg" id="password" name="password" maxlength="32"  onChange="$('#cs_login_btn').click();">
                </div>
				<div class="form-group" id="div_err" style="display: none;">
					<label class="cs-err" id="err_msg"></label>
				</div>
				<div class="form-group" align="right">
					<a class="cs-font-white cs-a-link" id="cs_forgot_btn"><script>dw(MB_forgot)</script></a>
				</div>				
                <div class="cs-h-10"></div>
                <div class="row">
                    <div class="col-xs-8 col-xs-offset-2">
                    	<button type="submit" class="btn btn-lg btn-block btn-cs-black" id="cs_login_btn"><script>dw(BT_login)</script></button>
                    </div>
                </div>				
                </form>
                <div class="cs-h-20"></div>
            </div>
		</div>
	</div>
	<script language="javascript" src="js/bootstrap.min.js"></script>
    <script language="javascript" src="js/router.js"></script>
	<script>
		$(function() {
			$('#cs_login_btn').on('click', function(event) {
				if($("#username").val()==""||$("#password").val()==""){
					$('#err_msg').html(JS_msg51);
					$('#div_err').show();
					return false;
				}
                $("#login_frm").submit();
				return true;
			});
			$('#cs_forgot_btn').on('click', function(event) {
				gotoUrl('forgot.asp');
			});

            var rJson = _globalCfg_;
            setCookie("languageType", rJson.LanguageType);
            setCookie("productName", rJson.ProductModel);
            setCookie("fmVersion", rJson.fmVersion);  

            if (rJson["login_flag"]=="2"){
            	$('#div_err').show();
                $('#err_msg').html(JS_msg52);
            }else if (rJson["login_flag"]=="3"){
            	$('#div_err').show();
                $('#err_msg').html(JS_msg53);
            }
		});
	</script>
</body>
</html>