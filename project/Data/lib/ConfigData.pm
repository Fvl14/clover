package ConfigData;

use Exporter 'import';
@EXPORT_OK = qw($configData $router);

our $configData = {
	config_host => 'localhost',

	#aerospike
	config_as_namespace => 'clover',
	config_as_set => 'testSet',
	config_as_conn_timeout => 10,
	config_as_host => '127.0.0.1'
};

our $router = [
	'/api/exercise' => 'Controller::Exercise',
    '/api/exercise/{id:\d+}' => 'Controller::Exercise',
    '/api/login' => 'Controller::Authentication',
    '/api/registration' => 'Controller::Registration',
    '/api/user' => 'Controller::User',
    '/api/user/{id:\d+}' => 'Controller::User',
    '/api/logout' => 'Controller::Logout'
];

1;