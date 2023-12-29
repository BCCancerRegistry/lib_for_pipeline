CREATE TABLE public.batch (
    batch_id integer NOT NULL,
    pipeline_name character varying(255),
    date_to date,
    date_from date,
    run_date date DEFAULT CURRENT_DATE,
    comment text
);


ALTER TABLE public.batch OWNER TO airflow;


CREATE SEQUENCE public.batch_batch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.batch_batch_id_seq OWNER TO airflow;


ALTER SEQUENCE public.batch_batch_id_seq OWNED BY public.batch.batch_id;



CREATE TABLE public.cleaned_data (
    batch_id integer NOT NULL,
    msgid integer NOT NULL,
    msg text
);


ALTER TABLE public.cleaned_data OWNER TO airflow;


CREATE TABLE public.labels (
    model_id integer NOT NULL,
    label integer NOT NULL,
    label_name character varying(255)
);


ALTER TABLE public.labels OWNER TO airflow;


CREATE TABLE public.model (
    model_id integer NOT NULL,
    model_name character varying(255) NOT NULL,
    model_version character varying(50) NOT NULL,
    model_location character varying(255) NOT NULL,
    submited_on date DEFAULT CURRENT_DATE
);


ALTER TABLE public.model OWNER TO airflow;


CREATE SEQUENCE public.model_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.model_model_id_seq OWNER TO airflow;

ALTER SEQUENCE public.model_model_id_seq OWNED BY public.model.model_id;


CREATE TABLE public.prediction_table (
    batch_id integer NOT NULL,
    msgid integer NOT NULL,
    predicted_label integer,
    model_score numeric(10,2),
    model_id integer
);


ALTER TABLE public.prediction_table OWNER TO airflow;


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


ALTER TABLE public.preped_data OWNER TO airflow;


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


ALTER TABLE public.section_regex OWNER TO airflow;


ALTER TABLE ONLY public.batch ALTER COLUMN batch_id SET DEFAULT nextval('public.batch_batch_id_seq'::regclass);


ALTER TABLE ONLY public.model ALTER COLUMN model_id SET DEFAULT nextval('public.model_model_id_seq'::regclass);


ALTER TABLE ONLY public.batch
    ADD CONSTRAINT batch_pkey PRIMARY KEY (batch_id);




ALTER TABLE ONLY public.cleaned_data
    ADD CONSTRAINT cleaned_data_pkey PRIMARY KEY (batch_id, msgid);


ALTER TABLE ONLY public.labels
    ADD CONSTRAINT labels_pkey PRIMARY KEY (model_id, label);


ALTER TABLE ONLY public.model
    ADD CONSTRAINT model_pkey PRIMARY KEY (model_id);


ALTER TABLE ONLY public.prediction_table
    ADD CONSTRAINT prediction_table_pkey PRIMARY KEY (batch_id, msgid);


ALTER TABLE ONLY public.preped_data
    ADD CONSTRAINT preped_data_pkey PRIMARY KEY (batch_id, msgid);

ALTER TABLE ONLY public.cleaned_data
    ADD CONSTRAINT clean_data_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.batch(batch_id);


ALTER TABLE ONLY public.labels
    ADD CONSTRAINT labels_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.model(model_id);


ALTER TABLE ONLY public.prediction_table
    ADD CONSTRAINT prediction_table_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.batch(batch_id);



ALTER TABLE ONLY public.prediction_table
    ADD CONSTRAINT prediction_table_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.model(model_id);

ALTER TABLE ONLY public.preped_data
    ADD CONSTRAINT preped_data_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.batch(batch_id);

ALTER TABLE ONLY public.section_regex
    ADD CONSTRAINT section_regex_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.model(model_id);


GRANT ALL ON TABLE public.batch TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.batch TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.batch TO bccancer_de_ro_gp;


GRANT USAGE ON SEQUENCE public.batch_batch_id_seq TO bccancer_de_rw_gp;



GRANT ALL ON TABLE public.cleaned_data TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.cleaned_data TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.cleaned_data TO bccancer_de_ro_gp;


GRANT ALL ON TABLE public.labels TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.labels TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.labels TO bccancer_de_ro_gp;




GRANT ALL ON TABLE public.model TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.model TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.model TO bccancer_de_ro_gp;




GRANT USAGE ON SEQUENCE public.model_model_id_seq TO bccancer_de_rw_gp;



GRANT ALL ON TABLE public.prediction_table TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.prediction_table TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.prediction_table TO bccancer_de_ro_gp;




GRANT ALL ON TABLE public.preped_data TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.preped_data TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.preped_data TO bccancer_de_ro_gp;




GRANT ALL ON TABLE public.section_regex TO bccancer_admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.section_regex TO bccancer_de_rw_gp;
GRANT SELECT ON TABLE public.section_regex TO bccancer_de_ro_gp;


