CREATE TABLE "user" (
	"id" serial NOT NULL,
	"password" varchar(64) NOT NULL,
	"email" varchar(256) UNIQUE NOT NULL,
	"role_id" int NOT NULL,
	CONSTRAINT user_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "role" (
	"id" serial NOT NULL,
	"name" varchar(64) NOT NULL,
	CONSTRAINT role_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "recovery" (
	"id" serial NOT NULL,
	"user_id" serial NOT NULL,
	"recovery_hash" varchar(256) NOT NULL,
	"expire_date" DATE NOT NULL,
	CONSTRAINT recovery_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "users_skill" (
	"id" serial NOT NULL,
	"skill_name" varchar(256) NOT NULL,
	"parrent_id" int,
	"language_id" int NOT NULL,
	CONSTRAINT users_skill_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "program_language" (
	"id" serial NOT NULL,
	"language_name" varchar(32) NOT NULL,
	CONSTRAINT program_language_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "user_to_users_skill" (
	"user_id" int NOT NULL,
	"skill_id" int NOT NULL,
	"id" serial NOT NULL,
	CONSTRAINT user_to_users_skill_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "exercise" (
	"id" serial NOT NULL,
	"description" TEXT NOT NULL,
	"name_function" varchar(256) NOT NULL,
	"input_parameter" jsonb NOT NULL,
	"output_parameter" jsonb NOT NULL,
	CONSTRAINT exercise_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "result" (
	"id" serial NOT NULL,
	"user_id" int NOT NULL,
	"exercise_id" int NOT NULL,
	"language_id" int NOT NULL,
	"result" bool NOT NULL,
	"user_solution" TEXT NOT NULL,
	"state" varchar(32) NOT NULL,
	"executive_time" int NOT NULL,
	"final_result_date" DATE NOT NULL,
	CONSTRAINT result_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "solution_reports" (
	"id" serial NOT NULL,
	"result_id" int NOT NULL,
	"console_output" TEXT NOT NULL,
	"creation_date" DATE NOT NULL,
	"error_log" TEXT NOT NULL,
	CONSTRAINT solution_reports_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



ALTER TABLE "user" ADD CONSTRAINT "user_fk0" FOREIGN KEY ("role_id") REFERENCES "role"("id");


ALTER TABLE "recovery" ADD CONSTRAINT "recovery_fk0" FOREIGN KEY ("user_id") REFERENCES "user"("id");

ALTER TABLE "users_skill" ADD CONSTRAINT "users_skill_fk0" FOREIGN KEY ("language_id") REFERENCES "program_language"("id");


ALTER TABLE "user_to_users_skill" ADD CONSTRAINT "user_to_users_skill_fk0" FOREIGN KEY ("user_id") REFERENCES "user"("id");
ALTER TABLE "user_to_users_skill" ADD CONSTRAINT "user_to_users_skill_fk1" FOREIGN KEY ("skill_id") REFERENCES "users_skill"("id");


ALTER TABLE "result" ADD CONSTRAINT "result_fk0" FOREIGN KEY ("user_id") REFERENCES "user"("id");
ALTER TABLE "result" ADD CONSTRAINT "result_fk1" FOREIGN KEY ("exercise_id") REFERENCES "exercise"("id");
ALTER TABLE "result" ADD CONSTRAINT "result_fk2" FOREIGN KEY ("language_id") REFERENCES "program_language"("id");

ALTER TABLE "solution_reports" ADD CONSTRAINT "solution_reports_fk0" FOREIGN KEY ("result_id") REFERENCES "result"("id");

