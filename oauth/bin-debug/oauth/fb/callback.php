<?php
session_start();
$url = 'https://graph.facebook.com/oauth/access_token'
        . '?client_id=' . $_SESSION['application_id']
        . '&client_secret=' . $_SESSION['application_secret']
        . '&redirect_uri=' . $_SESSION['redirect_uri']
        . '&code=' . $_GET['code'];
$result = file_get_contents($url, False, $cxContext);
$output = null;
parse_str($result, $output);
if (!isset($output['access_token'])) {
  session_destroy();
  die();
}
$_SESSION['access_token'] = $output['access_token'];
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>OAuth Comp</title>
<script src="swfobject.js" type="text/javascript"></script>
</head>
<body>
	<div id="content"></div>
	<script type="text/javascript">
	<!--
		var flashvars = {
			access_token:"<?php echo $_SESSION['access_token'] ?>"
		};
		var params = { menu:"false", bgcolor:"#FFFFFF", allowScriptAccess:"always"};
		var attributes = {id:"content", name:"content"};

		swfobject.embedSWF("OauthCallbackFB.swf", "content", "465", "465", "10", null, flashvars, params, attributes);
	//-->
	</script>

</body>
</html>