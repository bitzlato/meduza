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


--
-- Name: ban_action; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ban_action AS ENUM (
    'ban',
    'unban'
);


--
-- Name: blockchain_tx_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.blockchain_tx_status AS ENUM (
    'initial',
    'pending',
    'confirmed'
);


--
-- Name: cryptocurrency_amount; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.cryptocurrency_amount AS numeric(60,8)
	CONSTRAINT cryptocurrency_amount_check CHECK ((VALUE <> 'NaN'::numeric));


--
-- Name: cryptocurrency_code; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.cryptocurrency_code AS character varying(4)
	CONSTRAINT cryptocurrency_code_check1 CHECK ((length((VALUE)::text) >= 3));


--
-- Name: deposit_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.deposit_status AS ENUM (
    'pending',
    'aml-check',
    'aml-seizure',
    'dust-seizure',
    'success'
);


--
-- Name: entity; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.entity AS ENUM (
    'user',
    'wallet',
    'profile',
    'order',
    'trade',
    'advert'
);


--
-- Name: event_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.event_type AS ENUM (
    'created',
    'updated',
    'deleted'
);


--
-- Name: kyc_provider; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.kyc_provider AS ENUM (
    'LEGACY',
    'SUMSUB'
);


--
-- Name: kyc_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.kyc_status AS ENUM (
    'NONE',
    'APPROVED',
    'REJECTED',
    'BAN'
);


--
-- Name: oauth_aud; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.oauth_aud AS ENUM (
    'usr',
    'mob'
);


--
-- Name: wallet_address_change_reason; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.wallet_address_change_reason AS ENUM (
    'merge',
    'admin_reset',
    'migration'
);


--
-- Name: withdrawal_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.withdrawal_status AS ENUM (
    'pending',
    'processed',
    'cancelled',
    'in_progress',
    'failed',
    'cancelled_by_admin'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: wallet; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallet (
    id integer NOT NULL,
    user_id integer NOT NULL,
    address character varying(800),
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


--
-- Name: add_fake_balance(integer, integer, bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_fake_balance(userid integer, cc integer, amount bigint) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  wallet RECORD;
BEGIN

  SELECT * INTO wallet
  FROM public.wallets w
  WHERE w.user_id = userid AND w.currency = cc;

  RAISE NOTICE 'new_balance = %', wallet.balance + amount;

  UPDATE public.wallets w
  SET balance = balance + amount
  WHERE w.id = wallet.id;

  INSERT into public.transactions (user_id, wallet_id, currency, address, amount, category, txid, balance_loaded)
  VALUES (userid, wallet.id, cc, '', amount, 2, '', true);

  UPDATE p2p.cryptocurrency_settings
  SET cold_wallet_audit_adjust = cold_wallet_audit_adjust + amount::numeric / 100000000
  WHERE code = (SELECT code FROM public.cryptocurrency WHERE int_code=cc);
END;
$$;


--
-- Name: array_sort_unique(anyarray); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.array_sort_unique(anyarray) RETURNS anyarray
    LANGUAGE sql
    AS $_$
  SELECT ARRAY(
    SELECT DISTINCT $1[s.i]
    FROM generate_series(array_lower($1,1), array_upper($1,1)) AS s(i)
    ORDER BY 1
  );
$_$;


--
-- Name: base58_encode(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.base58_encode(num integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$

DECLARE
  alphabet   VARCHAR(255);
  base_count INT DEFAULT 0;
  encoded    VARCHAR(255);
  divisor    DECIMAL(10, 4);
  mod        INT DEFAULT 0;

BEGIN
  alphabet := '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  base_count := char_length(alphabet);
  encoded := '';

  WHILE num >= base_count LOOP
    divisor := num / base_count;
    mod := (num - (base_count * trunc(divisor, 0)));
    encoded := concat(substring(alphabet FROM mod + 1 FOR 1), encoded);
    num := trunc(divisor, 0);
  END LOOP;

  encoded = concat(substring(alphabet FROM num + 1 FOR 1), encoded);

  RETURN (encoded);

END; $$;


--
-- Name: create_partition_for_date(date, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_partition_for_date(p_date date, p_table character varying) RETURNS void
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $_$
declare
    declare
    v_partition_name text := p_table || '$' || to_char(p_date, 'YYYYMMDD');
begin
    -- If partition does not exist...:
    if to_regclass(v_partition_name) is null then
        -- Generate a new table that acts as a partition:
        execute format('create table %I partition of %I for values in (%L)', v_partition_name, p_table, p_date);
        execute format('alter table %I set (autovacuum_enabled=false, fillfactor = 100)', v_partition_name);
    end if;
end;
$_$;


--
-- Name: drop_partition_for_date(date, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.drop_partition_for_date(p_date date, p_table character varying) RETURNS void
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $_$
declare
    declare
    v_partition_name text := p_table || '$' || to_char(p_date, 'YYYYMMDD');
begin
    -- If partition exists...:
    if to_regclass(v_partition_name) is not null then
        -- Drop old partition
        execute format('drop table %I', v_partition_name);
    end if;
end;
$_$;


--
-- Name: first_agg(anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.first_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT $1;
$_$;


--
-- Name: get_partitions_for_date(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_partitions_for_date(p_table character varying) RETURNS TABLE(partition_name text, for_date date)
    LANGUAGE sql
    SET search_path TO 'public'
    AS $$
select partition_name::text, SUBSTRING(expr, 'FOR VALUES IN \((.*)\)')::date for_date
from (
         select pt.relname as                              partition_name,
                pg_get_expr(pt.relpartbound, pt.oid, true) expr
         from pg_class base_tb
                  join pg_inherits i on i.inhparent = base_tb.oid
                  join pg_class pt on pt.oid = i.inhrelid
         where base_tb.oid = p_table::regclass
     ) p

$$;


--
-- Name: hold_to_balance(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.hold_to_balance(payment_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
  amount bigint;
  wallet_id integer;
BEGIN

  EXECUTE 'SELECT wallet_id, amount + fee FROM public.payments WHERE id = $1'
  INTO wallet_id, amount
  USING payment_id;

  EXECUTE 'UPDATE public.wallets 
           SET balance = balance + $1,
               hold_balance = hold_balance - $1
           WHERE id = $2'
  USING amount, wallet_id;

  EXECUTE 'UPDATE public.payments
           SET status = 5
           WHERE id = $1'
  USING payment_id;

  INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
  VALUES (wallet_id,
          format('Move hold %s to balance for failed payment %s', amount, payment_id),
          (SELECT balance FROM public.wallets WHERE id = wallet_id),
          (SELECT hold_balance FROM public.wallets WHERE id = wallet_id),
          format('Revert payments'));
END;
$_$;


--
-- Name: last_agg(anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.last_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT $2;
$_$;


--
-- Name: maintain_partitions_for_dates(integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.maintain_partitions_for_dates(p_retain_days integer, p_in_advance_days integer, p_table text) RETURNS void
    LANGUAGE sql
    SET search_path TO 'public'
    AS $$
select create_partition_for_date(dt, p_table)
from (
         select current_date + delta.d dt
         from generate_series(0, p_in_advance_days) delta(d)
             except
         select for_date
         from get_partitions_for_date(p_table)
     ) to_create;

select drop_partition_for_date(for_date, p_table)
from get_partitions_for_date(p_table)
where for_date < current_date - p_retain_days ;
$$;


--
-- Name: mark_as_sent_and_release(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.mark_as_sent_and_release() RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
  amount bigint;
  wallet_id integer;
  payment_id integer;
BEGIN

FOR payment_id IN SELECT p.id FROM public.payments p
  JOIN public.wallets w ON p.wallet_id=w.id
  WHERE p."status" = '2' 
  AND p."created_at" > '2018-12-01' 
  AND CAST(p."updated_at" AS text) LIKE '%2018-12-03%' 
  AND p.created_at < '2018-12-03 16:00'
  AND p."transaction_id" IS NULL
  AND p.id != 13489 AND w.balance >= p.amount + p.fee
LOOP

  EXECUTE 'SELECT wallet_id, amount + fee FROM public.payments WHERE id = $1'
  INTO wallet_id, amount
  USING payment_id;

  EXECUTE 'UPDATE public.wallets 
           SET balance = balance - $1,
               hold_balance = hold_balance + $1
           WHERE id = $2'
  USING amount, wallet_id;

  EXECUTE 'UPDATE public.payments
           SET status = 2
           WHERE id = $1'
  USING payment_id;
END LOOP;
END;
$_$;


--
-- Name: mark_as_sent_and_release_hold(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.mark_as_sent_and_release_hold(payment_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
  amount bigint;
  wallet_id integer;
BEGIN

  EXECUTE 'SELECT wallet_id, amount + fee FROM public.payments WHERE id = $1'
  INTO wallet_id, amount
  USING payment_id;

  EXECUTE 'UPDATE public.wallets 
           SET hold_balance = hold_balance - $1
           WHERE id = $2'
  USING amount, wallet_id;

  EXECUTE 'UPDATE public.payments
           SET status = 2
           WHERE id = $1'
  USING payment_id;

  INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
  VALUES (wallet_id,
          format('Release hold %s for already sent payment %s', amount, payment_id),
          (SELECT balance FROM public.wallets WHERE id = wallet_id),
          (SELECT hold_balance FROM public.wallets WHERE id = wallet_id),
          format('Sent payments release'));
END;
$_$;


--
-- Name: move_money(integer, integer, public.cryptocurrency_code, numeric, text, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.move_money(user_from integer, user_to integer, cc public.cryptocurrency_code, amount numeric, cause text, platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
  wallet_from integer;
  wallet_to integer;

BEGIN
  SELECT id
  FROM public.wallet
  WHERE user_id = user_from
    AND cc_code = cc
  INTO wallet_from;

  SELECT id
  FROM public.wallet
  WHERE user_id = user_to
    AND cc_code = cc
  INTO wallet_to;

  UPDATE public.wallet
  SET balance = balance - amount
  WHERE id = wallet_from;

  INSERT INTO p2p.wallet_log(
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    amount,
    currency,
    source_type,
    operation_type,
    platform
  ) VALUES (
    wallet_from,
    (SELECT balance FROM public.wallet WHERE id = wallet_from),
    (SELECT hold_balance FROM public.wallet WHERE id = wallet_from),
    cause,
    amount,
    cc,
    'direct',
    'outgoing',
    platform
  );

  UPDATE public.wallet
  SET balance = balance + amount
  WHERE id = wallet_to;

  INSERT INTO p2p.wallet_log (
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    amount,
    currency,
    source_type,
    operation_type,
    platform
  ) VALUES (
    wallet_to,
    (SELECT balance FROM public.wallet WHERE id = wallet_to),
    (SELECT hold_balance FROM public.wallet WHERE id = wallet_to),
    cause,
    amount,
    cc,
    'direct',
    'incoming',
    platform
  );
END;
$$;


--
-- Name: move_money(integer, integer, public.cryptocurrency_code, numeric, text, p2p.operation_source, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.move_money(user_from integer, user_to integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
  wallet_from integer;
  wallet_to integer;

BEGIN
  SELECT id
  FROM public.wallets
  WHERE user_id = user_from
    AND cc_code = cc
  INTO wallet_from;

  SELECT id
  FROM public.wallets
  WHERE user_id = user_to
    AND cc_code = cc
  INTO wallet_to;

  UPDATE public.wallets
  SET balance = balance - amount
  WHERE id = wallet_from;

  INSERT INTO p2p.wallet_log(
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    amount,
    currency,
    source_type,
    operation_type,
    platform
  ) VALUES (
    wallet_from,
    (SELECT balance FROM public.wallets WHERE id = wallet_from),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_from),
    cause,
    amount,
    cc,
    source_type,
    'outgoing',
    platform
  );

  UPDATE public.wallets
  SET balance = balance + amount
  WHERE id = wallet_to;

  INSERT INTO p2p.wallet_log (
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    amount,
    currency,
    source_type,
    operation_type,
    platform
  ) VALUES (
    wallet_to,
    (SELECT balance FROM public.wallets WHERE id = wallet_to),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_to),
    cause,
    amount,
    cc,
    source_type,
    'incoming',
    platform
  );
END;
$$;


--
-- Name: null_txids_for_internal_txes(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.null_txids_for_internal_txes() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  tx_id character varying(128);
BEGIN

FOR tx_id IN SELECT txid
            FROM public.transactions
            GROUP BY txid HAVING count(*)>1 LOOP

  UPDATE public.transactions
  SET txid='-'||tx_id
  WHERE txid=tx_id AND category=1;
END LOOP;

END;
$$;


--
-- Name: release_banned_balances(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.release_banned_balances() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  wallet RECORD;
  system_uid integer;
BEGIN

SELECT id
FROM public.users
WHERE username = 'system'
INTO system_uid;

FOR wallet IN SELECT wallets.id,
                     wallets.currency,
                     wallets.balance,
                     wallets.hold_balance
              FROM public.wallets
              INNER JOIN p2p.user_profile
                      ON public.wallets.user_id = p2p.user_profile.user_id
              WHERE p2p.user_profile.blocked_by_admin = true
                AND (public.wallets.balance != 0 OR public.wallets.hold_balance != 0) LOOP

    UPDATE public.wallets
    SET balance = 0,
        hold_balance = 0
    WHERE id = wallet.id;

--  INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
--  VALUES (wallet.id,
--          format('Withdraw from wallet balance %s + %s (hold_balance) in satoshi', wallet.balance, wallet.hold_balance),
--          0,
--          0,
--          format('Releasing balances of blocked user wallet_id %s', wallet.id));
    INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment)
    VALUES (wallet.id,
            format('Withdraw from wallet balance %s + %s (hold_balance) in satoshi', wallet.balance, wallet.hold_balance),
            0,
            0);

    UPDATE public.wallets
    SET balance = balance + wallet.balance + wallet.hold_balance
    WHERE user_id = system_uid
      AND currency = wallet.currency;

--  INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
--  VALUES (wallet.id,
--          format('Add to wallet balance %s and hold_balance %s in satoshi', wallet.balance, wallet.hold_balance),
--          (SELECT balance FROM public.wallets WHERE user_id = system_uid AND currency = wallet.currency),
--          (SELECT hold_balance FROM public.wallets WHERE user_id = system_uid AND currency = wallet.currency),
--          format('Releasing balances of blocked user wallet_id %s', wallet.id));
    INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment)
    VALUES (wallet.id,
            format('Add to wallet balance %s and hold_balance %s in satoshi', wallet.balance, wallet.hold_balance),
            (SELECT balance FROM public.wallets WHERE user_id = system_uid AND currency = wallet.currency),
            (SELECT hold_balance FROM public.wallets WHERE user_id = system_uid AND currency = wallet.currency));

END LOOP;

END;
$$;


--
-- Name: first(anyelement); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE public.first(anyelement) (
    SFUNC = public.first_agg,
    STYPE = anyelement
);


--
-- Name: last(anyelement); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE public.last(anyelement) (
    SFUNC = public.last_agg,
    STYPE = anyelement
);


--
-- Name: cryptocurrency; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cryptocurrency (
    code character varying(4) NOT NULL,
    name character varying(256) NOT NULL,
    scale smallint DEFAULT 8 NOT NULL,
    weight smallint NOT NULL,
    CONSTRAINT cryptocurrency_code_check CHECK ((length((code)::text) > 0)),
    CONSTRAINT cryptocurrency_name_check CHECK ((length((name)::text) > 0))
);


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
    address_transaction meduza.citext NOT NULL,
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
-- Name: transaction_analyses; Type: TABLE; Schema: meduza; Owner: -
--

CREATE TABLE meduza.transaction_analyses (
    id bigint NOT NULL,
    txid meduza.citext NOT NULL,
    cc_code character varying NOT NULL,
    risk_level integer NOT NULL,
    input_addresses jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    analysis_result_id bigint,
    risk_confidence numeric NOT NULL
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
-- Name: user_cryptocurrency_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_cryptocurrency_settings (
    user_id integer NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    trading_enabled boolean DEFAULT true NOT NULL
);


--
-- Name: blockchain_tx; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blockchain_tx (
    id integer NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    txid character varying(128) NOT NULL,
    network_fee public.cryptocurrency_amount,
    status public.blockchain_tx_status NOT NULL,
    confirmations integer,
    issued_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    source jsonb,
    CONSTRAINT blockchain_tx_check CHECK (((issued_at IS NULL) = (status = 'initial'::public.blockchain_tx_status))),
    CONSTRAINT blockchain_tx_confirmations_check CHECK ((confirmations >= 0)),
    CONSTRAINT blockchain_tx_network_fee_check CHECK (((network_fee)::numeric >= (0)::numeric)),
    CONSTRAINT blockchain_tx_txid_check CHECK ((length((txid)::text) > 0))
);


--
-- Name: deposit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deposit (
    id integer NOT NULL,
    user_id integer,
    wallet_id integer,
    account character varying(100),
    fee public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    address character varying(68) NOT NULL,
    amount public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    blockchain_tx_id integer NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    comment character varying(256),
    vout integer,
    is_dust boolean DEFAULT false NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    status public.deposit_status NOT NULL,
    CONSTRAINT deposit_check CHECK (((status <> 'dust-seizure'::public.deposit_status) OR is_dust))
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    subject character varying(510) NOT NULL,
    username character varying(510) NOT NULL,
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
    "2fa_enabled" boolean DEFAULT false NOT NULL,
    ref_type p2p.referral_type DEFAULT 'independent'::p2p.referral_type NOT NULL,
    authority_can_make_deal boolean DEFAULT true NOT NULL,
    authority_can_make_order boolean DEFAULT true NOT NULL,
    authority_can_make_voucher boolean DEFAULT true NOT NULL,
    authority_can_make_withdrawal boolean DEFAULT true NOT NULL,
    authority_is_admin boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    password_reset_at timestamp without time zone,
    CONSTRAINT users_check CHECK ((deleted_at > created_at))
);


--
-- Name: withdrawal; Type: TABLE; Schema: public; Owner: -
--

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
    CONSTRAINT check_amount CHECK (((amount)::numeric > (0)::numeric)),
    CONSTRAINT payments_fee_check CHECK (((fee)::numeric >= (0)::numeric)),
    CONSTRAINT withdrawal_check CHECK (((blockchain_tx_id IS NOT NULL) OR (status = ANY (ARRAY['pending'::public.withdrawal_status, 'in_progress'::public.withdrawal_status, 'cancelled_by_admin'::public.withdrawal_status, 'failed'::public.withdrawal_status])))),
    CONSTRAINT withdrawal_real_pay_fee_check CHECK (((real_pay_fee)::numeric >= (0)::numeric))
)
WITH (fillfactor='90', autovacuum_enabled='on', autovacuum_vacuum_cost_delay='20');


--
-- Name: account; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account (
    id integer NOT NULL,
    kyc_status public.kyc_status DEFAULT 'NONE'::public.kyc_status NOT NULL
);


--
-- Name: account_kyc_hist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_kyc_hist (
    acc_id integer NOT NULL,
    correlation_id character varying(126) NOT NULL,
    provider public.kyc_provider NOT NULL,
    status public.kyc_status NOT NULL,
    source jsonb,
    at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: account_swap_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_swap_log (
    id integer NOT NULL,
    old_user_id integer NOT NULL,
    new_user_id integer NOT NULL,
    cause character varying(512) NOT NULL,
    admin_id integer NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: account_swap_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_swap_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_swap_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_swap_log_id_seq OWNED BY public.account_swap_log.id;


--
-- Name: admin_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_user (
    id integer NOT NULL,
    email character varying(510) NOT NULL,
    password character varying(510) NOT NULL,
    gauth_key character varying(64),
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    role text DEFAULT 'superuser'::text NOT NULL,
    user_id integer
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_user.id;


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
-- Name: backup$deposit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."backup$deposit" (
    id integer,
    user_id integer,
    wallet_id integer,
    account character varying(100),
    fee public.cryptocurrency_amount,
    address character varying(68),
    amount public.cryptocurrency_amount,
    txid character varying(128),
    confirmations integer,
    balance_loaded boolean,
    created_at timestamp(0) without time zone,
    updated_at timestamp without time zone,
    comment character varying(256),
    vout integer,
    is_dust boolean,
    is_confirmed boolean,
    cc_code public.cryptocurrency_code
);


--
-- Name: backup$payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."backup$payments" (
    id integer,
    user_id integer,
    wallet_id integer,
    transaction_id character varying(128),
    address character varying(68),
    amount public.cryptocurrency_amount,
    fee public.cryptocurrency_amount,
    status public.withdrawal_status,
    remote_ip integer,
    fraud boolean,
    created_at timestamp(0) without time zone,
    updated_at timestamp without time zone,
    comment text,
    network_fee public.cryptocurrency_amount,
    real_pay_fee public.cryptocurrency_amount,
    vip boolean,
    cc_code public.cryptocurrency_code
);


--
-- Name: banned_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.banned_user (
    user_id integer NOT NULL,
    reason text,
    action public.ban_action NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    by_admin character varying(50) NOT NULL
);


--
-- Name: blockchain_tx_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.blockchain_tx ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.blockchain_tx_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: event; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event (
    id integer NOT NULL,
    event_type public.event_type NOT NULL,
    entity_type public.entity NOT NULL,
    entity_id integer NOT NULL,
    event_data_json jsonb NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_id_seq OWNED BY public.event.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: lock_monitor; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.lock_monitor AS
 SELECT COALESCE(((blockingl.relation)::regclass)::text, blockingl.locktype) AS locked_item,
    (now() - blockeda.query_start) AS waiting_duration,
    blockeda.pid AS blocked_pid,
    blockeda.query AS blocked_query,
    blockedl.mode AS blocked_mode,
    blockinga.pid AS blocking_pid,
    blockinga.query AS blocking_query,
    blockingl.mode AS blocking_mode
   FROM (((pg_locks blockedl
     JOIN pg_stat_activity blockeda ON ((blockedl.pid = blockeda.pid)))
     JOIN pg_locks blockingl ON ((((blockingl.transactionid = blockedl.transactionid) OR ((blockingl.relation = blockedl.relation) AND (blockingl.locktype = blockedl.locktype))) AND (blockedl.pid <> blockingl.pid))))
     JOIN pg_stat_activity blockinga ON (((blockingl.pid = blockinga.pid) AND (blockinga.datid = blockeda.datid))))
  WHERE ((NOT blockedl.granted) AND (blockinga.datname = current_database()));


--
-- Name: withdrawal_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.withdrawal_log (
    id integer NOT NULL,
    withdrawal_id integer NOT NULL,
    log text NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: payment_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_logs_id_seq OWNED BY public.withdrawal_log.id;


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.withdrawal.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: signed_operation_request; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.signed_operation_request (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
PARTITION BY LIST (expires_date);


--
-- Name: signed_operation_request$20211019; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211019" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211019" FOR VALUES IN ('2021-10-19');


--
-- Name: signed_operation_request$20211020; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211020" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211020" FOR VALUES IN ('2021-10-20');


--
-- Name: signed_operation_request$20211021; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211021" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211021" FOR VALUES IN ('2021-10-21');


--
-- Name: signed_operation_request$20211022; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211022" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211022" FOR VALUES IN ('2021-10-22');


--
-- Name: signed_operation_request$20211023; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211023" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211023" FOR VALUES IN ('2021-10-23');


--
-- Name: signed_operation_request$20211024; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211024" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211024" FOR VALUES IN ('2021-10-24');


--
-- Name: signed_operation_request$20211025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211025" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211025" FOR VALUES IN ('2021-10-25');


--
-- Name: signed_operation_request$20211026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211026" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211026" FOR VALUES IN ('2021-10-26');


--
-- Name: signed_operation_request$20211027; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211027" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211027" FOR VALUES IN ('2021-10-27');


--
-- Name: signed_operation_request$20211028; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211028" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211028" FOR VALUES IN ('2021-10-28');


--
-- Name: signed_operation_request$20211029; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211029" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211029" FOR VALUES IN ('2021-10-29');


--
-- Name: signed_operation_request$20211030; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211030" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211030" FOR VALUES IN ('2021-10-30');


--
-- Name: signed_operation_request$20211031; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211031" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211031" FOR VALUES IN ('2021-10-31');


--
-- Name: signed_operation_request$20211101; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211101" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211101" FOR VALUES IN ('2021-11-01');


--
-- Name: signed_operation_request$20211102; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211102" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211102" FOR VALUES IN ('2021-11-02');


--
-- Name: signed_operation_request$20211103; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211103" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211103" FOR VALUES IN ('2021-11-03');


--
-- Name: signed_operation_request$20211104; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211104" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211104" FOR VALUES IN ('2021-11-04');


--
-- Name: signed_operation_request$20211105; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211105" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211105" FOR VALUES IN ('2021-11-05');


--
-- Name: signed_operation_request$20211106; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211106" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211106" FOR VALUES IN ('2021-11-06');


--
-- Name: signed_operation_request$20211107; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211107" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211107" FOR VALUES IN ('2021-11-07');


--
-- Name: signed_operation_request$20211108; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211108" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211108" FOR VALUES IN ('2021-11-08');


--
-- Name: signed_operation_request$20211109; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211109" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211109" FOR VALUES IN ('2021-11-09');


--
-- Name: signed_operation_request$20211110; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211110" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211110" FOR VALUES IN ('2021-11-10');


--
-- Name: signed_operation_request$20211111; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211111" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211111" FOR VALUES IN ('2021-11-11');


--
-- Name: signed_operation_request$20211112; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211112" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211112" FOR VALUES IN ('2021-11-12');


--
-- Name: signed_operation_request$20211113; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211113" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211113" FOR VALUES IN ('2021-11-13');


--
-- Name: signed_operation_request$20211114; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211114" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211114" FOR VALUES IN ('2021-11-14');


--
-- Name: signed_operation_request$20211115; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211115" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211115" FOR VALUES IN ('2021-11-15');


--
-- Name: signed_operation_request$20211116; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211116" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211116" FOR VALUES IN ('2021-11-16');


--
-- Name: signed_operation_request$20211117; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211117" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211117" FOR VALUES IN ('2021-11-17');


--
-- Name: signed_operation_request$20211118; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211118" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211118" FOR VALUES IN ('2021-11-18');


--
-- Name: signed_operation_request$20211119; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211119" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211119" FOR VALUES IN ('2021-11-19');


--
-- Name: signed_operation_request$20211120; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211120" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211120" FOR VALUES IN ('2021-11-20');


--
-- Name: signed_operation_request$20211121; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."signed_operation_request$20211121" (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    command character varying(63) NOT NULL,
    params jsonb NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    confirmed_at timestamp without time zone,
    CONSTRAINT signed_operation_request_check CHECK (((expires_date + expires_time) > issued_at)),
    CONSTRAINT signed_operation_request_check1 CHECK (((expires_date + expires_time) > confirmed_at))
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20211121" FOR VALUES IN ('2021-11-21');


--
-- Name: signed_operation_request_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.signed_operation_request ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.signed_operation_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.deposit.id;


--
-- Name: user_auth_pub_key; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_auth_pub_key (
    user_id integer NOT NULL,
    kid smallint DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    jwk jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    name character varying(63) DEFAULT 'default'::character varying NOT NULL,
    can_read boolean DEFAULT true NOT NULL,
    can_trade boolean DEFAULT true NOT NULL,
    can_transfer boolean DEFAULT true NOT NULL,
    aud public.oauth_aud DEFAULT 'usr'::public.oauth_aud NOT NULL
);


--
-- Name: user_token_mfa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_token_mfa (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
PARTITION BY LIST (expires_date);


--
-- Name: user_token_mfa$20211115; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user_token_mfa$20211115" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20211115" FOR VALUES IN ('2021-11-15');


--
-- Name: user_token_mfa$20211116; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user_token_mfa$20211116" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20211116" FOR VALUES IN ('2021-11-16');


--
-- Name: user_token_mfa$20211117; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user_token_mfa$20211117" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20211117" FOR VALUES IN ('2021-11-17');


--
-- Name: user_token_mfa$20211118; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user_token_mfa$20211118" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20211118" FOR VALUES IN ('2021-11-18');


--
-- Name: user_token_mfa$20211119; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user_token_mfa$20211119" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20211119" FOR VALUES IN ('2021-11-19');


--
-- Name: user_token_mfa$20211120; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user_token_mfa$20211120" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20211120" FOR VALUES IN ('2021-11-20');


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public."user".id;


--
-- Name: wallet_address_hist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallet_address_hist (
    wallet_id integer NOT NULL,
    user_id integer NOT NULL,
    cryptocurrency_code character varying(4) NOT NULL,
    address character varying(800) NOT NULL,
    active_from timestamp(0) without time zone NOT NULL,
    active_till timestamp without time zone NOT NULL,
    admin_user_id integer,
    reason public.wallet_address_change_reason NOT NULL,
    comment character varying(1024),
    action_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT wallet_address_hist_check CHECK ((NOT ((admin_user_id IS NULL) AND (reason = 'admin_reset'::public.wallet_address_change_reason))))
);


--
-- Name: COLUMN wallet_address_hist.active_from; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.wallet_address_hist.active_from IS 'wallets.created_at';


--
-- Name: COLUMN wallet_address_hist.active_till; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.wallet_address_hist.active_till IS 'wallets.updated_at';


--
-- Name: wallets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wallets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wallets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wallets_id_seq OWNED BY public.wallet.id;


--
-- Name: address_analyses id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.address_analyses ALTER COLUMN id SET DEFAULT nextval('meduza.address_analyses_id_seq'::regclass);


--
-- Name: analysis_results id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.analysis_results ALTER COLUMN id SET DEFAULT nextval('meduza.analysis_results_id_seq'::regclass);


--
-- Name: transaction_analyses id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.transaction_analyses ALTER COLUMN id SET DEFAULT nextval('meduza.transaction_analyses_id_seq'::regclass);


--
-- Name: transaction_sources id; Type: DEFAULT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.transaction_sources ALTER COLUMN id SET DEFAULT nextval('meduza.transaction_sources_id_seq'::regclass);


--
-- Name: account_swap_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_swap_log ALTER COLUMN id SET DEFAULT nextval('public.account_swap_log_id_seq'::regclass);


--
-- Name: admin_user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_user ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: deposit id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deposit ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: event id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event ALTER COLUMN id SET DEFAULT nextval('public.event_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: user ref_parent_user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN ref_parent_user_id SET DEFAULT currval('public.users_id_seq'::regclass);


--
-- Name: wallet id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet ALTER COLUMN id SET DEFAULT nextval('public.wallets_id_seq'::regclass);


--
-- Name: withdrawal id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: withdrawal_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal_log ALTER COLUMN id SET DEFAULT nextval('public.payment_logs_id_seq'::regclass);


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
-- Name: account_kyc_hist account_kyc_hist_acc_id_at_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_kyc_hist
    ADD CONSTRAINT account_kyc_hist_acc_id_at_key UNIQUE (acc_id, at);


--
-- Name: account_kyc_hist account_kyc_hist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_kyc_hist
    ADD CONSTRAINT account_kyc_hist_pkey PRIMARY KEY (provider, correlation_id);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: account_swap_log account_swap_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_swap_log
    ADD CONSTRAINT account_swap_log_pkey PRIMARY KEY (old_user_id, new_user_id);


--
-- Name: admin_user admin_users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_user
    ADD CONSTRAINT admin_users_email_key UNIQUE (email);


--
-- Name: admin_user admin_users_gauth_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_user
    ADD CONSTRAINT admin_users_gauth_key_key UNIQUE (gauth_key);


--
-- Name: admin_user admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_user
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: banned_user banned_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banned_user
    ADD CONSTRAINT banned_users_pkey PRIMARY KEY (user_id, date);


--
-- Name: blockchain_tx blockchain_tx_cc_code_txid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blockchain_tx
    ADD CONSTRAINT blockchain_tx_cc_code_txid_key UNIQUE (cc_code, txid);


--
-- Name: blockchain_tx blockchain_tx_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blockchain_tx
    ADD CONSTRAINT blockchain_tx_pkey PRIMARY KEY (id);


--
-- Name: cryptocurrency cryptocurrency_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cryptocurrency
    ADD CONSTRAINT cryptocurrency_name_key UNIQUE (name);


--
-- Name: cryptocurrency cryptocurrency_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cryptocurrency
    ADD CONSTRAINT cryptocurrency_pkey PRIMARY KEY (code);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: withdrawal_log payment_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal_log
    ADD CONSTRAINT payment_logs_pkey PRIMARY KEY (id);


--
-- Name: withdrawal payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: withdrawal payments_wallet_id_address_created_at_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_wallet_id_address_created_at_key UNIQUE (wallet_id, address, created_at);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: signed_operation_request signed_operation_request_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signed_operation_request
    ADD CONSTRAINT signed_operation_request_pkey PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211019 signed_operation_request$20211019_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211019"
    ADD CONSTRAINT "signed_operation_request$20211019_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211020 signed_operation_request$20211020_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211020"
    ADD CONSTRAINT "signed_operation_request$20211020_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211021 signed_operation_request$20211021_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211021"
    ADD CONSTRAINT "signed_operation_request$20211021_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211022 signed_operation_request$20211022_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211022"
    ADD CONSTRAINT "signed_operation_request$20211022_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211023 signed_operation_request$20211023_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211023"
    ADD CONSTRAINT "signed_operation_request$20211023_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211024 signed_operation_request$20211024_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211024"
    ADD CONSTRAINT "signed_operation_request$20211024_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211025 signed_operation_request$20211025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211025"
    ADD CONSTRAINT "signed_operation_request$20211025_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211026 signed_operation_request$20211026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211026"
    ADD CONSTRAINT "signed_operation_request$20211026_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211027 signed_operation_request$20211027_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211027"
    ADD CONSTRAINT "signed_operation_request$20211027_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211028 signed_operation_request$20211028_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211028"
    ADD CONSTRAINT "signed_operation_request$20211028_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211029 signed_operation_request$20211029_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211029"
    ADD CONSTRAINT "signed_operation_request$20211029_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211030 signed_operation_request$20211030_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211030"
    ADD CONSTRAINT "signed_operation_request$20211030_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211031 signed_operation_request$20211031_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211031"
    ADD CONSTRAINT "signed_operation_request$20211031_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211101 signed_operation_request$20211101_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211101"
    ADD CONSTRAINT "signed_operation_request$20211101_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211102 signed_operation_request$20211102_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211102"
    ADD CONSTRAINT "signed_operation_request$20211102_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211103 signed_operation_request$20211103_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211103"
    ADD CONSTRAINT "signed_operation_request$20211103_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211104 signed_operation_request$20211104_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211104"
    ADD CONSTRAINT "signed_operation_request$20211104_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211105 signed_operation_request$20211105_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211105"
    ADD CONSTRAINT "signed_operation_request$20211105_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211106 signed_operation_request$20211106_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211106"
    ADD CONSTRAINT "signed_operation_request$20211106_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211107 signed_operation_request$20211107_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211107"
    ADD CONSTRAINT "signed_operation_request$20211107_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211108 signed_operation_request$20211108_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211108"
    ADD CONSTRAINT "signed_operation_request$20211108_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211109 signed_operation_request$20211109_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211109"
    ADD CONSTRAINT "signed_operation_request$20211109_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211110 signed_operation_request$20211110_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211110"
    ADD CONSTRAINT "signed_operation_request$20211110_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211111 signed_operation_request$20211111_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211111"
    ADD CONSTRAINT "signed_operation_request$20211111_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211112 signed_operation_request$20211112_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211112"
    ADD CONSTRAINT "signed_operation_request$20211112_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211113 signed_operation_request$20211113_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211113"
    ADD CONSTRAINT "signed_operation_request$20211113_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211114 signed_operation_request$20211114_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211114"
    ADD CONSTRAINT "signed_operation_request$20211114_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211115 signed_operation_request$20211115_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211115"
    ADD CONSTRAINT "signed_operation_request$20211115_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211116 signed_operation_request$20211116_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211116"
    ADD CONSTRAINT "signed_operation_request$20211116_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211117 signed_operation_request$20211117_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211117"
    ADD CONSTRAINT "signed_operation_request$20211117_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211118 signed_operation_request$20211118_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211118"
    ADD CONSTRAINT "signed_operation_request$20211118_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211119 signed_operation_request$20211119_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211119"
    ADD CONSTRAINT "signed_operation_request$20211119_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211120 signed_operation_request$20211120_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211120"
    ADD CONSTRAINT "signed_operation_request$20211120_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20211121 signed_operation_request$20211121_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."signed_operation_request$20211121"
    ADD CONSTRAINT "signed_operation_request$20211121_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: deposit transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: deposit txid_vout; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT txid_vout UNIQUE (blockchain_tx_id, vout);


--
-- Name: user_auth_pub_key user_auth_pub_key_jwk_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_auth_pub_key
    ADD CONSTRAINT user_auth_pub_key_jwk_key UNIQUE (jwk);


--
-- Name: user_auth_pub_key user_auth_pub_key_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_auth_pub_key
    ADD CONSTRAINT user_auth_pub_key_pkey PRIMARY KEY (user_id, aud, kid);


--
-- Name: user_cryptocurrency_settings user_cryptocurrency_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_cryptocurrency_settings
    ADD CONSTRAINT user_cryptocurrency_settings_pkey PRIMARY KEY (user_id, cc_code);


--
-- Name: wallet user_id_currency_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT user_id_currency_unique UNIQUE (user_id, cc_code);


--
-- Name: user_token_mfa user_tokens_mfa_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_token_mfa
    ADD CONSTRAINT user_tokens_mfa_pkey PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20211115 user_token_mfa$20211115_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user_token_mfa$20211115"
    ADD CONSTRAINT "user_token_mfa$20211115_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20211116 user_token_mfa$20211116_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user_token_mfa$20211116"
    ADD CONSTRAINT "user_token_mfa$20211116_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20211117 user_token_mfa$20211117_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user_token_mfa$20211117"
    ADD CONSTRAINT "user_token_mfa$20211117_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20211118 user_token_mfa$20211118_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user_token_mfa$20211118"
    ADD CONSTRAINT "user_token_mfa$20211118_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20211119 user_token_mfa$20211119_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user_token_mfa$20211119"
    ADD CONSTRAINT "user_token_mfa$20211119_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20211120 user_token_mfa$20211120_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user_token_mfa$20211120"
    ADD CONSTRAINT "user_token_mfa$20211120_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wallet_address_hist wallet_address_hist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_address_hist
    ADD CONSTRAINT wallet_address_hist_pkey PRIMARY KEY (address, cryptocurrency_code, user_id);


--
-- Name: wallet wallets_address_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallets_address_key UNIQUE (cc_code, address);


--
-- Name: wallet wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- Name: index_address_analyses_on_address; Type: INDEX; Schema: meduza; Owner: -
--

CREATE UNIQUE INDEX index_address_analyses_on_address ON meduza.address_analyses USING btree (address);


--
-- Name: index_address_analyses_on_analysis_result_id; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_address_analyses_on_analysis_result_id ON meduza.address_analyses USING btree (analysis_result_id);


--
-- Name: index_analysis_results_on_address_transaction; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_analysis_results_on_address_transaction ON meduza.analysis_results USING btree (address_transaction);


--
-- Name: index_transaction_analyses_on_analysis_result_id; Type: INDEX; Schema: meduza; Owner: -
--

CREATE INDEX index_transaction_analyses_on_analysis_result_id ON meduza.transaction_analyses USING btree (analysis_result_id);


--
-- Name: index_transaction_analyses_on_txid; Type: INDEX; Schema: meduza; Owner: -
--

CREATE UNIQUE INDEX index_transaction_analyses_on_txid ON meduza.transaction_analyses USING btree (txid);


--
-- Name: deposit_cc_code_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deposit_cc_code_idx ON public.deposit USING btree (cc_code);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: payments_address_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_address_idx ON public.withdrawal USING btree (address);


--
-- Name: payments_amount_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_amount_idx ON public.withdrawal USING btree (amount);


--
-- Name: payments_cc_code_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_cc_code_idx ON public.withdrawal USING btree (cc_code);


--
-- Name: payments_created_at_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_created_at_id_idx ON public.withdrawal USING btree (created_at);


--
-- Name: payments_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_status_idx ON public.withdrawal USING btree (status);


--
-- Name: payments_transaction_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_transaction_id_idx ON public.withdrawal USING btree (blockchain_tx_id);


--
-- Name: payments_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_user_id_idx ON public.withdrawal USING btree (user_id);


--
-- Name: signed_operation_request_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX signed_operation_request_id_idx ON ONLY public.signed_operation_request USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211019_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211019_id_idx" ON public."signed_operation_request$20211019" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211020_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211020_id_idx" ON public."signed_operation_request$20211020" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211021_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211021_id_idx" ON public."signed_operation_request$20211021" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211022_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211022_id_idx" ON public."signed_operation_request$20211022" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211023_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211023_id_idx" ON public."signed_operation_request$20211023" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211024_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211024_id_idx" ON public."signed_operation_request$20211024" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211025_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211025_id_idx" ON public."signed_operation_request$20211025" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211026_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211026_id_idx" ON public."signed_operation_request$20211026" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211027_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211027_id_idx" ON public."signed_operation_request$20211027" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211028_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211028_id_idx" ON public."signed_operation_request$20211028" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211029_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211029_id_idx" ON public."signed_operation_request$20211029" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211030_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211030_id_idx" ON public."signed_operation_request$20211030" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211031_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211031_id_idx" ON public."signed_operation_request$20211031" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211101_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211101_id_idx" ON public."signed_operation_request$20211101" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211102_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211102_id_idx" ON public."signed_operation_request$20211102" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211103_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211103_id_idx" ON public."signed_operation_request$20211103" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211104_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211104_id_idx" ON public."signed_operation_request$20211104" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211105_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211105_id_idx" ON public."signed_operation_request$20211105" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211106_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211106_id_idx" ON public."signed_operation_request$20211106" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211107_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211107_id_idx" ON public."signed_operation_request$20211107" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211108_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211108_id_idx" ON public."signed_operation_request$20211108" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211109_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211109_id_idx" ON public."signed_operation_request$20211109" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211110_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211110_id_idx" ON public."signed_operation_request$20211110" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211111_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211111_id_idx" ON public."signed_operation_request$20211111" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211112_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211112_id_idx" ON public."signed_operation_request$20211112" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211113_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211113_id_idx" ON public."signed_operation_request$20211113" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211114_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211114_id_idx" ON public."signed_operation_request$20211114" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211115_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211115_id_idx" ON public."signed_operation_request$20211115" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211116_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211116_id_idx" ON public."signed_operation_request$20211116" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211117_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211117_id_idx" ON public."signed_operation_request$20211117" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211118_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211118_id_idx" ON public."signed_operation_request$20211118" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211119_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211119_id_idx" ON public."signed_operation_request$20211119" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211120_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211120_id_idx" ON public."signed_operation_request$20211120" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20211121_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "signed_operation_request$20211121_id_idx" ON public."signed_operation_request$20211121" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: transactions_address_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX transactions_address_idx ON public.deposit USING btree (address);


--
-- Name: transactions_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX transactions_created_at_idx ON public.deposit USING btree (created_at);


--
-- Name: transactions_txid_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX transactions_txid_idx ON public.deposit USING btree (blockchain_tx_id);


--
-- Name: transactions_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX transactions_user_id_idx ON public.deposit USING btree (user_id);


--
-- Name: user_cryptocurrency_settings_user_id_cryptocurrency_code_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX user_cryptocurrency_settings_user_id_cryptocurrency_code_idx ON public.user_cryptocurrency_settings USING btree (user_id, cc_code) WHERE trading_enabled;


--
-- Name: users_real_email_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_real_email_idx ON public."user" USING btree (real_email) WHERE (deleted_at IS NULL);


--
-- Name: users_ref_parent_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_ref_parent_user_id_idx ON public."user" USING btree (ref_parent_user_id);


--
-- Name: users_subject_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_subject_idx ON public."user" USING btree (subject) WHERE (deleted_at IS NULL);


--
-- Name: users_subject_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_subject_idx1 ON public."user" USING btree (subject);


--
-- Name: users_telegram_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_telegram_id_idx ON public."user" USING btree (telegram_id) WHERE (deleted_at IS NULL);


--
-- Name: users_telegram_id_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_telegram_id_idx1 ON public."user" USING btree (telegram_id);


--
-- Name: users_username_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_username_idx ON public."user" USING btree (username) WHERE (deleted_at IS NULL);


--
-- Name: users_username_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_username_idx1 ON public."user" USING btree (username);


--
-- Name: wallet_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX wallet_user_id ON public.wallet USING btree (user_id);


--
-- Name: signed_operation_request$20211019_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211019_id_idx";


--
-- Name: signed_operation_request$20211019_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211019_pkey";


--
-- Name: signed_operation_request$20211020_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211020_id_idx";


--
-- Name: signed_operation_request$20211020_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211020_pkey";


--
-- Name: signed_operation_request$20211021_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211021_id_idx";


--
-- Name: signed_operation_request$20211021_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211021_pkey";


--
-- Name: signed_operation_request$20211022_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211022_id_idx";


--
-- Name: signed_operation_request$20211022_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211022_pkey";


--
-- Name: signed_operation_request$20211023_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211023_id_idx";


--
-- Name: signed_operation_request$20211023_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211023_pkey";


--
-- Name: signed_operation_request$20211024_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211024_id_idx";


--
-- Name: signed_operation_request$20211024_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211024_pkey";


--
-- Name: signed_operation_request$20211025_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211025_id_idx";


--
-- Name: signed_operation_request$20211025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211025_pkey";


--
-- Name: signed_operation_request$20211026_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211026_id_idx";


--
-- Name: signed_operation_request$20211026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211026_pkey";


--
-- Name: signed_operation_request$20211027_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211027_id_idx";


--
-- Name: signed_operation_request$20211027_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211027_pkey";


--
-- Name: signed_operation_request$20211028_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211028_id_idx";


--
-- Name: signed_operation_request$20211028_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211028_pkey";


--
-- Name: signed_operation_request$20211029_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211029_id_idx";


--
-- Name: signed_operation_request$20211029_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211029_pkey";


--
-- Name: signed_operation_request$20211030_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211030_id_idx";


--
-- Name: signed_operation_request$20211030_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211030_pkey";


--
-- Name: signed_operation_request$20211031_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211031_id_idx";


--
-- Name: signed_operation_request$20211031_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211031_pkey";


--
-- Name: signed_operation_request$20211101_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211101_id_idx";


--
-- Name: signed_operation_request$20211101_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211101_pkey";


--
-- Name: signed_operation_request$20211102_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211102_id_idx";


--
-- Name: signed_operation_request$20211102_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211102_pkey";


--
-- Name: signed_operation_request$20211103_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211103_id_idx";


--
-- Name: signed_operation_request$20211103_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211103_pkey";


--
-- Name: signed_operation_request$20211104_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211104_id_idx";


--
-- Name: signed_operation_request$20211104_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211104_pkey";


--
-- Name: signed_operation_request$20211105_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211105_id_idx";


--
-- Name: signed_operation_request$20211105_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211105_pkey";


--
-- Name: signed_operation_request$20211106_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211106_id_idx";


--
-- Name: signed_operation_request$20211106_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211106_pkey";


--
-- Name: signed_operation_request$20211107_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211107_id_idx";


--
-- Name: signed_operation_request$20211107_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211107_pkey";


--
-- Name: signed_operation_request$20211108_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211108_id_idx";


--
-- Name: signed_operation_request$20211108_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211108_pkey";


--
-- Name: signed_operation_request$20211109_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211109_id_idx";


--
-- Name: signed_operation_request$20211109_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211109_pkey";


--
-- Name: signed_operation_request$20211110_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211110_id_idx";


--
-- Name: signed_operation_request$20211110_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211110_pkey";


--
-- Name: signed_operation_request$20211111_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211111_id_idx";


--
-- Name: signed_operation_request$20211111_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211111_pkey";


--
-- Name: signed_operation_request$20211112_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211112_id_idx";


--
-- Name: signed_operation_request$20211112_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211112_pkey";


--
-- Name: signed_operation_request$20211113_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211113_id_idx";


--
-- Name: signed_operation_request$20211113_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211113_pkey";


--
-- Name: signed_operation_request$20211114_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211114_id_idx";


--
-- Name: signed_operation_request$20211114_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211114_pkey";


--
-- Name: signed_operation_request$20211115_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211115_id_idx";


--
-- Name: signed_operation_request$20211115_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211115_pkey";


--
-- Name: signed_operation_request$20211116_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211116_id_idx";


--
-- Name: signed_operation_request$20211116_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211116_pkey";


--
-- Name: signed_operation_request$20211117_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211117_id_idx";


--
-- Name: signed_operation_request$20211117_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211117_pkey";


--
-- Name: signed_operation_request$20211118_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211118_id_idx";


--
-- Name: signed_operation_request$20211118_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211118_pkey";


--
-- Name: signed_operation_request$20211119_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211119_id_idx";


--
-- Name: signed_operation_request$20211119_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211119_pkey";


--
-- Name: signed_operation_request$20211120_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211120_id_idx";


--
-- Name: signed_operation_request$20211120_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211120_pkey";


--
-- Name: signed_operation_request$20211121_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20211121_id_idx";


--
-- Name: signed_operation_request$20211121_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20211121_pkey";


--
-- Name: user_token_mfa$20211115_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20211115_pkey";


--
-- Name: user_token_mfa$20211116_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20211116_pkey";


--
-- Name: user_token_mfa$20211117_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20211117_pkey";


--
-- Name: user_token_mfa$20211118_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20211118_pkey";


--
-- Name: user_token_mfa$20211119_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20211119_pkey";


--
-- Name: user_token_mfa$20211120_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20211120_pkey";


--
-- Name: address_analyses fk_rails_4d26b9d298; Type: FK CONSTRAINT; Schema: meduza; Owner: -
--

ALTER TABLE ONLY meduza.address_analyses
    ADD CONSTRAINT fk_rails_4d26b9d298 FOREIGN KEY (analysis_result_id) REFERENCES meduza.analysis_results(id);


--
-- Name: account account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_id_fkey FOREIGN KEY (id) REFERENCES public."user"(id);


--
-- Name: account_kyc_hist account_kyc_hist_acc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_kyc_hist
    ADD CONSTRAINT account_kyc_hist_acc_id_fkey FOREIGN KEY (acc_id) REFERENCES public."user"(id);


--
-- Name: account_swap_log account_swap_log_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_swap_log
    ADD CONSTRAINT account_swap_log_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public."user"(id);


--
-- Name: account_swap_log account_swap_log_new_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_swap_log
    ADD CONSTRAINT account_swap_log_new_user_id_fkey FOREIGN KEY (new_user_id) REFERENCES public."user"(id);


--
-- Name: account_swap_log account_swap_log_old_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_swap_log
    ADD CONSTRAINT account_swap_log_old_user_id_fkey FOREIGN KEY (old_user_id) REFERENCES public."user"(id);


--
-- Name: deposit deposit_blockchain_tx_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT deposit_blockchain_tx_id_fkey FOREIGN KEY (blockchain_tx_id) REFERENCES public.blockchain_tx(id);


--
-- Name: withdrawal payments_currency_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_currency_fkey FOREIGN KEY (cc_code) REFERENCES public.cryptocurrency(code);


--
-- Name: withdrawal payments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: withdrawal payments_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallet(id);


--
-- Name: signed_operation_request signed_operation_request_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.signed_operation_request
    ADD CONSTRAINT signed_operation_request_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_auth_pub_key user_auth_pub_key_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_auth_pub_key
    ADD CONSTRAINT user_auth_pub_key_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_cryptocurrency_settings user_cryptocurrency_settings_cryptocurrency_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_cryptocurrency_settings
    ADD CONSTRAINT user_cryptocurrency_settings_cryptocurrency_code_fkey FOREIGN KEY (cc_code) REFERENCES public.cryptocurrency(code);


--
-- Name: user_cryptocurrency_settings user_cryptocurrency_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_cryptocurrency_settings
    ADD CONSTRAINT user_cryptocurrency_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_token_mfa user_tokens_mfa_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.user_token_mfa
    ADD CONSTRAINT user_tokens_mfa_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user users_ref_parent_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT users_ref_parent_user_id_fkey FOREIGN KEY (ref_parent_user_id) REFERENCES public."user"(id);


--
-- Name: wallet_address_hist wallet_address_hist_admin_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_address_hist
    ADD CONSTRAINT wallet_address_hist_admin_user_id_fkey FOREIGN KEY (admin_user_id) REFERENCES public."user"(id);


--
-- Name: wallet_address_hist wallet_address_hist_cryptocurrency_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_address_hist
    ADD CONSTRAINT wallet_address_hist_cryptocurrency_code_fkey FOREIGN KEY (cryptocurrency_code) REFERENCES public.cryptocurrency(code);


--
-- Name: wallet_address_hist wallet_address_hist_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_address_hist
    ADD CONSTRAINT wallet_address_hist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: wallet_address_hist wallet_address_hist_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_address_hist
    ADD CONSTRAINT wallet_address_hist_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallet(id);


--
-- Name: withdrawal withdrawal_blockchain_tx_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_blockchain_tx_id_fkey FOREIGN KEY (blockchain_tx_id) REFERENCES public.blockchain_tx(id);


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
('20211126081238');


