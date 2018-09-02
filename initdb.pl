ystem('su - postgres');
system('psql');
system('create database clover;');
system('\q');
system('psql --username=postgres clover < /clover/clover/clover.sql');
system('exit');
