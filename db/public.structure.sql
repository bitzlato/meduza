CREATE DOMAIN public.cryptocurrency_amount AS numeric(60,8)
	CONSTRAINT cryptocurrency_amount_check CHECK ((VALUE <> 'NaN'::numeric));

CREATE DOMAIN public.cryptocurrency_code AS character varying(4)
	CONSTRAINT cryptocurrency_code_check1 CHECK ((length((VALUE)::text) >= 3));

CREATE TYPE public.withdrawal_status AS ENUM (
    'pending',
    'processed',
    'cancelled',
    'in_progress',
    'failed',
    'cancelled_by_admin',
    'aml'
);

CREATE TABLE public."user" (
    id integer NOT NULL,
    subject character varying(510) NOT NULL,
    nickname character varying(510),
    email_verified boolean NOT NULL,
    chat_enabled boolean NOT NULL,
    email_auth_enabled boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    telegram_id character varying(256),
    auth0_id character varying,
    ref_parent_user_id integer,
    referrer integer,
    country character varying,
    real_email text,
    authority_can_make_deal boolean DEFAULT true NOT NULL,
    authority_can_make_order boolean DEFAULT true NOT NULL,
    authority_can_make_voucher boolean DEFAULT true NOT NULL,
    authority_can_make_withdrawal boolean DEFAULT true NOT NULL,
    authority_is_admin boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    password_reset_at timestamp without time zone,
    sys_code character varying(63),
    meta jsonb,
    CONSTRAINT user_check CHECK (((sys_code IS NULL) OR ((telegram_id IS NULL) AND (real_email IS NULL) AND (nickname IS NULL)))),
    CONSTRAINT user_sys_code_check CHECK ((length((sys_code)::text) > 0)),
    CONSTRAINT users_check CHECK ((deleted_at > created_at))
);

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);

CREATE TABLE public.wallet (
    id integer NOT NULL,
    user_id integer NOT NULL,
    balance public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    hold_balance public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    debt public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    CONSTRAINT balance_check CHECK (((balance)::numeric >= (0)::numeric)),
    CONSTRAINT debt_check CHECK (((debt)::numeric >= (0)::numeric)),
    CONSTRAINT hold_check CHECK (((hold_balance)::numeric >= (0)::numeric))
);

CREATE SEQUENCE public.wallets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ONLY public.wallet ALTER COLUMN id SET DEFAULT nextval('public.wallets_id_seq'::regclass);

CREATE TABLE public.withdrawal (
    id integer NOT NULL,
    user_id integer NOT NULL,
    wallet_id integer NOT NULL,
    blockchain_tx_id integer,
    address character varying(68) NOT NULL,
    amount public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    fee public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    status public.withdrawal_status NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    comment text,
    real_pay_fee public.cryptocurrency_amount,
    cc_code public.cryptocurrency_code NOT NULL,
    meduza_status jsonb,
    CONSTRAINT check_amount CHECK (((amount)::numeric > (0)::numeric)),
    CONSTRAINT payments_fee_check CHECK (((fee)::numeric >= (0)::numeric)),
    CONSTRAINT withdrawal_check CHECK (((blockchain_tx_id IS NOT NULL) OR (status = ANY (ARRAY['aml'::public.withdrawal_status, 'pending'::public.withdrawal_status, 'in_progress'::public.withdrawal_status, 'cancelled_by_admin'::public.withdrawal_status, 'failed'::public.withdrawal_status])))),
    CONSTRAINT withdrawal_real_pay_fee_check CHECK (((real_pay_fee)::numeric >= (0)::numeric))
)
WITH (fillfactor='90', autovacuum_enabled='on', autovacuum_vacuum_cost_delay='20');

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ONLY public.withdrawal ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);
