package ConfigData;

use Exporter 'import';
@EXPORT_OK = qw($configData $router);

our $configData = {
	config_host => 'localhost',

	#aerospike
	config_as_namespace => 'test',
	config_as_set => 'testSet',
	config_as_conn_timeout => 10,
	config_as_host => '127.0.0.1'
};

our $router = [
	'/aaa/exercise' => 'Controller::Exercise',
    '/aaa/exercise/{id:\d+}' => 'Controller::Exercise',
    '/aaa/login' => 'Controller::Authentication'
];

1;