# Clover


### Installation

Clover requires [Docker](https://www.docker.com/) to run.


### Docker
Clover is very easy to install in a Docker container.

```sh
cd clover
docker build .
```
This will create the dillinger image and pull in the necessary dependencies. 
Once done, run the Docker image and map the ports 80 and 443  to whatever you wish on your host. In this example, we simply map port 8001(8002) of the host to port 80(443) of the Docker (or whatever ports was exposed in the Dockerfile):

```sh
docker run -p 8001:80 -p 8002:443 <build_image_id>
```

Verify the deployment by navigating to your server address in your preferred browser.

```sh
POST: http://localhost:8001/api/registration
{
	"email":"test@email.com",
	"password":"234"
}
```

#### List of API

```sh
GET '/api/exercise' - get all exercises from clover,
------------------------------------------------------------
POST '/api/exercise' - add exercise to clover,
{
    "description":"Some task",
    "name_function":"test_funk",
    "input_parameter": "\{\"var1\": \"var2\"\}", #json
    "output_parameter": "\{\"res1\": \"res2\"\}" #json
}
------------------------------------------------------------
GET '/api/exercise/:id' - get exercise from clover,
------------------------------------------------------------
PUT '/api/exercise/:id' - update exercise,
{
    "description":"New task",
    "name_function":"test_new_funk",
    "input_parameter": "\{\"var3\": \"var4\"\}", #json
    "output_parameter": "\{\"res3\": \"res4\"\}" #json
}
------------------------------------------------------------
DELETE '/api/exercise/:id' - delete exercise,
------------------------------------------------------------
POST '/api/login' - login into clover,
{
	"email":"test@email.com",
	"password":"1234"
}
------------------------------------------------------------
POST '/api/registration' => create an account in clover,
{
	"email":"test@email.com",
	"password":"1234"
}
------------------------------------------------------------
GET '/api/user' - get list of users from clover,
------------------------------------------------------------
POST '/api/user' - add new user to clover,
{
	"email":"test2@email.com",
	"password":"11111"
}
------------------------------------------------------------
POST '/api/logout/:id' - user logout
```


### Todos
- Review
- Write more APIs for Data
- Write Tests
- Add APIs for ZeroMQ
- Add frontend Angular UI with its own API

License
----


**Free Software, Yeah!**


