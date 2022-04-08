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
    updated_at timestamp(6) without time zone NOT NULL,
    cc_code character varying
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
    address_transaction meduza.citext NOT NULL,
    risk_confidence numeric,
    risk_level integer,
    raw_response jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cc_code character varying,
    type character varying NOT NULL
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
-- Name: analyzed_users; Type: TABLE; Schema: meduza; Owner: -
--

CREATE TABLE meduza.analyzed_users (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    risk_level_1_count integer DEFAULT 0 NOT NULL,
    risk_level_2_count integer DEFAULT 0 NOT NULL,
    risk_level_3_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: analyzed_users_id_seq; Type: SEQUENCE; Schema: meduza; Owner: -
--

CREATE SEQUENCE meduza.analyzed_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: analyzed_users_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: -
--

ALTER SEQUENCE meduza.analyzed_users_id_seq OWNED BY meduza.analyzed_users.id;


--
-- Name: pending_analyses; Type: TABLE; Schema: meduza; Owner: -
--

CREATE TABLE meduza.pending_analyses (
    id bigint NOT NULL,
    address_transaction character varying NOT NULL,
    state character varying DEFAULT 'pending'::character varying NOT NULL,
    cc_code character varying NOT NULL,
    reply_to character varying,
    correlation_id character varying,
    source character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    type character varying,
    analysis_result_id bigint,
    meta jsonb,
    replied_at timestamp without time zone
);


--
-- Name: pending_analyses_id_seq; Type: SEQUENCE; Schema: meduza; Owner: -
--

CREATE SEQUENCE meduza.pending_analyses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pending_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: -
--

ALTER SEQUENCE meduza.pending_analyses_id_seq OWNED BY meduza.pending_analyses.id;


--
-- Name: transaction_analyses; Type: TABLE; Schema: meduza; Owner: -
--

CREATE TABLE meduza.transaction_analyses (
    id bigint NOT NULL,
    txid meduza.citext NOT NULL,
    cc_code character varying NOT NULL,
    risk_level integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    analysis_result_id bigint NOT NULL,
    risk_confidence numeric NOT NULL,
    meta jsonb DEFAULT '{}'::jsonb NOT NULL,
    direction character varying,
    pending_analyses_id bigint,
    analyzed_user_id bigint
);


--
-- Name: transaction_analyses_id_seq; Type: SEQUENCE; Schema: meduza; Owner: -
--

CREATE SEQUENCE meduza.transaction_analyses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: -
--

ALTER SEQUENCE meduza.transaction_analyses_id_seq OWNED BY meduza.transaction_analyses.id;


--
-- Name: transaction_sources; Type: TABLE; Schema: meduza; Owner: -
--

CREATE TABLE meduza.transaction_sources (
    id bigint NOT NULL,
    last_processed_blockchain_tx_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cc_code character varying NOT NULL
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
-- Name: analyzed_users id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.analyzed_users ALTER COLUMN id SET DEFAULT nextval('meduza.analyzed_users_id_seq'::regclass);


--
-- Name: pending_analyses id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.pending_analyses ALTER COLUMN id SET DEFAULT nextval('meduza.pending_analyses_id_seq'::regclass);


--
-- Name: transaction_analyses id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.transaction_analyses ALTER COLUMN id SET DEFAULT nextval('meduza.transaction_analyses_id_seq'::regclass);


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
-- Name: analyzed_users analyzed_users_pkey; Type: CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.analyzed_users
    ADD CONSTRAINT analyzed_users_pkey PRIMARY KEY (id);


--
-- Name: pending_analyses pending_analyses_pkey; Type: CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.pending_analyses
    ADD CONSTRAINT pending_analyses_pkey PRIMARY KEY (id);


--
-- Name: transaction_analyses transaction_analyses_pkey; Type: CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.transaction_analyses
    ADD CONSTRAINT transaction_analyses_pkey PRIMARY KEY (id);


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
-- Name: index_address_analyses_on_address_and_cc_code; Type: INDEX; Schema: meduza; Owner: -
--

CREATE UNIQUE INDEX index_address_analyses_on_address_and_cc_code ON meduza.address_analyses USING btree (address, cc_code);


--
-- Name: index_address_analyses_on_analysis_result_id; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_address_analyses_on_analysis_result_id ON meduza.address_analyses USING btree (analysis_result_id);


--
-- Name: index_analysis_results_on_address_transaction; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_analysis_results_on_address_transaction ON meduza.analysis_results USING btree (address_transaction);


--
-- Name: index_analyzed_users_on_risk_level_1_count; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_analyzed_users_on_risk_level_1_count ON meduza.analyzed_users USING btree (risk_level_1_count);


--
-- Name: index_analyzed_users_on_risk_level_2_count; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_analyzed_users_on_risk_level_2_count ON meduza.analyzed_users USING btree (risk_level_2_count);


--
-- Name: index_analyzed_users_on_risk_level_3_count; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_analyzed_users_on_risk_level_3_count ON meduza.analyzed_users USING btree (risk_level_3_count);


--
-- Name: index_analyzed_users_on_user_id_uniq; Type: INDEX; Schema: meduza; Owner: -
--

CREATE UNIQUE INDEX index_analyzed_users_on_user_id_uniq ON meduza.analyzed_users USING btree (user_id);


--
-- Name: index_pending_analyses_on_analysis_result_id; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_pending_analyses_on_analysis_result_id ON meduza.pending_analyses USING btree (analysis_result_id);


--
-- Name: index_transaction_analyses_on_analysis_result_id; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_transaction_analyses_on_analysis_result_id ON meduza.transaction_analyses USING btree (analysis_result_id);


--
-- Name: index_transaction_analyses_on_analyzed_user_id; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_transaction_analyses_on_analyzed_user_id ON meduza.transaction_analyses USING btree (analyzed_user_id);


--
-- Name: index_transaction_analyses_on_cc_code_and_txid; Type: INDEX; Schema: meduza; Owner: -
--

CREATE UNIQUE INDEX index_transaction_analyses_on_cc_code_and_txid ON meduza.transaction_analyses USING btree (cc_code, txid);


--
-- Name: index_transaction_analyses_on_pending_analyses_id; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_transaction_analyses_on_pending_analyses_id ON meduza.transaction_analyses USING btree (pending_analyses_id);


--
-- Name: pending_analysis_adress_transaction_idx; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX pending_analysis_adress_transaction_idx ON meduza.pending_analyses USING btree (source, state, address_transaction);


--
-- Name: pending_analyses fk_rails_27fc4b529c; Type: FK CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.pending_analyses
    ADD CONSTRAINT fk_rails_27fc4b529c FOREIGN KEY (analysis_result_id) REFERENCES meduza.analysis_results(id);


--
-- Name: address_analyses fk_rails_4d26b9d298; Type: FK CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.address_analyses
    ADD CONSTRAINT fk_rails_4d26b9d298 FOREIGN KEY (analysis_result_id) REFERENCES meduza.analysis_results(id);


--
-- Name: transaction_analyses fk_rails_760f842201; Type: FK CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.transaction_analyses
    ADD CONSTRAINT fk_rails_760f842201 FOREIGN KEY (analyzed_user_id) REFERENCES meduza.analyzed_users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO meduza,public;

INSERT INTO "schema_migrations" (version) VALUES
('20211118152519'),
('20211118160230'),
('20211119063003'),
('20211119154629'),
('20211124083829'),
('20211124084333'),
('20211124085144'),
('20211126081238'),
('20211129090122'),
('20211129175044'),
('20211129181253'),
('20211129191823'),
('20211129194459'),
('20211130103912'),
('20220225101544'),
('20220225113244'),
('20220225113612'),
('20220225114014'),
('20220225134028'),
('20220225135745'),
('20220225151910'),
('20220225153241'),
('20220228071220'),
('20220228142051'),
('20220228142958'),
('20220302134255'),
('20220303143427'),
('20220318181931'),
('20220329142334'),
('20220329142455'),
('20220331151440'),
('20220407121620'),
('20220408133353'),
('20220408151446');


