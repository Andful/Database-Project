--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE customer (
    user_name text
);


ALTER TABLE customer OWNER TO postgres;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE employee (
    user_name text,
    team_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    name text,
    address text,
    salary bigint,
    schedule text,
    CONSTRAINT employee_employee_id_check CHECK ((employee_id >= 0)),
    CONSTRAINT employee_salary_check CHECK ((salary >= 0))
);


ALTER TABLE employee OWNER TO postgres;

--
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE employee_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employee_employee_id_seq OWNER TO postgres;

--
-- Name: employee_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE employee_employee_id_seq OWNED BY employee.employee_id;


--
-- Name: employee_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE employee_team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employee_team_id_seq OWNER TO postgres;

--
-- Name: employee_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE employee_team_id_seq OWNED BY employee.team_id;


--
-- Name: is_moderated_by; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE is_moderated_by (
    thread_id bigint NOT NULL,
    employee_id bigint NOT NULL
);


ALTER TABLE is_moderated_by OWNER TO postgres;

--
-- Name: is_moderated_by_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE is_moderated_by_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE is_moderated_by_employee_id_seq OWNER TO postgres;

--
-- Name: is_moderated_by_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE is_moderated_by_employee_id_seq OWNED BY is_moderated_by.employee_id;


--
-- Name: is_moderated_by_thread_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE is_moderated_by_thread_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE is_moderated_by_thread_id_seq OWNER TO postgres;

--
-- Name: is_moderated_by_thread_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE is_moderated_by_thread_id_seq OWNED BY is_moderated_by.thread_id;


--
-- Name: manager; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE manager (
    employee_id bigint
);


ALTER TABLE manager OWNER TO postgres;

--
-- Name: message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE message (
    creator text,
    thread_id bigint NOT NULL,
    message_id bigint NOT NULL,
    "time" date,
    content text
);


ALTER TABLE message OWNER TO postgres;

--
-- Name: message_message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE message_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE message_message_id_seq OWNER TO postgres;

--
-- Name: message_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE message_message_id_seq OWNED BY message.message_id;


--
-- Name: message_thread_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE message_thread_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE message_thread_id_seq OWNER TO postgres;

--
-- Name: message_thread_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE message_thread_id_seq OWNED BY message.thread_id;


--
-- Name: thread; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE thread (
    thread_id bigint NOT NULL,
    creator text,
    topic_title text,
    title text,
    description text,
    date_created date
);


ALTER TABLE thread OWNER TO postgres;

--
-- Name: messages_and_threads; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW messages_and_threads AS
 SELECT t.thread_id,
    m.content
   FROM message m,
    thread t
  WHERE (m.thread_id = t.thread_id);


ALTER TABLE messages_and_threads OWNER TO postgres;

--
-- Name: moderator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE moderator (
    employee_id bigint NOT NULL
);


ALTER TABLE moderator OWNER TO postgres;

--
-- Name: specialist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE specialist (
    employee_id bigint,
    speciality text
);


ALTER TABLE specialist OWNER TO postgres;

--
-- Name: specialists_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW specialists_info AS
 SELECT e.user_name,
    s.speciality,
    e.schedule
   FROM specialist s,
    employee e
  WHERE (s.employee_id = e.employee_id);


ALTER TABLE specialists_info OWNER TO postgres;

--
-- Name: team; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE team (
    team_id bigint NOT NULL,
    mgr_id bigint,
    mgr_start_date date
);


ALTER TABLE team OWNER TO postgres;

--
-- Name: team_mgr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE team_mgr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE team_mgr_id_seq OWNER TO postgres;

--
-- Name: team_mgr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE team_mgr_id_seq OWNED BY team.mgr_id;


--
-- Name: team_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE team_team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE team_team_id_seq OWNER TO postgres;

--
-- Name: team_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE team_team_id_seq OWNED BY team.team_id;


--
-- Name: thread_thread_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE thread_thread_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE thread_thread_id_seq OWNER TO postgres;

--
-- Name: thread_thread_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE thread_thread_id_seq OWNED BY thread.thread_id;


--
-- Name: topic; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE topic (
    managing_team_id bigint NOT NULL,
    title text NOT NULL,
    description text
);


ALTER TABLE topic OWNER TO postgres;

--
-- Name: topic_managing_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE topic_managing_team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE topic_managing_team_id_seq OWNER TO postgres;

--
-- Name: topic_managing_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE topic_managing_team_id_seq OWNED BY topic.managing_team_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    user_name text NOT NULL,
    date_joined date,
    password text,
    phone_nr character(10),
    cookie character(30),
    CONSTRAINT users_phone_nr_check CHECK (((length(phone_nr) = 10) AND (phone_nr ~ '^[0-9\+]+$'::text)))
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: employee team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee ALTER COLUMN team_id SET DEFAULT nextval('employee_team_id_seq'::regclass);


--
-- Name: employee employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee ALTER COLUMN employee_id SET DEFAULT nextval('employee_employee_id_seq'::regclass);


--
-- Name: is_moderated_by thread_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY is_moderated_by ALTER COLUMN thread_id SET DEFAULT nextval('is_moderated_by_thread_id_seq'::regclass);


--
-- Name: is_moderated_by employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY is_moderated_by ALTER COLUMN employee_id SET DEFAULT nextval('is_moderated_by_employee_id_seq'::regclass);


--
-- Name: message thread_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message ALTER COLUMN thread_id SET DEFAULT nextval('message_thread_id_seq'::regclass);


--
-- Name: message message_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message ALTER COLUMN message_id SET DEFAULT nextval('message_message_id_seq'::regclass);


--
-- Name: team team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY team ALTER COLUMN team_id SET DEFAULT nextval('team_team_id_seq'::regclass);


--
-- Name: team mgr_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY team ALTER COLUMN mgr_id SET DEFAULT nextval('team_mgr_id_seq'::regclass);


--
-- Name: thread thread_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY thread ALTER COLUMN thread_id SET DEFAULT nextval('thread_thread_id_seq'::regclass);


--
-- Name: topic managing_team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY topic ALTER COLUMN managing_team_id SET DEFAULT nextval('topic_managing_team_id_seq'::regclass);


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customer (user_name) FROM stdin;
customer1
customer2
customer3
customer4
customer1
customer2
customer3
customer4
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY employee (user_name, team_id, employee_id, name, address, salary, schedule) FROM stdin;
andrea	1	1	andrea	address 12	3000	busy
ryan	1	2	ryan	address 22	3000	schedule
anton	1	3	anton	address 14	3000	schedule
anton2	1	4	anton	address 16	3000	schedule
\.


--
-- Name: employee_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('employee_employee_id_seq', 1, false);


--
-- Name: employee_team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('employee_team_id_seq', 1, false);


--
-- Data for Name: is_moderated_by; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY is_moderated_by (thread_id, employee_id) FROM stdin;
1	1
2	2
3	3
4	4
1	1
2	2
3	3
4	4
\.


--
-- Name: is_moderated_by_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('is_moderated_by_employee_id_seq', 1, false);


--
-- Name: is_moderated_by_thread_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('is_moderated_by_thread_id_seq', 1, false);


--
-- Data for Name: manager; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY manager (employee_id) FROM stdin;
1
2
3
4
1
2
3
4
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY message (creator, thread_id, message_id, "time", content) FROM stdin;
andrea	1	1	2010-10-10	hello
andrea	1	2	2010-10-10	hello
andrea	1	3	2010-10-10	hello
andrea	1	4	2010-10-10	hello
\.


--
-- Name: message_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('message_message_id_seq', 1, false);


--
-- Name: message_thread_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('message_thread_id_seq', 1, false);


--
-- Data for Name: moderator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY moderator (employee_id) FROM stdin;
1
2
3
4
\.


--
-- Data for Name: specialist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY specialist (employee_id, speciality) FROM stdin;
1	sleeping
2	database
3	java
4	nose picking
1	sleeping
2	database
3	java
4	nose picking
\.


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY team (team_id, mgr_id, mgr_start_date) FROM stdin;
1	\N	2010-10-10
2	\N	2010-10-10
3	\N	2010-10-10
4	\N	2010-10-10
\.


--
-- Name: team_mgr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('team_mgr_id_seq', 1, false);


--
-- Name: team_team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('team_team_id_seq', 1, false);


--
-- Data for Name: thread; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY thread (thread_id, creator, topic_title, title, description, date_created) FROM stdin;
1	andrea	database	How to basic	hello	2010-10-10
2	andrea	database	How to basic	hello	2010-10-10
3	andrea	database	How to basic	hello	2010-10-10
4	andrea	database	How to basic	hello	2010-10-10
\.


--
-- Name: thread_thread_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('thread_thread_id_seq', 1, false);


--
-- Data for Name: topic; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY topic (managing_team_id, title, description) FROM stdin;
1	database	data
1	database2	data
1	database3	data
1	database4	data
\.


--
-- Name: topic_managing_team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('topic_managing_team_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (user_name, date_joined, password, phone_nr, cookie) FROM stdin;
andrea	2017-10-13	$2a$10$/Ub33GC9Ob3KKUCi.IB81u5N9wFz4ZoZndYCcsOZ6e4w4PbjxqoAa	0000000000	sxS4D3R4Jomh02suiyzzCVcfgTeitS
ryan	2017-10-16	$2a$10$3T3tgynbUATHUVgp1VfPDukXy0Td89ShQpzQdd.uC0ESgg1vx0CDm	0011001100	S3mKS9NiqUEbz8xqw0ETHBUOTNXPp5
anton	2017-10-17	$2a$10$UL9gLJ9/hLVkLK0beffqAegseW5vxE8I9FduDBUn4qIIqXUeTGijm	0000011111	EWoPnVIFQQWQtoW3owXvUA6mSkOBhb
anton2	2017-10-17	$2a$10$EI8oHCemuXaQg9gsziexaucEdSsorHnn17qiEyFAF.uOWodc3T1ly	1010100101	DxIuLNGYMEFSXNPyBGq2veDw29YrPQ
customer1	2017-10-13	$2a$10$/Ub33GC9Ob3KKUCi.IB81u5N9wFz4ZoZndYCcsOZ6e4w4PbjxqoAa	0000000000	sxS4D3R4Jomh02suiyzzCVcfgTeita
customer2	2017-10-16	$2a$10$3T3tgynbUATHUVgp1VfPDukXy0Td89ShQpzQdd.uC0ESgg1vx0CDm	0011001100	S3mKS9NiqUEbz8xqw0ETHBUOTNXPpa
customer3	2017-10-17	$2a$10$UL9gLJ9/hLVkLK0beffqAegseW5vxE8I9FduDBUn4qIIqXUeTGijm	0000011111	EWoPnVIFQQWQtoW3owXvUA6mSkOBha
customer4	2017-10-17	$2a$10$EI8oHCemuXaQg9gsziexaucEdSsorHnn17qiEyFAF.uOWodc3T1ly	1010100101	DxIuLNGYMEFSXNPyBGq2veDw29YrPa
\.


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_pkey PRIMARY KEY (message_id);


--
-- Name: moderator moderator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY moderator
    ADD CONSTRAINT moderator_pkey PRIMARY KEY (employee_id);


--
-- Name: team team_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY team
    ADD CONSTRAINT team_pkey PRIMARY KEY (team_id);


--
-- Name: thread thread_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY thread
    ADD CONSTRAINT thread_pkey PRIMARY KEY (thread_id);


--
-- Name: topic topic_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_pkey PRIMARY KEY (title);


--
-- Name: users users_cookie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_cookie_key UNIQUE (cookie);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_name);


--
-- Name: customer customer_user_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_user_name_fkey FOREIGN KEY (user_name) REFERENCES users(user_name);


--
-- Name: employee employee_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_team_id_fkey FOREIGN KEY (team_id) REFERENCES team(team_id);


--
-- Name: employee employee_user_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_user_name_fkey FOREIGN KEY (user_name) REFERENCES users(user_name);


--
-- Name: is_moderated_by is_moderated_by_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY is_moderated_by
    ADD CONSTRAINT is_moderated_by_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employee(employee_id);


--
-- Name: is_moderated_by is_moderated_by_thread_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY is_moderated_by
    ADD CONSTRAINT is_moderated_by_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES thread(thread_id);


--
-- Name: manager manager_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY manager
    ADD CONSTRAINT manager_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employee(employee_id);


--
-- Name: message message_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_creator_fkey FOREIGN KEY (creator) REFERENCES users(user_name);


--
-- Name: message message_thread_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES thread(thread_id);


--
-- Name: moderator moderator_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY moderator
    ADD CONSTRAINT moderator_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employee(employee_id);


--
-- Name: specialist specialist_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY specialist
    ADD CONSTRAINT specialist_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employee(employee_id);


--
-- Name: thread thread_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY thread
    ADD CONSTRAINT thread_creator_fkey FOREIGN KEY (creator) REFERENCES users(user_name);


--
-- Name: thread thread_topic_title_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY thread
    ADD CONSTRAINT thread_topic_title_fkey FOREIGN KEY (topic_title) REFERENCES topic(title);


--
-- Name: topic topic_managing_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_managing_team_id_fkey FOREIGN KEY (managing_team_id) REFERENCES team(team_id);


--
-- PostgreSQL database dump complete
--

