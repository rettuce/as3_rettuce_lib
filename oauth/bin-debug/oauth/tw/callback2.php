<?php

session_start();

require_once('twitteroauth/twitteroauth.php');
require_once('config.php');

$oauth_access_token = $_SESSION['access_token'];

$access_token = $oauth_access_token['oauth_token'];
$access_token_secret = $oauth_access_token['oauth_token_secret'];
$user_id = $oauth_access_token['user_id'];
$screen_name = $oauth_access_token['screen_name'];

$connection = new TwitterOAuth(CONSUMER_KEY, CONSUMER_SECRET, $access_token, $access_token_secret);
$connection->format = 'xml';
$content = $connection->get('account/verify_credentials');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>OAuth for twitter</title>
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/swfobject.js"></script>
</head>
<body>

	<div id="content"></div>

	<script type="text/javascript">
	<!--
		var flashvars = {
			access_token        :"<?php echo $access_token; ?>",
			access_token_secret :"<?php echo $access_token_secret; ?>",
			user_id				:"<?php echo $user_id; ?>",
			screen_name			:"<?php echo $screen_name; ?>"
		};
		var params = { menu:"false", bgcolor:"#FFFFFF", allowScriptAccess:"always"};
		var attributes = {id:"content", name:"content"};

		swfobject.embedSWF("./OauthCallbackTW.swf", "content", "465", "465", "10", null, flashvars, params, attributes);
	//-->
	</script>

</body>
</html>
