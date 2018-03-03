<?php
	@define('HTTP_USER_AGENT', 'Mozilla/5.0 (Windows NT 6.0; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0', true);
	@define('HTTP_TIME_OUT', 30, true);
	@define('HTTP_USE_GZIP', true, true);
	$httpIP = null;

	@define('RPC_TIME_OUT', 5, true);

	@define('LOG_RPC_CALLS', false, true);
	@define('LOG_RPC_FAULTS', true, true);

	// for php
	@define('PHP_USE_GZIP', false, true);
	@define('PHP_GZIP_LEVEL', 2, true);

	$schedule_rand = 10;

	$do_diagnostic = true;
	$log_file = '/tmp/errors.log';

	$saveUploadedTorrents = true;
	$overwriteUploadedTorrents = false;

	$topDirectory = '/data/rtorrent/';
	$forbidUserSettings = false;

	$scgi_port = 0;
	$scgi_host = "unix:///tmp/rpc.socket";

	$XMLRPCMountPoint = "/RPC2";

	$pathToExternals = array(
		"php"  => '',
		"curl" => '/usr/bin/curl',
		"gzip" => '',
		"id"   => '',
		"stat" => '',
	);

	$localhosts = array(
		"127.0.0.1",
		"localhost",
	);

	$profilePath = '/data/rtorrent/rutorrent/user-profiles';
	$profileMask = 0777;

	$tempDirectory = null;
