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

--
-- Name: meduza; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA meduza;


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: address_analyses; Type: TABLE; Schema: meduza; Owner: -
--

CREATE TABLE meduza.address_analyses (
    id bigint NOT NULL,
    address meduza.citext NOT NULL,
    risk_level integer NOT NULL,
    risk_confidence numeric NOT NULL,
    analysis_result_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: address_analyses_id_seq; Type: SEQUENCE; Schema: meduza; Owner: -
--

CREATE SEQUENCE meduza.address_analyses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: address_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: -
--

ALTER SEQUENCE meduza.address_analyses_id_seq OWNED BY meduza.address_analyses.id;


--
-- Name: analysis_results; Type: TABLE; Schema: meduza; Owner: -
--

CREATE TABLE meduza.analysis_results (
    id bigint NOT NULL,
    address meduza.citext NOT NULL,
    risk_confidence numeric NOT NULL,
    risk_level integer NOT NULL,
    raw_response jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: analysis_results_id_seq; Type: SEQUENCE; Schema: meduza; Owner: -
--

CREATE SEQUENCE meduza.analysis_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: analysis_results_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: -
--

ALTER SEQUENCE meduza.analysis_results_id_seq OWNED BY meduza.analysis_results.id;


--
-- Name: transaction_sources; Type: TABLE; Schema: meduza; Owner: -
--

CREATE TABLE meduza.transaction_sources (
    id bigint NOT NULL,
    name character varying,
    last_processed_blockchain_tx_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: transaction_sources_id_seq; Type: SEQUENCE; Schema: meduza; Owner: -
--

CREATE SEQUENCE meduza.transaction_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: -
--

ALTER SEQUENCE meduza.transaction_sources_id_seq OWNED BY meduza.transaction_sources.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: address_analyses id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.address_analyses ALTER COLUMN id SET DEFAULT nextval('meduza.address_analyses_id_seq'::regclass);


--
-- Name: analysis_results id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.analysis_results ALTER COLUMN id SET DEFAULT nextval('meduza.analysis_results_id_seq'::regclass);


--
-- Name: transaction_sources id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.transaction_sources ALTER COLUMN id SET DEFAULT nextval('meduza.transaction_sources_id_seq'::regclass);


--
-- Name: address_analyses address_analyses_pkey; Type: CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.address_analyses
    ADD CONSTRAINT address_analyses_pkey PRIMARY KEY (id);


--
-- Name: analysis_results analysis_results_pkey; Type: CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.analysis_results
    ADD CONSTRAINT analysis_results_pkey PRIMARY KEY (id);


--
-- Name: transaction_sources transaction_sources_pkey; Type: CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.transaction_sources
    ADD CONSTRAINT transaction_sources_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_address_analyses_on_address; Type: INDEX; Schema: meduza; Owner: -
--

CREATE UNIQUE INDEX index_address_analyses_on_address ON meduza.address_analyses USING btree (address);


--
-- Name: index_address_analyses_on_analysis_result_id; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_address_analyses_on_analysis_result_id ON meduza.address_analyses USING btree (analysis_result_id);


--
-- Name: index_analysis_results_on_address; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_analysis_results_on_address ON meduza.analysis_results USING btree (address);


--
-- Name: address_analyses fk_rails_4d26b9d298; Type: FK CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.address_analyses
    ADD CONSTRAINT fk_rails_4d26b9d298 FOREIGN KEY (analysis_result_id) REFERENCES meduza.analysis_results(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO meduza,public;

INSERT INTO "schema_migrations" (version) VALUES
('20211118152519'),
('20211118160230'),
('20211119063003');


