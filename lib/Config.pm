package Config;

$ENV{config_host} = "localhost";

#aerospike
$ENV{config_as_namespace} = "test";
$ENV{config_as_set} = "testSet";
$ENV{config_as_conn_timeout} = 10;
$ENV{config_as_host} = '127.0.0.1';

1;