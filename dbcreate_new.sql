--
-- PostgreSQL database dump
--

-- Dumped from database version 13.12 (Debian 13.12-1.pgdg120+1)
-- Dumped by pg_dump version 13.12

-- Started on 2023-12-22 22:06:01 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;
-- Role: bccancer_admin
-- DROP ROLE IF EXISTS bccancer_admin;

CREATE ROLE bccancer_admin WITH
  LOGIN
  SUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'md5057afd3d29b2df7a535e890d5020d7bc';

GRANT bccancer_de_ro_gp, bccancer_de_rw_gp TO bccancer_admin WITH ADMIN OPTION;
-- Role: bccancer_de_ro_gp
-- DROP ROLE IF EXISTS bccancer_de_ro_gp;

CREATE ROLE bccancer_de_ro_gp WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

-- Role: bccancer_de_ro_user
-- DROP ROLE IF EXISTS bccancer_de_ro_user;

CREATE ROLE bccancer_de_ro_user WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'md5d6884f157991c05469e264f044af7ad0';

GRANT bccancer_de_ro_gp TO bccancer_de_ro_user;
-- Role: bccancer_de_rw_gp
-- DROP ROLE IF EXISTS bccancer_de_rw_gp;

CREATE ROLE bccancer_de_rw_gp WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
-- Role: bccancer_de_rw_user
-- DROP ROLE IF EXISTS bccancer_de_rw_user;

CREATE ROLE bccancer_de_rw_user WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'md5e997ebbf7de75f298ab810285e985996';

GRANT bccancer_de_rw_gp TO bccancer_de_rw_user;
-- Database: BCCancer_DE

-- DROP DATABASE IF EXISTS "BCCancer_DE";

CREATE DATABASE "BCCancer_DE"
    WITH
    OWNER = bccancer_admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

--
-- TOC entry 200 (class 1259 OID 17041)
-- Name: Preped_data; Type: TABLE; Schema: public; Owner: bccancer_de_rw_user
--

CREATE TABLE public."Preped_data" (
    batch_id bigint,
    msgid bigint,
    gross text,
    addendum text,
    diagnosis text,
    diagnosis_comment text,
    micro text,
    filtered_message text,
    part_of_report text
);


ALTER TABLE public."Preped_data" OWNER TO bccancer_de_rw_user;

--
-- TOC entry 201 (class 1259 OID 17047)
-- Name: Preped_table; Type: TABLE; Schema: public; Owner: bccancer_de_rw_user
--

CREATE TABLE public."Preped_table" (
    batch_id bigint,
    msgid bigint,
    gross text,
    addendum text,
    diagnosis text,
    diagnosis_comment text,
    micro text,
    filtered_message text,
    part_of_report text
);


ALTER TABLE public."Preped_table" OWNER TO bccancer_de_rw_user;

--
-- TOC entry 202 (class 1259 OID 17053)
-- Name: batch; Type: TABLE; Schema: public; Owner: airflow
--

CREATE TABLE public.batch (
    batch_id integer NOT NULL,
    pipeline_name character varying(255),
    date_to date,
    date_from date,
    run_date date DEFAULT CURRENT_DATE,
    comment text
);


ALTER TABLE public.batch OWNER TO bccancer_de_rw_user;

--
-- TOC entry 203 (class 1259 OID 17060)
-- Name: batch_batch_id_seq; Type: SEQUENCE; Schema: public; Owner: airflow
--

CREATE SEQUENCE public.batch_batch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.batch_batch_id_seq OWNER TO bccancer_de_rw_user;

--
-- TOC entry 3085 (class 0 OID 0)
-- Dependencies: 203
-- Name: batch_batch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: airflow
--

ALTER SEQUENCE public.batch_batch_id_seq OWNED BY public.batch.batch_id;


--
-- TOC entry 204 (class 1259 OID 17062)
-- Name: batch_test; Type: TABLE; Schema: public; Owner: bccancer_admin
--

CREATE TABLE public.batch_test (
    batch_id integer NOT NULL,
    pipeline_name character varying(255),
    date_to date,
    date_from date,
    run_date date DEFAULT CURRENT_DATE,
    comment text
);


ALTER TABLE public.batch_test OWNER TO bccancer_de_rw_user;

--
-- TOC entry 205 (class 1259 OID 17069)
-- Name: batch_test_batch_id_seq; Type: SEQUENCE; Schema: public; Owner: bccancer_admin
--

CREATE SEQUENCE public.batch_test_batch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.batch_test_batch_id_seq OWNER TO bccancer_admin;

--
-- TOC entry 3088 (class 0 OID 0)
-- Dependencies: 205
-- Name: batch_test_batch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bccancer_admin
--

ALTER SEQUENCE public.batch_test_batch_id_seq OWNED BY public.batch_test.batch_id;


--
-- TOC entry 206 (class 1259 OID 17071)
-- Name: cleaned_data; Type: TABLE; Schema: public; Owner: bccancer_de_rw_user
--

CREATE TABLE public.cleaned_data (
    batch_id integer NOT NULL,
    msgid integer NOT NULL,
    msg text
);


ALTER TABLE public.cleaned_data OWNER TO bccancer_de_rw_user;

--
-- TOC entry 207 (class 1259 OID 17077)
-- Name: labels; Type: TABLE; Schema: public; Owner: bccancer_de_rw_user
--

CREATE TABLE public.labels (
    model_id integer NOT NULL,
    label integer NOT NULL,
    label_name character varying(255)
);


ALTER TABLE public.labels OWNER TO bccancer_de_rw_user;

--
-- TOC entry 208 (class 1259 OID 17080)
-- Name: model; Type: TABLE; Schema: public; Owner: bccancer_de_rw_user
--

CREATE TABLE public.model (
    model_id integer NOT NULL,
    model_name character varying(255) NOT NULL,
    model_version character varying(50) NOT NULL,
    model_location character varying(255) NOT NULL,
    submited_on date DEFAULT CURRENT_DATE
);


ALTER TABLE public.model OWNER TO bccancer_de_rw_user;

--
-- TOC entry 209 (class 1259 OID 17087)
-- Name: model_model_id_seq; Type: SEQUENCE; Schema: public; Owner: bccancer_de_rw_user
--

CREATE SEQUENCE public.model_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.model_model_id_seq OWNER TO bccancer_de_rw_user;

--
-- TOC entry 3093 (class 0 OID 0)
-- Dependencies: 209
-- Name: model_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bccancer_de_rw_user
--

ALTER SEQUENCE public.model_model_id_seq OWNED BY public.model.model_id;


--
-- TOC entry 210 (class 1259 OID 17089)
-- Name: prediction_table; Type: TABLE; Schema: public; Owner: bccancer_de_rw_user
--

CREATE TABLE public.prediction_table (
    batch_id integer NOT NULL,
    msgid integer NOT NULL,
    predicted_label integer,
    model_score numeric(10,2),
    model_id integer
);


ALTER TABLE public.prediction_table OWNER TO bccancer_de_rw_user;

--
-- TOC entry 211 (class 1259 OID 17092)
-- Name: preped_data; Type: TABLE; Schema: public; Owner: bccancer_de_rw_user
--

CREATE TABLE public.preped_data (
    batch_id integer NOT NULL,
    msgid integer NOT NULL,
    diagnosis text,
    diagnosis_comment text,
    addendum text,
    micro text,
    gross text,
    filtered_message text,
    part_of_report text
);


ALTER TABLE public.preped_data OWNER TO bccancer_de_rw_user;

--
-- TOC entry 212 (class 1259 OID 17098)
-- Name: section_regex; Type: TABLE; Schema: public; Owner: bccancer_de_rw_user
--

CREATE TABLE public.section_regex (
    parent_category character varying(255),
    nha character varying(255),
    fha character varying(255),
    fha2 character varying(255),
    iha character varying(255),
    vcha1 character varying(255),
    vcha2 character varying(255),
    model_id integer
);


ALTER TABLE public.section_regex OWNER TO bccancer_de_rw_user;

--
-- TOC entry 2925 (class 2604 OID 17104)
-- Name: batch batch_id; Type: DEFAULT; Schema: public; Owner: bccancer_de_rw_user
--

ALTER TABLE ONLY public.batch ALTER COLUMN batch_id SET DEFAULT nextval('public.batch_batch_id_seq'::regclass);


--
-- TOC entry 2927 (class 2604 OID 17105)
-- Name: batch_test batch_id; Type: DEFAULT; Schema: public; Owner: bccancer_admin
--

ALTER TABLE ONLY public.batch_test ALTER COLUMN batch_id SET DEFAULT nextval('public.batch_test_batch_id_seq'::regclass);


--
-- TOC entry 2929 (class 2604 OID 17106)
-- Name: model model_id; Type: DEFAULT; Schema: public; Owner: bccancer_de_rw_user
--

ALTER TABLE ONLY public.model ALTER COLUMN model_id SET DEFAULT nextval('public.model_model_id_seq'::regclass);


--
-- TOC entry 2931 (class 2606 OID 17391)
-- Name: batch batch_pkey; Type: CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.batch
    ADD CONSTRAINT batch_pkey PRIMARY KEY (batch_id);


--
-- TOC entry 2933 (class 2606 OID 17393)
-- Name: batch_test batch_test_pkey; Type: CONSTRAINT; Schema: public; Owner: bccancer_admin
--

ALTER TABLE ONLY public.batch_test
    ADD CONSTRAINT batch_test_pkey PRIMARY KEY (batch_id);


--
-- TOC entry 2935 (class 2606 OID 17395)
-- Name: cleaned_data cleaned_data_pkey; Type: CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.cleaned_data
    ADD CONSTRAINT cleaned_data_pkey PRIMARY KEY (batch_id, msgid);


--
-- TOC entry 2937 (class 2606 OID 17397)
-- Name: labels labels_pkey; Type: CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.labels
    ADD CONSTRAINT labels_pkey PRIMARY KEY (model_id, label);


--
-- TOC entry 2939 (class 2606 OID 17399)
-- Name: model model_pkey; Type: CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.model
    ADD CONSTRAINT model_pkey PRIMARY KEY (model_id);


--
-- TOC entry 2941 (class 2606 OID 17401)
-- Name: prediction_table prediction_table_pkey; Type: CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.prediction_table
    ADD CONSTRAINT prediction_table_pkey PRIMARY KEY (batch_id, msgid);


--
-- TOC entry 2943 (class 2606 OID 17403)
-- Name: preped_data preped_data_pkey; Type: CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.preped_data
    ADD CONSTRAINT preped_data_pkey PRIMARY KEY (batch_id, msgid);


--
-- TOC entry 2944 (class 2606 OID 17404)
-- Name: labels labels_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.labels
    ADD CONSTRAINT labels_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.model(model_id);


--
-- TOC entry 2945 (class 2606 OID 17409)
-- Name: prediction_table prediction_table_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.prediction_table
    ADD CONSTRAINT prediction_table_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.batch(batch_id);


--
-- TOC entry 2946 (class 2606 OID 17414)
-- Name: prediction_table prediction_table_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.prediction_table
    ADD CONSTRAINT prediction_table_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.model(model_id);


--
-- TOC entry 2947 (class 2606 OID 17419)
-- Name: preped_data preped_data_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.preped_data
    ADD CONSTRAINT preped_data_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.batch(batch_id);


--
-- TOC entry 2948 (class 2606 OID 17424)
-- Name: section_regex section_regex_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: airflow
--

ALTER TABLE ONLY public.section_regex
    ADD CONSTRAINT section_regex_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.model(model_id);


--
-- TOC entry 3084 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE batch; Type: ACL; Schema: public; Owner: airflow
--

GRANT ALL ON TABLE public.batch TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.batch TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.batch TO bccancer_de_ro_gp;


--
-- TOC entry 3086 (class 0 OID 0)
-- Dependencies: 203
-- Name: SEQUENCE batch_batch_id_seq; Type: ACL; Schema: public; Owner: airflow
--

GRANT USAGE ON SEQUENCE public.batch_batch_id_seq TO bccancer_de_rw_gp;


--
-- TOC entry 3087 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE batch_test; Type: ACL; Schema: public; Owner: bccancer_admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.batch_test TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.batch_test TO bccancer_de_ro_gp;


--
-- TOC entry 3089 (class 0 OID 0)
-- Dependencies: 205
-- Name: SEQUENCE batch_test_batch_id_seq; Type: ACL; Schema: public; Owner: bccancer_admin
--

GRANT USAGE ON SEQUENCE public.batch_test_batch_id_seq TO bccancer_de_rw_gp;


--
-- TOC entry 3090 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE cleaned_data; Type: ACL; Schema: public; Owner: airflow
--

GRANT ALL ON TABLE public.cleaned_data TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.cleaned_data TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.cleaned_data TO bccancer_de_ro_gp;


--
-- TOC entry 3091 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE labels; Type: ACL; Schema: public; Owner: airflow
--

GRANT ALL ON TABLE public.labels TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.labels TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.labels TO bccancer_de_ro_gp;


--
-- TOC entry 3092 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE model; Type: ACL; Schema: public; Owner: airflow
--

GRANT ALL ON TABLE public.model TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.model TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.model TO bccancer_de_ro_gp;


--
-- TOC entry 3094 (class 0 OID 0)
-- Dependencies: 209
-- Name: SEQUENCE model_model_id_seq; Type: ACL; Schema: public; Owner: airflow
--

GRANT USAGE ON SEQUENCE public.model_model_id_seq TO bccancer_de_rw_gp;


--
-- TOC entry 3095 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE prediction_table; Type: ACL; Schema: public; Owner: airflow
--

GRANT ALL ON TABLE public.prediction_table TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.prediction_table TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.prediction_table TO bccancer_de_ro_gp;


--
-- TOC entry 3096 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE preped_data; Type: ACL; Schema: public; Owner: airflow
--

GRANT ALL ON TABLE public.preped_data TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.preped_data TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.preped_data TO bccancer_de_ro_gp;


--
-- TOC entry 3097 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE section_regex; Type: ACL; Schema: public; Owner: airflow
--

GRANT ALL ON TABLE public.section_regex TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.section_regex TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.section_regex TO bccancer_de_ro_gp;


-- Completed on 2023-12-22 22:06:01 UTC

--
-- PostgreSQL database dump complete
--

