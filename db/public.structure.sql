--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5 (Ubuntu 13.5-1.pgdg18.04+1)
-- Dumped by pg_dump version 13.1 (Ubuntu 13.1-1.pgdg18.04+1)

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
-- Name: barong; Type: SCHEMA; Schema: -; Owner: market
--

CREATE SCHEMA barong;


ALTER SCHEMA barong OWNER TO market;

--
-- Name: cleanup; Type: SCHEMA; Schema: -; Owner: bitzlato
--

CREATE SCHEMA cleanup;


ALTER SCHEMA cleanup OWNER TO bitzlato;

--
-- Name: history; Type: SCHEMA; Schema: -; Owner: bitzlato
--

CREATE SCHEMA history;


ALTER SCHEMA history OWNER TO bitzlato;

--
-- Name: meduza; Type: SCHEMA; Schema: -; Owner: meduza
--

CREATE SCHEMA meduza;


ALTER SCHEMA meduza OWNER TO meduza;

--
-- Name: mer; Type: SCHEMA; Schema: -; Owner: bitzlato
--

CREATE SCHEMA mer;


ALTER SCHEMA mer OWNER TO bitzlato;

--
-- Name: p2p; Type: SCHEMA; Schema: -; Owner: bitzlato
--

CREATE SCHEMA p2p;


ALTER SCHEMA p2p OWNER TO bitzlato;

--
-- Name: postgres_exporter; Type: SCHEMA; Schema: -; Owner: postgres_exporter
--

CREATE SCHEMA postgres_exporter;


ALTER SCHEMA postgres_exporter OWNER TO postgres_exporter;

--
-- Name: rep; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA rep;


ALTER SCHEMA rep OWNER TO postgres;

--
-- Name: sec; Type: SCHEMA; Schema: -; Owner: bitzlato
--

CREATE SCHEMA sec;


ALTER SCHEMA sec OWNER TO bitzlato;

--
-- Name: whaler; Type: SCHEMA; Schema: -; Owner: whaler
--

CREATE SCHEMA whaler;


ALTER SCHEMA whaler OWNER TO whaler;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA p2p;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: invoice_status; Type: TYPE; Schema: mer; Owner: bitzlato
--

CREATE TYPE mer.invoice_status AS ENUM (
    'active',
    'pause'
);


ALTER TYPE mer.invoice_status OWNER TO bitzlato;

--
-- Name: invoice_type; Type: TYPE; Schema: mer; Owner: bitzlato
--

CREATE TYPE mer.invoice_type AS ENUM (
    'open',
    'close'
);


ALTER TYPE mer.invoice_type OWNER TO bitzlato;

--
-- Name: merchant_status; Type: TYPE; Schema: mer; Owner: bitzlato
--

CREATE TYPE mer.merchant_status AS ENUM (
    'active',
    'frozen'
);


ALTER TYPE mer.merchant_status OWNER TO bitzlato;

--
-- Name: payments_statuses; Type: TYPE; Schema: mer; Owner: bitzlato
--

CREATE TYPE mer.payments_statuses AS ENUM (
    'pending',
    'done',
    'blocked_by_admin'
);


ALTER TYPE mer.payments_statuses OWNER TO bitzlato;

--
-- Name: ads_status; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.ads_status AS ENUM (
    'active',
    'pause',
    'paused_automatically',
    'banned'
);


ALTER TYPE p2p.ads_status OWNER TO bitzlato;

--
-- Name: ads_type; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.ads_type AS ENUM (
    'purchase',
    'selling'
);


ALTER TYPE p2p.ads_type OWNER TO bitzlato;

--
-- Name: advert_creating_block_reason; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.advert_creating_block_reason AS ENUM (
    'not-enough-trades',
    'blocked'
);


ALTER TYPE p2p.advert_creating_block_reason OWNER TO bitzlato;

--
-- Name: audit_rec; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.audit_rec AS (
	"totalIn" numeric,
	"totalOut" numeric,
	"totalAudit" numeric,
	"totalWallets" numeric,
	"coldWalletAdjust" numeric,
	"totalBalancesFree" numeric,
	"systemWalletBalance" numeric,
	"totalBalancesHolded" numeric,
	"realColdWalletBalance" numeric,
	"systemHotWalletBalance" numeric,
	"totalWalletsColdAndHot" numeric,
	"hotWalletUnconfirmedBalance" numeric,
	"pendingPayments" numeric,
	"totalNetworkFee" numeric
);


ALTER TYPE p2p.audit_rec OWNER TO bitzlato;

--
-- Name: deep_link_action_type; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.deep_link_action_type AS ENUM (
    'referal',
    'cheque'
);


ALTER TYPE p2p.deep_link_action_type OWNER TO bitzlato;

--
-- Name: dispute_decisions_type; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.dispute_decisions_type AS ENUM (
    'approve',
    'cancel'
);


ALTER TYPE p2p.dispute_decisions_type OWNER TO bitzlato;

--
-- Name: dust_aggregation_status; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.dust_aggregation_status AS ENUM (
    'dust_collected',
    'fee_settled'
);


ALTER TYPE p2p.dust_aggregation_status OWNER TO bitzlato;

--
-- Name: dust_category; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.dust_category AS ENUM (
    'bolsh_c',
    'bolsh_b',
    'bolsh_a',
    'sredne_b',
    'sredne_a',
    'dust_c',
    'dust_b',
    'dust_a'
);


ALTER TYPE p2p.dust_category OWNER TO bitzlato;

--
-- Name: feedback_type; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.feedback_type AS ENUM (
    'thumb-up',
    'relieved',
    'weary',
    'rage',
    'hankey'
);


ALTER TYPE p2p.feedback_type OWNER TO bitzlato;

--
-- Name: operation_source; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.operation_source AS ENUM (
    'trade',
    'order',
    'referral',
    'voucher',
    'direct',
    'commission',
    'deposit',
    'withdraw',
    'tips',
    'debt',
    'beton',
    'invoice',
    'merchantPay',
    'cancel_withdraw',
    'deposit_seizure'
);


ALTER TYPE p2p.operation_source OWNER TO bitzlato;

--
-- Name: operation_type; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.operation_type AS ENUM (
    'hold',
    'unhold',
    'incoming',
    'outgoing',
    'deposit',
    'withdraw'
);


ALTER TYPE p2p.operation_type OWNER TO bitzlato;

--
-- Name: pair_status; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.pair_status AS ENUM (
    'active',
    'frozen'
);


ALTER TYPE p2p.pair_status OWNER TO bitzlato;

--
-- Name: ref_type; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.ref_type AS ENUM (
    'SHORT',
    'LONG',
    'NUMBERS',
    'LETTERS'
);


ALTER TYPE p2p.ref_type OWNER TO bitzlato;

--
-- Name: referral_type; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.referral_type AS ENUM (
    'independent',
    'ref_link_bot',
    'ref_link_web',
    'ad_bot',
    'ad_web',
    'voucher_bot',
    'voucher_web'
);


ALTER TYPE p2p.referral_type OWNER TO bitzlato;

--
-- Name: trade_state; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.trade_state AS ENUM (
    'trade-created',
    'confirm-trade',
    'payment',
    'confirm-payment',
    'dispute',
    'cancel',
    'completed'
);


ALTER TYPE p2p.trade_state OWNER TO bitzlato;

--
-- Name: trade_status_advanced; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.trade_status_advanced AS ENUM (
    'cancel-created-user',
    'cancel-created-auto',
    'cancel-confirmed-user',
    'cancel-confirmed-auto',
    'cancel-payment-auto',
    'cancel-dispute-admin',
    'cancel-reopen-admin',
    'dispute-reopen',
    'confirm-payment-dispute-user',
    'confirm-payment-dispute-admin',
    'confirm-payment-reopen-user',
    'confirm-payment-reopen-admin'
);


ALTER TYPE p2p.trade_status_advanced OWNER TO bitzlato;

--
-- Name: trade_type; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.trade_type AS ENUM (
    'ONLINE_BUY',
    'ONLINE_SELL',
    'LOCAL_SELL',
    'LOCAL_BUY'
);


ALTER TYPE p2p.trade_type OWNER TO bitzlato;

--
-- Name: user_trade_status; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.user_trade_status AS ENUM (
    'active',
    'pause'
);


ALTER TYPE p2p.user_trade_status OWNER TO bitzlato;

--
-- Name: voucher_status_type; Type: TYPE; Schema: p2p; Owner: bitzlato
--

CREATE TYPE p2p.voucher_status_type AS ENUM (
    'active',
    'cashed'
);


ALTER TYPE p2p.voucher_status_type OWNER TO bitzlato;

--
-- Name: admin_role; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.admin_role AS ENUM (
    'superuser',
    'finadmin',
    'admin',
    'operator',
    'user'
);


ALTER TYPE public.admin_role OWNER TO bitzlato;

--
-- Name: ban_action; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.ban_action AS ENUM (
    'ban',
    'unban'
);


ALTER TYPE public.ban_action OWNER TO bitzlato;

--
-- Name: blockchain_tx_status; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.blockchain_tx_status AS ENUM (
    'initial',
    'pending',
    'confirmed'
);


ALTER TYPE public.blockchain_tx_status OWNER TO bitzlato;

--
-- Name: cryptocurrency_amount; Type: DOMAIN; Schema: public; Owner: bitzlato
--

CREATE DOMAIN public.cryptocurrency_amount AS numeric(60,8)
	CONSTRAINT cryptocurrency_amount_check CHECK ((VALUE <> 'NaN'::numeric));


ALTER DOMAIN public.cryptocurrency_amount OWNER TO bitzlato;

--
-- Name: cryptocurrency_code; Type: DOMAIN; Schema: public; Owner: bitzlato
--

CREATE DOMAIN public.cryptocurrency_code AS character varying(4)
	CONSTRAINT cryptocurrency_code_check1 CHECK ((length((VALUE)::text) >= 3));


ALTER DOMAIN public.cryptocurrency_code OWNER TO bitzlato;

--
-- Name: deposit_status; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.deposit_status AS ENUM (
    'pending',
    'aml-check',
    'aml-seizure',
    'dust-seizure',
    'success'
);


ALTER TYPE public.deposit_status OWNER TO bitzlato;

--
-- Name: entity; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.entity AS ENUM (
    'user',
    'wallet',
    'profile',
    'order',
    'trade',
    'advert'
);


ALTER TYPE public.entity OWNER TO bitzlato;

--
-- Name: event_type; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.event_type AS ENUM (
    'created',
    'updated',
    'deleted'
);


ALTER TYPE public.event_type OWNER TO bitzlato;

--
-- Name: kyc_provider; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.kyc_provider AS ENUM (
    'LEGACY',
    'SUMSUB'
);


ALTER TYPE public.kyc_provider OWNER TO bitzlato;

--
-- Name: kyc_status; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.kyc_status AS ENUM (
    'NONE',
    'APPROVED',
    'REJECTED',
    'BAN'
);


ALTER TYPE public.kyc_status OWNER TO bitzlato;

--
-- Name: oauth_aud; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.oauth_aud AS ENUM (
    'usr',
    'mob'
);


ALTER TYPE public.oauth_aud OWNER TO bitzlato;

--
-- Name: text_code; Type: DOMAIN; Schema: public; Owner: bitzlato
--

CREATE DOMAIN public.text_code AS character varying(63)
	CONSTRAINT text_code_check CHECK ((length((VALUE)::text) > 0));


ALTER DOMAIN public.text_code OWNER TO bitzlato;

--
-- Name: wallet_address_change_reason; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.wallet_address_change_reason AS ENUM (
    'merge',
    'admin_reset',
    'migration'
);


ALTER TYPE public.wallet_address_change_reason OWNER TO bitzlato;

--
-- Name: withdrawal_status; Type: TYPE; Schema: public; Owner: bitzlato
--

CREATE TYPE public.withdrawal_status AS ENUM (
    'pending',
    'processed',
    'cancelled',
    'in_progress',
    'failed',
    'cancelled_by_admin',
    'aml'
);


ALTER TYPE public.withdrawal_status OWNER TO bitzlato;

--
-- Name: add_rating_after_merge(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.add_rating_after_merge() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  tgid character varying(256);
BEGIN

FOR tgid IN SELECT regexp_replace(telegram_id, 'deleted_{?(\d+)}?', '\1') as tgid
            FROM public.users
            WHERE telegram_id LIKE 'deleted_%' AND NOT telegram_id LIKE '%todel' LOOP

  UPDATE p2p.user_profile
  SET rating = rating + 10
  WHERE user_id=(SELECT id FROM public.users WHERE telegram_id=tgid);

  RAISE NOTICE 'Add 10 rating for tgid=%', tgid;

END LOOP;
END;
$$;


ALTER FUNCTION p2p.add_rating_after_merge() OWNER TO bitzlato;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: payment_method; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.payment_method (
    id integer NOT NULL,
    currency character varying(8) NOT NULL,
    description character varying(2048) NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    payment_group integer DEFAULT 1 NOT NULL,
    i18n jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE p2p.payment_method OWNER TO bitzlato;

--
-- Name: adm_create_fiat_currency(character varying, character varying, character varying, boolean, numeric); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.adm_create_fiat_currency(p_symbol character varying, p_name character varying, p_sign character varying, p_free_trade_enabled boolean DEFAULT false, p_max_commission_sum numeric DEFAULT 200000) RETURNS SETOF p2p.payment_method
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'p2p'
    AS $$
insert into currency(symbol, name, sign, free_trade_enabled, max_commission_sum)
values (p_symbol, p_name, p_sign, p_free_trade_enabled, p_max_commission_sum);

with global_paymethod as (
    select label, payments_group
    from payment_method_global
)
insert
into payment_method(currency, description, weight, payment_group, i18n)
select p_symbol,
       global_paymethod.label,
       0,
       global_paymethod.payments_group,
       json_build_object('ru', global_paymethod.label)
from global_paymethod
returning *;

$$;


ALTER FUNCTION p2p.adm_create_fiat_currency(p_symbol character varying, p_name character varying, p_sign character varying, p_free_trade_enabled boolean, p_max_commission_sum numeric) OWNER TO bitzlato;

--
-- Name: ad; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.ad (
    id integer NOT NULL,
    user_id integer NOT NULL,
    type p2p.ads_type NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    paymethod integer NOT NULL,
    rate_value numeric NOT NULL,
    min_amount numeric NOT NULL,
    max_amount numeric NOT NULL,
    terms character varying(3000),
    details character varying(1500),
    status p2p.ads_status NOT NULL,
    ratepercent numeric,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    min_partner_trades_amount numeric,
    max_limit_for_new_trader numeric,
    verified_only boolean DEFAULT false,
    liquidity_limit boolean,
    CONSTRAINT check_max CHECK ((max_amount > (0)::numeric)),
    CONSTRAINT check_min CHECK ((min_amount > (0)::numeric)),
    CONSTRAINT max_amount_check CHECK ((max_amount > 0.0001)),
    CONSTRAINT min_amount_check CHECK ((min_amount > 0.0001))
)
WITH (fillfactor='85', autovacuum_enabled='on', autovacuum_vacuum_cost_delay='20');


ALTER TABLE p2p.ad OWNER TO bitzlato;

--
-- Name: wallet; Type: TABLE; Schema: public; Owner: bitzlato
--

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


ALTER TABLE public.wallet OWNER TO bitzlato;

--
-- Name: ads_filter(p2p.ad, public.wallet, real); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.ads_filter(ad p2p.ad, wallet public.wallet, trade_comission_percent real) RETURNS integer
    LANGUAGE plpgsql
    AS $$        DECLARE res int;
        DEClARE remoteRateValue numeric;
        BEGIN
                -- raise notice 'ads: %', ad.id;

                -- find rate. TODO: add user rates
                SELECT "value" INTO remoteRateValue
                FROM p2p.rate r
                JOIN p2p.payment_method p on p.id = ad.paymethod
                WHERE r.cc_code = ad.cc_code
                AND r.currency_symbol = p.currency
                AND r.default_rate = TRUE LIMIT 1;

                -- filter 20% from top and button from remote rate
                IF ad.rate_value > remoteRateValue + remoteRateValue * 0.5::numeric OR ad.rate_value < remoteRateValue - remoteRateValue * 0.5::numeric
                THEN
                  RETURN 3;
                END IF;

                IF ad.type = 'purchase'::p2p.ads_type
                THEN
                  RETURN 1;
                END IF;

                IF wallet IS NULL
                THEN
                  RETURN 0;
                END IF;

                -- filter via balance
                IF wallet.balance < ad.min_amount / ad.rate_value + ad.min_amount / ad.rate_value * trade_comission_percent::numeric * 1::numeric
                THEN
                  RETURN 2;
                END IF;

                RETURN 1;
        END;
$$;


ALTER FUNCTION p2p.ads_filter(ad p2p.ad, wallet public.wallet, trade_comission_percent real) OWNER TO bitzlato;

--
-- Name: balance_to_hold(integer, integer, bigint, text); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.balance_to_hold(wallet_from integer, wallet_to integer, amount bigint, cause text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
BEGIN
  EXECUTE 'UPDATE public.wallets
           SET balance = balance - $2
           WHERE id = $1'
  USING wallet_from, amount;

  INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
  VALUES (wallet_from,
          format('Withdraw manually %s satoshi to wallet %s hold', amount, wallet_to),
          (SELECT balance FROM public.wallets WHERE id = wallet_from),
          (SELECT hold_balance FROM public.wallets WHERE id = wallet_from),
          cause);

  EXECUTE 'UPDATE public.wallets
           SET hold_balance = hold_balance + $2
           WHERE id = $1'
  USING wallet_to, amount;

  INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
  VALUES (wallet_to,
          format('Add manually %s satoshi from wallet %s', amount, wallet_from),
          (SELECT balance FROM public.wallets WHERE id = wallet_to),
          (SELECT hold_balance FROM public.wallets WHERE id = wallet_to),
          cause);
END;
$_$;


ALTER FUNCTION p2p.balance_to_hold(wallet_from integer, wallet_to integer, amount bigint, cause text) OWNER TO bitzlato;

--
-- Name: balance_to_null(integer, public.cryptocurrency_code, numeric, text, p2p.operation_source, character varying); Type: FUNCTION; Schema: p2p; Owner: vanch
--

CREATE FUNCTION p2p.balance_to_null(userid integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
  wallet integer;

BEGIN
  SELECT id
  FROM public.wallets
  WHERE user_id = userid
    AND cc_code = cc
  INTO wallet;

  UPDATE public.wallets
  SET balance = balance - amount
  WHERE id = wallet;

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
    wallet,
    (SELECT balance FROM public.wallets WHERE id = wallet),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet),
    cause,
    amount,
    cc,
    source_type,
    'outgoing',
    platform
  );

END;
$$;


ALTER FUNCTION p2p.balance_to_null(userid integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, platform character varying) OWNER TO vanch;

--
-- Name: base58_encode(integer); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.base58_encode(num integer) RETURNS character varying
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


ALTER FUNCTION p2p.base58_encode(num integer) OWNER TO bitzlato;

--
-- Name: cancel_payment(integer, text); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.cancel_payment(pay_id integer, cause text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  payment RECORD;
  system_wallet_id integer;
  voucher_id integer;
  cc_code character varying(4);
BEGIN
  SELECT wallet_id, currency, amount, fee
  INTO payment
  FROM public.payments
  WHERE id = pay_id;

  SELECT code
  FROM public.cryptocurrency
  WHERE int_code = payment.currency
  INTO cc_code;

  SELECT w.id
  INTO system_wallet_id
  FROM public.wallets w
  JOIN public.users u
  ON u.id = w.user_id
  WHERE u.username = 'system'
  AND w.currency = payment.currency;

  UPDATE public.wallets
  SET balance = balance + payment.amount + payment.fee
  WHERE id = payment.wallet_id;

  INSERT INTO p2p.wallet_log(
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    amount,
    currency,
    source_type,
    source_id,
    operation_type,
    platform
  ) VALUES (
    payment.wallet_id,
    (SELECT balance FROM public.wallets WHERE id = payment.wallet_id),
    (SELECT hold_balance FROM public.wallets WHERE id = payment.wallet_id),
    cause,
    ((payment.amount + payment.fee) / 100000000::numeric)::numeric(1000, 10),
    cc_code,
    'withdraw',
    pay_id,
    'incoming',
    'wallet'
  );

  SELECT id
  INTO voucher_id
  FROM p2p.withdraw_vouchers wv
  WHERE wv.payment_id = pay_id;

  IF voucher_id IS NOT NULL THEN
    UPDATE p2p.withdraw_vouchers SET payment_id = NULL, used_at = NULL WHERE id = voucher_id;
  ELSE
    UPDATE public.wallets
    SET balance = balance - payment.fee
    WHERE id = system_wallet_id;

    INSERT INTO p2p.wallet_log(
      wallet_id,
      balance_at_the_moment,
      hold_balance_at_moment,
      cause,
      amount,
      currency,
      source_type,
      source_id,
      operation_type,
      platform
    ) VALUES (
      system_wallet_id,
      (SELECT balance FROM public.wallets WHERE id = system_wallet_id),
      (SELECT hold_balance FROM public.wallets WHERE id = system_wallet_id),
      cause,
      ((payment.amount + payment.fee) / 100000000::numeric)::numeric(1000, 10),
      cc_code,
      'withdraw',
      pay_id,
      'outgoing',
      'wallet'
    );
  END IF;

  DELETE FROM public.txs
  WHERE payments_id = pay_id;

  DELETE FROM public.payments
  WHERE id = pay_id;
END;
$$;


ALTER FUNCTION p2p.cancel_payment(pay_id integer, cause text) OWNER TO bitzlato;

--
-- Name: check_two_trades(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.check_two_trades() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DEClARE result int;
BEGIN

    select into result count(*)
    FROM p2p.trade
    WHERE p2p.trade.status = 'trade-created'
      AND p2p.trade.amount = NEW.amount
      AND p2p.trade.crypto_seller = NEW.crypto_seller
      AND p2p.trade.crypto_buyer = NEW.crypto_buyer
      AND p2p.trade.cc_code = NEW.cc_code
      AND p2p.trade.created_at + INTERVAL '1 minute' > now();
    IF (result > 1) THEN
        RAISE 'Wait 5 minutes for insert';
    END IF;
    return NEW;
END
$$;


ALTER FUNCTION p2p.check_two_trades() OWNER TO bitzlato;

--
-- Name: check_two_user_rates(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.check_two_user_rates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DEClARE result boolean;
BEGIN

                select into result exists (select 1
                FROM p2p.user_rate
                WHERE p2p.user_rate.user_id = NEW.user_id
                AND p2p.user_rate.rate_id = NEW.rate_id);
                IF (result) THEN
                    RAISE 'User rates already exists';
                END IF;
                return NEW;

END
$$;


ALTER FUNCTION p2p.check_two_user_rates() OWNER TO bitzlato;

--
-- Name: create_rate_plan_withdraw_item(character varying, numeric, numeric, numeric, character varying, timestamp with time zone, timestamp with time zone, character varying); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.create_rate_plan_withdraw_item(p_cc_code character varying, p_fee_amount numeric, p_amount_from numeric, p_amount_till numeric, p_amount_bounds character varying DEFAULT '[)'::character varying, p_act_from timestamp with time zone DEFAULT '2021-01-01 00:00:00+00'::timestamp with time zone, p_act_till timestamp with time zone DEFAULT 'infinity'::timestamp with time zone, p_act_bounds character varying DEFAULT '[)'::character varying) RETURNS void
    LANGUAGE sql
    SET search_path TO 'p2p'
    AS $$
insert into rate_plan_withdraw(cc_code, act_during, op_amount, fee_amount)
values (p_cc_code,
        tsrange(p_act_from::timestamp, p_act_till::timestamp, p_act_bounds),
        numrange(p_amount_from, p_amount_till, p_amount_bounds),
        p_fee_amount)
$$;


ALTER FUNCTION p2p.create_rate_plan_withdraw_item(p_cc_code character varying, p_fee_amount numeric, p_amount_from numeric, p_amount_till numeric, p_amount_bounds character varying, p_act_from timestamp with time zone, p_act_till timestamp with time zone, p_act_bounds character varying) OWNER TO bitzlato;

--
-- Name: disable_ads(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.disable_ads() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  c character varying(5);
  cc character varying(256);
  cryptocurrencies varchar(256)[] := array['BTC'];
BEGIN

FOR c IN SELECT symbol FROM p2p.currencies LOOP
  FOREACH cc IN ARRAY cryptocurrencies LOOP

  UPDATE p2p.ads SET status='pause'
  WHERE cryptocurrency=cc
    AND paymethod IN (SELECT id FROM p2p.payment_method WHERE currency=c)
    AND (rate_value > (SELECT value FROM p2p.rates r WHERE r.default_rate=true AND r.cryptocurrency_code=cc AND r.currency_symbol=c) * 1.2
      OR rate_value < (SELECT value FROM p2p.rates r WHERE r.default_rate=true AND r.cryptocurrency_code=cc AND r.currency_symbol=c) * 0.8);

  END LOOP;
END LOOP;

END;
$$;


ALTER FUNCTION p2p.disable_ads() OWNER TO bitzlato;

--
-- Name: get_user_trading_stat_in_fiat_equiv(integer, character varying); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.get_user_trading_stat_in_fiat_equiv(p_user_id integer, p_currency character varying) RETURNS TABLE(cc_code character varying, sold numeric, bought numeric, deposit numeric, withdrawal numeric, saved_by_free_trade numeric, saved_by_vouchers numeric, total_deals integer, success_deals integer)
    LANGUAGE sql
    SET search_path TO 'p2p', 'public'
    AS $$
select cc_code,
       sold * fiat.value                sold,
       bought * fiat.value              bought,
       deposit * fiat.value             deposit,
       withdrawal * fiat.value          withdrawal,
       saved_by_free_trade * fiat.value saved_by_free_trade,
       saved_by_wvouchers * fiat.value  saved_by_vouchers,
       total_count                      total_deals,
       success_deals                    success_deals
from trade_statistic ts
         join cryptocurrency_settings cs
              on ts.cc_code = cs.code
                  and not cs.is_delisted
         left join lateral (select value
                            from rate r
                                     left join user_rate ur
                                               on r.id = ur.rate_id
                                                   and ur.user_id = ts.user_id
                            where r.currency_symbol = p_currency
                              and (ur.user_id notnull or default_rate)
                              and r.cc_code = ts.cc_code
                            order by ur.user_id nulls last
                            limit 1
    ) fiat on true
where ts.user_id = p_user_id;
$$;


ALTER FUNCTION p2p.get_user_trading_stat_in_fiat_equiv(p_user_id integer, p_currency character varying) OWNER TO bitzlato;

--
-- Name: get_withdrawal_fee_and_limits(character varying, numeric, numeric); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.get_withdrawal_fee_and_limits(p_cc_code character varying, p_balance numeric, p_amount_to_withdraw numeric, OUT p_min_fee_amount numeric, OUT p_max_fee_amount numeric, OUT p_fee_amount numeric, OUT p_max_withdrawal_amount numeric) RETURNS record
    LANGUAGE sql
    SET search_path TO 'p2p'
    AS $$
with x as materialized (
    select numrange(lower(op_amount), p_balance - fee_amount, '(]') + op_amount can_withdraw,
           p_balance - fee_amount                                               max_withdraw,
           fee_amount
    from rate_plan_withdraw rpw
    where act_during @> localtimestamp
      and rpw.cc_code = p_cc_code
      and p_balance > fee_amount
      and (p_balance >= p_amount_to_withdraw or p_amount_to_withdraw is null)
      and numrange(0, p_balance - fee_amount, '(]') && op_amount
)
select min(fee_amount),
       max(fee_amount),
       max(fee_amount) filter ( where p_amount_to_withdraw <@ can_withdraw ),
       min(max_withdraw)
from x;
$$;


ALTER FUNCTION p2p.get_withdrawal_fee_and_limits(p_cc_code character varying, p_balance numeric, p_amount_to_withdraw numeric, OUT p_min_fee_amount numeric, OUT p_max_fee_amount numeric, OUT p_fee_amount numeric, OUT p_max_withdrawal_amount numeric) OWNER TO bitzlato;

--
-- Name: get_withdrawal_fee_range(character varying); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.get_withdrawal_fee_range(p_cc_code character varying) RETURNS TABLE(min numeric, max numeric)
    LANGUAGE sql
    SET search_path TO 'p2p'
    AS $$
select min(fee_amount), max(fee_amount)
from rate_plan_withdraw
where cc_code = p_cc_code
  and localtimestamp <@ act_during
$$;


ALTER FUNCTION p2p.get_withdrawal_fee_range(p_cc_code character varying) OWNER TO bitzlato;

--
-- Name: global_paymethods_delete(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.global_paymethods_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
		delete from p2p.payment_method where description = OLD.label;
		return OLD;

END $$;


ALTER FUNCTION p2p.global_paymethods_delete() OWNER TO bitzlato;

--
-- Name: global_paymethods_insert(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.global_paymethods_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 rc record;
BEGIN
	FOR rc IN SELECT symbol FROM p2p.currencies
	LOOP
		INSERT INTO p2p.payment_method (currency, description, i18n, weight, payments_group)
		VALUES (rc.symbol, NEW.label, json_build_object('ru', NEW.label), 0, NEW.payments_group) ON CONFLICT DO NOTHING;
	END LOOP;
	return NEW;

END $$;


ALTER FUNCTION p2p.global_paymethods_insert() OWNER TO bitzlato;

--
-- Name: global_paymethods_update(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.global_paymethods_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
		update p2p.payment_method SET description = NEW.label, i18n = json_build_object('ru', NEW.label) where description = OLD.label;
		return NEW;

END $$;


ALTER FUNCTION p2p.global_paymethods_update() OWNER TO bitzlato;

--
-- Name: handle_features_adding(character varying[]); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.handle_features_adding(codes character varying[]) RETURNS TABLE(codes_to_add character varying[], error_code_required character varying[], error_code_second_level character varying[])
    LANGUAGE sql
    SET search_path TO 'p2p'
    AS $$
with to_add as (
    select unnest(codes) code
)

select array_agg(distinct root.code)                                                codes_to_add,

       array_agg(distinct req.code)
       filter (where req.code is not null)                                          error_code_require,

       array_agg(req.required_feature_code)
       filter (where not req.required_feature_code = any(select * from to_add) )    error_code_second_level

from p2p.feature root
         left join p2p.feature req on root.required_feature_code = req.code

    and req.code not in (select * from to_add)

where root.code in (select * from to_add)
    ;
$$;


ALTER FUNCTION p2p.handle_features_adding(codes character varying[]) OWNER TO bitzlato;

--
-- Name: heal_old_data_after_merge(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.heal_old_data_after_merge() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  tgid character varying(256);
  old_uid integer;
BEGIN

FOR old_uid, tgid IN SELECT id as old_uid, regexp_replace(telegram_id, 'deleted_{?(\d+)}?', '\1') as tgid
            FROM public.users
            WHERE telegram_id LIKE 'deleted_%' AND NOT telegram_id LIKE '%todel' LOOP

  UPDATE p2p.old_data_profile
  SET user_id=(SELECT id FROM public.users WHERE telegram_id=tgid)
  WHERE user_id=old_uid;

END LOOP;
END;
$$;


ALTER FUNCTION p2p.heal_old_data_after_merge() OWNER TO bitzlato;

--
-- Name: heal_reg_after_merge(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.heal_reg_after_merge() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  tgid character varying(256);
  old_uid integer;
  new_uid integer;
  old_reg timestamp;
  new_reg timestamp;
BEGIN

  FOR old_uid, tgid IN SELECT id as old_uid, regexp_replace(telegram_id, 'deleted_{?(\d+)}?', '\1') as tgid
              FROM public.users
              WHERE telegram_id LIKE 'deleted_%' AND NOT telegram_id LIKE '%todel' LOOP
  
    SELECT id
    FROM public.users
    WHERE telegram_id = tgid
    INTO new_uid;

    SELECT start_of_use_date
    FROM p2p.user_profile
    WHERE user_id = old_uid
    INTO old_reg;
  
    SELECT start_of_use_date
    FROM p2p.user_profile
    WHERE user_id = new_uid
    INTO new_reg;

    RAISE NOTICE 'Old_uid %, New_uid % within % and % = %', old_uid, new_uid, old_reg, new_reg, least(old_reg, new_reg);


    UPDATE p2p.user_profile
    SET start_of_use_date = least(old_reg, new_reg)
    WHERE user_id=new_uid;
  END LOOP;
END;
$$;


ALTER FUNCTION p2p.heal_reg_after_merge() OWNER TO bitzlato;

--
-- Name: heal_vouchers_after_merge(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.heal_vouchers_after_merge() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  tgid character varying(256);
  old_uid integer;
BEGIN

FOR old_uid, tgid IN SELECT id as old_uid, regexp_replace(telegram_id, 'deleted_{?(\d+)}?', '\1') as tgid
            FROM public.users
            WHERE telegram_id LIKE 'deleted_%' AND NOT telegram_id LIKE '%todel' LOOP

  UPDATE p2p.voucher
  SET user_id=(SELECT id FROM public.users WHERE telegram_id=tgid)
  WHERE user_id=old_uid;

  UPDATE p2p.voucher
  SET cashed_by_user_id=(SELECT id FROM public.users WHERE telegram_id=tgid)
  WHERE cashed_by_user_id=old_uid;

END LOOP;
END;
$$;


ALTER FUNCTION p2p.heal_vouchers_after_merge() OWNER TO bitzlato;

--
-- Name: hold_to_balance(integer, public.cryptocurrency_code, numeric, text, p2p.operation_source, character varying); Type: FUNCTION; Schema: p2p; Owner: vanch
--

CREATE FUNCTION p2p.hold_to_balance(userid integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
  wallet_id integer;

BEGIN
  SELECT id
  FROM public.wallet
  WHERE user_id = userid
    AND cc_code = cc
  INTO wallet_id;

  UPDATE public.wallet
  SET balance = balance + amount
  WHERE id = wallet_id;

  UPDATE public.wallet
  SET hold_balance = hold_balance - amount
  WHERE id = wallet_id;

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
    wallet_id,
    (SELECT balance FROM public.wallet WHERE id = wallet_id),
    (SELECT hold_balance FROM public.wallet WHERE id = wallet_id),
    cause,
    amount,
    cc,
    source_type,
    'unhold',
    platform
  );

END;
$$;


ALTER FUNCTION p2p.hold_to_balance(userid integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, platform character varying) OWNER TO vanch;

--
-- Name: hold_to_null(integer, integer, bigint, text); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.hold_to_null(user_from integer, currency integer, amount bigint, cause text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
  wallet_from integer;
BEGIN
  EXECUTE 'SELECT id
           FROM public.wallets
           WHERE user_id = $1
           AND   currency = $2'
  INTO wallet_from
  USING user_from, currency;

  EXECUTE 'UPDATE public.wallets
           SET hold_balance = hold_balance - $2
           WHERE id = $1'
  USING wallet_from, amount;

  INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
  VALUES (wallet_from,
          format('Release %s satoshi to null', amount),
          (SELECT balance FROM public.wallets WHERE id = wallet_from),
          (SELECT hold_balance FROM public.wallets WHERE id = wallet_from),
          cause);
END;
$_$;


ALTER FUNCTION p2p.hold_to_null(user_from integer, currency integer, amount bigint, cause text) OWNER TO bitzlato;

--
-- Name: hold_to_null(integer, public.cryptocurrency_code, numeric, text, p2p.operation_source, character varying); Type: FUNCTION; Schema: p2p; Owner: vanch
--

CREATE FUNCTION p2p.hold_to_null(userid integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
  wallet integer;

BEGIN
  SELECT id
  FROM public.wallets
  WHERE user_id = userid
    AND cc_code = cc
  INTO wallet;

  UPDATE public.wallets
  SET hold_balance = hold_balance - amount
  WHERE id = wallet;

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
    wallet,
    (SELECT balance FROM public.wallets WHERE id = wallet),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet),
    cause,
    amount,
    cc,
    source_type,
    'outgoing',
    platform
  );

END;
$$;


ALTER FUNCTION p2p.hold_to_null(userid integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, platform character varying) OWNER TO vanch;

--
-- Name: money_to_hold(integer, public.cryptocurrency_code, numeric, text, p2p.operation_source, integer, character varying); Type: FUNCTION; Schema: p2p; Owner: vanch
--

CREATE FUNCTION p2p.money_to_hold(userid integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
  wallet_id integer;

BEGIN
  SELECT id
  FROM public.wallet
  WHERE user_id = userid
    AND cc_code = cc
  INTO wallet_id;

  UPDATE public.wallet
  SET balance = balance - amount
  WHERE id = wallet_id;

  UPDATE public.wallet
  SET hold_balance = hold_balance + amount
  WHERE id = wallet_id;

  INSERT INTO p2p.wallet_log(
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    amount,
    currency,
    source_type,
    source_id,
    operation_type,
    platform
  ) VALUES (
    wallet_id,
    (SELECT balance FROM public.wallet WHERE id = wallet_id),
    (SELECT hold_balance FROM public.wallet WHERE id = wallet_id),
    cause,
    amount,
    cc,
    source_type,
    source_id,
    'hold',
    platform
  );

END;
$$;


ALTER FUNCTION p2p.money_to_hold(userid integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) OWNER TO vanch;

--
-- Name: move_money(integer, integer, integer, bigint, text); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.move_money(user_from integer, user_to integer, cc integer, amount bigint, cause text) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
  wallet_from integer;
  wallet_to integer;
  cc_code varchar(10);

BEGIN
  SELECT code
  FROM public.cryptocurrency
  WHERE int_code = cc
  INTO cc_code;

  SELECT id
  FROM public.wallets
  WHERE user_id = user_from
    AND currency = cc
  INTO wallet_from;

  SELECT id
  FROM public.wallets
  WHERE user_id = user_to
    AND currency = cc
  INTO wallet_to;

  UPDATE public.wallets
  SET balance = balance - amount
  WHERE id = wallet_from;

  INSERT INTO p2p.wallet_log (
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    currency,
    amount,
    source_type,
    operation_type,
    platform
  ) VALUES (
    wallet_from,
    (SELECT balance FROM public.wallets WHERE id = wallet_from),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_from),
    cause,
    cc_code,
    (amount / 100000000::numeric)::numeric(1000, 10),
    'direct',
    'outgoing',
    'admin'
  );

  UPDATE public.wallets
  SET balance = balance + amount
  WHERE id = wallet_to;

  INSERT INTO p2p.wallet_log (
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    currency,
    amount,
    source_type,
    operation_type,
    platform
  ) VALUES (
    wallet_to,
    (SELECT balance FROM public.wallets WHERE id = wallet_to),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_to),
    cause,
    cc_code,
    (amount / 100000000::numeric)::numeric(1000, 10),
    'direct',
    'incoming',
    'admin'
  );
END;
$$;


ALTER FUNCTION p2p.move_money(user_from integer, user_to integer, cc integer, amount bigint, cause text) OWNER TO bitzlato;

--
-- Name: move_money(integer, integer, integer, numeric, text, p2p.operation_source, integer, character varying); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.move_money(user_from integer, user_to integer, cc integer, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
  wallet_from integer;
  wallet_to integer;
  cc_code character varying(4);

BEGIN
  SELECT id
  FROM public.wallets
  WHERE user_id = user_from
    AND currency = cc
  INTO wallet_from;

  SELECT id
  FROM public.wallets
  WHERE user_id = user_to
    AND currency = cc
  INTO wallet_to;

  SELECT code
  FROM public.cryptocurrency
  WHERE int_code = cc
  INTO cc_code;

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
    source_id,
    operation_type,
    platform
  ) VALUES (
    wallet_from,
    (SELECT balance FROM public.wallets WHERE id = wallet_from),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_from),
    cause,
    (amount / 100000000::numeric)::numeric(1000, 10),
    cc_code,
    source_type,
    source_id,
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
    source_id,
    operation_type,
    platform
  ) VALUES (
    wallet_to,
    (SELECT balance FROM public.wallets WHERE id = wallet_to),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_to),
    cause,
    (amount::numeric / 100000000::numeric)::numeric(1000, 10),
    cc_code,
    source_type,
    source_id,
    'incoming',
    platform
  );
END;
$$;


ALTER FUNCTION p2p.move_money(user_from integer, user_to integer, cc integer, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) OWNER TO bitzlato;

--
-- Name: move_money(integer, integer, public.cryptocurrency_code, numeric, text, p2p.operation_source, integer, character varying); Type: FUNCTION; Schema: p2p; Owner: vanch
--

CREATE FUNCTION p2p.move_money(user_from integer, user_to integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) RETURNS void
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
    source_id,
    operation_type,
    platform
  ) VALUES (
    wallet_from,
    (SELECT balance FROM public.wallets WHERE id = wallet_from),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_from),
    cause,
    (amount / 100000000::numeric)::numeric(1000, 10),
    cc,
    source_type,
    source_id,
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
    source_id,
    operation_type,
    platform
  ) VALUES (
    wallet_to,
    (SELECT balance FROM public.wallets WHERE id = wallet_to),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_to),
    cause,
    (amount::numeric / 100000000::numeric)::numeric(1000, 10),
    cc,
    source_type,
    source_id,
    'incoming',
    platform
  );
END;
$$;


ALTER FUNCTION p2p.move_money(user_from integer, user_to integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) OWNER TO vanch;

--
-- Name: move_user(integer, integer); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.move_user(from_id integer, to_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  wallet RECORD;
  cc_stat RECORD;
  wallet_id integer;
  from_public_name character varying;
BEGIN

FOR wallet IN SELECT currency FROM public.wallets WHERE user_id = from_id LOOP

  SELECT id INTO wallet_id
  FROM public.wallets
  WHERE user_id = to_id AND currency = wallet.currency;

  IF wallet_id IS NULL THEN
    INSERT INTO public.wallets (user_id, currency) VALUES (to_id, wallet.currency);
  END IF;

  UPDATE public.wallets
  SET balance = balance + (SELECT balance + hold_balance
                           FROM public.wallets
                           WHERE user_id = from_id AND currency = wallet.currency)
  WHERE user_id = to_id AND currency = wallet.currency;

  UPDATE public.wallets
  SET balance = 0,
      hold_balance = 0
  WHERE user_id = from_id AND currency = wallet.currency;

END LOOP;

FOR cc_stat IN SELECT * FROM p2p.trade_statistic WHERE user_id = from_id LOOP

  INSERT INTO p2p.trade_statistic AS ts (user_id,
                                         cryptocurrency,
                                         total_count,
                                         total_amount,
                                         success_deals,
                                         canceled_deals,
                                         defeat_in_dispute,
                                         positive_feedbacks_count,
                                         negative_feedbacks_count)
  VALUES (to_id,
          cc_stat.cryptocurrency,
          cc_stat.total_count,
          cc_stat.total_amount,
          cc_stat.success_deals,
          cc_stat.canceled_deals,
          cc_stat.defeat_in_dispute,
          cc_stat.positive_feedbacks_count,
          cc_stat.negative_feedbacks_count)
  
  ON CONFLICT (user_id, cryptocurrency) DO UPDATE 
  SET total_count = ts.total_count + cc_stat.total_count,
      total_amount = ts.total_amount + cc_stat.total_amount,
      success_deals = ts.success_deals + cc_stat.success_deals,
      canceled_deals = ts.canceled_deals + cc_stat.canceled_deals,
      defeat_in_dispute = ts.defeat_in_dispute + cc_stat.defeat_in_dispute,
      positive_feedbacks_count = ts.positive_feedbacks_count + cc_stat.positive_feedbacks_count,
      negative_feedbacks_count = ts.negative_feedbacks_count + cc_stat.negative_feedbacks_count;

END LOOP;


UPDATE public.users
SET ref_parent_user_id = to_id
WHERE ref_parent_user_id = from_id AND id != ref_parent_user_id;

UPDATE public.users
SET ref_parent_user_id = (SELECT ref_parent_user_id FROM public.users WHERE id = from_id),
    created_at = (SELECT created_at FROM public.users WHERE id = from_id)
WHERE id = to_id;

UPDATE p2p.feedbacks
SET for_user_id = to_id
WHERE for_user_id = from_id;

UPDATE p2p.user_block
SET user_id = to_id
WHERE user_id = from_id;

UPDATE p2p.user_block
SET blocked_user_id = to_id
WHERE blocked_user_id = from_id;

UPDATE p2p.user_trust
SET user_id = to_id
WHERE user_id = from_id;

UPDATE p2p.user_trust
SET trusted_user_id = to_id
WHERE trusted_user_id = from_id;

UPDATE p2p.notebook
SET user_id = to_id
WHERE user_id = from_id;

UPDATE p2p.withdraw_vouchers
SET user_id = to_id
WHERE user_id = from_id
  AND used_at IS NULL
  AND expire_at > now();

UPDATE p2p.user_profile
SET about_user = concat('?????????????????? ?? ', from_id, '. ', (SELECT about_user FROM p2p.user_profile WHERE user_id = from_id), ' ', about_user),
    rating = rating + (SELECT rating FROM p2p.user_profile WHERE user_id = from_id),
    start_of_use_date = (SELECT start_of_use_date FROM p2p.user_profile WHERE user_id = from_id)
WHERE user_id = to_id;

UPDATE p2p.user_profile
SET about_user = concat('?????????????????? ???? ', to_id, '.', about_user)
WHERE user_id = from_id;

SELECT public_name
FROM p2p.user_profile
WHERE user_id = from_id
INTO from_public_name;

IF from_public_name IS NOT NULL THEN
  UPDATE p2p.user_profile SET public_name = NULL WHERE user_id = from_id;
  UPDATE p2p.user_profile SET public_name = from_public_name WHERE user_id = to_id;
END IF;

END;
$$;


ALTER FUNCTION p2p.move_user(from_id integer, to_id integer) OWNER TO bitzlato;

--
-- Name: recreate_payment(integer); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.recreate_payment(payment_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
  amount bigint;
  wallet_id integer;
BEGIN

  EXECUTE 'SELECT wallet_id, amount + fee FROM public.payments WHERE status = 5 AND id = $1'
  INTO wallet_id, amount
  USING payment_id;

  EXECUTE 'UPDATE public.wallets 
           SET hold_balance = hold_balance + $1
           WHERE id = $2'
  USING amount, wallet_id;

  EXECUTE 'UPDATE public.payments
           SET status = 1
           WHERE id = $1'
  USING payment_id;

  INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
  VALUES (wallet_id,
          format('Get %s hold back and restart payment %s', amount, payment_id),
          (SELECT balance FROM public.wallets WHERE id = wallet_id),
          (SELECT hold_balance FROM public.wallets WHERE id = wallet_id),
          format('Restart payment'));
END;
$_$;


ALTER FUNCTION p2p.recreate_payment(payment_id integer) OWNER TO bitzlato;

--
-- Name: release_banned_balances(timestamp without time zone); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.release_banned_balances(up_to_date timestamp without time zone DEFAULT now()) RETURNS void
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

  FOR wallet IN SELECT w.id,
                       w.currency,
                       w.balance,
                       w.hold_balance
                FROM public.wallets w
                INNER JOIN p2p.user_profile up
                        ON w.user_id = up.user_id
                WHERE up.blocked_by_admin = true
                  AND w.balance > 0
                  AND up.lastactivity < up_to_date LOOP

    UPDATE public.wallets
    SET balance = 0
    WHERE id = wallet.id;

    INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
    VALUES (wallet.id,
            format('Withdraw from wallet balance %s in satoshi', wallet.balance),
            0,
            wallet.hold_balance,
            'Releasing balances of blocked users');

    UPDATE public.wallets
    SET balance = balance + wallet.balance
    WHERE user_id = system_uid
      AND currency = wallet.currency;

    INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
    VALUES ((SELECT id FROM public.wallets WHERE user_id = system_uid AND currency = wallet.currency),
            format('Add to wallet balance %s in satoshi', wallet.balance),
            (SELECT balance FROM public.wallets WHERE user_id = system_uid AND currency = wallet.currency),
            (SELECT hold_balance FROM public.wallets WHERE user_id = system_uid AND currency = wallet.currency),
            'Releasing balances of blocked users');
  END LOOP;
END;
$$;


ALTER FUNCTION p2p.release_banned_balances(up_to_date timestamp without time zone) OWNER TO bitzlato;

--
-- Name: release_debt(integer, integer, integer, numeric, text, p2p.operation_source, integer, character varying); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.release_debt(user_from integer, user_to integer, cc integer, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
  wallet_from integer;
  wallet_to integer;
  cc_code character varying(4);

BEGIN
  SELECT id
  FROM public.wallets
  WHERE user_id = user_from
    AND currency = cc
  INTO wallet_from;

  SELECT id
  FROM public.wallets
  WHERE user_id = user_to
    AND currency = cc
  INTO wallet_to;

  SELECT code
  FROM public.cryptocurrency
  WHERE int_code = cc
  INTO cc_code;

  UPDATE public.wallets
  SET hold_balance = hold_balance - amount
  WHERE id = wallet_from;

  INSERT INTO p2p.wallet_log(
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    amount,
    currency,
    source_type,
    source_id,
    operation_type,
    platform
  ) VALUES (
    wallet_from,
    (SELECT balance FROM public.wallets WHERE id = wallet_from),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_from),
    cause,
    (amount / 100000000::numeric)::numeric(1000, 10),
    cc_code,
    source_type,
    source_id,
    'unhold',
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
    source_id,
    operation_type,
    platform
  ) VALUES (
    wallet_to,
    (SELECT balance FROM public.wallets WHERE id = wallet_to),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_to),
    cause,
    (amount::numeric / 100000000::numeric)::numeric(1000, 10),
    cc_code,
    source_type,
    source_id,
    'incoming',
    platform
  );
END;
$$;


ALTER FUNCTION p2p.release_debt(user_from integer, user_to integer, cc integer, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) OWNER TO bitzlato;

--
-- Name: release_debt(integer, integer, public.cryptocurrency_code, numeric, text, p2p.operation_source, integer, character varying); Type: FUNCTION; Schema: p2p; Owner: vanch
--

CREATE FUNCTION p2p.release_debt(user_from integer, user_to integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) RETURNS void
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
  SET hold_balance = hold_balance - amount
  WHERE id = wallet_from;

  INSERT INTO p2p.wallet_log(
    wallet_id,
    balance_at_the_moment,
    hold_balance_at_moment,
    cause,
    amount,
    currency,
    source_type,
    source_id,
    operation_type,
    platform
  ) VALUES (
    wallet_from,
    (SELECT balance FROM public.wallets WHERE id = wallet_from),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_from),
    cause,
    (amount / 100000000::numeric)::numeric(1000, 10),
    cc,
    source_type,
    source_id,
    'unhold',
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
    source_id,
    operation_type,
    platform
  ) VALUES (
    wallet_to,
    (SELECT balance FROM public.wallets WHERE id = wallet_to),
    (SELECT hold_balance FROM public.wallets WHERE id = wallet_to),
    cause,
    (amount::numeric / 100000000::numeric)::numeric(1000, 10),
    cc,
    source_type,
    source_id,
    'incoming',
    platform
  );
END;
$$;


ALTER FUNCTION p2p.release_debt(user_from integer, user_to integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) OWNER TO vanch;

--
-- Name: release_debts(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.release_debts() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  wallet RECORD;
BEGIN
FOR wallet IN SELECT id, balance, hold_balance, debt 
              FROM public.wallets 
              WHERE debt > 0 AND debt = hold_balance LOOP

  UPDATE public.wallets
  SET debt = 0
  WHERE id=wallet.id;

  INSERT INTO p2p.wallet_log (wallet_id, description, balance_at_the_moment, hold_balance_at_moment, cause)
  VALUES (wallet.id,
          format('Holding debt=%s', wallet.debt),
          wallet.balance,
          wallet.hold_balance,
          format('Holding debt'));
END LOOP;
END;
$$;


ALTER FUNCTION p2p.release_debts() OWNER TO bitzlato;

--
-- Name: remote_rate_value(integer, character varying, public.cryptocurrency_code); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.remote_rate_value(p_user_id integer, p_currency character varying, p_cc_code public.cryptocurrency_code) RETURNS numeric
    LANGUAGE sql
    SET search_path TO 'public', 'p2p'
    AS $$

select r.value
from RATE r
         left join user_rate ur on r.id = ur.rate_id and ur.user_id = p_user_id
where r.currency_symbol = p_currency
  and r.cc_code = p_cc_code
  and (ur.user_id is not null or r.default_rate)
order by ur.user_id nulls last
limit 1;

$$;


ALTER FUNCTION p2p.remote_rate_value(p_user_id integer, p_currency character varying, p_cc_code public.cryptocurrency_code) OWNER TO bitzlato;

--
-- Name: rep_finance_movement_100(integer); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.rep_finance_movement_100(p_user_id integer) RETURNS TABLE(amount numeric, cc_code character varying, operation_type character varying, source_type character varying, source_id character varying, date timestamp without time zone)
    LANGUAGE sql
    SET search_path TO 'p2p', 'public'
    AS $$
(
    select amount::numeric,
           t.cc_code,
           'Incoming',
           'Deposit',
           btx.txid,
           t.created_at
    from deposit t
    join blockchain_tx btx on blockchain_tx_id = btx.id
    where user_id = p_user_id
      and t.status = 'success'
)
union
(
    select amount::numeric,
           p.cc_code,
           'Outgoing',
           'Withdraw',
           btx.txid,
           p.created_at
    from withdrawal p
    left join blockchain_tx btx on blockchain_tx_id = btx.id
    where user_id = p_user_id
      and p.status = 'processed'
)
union
(
    select fee::numeric,
           p2.cc_code,
           'Outgoing',
           'Withdraw Fee',
           btx.txid,
           p2.created_at
    from withdrawal p2
    left join blockchain_tx btx on blockchain_tx_id = btx.id
    where user_id = p_user_id
      and p2.status = 'processed'
      and fee > 0
)
union
(
    select amount,
           cc_code,
           case when user_id = p_user_id then 'Outgoing' else 'Incoming' end,
           'Voucher',
           'c_' || secret_key,
           cashed_at
    from voucher
    where (user_id = p_user_id or cashed_by_user_id = p_user_id)
      and deleted_at is null
      and cashed_at is not null
)
union
(
    select crypto_amount,
           cc_code,
           'Incoming',
           'Referral Bonus',
           case
               when trade_id is not null then 'Trade id #' || trade_id
               else 'Order id #' || order_id
               end,
           date
    from referal_bonus rb
    where ref_parent_user_id = p_user_id
)
union
(
    select cryptoamount,
           cc_code,
           case when crypto_buyer = p_user_id then 'Incoming' else 'Outgoing' end,
           'Trade',
           id::varchar,
           trade.created_at
    from trade
    where status = 'confirm-payment'::trade_state
      and (crypto_buyer = p_user_id or crypto_seller = p_user_id)
)
union
(
    select tips_amount,
           cc_code,
           case
               when crypto_buyer = p_user_id and ad_type = 'purchase'::ads_type or
                    crypto_seller = p_user_id and ad_type = 'selling'::ads_type
                   then 'Incoming'
               else
                   'Outgoing' end,
           'Trade Tips',
           id::varchar,
           created_at
    from trade
    where status = 'confirm-payment'::trade_state
      and (crypto_buyer = p_user_id or
           crypto_seller = p_user_id)
      and tips_payed
)
union
(
    select amount,
           cc_code,
           'Incoming',
           'Payment from merchant',
           id::varchar,
           date
    from mer.payment
    where user_id = p_user_id and status = 'done'
)
order by 6 desc;
$$;


ALTER FUNCTION p2p.rep_finance_movement_100(p_user_id integer) OWNER TO bitzlato;

--
-- Name: rep_referral_104(integer); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.rep_referral_104(rep_user_id integer) RETURNS TABLE(type character varying, referral_id integer, referral_name character varying, amount_crypto numeric, cc_code character varying, amount_usd numeric, referral_type p2p.referral_type, date timestamp without time zone)
    LANGUAGE sql
    SET search_path TO 'p2p', 'public'
    AS $$
(
    select 'New referral',
           id,
           (select coalesce(public_name, generated_name) from p2p.user_profile p where p.user_id = u.id),
           0,
           '-',
           0,
           ref_type,
           (select date from (values (u.created_at, m.date_of_merge)) m(date) order by date)
    from "user" u
             left join p2p.merge m on u.id = m.telegram_account_user_id or u.id = m.web_account_user_id
    where ref_parent_user_id = rep_user_id
      and id != rep_user_id
      and u.deleted_at is null
)
UNION
(
    select 'Referral payment',
           p.user_id,
           coalesce(p.public_name, p.generated_name),
           rb.crypto_amount,
           rb.cc_code,
           rb.crypto_amount * r.value,
           (select ref_type from "user" u where u.id = p.user_id),
           rb.date
    from referal_bonus rb
             left join merge m on rb.referal_id = m.web_account_user_id or rb.referal_id = m.telegram_account_user_id
             left join user_profile p on
            p.user_id = m.web_account_user_id or p.user_id = m.telegram_account_user_id or p.user_id = rb.referal_id
             join rate r
                  on r.currency_symbol = 'USD' and r.cc_code = rb.cc_code and default_rate

    where rb.ref_parent_user_id = rep_user_id
)
ORDER BY 8 DESC;
$$;


ALTER FUNCTION p2p.rep_referral_104(rep_user_id integer) OWNER TO bitzlato;

--
-- Name: rep_trade_history_101(integer); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.rep_trade_history_101(p_user_id integer) RETURNS TABLE(id integer, crypto_amount numeric, fiat_amount numeric, exchange_rate numeric, buyer integer, seller integer, type p2p.ads_type, status p2p.trade_state, cc_code character varying, currency character varying, fee numeric, payment_method character varying, date timestamp without time zone)
    LANGUAGE sql
    SET search_path TO 'p2p', 'public'
    AS $$
select id,
       cryptoamount,
       amount,
       ad_rate,
       crypto_buyer,
       crypto_seller,
       ad_type,
       status,
       cc_code,
       currency,
       case
           when status != 'confirm-payment'::trade_state then 0
           when p_user_id = crypto_buyer then fee_buyer
           else fee_seller end,
       (select description from payment_method where id = t.ad_paymethod)                "paymethod",
       (select date from trade_history where trade_id = t.id order by date desc limit 1) "last_action_date"
from trade t
where crypto_buyer = p_user_id
   or crypto_seller = p_user_id
order by last_action_date desc, id desc;
$$;


ALTER FUNCTION p2p.rep_trade_history_101(p_user_id integer) OWNER TO bitzlato;

--
-- Name: rep_vouchers_102(integer); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.rep_vouchers_102(p_user_id integer) RETURNS TABLE(amount numeric, cc_code character varying, currency character varying, giver integer, recipient integer, status character varying, voucher_code character varying, comment character varying, cashed_at timestamp without time zone, created_at timestamp without time zone)
    LANGUAGE sql
    SET search_path TO 'p2p', 'public'
    AS $$
select amount,
       cc_code,
       currency,
       user_id,
       cashed_by_user_id,
       case when cashed_at is null then 'created' else 'cashed' end,
       secret_key,
       case when p_user_id = cashed_by_user_id then comment_by_cashed_user else comment end,
       cashed_at,
       created_at
from voucher
where deleted_at is null
  and (user_id = p_user_id or cashed_by_user_id = p_user_id)
order by created_at desc, id desc
$$;


ALTER FUNCTION p2p.rep_vouchers_102(p_user_id integer) OWNER TO bitzlato;

--
-- Name: rep_wallet_history_103(integer); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.rep_wallet_history_103(p_user_id integer) RETURNS TABLE(type character varying, amount numeric, cc_code character varying, fee numeric, address character varying, transaction character varying, comment character varying, date timestamp without time zone)
    LANGUAGE sql
    SET search_path TO 'p2p', 'public'
    AS $$
(
    select 'Receive',
           amount::numeric,
           t.cc_code,
           fee::numeric,
           address,
           txid,
           comment,
           t.created_at
    from deposit t
    join blockchain_tx btx on blockchain_tx_id = btx.id
    where user_id = p_user_id
      and t.status = 'success'
)
union all
(
    select 'Send',
           amount,
           p.cc_code,
           fee,
           address,
           txid,
           comment,
           p.created_at
    from withdrawal p
    left join blockchain_tx btx on blockchain_tx_id = btx.id
    where user_id = p_user_id
      and p.status = 'processed'
)
union all
(
    select 'Referral Payment',
           crypto_amount,
           cc_code,
           0,
           '',
           '',
           '',
           date
    from referal_bonus
    where ref_parent_user_id = p_user_id
)
union all
(
    select 'Tips ' || case when trade_initiator = p_user_id then 'outgoing' else 'incoming' end,
           tips_amount,
           cc_code,
           0,
           'Trade id #' || id,
           '',
           '',
           created_at
    from trade t
    where tips_payed
      and (crypto_seller = p_user_id or crypto_buyer = p_user_id)
)
union all
(
    select 'Payment via merchant',
           amount,
           cc_code,
           0,
           (select name
            from mer.merchant m
                     join mer.invoice i on i.merchant_id = m.id
            where i.id = mt.invoice_id),
           'Invoice ID ' || invoice_id,
           '',
           created_at
    from mer.invoice_transaction mt
    where user_id = p_user_id
)
union all
(
    select 'Payment from merchant',
           amount,
           cc_code,
           0,
           (select name from mer.merchant m where m.id = mp.merchant_id),
           '',
           '',
           date
    from mer.payment mp
    where user_id = p_user_id and status = 'done'
)
order by 8 desc;
$$;


ALTER FUNCTION p2p.rep_wallet_history_103(p_user_id integer) OWNER TO bitzlato;

--
-- Name: set_merged_after_merge(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.set_merged_after_merge() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  tgid character varying(256);
BEGIN

  FOR tgid IN SELECT regexp_replace(telegram_id, 'deleted_{?(\d+)}?', '\1') as tgid
              FROM public.users
              WHERE telegram_id LIKE 'deleted_%' AND NOT telegram_id LIKE '%todel' LOOP
  
    UPDATE p2p.user_profile
    SET merged=true
    WHERE user_id=(SELECT id FROM public.users WHERE telegram_id=tgid);
  END LOOP;
END;
$$;


ALTER FUNCTION p2p.set_merged_after_merge() OWNER TO bitzlato;

--
-- Name: store_audit_json(); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.store_audit_json() RETURNS jsonb
    LANGUAGE sql
    SET search_path TO 'p2p', 'public'
    AS $$
insert into audit(audit_json)
select jsonb_object_agg(s.cryptocurrency,
                        jsonb_build_object(
                            'totalIn', s.total_in,
                            'totalDustIn', s.total_dust_in,
                            'totalOut', s.total_out,
                            'totalAudit', s.total_in - s.total_out - s.total_wallets,
                            'totalWallets', s.total_wallets,
                            'totalBalancesHolded', s.total_balances_holded,
                            'totalBalancesFree', s.total_balances_free,
                            'pendingPayments', s.pending_payments,
                            'totalNetworkFee', s.total_network_fee,
                            'systemWalletBalance', s.system_wallet_balance,
                            'realColdWalletBalance', s.real_cold_wallet_balance,
                            'systemHotWalletBalance', s.hot_wallet_balance,
                            'hotWalletUnconfirmedBalance', s.hot_wallet_unconfirmed_balance,
                            'totalWalletsColdAndHot',
                            s.hot_wallet_balance + s.real_cold_wallet_balance + s.cold_wallet_audit_adjust,
                            'coldWalletAdjust', s.cold_wallet_audit_adjust,
                            'debt', s.debt
                            )
           )
from vw_audit_source s
returning audit_json;
$$;


ALTER FUNCTION p2p.store_audit_json() OWNER TO bitzlato;

--
-- Name: to_seconds(text); Type: FUNCTION; Schema: p2p; Owner: bitzlato
--

CREATE FUNCTION p2p.to_seconds(t text) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
DECLARE 
    hs INTEGER;
    ms INTEGER;
    s INTEGER;
BEGIN
    SELECT (EXTRACT( HOUR FROM  t::time) * 60*60) INTO hs; 
    SELECT (EXTRACT (MINUTES FROM t::time) * 60) INTO ms;
    SELECT (EXTRACT (SECONDS from t::time)) INTO s;
    SELECT (hs + ms + s) INTO s;
    RETURN s;
END;
$$;


ALTER FUNCTION p2p.to_seconds(t text) OWNER TO bitzlato;

--
-- Name: add_fake_balance(integer, integer, bigint); Type: FUNCTION; Schema: public; Owner: bitzlato
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


ALTER FUNCTION public.add_fake_balance(userid integer, cc integer, amount bigint) OWNER TO bitzlato;

--
-- Name: array_sort_unique(anyarray); Type: FUNCTION; Schema: public; Owner: zeppelin
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


ALTER FUNCTION public.array_sort_unique(anyarray) OWNER TO zeppelin;

--
-- Name: base58_encode(integer); Type: FUNCTION; Schema: public; Owner: bitzlato
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


ALTER FUNCTION public.base58_encode(num integer) OWNER TO bitzlato;

--
-- Name: change_wallet_address(integer, public.cryptocurrency_code, character varying, public.text_code, public.wallet_address_change_reason, character varying); Type: FUNCTION; Schema: public; Owner: bitzlato
--

CREATE FUNCTION public.change_wallet_address(p_acc_id integer, p_cc_code public.cryptocurrency_code, p_address character varying, p_admin_code public.text_code, p_reason public.wallet_address_change_reason, p_comment character varying, OUT r_old_address character varying) RETURNS character varying
    LANGUAGE sql
    AS $$
    with ins as (
         insert into wallet_address_hist (user_id,
                                          cryptocurrency_code,
                                          address,
                                          active_from,
                                          active_till,
                                          admin_code,
                                          reason,
                                          comment
             )
             select acc_id,
                    cc_code,
                    address,
                    created_at,
                    current_timestamp,
                    p_admin_code,
                    p_reason,
                    p_comment
             from wallet_address wa
             where true
               and wa.acc_id = p_acc_id
               and wa.cc_code = p_cc_code
             for update
        returning address
     ),
     upd as (
         update wallet_address
             set address = p_address
             from ins
             where true
                 and acc_id = p_acc_id
                 and cc_code = p_cc_code
             returning ins.address
     )
select upd.address
from upd;
$$;


ALTER FUNCTION public.change_wallet_address(p_acc_id integer, p_cc_code public.cryptocurrency_code, p_address character varying, p_admin_code public.text_code, p_reason public.wallet_address_change_reason, p_comment character varying, OUT r_old_address character varying) OWNER TO bitzlato;

--
-- Name: change_wallet_address_owner(integer, integer, public.cryptocurrency_code, public.text_code, public.wallet_address_change_reason, character varying); Type: FUNCTION; Schema: public; Owner: bitzlato
--

CREATE FUNCTION public.change_wallet_address_owner(p_acc_id integer, p_new_acc_id integer, p_cc_code public.cryptocurrency_code, p_admin_code public.text_code, p_reason public.wallet_address_change_reason, p_comment character varying, OUT r_address character varying) RETURNS character varying
    LANGUAGE sql
    AS $$
    with ins as (
         insert into wallet_address_hist (user_id,
                                          cryptocurrency_code,
                                          address,
                                          active_from,
                                          active_till,
                                          admin_code,
                                          reason,
                                          comment
             )
             select acc_id,
                    cc_code,
                    address,
                    created_at,
                    current_timestamp,
                    p_admin_code,
                    p_reason,
                    p_comment
             from wallet_address wa
             where true
               and wa.acc_id = p_acc_id
               and wa.cc_code = p_cc_code
             for update
        returning address
     ),
     upd as (
         update wallet_address
             set acc_id = p_new_acc_id
             from ins
             where true
                 and acc_id = p_acc_id
                 and cc_code = p_cc_code
             returning ins.address
     )
select upd.address
from upd;
$$;


ALTER FUNCTION public.change_wallet_address_owner(p_acc_id integer, p_new_acc_id integer, p_cc_code public.cryptocurrency_code, p_admin_code public.text_code, p_reason public.wallet_address_change_reason, p_comment character varying, OUT r_address character varying) OWNER TO bitzlato;

--
-- Name: create_partition_for_date(date, character varying); Type: FUNCTION; Schema: public; Owner: bitzlato
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


ALTER FUNCTION public.create_partition_for_date(p_date date, p_table character varying) OWNER TO bitzlato;

--
-- Name: drop_partition_for_date(date, character varying); Type: FUNCTION; Schema: public; Owner: bitzlato
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


ALTER FUNCTION public.drop_partition_for_date(p_date date, p_table character varying) OWNER TO bitzlato;

--
-- Name: drop_wallet_address(public.cryptocurrency_code, integer, public.text_code, public.wallet_address_change_reason, character varying); Type: FUNCTION; Schema: public; Owner: bitzlato
--

CREATE FUNCTION public.drop_wallet_address(p_cc_code public.cryptocurrency_code, p_acc_id integer, p_admin_code public.text_code, p_reason public.wallet_address_change_reason, p_comment character varying, OUT r_address character varying) RETURNS character varying
    LANGUAGE sql
    AS $$

with del as (
    delete from wallet_address
        where true
            and cc_code = p_cc_code
            and acc_id = p_acc_id
        returning *
),
     hist as (
         select acc_id,
                cc_code,
                address,
                created_at,
                current_timestamp,
                p_admin_code,
                p_reason,
                p_comment
         from del
     ),
     ins as (
         insert into wallet_address_hist (user_id,
                                          cryptocurrency_code,
                                          address,
                                          active_from,
                                          active_till,
                                          admin_code,
                                          reason,
                                          comment
             )
             select * from hist
             returning address
     )

select address
from ins

$$;


ALTER FUNCTION public.drop_wallet_address(p_cc_code public.cryptocurrency_code, p_acc_id integer, p_admin_code public.text_code, p_reason public.wallet_address_change_reason, p_comment character varying, OUT r_address character varying) OWNER TO bitzlato;

--
-- Name: drop_wallet_address(public.cryptocurrency_code, text, public.text_code, public.wallet_address_change_reason, character varying); Type: FUNCTION; Schema: public; Owner: bitzlato
--

CREATE FUNCTION public.drop_wallet_address(p_cc_code public.cryptocurrency_code, p_address text, p_admin_code public.text_code, p_reason public.wallet_address_change_reason, p_comment character varying, OUT r_acc_id integer) RETURNS integer
    LANGUAGE sql
    AS $$

with del as (
    delete from wallet_address
        where true
            and cc_code = p_cc_code
            and address = p_address
        returning *
),
     hist as (
         select acc_id,
                cc_code,
                address,
                created_at,
                current_timestamp,
                p_admin_code,
                p_reason,
                p_comment
         from del
     ),
     ins as (
         insert into wallet_address_hist (user_id,
                                          cryptocurrency_code,
                                          address,
                                          active_from,
                                          active_till,
                                          admin_code,
                                          reason,
                                          comment
             )
             select * from hist
             returning user_id
     )

select user_id
from ins

$$;


ALTER FUNCTION public.drop_wallet_address(p_cc_code public.cryptocurrency_code, p_address text, p_admin_code public.text_code, p_reason public.wallet_address_change_reason, p_comment character varying, OUT r_acc_id integer) OWNER TO bitzlato;

--
-- Name: first_agg(anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: bitzlato
--

CREATE FUNCTION public.first_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT $1;
$_$;


ALTER FUNCTION public.first_agg(anyelement, anyelement) OWNER TO bitzlato;

--
-- Name: get_partitions_for_date(character varying); Type: FUNCTION; Schema: public; Owner: bitzlato
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


ALTER FUNCTION public.get_partitions_for_date(p_table character varying) OWNER TO bitzlato;

--
-- Name: hold_to_balance(integer); Type: FUNCTION; Schema: public; Owner: bitzlato
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


ALTER FUNCTION public.hold_to_balance(payment_id integer) OWNER TO bitzlato;

--
-- Name: last_agg(anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: bitzlato
--

CREATE FUNCTION public.last_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT $2;
$_$;


ALTER FUNCTION public.last_agg(anyelement, anyelement) OWNER TO bitzlato;

--
-- Name: maintain_partitions_for_dates(integer, integer, text); Type: FUNCTION; Schema: public; Owner: bitzlato
--

CREATE FUNCTION public.maintain_partitions_for_dates(p_retain_days integer, p_in_advance_days integer, p_table text) RETURNS void
    LANGUAGE sql
    SET search_path TO 'public', '$user', 'public'
    AS $$
select create_partition_for_date(dt, p_table)
from (
       select current_date + delta.d dt
       from generate_series(-1, p_in_advance_days) delta(d)
       except
       select for_date
       from get_partitions_for_date(p_table)
     ) to_create;

select drop_partition_for_date(for_date, p_table)
from get_partitions_for_date(p_table)
where for_date < current_date - p_retain_days ;
$$;


ALTER FUNCTION public.maintain_partitions_for_dates(p_retain_days integer, p_in_advance_days integer, p_table text) OWNER TO bitzlato;

--
-- Name: mark_as_sent_and_release(); Type: FUNCTION; Schema: public; Owner: bitzlato
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


ALTER FUNCTION public.mark_as_sent_and_release() OWNER TO bitzlato;

--
-- Name: mark_as_sent_and_release_hold(integer); Type: FUNCTION; Schema: public; Owner: bitzlato
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


ALTER FUNCTION public.mark_as_sent_and_release_hold(payment_id integer) OWNER TO bitzlato;

--
-- Name: move_money(integer, integer, public.cryptocurrency_code, numeric, text, character varying); Type: FUNCTION; Schema: public; Owner: vanch
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


ALTER FUNCTION public.move_money(user_from integer, user_to integer, cc public.cryptocurrency_code, amount numeric, cause text, platform character varying) OWNER TO vanch;

--
-- Name: move_money(integer, integer, public.cryptocurrency_code, numeric, text, p2p.operation_source, character varying); Type: FUNCTION; Schema: public; Owner: vanch
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


ALTER FUNCTION public.move_money(user_from integer, user_to integer, cc public.cryptocurrency_code, amount numeric, cause text, source_type p2p.operation_source, platform character varying) OWNER TO vanch;

--
-- Name: null_txids_for_internal_txes(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.null_txids_for_internal_txes() OWNER TO postgres;

--
-- Name: register_dispute_video(public.text_code, integer, character varying); Type: FUNCTION; Schema: public; Owner: bitzlato
--

CREATE FUNCTION public.register_dispute_video(p_admin_code public.text_code, p_dispute_id integer, p_file_name character varying, OUT r_local_file_name text) RETURNS text
    LANGUAGE sql
    SET search_path TO 'public', 'p2p'
    AS $$
insert into dispute_video (id, admin_code, dispute_id, file_name)
select nextval(s), p_admin_code, p_dispute_id, currval(s) || '.' || p_file_name
from pg_get_serial_sequence('dispute_video', 'id') s
returning file_name;
$$;


ALTER FUNCTION public.register_dispute_video(p_admin_code public.text_code, p_dispute_id integer, p_file_name character varying, OUT r_local_file_name text) OWNER TO bitzlato;

--
-- Name: release_banned_balances(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.release_banned_balances() OWNER TO postgres;

--
-- Name: exchange_fee(daterange, integer[]); Type: FUNCTION; Schema: rep; Owner: bitzlato
--

CREATE FUNCTION rep.exchange_fee(period daterange, ignore_users_with_ids integer[]) RETURNS TABLE(crypto character varying, total_fee numeric)
    LANGUAGE sql STABLE SECURITY DEFINER PARALLEL SAFE
    SET search_path TO 'rep', 'ex', 'public'
    AS $$
with market_fee as (
    select ma.name, fee.*
    from markets_available ma
             join crypto_asset b on ma.base_asset = b.code
             join crypto_asset q on ma.quote_asset = q.code
             join lateral ( values (b.code, 'buy'::order_side),
                                   (q.code, 'sell'::order_side)
        ) fee(crypto, side) on true
    where ma.is_active
)
select crypto,
       sum(oeh.fee) total_fee
from orders_exec_hist oeh
         join orders o on oeh.order_id = o.id
    and period @> date_trunc('day', oeh.at)::date
    and fee > 0
    and oeh.user_id != all(ignore_users_with_ids)
         right join market_fee mf on o.pair = mf.name and o.side = mf.side
group by crypto
order by crypto
$$;


ALTER FUNCTION rep.exchange_fee(period daterange, ignore_users_with_ids integer[]) OWNER TO bitzlato;

--
-- Name: fill_public_names_pool(character varying[], character varying[], character varying[], character varying[], integer); Type: FUNCTION; Schema: sec; Owner: bitzlato
--

CREATE FUNCTION sec.fill_public_names_pool(p_prefix character varying[], p_postfix character varying[], p_first_name character varying[], p_adjectives character varying[], p_limit integer DEFAULT NULL::integer) RETURNS bigint
    LANGUAGE sql
    SET search_path TO 'sec'
    AS $$
with prefix(name) AS materialized (SELECT unnest(p_prefix)),
     postfix(name) AS materialized (SELECT unnest(p_postfix)),
     firstName(name) AS materialized (SELECT unnest(p_first_name)),
     adjectives(name) AS materialized (SELECT unnest(p_adjectives)),
     name_samples(name) as (
         select *
         from (
                  select adjectives.name || firstName.name || postfix.name
                  from adjectives,
                       firstName,
                       postfix
                  union all
                  select firstName.name || adjectives.name || postfix.name
                  from adjectives,
                       firstName,
                       postfix
                  union all
                  select prefix.name || firstName.name || adjectives.name
                  from adjectives,
                       firstName,
                       prefix
                  union all
                  select prefix.name || adjectives.name || firstName.name
                  from adjectives,
                       firstName,
                       prefix
                  union all
                  select prefix.name || firstName.name || postfix.name
                  from prefix,
                       firstName,
                       postfix
                  union all
                  select prefix.name || adjectives.name || postfix.name
                  from prefix,
                       adjectives,
                       postfix
              ) permut(name)
         where length(name) <= 28
         limit p_limit
     )
insert
into public_names_pool(name)
select * from (
                  select name
                  from name_samples
                      except
                  select name
                  from public_names_pool
              ) new_names
order by random()
on conflict do nothing;

select count(name) as free_count
from public_names_pool
where in_use_since is null;

$$;


ALTER FUNCTION sec.fill_public_names_pool(p_prefix character varying[], p_postfix character varying[], p_first_name character varying[], p_adjectives character varying[], p_limit integer) OWNER TO bitzlato;

--
-- Name: first(anyelement); Type: AGGREGATE; Schema: public; Owner: bitzlato
--

CREATE AGGREGATE public.first(anyelement) (
    SFUNC = public.first_agg,
    STYPE = anyelement
);


ALTER AGGREGATE public.first(anyelement) OWNER TO bitzlato;

--
-- Name: last(anyelement); Type: AGGREGATE; Schema: public; Owner: bitzlato
--

CREATE AGGREGATE public.last(anyelement) (
    SFUNC = public.last_agg,
    STYPE = anyelement
);


ALTER AGGREGATE public.last(anyelement) OWNER TO bitzlato;

--
-- Name: audit_user; Type: TABLE; Schema: cleanup; Owner: bitzlato
--

CREATE TABLE cleanup.audit_user (
    id integer NOT NULL,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    audit_json jsonb
);


ALTER TABLE cleanup.audit_user OWNER TO bitzlato;

--
-- Name: audit_users_id_seq; Type: SEQUENCE; Schema: cleanup; Owner: bitzlato
--

CREATE SEQUENCE cleanup.audit_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cleanup.audit_users_id_seq OWNER TO bitzlato;

--
-- Name: audit_users_id_seq; Type: SEQUENCE OWNED BY; Schema: cleanup; Owner: bitzlato
--

ALTER SEQUENCE cleanup.audit_users_id_seq OWNED BY cleanup.audit_user.id;


--
-- Name: auth_stats; Type: TABLE; Schema: cleanup; Owner: bitzlato
--

CREATE TABLE cleanup.auth_stats (
    id integer NOT NULL,
    user_id integer NOT NULL,
    ip integer,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE cleanup.auth_stats OWNER TO bitzlato;

--
-- Name: auth_stats_id_seq; Type: SEQUENCE; Schema: cleanup; Owner: bitzlato
--

CREATE SEQUENCE cleanup.auth_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cleanup.auth_stats_id_seq OWNER TO bitzlato;

--
-- Name: auth_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: cleanup; Owner: bitzlato
--

ALTER SEQUENCE cleanup.auth_stats_id_seq OWNED BY cleanup.auth_stats.id;


--
-- Name: broadcast_result; Type: TABLE; Schema: cleanup; Owner: bitzlato
--

CREATE TABLE cleanup.broadcast_result (
    id integer NOT NULL,
    user_id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    period text,
    received boolean NOT NULL,
    error text
);


ALTER TABLE cleanup.broadcast_result OWNER TO bitzlato;

--
-- Name: country_code; Type: TABLE; Schema: cleanup; Owner: bitzlato
--

CREATE TABLE cleanup.country_code (
    id integer NOT NULL,
    cc character varying(5) NOT NULL,
    payment_methods text[]
);


ALTER TABLE cleanup.country_code OWNER TO bitzlato;

--
-- Name: country_codes_id_seq; Type: SEQUENCE; Schema: cleanup; Owner: bitzlato
--

CREATE SEQUENCE cleanup.country_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cleanup.country_codes_id_seq OWNER TO bitzlato;

--
-- Name: country_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: cleanup; Owner: bitzlato
--

ALTER SEQUENCE cleanup.country_codes_id_seq OWNED BY cleanup.country_code.id;


--
-- Name: daily_reports_dash; Type: TABLE; Schema: cleanup; Owner: bitzlato
--

CREATE TABLE cleanup.daily_reports_dash (
    id integer NOT NULL,
    pay_fee numeric,
    network_fee numeric,
    average_network_fee numeric,
    trade_comission numeric,
    ref_payments numeric,
    report_date date
);


ALTER TABLE cleanup.daily_reports_dash OWNER TO bitzlato;

--
-- Name: daily_reports_dash_id_seq; Type: SEQUENCE; Schema: cleanup; Owner: bitzlato
--

CREATE SEQUENCE cleanup.daily_reports_dash_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cleanup.daily_reports_dash_id_seq OWNER TO bitzlato;

--
-- Name: daily_reports_dash_id_seq; Type: SEQUENCE OWNED BY; Schema: cleanup; Owner: bitzlato
--

ALTER SEQUENCE cleanup.daily_reports_dash_id_seq OWNED BY cleanup.daily_reports_dash.id;


--
-- Name: mailing_result_id_seq; Type: SEQUENCE; Schema: cleanup; Owner: bitzlato
--

CREATE SEQUENCE cleanup.mailing_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cleanup.mailing_result_id_seq OWNER TO bitzlato;

--
-- Name: mailing_result_id_seq; Type: SEQUENCE OWNED BY; Schema: cleanup; Owner: bitzlato
--

ALTER SEQUENCE cleanup.mailing_result_id_seq OWNED BY cleanup.broadcast_result.id;


--
-- Name: one_time_code; Type: TABLE; Schema: cleanup; Owner: bitzlato
--

CREATE TABLE cleanup.one_time_code (
    id integer NOT NULL,
    user_id integer NOT NULL,
    code integer NOT NULL,
    type character varying(10),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE cleanup.one_time_code OWNER TO bitzlato;

--
-- Name: one_time_codes_id_seq; Type: SEQUENCE; Schema: cleanup; Owner: bitzlato
--

CREATE SEQUENCE cleanup.one_time_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cleanup.one_time_codes_id_seq OWNER TO bitzlato;

--
-- Name: one_time_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: cleanup; Owner: bitzlato
--

ALTER SEQUENCE cleanup.one_time_codes_id_seq OWNED BY cleanup.one_time_code.id;


--
-- Name: stablecoin_exchange; Type: TABLE; Schema: cleanup; Owner: bitzlato
--

CREATE TABLE cleanup.stablecoin_exchange (
    id integer NOT NULL,
    user_id integer,
    action_code character varying(256),
    stablecoin character varying(256) NOT NULL,
    cryptocurrency character varying(256) NOT NULL,
    rate_id integer NOT NULL,
    sale numeric,
    close_at timestamp without time zone
);


ALTER TABLE cleanup.stablecoin_exchange OWNER TO bitzlato;

--
-- Name: stablecoin_exchange_id_seq; Type: SEQUENCE; Schema: cleanup; Owner: bitzlato
--

CREATE SEQUENCE cleanup.stablecoin_exchange_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cleanup.stablecoin_exchange_id_seq OWNER TO bitzlato;

--
-- Name: stablecoin_exchange_id_seq; Type: SEQUENCE OWNED BY; Schema: cleanup; Owner: bitzlato
--

ALTER SEQUENCE cleanup.stablecoin_exchange_id_seq OWNED BY cleanup.stablecoin_exchange.id;


--
-- Name: trade_stats; Type: TABLE; Schema: cleanup; Owner: bitzlato
--

CREATE TABLE cleanup.trade_stats (
    id integer NOT NULL,
    type integer NOT NULL,
    open_price bigint DEFAULT 0 NOT NULL,
    close_price bigint DEFAULT 0 NOT NULL,
    high_price bigint DEFAULT 0 NOT NULL,
    low_price bigint DEFAULT 0 NOT NULL,
    volume bigint DEFAULT 0 NOT NULL,
    exchange_volume bigint DEFAULT 0 NOT NULL,
    start_time timestamp with time zone,
    end_time timestamp with time zone
);


ALTER TABLE cleanup.trade_stats OWNER TO bitzlato;

--
-- Name: trade_stats_id_seq; Type: SEQUENCE; Schema: cleanup; Owner: bitzlato
--

CREATE SEQUENCE cleanup.trade_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cleanup.trade_stats_id_seq OWNER TO bitzlato;

--
-- Name: trade_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: cleanup; Owner: bitzlato
--

ALTER SEQUENCE cleanup.trade_stats_id_seq OWNED BY cleanup.trade_stats.id;


--
-- Name: wallet_backup_merge_issues; Type: TABLE; Schema: history; Owner: vanch
--

CREATE TABLE history.wallet_backup_merge_issues (
    id integer,
    user_id integer,
    currency integer,
    address character varying(800),
    balance bigint,
    hold_balance bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp without time zone,
    debt bigint
);


ALTER TABLE history.wallet_backup_merge_issues OWNER TO vanch;

--
-- Name: wallets_backup; Type: TABLE; Schema: history; Owner: bitzlato
--

CREATE TABLE history.wallets_backup (
    id integer,
    user_id integer,
    currency integer,
    address character varying(800),
    balance bigint,
    hold_balance bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp without time zone,
    debt bigint
);


ALTER TABLE history.wallets_backup OWNER TO bitzlato;

--
-- Name: wallets_change; Type: TABLE; Schema: history; Owner: bitzlato
--

CREATE TABLE history.wallets_change (
    id integer,
    user_id integer,
    currency integer,
    address character varying(800),
    balance bigint,
    hold_balance bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp without time zone,
    debt bigint
);


ALTER TABLE history.wallets_change OWNER TO bitzlato;

--
-- Name: address_analyses; Type: TABLE; Schema: meduza; Owner: meduza
--

CREATE TABLE meduza.address_analyses (
    id bigint NOT NULL,
    address public.citext NOT NULL,
    risk_level integer NOT NULL,
    risk_confidence numeric NOT NULL,
    analysis_result_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE meduza.address_analyses OWNER TO meduza;

--
-- Name: address_analyses_id_seq; Type: SEQUENCE; Schema: meduza; Owner: meduza
--

CREATE SEQUENCE meduza.address_analyses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE meduza.address_analyses_id_seq OWNER TO meduza;

--
-- Name: address_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: meduza
--

ALTER SEQUENCE meduza.address_analyses_id_seq OWNED BY meduza.address_analyses.id;


--
-- Name: analysis_results; Type: TABLE; Schema: meduza; Owner: meduza
--

CREATE TABLE meduza.analysis_results (
    id bigint NOT NULL,
    address_transaction public.citext NOT NULL,
    risk_confidence numeric NOT NULL,
    risk_level integer NOT NULL,
    raw_response jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cc_code character varying,
    type character varying NOT NULL
);


ALTER TABLE meduza.analysis_results OWNER TO meduza;

--
-- Name: analysis_results_id_seq; Type: SEQUENCE; Schema: meduza; Owner: meduza
--

CREATE SEQUENCE meduza.analysis_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE meduza.analysis_results_id_seq OWNER TO meduza;

--
-- Name: analysis_results_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: meduza
--

ALTER SEQUENCE meduza.analysis_results_id_seq OWNED BY meduza.analysis_results.id;


--
-- Name: analyzed_users; Type: TABLE; Schema: meduza; Owner: meduza
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


ALTER TABLE meduza.analyzed_users OWNER TO meduza;

--
-- Name: analyzed_users_id_seq; Type: SEQUENCE; Schema: meduza; Owner: meduza
--

CREATE SEQUENCE meduza.analyzed_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE meduza.analyzed_users_id_seq OWNER TO meduza;

--
-- Name: analyzed_users_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: meduza
--

ALTER SEQUENCE meduza.analyzed_users_id_seq OWNED BY meduza.analyzed_users.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: meduza; Owner: meduza
--

CREATE TABLE meduza.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE meduza.ar_internal_metadata OWNER TO meduza;

--
-- Name: pending_analyses; Type: TABLE; Schema: meduza; Owner: meduza
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


ALTER TABLE meduza.pending_analyses OWNER TO meduza;

--
-- Name: pending_analyses_id_seq; Type: SEQUENCE; Schema: meduza; Owner: meduza
--

CREATE SEQUENCE meduza.pending_analyses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE meduza.pending_analyses_id_seq OWNER TO meduza;

--
-- Name: pending_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: meduza
--

ALTER SEQUENCE meduza.pending_analyses_id_seq OWNED BY meduza.pending_analyses.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: meduza; Owner: meduza
--

CREATE TABLE meduza.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE meduza.schema_migrations OWNER TO meduza;

--
-- Name: transaction_analyses; Type: TABLE; Schema: meduza; Owner: meduza
--

CREATE TABLE meduza.transaction_analyses (
    id bigint NOT NULL,
    txid public.citext NOT NULL,
    cc_code character varying NOT NULL,
    risk_level integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    analysis_result_id bigint,
    risk_confidence numeric,
    meta jsonb DEFAULT '{}'::jsonb NOT NULL,
    direction character varying,
    pending_analyses_id bigint
);


ALTER TABLE meduza.transaction_analyses OWNER TO meduza;

--
-- Name: transaction_analyses_id_seq; Type: SEQUENCE; Schema: meduza; Owner: meduza
--

CREATE SEQUENCE meduza.transaction_analyses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE meduza.transaction_analyses_id_seq OWNER TO meduza;

--
-- Name: transaction_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: meduza
--

ALTER SEQUENCE meduza.transaction_analyses_id_seq OWNED BY meduza.transaction_analyses.id;


--
-- Name: transaction_sources; Type: TABLE; Schema: meduza; Owner: meduza
--

CREATE TABLE meduza.transaction_sources (
    id bigint NOT NULL,
    last_processed_blockchain_tx_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cc_code character varying NOT NULL
);


ALTER TABLE meduza.transaction_sources OWNER TO meduza;

--
-- Name: transaction_sources_id_seq; Type: SEQUENCE; Schema: meduza; Owner: meduza
--

CREATE SEQUENCE meduza.transaction_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE meduza.transaction_sources_id_seq OWNER TO meduza;

--
-- Name: transaction_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: meduza; Owner: meduza
--

ALTER SEQUENCE meduza.transaction_sources_id_seq OWNED BY meduza.transaction_sources.id;


--
-- Name: bill; Type: TABLE; Schema: mer; Owner: bitzlato
--

CREATE TABLE mer.bill (
    id integer NOT NULL,
    user_id integer NOT NULL,
    invoice_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    payed_at timestamp without time zone,
    deleted_at timestamp without time zone,
    merchant_id integer NOT NULL
);


ALTER TABLE mer.bill OWNER TO bitzlato;

--
-- Name: bills_id_seq; Type: SEQUENCE; Schema: mer; Owner: bitzlato
--

CREATE SEQUENCE mer.bills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mer.bills_id_seq OWNER TO bitzlato;

--
-- Name: bills_id_seq; Type: SEQUENCE OWNED BY; Schema: mer; Owner: bitzlato
--

ALTER SEQUENCE mer.bills_id_seq OWNED BY mer.bill.id;


--
-- Name: invoice; Type: TABLE; Schema: mer; Owner: bitzlato
--

CREATE TABLE mer.invoice (
    id integer NOT NULL,
    merchant_id integer NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    amount public.cryptocurrency_amount,
    type mer.invoice_type NOT NULL,
    comment text,
    secret_key text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    completed_at timestamp without time zone,
    deleted_at timestamp without time zone,
    expiry_at timestamp without time zone NOT NULL,
    status mer.invoice_status DEFAULT 'pause'::mer.invoice_status NOT NULL
);


ALTER TABLE mer.invoice OWNER TO bitzlato;

--
-- Name: invoice_transaction; Type: TABLE; Schema: mer; Owner: bitzlato
--

CREATE TABLE mer.invoice_transaction (
    id integer NOT NULL,
    user_id integer NOT NULL,
    invoice_id integer NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    amount public.cryptocurrency_amount NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE mer.invoice_transaction OWNER TO bitzlato;

--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: mer; Owner: bitzlato
--

CREATE SEQUENCE mer.invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mer.invoices_id_seq OWNER TO bitzlato;

--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: mer; Owner: bitzlato
--

ALTER SEQUENCE mer.invoices_id_seq OWNED BY mer.invoice.id;


--
-- Name: invoices_transactions_id_seq; Type: SEQUENCE; Schema: mer; Owner: bitzlato
--

CREATE SEQUENCE mer.invoices_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mer.invoices_transactions_id_seq OWNER TO bitzlato;

--
-- Name: invoices_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: mer; Owner: bitzlato
--

ALTER SEQUENCE mer.invoices_transactions_id_seq OWNED BY mer.invoice_transaction.id;


--
-- Name: merchant; Type: TABLE; Schema: mer; Owner: bitzlato
--

CREATE TABLE mer.merchant (
    id integer NOT NULL,
    user_id integer NOT NULL,
    nickname text,
    name text NOT NULL,
    status mer.merchant_status NOT NULL,
    description text,
    notes text,
    frozen_at text,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE mer.merchant OWNER TO bitzlato;

--
-- Name: merchant_id_seq; Type: SEQUENCE; Schema: mer; Owner: bitzlato
--

CREATE SEQUENCE mer.merchant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mer.merchant_id_seq OWNER TO bitzlato;

--
-- Name: merchant_id_seq; Type: SEQUENCE OWNED BY; Schema: mer; Owner: bitzlato
--

ALTER SEQUENCE mer.merchant_id_seq OWNED BY mer.merchant.id;


--
-- Name: payment; Type: TABLE; Schema: mer; Owner: bitzlato
--

CREATE TABLE mer.payment (
    id integer NOT NULL,
    merchant_id integer NOT NULL,
    user_id integer,
    cc_code public.cryptocurrency_code NOT NULL,
    amount numeric NOT NULL,
    status mer.payments_statuses NOT NULL,
    voucher_id integer,
    date timestamp without time zone DEFAULT now() NOT NULL,
    client_provided_id character varying(64),
    CONSTRAINT positive_amount CHECK ((amount > (0)::numeric))
);


ALTER TABLE mer.payment OWNER TO bitzlato;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: mer; Owner: bitzlato
--

CREATE SEQUENCE mer.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mer.payments_id_seq OWNER TO bitzlato;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: mer; Owner: bitzlato
--

ALTER SEQUENCE mer.payments_id_seq OWNED BY mer.payment.id;


--
-- Name: admin_file_uploaded; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.admin_file_uploaded (
    from_user integer NOT NULL,
    trade_id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    for_dispute boolean DEFAULT false NOT NULL,
    caption text
);


ALTER TABLE p2p.admin_file_uploaded OWNER TO bitzlato;

--
-- Name: admin_file_uploded_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.admin_file_uploded_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.admin_file_uploded_id_seq OWNER TO bitzlato;

--
-- Name: admin_file_uploded_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.admin_file_uploded_id_seq OWNED BY p2p.admin_file_uploaded.id;


--
-- Name: ads_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.ads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.ads_id_seq OWNER TO bitzlato;

--
-- Name: ads_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.ads_id_seq OWNED BY p2p.ad.id;


--
-- Name: audit; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.audit (
    id integer NOT NULL,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    audit_json jsonb NOT NULL
);


ALTER TABLE p2p.audit OWNER TO bitzlato;

--
-- Name: audit_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.audit_id_seq OWNER TO bitzlato;

--
-- Name: audit_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.audit_id_seq OWNED BY p2p.audit.id;


--
-- Name: backup$wallet_log; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p."backup$wallet_log" (
    id integer NOT NULL,
    wallet_id integer NOT NULL,
    description text,
    balance_at_the_moment bigint NOT NULL,
    hold_balance_at_moment bigint NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    cause text,
    currency character varying(10),
    amount numeric,
    source_type p2p.operation_source,
    source_id integer,
    operation_type p2p.operation_type,
    platform character varying(10)
);


ALTER TABLE p2p."backup$wallet_log" OWNER TO bitzlato;

--
-- Name: cryptocurrency_settings; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.cryptocurrency_settings (
    code public.cryptocurrency_code NOT NULL,
    ref_trader_bonus_percent real NOT NULL,
    trade_comission_percent real,
    hot_wallet_balance public.cryptocurrency_amount,
    cold_wallet_audit_adjust public.cryptocurrency_amount,
    withdraw_enabled boolean DEFAULT true NOT NULL,
    deposit_enabled boolean DEFAULT true NOT NULL,
    optimal_enabled boolean DEFAULT true NOT NULL,
    free_enabled boolean DEFAULT false NOT NULL,
    free_trades_enabled boolean DEFAULT false NOT NULL,
    min_withdrawal public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    is_token boolean DEFAULT false NOT NULL,
    ref_ad_bonus_percent real NOT NULL,
    pay_many_stack integer DEFAULT 1 NOT NULL,
    minimum_ad_enabled_amount public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    real_cold_wallet_balance public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    freeze_amount public.cryptocurrency_amount DEFAULT '1'::numeric NOT NULL,
    trades_enabled boolean DEFAULT true NOT NULL,
    is_shitcoin boolean DEFAULT false NOT NULL,
    is_delisted boolean DEFAULT false NOT NULL,
    has_cold_wallet boolean DEFAULT false NOT NULL,
    cold_wallet_balance_updated_at timestamp without time zone,
    bot_name character varying(126),
    blockchain_url character varying(126),
    hot_wallet_unconfirmed_balance public.cryptocurrency_amount,
    min_acceptable_deposit public.cryptocurrency_amount,
    mature_trader_min_turnover public.cryptocurrency_amount,
    in_rating boolean DEFAULT false NOT NULL,
    debt numeric(60,8) DEFAULT 0 NOT NULL,
    audit_watchdog_deposit_interval interval,
    withdraw_amount_limit public.cryptocurrency_amount,
    custom jsonb,
    CONSTRAINT cryptocurrency_settings_check CHECK (((NOT is_delisted) OR (NOT (trades_enabled OR withdraw_enabled OR deposit_enabled)))),
    CONSTRAINT cryptocurrency_settings_debt_check CHECK ((debt >= (0)::numeric)),
    CONSTRAINT cryptocurrency_settings_min_acceptable_deposit_check CHECK (((min_acceptable_deposit)::numeric > (0)::numeric)),
    CONSTRAINT cryptocurrency_settings_withdraw_amount_limit_check CHECK (((withdraw_amount_limit)::numeric >= (min_withdrawal)::numeric))
)
WITH (fillfactor='85');


ALTER TABLE p2p.cryptocurrency_settings OWNER TO bitzlato;

--
-- Name: COLUMN cryptocurrency_settings.min_acceptable_deposit; Type: COMMENT; Schema: p2p; Owner: bitzlato
--

COMMENT ON COLUMN p2p.cryptocurrency_settings.min_acceptable_deposit IS 'Prevent deposits of dust (too small amounts)';


--
-- Name: rate; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.rate (
    id integer NOT NULL,
    value numeric NOT NULL,
    url text NOT NULL,
    description text NOT NULL,
    currency_symbol character varying(5) NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    default_rate boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT check_values CHECK ((value > (0)::numeric))
);


ALTER TABLE p2p.rate OWNER TO bitzlato;

--
-- Name: trade_statistic; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.trade_statistic (
    user_id integer NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    total_count integer DEFAULT 0 NOT NULL,
    total_amount public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    success_deals integer DEFAULT 0 NOT NULL,
    canceled_deals integer DEFAULT 0 NOT NULL,
    defeat_in_dispute integer DEFAULT 0 NOT NULL,
    positive_feedbacks_count integer DEFAULT 0 NOT NULL,
    negative_feedbacks_count integer DEFAULT 0 NOT NULL,
    id integer NOT NULL,
    bought public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    sold public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    deposit public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    withdrawal public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    saved_by_free_trade public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    saved_by_wvouchers public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    CONSTRAINT trade_statistic_bought_check CHECK (((bought)::numeric >= (0)::numeric)),
    CONSTRAINT trade_statistic_deposit_check CHECK (((deposit)::numeric >= (0)::numeric)),
    CONSTRAINT trade_statistic_saved_by_free_trade_check CHECK (((saved_by_free_trade)::numeric >= (0)::numeric)),
    CONSTRAINT trade_statistic_saved_by_wvouchers_check CHECK (((saved_by_wvouchers)::numeric >= (0)::numeric)),
    CONSTRAINT trade_statistic_sold_check CHECK (((sold)::numeric >= (0)::numeric)),
    CONSTRAINT trade_statistic_success_deals_check CHECK ((success_deals >= 0)),
    CONSTRAINT trade_statistic_total_count_check CHECK ((total_count >= 0)),
    CONSTRAINT trade_statistic_withdrawal_check CHECK (((withdrawal)::numeric >= (0)::numeric))
);


ALTER TABLE p2p.trade_statistic OWNER TO bitzlato;

--
-- Name: user_profile; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_profile (
    id integer NOT NULL,
    lang character varying(2) NOT NULL,
    user_id integer NOT NULL,
    currency character varying(5) NOT NULL,
    cryptocurrency character varying(256) NOT NULL,
    start_of_use_date timestamp without time zone DEFAULT now(),
    rating numeric NOT NULL,
    lastactivity timestamp without time zone DEFAULT now() NOT NULL,
    blocked_by_admin boolean DEFAULT false NOT NULL,
    old_trade_status p2p.user_trade_status DEFAULT 'pause'::p2p.user_trade_status NOT NULL,
    cancreateadvert_status boolean,
    cancreateadvert_reason p2p.advert_creating_block_reason,
    verified boolean DEFAULT false NOT NULL,
    about_user text DEFAULT ''::text,
    telegram_name character varying,
    user_info text,
    licensing_agreement_accepted boolean DEFAULT false NOT NULL,
    greeting text,
    safe_mode_enabled boolean DEFAULT true NOT NULL,
    pass_safety_wizard boolean DEFAULT false NOT NULL,
    suspicious boolean DEFAULT false NOT NULL,
    copilka numeric,
    merged boolean DEFAULT false NOT NULL,
    public_name character varying(28),
    lang_web character varying(2),
    verification_date timestamp without time zone,
    accept_marketing_emails boolean DEFAULT true NOT NULL,
    generated_name character varying(28) NOT NULL,
    phone character varying(20),
    is_muted boolean DEFAULT false NOT NULL,
    timezone character varying(100),
    pass_merge_wizard boolean DEFAULT false NOT NULL,
    "safetyIndex_modifier" integer DEFAULT 0 NOT NULL,
    avatar character varying(40),
    self_frozen boolean DEFAULT false NOT NULL,
    CONSTRAINT user_profile_generated_name_check CHECK ((length((generated_name)::text) > 0)),
    CONSTRAINT user_profile_public_name_check CHECK ((length((public_name)::text) > 0))
)
WITH (fillfactor='85', autovacuum_enabled='on', autovacuum_vacuum_cost_delay='20');


ALTER TABLE p2p.user_profile OWNER TO bitzlato;

--
-- Name: cryptocurrency; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.cryptocurrency (
    code character varying(4) NOT NULL,
    name character varying(256) NOT NULL,
    scale smallint DEFAULT 8 NOT NULL,
    weight smallint NOT NULL,
    CONSTRAINT cryptocurrency_code_check CHECK ((length((code)::text) > 0)),
    CONSTRAINT cryptocurrency_name_check CHECK ((length((name)::text) > 0))
);


ALTER TABLE public.cryptocurrency OWNER TO bitzlato;

--
-- Name: user_cryptocurrency_settings; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.user_cryptocurrency_settings (
    user_id integer NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    trading_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.user_cryptocurrency_settings OWNER TO bitzlato;

--
-- Name: buy_ads_mview; Type: MATERIALIZED VIEW; Schema: p2p; Owner: bitzlato
--

CREATE MATERIALIZED VIEW p2p.buy_ads_mview
WITH (fillfactor='70') AS
 WITH btc_min_ad_amount AS (
         SELECT cryptocurrency_settings.minimum_ad_enabled_amount AS amount
           FROM p2p.cryptocurrency_settings
          WHERE ((cryptocurrency_settings.code)::text = 'BTC'::text)
        )
 SELECT ad.id AS aid,
    ad.cc_code,
    pm.currency,
    ad.min_amount,
    ad.max_amount,
    ad.rate_value,
    pm.id AS pid,
    pm.i18n,
    pm.description,
    ad.user_id,
    up.lastactivity,
    up.verified,
    (up.verified AND (NOT up.suspicious)) AS is_it_safe,
    ad.max_limit_for_new_trader,
    w.balance,
    ad.verified_only,
    (((up.start_of_use_date + '2 mons'::interval) < now()) AND (stat.success_deals >= 20) AND ((stat.turnover >= (ccs.mature_trader_min_turnover)::numeric) OR (ccs.mature_trader_min_turnover IS NULL))) AS is_mature,
    up.start_of_use_date
   FROM ((((((((((p2p.ad
     CROSS JOIN btc_min_ad_amount)
     JOIN public.cryptocurrency cc ON (((cc.code)::text = (ad.cc_code)::text)))
     JOIN p2p.cryptocurrency_settings ccs ON ((((ccs.code)::text = (ad.cc_code)::text) AND ccs.trades_enabled AND (NOT ccs.is_delisted) AND (NOT ccs.is_shitcoin))))
     JOIN public.user_cryptocurrency_settings uccs ON ((((uccs.cc_code)::text = (cc.code)::text) AND (uccs.user_id = ad.user_id) AND uccs.trading_enabled)))
     JOIN p2p.payment_method pm ON ((pm.id = ad.paymethod)))
     JOIN p2p.user_profile up ON (((up.user_id = ad.user_id) AND (NOT up.blocked_by_admin) AND (NOT up.is_muted))))
     JOIN p2p.rate r ON ((((r.cc_code)::text = (ad.cc_code)::text) AND r.default_rate AND ((r.currency_symbol)::text = (pm.currency)::text))))
     JOIN public.wallet btcw ON (((btcw.user_id = ad.user_id) AND ((btcw.cc_code)::text = 'BTC'::text))))
     JOIN public.wallet w ON (((w.user_id = ad.user_id) AND ((w.cc_code)::text = (cc.code)::text))))
     CROSS JOIN LATERAL ( SELECT sum(trade_statistic.success_deals) AS success_deals,
            sum((trade_statistic.total_amount)::numeric) FILTER (WHERE ((trade_statistic.cc_code)::text = (ad.cc_code)::text)) AS turnover
           FROM p2p.trade_statistic
          WHERE (trade_statistic.user_id = ad.user_id)) stat)
  WHERE ((ad.deleted_at IS NULL) AND (ad.status = 'active'::p2p.ads_status) AND (ad.type = 'purchase'::p2p.ads_type) AND ((ad.rate_value >= (r.value * 0.5)) AND (ad.rate_value <= (r.value * 1.5))) AND ((((btcw.balance)::numeric + (btcw.hold_balance)::numeric) >= (btc_min_ad_amount.amount)::numeric) OR (((w.balance)::numeric + (w.hold_balance)::numeric) >= (ccs.minimum_ad_enabled_amount)::numeric)))
  WITH NO DATA;


ALTER TABLE p2p.buy_ads_mview OWNER TO bitzlato;

--
-- Name: buy_ads_view; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.buy_ads_view AS
 SELECT buy_ads_mview.aid,
    buy_ads_mview.cc_code,
    buy_ads_mview.currency,
    buy_ads_mview.min_amount,
    buy_ads_mview.max_amount,
    buy_ads_mview.rate_value,
    buy_ads_mview.pid,
    buy_ads_mview.i18n,
    buy_ads_mview.description,
    buy_ads_mview.user_id,
    buy_ads_mview.lastactivity,
    buy_ads_mview.verified,
    buy_ads_mview.is_it_safe,
    buy_ads_mview.max_limit_for_new_trader,
    buy_ads_mview.balance,
    buy_ads_mview.verified_only,
    buy_ads_mview.is_mature,
    buy_ads_mview.start_of_use_date
   FROM p2p.buy_ads_mview
  ORDER BY buy_ads_mview.verified DESC, buy_ads_mview.is_mature DESC, buy_ads_mview.rate_value DESC, buy_ads_mview.start_of_use_date, buy_ads_mview.aid DESC;


ALTER TABLE p2p.buy_ads_view OWNER TO bitzlato;

--
-- Name: cc_settings_backup; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.cc_settings_backup (
    code character varying(256) NOT NULL,
    ref_trader_bonus_percent real,
    trade_comission_percent real,
    hot_wallet_balance numeric,
    cold_wallet_audit_adjust numeric,
    withdrawal_fee_optimal numeric DEFAULT 0.001,
    withdrawal_fee_vip numeric DEFAULT 0.001,
    withdraw_enabled boolean DEFAULT true NOT NULL,
    deposit_enabled boolean DEFAULT true NOT NULL,
    optimal_enabled boolean DEFAULT true NOT NULL,
    vip_enabled boolean DEFAULT true NOT NULL,
    free_enabled boolean DEFAULT false NOT NULL,
    free_trades_enabled boolean DEFAULT false NOT NULL,
    min_withdrawal numeric DEFAULT 0 NOT NULL,
    is_token boolean DEFAULT false NOT NULL,
    ref_ad_bonus_percent real,
    pay_many_stack integer DEFAULT 1 NOT NULL,
    minimum_ad_enabled_amount numeric DEFAULT 0 NOT NULL,
    real_cold_wallet_balance numeric DEFAULT 0,
    freeze_amount numeric DEFAULT '1'::numeric NOT NULL,
    trades_enabled boolean DEFAULT true NOT NULL,
    is_shitcoin boolean DEFAULT false NOT NULL,
    is_delisted boolean DEFAULT false NOT NULL,
    has_cold_wallet boolean DEFAULT false NOT NULL,
    cold_wallet_balance_updated_at timestamp without time zone,
    bot_name character varying(126),
    blockchain_url character varying(126),
    hot_wallet_unconfirmed_balance numeric,
    CONSTRAINT cryptocurrency_settings_check CHECK (((NOT is_delisted) OR (NOT (trades_enabled OR withdraw_enabled OR deposit_enabled))))
);


ALTER TABLE p2p.cc_settings_backup OWNER TO bitzlato;

--
-- Name: chat; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.chat (
    id integer NOT NULL,
    author_id integer NOT NULL,
    text text,
    trade_id integer,
    "to" integer[],
    to_admin boolean DEFAULT false NOT NULL,
    from_admin boolean DEFAULT false NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    admin_file_uploaded_id integer
)
WITH (fillfactor='85');


ALTER TABLE p2p.chat OWNER TO bitzlato;

--
-- Name: chat_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.chat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.chat_id_seq OWNER TO bitzlato;

--
-- Name: chat_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.chat_id_seq OWNED BY p2p.chat.id;


--
-- Name: config; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.config (
    name character varying(100) NOT NULL,
    value character varying(50) NOT NULL
);


ALTER TABLE p2p.config OWNER TO bitzlato;

--
-- Name: config_maintenance; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.config_maintenance (
    name character varying(50) NOT NULL,
    status boolean NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE p2p.config_maintenance OWNER TO bitzlato;

--
-- Name: cryptocurrency_rate_source; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.cryptocurrency_rate_source (
    cc_code public.cryptocurrency_code NOT NULL,
    rate_source_code character varying(63) NOT NULL,
    priority smallint NOT NULL,
    CONSTRAINT cryptocurrency_rate_source_priority_check CHECK ((priority > 0))
);


ALTER TABLE p2p.cryptocurrency_rate_source OWNER TO bitzlato;

--
-- Name: currency; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.currency (
    symbol character varying(5) NOT NULL,
    name character varying(70) NOT NULL,
    sign character varying(3) NOT NULL,
    free_trade_enabled boolean DEFAULT false NOT NULL,
    max_commission_sum numeric DEFAULT 200000 NOT NULL
);


ALTER TABLE p2p.currency OWNER TO bitzlato;

--
-- Name: debt; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.debt (
    id integer NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    sum public.cryptocurrency_amount NOT NULL,
    done boolean NOT NULL,
    wallet_id integer NOT NULL,
    admin_code public.text_code NOT NULL,
    comment text,
    banuser boolean DEFAULT false NOT NULL,
    execution_date timestamp without time zone,
    action character varying(32),
    action_date timestamp without time zone,
    action_admin_code public.text_code,
    CONSTRAINT debts_sum_check CHECK (((sum)::numeric > (0)::numeric))
);


ALTER TABLE p2p.debt OWNER TO bitzlato;

--
-- Name: debts_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.debts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.debts_id_seq OWNER TO bitzlato;

--
-- Name: debts_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.debts_id_seq OWNED BY p2p.debt.id;


--
-- Name: deep_link_action; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.deep_link_action (
    id integer NOT NULL,
    action p2p.deep_link_action_type NOT NULL
);


ALTER TABLE p2p.deep_link_action OWNER TO bitzlato;

--
-- Name: deep_link_action_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.deep_link_action_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.deep_link_action_id_seq OWNER TO bitzlato;

--
-- Name: deep_link_action_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.deep_link_action_id_seq OWNED BY p2p.deep_link_action.id;


--
-- Name: deep_link_referal_action; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.deep_link_referal_action (
    deep_link_action_id integer NOT NULL,
    parent_user_id integer NOT NULL
);


ALTER TABLE p2p.deep_link_referal_action OWNER TO bitzlato;

--
-- Name: deeplink_utm; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.deeplink_utm (
    code character varying(32) NOT NULL,
    utm_json jsonb NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE p2p.deeplink_utm OWNER TO bitzlato;

--
-- Name: dispute; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.dispute (
    id integer NOT NULL,
    trade_id integer NOT NULL,
    seller_id integer NOT NULL,
    buyer_id integer NOT NULL,
    seller_reason text,
    admin_code public.text_code,
    chat_id integer,
    opened_at timestamp without time zone NOT NULL,
    closed_at timestamp without time zone,
    resolution p2p.trade_state,
    buyer_reason text,
    resolution_reason text,
    comment_admin text,
    refund boolean,
    reopened boolean DEFAULT false,
    fine_payer integer
);


ALTER TABLE p2p.dispute OWNER TO bitzlato;

--
-- Name: dispute_decision; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.dispute_decision (
    id integer NOT NULL,
    trade_id integer NOT NULL,
    commentary text NOT NULL,
    type p2p.dispute_decisions_type NOT NULL,
    active boolean DEFAULT true NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    dispute_id integer,
    admin_code public.text_code NOT NULL
);


ALTER TABLE p2p.dispute_decision OWNER TO bitzlato;

--
-- Name: dispute_decisions_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.dispute_decisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.dispute_decisions_id_seq OWNER TO bitzlato;

--
-- Name: dispute_decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.dispute_decisions_id_seq OWNED BY p2p.dispute_decision.id;


--
-- Name: dispute_video; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.dispute_video (
    id integer NOT NULL,
    dispute_id integer NOT NULL,
    file_name character varying(64) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    admin_code public.text_code NOT NULL
);


ALTER TABLE p2p.dispute_video OWNER TO bitzlato;

--
-- Name: dispute_video_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.dispute_video_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.dispute_video_id_seq OWNER TO bitzlato;

--
-- Name: dispute_video_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.dispute_video_id_seq OWNED BY p2p.dispute_video.id;


--
-- Name: disputes_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.disputes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.disputes_id_seq OWNER TO bitzlato;

--
-- Name: disputes_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.disputes_id_seq OWNED BY p2p.dispute.id;


--
-- Name: dust_aggregation; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.dust_aggregation (
    id integer NOT NULL,
    tx_id character varying(126) NOT NULL,
    status p2p.dust_aggregation_status DEFAULT 'dust_collected'::p2p.dust_aggregation_status NOT NULL,
    confirmation_block integer,
    confirmation_time timestamp without time zone,
    category p2p.dust_category NOT NULL,
    count_inputs integer NOT NULL,
    sum_inputs public.cryptocurrency_amount NOT NULL,
    sum_outputs public.cryptocurrency_amount NOT NULL,
    fee public.cryptocurrency_amount NOT NULL,
    fee_rate public.cryptocurrency_amount NOT NULL,
    address_collector character varying(126) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    settled_at timestamp without time zone,
    CONSTRAINT dust_aggregation_check CHECK (((settled_at IS NOT NULL) = (status = 'fee_settled'::p2p.dust_aggregation_status))),
    CONSTRAINT dust_aggregation_count_inputs_check CHECK ((count_inputs > 0)),
    CONSTRAINT dust_aggregation_fee_check CHECK (((fee)::numeric >= (0)::numeric)),
    CONSTRAINT dust_aggregation_fee_rate_check CHECK (((fee_rate)::numeric >= (0)::numeric)),
    CONSTRAINT dust_aggregation_sum_inputs_check CHECK (((sum_inputs)::numeric > (0)::numeric)),
    CONSTRAINT dust_aggregation_sum_outputs_check CHECK (((sum_outputs)::numeric > (0)::numeric))
);


ALTER TABLE p2p.dust_aggregation OWNER TO bitzlato;

--
-- Name: dust_aggregation_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

ALTER TABLE p2p.dust_aggregation ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME p2p.dust_aggregation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: feature; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.feature (
    code character varying(63) NOT NULL,
    description text NOT NULL,
    required_feature_code character varying(63),
    CONSTRAINT features_check CHECK (((code)::text <> (required_feature_code)::text))
);


ALTER TABLE p2p.feature OWNER TO bitzlato;

--
-- Name: feedback; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.feedback (
    id integer NOT NULL,
    user_id integer NOT NULL,
    type p2p.feedback_type NOT NULL,
    text text DEFAULT ''::text NOT NULL,
    trade_id integer,
    for_user_id integer,
    date timestamp without time zone
);


ALTER TABLE p2p.feedback OWNER TO bitzlato;

--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.feedbacks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.feedbacks_id_seq OWNER TO bitzlato;

--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.feedbacks_id_seq OWNED BY p2p.feedback.id;


--
-- Name: forbidden_public_name; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.forbidden_public_name (
    name text NOT NULL
);


ALTER TABLE p2p.forbidden_public_name OWNER TO bitzlato;

--
-- Name: identity_verification_attempt; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.identity_verification_attempt (
    user_id integer NOT NULL,
    at timestamp without time zone NOT NULL,
    success boolean NOT NULL,
    comment character varying
);


ALTER TABLE p2p.identity_verification_attempt OWNER TO bitzlato;

--
-- Name: lang; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.lang (
    code character varying(2) NOT NULL,
    description character varying(256) NOT NULL
);


ALTER TABLE p2p.lang OWNER TO bitzlato;

--
-- Name: merge; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.merge (
    web_account_user_id integer NOT NULL,
    telegram_account_user_id integer NOT NULL,
    date_of_merge timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    CONSTRAINT merges_check CHECK ((deleted_at > date_of_merge))
);


ALTER TABLE p2p.merge OWNER TO bitzlato;

--
-- Name: merge_token; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.merge_token (
    id bigint NOT NULL,
    expired_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    token character varying(512) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE p2p.merge_token OWNER TO bitzlato;

--
-- Name: merge_tokens_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.merge_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.merge_tokens_id_seq OWNER TO bitzlato;

--
-- Name: merge_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.merge_tokens_id_seq OWNED BY p2p.merge_token.id;


--
-- Name: muted_user; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.muted_user (
    id integer NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    admin_code public.text_code NOT NULL,
    user_id integer NOT NULL,
    duration_hrs integer NOT NULL,
    reason text NOT NULL,
    expiry timestamp without time zone NOT NULL,
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE p2p.muted_user OWNER TO bitzlato;

--
-- Name: muted_users_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.muted_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.muted_users_id_seq OWNER TO bitzlato;

--
-- Name: muted_users_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.muted_users_id_seq OWNED BY p2p.muted_user.id;


--
-- Name: notebook; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.notebook (
    id integer NOT NULL,
    user_id integer NOT NULL,
    cryptocurrency character varying(8) NOT NULL,
    address character varying(800) NOT NULL,
    description character varying(255) NOT NULL,
    is_actual boolean NOT NULL
);


ALTER TABLE p2p.notebook OWNER TO bitzlato;

--
-- Name: notebook_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.notebook_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.notebook_id_seq OWNER TO bitzlato;

--
-- Name: notebook_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.notebook_id_seq OWNED BY p2p.notebook.id;


--
-- Name: notification; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.notification (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    data_json jsonb DEFAULT '{}'::jsonb NOT NULL,
    receiver_user_id integer NOT NULL,
    unread boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE p2p.notification OWNER TO bitzlato;

--
-- Name: notification_token; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.notification_token (
    user_id integer NOT NULL,
    token text NOT NULL,
    device_id text NOT NULL
);


ALTER TABLE p2p.notification_token OWNER TO bitzlato;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.notifications_id_seq OWNER TO bitzlato;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.notifications_id_seq OWNED BY p2p.notification.id;


--
-- Name: old_data_profile; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.old_data_profile (
    id integer NOT NULL,
    user_id integer NOT NULL,
    btc_amount numeric NOT NULL,
    btc_count integer NOT NULL
);


ALTER TABLE p2p.old_data_profile OWNER TO bitzlato;

--
-- Name: old_data_profile_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.old_data_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.old_data_profile_id_seq OWNER TO bitzlato;

--
-- Name: old_data_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.old_data_profile_id_seq OWNED BY p2p.old_data_profile.id;


--
-- Name: payment_group; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.payment_group (
    id integer NOT NULL,
    label text NOT NULL,
    weight integer DEFAULT 0 NOT NULL
);


ALTER TABLE p2p.payment_group OWNER TO bitzlato;

--
-- Name: payment_group_multilang; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.payment_group_multilang (
    id integer NOT NULL,
    payments_group_id integer NOT NULL,
    lang_code character varying(32) NOT NULL,
    label text NOT NULL
);


ALTER TABLE p2p.payment_group_multilang OWNER TO bitzlato;

--
-- Name: payment_list_precalculation; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.payment_list_precalculation (
    payment_method_id integer NOT NULL,
    best_rate numeric NOT NULL,
    ads_count integer NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    description text NOT NULL,
    currency character(4) NOT NULL,
    trade_amount numeric NOT NULL,
    ads_type p2p.ads_type NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    payment_group integer DEFAULT 1 NOT NULL,
    best_rate_safe numeric NOT NULL,
    i18n jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE p2p.payment_list_precalculation OWNER TO bitzlato;

--
-- Name: payment_method_global; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.payment_method_global (
    id integer NOT NULL,
    label character varying(255) NOT NULL,
    payments_group integer NOT NULL
);


ALTER TABLE p2p.payment_method_global OWNER TO bitzlato;

--
-- Name: payment_method_global_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.payment_method_global_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.payment_method_global_id_seq OWNER TO bitzlato;

--
-- Name: payment_method_global_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.payment_method_global_id_seq OWNED BY p2p.payment_method_global.id;


--
-- Name: payment_method_hist; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.payment_method_hist (
    id integer NOT NULL,
    admin_code public.text_code NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE p2p.payment_method_hist OWNER TO bitzlato;

--
-- Name: payment_method_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.payment_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.payment_method_id_seq OWNER TO bitzlato;

--
-- Name: payment_method_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.payment_method_id_seq OWNED BY p2p.payment_method.id;


--
-- Name: payments_group_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.payments_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.payments_group_id_seq OWNER TO bitzlato;

--
-- Name: payments_group_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.payments_group_id_seq OWNED BY p2p.payment_group.id;


--
-- Name: payments_group_multilang_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.payments_group_multilang_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.payments_group_multilang_id_seq OWNER TO bitzlato;

--
-- Name: payments_group_multilang_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.payments_group_multilang_id_seq OWNED BY p2p.payment_group_multilang.id;


--
-- Name: rate_fiat; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.rate_fiat (
    value numeric NOT NULL,
    url text NOT NULL,
    description text NOT NULL,
    symbol1 character varying(5) NOT NULL,
    symbol2 character varying(256) NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT rates_fiat_value_check CHECK ((value > (0)::numeric))
);


ALTER TABLE p2p.rate_fiat OWNER TO bitzlato;

--
-- Name: rate_plan_withdraw; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.rate_plan_withdraw (
    cc_code character varying NOT NULL,
    act_during tsrange NOT NULL,
    op_amount numrange NOT NULL,
    fee_amount public.cryptocurrency_amount NOT NULL,
    CONSTRAINT rate_plan_withdraw_fee_amount_check CHECK (((fee_amount)::numeric >= (0)::numeric)),
    CONSTRAINT rate_plan_withdraw_op_amount_check CHECK ((op_amount <@ '[0,)'::numrange))
);


ALTER TABLE p2p.rate_plan_withdraw OWNER TO bitzlato;

--
-- Name: rate_source; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.rate_source (
    code character varying(63) NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE p2p.rate_source OWNER TO bitzlato;

--
-- Name: rates_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.rates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.rates_id_seq OWNER TO bitzlato;

--
-- Name: rates_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.rates_id_seq OWNED BY p2p.rate.id;


--
-- Name: rating_change_log; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.rating_change_log (
    id integer NOT NULL,
    value numeric NOT NULL,
    cause text NOT NULL,
    user_id integer NOT NULL,
    "tradeId" integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE p2p.rating_change_log OWNER TO bitzlato;

--
-- Name: rating_change_log_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.rating_change_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.rating_change_log_id_seq OWNER TO bitzlato;

--
-- Name: rating_change_log_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.rating_change_log_id_seq OWNED BY p2p.rating_change_log.id;


--
-- Name: referal_bonus; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.referal_bonus (
    id integer NOT NULL,
    referal_id integer NOT NULL,
    crypto_amount public.cryptocurrency_amount NOT NULL,
    trade_id integer,
    date timestamp without time zone DEFAULT now() NOT NULL,
    order_id bigint,
    ref_parent_user_id integer NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL
);


ALTER TABLE p2p.referal_bonus OWNER TO bitzlato;

--
-- Name: referal_bonuses_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.referal_bonuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.referal_bonuses_id_seq OWNER TO bitzlato;

--
-- Name: referal_bonuses_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.referal_bonuses_id_seq OWNED BY p2p.referal_bonus.id;


--
-- Name: referral_links_statistic; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.referral_links_statistic (
    id integer NOT NULL,
    user_id integer NOT NULL,
    parent_id integer,
    key_word character varying(100),
    date timestamp without time zone DEFAULT now() NOT NULL,
    url text
);


ALTER TABLE p2p.referral_links_statistic OWNER TO bitzlato;

--
-- Name: referral_links_statistic_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.referral_links_statistic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.referral_links_statistic_id_seq OWNER TO bitzlato;

--
-- Name: referral_links_statistic_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.referral_links_statistic_id_seq OWNED BY p2p.referral_links_statistic.id;


--
-- Name: report; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.report (
    code integer NOT NULL,
    description text NOT NULL,
    format character varying(10) NOT NULL
);


ALTER TABLE p2p.report OWNER TO bitzlato;

--
-- Name: requisite; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.requisite (
    id integer NOT NULL,
    user_id integer NOT NULL,
    paymethod character varying(8) NOT NULL,
    details character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    is_actual boolean NOT NULL
);


ALTER TABLE p2p.requisite OWNER TO bitzlato;

--
-- Name: requisites_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.requisites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.requisites_id_seq OWNER TO bitzlato;

--
-- Name: requisites_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.requisites_id_seq OWNED BY p2p.requisite.id;


--
-- Name: sell_ads_mview; Type: MATERIALIZED VIEW; Schema: p2p; Owner: bitzlato
--

CREATE MATERIALIZED VIEW p2p.sell_ads_mview
WITH (fillfactor='70') AS
 SELECT ad.id AS aid,
    ad.cc_code,
    pm.currency,
    ad.min_amount,
    LEAST(ad.max_amount, (((w.balance)::numeric * ad.rate_value) / ((1)::numeric + (ccs.trade_comission_percent)::numeric))) AS max_amount,
    ad.rate_value,
    pm.id AS pid,
    pm.i18n,
    pm.description,
    ad.user_id,
    up.lastactivity,
    up.verified,
    (up.verified AND (NOT up.suspicious)) AS is_it_safe,
    ad.max_limit_for_new_trader,
    w.balance,
    ad.verified_only,
    up.start_of_use_date
   FROM (((((((p2p.ad
     JOIN p2p.cryptocurrency_settings ccs ON ((((ccs.code)::text = (ad.cc_code)::text) AND ccs.trades_enabled AND (NOT ccs.is_delisted) AND (NOT ccs.is_shitcoin))))
     JOIN public.user_cryptocurrency_settings uccs ON ((((uccs.cc_code)::text = (ccs.code)::text) AND (uccs.user_id = ad.user_id) AND uccs.trading_enabled)))
     JOIN p2p.payment_method pm ON ((pm.id = ad.paymethod)))
     JOIN p2p.user_profile up ON (((up.user_id = ad.user_id) AND (NOT up.blocked_by_admin) AND (NOT up.is_muted))))
     JOIN public.cryptocurrency cc ON (((cc.code)::text = (ad.cc_code)::text)))
     JOIN p2p.rate r ON ((((r.cc_code)::text = (ad.cc_code)::text) AND r.default_rate AND ((r.currency_symbol)::text = (pm.currency)::text))))
     JOIN public.wallet w ON (((w.user_id = ad.user_id) AND ((w.cc_code)::text = (cc.code)::text))))
  WHERE ((ad.deleted_at IS NULL) AND (ad.status = 'active'::p2p.ads_status) AND (ad.type = 'selling'::p2p.ads_type) AND ((ad.rate_value >= (r.value * 0.5)) AND (ad.rate_value <= (r.value * 1.5))) AND ((w.balance)::numeric > ((ad.min_amount / ad.rate_value) * ((1)::numeric + (ccs.trade_comission_percent)::numeric))))
  WITH NO DATA;


ALTER TABLE p2p.sell_ads_mview OWNER TO bitzlato;

--
-- Name: sell_ads_view; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.sell_ads_view AS
 SELECT sell_ads_mview.aid,
    sell_ads_mview.cc_code,
    sell_ads_mview.currency,
    sell_ads_mview.min_amount,
    sell_ads_mview.max_amount,
    sell_ads_mview.rate_value,
    sell_ads_mview.pid,
    sell_ads_mview.i18n,
    sell_ads_mview.description,
    sell_ads_mview.user_id,
    sell_ads_mview.lastactivity,
    sell_ads_mview.verified,
    sell_ads_mview.is_it_safe,
    sell_ads_mview.max_limit_for_new_trader,
    sell_ads_mview.balance,
    sell_ads_mview.verified_only,
    sell_ads_mview.start_of_use_date
   FROM p2p.sell_ads_mview
  ORDER BY sell_ads_mview.verified DESC, sell_ads_mview.rate_value, sell_ads_mview.start_of_use_date, sell_ads_mview.aid DESC;


ALTER TABLE p2p.sell_ads_view OWNER TO bitzlato;

--
-- Name: stablecoin_trade; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.stablecoin_trade (
    name character varying(20) NOT NULL,
    status p2p.pair_status NOT NULL,
    base character varying(10) NOT NULL,
    quote character varying(10) NOT NULL,
    fee_sell numeric NOT NULL,
    fee_buy numeric NOT NULL,
    max_amount_quote numeric NOT NULL,
    min_amount_quote numeric NOT NULL
);


ALTER TABLE p2p.stablecoin_trade OWNER TO bitzlato;

--
-- Name: trade; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.trade (
    id integer NOT NULL,
    trade_initiator integer NOT NULL,
    crypto_seller integer NOT NULL,
    crypto_buyer integer NOT NULL,
    status p2p.trade_state NOT NULL,
    currency character varying(8) NOT NULL,
    amount numeric NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    cryptoamount public.cryptocurrency_amount NOT NULL,
    details text,
    fee_buyer public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    fee_seller public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    ad_id integer NOT NULL,
    ad_user_id integer NOT NULL,
    ad_rate numeric NOT NULL,
    ad_terms text,
    ad_details text,
    ad_type p2p.ads_type NOT NULL,
    ad_min_amount numeric NOT NULL,
    ad_max_amount numeric NOT NULL,
    ad_paymethod integer NOT NULL,
    timeout integer DEFAULT 0 NOT NULL,
    ref_bonus_paid boolean DEFAULT false,
    first_dispute_notification_shown boolean DEFAULT false,
    comission numeric DEFAULT 0.009 NOT NULL,
    creater_platform character varying(3),
    confirmer_platform character varying(3),
    ad_owner_parent_id integer,
    trade_initiator_parent_id integer,
    ref_bonus_percent numeric,
    status_advanced p2p.trade_status_advanced,
    created_at timestamp without time zone NOT NULL,
    second_dispute_notification_shown boolean DEFAULT false NOT NULL,
    tips_payed boolean DEFAULT false NOT NULL,
    tips_amount numeric,
    CONSTRAINT check_amount CHECK ((amount > (0)::numeric)),
    CONSTRAINT check_cryptoamount CHECK (((cryptoamount)::numeric > (0)::numeric)),
    CONSTRAINT trades_check CHECK (((trade_initiator = crypto_seller) OR (trade_initiator = crypto_buyer)))
);


ALTER TABLE p2p.trade OWNER TO bitzlato;

--
-- Name: trade_history; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.trade_history (
    id integer NOT NULL,
    trade_id integer NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    status p2p.trade_state NOT NULL,
    reason text NOT NULL,
    status_advanced p2p.trade_status_advanced
);


ALTER TABLE p2p.trade_history OWNER TO bitzlato;

--
-- Name: trade_history_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.trade_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.trade_history_id_seq OWNER TO bitzlato;

--
-- Name: trade_history_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.trade_history_id_seq OWNED BY p2p.trade_history.id;


--
-- Name: trade_statistic_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.trade_statistic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.trade_statistic_id_seq OWNER TO bitzlato;

--
-- Name: trade_statistic_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.trade_statistic_id_seq OWNED BY p2p.trade_statistic.id;


--
-- Name: trade_statistic_log; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.trade_statistic_log (
    id integer NOT NULL,
    ts_id integer NOT NULL,
    old_value text NOT NULL,
    new_value text NOT NULL,
    cause text NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    admin_code public.text_code NOT NULL
);


ALTER TABLE p2p.trade_statistic_log OWNER TO bitzlato;

--
-- Name: trade_statistic_log_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.trade_statistic_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.trade_statistic_log_id_seq OWNER TO bitzlato;

--
-- Name: trade_statistic_log_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.trade_statistic_log_id_seq OWNED BY p2p.trade_statistic_log.id;


--
-- Name: trades_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.trades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.trades_id_seq OWNER TO bitzlato;

--
-- Name: trades_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.trades_id_seq OWNED BY p2p.trade.id;


--
-- Name: untrusted_user; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.untrusted_user (
    id integer NOT NULL,
    user_id integer NOT NULL,
    reason text NOT NULL,
    date timestamp without time zone NOT NULL,
    admin_code public.text_code NOT NULL,
    active boolean DEFAULT true NOT NULL,
    expires_at timestamp without time zone NOT NULL
);


ALTER TABLE p2p.untrusted_user OWNER TO bitzlato;

--
-- Name: untrusted_users_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.untrusted_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.untrusted_users_id_seq OWNER TO bitzlato;

--
-- Name: untrusted_users_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.untrusted_users_id_seq OWNED BY p2p.untrusted_user.id;


--
-- Name: user_2fa; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_2fa (
    id integer NOT NULL,
    user_id integer NOT NULL,
    secret character varying(20) NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE p2p.user_2fa OWNER TO bitzlato;

--
-- Name: user_action_freeze; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_action_freeze (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    ends_at timestamp without time zone NOT NULL,
    freeze_type text NOT NULL,
    reason text NOT NULL,
    active boolean DEFAULT true NOT NULL,
    admin_code public.text_code
);


ALTER TABLE p2p.user_action_freeze OWNER TO bitzlato;

--
-- Name: user_actions_freeze_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.user_actions_freeze_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.user_actions_freeze_id_seq OWNER TO bitzlato;

--
-- Name: user_actions_freeze_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.user_actions_freeze_id_seq OWNED BY p2p.user_action_freeze.id;


--
-- Name: user_ad_filter; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_ad_filter (
    user_id integer NOT NULL,
    settings_json jsonb NOT NULL
);


ALTER TABLE p2p.user_ad_filter OWNER TO bitzlato;

--
-- Name: user_block; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_block (
    id integer NOT NULL,
    user_id integer NOT NULL,
    blocked_user_id integer NOT NULL,
    date timestamp without time zone NOT NULL
);


ALTER TABLE p2p.user_block OWNER TO bitzlato;

--
-- Name: user_block_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.user_block_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.user_block_id_seq OWNER TO bitzlato;

--
-- Name: user_block_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.user_block_id_seq OWNED BY p2p.user_block.id;


--
-- Name: user_feature; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_feature (
    user_id integer NOT NULL,
    feature_code character varying(63) NOT NULL
);


ALTER TABLE p2p.user_feature OWNER TO bitzlato;

--
-- Name: user_note; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_note (
    id integer NOT NULL,
    user_id integer NOT NULL,
    for_user_id integer NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE p2p.user_note OWNER TO bitzlato;

--
-- Name: user_notes_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.user_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.user_notes_id_seq OWNER TO bitzlato;

--
-- Name: user_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.user_notes_id_seq OWNED BY p2p.user_note.id;


--
-- Name: user_profile_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.user_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.user_profile_id_seq OWNER TO bitzlato;

--
-- Name: user_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.user_profile_id_seq OWNED BY p2p.user_profile.id;


--
-- Name: user_rate; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_rate (
    id integer NOT NULL,
    user_id integer NOT NULL,
    rate_id integer NOT NULL
);


ALTER TABLE p2p.user_rate OWNER TO bitzlato;

--
-- Name: user_rates_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.user_rates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.user_rates_id_seq OWNER TO bitzlato;

--
-- Name: user_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.user_rates_id_seq OWNED BY p2p.user_rate.id;


--
-- Name: user_settings; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_settings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    save_requisites boolean DEFAULT true NOT NULL,
    notifications jsonb
);


ALTER TABLE p2p.user_settings OWNER TO bitzlato;

--
-- Name: user_settings_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.user_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.user_settings_id_seq OWNER TO bitzlato;

--
-- Name: user_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.user_settings_id_seq OWNED BY p2p.user_settings.id;


--
-- Name: user_trust; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.user_trust (
    id integer NOT NULL,
    user_id integer NOT NULL,
    trusted_user_id integer NOT NULL,
    trust boolean NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE p2p.user_trust OWNER TO bitzlato;

--
-- Name: user_trust_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.user_trust_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.user_trust_id_seq OWNER TO bitzlato;

--
-- Name: user_trust_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.user_trust_id_seq OWNED BY p2p.user_trust.id;


--
-- Name: users_2fa_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.users_2fa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.users_2fa_id_seq OWNER TO bitzlato;

--
-- Name: users_2fa_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.users_2fa_id_seq OWNED BY p2p.user_2fa.id;


--
-- Name: utm_statistic; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.utm_statistic (
    user_id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    utm_source character varying(255) NOT NULL,
    utm_medium character varying(255),
    utm_campaign character varying(255),
    utm_term character varying(255),
    utm_content character varying(255)
);


ALTER TABLE p2p.utm_statistic OWNER TO bitzlato;

--
-- Name: voucher; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.voucher (
    id integer NOT NULL,
    secret_key text NOT NULL,
    cc_code public.cryptocurrency_code NOT NULL,
    amount public.cryptocurrency_amount NOT NULL,
    currency character varying(3) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    cashed_at timestamp without time zone,
    user_id integer NOT NULL,
    cashed_by_user_id integer,
    comment text,
    comment_by_cashed_user text,
    CONSTRAINT check_amount CHECK (((amount)::numeric > (0)::numeric))
);


ALTER TABLE p2p.voucher OWNER TO bitzlato;

--
-- Name: voucher_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.voucher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.voucher_id_seq OWNER TO bitzlato;

--
-- Name: voucher_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.voucher_id_seq OWNED BY p2p.voucher.id;


--
-- Name: vw_audit; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.vw_audit AS
 SELECT a1.id,
    a1.date,
    a1.cryptocurrency,
    a2."totalIn" AS total_in,
    a2."totalOut" AS total_out,
    a2."totalAudit" AS total_audit,
    a2."totalWallets" AS total_wallets,
    a2."coldWalletAdjust" AS cold_wallet_adjust,
    a2."totalBalancesFree" AS total_balances_free,
    a2."systemWalletBalance" AS system_wallet_balance,
    a2."totalBalancesHolded" AS total_balances_holded,
    a2."realColdWalletBalance" AS real_cold_wallet_balance,
    a2."systemHotWalletBalance" AS system_hot_wallet_balance,
    a2."totalWalletsColdAndHot" AS total_wallets_cold_and_hot,
    a2."hotWalletUnconfirmedBalance" AS hot_wallet_unconfirmed_balance,
    a2."pendingPayments" AS pending_payments,
    a2."totalNetworkFee" AS total_network_fee
   FROM (( SELECT a.id,
            a.date,
            (jsonb_each(a.audit_json)).key AS key,
            (jsonb_each(a.audit_json)).value AS value
           FROM ( SELECT a_1.id,
                    a_1.date,
                    a_1.audit_json
                   FROM p2p.audit a_1
                  ORDER BY a_1.id DESC) a) a1(id, date, cryptocurrency, data)
     CROSS JOIN LATERAL ( SELECT jsonb_populate_record."totalIn",
            jsonb_populate_record."totalOut",
            jsonb_populate_record."totalAudit",
            jsonb_populate_record."totalWallets",
            jsonb_populate_record."coldWalletAdjust",
            jsonb_populate_record."totalBalancesFree",
            jsonb_populate_record."systemWalletBalance",
            jsonb_populate_record."totalBalancesHolded",
            jsonb_populate_record."realColdWalletBalance",
            jsonb_populate_record."systemHotWalletBalance",
            jsonb_populate_record."totalWalletsColdAndHot",
            jsonb_populate_record."hotWalletUnconfirmedBalance",
            jsonb_populate_record."pendingPayments",
            jsonb_populate_record."totalNetworkFee"
           FROM jsonb_populate_record(NULL::p2p.audit_rec, a1.data) jsonb_populate_record("totalIn", "totalOut", "totalAudit", "totalWallets", "coldWalletAdjust", "totalBalancesFree", "systemWalletBalance", "totalBalancesHolded", "realColdWalletBalance", "systemHotWalletBalance", "totalWalletsColdAndHot", "hotWalletUnconfirmedBalance", "pendingPayments", "totalNetworkFee")) a2);


ALTER TABLE p2p.vw_audit OWNER TO bitzlato;

--
-- Name: vw_audit_latest; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.vw_audit_latest AS
 SELECT a1.id,
    a1.date,
    a1.cryptocurrency,
    a2."totalIn" AS total_in,
    a2."totalOut" AS total_out,
    a2."totalAudit" AS total_audit,
    a2."totalWallets" AS total_wallets,
    a2."coldWalletAdjust" AS cold_wallet_adjust,
    a2."totalBalancesFree" AS total_balances_free,
    a2."systemWalletBalance" AS system_wallet_balance,
    a2."totalBalancesHolded" AS total_balances_holded,
    a2."realColdWalletBalance" AS real_cold_wallet_balance,
    a2."systemHotWalletBalance" AS system_hot_wallet_balance,
    a2."totalWalletsColdAndHot" AS total_wallets_cold_and_hot,
    a2."hotWalletUnconfirmedBalance" AS hot_wallet_unconfirmed_balance,
    a2."pendingPayments" AS pending_payments,
    a2."totalNetworkFee" AS total_network_fee
   FROM (( SELECT a.id,
            a.date,
            (jsonb_each(a.audit_json)).key AS key,
            (jsonb_each(a.audit_json)).value AS value
           FROM ( SELECT a_1.id,
                    a_1.date,
                    a_1.audit_json
                   FROM p2p.audit a_1
                  ORDER BY a_1.id DESC
                 LIMIT 1) a) a1(id, date, cryptocurrency, data)
     CROSS JOIN LATERAL ( SELECT jsonb_populate_record."totalIn",
            jsonb_populate_record."totalOut",
            jsonb_populate_record."totalAudit",
            jsonb_populate_record."totalWallets",
            jsonb_populate_record."coldWalletAdjust",
            jsonb_populate_record."totalBalancesFree",
            jsonb_populate_record."systemWalletBalance",
            jsonb_populate_record."totalBalancesHolded",
            jsonb_populate_record."realColdWalletBalance",
            jsonb_populate_record."systemHotWalletBalance",
            jsonb_populate_record."totalWalletsColdAndHot",
            jsonb_populate_record."hotWalletUnconfirmedBalance",
            jsonb_populate_record."pendingPayments",
            jsonb_populate_record."totalNetworkFee"
           FROM jsonb_populate_record(NULL::p2p.audit_rec, a1.data) jsonb_populate_record("totalIn", "totalOut", "totalAudit", "totalWallets", "coldWalletAdjust", "totalBalancesFree", "systemWalletBalance", "totalBalancesHolded", "realColdWalletBalance", "systemHotWalletBalance", "totalWalletsColdAndHot", "hotWalletUnconfirmedBalance", "pendingPayments", "totalNetworkFee")) a2);


ALTER TABLE p2p.vw_audit_latest OWNER TO bitzlato;

--
-- Name: blockchain_tx; Type: TABLE; Schema: public; Owner: bitzlato
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


ALTER TABLE public.blockchain_tx OWNER TO bitzlato;

--
-- Name: deposit; Type: TABLE; Schema: public; Owner: bitzlato
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


ALTER TABLE public.deposit OWNER TO bitzlato;

--
-- Name: user; Type: TABLE; Schema: public; Owner: bitzlato
--

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
    "2fa_enabled" boolean DEFAULT false NOT NULL,
    ref_type p2p.referral_type DEFAULT 'independent'::p2p.referral_type NOT NULL,
    authority_can_make_deal boolean DEFAULT true NOT NULL,
    authority_can_make_order boolean DEFAULT true NOT NULL,
    authority_can_make_voucher boolean DEFAULT true NOT NULL,
    authority_can_make_withdrawal boolean DEFAULT true NOT NULL,
    authority_is_admin boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    password_reset_at timestamp without time zone,
    sys_code character varying(63),
    CONSTRAINT user_check CHECK (((sys_code IS NULL) OR ((telegram_id IS NULL) AND (real_email IS NULL) AND (nickname IS NULL)))),
    CONSTRAINT user_sys_code_check CHECK ((length((sys_code)::text) > 0)),
    CONSTRAINT users_check CHECK ((deleted_at > created_at))
);


ALTER TABLE public."user" OWNER TO bitzlato;

--
-- Name: COLUMN "user".sys_code; Type: COMMENT; Schema: public; Owner: bitzlato
--

COMMENT ON COLUMN public."user".sys_code IS 'Special code for system accounts only, must be unique for each system account. Regular users have don''t have such codes.';


--
-- Name: withdrawal; Type: TABLE; Schema: public; Owner: bitzlato
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
    CONSTRAINT withdrawal_check CHECK (((blockchain_tx_id IS NOT NULL) OR (status = ANY (ARRAY['aml'::public.withdrawal_status,'pending'::public.withdrawal_status, 'in_progress'::public.withdrawal_status, 'cancelled_by_admin'::public.withdrawal_status, 'failed'::public.withdrawal_status])))),
    CONSTRAINT withdrawal_real_pay_fee_check CHECK (((real_pay_fee)::numeric >= (0)::numeric))
)
WITH (fillfactor='90', autovacuum_enabled='on', autovacuum_vacuum_cost_delay='20');


ALTER TABLE public.withdrawal OWNER TO bitzlato;

--
-- Name: vw_audit_source; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.vw_audit_source AS
 WITH sum_withdrawal AS (
         SELECT p.cc_code AS code,
            sum((p.amount)::numeric) FILTER (WHERE (p.status = 'pending'::public.withdrawal_status)) AS pending_payments,
            sum((p.amount)::numeric) FILTER (WHERE (p.status = ANY (ARRAY['pending'::public.withdrawal_status, 'processed'::public.withdrawal_status, 'in_progress'::public.withdrawal_status]))) AS total_out
           FROM public.withdrawal p
          GROUP BY p.cc_code
        ), sum_btx AS (
         SELECT btx.cc_code,
            sum((btx.network_fee)::numeric) AS total_network_fee
           FROM public.blockchain_tx btx
          WHERE (btx.status = 'confirmed'::public.blockchain_tx_status)
          GROUP BY btx.cc_code
        ), sum_wallets AS (
         SELECT w.cc_code AS code,
            sum((w.balance)::numeric) AS total_balances_free,
            sum((w.hold_balance)::numeric) AS total_balances_holded,
            sum(((w.balance)::numeric + (w.hold_balance)::numeric)) AS total_balances
           FROM public.wallet w
          GROUP BY w.cc_code
        ), sum_deposits AS (
         SELECT t.cc_code AS code,
            sum((t.amount)::numeric) FILTER (WHERE (t.status = 'success'::public.deposit_status)) AS total_in,
            sum((t.amount)::numeric) FILTER (WHERE (t.status = 'dust-seizure'::public.deposit_status)) AS total_dust_in
           FROM public.deposit t
          GROUP BY t.cc_code
        ), system_wallets AS (
         SELECT w.cc_code AS code,
            w.balance AS system_wallet_balance
           FROM public.wallet w
          WHERE (w.user_id = ( SELECT "user".id
                   FROM public."user"
                  WHERE (("user".sys_code)::text = 'system'::text)))
        )
 SELECT ccs.code AS cryptocurrency,
    ccs.real_cold_wallet_balance,
    ccs.hot_wallet_balance,
    ccs.hot_wallet_unconfirmed_balance,
    ccs.cold_wallet_audit_adjust,
    sysw.system_wallet_balance,
    COALESCE(sp.pending_payments, (0)::numeric) AS pending_payments,
    COALESCE(sum_btx.total_network_fee, (0)::numeric) AS total_network_fee,
    COALESCE(sp.total_out, (0)::numeric) AS total_out,
    COALESCE(st.total_in, (0)::numeric) AS total_in,
    COALESCE(st.total_dust_in, (0)::numeric) AS total_dust_in,
    COALESCE(sw.total_balances_free, (0)::numeric) AS total_balances_free,
    COALESCE(sw.total_balances_holded, (0)::numeric) AS total_balances_holded,
    (COALESCE(sw.total_balances, (0)::numeric) + COALESCE(sp.pending_payments, (0)::numeric)) AS total_wallets,
    ccs.debt
   FROM (((((p2p.cryptocurrency_settings ccs
     LEFT JOIN sum_btx ON (((ccs.code)::text = (sum_btx.cc_code)::text)))
     LEFT JOIN sum_withdrawal sp ON (((sp.code)::text = (ccs.code)::text)))
     LEFT JOIN sum_wallets sw ON (((sw.code)::text = (ccs.code)::text)))
     LEFT JOIN sum_deposits st ON (((st.code)::text = (ccs.code)::text)))
     LEFT JOIN system_wallets sysw ON (((sysw.code)::text = (ccs.code)::text)))
  WHERE (NOT ccs.is_delisted);


ALTER TABLE p2p.vw_audit_source OWNER TO bitzlato;

--
-- Name: vw_audit_watchdog; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.vw_audit_watchdog AS
 SELECT cc.code AS cryptocurrency,
    (s.total_wallets - (((((s.hot_wallet_balance)::numeric + (s.real_cold_wallet_balance)::numeric) + (s.cold_wallet_audit_adjust)::numeric) + d.sum_amnt) + COALESCE((s.hot_wallet_unconfirmed_balance)::numeric, (0)::numeric))) AS balance,
    s.hot_wallet_balance
   FROM ((p2p.cryptocurrency_settings cc
     LEFT JOIN p2p.vw_audit_source s ON (((s.cryptocurrency)::text = (cc.code)::text)))
     CROSS JOIN LATERAL ( SELECT COALESCE(sum((d_1.amount)::numeric), (0)::numeric) AS sum_amnt
           FROM public.deposit d_1
          WHERE (((d_1.cc_code)::text = (cc.code)::text) AND (d_1.updated_at >= (now() - cc.audit_watchdog_deposit_interval)))) d)
  WHERE cc.withdraw_enabled;


ALTER TABLE p2p.vw_audit_watchdog OWNER TO bitzlato;

--
-- Name: vw_disputes_list; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.vw_disputes_list AS
 WITH islastansweradmin AS (
         SELECT t1_1.trade_id,
            t1_1.from_admin
           FROM ( SELECT t1_2.trade_id,
                    t1_2.from_admin,
                    row_number() OVER (PARTITION BY t1_2.trade_id ORDER BY t1_2.id DESC) AS rn
                   FROM (p2p.chat t1_2
                     JOIN p2p.dispute t2 ON ((t1_2.trade_id = t2.trade_id)))
                  WHERE (t2.resolution IS NULL)) t1_1
          WHERE (t1_1.rn = 1)
        )
 SELECT t1.id,
    t1.trade_id,
    t3.amount,
    t3.currency,
    t1.seller_id,
    t1.buyer_id,
    t1.buyer_reason,
    t1.seller_reason,
    t1.opened_at,
    t1.refund,
    ((CURRENT_TIMESTAMP - (t1.opened_at)::timestamp with time zone))::text AS in_dispute,
    COALESCE(t4.from_admin, false) AS isadminlastmessage
   FROM ((p2p.dispute t1
     LEFT JOIN islastansweradmin t4 ON ((t4.trade_id = t1.trade_id)))
     JOIN p2p.trade t3 ON ((t1.trade_id = t3.id)))
  WHERE ((t1.resolution IS NULL) AND (t1.closed_at IS NULL))
  ORDER BY t1.id DESC
 LIMIT 500;


ALTER TABLE p2p.vw_disputes_list OWNER TO bitzlato;

--
-- Name: vw_inappropriate_ads; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.vw_inappropriate_ads AS
 WITH btc_min_ad_amount AS (
         SELECT cryptocurrency_settings.minimum_ad_enabled_amount AS amount
           FROM p2p.cryptocurrency_settings
          WHERE ((cryptocurrency_settings.code)::text = 'BTC'::text)
        )
 SELECT ad.id,
    ad.user_id
   FROM ((((((((p2p.ad
     CROSS JOIN btc_min_ad_amount)
     JOIN public.cryptocurrency cc ON (((cc.code)::text = (ad.cc_code)::text)))
     JOIN p2p.cryptocurrency_settings ccs ON ((((ccs.code)::text = (ad.cc_code)::text) AND ccs.trades_enabled AND (NOT ccs.is_delisted) AND (NOT ccs.is_shitcoin))))
     JOIN public.user_cryptocurrency_settings uccs ON ((((uccs.cc_code)::text = (cc.code)::text) AND (uccs.user_id = ad.user_id) AND uccs.trading_enabled)))
     JOIN p2p.payment_method pm ON ((pm.id = ad.paymethod)))
     JOIN p2p.rate r ON ((((r.cc_code)::text = (ad.cc_code)::text) AND r.default_rate AND ((r.currency_symbol)::text = (pm.currency)::text))))
     JOIN public.wallet btcw ON (((btcw.user_id = ad.user_id) AND ((btcw.cc_code)::text = 'BTC'::text))))
     JOIN public.wallet w ON (((w.user_id = ad.user_id) AND ((w.cc_code)::text = (cc.code)::text))))
  WHERE ((ad.deleted_at IS NULL) AND (ad.status = 'active'::p2p.ads_status) AND (false OR (ad.rate_value < (r.value * 0.5)) OR (ad.rate_value > (r.value * 1.5)) OR (true AND (ad.type = 'purchase'::p2p.ads_type) AND (NOT (((btcw.balance)::numeric + (btcw.hold_balance)::numeric) >= (btc_min_ad_amount.amount)::numeric)) AND (NOT (((w.balance)::numeric + (w.hold_balance)::numeric) >= (ccs.minimum_ad_enabled_amount)::numeric))) OR (true AND (ad.type = 'selling'::p2p.ads_type) AND (NOT ((w.balance)::numeric > ((ad.min_amount / ad.rate_value) * ((1)::numeric + (ccs.trade_comission_percent)::numeric)))))));


ALTER TABLE p2p.vw_inappropriate_ads OWNER TO bitzlato;

--
-- Name: vw_user_notification_alarm_mode; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.vw_user_notification_alarm_mode AS
 SELECT a.user_id,
    a.notification_code,
    regexp_split_to_array(a.value, ','::text) AS alarm_mode
   FROM ( SELECT us.user_id,
            (jsonb_each_text(us.notifications)).key AS key,
            (jsonb_each_text(us.notifications)).value AS value
           FROM p2p.user_settings us
          WHERE (us.notifications IS NOT NULL)) a(user_id, notification_code, value)
  WHERE (a.value IS NOT NULL);


ALTER TABLE p2p.vw_user_notification_alarm_mode OWNER TO bitzlato;

--
-- Name: vw_user_voucher; Type: VIEW; Schema: p2p; Owner: bitzlato
--

CREATE VIEW p2p.vw_user_voucher AS
 SELECT v.secret_key,
    v.cc_code,
    v.amount,
    v.currency,
    v.created_at,
    v.cashed_at,
    v.user_id,
    v.cashed_by_user_id,
    round(((v.amount)::numeric * p2p.remote_rate_value(u.user_id, u.currency, v.cc_code)), 8) AS fiat_amount,
    (
        CASE
            WHEN (v.cashed_at IS NULL) THEN 'active'::text
            ELSE 'cashed'::text
        END)::p2p.voucher_status_type AS status,
        CASE
            WHEN (v.user_id = u.user_id) THEN v.comment
            ELSE v.comment_by_cashed_user
        END AS comment,
    u.user_id AS voucher_user_id
   FROM (p2p.voucher v
     JOIN p2p.user_profile u ON (((v.user_id = u.user_id) OR (v.cashed_by_user_id = u.user_id))))
  WHERE (v.deleted_at IS NULL)
  ORDER BY v.created_at DESC;


ALTER TABLE p2p.vw_user_voucher OWNER TO bitzlato;

--
-- Name: wallet_log; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.wallet_log (
    wallet_id integer NOT NULL,
    description character varying(100),
    balance_at_the_moment public.cryptocurrency_amount NOT NULL,
    hold_balance_at_moment public.cryptocurrency_amount NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    cause character varying(200),
    currency public.cryptocurrency_code NOT NULL,
    amount public.cryptocurrency_amount NOT NULL,
    source_type p2p.operation_source,
    source_id integer,
    operation_type p2p.operation_type,
    platform character varying(10)
);


ALTER TABLE p2p.wallet_log OWNER TO bitzlato;

--
-- Name: wallet_log_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.wallet_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.wallet_log_id_seq OWNER TO bitzlato;

--
-- Name: wallet_log_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.wallet_log_id_seq OWNED BY p2p."backup$wallet_log".id;


--
-- Name: withdraw_voucher; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.withdraw_voucher (
    id integer NOT NULL,
    user_id integer,
    payment_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    used_at timestamp without time zone,
    secret_key text NOT NULL,
    expire_at timestamp without time zone DEFAULT (now() + '1 mon'::interval) NOT NULL,
    first_notification_sent boolean DEFAULT false NOT NULL,
    second_notification_sent boolean DEFAULT false NOT NULL,
    prime_time_event_name character varying(64)
);


ALTER TABLE p2p.withdraw_voucher OWNER TO bitzlato;

--
-- Name: withdraw_voucher_prime_time; Type: TABLE; Schema: p2p; Owner: bitzlato
--

CREATE TABLE p2p.withdraw_voucher_prime_time (
    name character varying(63) NOT NULL,
    active boolean DEFAULT true NOT NULL,
    from_hour smallint,
    to_hour smallint,
    monday boolean DEFAULT true NOT NULL,
    tuesday boolean DEFAULT true NOT NULL,
    wednesday boolean DEFAULT true NOT NULL,
    thursday boolean DEFAULT true NOT NULL,
    friday boolean DEFAULT true NOT NULL,
    saturday boolean DEFAULT true NOT NULL,
    sunday boolean DEFAULT true NOT NULL,
    min_amount public.cryptocurrency_amount DEFAULT 0 NOT NULL,
    start_at timestamp without time zone DEFAULT now() NOT NULL,
    expires_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    per_user_limit integer DEFAULT 1 NOT NULL,
    CONSTRAINT withdraw_vouchers_prime_time_check CHECK ((from_hour <= to_hour)),
    CONSTRAINT withdraw_vouchers_prime_time_check1 CHECK ((expires_at > start_at)),
    CONSTRAINT withdraw_vouchers_prime_time_from_hour_check CHECK (((from_hour >= 0) AND (from_hour <= 23))),
    CONSTRAINT withdraw_vouchers_prime_time_from_hour_check1 CHECK (((from_hour >= 0) AND (from_hour <= 23))),
    CONSTRAINT withdraw_vouchers_prime_time_min_amount_check CHECK (((min_amount)::numeric >= (0)::numeric)),
    CONSTRAINT withdraw_vouchers_prime_time_name_check CHECK ((length((name)::text) > 0)),
    CONSTRAINT withdraw_vouchers_prime_time_per_user_limit_check CHECK ((per_user_limit > 0))
);


ALTER TABLE p2p.withdraw_voucher_prime_time OWNER TO bitzlato;

--
-- Name: withdraw_vouchers_id_seq; Type: SEQUENCE; Schema: p2p; Owner: bitzlato
--

CREATE SEQUENCE p2p.withdraw_vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE p2p.withdraw_vouchers_id_seq OWNER TO bitzlato;

--
-- Name: withdraw_vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: p2p; Owner: bitzlato
--

ALTER SEQUENCE p2p.withdraw_vouchers_id_seq OWNED BY p2p.withdraw_voucher.id;


--
-- Name: pg_stat_activity; Type: VIEW; Schema: postgres_exporter; Owner: postgres
--

CREATE VIEW postgres_exporter.pg_stat_activity AS
 SELECT pg_stat_activity.datid,
    pg_stat_activity.datname,
    pg_stat_activity.pid,
    pg_stat_activity.usesysid,
    pg_stat_activity.usename,
    pg_stat_activity.application_name,
    pg_stat_activity.client_addr,
    pg_stat_activity.client_hostname,
    pg_stat_activity.client_port,
    pg_stat_activity.backend_start,
    pg_stat_activity.xact_start,
    pg_stat_activity.query_start,
    pg_stat_activity.state_change,
    pg_stat_activity.wait_event_type,
    pg_stat_activity.wait_event,
    pg_stat_activity.state,
    pg_stat_activity.backend_xid,
    pg_stat_activity.backend_xmin,
    pg_stat_activity.query,
    pg_stat_activity.backend_type
   FROM pg_stat_activity;


ALTER TABLE postgres_exporter.pg_stat_activity OWNER TO postgres;

--
-- Name: pg_stat_replication; Type: VIEW; Schema: postgres_exporter; Owner: postgres
--

CREATE VIEW postgres_exporter.pg_stat_replication AS
 SELECT pg_stat_replication.pid,
    pg_stat_replication.usesysid,
    pg_stat_replication.usename,
    pg_stat_replication.application_name,
    pg_stat_replication.client_addr,
    pg_stat_replication.client_hostname,
    pg_stat_replication.client_port,
    pg_stat_replication.backend_start,
    pg_stat_replication.backend_xmin,
    pg_stat_replication.state,
    pg_stat_replication.sent_lsn,
    pg_stat_replication.write_lsn,
    pg_stat_replication.flush_lsn,
    pg_stat_replication.replay_lsn,
    pg_stat_replication.write_lag,
    pg_stat_replication.flush_lag,
    pg_stat_replication.replay_lag,
    pg_stat_replication.sync_priority,
    pg_stat_replication.sync_state
   FROM pg_stat_replication;


ALTER TABLE postgres_exporter.pg_stat_replication OWNER TO postgres;

--
-- Name: account; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.account (
    id integer NOT NULL,
    kyc_status public.kyc_status DEFAULT 'NONE'::public.kyc_status NOT NULL
);


ALTER TABLE public.account OWNER TO bitzlato;

--
-- Name: account_kyc_hist; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.account_kyc_hist (
    acc_id integer NOT NULL,
    correlation_id character varying(126) NOT NULL,
    provider public.kyc_provider NOT NULL,
    status public.kyc_status NOT NULL,
    source jsonb,
    at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.account_kyc_hist OWNER TO bitzlato;

--
-- Name: account_swap_log; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.account_swap_log (
    id integer NOT NULL,
    old_user_id integer NOT NULL,
    new_user_id integer NOT NULL,
    cause character varying(512) NOT NULL,
    admin_code public.text_code NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.account_swap_log OWNER TO bitzlato;

--
-- Name: account_swap_log_id_seq; Type: SEQUENCE; Schema: public; Owner: bitzlato
--

CREATE SEQUENCE public.account_swap_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_swap_log_id_seq OWNER TO bitzlato;

--
-- Name: account_swap_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitzlato
--

ALTER SEQUENCE public.account_swap_log_id_seq OWNED BY public.account_swap_log.id;


--
-- Name: admin_user; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.admin_user (
    code public.text_code NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    role public.admin_role DEFAULT 'superuser'::public.admin_role NOT NULL,
    user_id integer
);


ALTER TABLE public.admin_user OWNER TO bitzlato;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: cerberus
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO cerberus;

--
-- Name: backup$wallet_log_unknown_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."backup$wallet_log_unknown_users" (
    wallet_id integer,
    description character varying(100),
    balance_at_the_moment public.cryptocurrency_amount,
    hold_balance_at_moment public.cryptocurrency_amount,
    date timestamp without time zone,
    cause character varying(200),
    currency public.cryptocurrency_code,
    amount public.cryptocurrency_amount,
    source_type p2p.operation_source,
    source_id integer,
    operation_type p2p.operation_type,
    platform character varying(10)
);


ALTER TABLE public."backup$wallet_log_unknown_users" OWNER TO postgres;

--
-- Name: backup$wallet_unknown_users; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."backup$wallet_unknown_users" (
    id integer,
    user_id integer,
    address character varying(800),
    balance public.cryptocurrency_amount,
    hold_balance public.cryptocurrency_amount,
    created_at timestamp(0) without time zone,
    updated_at timestamp without time zone,
    debt public.cryptocurrency_amount,
    cc_code public.cryptocurrency_code
);


ALTER TABLE public."backup$wallet_unknown_users" OWNER TO bitzlato;

--
-- Name: banned_user; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.banned_user (
    user_id integer NOT NULL,
    reason text,
    action public.ban_action NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    admin_code public.text_code NOT NULL
);


ALTER TABLE public.banned_user OWNER TO bitzlato;

--
-- Name: blockchain_tx_id_seq; Type: SEQUENCE; Schema: public; Owner: bitzlato
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
-- Name: event; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.event (
    id integer NOT NULL,
    event_type public.event_type NOT NULL,
    entity_type public.entity NOT NULL,
    entity_id integer NOT NULL,
    event_data_json jsonb NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.event OWNER TO bitzlato;

--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: bitzlato
--

CREATE SEQUENCE public.event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_id_seq OWNER TO bitzlato;

--
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitzlato
--

ALTER SEQUENCE public.event_id_seq OWNED BY public.event.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: bitzlato
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


ALTER TABLE public.flyway_schema_history OWNER TO bitzlato;

--
-- Name: lock_monitor; Type: VIEW; Schema: public; Owner: postgres
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


ALTER TABLE public.lock_monitor OWNER TO postgres;

--
-- Name: withdrawal_log; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.withdrawal_log (
    id integer NOT NULL,
    withdrawal_id integer NOT NULL,
    log text NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.withdrawal_log OWNER TO bitzlato;

--
-- Name: payment_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: bitzlato
--

CREATE SEQUENCE public.payment_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_logs_id_seq OWNER TO bitzlato;

--
-- Name: payment_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitzlato
--

ALTER SEQUENCE public.payment_logs_id_seq OWNED BY public.withdrawal_log.id;


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: bitzlato
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO bitzlato;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitzlato
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.withdrawal.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: cerberus
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO cerberus;

--
-- Name: signed_operation_request; Type: TABLE; Schema: public; Owner: bitzlato
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


ALTER TABLE public.signed_operation_request OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220131; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220131" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220131" FOR VALUES IN ('2022-01-31');


ALTER TABLE public."signed_operation_request$20220131" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220201; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220201" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220201" FOR VALUES IN ('2022-02-01');


ALTER TABLE public."signed_operation_request$20220201" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220202; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220202" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220202" FOR VALUES IN ('2022-02-02');


ALTER TABLE public."signed_operation_request$20220202" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220203; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220203" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220203" FOR VALUES IN ('2022-02-03');


ALTER TABLE public."signed_operation_request$20220203" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220204; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220204" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220204" FOR VALUES IN ('2022-02-04');


ALTER TABLE public."signed_operation_request$20220204" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220205; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220205" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220205" FOR VALUES IN ('2022-02-05');


ALTER TABLE public."signed_operation_request$20220205" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220206; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220206" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220206" FOR VALUES IN ('2022-02-06');


ALTER TABLE public."signed_operation_request$20220206" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220207; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220207" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220207" FOR VALUES IN ('2022-02-07');


ALTER TABLE public."signed_operation_request$20220207" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220208; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220208" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220208" FOR VALUES IN ('2022-02-08');


ALTER TABLE public."signed_operation_request$20220208" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220209; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220209" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220209" FOR VALUES IN ('2022-02-09');


ALTER TABLE public."signed_operation_request$20220209" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220210; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220210" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220210" FOR VALUES IN ('2022-02-10');


ALTER TABLE public."signed_operation_request$20220210" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220211; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220211" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220211" FOR VALUES IN ('2022-02-11');


ALTER TABLE public."signed_operation_request$20220211" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220212; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220212" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220212" FOR VALUES IN ('2022-02-12');


ALTER TABLE public."signed_operation_request$20220212" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220213; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220213" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220213" FOR VALUES IN ('2022-02-13');


ALTER TABLE public."signed_operation_request$20220213" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220214; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220214" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220214" FOR VALUES IN ('2022-02-14');


ALTER TABLE public."signed_operation_request$20220214" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220215; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220215" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220215" FOR VALUES IN ('2022-02-15');


ALTER TABLE public."signed_operation_request$20220215" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220216; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220216" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220216" FOR VALUES IN ('2022-02-16');


ALTER TABLE public."signed_operation_request$20220216" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220217; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220217" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220217" FOR VALUES IN ('2022-02-17');


ALTER TABLE public."signed_operation_request$20220217" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220218; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220218" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220218" FOR VALUES IN ('2022-02-18');


ALTER TABLE public."signed_operation_request$20220218" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220219; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220219" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220219" FOR VALUES IN ('2022-02-19');


ALTER TABLE public."signed_operation_request$20220219" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220220; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220220" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220220" FOR VALUES IN ('2022-02-20');


ALTER TABLE public."signed_operation_request$20220220" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220221; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220221" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220221" FOR VALUES IN ('2022-02-21');


ALTER TABLE public."signed_operation_request$20220221" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220222; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220222" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220222" FOR VALUES IN ('2022-02-22');


ALTER TABLE public."signed_operation_request$20220222" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220223; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220223" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220223" FOR VALUES IN ('2022-02-23');


ALTER TABLE public."signed_operation_request$20220223" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220224; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220224" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220224" FOR VALUES IN ('2022-02-24');


ALTER TABLE public."signed_operation_request$20220224" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220225; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220225" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220225" FOR VALUES IN ('2022-02-25');


ALTER TABLE public."signed_operation_request$20220225" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220226; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220226" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220226" FOR VALUES IN ('2022-02-26');


ALTER TABLE public."signed_operation_request$20220226" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220227; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220227" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220227" FOR VALUES IN ('2022-02-27');


ALTER TABLE public."signed_operation_request$20220227" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220228; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220228" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220228" FOR VALUES IN ('2022-02-28');


ALTER TABLE public."signed_operation_request$20220228" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220301; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220301" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220301" FOR VALUES IN ('2022-03-01');


ALTER TABLE public."signed_operation_request$20220301" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220302; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220302" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220302" FOR VALUES IN ('2022-03-02');


ALTER TABLE public."signed_operation_request$20220302" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220303; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220303" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220303" FOR VALUES IN ('2022-03-03');


ALTER TABLE public."signed_operation_request$20220303" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220304; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220304" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220304" FOR VALUES IN ('2022-03-04');


ALTER TABLE public."signed_operation_request$20220304" OWNER TO bitzlato;

--
-- Name: signed_operation_request$20220305; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."signed_operation_request$20220305" (
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
ALTER TABLE ONLY public.signed_operation_request ATTACH PARTITION public."signed_operation_request$20220305" FOR VALUES IN ('2022-03-05');


ALTER TABLE public."signed_operation_request$20220305" OWNER TO bitzlato;

--
-- Name: signed_operation_request_id_seq; Type: SEQUENCE; Schema: public; Owner: bitzlato
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
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: bitzlato
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_id_seq OWNER TO bitzlato;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitzlato
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.deposit.id;


--
-- Name: user_auth_pub_key; Type: TABLE; Schema: public; Owner: bitzlato
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


ALTER TABLE public.user_auth_pub_key OWNER TO bitzlato;

--
-- Name: user_token_mfa; Type: TABLE; Schema: public; Owner: bitzlato
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


ALTER TABLE public.user_token_mfa OWNER TO bitzlato;

--
-- Name: user_token_mfa$20220227; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."user_token_mfa$20220227" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20220227" FOR VALUES IN ('2022-02-27');


ALTER TABLE public."user_token_mfa$20220227" OWNER TO bitzlato;

--
-- Name: user_token_mfa$20220228; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."user_token_mfa$20220228" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20220228" FOR VALUES IN ('2022-02-28');


ALTER TABLE public."user_token_mfa$20220228" OWNER TO bitzlato;

--
-- Name: user_token_mfa$20220301; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."user_token_mfa$20220301" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20220301" FOR VALUES IN ('2022-03-01');


ALTER TABLE public."user_token_mfa$20220301" OWNER TO bitzlato;

--
-- Name: user_token_mfa$20220302; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."user_token_mfa$20220302" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20220302" FOR VALUES IN ('2022-03-02');


ALTER TABLE public."user_token_mfa$20220302" OWNER TO bitzlato;

--
-- Name: user_token_mfa$20220303; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."user_token_mfa$20220303" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20220303" FOR VALUES IN ('2022-03-03');


ALTER TABLE public."user_token_mfa$20220303" OWNER TO bitzlato;

--
-- Name: user_token_mfa$20220304; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public."user_token_mfa$20220304" (
    jwt_hash character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_date date NOT NULL,
    expires_time time without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    mfa_passed_at timestamp without time zone DEFAULT now() NOT NULL
)
WITH (autovacuum_enabled='false', fillfactor='100');
ALTER TABLE ONLY public.user_token_mfa ATTACH PARTITION public."user_token_mfa$20220304" FOR VALUES IN ('2022-03-04');


ALTER TABLE public."user_token_mfa$20220304" OWNER TO bitzlato;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: bitzlato
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO bitzlato;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitzlato
--

ALTER SEQUENCE public.users_id_seq OWNED BY public."user".id;


--
-- Name: vw_admin; Type: VIEW; Schema: public; Owner: bitzlato
--

CREATE VIEW public.vw_admin AS
 SELECT au.code,
    au.role,
    au.user_id,
    (au.code)::character varying AS display_name,
    au.created_at,
    au.updated_at
   FROM public.admin_user au;


ALTER TABLE public.vw_admin OWNER TO bitzlato;

--
-- Name: wallet_address; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.wallet_address (
    cc_code public.cryptocurrency_code NOT NULL,
    acc_id integer NOT NULL,
    address character varying(800) NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.wallet_address OWNER TO bitzlato;

--
-- Name: wallet_address_hist; Type: TABLE; Schema: public; Owner: bitzlato
--

CREATE TABLE public.wallet_address_hist (
    user_id integer NOT NULL,
    cryptocurrency_code character varying(4) NOT NULL,
    address character varying(800) NOT NULL,
    active_from timestamp(0) without time zone NOT NULL,
    active_till timestamp without time zone NOT NULL,
    admin_code public.text_code,
    reason public.wallet_address_change_reason NOT NULL,
    comment character varying(1024),
    action_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT wallet_address_hist_check CHECK ((NOT ((admin_code IS NULL) AND (reason = 'admin_reset'::public.wallet_address_change_reason))))
);


ALTER TABLE public.wallet_address_hist OWNER TO bitzlato;

--
-- Name: COLUMN wallet_address_hist.active_from; Type: COMMENT; Schema: public; Owner: bitzlato
--

COMMENT ON COLUMN public.wallet_address_hist.active_from IS 'wallets.created_at';


--
-- Name: COLUMN wallet_address_hist.active_till; Type: COMMENT; Schema: public; Owner: bitzlato
--

COMMENT ON COLUMN public.wallet_address_hist.active_till IS 'wallets.updated_at';


--
-- Name: wallets_id_seq; Type: SEQUENCE; Schema: public; Owner: bitzlato
--

CREATE SEQUENCE public.wallets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wallets_id_seq OWNER TO bitzlato;

--
-- Name: wallets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitzlato
--

ALTER SEQUENCE public.wallets_id_seq OWNED BY public.wallet.id;


--
-- Name: public_names_pool; Type: TABLE; Schema: sec; Owner: bitzlato
--

CREATE TABLE sec.public_names_pool (
    name character varying(28) NOT NULL,
    in_use_since timestamp without time zone
);


ALTER TABLE sec.public_names_pool OWNER TO bitzlato;

--
-- Name: user_mobile_push_token; Type: TABLE; Schema: sec; Owner: bitzlato
--

CREATE TABLE sec.user_mobile_push_token (
    token character varying(4096) NOT NULL,
    user_id integer NOT NULL,
    unique_device_id character varying(126) NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE sec.user_mobile_push_token OWNER TO bitzlato;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: whaler; Owner: whaler
--

CREATE TABLE whaler.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE whaler.ar_internal_metadata OWNER TO whaler;

--
-- Name: schema_migrations; Type: TABLE; Schema: whaler; Owner: whaler
--

CREATE TABLE whaler.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE whaler.schema_migrations OWNER TO whaler;

--
-- Name: transfers; Type: TABLE; Schema: whaler; Owner: whaler
--

CREATE TABLE whaler.transfers (
    id bigint NOT NULL,
    user_id bigint,
    amount numeric NOT NULL,
    currency_code character varying NOT NULL,
    source character varying NOT NULL,
    destination character varying NOT NULL,
    peatio_response_status character varying,
    peatio_response_body text,
    description character varying NOT NULL,
    meta jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    remote_ip inet NOT NULL,
    user_agent character varying NOT NULL,
    receive_attempts integer DEFAULT 0 NOT NULL,
    send_attempts integer DEFAULT 0 NOT NULL,
    log jsonb DEFAULT '[]'::jsonb NOT NULL,
    jid character varying,
    pid integer,
    state character varying DEFAULT 'pending'::character varying NOT NULL,
    received_at timestamp without time zone,
    sent_at timestamp without time zone,
    cancel_message character varying,
    canceling_at timestamp without time zone,
    member_uid character varying NOT NULL,
    peatio_member_transfer_id integer,
    refunded_at timestamp without time zone,
    refund_started_at timestamp without time zone,
    fail_message character varying,
    CONSTRAINT positive_amoount CHECK ((amount > (0)::numeric))
);


ALTER TABLE whaler.transfers OWNER TO whaler;

--
-- Name: COLUMN transfers.jid; Type: COMMENT; Schema: whaler; Owner: whaler
--

COMMENT ON COLUMN whaler.transfers.jid IS 'Async job id';


--
-- Name: COLUMN transfers.pid; Type: COMMENT; Schema: whaler; Owner: whaler
--

COMMENT ON COLUMN whaler.transfers.pid IS 'Id of processor running this transfer';


--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: whaler; Owner: whaler
--

CREATE SEQUENCE whaler.transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE whaler.transfers_id_seq OWNER TO whaler;

--
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: whaler; Owner: whaler
--

ALTER SEQUENCE whaler.transfers_id_seq OWNED BY whaler.transfers.id;


--
-- Name: wallet_transfers; Type: TABLE; Schema: whaler; Owner: whaler
--

CREATE TABLE whaler.wallet_transfers (
    id bigint NOT NULL,
    source_wallet_id bigint NOT NULL,
    destination_wallet_id bigint NOT NULL,
    amount numeric NOT NULL,
    source_wallet_balance_after numeric NOT NULL,
    destination_wallet_balance_after numeric NOT NULL,
    currency_code character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    transfer_id bigint NOT NULL,
    source_wallet_balance_before numeric NOT NULL,
    destination_wallet_balance_before numeric,
    CONSTRAINT positive_amoount CHECK ((amount > (0)::numeric))
);


ALTER TABLE whaler.wallet_transfers OWNER TO whaler;

--
-- Name: wallet_transfers_id_seq; Type: SEQUENCE; Schema: whaler; Owner: whaler
--

CREATE SEQUENCE whaler.wallet_transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE whaler.wallet_transfers_id_seq OWNER TO whaler;

--
-- Name: wallet_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: whaler; Owner: whaler
--

ALTER SEQUENCE whaler.wallet_transfers_id_seq OWNED BY whaler.wallet_transfers.id;


--
-- Name: audit_user id; Type: DEFAULT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.audit_user ALTER COLUMN id SET DEFAULT nextval('cleanup.audit_users_id_seq'::regclass);


--
-- Name: auth_stats id; Type: DEFAULT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.auth_stats ALTER COLUMN id SET DEFAULT nextval('cleanup.auth_stats_id_seq'::regclass);


--
-- Name: broadcast_result id; Type: DEFAULT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.broadcast_result ALTER COLUMN id SET DEFAULT nextval('cleanup.mailing_result_id_seq'::regclass);


--
-- Name: country_code id; Type: DEFAULT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.country_code ALTER COLUMN id SET DEFAULT nextval('cleanup.country_codes_id_seq'::regclass);


--
-- Name: daily_reports_dash id; Type: DEFAULT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.daily_reports_dash ALTER COLUMN id SET DEFAULT nextval('cleanup.daily_reports_dash_id_seq'::regclass);


--
-- Name: one_time_code id; Type: DEFAULT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.one_time_code ALTER COLUMN id SET DEFAULT nextval('cleanup.one_time_codes_id_seq'::regclass);


--
-- Name: stablecoin_exchange id; Type: DEFAULT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.stablecoin_exchange ALTER COLUMN id SET DEFAULT nextval('cleanup.stablecoin_exchange_id_seq'::regclass);


--
-- Name: trade_stats id; Type: DEFAULT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.trade_stats ALTER COLUMN id SET DEFAULT nextval('cleanup.trade_stats_id_seq'::regclass);


--
-- Name: address_analyses id; Type: DEFAULT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.address_analyses ALTER COLUMN id SET DEFAULT nextval('meduza.address_analyses_id_seq'::regclass);


--
-- Name: analysis_results id; Type: DEFAULT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.analysis_results ALTER COLUMN id SET DEFAULT nextval('meduza.analysis_results_id_seq'::regclass);


--
-- Name: analyzed_users id; Type: DEFAULT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.analyzed_users ALTER COLUMN id SET DEFAULT nextval('meduza.analyzed_users_id_seq'::regclass);


--
-- Name: pending_analyses id; Type: DEFAULT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.pending_analyses ALTER COLUMN id SET DEFAULT nextval('meduza.pending_analyses_id_seq'::regclass);


--
-- Name: transaction_analyses id; Type: DEFAULT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.transaction_analyses ALTER COLUMN id SET DEFAULT nextval('meduza.transaction_analyses_id_seq'::regclass);


--
-- Name: transaction_sources id; Type: DEFAULT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.transaction_sources ALTER COLUMN id SET DEFAULT nextval('meduza.transaction_sources_id_seq'::regclass);


--
-- Name: bill id; Type: DEFAULT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.bill ALTER COLUMN id SET DEFAULT nextval('mer.bills_id_seq'::regclass);


--
-- Name: invoice id; Type: DEFAULT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.invoice ALTER COLUMN id SET DEFAULT nextval('mer.invoices_id_seq'::regclass);


--
-- Name: invoice_transaction id; Type: DEFAULT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.invoice_transaction ALTER COLUMN id SET DEFAULT nextval('mer.invoices_transactions_id_seq'::regclass);


--
-- Name: merchant id; Type: DEFAULT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.merchant ALTER COLUMN id SET DEFAULT nextval('mer.merchant_id_seq'::regclass);


--
-- Name: payment id; Type: DEFAULT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.payment ALTER COLUMN id SET DEFAULT nextval('mer.payments_id_seq'::regclass);


--
-- Name: ad id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.ad ALTER COLUMN id SET DEFAULT nextval('p2p.ads_id_seq'::regclass);


--
-- Name: admin_file_uploaded id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.admin_file_uploaded ALTER COLUMN id SET DEFAULT nextval('p2p.admin_file_uploded_id_seq'::regclass);


--
-- Name: audit id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.audit ALTER COLUMN id SET DEFAULT nextval('p2p.audit_id_seq'::regclass);


--
-- Name: backup$wallet_log id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p."backup$wallet_log" ALTER COLUMN id SET DEFAULT nextval('p2p.wallet_log_id_seq'::regclass);


--
-- Name: chat id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.chat ALTER COLUMN id SET DEFAULT nextval('p2p.chat_id_seq'::regclass);


--
-- Name: debt id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.debt ALTER COLUMN id SET DEFAULT nextval('p2p.debts_id_seq'::regclass);


--
-- Name: deep_link_action id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.deep_link_action ALTER COLUMN id SET DEFAULT nextval('p2p.deep_link_action_id_seq'::regclass);


--
-- Name: dispute id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute ALTER COLUMN id SET DEFAULT nextval('p2p.disputes_id_seq'::regclass);


--
-- Name: dispute_decision id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_decision ALTER COLUMN id SET DEFAULT nextval('p2p.dispute_decisions_id_seq'::regclass);


--
-- Name: dispute_video id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_video ALTER COLUMN id SET DEFAULT nextval('p2p.dispute_video_id_seq'::regclass);


--
-- Name: feedback id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.feedback ALTER COLUMN id SET DEFAULT nextval('p2p.feedbacks_id_seq'::regclass);


--
-- Name: merge_token id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.merge_token ALTER COLUMN id SET DEFAULT nextval('p2p.merge_tokens_id_seq'::regclass);


--
-- Name: muted_user id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.muted_user ALTER COLUMN id SET DEFAULT nextval('p2p.muted_users_id_seq'::regclass);


--
-- Name: notebook id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.notebook ALTER COLUMN id SET DEFAULT nextval('p2p.notebook_id_seq'::regclass);


--
-- Name: notification id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.notification ALTER COLUMN id SET DEFAULT nextval('p2p.notifications_id_seq'::regclass);


--
-- Name: old_data_profile id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.old_data_profile ALTER COLUMN id SET DEFAULT nextval('p2p.old_data_profile_id_seq'::regclass);


--
-- Name: payment_group id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_group ALTER COLUMN id SET DEFAULT nextval('p2p.payments_group_id_seq'::regclass);


--
-- Name: payment_group_multilang id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_group_multilang ALTER COLUMN id SET DEFAULT nextval('p2p.payments_group_multilang_id_seq'::regclass);


--
-- Name: payment_method id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method ALTER COLUMN id SET DEFAULT nextval('p2p.payment_method_id_seq'::regclass);


--
-- Name: payment_method_global id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method_global ALTER COLUMN id SET DEFAULT nextval('p2p.payment_method_global_id_seq'::regclass);


--
-- Name: rate id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rate ALTER COLUMN id SET DEFAULT nextval('p2p.rates_id_seq'::regclass);


--
-- Name: rating_change_log id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rating_change_log ALTER COLUMN id SET DEFAULT nextval('p2p.rating_change_log_id_seq'::regclass);


--
-- Name: referal_bonus id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.referal_bonus ALTER COLUMN id SET DEFAULT nextval('p2p.referal_bonuses_id_seq'::regclass);


--
-- Name: referral_links_statistic id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.referral_links_statistic ALTER COLUMN id SET DEFAULT nextval('p2p.referral_links_statistic_id_seq'::regclass);


--
-- Name: requisite id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.requisite ALTER COLUMN id SET DEFAULT nextval('p2p.requisites_id_seq'::regclass);


--
-- Name: trade id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade ALTER COLUMN id SET DEFAULT nextval('p2p.trades_id_seq'::regclass);


--
-- Name: trade_history id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_history ALTER COLUMN id SET DEFAULT nextval('p2p.trade_history_id_seq'::regclass);


--
-- Name: trade_statistic id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic ALTER COLUMN id SET DEFAULT nextval('p2p.trade_statistic_id_seq'::regclass);


--
-- Name: trade_statistic_log id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic_log ALTER COLUMN id SET DEFAULT nextval('p2p.trade_statistic_log_id_seq'::regclass);


--
-- Name: untrusted_user id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.untrusted_user ALTER COLUMN id SET DEFAULT nextval('p2p.untrusted_users_id_seq'::regclass);


--
-- Name: user_2fa id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_2fa ALTER COLUMN id SET DEFAULT nextval('p2p.users_2fa_id_seq'::regclass);


--
-- Name: user_action_freeze id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_action_freeze ALTER COLUMN id SET DEFAULT nextval('p2p.user_actions_freeze_id_seq'::regclass);


--
-- Name: user_block id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_block ALTER COLUMN id SET DEFAULT nextval('p2p.user_block_id_seq'::regclass);


--
-- Name: user_note id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_note ALTER COLUMN id SET DEFAULT nextval('p2p.user_notes_id_seq'::regclass);


--
-- Name: user_profile id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile ALTER COLUMN id SET DEFAULT nextval('p2p.user_profile_id_seq'::regclass);


--
-- Name: user_rate id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_rate ALTER COLUMN id SET DEFAULT nextval('p2p.user_rates_id_seq'::regclass);


--
-- Name: user_settings id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_settings ALTER COLUMN id SET DEFAULT nextval('p2p.user_settings_id_seq'::regclass);


--
-- Name: user_trust id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_trust ALTER COLUMN id SET DEFAULT nextval('p2p.user_trust_id_seq'::regclass);


--
-- Name: voucher id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.voucher ALTER COLUMN id SET DEFAULT nextval('p2p.voucher_id_seq'::regclass);


--
-- Name: withdraw_voucher id; Type: DEFAULT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.withdraw_voucher ALTER COLUMN id SET DEFAULT nextval('p2p.withdraw_vouchers_id_seq'::regclass);


--
-- Name: account_swap_log id; Type: DEFAULT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account_swap_log ALTER COLUMN id SET DEFAULT nextval('public.account_swap_log_id_seq'::regclass);


--
-- Name: deposit id; Type: DEFAULT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.deposit ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: event id; Type: DEFAULT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.event ALTER COLUMN id SET DEFAULT nextval('public.event_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: user ref_parent_user_id; Type: DEFAULT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user" ALTER COLUMN ref_parent_user_id SET DEFAULT currval('public.users_id_seq'::regclass);


--
-- Name: wallet id; Type: DEFAULT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet ALTER COLUMN id SET DEFAULT nextval('public.wallets_id_seq'::regclass);


--
-- Name: withdrawal id; Type: DEFAULT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.withdrawal ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: withdrawal_log id; Type: DEFAULT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.withdrawal_log ALTER COLUMN id SET DEFAULT nextval('public.payment_logs_id_seq'::regclass);


--
-- Name: transfers id; Type: DEFAULT; Schema: whaler; Owner: whaler
--

ALTER TABLE ONLY whaler.transfers ALTER COLUMN id SET DEFAULT nextval('whaler.transfers_id_seq'::regclass);


--
-- Name: wallet_transfers id; Type: DEFAULT; Schema: whaler; Owner: whaler
--

ALTER TABLE ONLY whaler.wallet_transfers ALTER COLUMN id SET DEFAULT nextval('whaler.wallet_transfers_id_seq'::regclass);


--
-- Name: audit_user audit_users_pkey; Type: CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.audit_user
    ADD CONSTRAINT audit_users_pkey PRIMARY KEY (id);


--
-- Name: auth_stats auth_stats_pkey; Type: CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.auth_stats
    ADD CONSTRAINT auth_stats_pkey PRIMARY KEY (id);


--
-- Name: country_code country_codes_pkey; Type: CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.country_code
    ADD CONSTRAINT country_codes_pkey PRIMARY KEY (cc);


--
-- Name: daily_reports_dash daily_reports_dash_pkey; Type: CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.daily_reports_dash
    ADD CONSTRAINT daily_reports_dash_pkey PRIMARY KEY (id);


--
-- Name: one_time_code one_time_codes_pkey; Type: CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.one_time_code
    ADD CONSTRAINT one_time_codes_pkey PRIMARY KEY (id);


--
-- Name: stablecoin_exchange stablecoin_exchange_pkey; Type: CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.stablecoin_exchange
    ADD CONSTRAINT stablecoin_exchange_pkey PRIMARY KEY (id);


--
-- Name: stablecoin_exchange stablecoin_exchange_stablecoin_action_code_unique; Type: CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.stablecoin_exchange
    ADD CONSTRAINT stablecoin_exchange_stablecoin_action_code_unique UNIQUE (action_code, stablecoin);


--
-- Name: trade_stats trade_stats_pkey; Type: CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.trade_stats
    ADD CONSTRAINT trade_stats_pkey PRIMARY KEY (id);


--
-- Name: address_analyses address_analyses_pkey; Type: CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.address_analyses
    ADD CONSTRAINT address_analyses_pkey PRIMARY KEY (id);


--
-- Name: analysis_results analysis_results_pkey; Type: CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.analysis_results
    ADD CONSTRAINT analysis_results_pkey PRIMARY KEY (id);


--
-- Name: analyzed_users analyzed_users_pkey; Type: CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.analyzed_users
    ADD CONSTRAINT analyzed_users_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: pending_analyses pending_analyses_pkey; Type: CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.pending_analyses
    ADD CONSTRAINT pending_analyses_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: transaction_analyses transaction_analyses_pkey; Type: CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.transaction_analyses
    ADD CONSTRAINT transaction_analyses_pkey PRIMARY KEY (id);


--
-- Name: transaction_sources transaction_sources_pkey; Type: CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.transaction_sources
    ADD CONSTRAINT transaction_sources_pkey PRIMARY KEY (id);


--
-- Name: bill bills_pkey; Type: CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.bill
    ADD CONSTRAINT bills_pkey PRIMARY KEY (id);


--
-- Name: invoice invoices_pkey; Type: CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.invoice
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: invoice_transaction invoices_transactions_pkey; Type: CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.invoice_transaction
    ADD CONSTRAINT invoices_transactions_pkey PRIMARY KEY (id);


--
-- Name: merchant mer_uniq_user_id; Type: CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.merchant
    ADD CONSTRAINT mer_uniq_user_id UNIQUE (user_id);


--
-- Name: merchant merchant_pkey; Type: CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.merchant
    ADD CONSTRAINT merchant_pkey PRIMARY KEY (id);


--
-- Name: payment payments_pkey; Type: CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.payment
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: admin_file_uploaded admin_file_uploded_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.admin_file_uploaded
    ADD CONSTRAINT admin_file_uploded_pkey PRIMARY KEY (id);


--
-- Name: ad ads_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.ad
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: audit audit_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.audit
    ADD CONSTRAINT audit_pkey PRIMARY KEY (id);


--
-- Name: cc_settings_backup cc_settings_backup_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.cc_settings_backup
    ADD CONSTRAINT cc_settings_backup_pkey PRIMARY KEY (code);


--
-- Name: chat chat_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.chat
    ADD CONSTRAINT chat_pkey PRIMARY KEY (id);


--
-- Name: report check_unique_report_and_format; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.report
    ADD CONSTRAINT check_unique_report_and_format UNIQUE (description, format);


--
-- Name: config_maintenance config_maintenance_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.config_maintenance
    ADD CONSTRAINT config_maintenance_pkey PRIMARY KEY (name);


--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.config
    ADD CONSTRAINT config_pkey PRIMARY KEY (name);


--
-- Name: cryptocurrency_settings cryptocurrency_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.cryptocurrency_settings
    ADD CONSTRAINT cryptocurrency_pkey PRIMARY KEY (code);


--
-- Name: cryptocurrency_rate_source cryptocurrency_rate_source_cryptocurrency_code_priority_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.cryptocurrency_rate_source
    ADD CONSTRAINT cryptocurrency_rate_source_cryptocurrency_code_priority_key UNIQUE (cc_code, priority);


--
-- Name: cryptocurrency_rate_source cryptocurrency_rate_source_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.cryptocurrency_rate_source
    ADD CONSTRAINT cryptocurrency_rate_source_pkey PRIMARY KEY (cc_code, rate_source_code);


--
-- Name: currency currencies_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.currency
    ADD CONSTRAINT currencies_pkey PRIMARY KEY (symbol);


--
-- Name: payment_method currency_description_constraint; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method
    ADD CONSTRAINT currency_description_constraint UNIQUE (currency, description);


--
-- Name: deep_link_action deep_link_action_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.deep_link_action
    ADD CONSTRAINT deep_link_action_pkey PRIMARY KEY (id);


--
-- Name: dispute_decision dispute_decisions_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_decision
    ADD CONSTRAINT dispute_decisions_pkey PRIMARY KEY (id);


--
-- Name: dispute_video dispute_video_file_name_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_video
    ADD CONSTRAINT dispute_video_file_name_key UNIQUE (file_name);


--
-- Name: dispute_video dispute_video_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_video
    ADD CONSTRAINT dispute_video_pkey PRIMARY KEY (id);


--
-- Name: dispute disputes_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute
    ADD CONSTRAINT disputes_pkey PRIMARY KEY (id);


--
-- Name: dust_aggregation dust_aggregation_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dust_aggregation
    ADD CONSTRAINT dust_aggregation_pkey PRIMARY KEY (id);


--
-- Name: dust_aggregation dust_aggregation_tx_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dust_aggregation
    ADD CONSTRAINT dust_aggregation_tx_id_key UNIQUE (tx_id);


--
-- Name: feature features_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.feature
    ADD CONSTRAINT features_pkey PRIMARY KEY (code);


--
-- Name: feedback feedbacks_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.feedback
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: forbidden_public_name forbidden_public_names_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.forbidden_public_name
    ADD CONSTRAINT forbidden_public_names_pkey PRIMARY KEY (name);


--
-- Name: identity_verification_attempt identity_verification_attempt_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.identity_verification_attempt
    ADD CONSTRAINT identity_verification_attempt_pkey PRIMARY KEY (user_id, at);


--
-- Name: lang lang_description_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.lang
    ADD CONSTRAINT lang_description_key UNIQUE (description);


--
-- Name: lang lang_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.lang
    ADD CONSTRAINT lang_pkey PRIMARY KEY (code);


--
-- Name: merge_token merge_tokens_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.merge_token
    ADD CONSTRAINT merge_tokens_pkey PRIMARY KEY (id);


--
-- Name: merge_token merge_tokens_token_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.merge_token
    ADD CONSTRAINT merge_tokens_token_key UNIQUE (token);


--
-- Name: merge_token merge_tokens_user_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.merge_token
    ADD CONSTRAINT merge_tokens_user_id_key UNIQUE (user_id);


--
-- Name: merge merges_telegram_account_user_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.merge
    ADD CONSTRAINT merges_telegram_account_user_id_key UNIQUE (telegram_account_user_id);


--
-- Name: muted_user muted_users_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.muted_user
    ADD CONSTRAINT muted_users_pkey PRIMARY KEY (id);


--
-- Name: forbidden_public_name name_unique_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.forbidden_public_name
    ADD CONSTRAINT name_unique_key UNIQUE (name) INCLUDE (name);


--
-- Name: notebook notebook_address_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.notebook
    ADD CONSTRAINT notebook_address_key UNIQUE (user_id, address);


--
-- Name: notebook notebook_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.notebook
    ADD CONSTRAINT notebook_pkey PRIMARY KEY (id);


--
-- Name: notification_token notification_token_device_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.notification_token
    ADD CONSTRAINT notification_token_device_id_key UNIQUE (device_id);


--
-- Name: notification_token notification_token_token_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.notification_token
    ADD CONSTRAINT notification_token_token_key UNIQUE (token);


--
-- Name: notification notifications_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.notification
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: old_data_profile old_data_profile_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.old_data_profile
    ADD CONSTRAINT old_data_profile_pkey PRIMARY KEY (id);


--
-- Name: config p2p_config_check_name_unique; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.config
    ADD CONSTRAINT p2p_config_check_name_unique UNIQUE (name);


--
-- Name: merge p2p_merges_unique; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.merge
    ADD CONSTRAINT p2p_merges_unique UNIQUE (web_account_user_id, telegram_account_user_id);


--
-- Name: payment_method_global payment_method_global_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method_global
    ADD CONSTRAINT payment_method_global_pkey PRIMARY KEY (id);


--
-- Name: payment_method_hist payment_method_hist_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method_hist
    ADD CONSTRAINT payment_method_hist_pkey PRIMARY KEY (id);


--
-- Name: payment_method payment_method_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method
    ADD CONSTRAINT payment_method_pkey PRIMARY KEY (id);


--
-- Name: payment_group_multilang payments_group_multilang_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_group_multilang
    ADD CONSTRAINT payments_group_multilang_pkey PRIMARY KEY (id);


--
-- Name: payment_group payments_group_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_group
    ADD CONSTRAINT payments_group_pkey PRIMARY KEY (id);


--
-- Name: payment_list_precalculation payments_list_precalculation_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_list_precalculation
    ADD CONSTRAINT payments_list_precalculation_pkey PRIMARY KEY (cc_code, ads_type, payment_method_id);


--
-- Name: rate_plan_withdraw rate_plan_withdraw_cc_code_act_during_op_amount_excl; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rate_plan_withdraw
    ADD CONSTRAINT rate_plan_withdraw_cc_code_act_during_op_amount_excl EXCLUDE USING gist (cc_code WITH =, act_during WITH &&, op_amount WITH &&);


--
-- Name: user_rate rate_rate_id_constraint; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_rate
    ADD CONSTRAINT rate_rate_id_constraint UNIQUE (user_id, rate_id);


--
-- Name: rate_source rate_source_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rate_source
    ADD CONSTRAINT rate_source_pkey PRIMARY KEY (code);


--
-- Name: rate rate_url_cryptocurrency_constraint; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rate
    ADD CONSTRAINT rate_url_cryptocurrency_constraint UNIQUE (url, cc_code, currency_symbol);


--
-- Name: rate_fiat rates_fiat_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rate_fiat
    ADD CONSTRAINT rates_fiat_pkey PRIMARY KEY (symbol1, symbol2);


--
-- Name: rate rates_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rate
    ADD CONSTRAINT rates_pkey PRIMARY KEY (id);


--
-- Name: rating_change_log rating_change_log_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rating_change_log
    ADD CONSTRAINT rating_change_log_pkey PRIMARY KEY (id);


--
-- Name: referal_bonus referal_bonuses_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.referal_bonus
    ADD CONSTRAINT referal_bonuses_pkey PRIMARY KEY (id);


--
-- Name: referral_links_statistic referral_links_statistic_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.referral_links_statistic
    ADD CONSTRAINT referral_links_statistic_pkey PRIMARY KEY (id);


--
-- Name: requisite requisites_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.requisite
    ADD CONSTRAINT requisites_pkey PRIMARY KEY (id);


--
-- Name: stablecoin_trade stablecoin_trade_name_unique; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.stablecoin_trade
    ADD CONSTRAINT stablecoin_trade_name_unique UNIQUE (name);


--
-- Name: trade_history trade_history_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_history
    ADD CONSTRAINT trade_history_pkey PRIMARY KEY (id);


--
-- Name: trade_statistic_log trade_statistic_log_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic_log
    ADD CONSTRAINT trade_statistic_log_pkey PRIMARY KEY (id);


--
-- Name: trade_statistic trade_statistic_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic
    ADD CONSTRAINT trade_statistic_pkey PRIMARY KEY (id);


--
-- Name: trade_statistic trade_statistic_user_id_cryptocurrency_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic
    ADD CONSTRAINT trade_statistic_user_id_cryptocurrency_key UNIQUE (user_id, cc_code);


--
-- Name: trade trades_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade
    ADD CONSTRAINT trades_pkey PRIMARY KEY (id);


--
-- Name: user_settings unique_settings; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_settings
    ADD CONSTRAINT unique_settings UNIQUE (user_id);


--
-- Name: untrusted_user untrusted_users_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.untrusted_user
    ADD CONSTRAINT untrusted_users_pkey PRIMARY KEY (id);


--
-- Name: user_action_freeze user_action_freeze_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_action_freeze
    ADD CONSTRAINT user_action_freeze_pkey PRIMARY KEY (id);


--
-- Name: user_ad_filter user_ad_filter_user_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_ad_filter
    ADD CONSTRAINT user_ad_filter_user_id_key UNIQUE (user_id);


--
-- Name: user_block user_block_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_block
    ADD CONSTRAINT user_block_pkey PRIMARY KEY (id);


--
-- Name: user_block user_block_user_id_blocked_user_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_block
    ADD CONSTRAINT user_block_user_id_blocked_user_id_key UNIQUE (user_id, blocked_user_id);


--
-- Name: user_feature user_features_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_feature
    ADD CONSTRAINT user_features_pkey PRIMARY KEY (user_id, feature_code);


--
-- Name: user_note user_notes_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_note
    ADD CONSTRAINT user_notes_pkey PRIMARY KEY (id);


--
-- Name: user_profile user_profile_generated_name_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_generated_name_key UNIQUE (generated_name);


--
-- Name: user_profile user_profile_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_pkey PRIMARY KEY (id);


--
-- Name: user_profile user_profile_public_name_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_public_name_key UNIQUE (public_name);


--
-- Name: user_profile user_profile_uniqie; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_uniqie UNIQUE (user_id);


--
-- Name: user_profile user_profile_user_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_user_id_key UNIQUE (user_id);


--
-- Name: user_rate user_rates_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_rate
    ADD CONSTRAINT user_rates_pkey PRIMARY KEY (id);


--
-- Name: user_rate user_rates_user_id_rate_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_rate
    ADD CONSTRAINT user_rates_user_id_rate_id_key UNIQUE (user_id, rate_id);


--
-- Name: user_settings user_settings_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_settings
    ADD CONSTRAINT user_settings_pkey PRIMARY KEY (id);


--
-- Name: user_trust user_trust_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_trust
    ADD CONSTRAINT user_trust_pkey PRIMARY KEY (id);


--
-- Name: user_trust user_trust_user_id_trusted_user_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_trust
    ADD CONSTRAINT user_trust_user_id_trusted_user_id_key UNIQUE (user_id, trusted_user_id);


--
-- Name: user_2fa users_2fa_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_2fa
    ADD CONSTRAINT users_2fa_pkey PRIMARY KEY (id);


--
-- Name: user_2fa users_2fa_user_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_2fa
    ADD CONSTRAINT users_2fa_user_id_key UNIQUE (user_id);


--
-- Name: utm_statistic utm_statistic_user_id_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.utm_statistic
    ADD CONSTRAINT utm_statistic_user_id_key UNIQUE (user_id);


--
-- Name: voucher voucher_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.voucher
    ADD CONSTRAINT voucher_pkey PRIMARY KEY (id);


--
-- Name: voucher voucher_secret_key_key; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.voucher
    ADD CONSTRAINT voucher_secret_key_key UNIQUE (secret_key);


--
-- Name: backup$wallet_log wallet_log_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p."backup$wallet_log"
    ADD CONSTRAINT wallet_log_pkey PRIMARY KEY (id);


--
-- Name: withdraw_voucher withdraw_vouchers_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.withdraw_voucher
    ADD CONSTRAINT withdraw_vouchers_pkey PRIMARY KEY (id);


--
-- Name: withdraw_voucher_prime_time withdraw_vouchers_prime_time_pkey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.withdraw_voucher_prime_time
    ADD CONSTRAINT withdraw_vouchers_prime_time_pkey PRIMARY KEY (name);


--
-- Name: withdraw_voucher withdraw_vouchers_secret_key_ukey; Type: CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.withdraw_voucher
    ADD CONSTRAINT withdraw_vouchers_secret_key_ukey UNIQUE (secret_key);


--
-- Name: account_kyc_hist account_kyc_hist_acc_id_at_key; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account_kyc_hist
    ADD CONSTRAINT account_kyc_hist_acc_id_at_key UNIQUE (acc_id, at);


--
-- Name: account_kyc_hist account_kyc_hist_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account_kyc_hist
    ADD CONSTRAINT account_kyc_hist_pkey PRIMARY KEY (provider, correlation_id);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: account_swap_log account_swap_log_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account_swap_log
    ADD CONSTRAINT account_swap_log_pkey PRIMARY KEY (old_user_id, new_user_id);


--
-- Name: admin_user admin_user_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.admin_user
    ADD CONSTRAINT admin_user_pkey PRIMARY KEY (code);


--
-- Name: admin_user admin_users_email_key; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.admin_user
    ADD CONSTRAINT admin_users_email_key UNIQUE (code);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: cerberus
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: banned_user banned_users_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.banned_user
    ADD CONSTRAINT banned_users_pkey PRIMARY KEY (user_id, date);


--
-- Name: blockchain_tx blockchain_tx_cc_code_txid_key; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.blockchain_tx
    ADD CONSTRAINT blockchain_tx_cc_code_txid_key UNIQUE (cc_code, txid);


--
-- Name: blockchain_tx blockchain_tx_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.blockchain_tx
    ADD CONSTRAINT blockchain_tx_pkey PRIMARY KEY (id);


--
-- Name: cryptocurrency cryptocurrency_name_key; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.cryptocurrency
    ADD CONSTRAINT cryptocurrency_name_key UNIQUE (name);


--
-- Name: cryptocurrency cryptocurrency_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.cryptocurrency
    ADD CONSTRAINT cryptocurrency_pkey PRIMARY KEY (code);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: withdrawal_log payment_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.withdrawal_log
    ADD CONSTRAINT payment_logs_pkey PRIMARY KEY (id);


--
-- Name: withdrawal payments_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: withdrawal payments_wallet_id_address_created_at_key; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_wallet_id_address_created_at_key UNIQUE (wallet_id, address, created_at);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: cerberus
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: signed_operation_request signed_operation_request_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.signed_operation_request
    ADD CONSTRAINT signed_operation_request_pkey PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220131 signed_operation_request$20220131_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220131"
    ADD CONSTRAINT "signed_operation_request$20220131_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220201 signed_operation_request$20220201_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220201"
    ADD CONSTRAINT "signed_operation_request$20220201_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220202 signed_operation_request$20220202_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220202"
    ADD CONSTRAINT "signed_operation_request$20220202_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220203 signed_operation_request$20220203_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220203"
    ADD CONSTRAINT "signed_operation_request$20220203_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220204 signed_operation_request$20220204_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220204"
    ADD CONSTRAINT "signed_operation_request$20220204_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220205 signed_operation_request$20220205_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220205"
    ADD CONSTRAINT "signed_operation_request$20220205_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220206 signed_operation_request$20220206_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220206"
    ADD CONSTRAINT "signed_operation_request$20220206_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220207 signed_operation_request$20220207_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220207"
    ADD CONSTRAINT "signed_operation_request$20220207_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220208 signed_operation_request$20220208_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220208"
    ADD CONSTRAINT "signed_operation_request$20220208_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220209 signed_operation_request$20220209_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220209"
    ADD CONSTRAINT "signed_operation_request$20220209_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220210 signed_operation_request$20220210_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220210"
    ADD CONSTRAINT "signed_operation_request$20220210_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220211 signed_operation_request$20220211_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220211"
    ADD CONSTRAINT "signed_operation_request$20220211_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220212 signed_operation_request$20220212_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220212"
    ADD CONSTRAINT "signed_operation_request$20220212_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220213 signed_operation_request$20220213_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220213"
    ADD CONSTRAINT "signed_operation_request$20220213_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220214 signed_operation_request$20220214_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220214"
    ADD CONSTRAINT "signed_operation_request$20220214_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220215 signed_operation_request$20220215_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220215"
    ADD CONSTRAINT "signed_operation_request$20220215_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220216 signed_operation_request$20220216_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220216"
    ADD CONSTRAINT "signed_operation_request$20220216_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220217 signed_operation_request$20220217_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220217"
    ADD CONSTRAINT "signed_operation_request$20220217_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220218 signed_operation_request$20220218_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220218"
    ADD CONSTRAINT "signed_operation_request$20220218_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220219 signed_operation_request$20220219_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220219"
    ADD CONSTRAINT "signed_operation_request$20220219_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220220 signed_operation_request$20220220_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220220"
    ADD CONSTRAINT "signed_operation_request$20220220_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220221 signed_operation_request$20220221_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220221"
    ADD CONSTRAINT "signed_operation_request$20220221_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220222 signed_operation_request$20220222_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220222"
    ADD CONSTRAINT "signed_operation_request$20220222_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220223 signed_operation_request$20220223_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220223"
    ADD CONSTRAINT "signed_operation_request$20220223_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220224 signed_operation_request$20220224_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220224"
    ADD CONSTRAINT "signed_operation_request$20220224_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220225 signed_operation_request$20220225_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220225"
    ADD CONSTRAINT "signed_operation_request$20220225_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220226 signed_operation_request$20220226_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220226"
    ADD CONSTRAINT "signed_operation_request$20220226_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220227 signed_operation_request$20220227_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220227"
    ADD CONSTRAINT "signed_operation_request$20220227_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220228 signed_operation_request$20220228_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220228"
    ADD CONSTRAINT "signed_operation_request$20220228_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220301 signed_operation_request$20220301_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220301"
    ADD CONSTRAINT "signed_operation_request$20220301_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220302 signed_operation_request$20220302_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220302"
    ADD CONSTRAINT "signed_operation_request$20220302_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220303 signed_operation_request$20220303_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220303"
    ADD CONSTRAINT "signed_operation_request$20220303_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220304 signed_operation_request$20220304_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220304"
    ADD CONSTRAINT "signed_operation_request$20220304_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: signed_operation_request$20220305 signed_operation_request$20220305_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."signed_operation_request$20220305"
    ADD CONSTRAINT "signed_operation_request$20220305_pkey" PRIMARY KEY (expires_date, id);


--
-- Name: deposit transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: deposit txid_vout; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT txid_vout UNIQUE (blockchain_tx_id, vout);


--
-- Name: user_auth_pub_key user_auth_pub_key_jwk_key; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.user_auth_pub_key
    ADD CONSTRAINT user_auth_pub_key_jwk_key UNIQUE (jwk);


--
-- Name: user_auth_pub_key user_auth_pub_key_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.user_auth_pub_key
    ADD CONSTRAINT user_auth_pub_key_pkey PRIMARY KEY (user_id, aud, kid);


--
-- Name: user_cryptocurrency_settings user_cryptocurrency_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.user_cryptocurrency_settings
    ADD CONSTRAINT user_cryptocurrency_settings_pkey PRIMARY KEY (user_id, cc_code);


--
-- Name: wallet user_id_currency_unique; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT user_id_currency_unique UNIQUE (user_id, cc_code);


--
-- Name: user user_sys_code_key; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_sys_code_key UNIQUE (sys_code);


--
-- Name: user_token_mfa user_tokens_mfa_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.user_token_mfa
    ADD CONSTRAINT user_tokens_mfa_pkey PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20220227 user_token_mfa$20220227_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user_token_mfa$20220227"
    ADD CONSTRAINT "user_token_mfa$20220227_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20220228 user_token_mfa$20220228_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user_token_mfa$20220228"
    ADD CONSTRAINT "user_token_mfa$20220228_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20220301 user_token_mfa$20220301_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user_token_mfa$20220301"
    ADD CONSTRAINT "user_token_mfa$20220301_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20220302 user_token_mfa$20220302_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user_token_mfa$20220302"
    ADD CONSTRAINT "user_token_mfa$20220302_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20220303 user_token_mfa$20220303_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user_token_mfa$20220303"
    ADD CONSTRAINT "user_token_mfa$20220303_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user_token_mfa$20220304 user_token_mfa$20220304_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user_token_mfa$20220304"
    ADD CONSTRAINT "user_token_mfa$20220304_pkey" PRIMARY KEY (jwt_hash, expires_date);


--
-- Name: user users_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wallet_address wallet_address_cc_code_address_key; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet_address
    ADD CONSTRAINT wallet_address_cc_code_address_key UNIQUE (cc_code, address);


--
-- Name: wallet_address_hist wallet_address_hist_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet_address_hist
    ADD CONSTRAINT wallet_address_hist_pkey PRIMARY KEY (address, cryptocurrency_code, user_id);


--
-- Name: wallet_address wallet_address_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet_address
    ADD CONSTRAINT wallet_address_pkey PRIMARY KEY (cc_code, acc_id);


--
-- Name: wallet wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- Name: public_names_pool public_names_pool_pkey; Type: CONSTRAINT; Schema: sec; Owner: bitzlato
--

ALTER TABLE ONLY sec.public_names_pool
    ADD CONSTRAINT public_names_pool_pkey PRIMARY KEY (name);


--
-- Name: user_mobile_push_token user_mobile_push_token_pkey; Type: CONSTRAINT; Schema: sec; Owner: bitzlato
--

ALTER TABLE ONLY sec.user_mobile_push_token
    ADD CONSTRAINT user_mobile_push_token_pkey PRIMARY KEY (token);


--
-- Name: user_mobile_push_token user_mobile_push_token_user_id_unique_device_id_key; Type: CONSTRAINT; Schema: sec; Owner: bitzlato
--

ALTER TABLE ONLY sec.user_mobile_push_token
    ADD CONSTRAINT user_mobile_push_token_user_id_unique_device_id_key UNIQUE (user_id, unique_device_id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: whaler; Owner: whaler
--

ALTER TABLE ONLY whaler.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: whaler; Owner: whaler
--

ALTER TABLE ONLY whaler.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: whaler; Owner: whaler
--

ALTER TABLE ONLY whaler.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: wallet_transfers wallet_transfers_pkey; Type: CONSTRAINT; Schema: whaler; Owner: whaler
--

ALTER TABLE ONLY whaler.wallet_transfers
    ADD CONSTRAINT wallet_transfers_pkey PRIMARY KEY (id);


--
-- Name: index_address_analyses_on_address; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE UNIQUE INDEX index_address_analyses_on_address ON meduza.address_analyses USING btree (address);


--
-- Name: index_address_analyses_on_analysis_result_id; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE INDEX index_address_analyses_on_analysis_result_id ON meduza.address_analyses USING btree (analysis_result_id);


--
-- Name: index_analysis_results_on_address_transaction; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE INDEX index_analysis_results_on_address_transaction ON meduza.analysis_results USING btree (address_transaction);


--
-- Name: index_analyzed_users_on_risk_level_1_count; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE INDEX index_analyzed_users_on_risk_level_1_count ON meduza.analyzed_users USING btree (risk_level_1_count);


--
-- Name: index_analyzed_users_on_risk_level_2_count; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE INDEX index_analyzed_users_on_risk_level_2_count ON meduza.analyzed_users USING btree (risk_level_2_count);


--
-- Name: index_analyzed_users_on_risk_level_3_count; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE INDEX index_analyzed_users_on_risk_level_3_count ON meduza.analyzed_users USING btree (risk_level_3_count);


--
-- Name: index_analyzed_users_on_user_id_uniq; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE UNIQUE INDEX index_analyzed_users_on_user_id_uniq ON meduza.analyzed_users USING btree (user_id);


--
-- Name: index_pending_analyses_on_analysis_result_id; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE INDEX index_pending_analyses_on_analysis_result_id ON meduza.pending_analyses USING btree (analysis_result_id);


--
-- Name: index_transaction_analyses_on_analysis_result_id; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE INDEX index_transaction_analyses_on_analysis_result_id ON meduza.transaction_analyses USING btree (analysis_result_id);


--
-- Name: index_transaction_analyses_on_pending_analyses_id; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE INDEX index_transaction_analyses_on_pending_analyses_id ON meduza.transaction_analyses USING btree (pending_analyses_id);


--
-- Name: index_transaction_analyses_on_txid; Type: INDEX; Schema: meduza; Owner: meduza
--

CREATE UNIQUE INDEX index_transaction_analyses_on_txid ON meduza.transaction_analyses USING btree (txid);


--
-- Name: invoice_merchant_type_idx; Type: INDEX; Schema: mer; Owner: bitzlato
--

CREATE INDEX invoice_merchant_type_idx ON mer.invoice USING btree (merchant_id, type);


--
-- Name: invoice_transaction_invoice_idx; Type: INDEX; Schema: mer; Owner: bitzlato
--

CREATE INDEX invoice_transaction_invoice_idx ON mer.invoice_transaction USING btree (invoice_id);


--
-- Name: invoice_transaction_user_idx; Type: INDEX; Schema: mer; Owner: bitzlato
--

CREATE INDEX invoice_transaction_user_idx ON mer.invoice_transaction USING btree (user_id);


--
-- Name: invoices_cc_code_idx; Type: INDEX; Schema: mer; Owner: bitzlato
--

CREATE INDEX invoices_cc_code_idx ON mer.invoice USING btree (cc_code);


--
-- Name: invoices_transactions_cc_code_idx; Type: INDEX; Schema: mer; Owner: bitzlato
--

CREATE INDEX invoices_transactions_cc_code_idx ON mer.invoice_transaction USING btree (cc_code);


--
-- Name: unique_client_provided_id; Type: INDEX; Schema: mer; Owner: bitzlato
--

CREATE UNIQUE INDEX unique_client_provided_id ON mer.payment USING btree (merchant_id, client_provided_id) WHERE (client_provided_id IS NOT NULL);


--
-- Name: ads_cryptocurrency_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_cryptocurrency_idx ON p2p.ad USING btree (cc_code);


--
-- Name: ads_cryptocurrency_idx1; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_cryptocurrency_idx1 ON p2p.ad USING btree (cc_code) WHERE ((deleted_at IS NULL) AND (status = 'active'::p2p.ads_status) AND (type = 'purchase'::p2p.ads_type));


--
-- Name: ads_cryptocurrency_idx1_ccnew; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_cryptocurrency_idx1_ccnew ON p2p.ad USING btree (cc_code) WHERE ((deleted_at IS NULL) AND (status = 'active'::p2p.ads_status) AND (type = 'purchase'::p2p.ads_type));


--
-- Name: ads_cryptocurrency_idx2; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_cryptocurrency_idx2 ON p2p.ad USING btree (cc_code) WHERE ((deleted_at IS NULL) AND (status = 'active'::p2p.ads_status) AND (type = 'selling'::p2p.ads_type));


--
-- Name: ads_cryptocurrency_idx2_ccnew; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_cryptocurrency_idx2_ccnew ON p2p.ad USING btree (cc_code) WHERE ((deleted_at IS NULL) AND (status = 'active'::p2p.ads_status) AND (type = 'selling'::p2p.ads_type));


--
-- Name: ads_cryptocurrency_idx_ccnew; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_cryptocurrency_idx_ccnew ON p2p.ad USING btree (cc_code);


--
-- Name: ads_paymethod_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_paymethod_idx ON p2p.ad USING btree (paymethod);


--
-- Name: ads_rate_value_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_rate_value_idx ON p2p.ad USING btree (rate_value);


--
-- Name: ads_status_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_status_idx ON p2p.ad USING btree (status);


--
-- Name: ads_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX ads_user_id_idx ON p2p.ad USING btree (user_id);


--
-- Name: audit_date_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX audit_date_idx ON p2p.audit USING btree (date);


--
-- Name: buy_ads_mview_aid_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE UNIQUE INDEX buy_ads_mview_aid_idx ON p2p.buy_ads_mview USING btree (aid);


--
-- Name: buy_ads_mview_cc_code_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX buy_ads_mview_cc_code_idx ON p2p.buy_ads_mview USING btree (cc_code);


--
-- Name: chat_author_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX chat_author_id_idx ON p2p.chat USING btree (author_id);


--
-- Name: chat_from_admin_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX chat_from_admin_idx ON p2p.chat USING btree (from_admin);


--
-- Name: chat_to_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX chat_to_idx ON p2p.chat USING btree ("to");


--
-- Name: chat_trade_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX chat_trade_id_idx ON p2p.chat USING btree (trade_id);


--
-- Name: deep_link_referal_action_parent_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX deep_link_referal_action_parent_user_id_idx ON p2p.deep_link_referal_action USING btree (parent_user_id);


--
-- Name: disputes_admin_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX disputes_admin_idx ON p2p.dispute USING btree (admin_code);


--
-- Name: disputes_buyer_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX disputes_buyer_id_idx ON p2p.dispute USING btree (buyer_id);


--
-- Name: disputes_resolution_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX disputes_resolution_idx ON p2p.dispute USING btree (resolution);


--
-- Name: disputes_seller_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX disputes_seller_id_idx ON p2p.dispute USING btree (seller_id);


--
-- Name: dust_aggregation_status_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX dust_aggregation_status_idx ON p2p.dust_aggregation USING btree (status);


--
-- Name: feedbacks_for_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX feedbacks_for_user_id_idx ON p2p.feedback USING btree (for_user_id);


--
-- Name: feedbacks_trade_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX feedbacks_trade_id_idx ON p2p.feedback USING btree (trade_id);


--
-- Name: feedbacks_type_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX feedbacks_type_idx ON p2p.feedback USING btree (type);


--
-- Name: merges_web_account_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE UNIQUE INDEX merges_web_account_user_id_idx ON p2p.merge USING btree (web_account_user_id) WHERE (deleted_at IS NULL);


--
-- Name: notifications_name; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX notifications_name ON p2p.notification USING btree (name);


--
-- Name: notifications_receiver_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX notifications_receiver_user_id_idx ON p2p.notification USING btree (receiver_user_id);


--
-- Name: old_data_profile_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX old_data_profile_user_id_idx ON p2p.old_data_profile USING btree (user_id);


--
-- Name: payment_method_currency_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX payment_method_currency_idx ON p2p.payment_method USING btree (currency);


--
-- Name: payment_method_description_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX payment_method_description_idx ON p2p.payment_method USING btree (description);


--
-- Name: payment_method_i18n_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX payment_method_i18n_idx ON p2p.payment_method USING btree (i18n);


--
-- Name: payments_list_precalculation_ads_type_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX payments_list_precalculation_ads_type_idx ON p2p.payment_list_precalculation USING btree (ads_type);


--
-- Name: payments_list_precalculation_cryptocurrency_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX payments_list_precalculation_cryptocurrency_idx ON p2p.payment_list_precalculation USING btree (cc_code);


--
-- Name: payments_list_precalculation_currency_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX payments_list_precalculation_currency_idx ON p2p.payment_list_precalculation USING btree (currency);


--
-- Name: rates_cryptocurrency_code_currency_symbol_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE UNIQUE INDEX rates_cryptocurrency_code_currency_symbol_idx ON p2p.rate USING btree (cc_code, currency_symbol) WHERE default_rate;


--
-- Name: rates_cryptocurrency_code_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX rates_cryptocurrency_code_idx ON p2p.rate USING btree (cc_code);


--
-- Name: rates_currency_symbol_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX rates_currency_symbol_idx ON p2p.rate USING btree (currency_symbol);


--
-- Name: rates_default_rate_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX rates_default_rate_idx ON p2p.rate USING btree (default_rate);


--
-- Name: referal_bonuses_ref_parent_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX referal_bonuses_ref_parent_user_id_idx ON p2p.referal_bonus USING btree (ref_parent_user_id);


--
-- Name: sell_ads_mview_aid_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE UNIQUE INDEX sell_ads_mview_aid_idx ON p2p.sell_ads_mview USING btree (aid);


--
-- Name: sell_ads_mview_cc_code_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX sell_ads_mview_cc_code_idx ON p2p.sell_ads_mview USING btree (cc_code);


--
-- Name: trade_crypto_seller_ad_paymethod_status_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trade_crypto_seller_ad_paymethod_status_idx ON p2p.trade USING btree (crypto_seller, ad_paymethod, status);


--
-- Name: trade_history_date_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trade_history_date_idx ON p2p.trade_history USING btree (date);


--
-- Name: trade_history_status; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trade_history_status ON p2p.trade_history USING btree (status);


--
-- Name: trade_history_trade_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trade_history_trade_id_idx ON p2p.trade_history USING btree (trade_id);


--
-- Name: trade_statistic_cryptocurrency_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE UNIQUE INDEX trade_statistic_cryptocurrency_user_id_idx ON p2p.trade_statistic USING btree (cc_code, user_id);


--
-- Name: trade_statistic_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trade_statistic_idx ON p2p.trade_statistic USING btree (user_id);


--
-- Name: trades_ad_paymethod_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_ad_paymethod_idx ON p2p.trade USING btree (ad_paymethod);


--
-- Name: trades_ad_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_ad_user_id_idx ON p2p.trade USING btree (ad_user_id);


--
-- Name: trades_amount_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_amount_idx ON p2p.trade USING btree (amount);


--
-- Name: trades_comission_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_comission_idx ON p2p.trade USING btree (comission);


--
-- Name: trades_created_at_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_created_at_idx ON p2p.trade USING btree (created_at);


--
-- Name: trades_crypto_buyer_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_crypto_buyer_idx ON p2p.trade USING btree (crypto_buyer);


--
-- Name: trades_crypto_seller_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_crypto_seller_idx ON p2p.trade USING btree (crypto_seller);


--
-- Name: trades_cryptocurrency_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_cryptocurrency_idx ON p2p.trade USING btree (cc_code);


--
-- Name: trades_status_advanced_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_status_advanced_idx ON p2p.trade USING btree (status_advanced);


--
-- Name: trades_status_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_status_idx ON p2p.trade USING btree (status);


--
-- Name: trades_trade_initiator_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trades_trade_initiator_idx ON p2p.trade USING btree (trade_initiator);


--
-- Name: trgm_idx_wallet_log_cause; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX trgm_idx_wallet_log_cause ON p2p."backup$wallet_log" USING gin (cause public.gin_trgm_ops);


--
-- Name: user_block_blocked_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX user_block_blocked_user_id_idx ON p2p.user_block USING btree (blocked_user_id);


--
-- Name: user_profile_blocked_by_admin; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX user_profile_blocked_by_admin ON p2p.user_profile USING btree (blocked_by_admin);


--
-- Name: user_profile_lastactivity_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX user_profile_lastactivity_idx ON p2p.user_profile USING btree (lastactivity);


--
-- Name: user_profile_rating; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX user_profile_rating ON p2p.user_profile USING btree (rating);


--
-- Name: user_profile_start_of_use_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX user_profile_start_of_use_idx ON p2p.user_profile USING btree (start_of_use_date);


--
-- Name: user_profile_telegram_name_idx_new; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX user_profile_telegram_name_idx_new ON p2p.user_profile USING btree (telegram_name);


--
-- Name: user_profile_verification_date_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX user_profile_verification_date_idx ON p2p.user_profile USING btree (verification_date);


--
-- Name: user_profile_verified_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX user_profile_verified_idx ON p2p.user_profile USING btree (verified);


--
-- Name: user_rates_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX user_rates_user_id_idx ON p2p.user_rate USING btree (user_id);


--
-- Name: voucher_cashed_at_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX voucher_cashed_at_idx ON p2p.voucher USING btree (cashed_at);


--
-- Name: voucher_user_id_cc_code_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX voucher_user_id_cc_code_idx ON p2p.voucher USING btree (user_id, cc_code) WHERE ((cashed_at IS NULL) AND (deleted_at IS NULL));


--
-- Name: voucher_user_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX voucher_user_id_idx ON p2p.voucher USING btree (user_id);


--
-- Name: wallet_log_date_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX wallet_log_date_idx ON p2p."backup$wallet_log" USING btree (date);


--
-- Name: wallet_log_date_idx1; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX wallet_log_date_idx1 ON p2p.wallet_log USING btree (date);


--
-- Name: wallet_log_wallet_id; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX wallet_log_wallet_id ON p2p."backup$wallet_log" USING btree (wallet_id);


--
-- Name: wallet_log_wallet_id_idx; Type: INDEX; Schema: p2p; Owner: bitzlato
--

CREATE INDEX wallet_log_wallet_id_idx ON p2p.wallet_log USING btree (wallet_id);


--
-- Name: admin_user_user_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE UNIQUE INDEX admin_user_user_id_idx ON public.admin_user USING btree (user_id);


--
-- Name: deposit_cc_code_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX deposit_cc_code_idx ON public.deposit USING btree (cc_code);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: payments_address_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX payments_address_idx ON public.withdrawal USING btree (address);


--
-- Name: payments_amount_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX payments_amount_idx ON public.withdrawal USING btree (amount);


--
-- Name: payments_cc_code_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX payments_cc_code_idx ON public.withdrawal USING btree (cc_code);


--
-- Name: payments_created_at_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX payments_created_at_id_idx ON public.withdrawal USING btree (created_at);


--
-- Name: payments_status_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX payments_status_idx ON public.withdrawal USING btree (status);


--
-- Name: payments_transaction_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX payments_transaction_id_idx ON public.withdrawal USING btree (blockchain_tx_id);


--
-- Name: payments_user_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX payments_user_id_idx ON public.withdrawal USING btree (user_id);


--
-- Name: signed_operation_request_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX signed_operation_request_id_idx ON ONLY public.signed_operation_request USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220131_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220131_id_idx" ON public."signed_operation_request$20220131" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220201_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220201_id_idx" ON public."signed_operation_request$20220201" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220202_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220202_id_idx" ON public."signed_operation_request$20220202" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220203_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220203_id_idx" ON public."signed_operation_request$20220203" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220204_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220204_id_idx" ON public."signed_operation_request$20220204" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220205_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220205_id_idx" ON public."signed_operation_request$20220205" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220206_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220206_id_idx" ON public."signed_operation_request$20220206" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220207_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220207_id_idx" ON public."signed_operation_request$20220207" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220208_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220208_id_idx" ON public."signed_operation_request$20220208" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220209_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220209_id_idx" ON public."signed_operation_request$20220209" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220210_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220210_id_idx" ON public."signed_operation_request$20220210" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220211_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220211_id_idx" ON public."signed_operation_request$20220211" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220212_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220212_id_idx" ON public."signed_operation_request$20220212" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220213_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220213_id_idx" ON public."signed_operation_request$20220213" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220214_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220214_id_idx" ON public."signed_operation_request$20220214" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220215_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220215_id_idx" ON public."signed_operation_request$20220215" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220216_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220216_id_idx" ON public."signed_operation_request$20220216" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220217_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220217_id_idx" ON public."signed_operation_request$20220217" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220218_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220218_id_idx" ON public."signed_operation_request$20220218" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220219_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220219_id_idx" ON public."signed_operation_request$20220219" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220220_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220220_id_idx" ON public."signed_operation_request$20220220" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220221_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220221_id_idx" ON public."signed_operation_request$20220221" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220222_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220222_id_idx" ON public."signed_operation_request$20220222" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220223_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220223_id_idx" ON public."signed_operation_request$20220223" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220224_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220224_id_idx" ON public."signed_operation_request$20220224" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220225_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220225_id_idx" ON public."signed_operation_request$20220225" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220226_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220226_id_idx" ON public."signed_operation_request$20220226" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220227_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220227_id_idx" ON public."signed_operation_request$20220227" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220228_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220228_id_idx" ON public."signed_operation_request$20220228" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220301_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220301_id_idx" ON public."signed_operation_request$20220301" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220302_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220302_id_idx" ON public."signed_operation_request$20220302" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220303_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220303_id_idx" ON public."signed_operation_request$20220303" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220304_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220304_id_idx" ON public."signed_operation_request$20220304" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: signed_operation_request$20220305_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX "signed_operation_request$20220305_id_idx" ON public."signed_operation_request$20220305" USING btree (id) WHERE (confirmed_at IS NULL);


--
-- Name: transactions_address_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX transactions_address_idx ON public.deposit USING btree (address);


--
-- Name: transactions_created_at_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX transactions_created_at_idx ON public.deposit USING btree (created_at);


--
-- Name: transactions_txid_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX transactions_txid_idx ON public.deposit USING btree (blockchain_tx_id);


--
-- Name: transactions_user_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX transactions_user_id_idx ON public.deposit USING btree (user_id);


--
-- Name: user_cryptocurrency_settings_user_id_cryptocurrency_code_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE UNIQUE INDEX user_cryptocurrency_settings_user_id_cryptocurrency_code_idx ON public.user_cryptocurrency_settings USING btree (user_id, cc_code) WHERE trading_enabled;


--
-- Name: users_real_email_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX users_real_email_idx ON public."user" USING btree (real_email) WHERE (deleted_at IS NULL);


--
-- Name: users_ref_parent_user_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX users_ref_parent_user_id_idx ON public."user" USING btree (ref_parent_user_id);


--
-- Name: users_subject_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE UNIQUE INDEX users_subject_idx ON public."user" USING btree (subject) WHERE (deleted_at IS NULL);


--
-- Name: users_subject_idx1; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX users_subject_idx1 ON public."user" USING btree (subject);


--
-- Name: users_telegram_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE UNIQUE INDEX users_telegram_id_idx ON public."user" USING btree (telegram_id) WHERE (deleted_at IS NULL);


--
-- Name: users_telegram_id_idx1; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX users_telegram_id_idx1 ON public."user" USING btree (telegram_id);


--
-- Name: users_username_idx1; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX users_username_idx1 ON public."user" USING btree (nickname);


--
-- Name: wallet_address_acc_id_idx; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX wallet_address_acc_id_idx ON public.wallet_address USING btree (acc_id);


--
-- Name: wallet_user_id; Type: INDEX; Schema: public; Owner: bitzlato
--

CREATE INDEX wallet_user_id ON public.wallet USING btree (user_id);


--
-- Name: public_names_pool_name_idx; Type: INDEX; Schema: sec; Owner: bitzlato
--

CREATE UNIQUE INDEX public_names_pool_name_idx ON sec.public_names_pool USING btree (name) WHERE (in_use_since IS NULL);


--
-- Name: index_transfers_on_user_id; Type: INDEX; Schema: whaler; Owner: whaler
--

CREATE INDEX index_transfers_on_user_id ON whaler.transfers USING btree (user_id);


--
-- Name: index_wallet_transfers_on_destination_wallet_id; Type: INDEX; Schema: whaler; Owner: whaler
--

CREATE INDEX index_wallet_transfers_on_destination_wallet_id ON whaler.wallet_transfers USING btree (destination_wallet_id);


--
-- Name: index_wallet_transfers_on_source_wallet_id; Type: INDEX; Schema: whaler; Owner: whaler
--

CREATE INDEX index_wallet_transfers_on_source_wallet_id ON whaler.wallet_transfers USING btree (source_wallet_id);


--
-- Name: uniq_index_transfers_on_operation_id; Type: INDEX; Schema: whaler; Owner: whaler
--

CREATE UNIQUE INDEX uniq_index_transfers_on_operation_id ON whaler.wallet_transfers USING btree (transfer_id);


--
-- Name: signed_operation_request$20220131_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220131_id_idx";


--
-- Name: signed_operation_request$20220131_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220131_pkey";


--
-- Name: signed_operation_request$20220201_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220201_id_idx";


--
-- Name: signed_operation_request$20220201_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220201_pkey";


--
-- Name: signed_operation_request$20220202_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220202_id_idx";


--
-- Name: signed_operation_request$20220202_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220202_pkey";


--
-- Name: signed_operation_request$20220203_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220203_id_idx";


--
-- Name: signed_operation_request$20220203_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220203_pkey";


--
-- Name: signed_operation_request$20220204_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220204_id_idx";


--
-- Name: signed_operation_request$20220204_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220204_pkey";


--
-- Name: signed_operation_request$20220205_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220205_id_idx";


--
-- Name: signed_operation_request$20220205_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220205_pkey";


--
-- Name: signed_operation_request$20220206_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220206_id_idx";


--
-- Name: signed_operation_request$20220206_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220206_pkey";


--
-- Name: signed_operation_request$20220207_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220207_id_idx";


--
-- Name: signed_operation_request$20220207_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220207_pkey";


--
-- Name: signed_operation_request$20220208_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220208_id_idx";


--
-- Name: signed_operation_request$20220208_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220208_pkey";


--
-- Name: signed_operation_request$20220209_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220209_id_idx";


--
-- Name: signed_operation_request$20220209_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220209_pkey";


--
-- Name: signed_operation_request$20220210_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220210_id_idx";


--
-- Name: signed_operation_request$20220210_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220210_pkey";


--
-- Name: signed_operation_request$20220211_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220211_id_idx";


--
-- Name: signed_operation_request$20220211_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220211_pkey";


--
-- Name: signed_operation_request$20220212_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220212_id_idx";


--
-- Name: signed_operation_request$20220212_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220212_pkey";


--
-- Name: signed_operation_request$20220213_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220213_id_idx";


--
-- Name: signed_operation_request$20220213_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220213_pkey";


--
-- Name: signed_operation_request$20220214_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220214_id_idx";


--
-- Name: signed_operation_request$20220214_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220214_pkey";


--
-- Name: signed_operation_request$20220215_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220215_id_idx";


--
-- Name: signed_operation_request$20220215_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220215_pkey";


--
-- Name: signed_operation_request$20220216_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220216_id_idx";


--
-- Name: signed_operation_request$20220216_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220216_pkey";


--
-- Name: signed_operation_request$20220217_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220217_id_idx";


--
-- Name: signed_operation_request$20220217_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220217_pkey";


--
-- Name: signed_operation_request$20220218_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220218_id_idx";


--
-- Name: signed_operation_request$20220218_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220218_pkey";


--
-- Name: signed_operation_request$20220219_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220219_id_idx";


--
-- Name: signed_operation_request$20220219_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220219_pkey";


--
-- Name: signed_operation_request$20220220_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220220_id_idx";


--
-- Name: signed_operation_request$20220220_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220220_pkey";


--
-- Name: signed_operation_request$20220221_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220221_id_idx";


--
-- Name: signed_operation_request$20220221_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220221_pkey";


--
-- Name: signed_operation_request$20220222_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220222_id_idx";


--
-- Name: signed_operation_request$20220222_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220222_pkey";


--
-- Name: signed_operation_request$20220223_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220223_id_idx";


--
-- Name: signed_operation_request$20220223_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220223_pkey";


--
-- Name: signed_operation_request$20220224_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220224_id_idx";


--
-- Name: signed_operation_request$20220224_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220224_pkey";


--
-- Name: signed_operation_request$20220225_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220225_id_idx";


--
-- Name: signed_operation_request$20220225_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220225_pkey";


--
-- Name: signed_operation_request$20220226_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220226_id_idx";


--
-- Name: signed_operation_request$20220226_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220226_pkey";


--
-- Name: signed_operation_request$20220227_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220227_id_idx";


--
-- Name: signed_operation_request$20220227_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220227_pkey";


--
-- Name: signed_operation_request$20220228_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220228_id_idx";


--
-- Name: signed_operation_request$20220228_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220228_pkey";


--
-- Name: signed_operation_request$20220301_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220301_id_idx";


--
-- Name: signed_operation_request$20220301_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220301_pkey";


--
-- Name: signed_operation_request$20220302_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220302_id_idx";


--
-- Name: signed_operation_request$20220302_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220302_pkey";


--
-- Name: signed_operation_request$20220303_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220303_id_idx";


--
-- Name: signed_operation_request$20220303_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220303_pkey";


--
-- Name: signed_operation_request$20220304_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220304_id_idx";


--
-- Name: signed_operation_request$20220304_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220304_pkey";


--
-- Name: signed_operation_request$20220305_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_id_idx ATTACH PARTITION public."signed_operation_request$20220305_id_idx";


--
-- Name: signed_operation_request$20220305_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.signed_operation_request_pkey ATTACH PARTITION public."signed_operation_request$20220305_pkey";


--
-- Name: user_token_mfa$20220227_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20220227_pkey";


--
-- Name: user_token_mfa$20220228_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20220228_pkey";


--
-- Name: user_token_mfa$20220301_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20220301_pkey";


--
-- Name: user_token_mfa$20220302_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20220302_pkey";


--
-- Name: user_token_mfa$20220303_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20220303_pkey";


--
-- Name: user_token_mfa$20220304_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.user_tokens_mfa_pkey ATTACH PARTITION public."user_token_mfa$20220304_pkey";


--
-- Name: trade check_two_trades_trigger_after_insert; Type: TRIGGER; Schema: p2p; Owner: bitzlato
--

CREATE TRIGGER check_two_trades_trigger_after_insert AFTER INSERT ON p2p.trade FOR EACH ROW EXECUTE FUNCTION p2p.check_two_trades();


--
-- Name: user_rate check_two_user_rates_trigger_before_insert; Type: TRIGGER; Schema: p2p; Owner: bitzlato
--

CREATE TRIGGER check_two_user_rates_trigger_before_insert BEFORE INSERT ON p2p.user_rate FOR EACH ROW EXECUTE FUNCTION p2p.check_two_user_rates();


--
-- Name: payment_method_global global_paymethods_delete_handler; Type: TRIGGER; Schema: p2p; Owner: bitzlato
--

CREATE TRIGGER global_paymethods_delete_handler BEFORE DELETE ON p2p.payment_method_global FOR EACH ROW EXECUTE FUNCTION p2p.global_paymethods_delete();


--
-- Name: payment_method_global global_paymethods_insert_handler; Type: TRIGGER; Schema: p2p; Owner: bitzlato
--

CREATE TRIGGER global_paymethods_insert_handler AFTER INSERT ON p2p.payment_method_global FOR EACH ROW EXECUTE FUNCTION p2p.global_paymethods_insert();


--
-- Name: payment_method_global global_paymethods_update_handler; Type: TRIGGER; Schema: p2p; Owner: bitzlato
--

CREATE TRIGGER global_paymethods_update_handler AFTER UPDATE ON p2p.payment_method_global FOR EACH ROW EXECUTE FUNCTION p2p.global_paymethods_update();


--
-- Name: broadcast_result mailing_result_user_id_fkey; Type: FK CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.broadcast_result
    ADD CONSTRAINT mailing_result_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: one_time_code one_time_codes_user_id_fkey; Type: FK CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.one_time_code
    ADD CONSTRAINT one_time_codes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: stablecoin_exchange stablecoin_exchange_cryptocurrency_fkey; Type: FK CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.stablecoin_exchange
    ADD CONSTRAINT stablecoin_exchange_cryptocurrency_fkey FOREIGN KEY (cryptocurrency) REFERENCES p2p.cryptocurrency_settings(code);


--
-- Name: stablecoin_exchange stablecoin_exchange_rate_id_fkey; Type: FK CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.stablecoin_exchange
    ADD CONSTRAINT stablecoin_exchange_rate_id_fkey FOREIGN KEY (rate_id) REFERENCES p2p.rate(id);


--
-- Name: stablecoin_exchange stablecoin_exchange_stablecoin_fkey; Type: FK CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.stablecoin_exchange
    ADD CONSTRAINT stablecoin_exchange_stablecoin_fkey FOREIGN KEY (stablecoin) REFERENCES p2p.cryptocurrency_settings(code);


--
-- Name: stablecoin_exchange stablecoin_exchange_user_id_fkey; Type: FK CONSTRAINT; Schema: cleanup; Owner: bitzlato
--

ALTER TABLE ONLY cleanup.stablecoin_exchange
    ADD CONSTRAINT stablecoin_exchange_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: pending_analyses fk_rails_27fc4b529c; Type: FK CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.pending_analyses
    ADD CONSTRAINT fk_rails_27fc4b529c FOREIGN KEY (analysis_result_id) REFERENCES meduza.analysis_results(id);


--
-- Name: address_analyses fk_rails_4d26b9d298; Type: FK CONSTRAINT; Schema: meduza; Owner: meduza
--

ALTER TABLE ONLY meduza.address_analyses
    ADD CONSTRAINT fk_rails_4d26b9d298 FOREIGN KEY (analysis_result_id) REFERENCES meduza.analysis_results(id);


--
-- Name: bill bills_invoice_id_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.bill
    ADD CONSTRAINT bills_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES mer.invoice(id);


--
-- Name: bill bills_merchant_id_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.bill
    ADD CONSTRAINT bills_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES mer.merchant(id);


--
-- Name: bill bills_user_id_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.bill
    ADD CONSTRAINT bills_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: invoice invoices_cryptocurrency_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.invoice
    ADD CONSTRAINT invoices_cryptocurrency_fkey FOREIGN KEY (cc_code) REFERENCES p2p.cryptocurrency_settings(code);


--
-- Name: invoice invoices_merchant_id_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.invoice
    ADD CONSTRAINT invoices_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES mer.merchant(id);


--
-- Name: invoice_transaction invoices_transactions_cryptocurrency_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.invoice_transaction
    ADD CONSTRAINT invoices_transactions_cryptocurrency_fkey FOREIGN KEY (cc_code) REFERENCES p2p.cryptocurrency_settings(code);


--
-- Name: invoice_transaction invoices_transactions_invoice_id_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.invoice_transaction
    ADD CONSTRAINT invoices_transactions_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES mer.invoice(id);


--
-- Name: invoice_transaction invoices_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.invoice_transaction
    ADD CONSTRAINT invoices_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: merchant merchant_user_id_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.merchant
    ADD CONSTRAINT merchant_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: payment payments_cryptocurrency_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.payment
    ADD CONSTRAINT payments_cryptocurrency_fkey FOREIGN KEY (cc_code) REFERENCES p2p.cryptocurrency_settings(code);


--
-- Name: payment payments_merchant_id_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.payment
    ADD CONSTRAINT payments_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES mer.merchant(id);


--
-- Name: payment payments_user_id_fkey; Type: FK CONSTRAINT; Schema: mer; Owner: bitzlato
--

ALTER TABLE ONLY mer.payment
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: ad ads_cryptocurrency_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.ad
    ADD CONSTRAINT ads_cryptocurrency_fkey FOREIGN KEY (cc_code) REFERENCES p2p.cryptocurrency_settings(code);


--
-- Name: ad ads_paymethod_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.ad
    ADD CONSTRAINT ads_paymethod_fkey FOREIGN KEY (paymethod) REFERENCES p2p.payment_method(id);


--
-- Name: ad ads_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.ad
    ADD CONSTRAINT ads_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: chat chat_admin_file_uploaded_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.chat
    ADD CONSTRAINT chat_admin_file_uploaded_id_fkey FOREIGN KEY (admin_file_uploaded_id) REFERENCES p2p.admin_file_uploaded(id);


--
-- Name: chat chat_author_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.chat
    ADD CONSTRAINT chat_author_id_fkey FOREIGN KEY (author_id) REFERENCES public."user"(id) MATCH FULL;


--
-- Name: chat chat_trade_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.chat
    ADD CONSTRAINT chat_trade_id_fkey FOREIGN KEY (trade_id) REFERENCES p2p.trade(id);


--
-- Name: cryptocurrency_rate_source cryptocurrency_rate_source_cryptocurrency_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.cryptocurrency_rate_source
    ADD CONSTRAINT cryptocurrency_rate_source_cryptocurrency_code_fkey FOREIGN KEY (cc_code) REFERENCES public.cryptocurrency(code);


--
-- Name: cryptocurrency_rate_source cryptocurrency_rate_source_rate_source_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.cryptocurrency_rate_source
    ADD CONSTRAINT cryptocurrency_rate_source_rate_source_code_fkey FOREIGN KEY (rate_source_code) REFERENCES p2p.rate_source(code);


--
-- Name: cryptocurrency_settings cryptocurrency_settings_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.cryptocurrency_settings
    ADD CONSTRAINT cryptocurrency_settings_code_fkey FOREIGN KEY (code) REFERENCES public.cryptocurrency(code);


--
-- Name: debt debt_action_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.debt
    ADD CONSTRAINT debt_action_admin_code_fkey FOREIGN KEY (action_admin_code) REFERENCES public.admin_user(code);


--
-- Name: debt debt_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.debt
    ADD CONSTRAINT debt_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: debt debts_wallet_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.debt
    ADD CONSTRAINT debts_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallet(id);


--
-- Name: deep_link_referal_action deep_link_referal_action_deep_link_action_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.deep_link_referal_action
    ADD CONSTRAINT deep_link_referal_action_deep_link_action_id_fkey FOREIGN KEY (deep_link_action_id) REFERENCES p2p.deep_link_action(id);


--
-- Name: deep_link_referal_action deep_link_referal_action_parent_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.deep_link_referal_action
    ADD CONSTRAINT deep_link_referal_action_parent_user_id_fkey FOREIGN KEY (parent_user_id) REFERENCES public."user"(id);


--
-- Name: dispute dispute_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute
    ADD CONSTRAINT dispute_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: dispute_decision dispute_decision_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_decision
    ADD CONSTRAINT dispute_decision_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: dispute_decision dispute_decision_admin_code_fkey1; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_decision
    ADD CONSTRAINT dispute_decision_admin_code_fkey1 FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: dispute_decision dispute_decisions_dispute_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_decision
    ADD CONSTRAINT dispute_decisions_dispute_id_fkey FOREIGN KEY (dispute_id) REFERENCES p2p.dispute(id);


--
-- Name: dispute_decision dispute_decisions_trade_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_decision
    ADD CONSTRAINT dispute_decisions_trade_id_fkey FOREIGN KEY (trade_id) REFERENCES p2p.trade(id);


--
-- Name: dispute_video dispute_video_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_video
    ADD CONSTRAINT dispute_video_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: dispute_video dispute_video_admin_code_fkey1; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_video
    ADD CONSTRAINT dispute_video_admin_code_fkey1 FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: dispute_video dispute_video_dispute_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute_video
    ADD CONSTRAINT dispute_video_dispute_id_fkey FOREIGN KEY (dispute_id) REFERENCES p2p.dispute(id) ON UPDATE CASCADE;


--
-- Name: dispute disputes_buyer_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute
    ADD CONSTRAINT disputes_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public."user"(id);


--
-- Name: dispute disputes_seller_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute
    ADD CONSTRAINT disputes_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public."user"(id);


--
-- Name: dispute disputes_trade_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.dispute
    ADD CONSTRAINT disputes_trade_id_fkey FOREIGN KEY (trade_id) REFERENCES p2p.trade(id);


--
-- Name: feature features_required_feature_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.feature
    ADD CONSTRAINT features_required_feature_code_fkey FOREIGN KEY (required_feature_code) REFERENCES p2p.feature(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: feedback feedbacks_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.feedback
    ADD CONSTRAINT feedbacks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: identity_verification_attempt identity_verification_attempt_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.identity_verification_attempt
    ADD CONSTRAINT identity_verification_attempt_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: merge_token merge_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.merge_token
    ADD CONSTRAINT merge_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: merge merges_telegram_account_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.merge
    ADD CONSTRAINT merges_telegram_account_user_id_fkey FOREIGN KEY (telegram_account_user_id) REFERENCES public."user"(id);


--
-- Name: merge merges_web_account_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.merge
    ADD CONSTRAINT merges_web_account_user_id_fkey FOREIGN KEY (web_account_user_id) REFERENCES public."user"(id);


--
-- Name: muted_user muted_user_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.muted_user
    ADD CONSTRAINT muted_user_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: notebook notebook_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.notebook
    ADD CONSTRAINT notebook_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: notification_token notification_token_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.notification_token
    ADD CONSTRAINT notification_token_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: old_data_profile old_data_profile_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.old_data_profile
    ADD CONSTRAINT old_data_profile_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: payment_method payment_method_currency_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method
    ADD CONSTRAINT payment_method_currency_fkey FOREIGN KEY (currency) REFERENCES p2p.currency(symbol);


--
-- Name: payment_method_global payment_method_global_payments_group_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method_global
    ADD CONSTRAINT payment_method_global_payments_group_fkey FOREIGN KEY (payments_group) REFERENCES p2p.payment_group(id);


--
-- Name: payment_method_hist payment_method_hist_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method_hist
    ADD CONSTRAINT payment_method_hist_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: payment_method_hist payment_method_hist_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method_hist
    ADD CONSTRAINT payment_method_hist_id_fkey FOREIGN KEY (id) REFERENCES p2p.payment_method(id);


--
-- Name: payment_method payment_method_payments_group_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_method
    ADD CONSTRAINT payment_method_payments_group_fkey FOREIGN KEY (payment_group) REFERENCES p2p.payment_group(id);


--
-- Name: payment_group_multilang payments_group_multilang_payments_group_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_group_multilang
    ADD CONSTRAINT payments_group_multilang_payments_group_id_fkey FOREIGN KEY (payments_group_id) REFERENCES p2p.payment_group(id) ON DELETE CASCADE;


--
-- Name: payment_list_precalculation payments_list_precalculation_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_list_precalculation
    ADD CONSTRAINT payments_list_precalculation_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES p2p.payment_method(id);


--
-- Name: payment_list_precalculation payments_list_precalculation_payments_group_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.payment_list_precalculation
    ADD CONSTRAINT payments_list_precalculation_payments_group_fkey FOREIGN KEY (payment_group) REFERENCES p2p.payment_group(id);


--
-- Name: rate_plan_withdraw rate_plan_withdraw_cc_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rate_plan_withdraw
    ADD CONSTRAINT rate_plan_withdraw_cc_code_fkey FOREIGN KEY (cc_code) REFERENCES public.cryptocurrency(code);


--
-- Name: rate rates_cryptocurrency_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rate
    ADD CONSTRAINT rates_cryptocurrency_code_fkey FOREIGN KEY (cc_code) REFERENCES p2p.cryptocurrency_settings(code);


--
-- Name: rate rates_currency_symbol_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rate
    ADD CONSTRAINT rates_currency_symbol_fkey FOREIGN KEY (currency_symbol) REFERENCES p2p.currency(symbol);


--
-- Name: rating_change_log rating_change_log_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.rating_change_log
    ADD CONSTRAINT rating_change_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: referal_bonus referal_bonuses_cryptocurrency_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.referal_bonus
    ADD CONSTRAINT referal_bonuses_cryptocurrency_fkey FOREIGN KEY (cc_code) REFERENCES public.cryptocurrency(code) ON UPDATE CASCADE;


--
-- Name: referal_bonus referal_bonuses_ref_parent_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.referal_bonus
    ADD CONSTRAINT referal_bonuses_ref_parent_user_id_fkey FOREIGN KEY (ref_parent_user_id) REFERENCES public."user"(id) ON UPDATE CASCADE;


--
-- Name: referal_bonus referal_bonuses_referal_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.referal_bonus
    ADD CONSTRAINT referal_bonuses_referal_id_fkey FOREIGN KEY (referal_id) REFERENCES public."user"(id);


--
-- Name: referal_bonus referal_bonuses_trade_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.referal_bonus
    ADD CONSTRAINT referal_bonuses_trade_id_fkey FOREIGN KEY (trade_id) REFERENCES p2p.trade(id);


--
-- Name: requisite requisites_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.requisite
    ADD CONSTRAINT requisites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: trade_history trade_history_trade_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_history
    ADD CONSTRAINT trade_history_trade_id_fkey FOREIGN KEY (trade_id) REFERENCES p2p.trade(id);


--
-- Name: trade_statistic trade_statistic_cryptocurrency_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic
    ADD CONSTRAINT trade_statistic_cryptocurrency_fkey FOREIGN KEY (cc_code) REFERENCES p2p.cryptocurrency_settings(code);


--
-- Name: trade_statistic trade_statistic_cryptocurrency_fkey1; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic
    ADD CONSTRAINT trade_statistic_cryptocurrency_fkey1 FOREIGN KEY (cc_code) REFERENCES public.cryptocurrency(code);


--
-- Name: trade_statistic_log trade_statistic_log_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic_log
    ADD CONSTRAINT trade_statistic_log_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: trade_statistic_log trade_statistic_log_admin_code_fkey1; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic_log
    ADD CONSTRAINT trade_statistic_log_admin_code_fkey1 FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: trade_statistic_log trade_statistic_log_ts_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic_log
    ADD CONSTRAINT trade_statistic_log_ts_id_fkey FOREIGN KEY (ts_id) REFERENCES p2p.trade_statistic(id);


--
-- Name: trade_statistic trade_statistic_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade_statistic
    ADD CONSTRAINT trade_statistic_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: trade trades_ad_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade
    ADD CONSTRAINT trades_ad_id_fkey FOREIGN KEY (ad_id) REFERENCES p2p.ad(id);


--
-- Name: trade trades_ad_initiator_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade
    ADD CONSTRAINT trades_ad_initiator_fkey FOREIGN KEY (trade_initiator) REFERENCES public."user"(id);


--
-- Name: trade trades_ad_paymethod_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade
    ADD CONSTRAINT trades_ad_paymethod_fkey FOREIGN KEY (ad_paymethod) REFERENCES p2p.payment_method(id);


--
-- Name: trade trades_crypto_buyer_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade
    ADD CONSTRAINT trades_crypto_buyer_fkey FOREIGN KEY (crypto_buyer) REFERENCES public."user"(id);


--
-- Name: trade trades_crypto_seller_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.trade
    ADD CONSTRAINT trades_crypto_seller_fkey FOREIGN KEY (crypto_seller) REFERENCES public."user"(id);


--
-- Name: untrusted_user untrusted_user_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.untrusted_user
    ADD CONSTRAINT untrusted_user_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: user_action_freeze user_action_freeze_admin_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_action_freeze
    ADD CONSTRAINT user_action_freeze_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: user_action_freeze user_actions_freeze_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_action_freeze
    ADD CONSTRAINT user_actions_freeze_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_ad_filter user_ad_filter_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_ad_filter
    ADD CONSTRAINT user_ad_filter_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_block user_block_blocked_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_block
    ADD CONSTRAINT user_block_blocked_user_id_fkey FOREIGN KEY (blocked_user_id) REFERENCES public."user"(id);


--
-- Name: user_block user_block_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_block
    ADD CONSTRAINT user_block_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_feature user_features_feature_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_feature
    ADD CONSTRAINT user_features_feature_code_fkey FOREIGN KEY (feature_code) REFERENCES p2p.feature(code) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_note user_notes_for_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_note
    ADD CONSTRAINT user_notes_for_user_id_fkey FOREIGN KEY (for_user_id) REFERENCES public."user"(id);


--
-- Name: user_note user_notes_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_note
    ADD CONSTRAINT user_notes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_profile user_profile_cryptocurrency_code_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_cryptocurrency_code_fkey FOREIGN KEY (cryptocurrency) REFERENCES p2p.cryptocurrency_settings(code);


--
-- Name: user_profile user_profile_currency_symbol_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_currency_symbol_fkey FOREIGN KEY (currency) REFERENCES p2p.currency(symbol);


--
-- Name: user_profile user_profile_lang_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_lang_fkey FOREIGN KEY (lang) REFERENCES p2p.lang(code);


--
-- Name: user_profile user_profile_lang_web_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_lang_web_fkey FOREIGN KEY (lang_web) REFERENCES p2p.lang(code);


--
-- Name: user_profile user_profile_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_profile
    ADD CONSTRAINT user_profile_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_rate user_rates_rate_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_rate
    ADD CONSTRAINT user_rates_rate_id_fkey FOREIGN KEY (rate_id) REFERENCES p2p.rate(id);


--
-- Name: user_rate user_rates_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_rate
    ADD CONSTRAINT user_rates_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_settings user_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_settings
    ADD CONSTRAINT user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user_trust user_trust_trusted_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_trust
    ADD CONSTRAINT user_trust_trusted_user_id_fkey FOREIGN KEY (trusted_user_id) REFERENCES public."user"(id);


--
-- Name: user_trust user_trust_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_trust
    ADD CONSTRAINT user_trust_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_2fa users_2fa_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.user_2fa
    ADD CONSTRAINT users_2fa_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: utm_statistic utm_statistic_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.utm_statistic
    ADD CONSTRAINT utm_statistic_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: voucher voucher_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.voucher
    ADD CONSTRAINT voucher_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: wallet_log wallet_log_wallet_id_fkey1; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.wallet_log
    ADD CONSTRAINT wallet_log_wallet_id_fkey1 FOREIGN KEY (wallet_id) REFERENCES public.wallet(id);


--
-- Name: withdraw_voucher withdraw_vouchers_payment_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.withdraw_voucher
    ADD CONSTRAINT withdraw_vouchers_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.withdrawal(id);


--
-- Name: withdraw_voucher withdraw_vouchers_prime_time_event_name_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.withdraw_voucher
    ADD CONSTRAINT withdraw_vouchers_prime_time_event_name_fkey FOREIGN KEY (prime_time_event_name) REFERENCES p2p.withdraw_voucher_prime_time(name) ON UPDATE CASCADE;


--
-- Name: withdraw_voucher withdraw_vouchers_user_id_fkey; Type: FK CONSTRAINT; Schema: p2p; Owner: bitzlato
--

ALTER TABLE ONLY p2p.withdraw_voucher
    ADD CONSTRAINT withdraw_vouchers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: account account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_id_fkey FOREIGN KEY (id) REFERENCES public."user"(id);


--
-- Name: account_kyc_hist account_kyc_hist_acc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account_kyc_hist
    ADD CONSTRAINT account_kyc_hist_acc_id_fkey FOREIGN KEY (acc_id) REFERENCES public."user"(id);


--
-- Name: account_swap_log account_swap_log_admin_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account_swap_log
    ADD CONSTRAINT account_swap_log_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: account_swap_log account_swap_log_new_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account_swap_log
    ADD CONSTRAINT account_swap_log_new_user_id_fkey FOREIGN KEY (new_user_id) REFERENCES public."user"(id);


--
-- Name: account_swap_log account_swap_log_old_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.account_swap_log
    ADD CONSTRAINT account_swap_log_old_user_id_fkey FOREIGN KEY (old_user_id) REFERENCES public."user"(id);


--
-- Name: admin_user admin_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.admin_user
    ADD CONSTRAINT admin_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: banned_user banned_user_admin_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.banned_user
    ADD CONSTRAINT banned_user_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: deposit deposit_blockchain_tx_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT deposit_blockchain_tx_id_fkey FOREIGN KEY (blockchain_tx_id) REFERENCES public.blockchain_tx(id);


--
-- Name: withdrawal payments_currency_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_currency_fkey FOREIGN KEY (cc_code) REFERENCES public.cryptocurrency(code);


--
-- Name: withdrawal payments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: withdrawal payments_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT payments_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallet(id);


--
-- Name: signed_operation_request signed_operation_request_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE public.signed_operation_request
    ADD CONSTRAINT signed_operation_request_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_auth_pub_key user_auth_pub_key_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.user_auth_pub_key
    ADD CONSTRAINT user_auth_pub_key_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_cryptocurrency_settings user_cryptocurrency_settings_cryptocurrency_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.user_cryptocurrency_settings
    ADD CONSTRAINT user_cryptocurrency_settings_cryptocurrency_code_fkey FOREIGN KEY (cc_code) REFERENCES public.cryptocurrency(code);


--
-- Name: user_cryptocurrency_settings user_cryptocurrency_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.user_cryptocurrency_settings
    ADD CONSTRAINT user_cryptocurrency_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_token_mfa user_tokens_mfa_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE public.user_token_mfa
    ADD CONSTRAINT user_tokens_mfa_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user users_ref_parent_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT users_ref_parent_user_id_fkey FOREIGN KEY (ref_parent_user_id) REFERENCES public."user"(id);


--
-- Name: wallet_address wallet_address_acc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet_address
    ADD CONSTRAINT wallet_address_acc_id_fkey FOREIGN KEY (acc_id) REFERENCES public."user"(id);


--
-- Name: wallet_address wallet_address_cc_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet_address
    ADD CONSTRAINT wallet_address_cc_code_fkey FOREIGN KEY (cc_code) REFERENCES public.cryptocurrency(code);


--
-- Name: wallet_address_hist wallet_address_hist_admin_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet_address_hist
    ADD CONSTRAINT wallet_address_hist_admin_code_fkey FOREIGN KEY (admin_code) REFERENCES public.admin_user(code);


--
-- Name: wallet_address_hist wallet_address_hist_cryptocurrency_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet_address_hist
    ADD CONSTRAINT wallet_address_hist_cryptocurrency_code_fkey FOREIGN KEY (cryptocurrency_code) REFERENCES public.cryptocurrency(code);


--
-- Name: wallet_address_hist wallet_address_hist_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet_address_hist
    ADD CONSTRAINT wallet_address_hist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: wallet wallet_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallet_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: withdrawal withdrawal_blockchain_tx_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitzlato
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_blockchain_tx_id_fkey FOREIGN KEY (blockchain_tx_id) REFERENCES public.blockchain_tx(id);


--
-- Name: user_mobile_push_token user_mobile_push_token_user_id_fkey; Type: FK CONSTRAINT; Schema: sec; Owner: bitzlato
--

ALTER TABLE ONLY sec.user_mobile_push_token
    ADD CONSTRAINT user_mobile_push_token_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: transfers fk_rails_63fbf4e94e; Type: FK CONSTRAINT; Schema: whaler; Owner: whaler
--

ALTER TABLE ONLY whaler.transfers
    ADD CONSTRAINT fk_rails_63fbf4e94e FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: wallet_transfers fk_rails_c5e21c21e1; Type: FK CONSTRAINT; Schema: whaler; Owner: whaler
--

ALTER TABLE ONLY whaler.wallet_transfers
    ADD CONSTRAINT fk_rails_c5e21c21e1 FOREIGN KEY (destination_wallet_id) REFERENCES public.wallet(id);


--
-- Name: wallet_transfers fk_rails_dfe4c7c78e; Type: FK CONSTRAINT; Schema: whaler; Owner: whaler
--

ALTER TABLE ONLY whaler.wallet_transfers
    ADD CONSTRAINT fk_rails_dfe4c7c78e FOREIGN KEY (source_wallet_id) REFERENCES public.wallet(id);


--
-- Name: SCHEMA history; Type: ACL; Schema: -; Owner: bitzlato
--

GRANT USAGE ON SCHEMA history TO drey;
GRANT USAGE ON SCHEMA history TO zeppelin;
GRANT USAGE ON SCHEMA history TO maelstromm;


--
-- Name: SCHEMA mer; Type: ACL; Schema: -; Owner: bitzlato
--

GRANT USAGE ON SCHEMA mer TO michael;
GRANT USAGE ON SCHEMA mer TO backadm;
GRANT USAGE ON SCHEMA mer TO bitzlato_reader;
GRANT ALL ON SCHEMA mer TO bitzlato_admin;


--
-- Name: SCHEMA p2p; Type: ACL; Schema: -; Owner: bitzlato
--

GRANT USAGE ON SCHEMA p2p TO admin_manager;
GRANT USAGE ON SCHEMA p2p TO michael;
GRANT USAGE ON SCHEMA p2p TO igor;
GRANT USAGE ON SCHEMA p2p TO vladimir;
GRANT USAGE ON SCHEMA p2p TO dust_collector;
GRANT USAGE ON SCHEMA p2p TO bitzlato_reader;
GRANT USAGE ON SCHEMA p2p TO bitzlato_finance;
GRANT USAGE ON SCHEMA p2p TO bitzlato_writer;
GRANT ALL ON SCHEMA p2p TO bitzlato_admin;
GRANT USAGE ON SCHEMA p2p TO bitzlato_monitoring;
GRANT USAGE ON SCHEMA p2p TO bitzlato_analytics;


--
-- Name: SCHEMA postgres_exporter; Type: ACL; Schema: -; Owner: postgres_exporter
--

REVOKE ALL ON SCHEMA postgres_exporter FROM postgres_exporter;
GRANT USAGE ON SCHEMA postgres_exporter TO bitzlato_reader;
GRANT ALL ON SCHEMA postgres_exporter TO bitzlato_admin;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA public TO admin_manager;
GRANT USAGE ON SCHEMA public TO michael;
GRANT USAGE ON SCHEMA public TO igor;
GRANT USAGE ON SCHEMA public TO vladimir;
GRANT USAGE ON SCHEMA public TO bitzlato;
GRANT USAGE ON SCHEMA public TO bitzlato_reader;
GRANT ALL ON SCHEMA public TO bitzlato_admin;


--
-- Name: SCHEMA rep; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA rep TO zeppelin;
GRANT USAGE ON SCHEMA rep TO igor;
GRANT USAGE ON SCHEMA rep TO vladimir;
GRANT USAGE ON SCHEMA rep TO vanch;


--
-- Name: SCHEMA whaler; Type: ACL; Schema: -; Owner: whaler
--

GRANT USAGE ON SCHEMA whaler TO bitzlato_reader;


--
-- Name: FUNCTION gtrgm_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO bitzlato_admin;


--
-- Name: FUNCTION gtrgm_out(public.gtrgm); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO bitzlato_admin;


--
-- Name: FUNCTION add_rating_after_merge(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.add_rating_after_merge() TO bitzlato_admin;


--
-- Name: TABLE payment_method; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.payment_method TO zeppelin;
GRANT SELECT ON TABLE p2p.payment_method TO admin_manager;
GRANT SELECT ON TABLE p2p.payment_method TO michael;
GRANT SELECT ON TABLE p2p.payment_method TO igor;
GRANT SELECT ON TABLE p2p.payment_method TO vladimir;
GRANT ALL ON TABLE p2p.payment_method TO vanch;
GRANT SELECT ON TABLE p2p.payment_method TO bitzlato_reader;
GRANT INSERT,DELETE,UPDATE ON TABLE p2p.payment_method TO bitzlato_admin;
GRANT SELECT ON TABLE p2p.payment_method TO bitzlato_analytics;


--
-- Name: TABLE ad; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.ad TO zeppelin;
GRANT SELECT ON TABLE p2p.ad TO admin_manager;
GRANT SELECT ON TABLE p2p.ad TO michael;
GRANT SELECT ON TABLE p2p.ad TO igor;
GRANT SELECT ON TABLE p2p.ad TO vladimir;
GRANT ALL ON TABLE p2p.ad TO vanch;
GRANT SELECT ON TABLE p2p.ad TO bitzlato_reader;
GRANT UPDATE ON TABLE p2p.ad TO bitzlato_writer;
GRANT SELECT ON TABLE p2p.ad TO bitzlato_analytics;


--
-- Name: TABLE wallet; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.wallet TO admin_manager;
GRANT SELECT ON TABLE public.wallet TO michael;
GRANT SELECT ON TABLE public.wallet TO igor;
GRANT SELECT ON TABLE public.wallet TO vladimir;
GRANT SELECT ON TABLE public.wallet TO dust_collector;
GRANT SELECT ON TABLE public.wallet TO bitzlato_reader;
GRANT ALL ON TABLE public.wallet TO bitzlato_admin;
GRANT SELECT,REFERENCES,UPDATE ON TABLE public.wallet TO whaler;


--
-- Name: FUNCTION ads_filter(ad p2p.ad, wallet public.wallet, trade_comission_percent real); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.ads_filter(ad p2p.ad, wallet public.wallet, trade_comission_percent real) TO bitzlato_admin;


--
-- Name: FUNCTION balance_to_hold(wallet_from integer, wallet_to integer, amount bigint, cause text); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.balance_to_hold(wallet_from integer, wallet_to integer, amount bigint, cause text) TO bitzlato_admin;


--
-- Name: FUNCTION base58_encode(num integer); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.base58_encode(num integer) TO bitzlato_admin;


--
-- Name: FUNCTION cancel_payment(pay_id integer, cause text); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.cancel_payment(pay_id integer, cause text) TO bitzlato_admin;


--
-- Name: FUNCTION check_two_trades(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.check_two_trades() TO bitzlato_admin;


--
-- Name: FUNCTION check_two_user_rates(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.check_two_user_rates() TO bitzlato_admin;


--
-- Name: FUNCTION disable_ads(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.disable_ads() TO bitzlato_admin;


--
-- Name: FUNCTION global_paymethods_delete(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.global_paymethods_delete() TO bitzlato_admin;


--
-- Name: FUNCTION global_paymethods_insert(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.global_paymethods_insert() TO bitzlato_admin;


--
-- Name: FUNCTION global_paymethods_update(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.global_paymethods_update() TO bitzlato_admin;


--
-- Name: FUNCTION handle_features_adding(codes character varying[]); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.handle_features_adding(codes character varying[]) TO bitzlato_admin;


--
-- Name: FUNCTION heal_old_data_after_merge(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.heal_old_data_after_merge() TO bitzlato_admin;


--
-- Name: FUNCTION heal_reg_after_merge(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.heal_reg_after_merge() TO bitzlato_admin;


--
-- Name: FUNCTION heal_vouchers_after_merge(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.heal_vouchers_after_merge() TO bitzlato_admin;


--
-- Name: FUNCTION hold_to_null(user_from integer, currency integer, amount bigint, cause text); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.hold_to_null(user_from integer, currency integer, amount bigint, cause text) TO bitzlato_admin;


--
-- Name: FUNCTION move_money(user_from integer, user_to integer, cc integer, amount bigint, cause text); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.move_money(user_from integer, user_to integer, cc integer, amount bigint, cause text) TO bitzlato_admin;


--
-- Name: FUNCTION move_money(user_from integer, user_to integer, cc integer, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.move_money(user_from integer, user_to integer, cc integer, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) TO bitzlato_admin;


--
-- Name: FUNCTION move_user(from_id integer, to_id integer); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.move_user(from_id integer, to_id integer) TO bitzlato_admin;


--
-- Name: FUNCTION recreate_payment(payment_id integer); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.recreate_payment(payment_id integer) TO bitzlato_admin;


--
-- Name: FUNCTION release_banned_balances(up_to_date timestamp without time zone); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.release_banned_balances(up_to_date timestamp without time zone) TO bitzlato_admin;


--
-- Name: FUNCTION release_debt(user_from integer, user_to integer, cc integer, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.release_debt(user_from integer, user_to integer, cc integer, amount numeric, cause text, source_type p2p.operation_source, source_id integer, platform character varying) TO bitzlato_admin;


--
-- Name: FUNCTION release_debts(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.release_debts() TO bitzlato_admin;


--
-- Name: FUNCTION set_merged_after_merge(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.set_merged_after_merge() TO bitzlato_admin;


--
-- Name: FUNCTION store_audit_json(); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.store_audit_json() TO bitzlato_admin;


--
-- Name: FUNCTION to_seconds(t text); Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON FUNCTION p2p.to_seconds(t text) TO bitzlato_admin;


--
-- Name: FUNCTION add_fake_balance(userid integer, cc integer, amount bigint); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.add_fake_balance(userid integer, cc integer, amount bigint) TO bitzlato_admin;


--
-- Name: FUNCTION array_sort_unique(anyarray); Type: ACL; Schema: public; Owner: zeppelin
--

REVOKE ALL ON FUNCTION public.array_sort_unique(anyarray) FROM zeppelin;
GRANT ALL ON FUNCTION public.array_sort_unique(anyarray) TO bitzlato_admin;


--
-- Name: FUNCTION base58_encode(num integer); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.base58_encode(num integer) TO bitzlato_admin;


--
-- Name: FUNCTION create_partition_for_date(p_date date, p_table character varying); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.create_partition_for_date(p_date date, p_table character varying) TO bitzlato_admin;


--
-- Name: FUNCTION drop_partition_for_date(p_date date, p_table character varying); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.drop_partition_for_date(p_date date, p_table character varying) TO bitzlato_admin;


--
-- Name: FUNCTION first_agg(anyelement, anyelement); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.first_agg(anyelement, anyelement) TO bitzlato_admin;


--
-- Name: FUNCTION get_partitions_for_date(p_table character varying); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.get_partitions_for_date(p_table character varying) TO bitzlato_admin;


--
-- Name: FUNCTION gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO bitzlato_admin;


--
-- Name: FUNCTION gin_extract_value_trgm(text, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO bitzlato_admin;


--
-- Name: FUNCTION gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO bitzlato_admin;


--
-- Name: FUNCTION gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO bitzlato_admin;


--
-- Name: FUNCTION gtrgm_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO bitzlato_admin;


--
-- Name: FUNCTION gtrgm_consistent(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO bitzlato_admin;


--
-- Name: FUNCTION gtrgm_decompress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO bitzlato_admin;


--
-- Name: FUNCTION gtrgm_distance(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO bitzlato_admin;


--
-- Name: FUNCTION gtrgm_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO bitzlato_admin;


--
-- Name: FUNCTION gtrgm_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO bitzlato_admin;


--
-- Name: FUNCTION gtrgm_same(public.gtrgm, public.gtrgm, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO bitzlato_admin;


--
-- Name: FUNCTION gtrgm_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO bitzlato_admin;


--
-- Name: FUNCTION hold_to_balance(payment_id integer); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.hold_to_balance(payment_id integer) TO bitzlato_admin;


--
-- Name: FUNCTION last_agg(anyelement, anyelement); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.last_agg(anyelement, anyelement) TO bitzlato_admin;


--
-- Name: FUNCTION maintain_partitions_for_dates(p_retain_days integer, p_in_advance_days integer, p_table text); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.maintain_partitions_for_dates(p_retain_days integer, p_in_advance_days integer, p_table text) TO bitzlato_admin;


--
-- Name: FUNCTION mark_as_sent_and_release(); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.mark_as_sent_and_release() TO bitzlato_admin;


--
-- Name: FUNCTION mark_as_sent_and_release_hold(payment_id integer); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.mark_as_sent_and_release_hold(payment_id integer) TO bitzlato_admin;


--
-- Name: FUNCTION null_txids_for_internal_txes(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.null_txids_for_internal_txes() TO bitzlato_admin;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT queryid bigint, OUT query text, OUT calls bigint, OUT total_time double precision, OUT min_time double precision, OUT max_time double precision, OUT mean_time double precision, OUT stddev_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT queryid bigint, OUT query text, OUT calls bigint, OUT total_time double precision, OUT min_time double precision, OUT max_time double precision, OUT mean_time double precision, OUT stddev_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision) TO bitzlato_admin;


--
-- Name: FUNCTION pg_stat_statements_reset(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pg_stat_statements_reset() TO bitzlato_admin;


--
-- Name: FUNCTION release_banned_balances(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.release_banned_balances() TO bitzlato_admin;


--
-- Name: FUNCTION set_limit(real); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_limit(real) TO bitzlato_admin;


--
-- Name: FUNCTION show_limit(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.show_limit() TO bitzlato_admin;


--
-- Name: FUNCTION show_trgm(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.show_trgm(text) TO bitzlato_admin;


--
-- Name: FUNCTION similarity(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.similarity(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION similarity_dist(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION similarity_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.similarity_op(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION strict_word_similarity(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION strict_word_similarity_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION strict_word_similarity_dist_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION strict_word_similarity_dist_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION strict_word_similarity_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION word_similarity(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION word_similarity_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION word_similarity_dist_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION word_similarity_dist_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION word_similarity_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO bitzlato_admin;


--
-- Name: FUNCTION first(anyelement); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.first(anyelement) TO bitzlato_admin;


--
-- Name: FUNCTION last(anyelement); Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON FUNCTION public.last(anyelement) TO bitzlato_admin;


--
-- Name: TABLE audit_user; Type: ACL; Schema: cleanup; Owner: bitzlato
--

GRANT SELECT ON TABLE cleanup.audit_user TO drey;
GRANT SELECT ON TABLE cleanup.audit_user TO zeppelin;
GRANT SELECT ON TABLE cleanup.audit_user TO admin_manager;
GRANT ALL ON TABLE cleanup.audit_user TO postgres_exporter;
GRANT SELECT ON TABLE cleanup.audit_user TO maelstromm;
GRANT SELECT ON TABLE cleanup.audit_user TO michael;
GRANT SELECT ON TABLE cleanup.audit_user TO lucky;
GRANT SELECT ON TABLE cleanup.audit_user TO igor;
GRANT SELECT ON TABLE cleanup.audit_user TO vladimir;
GRANT ALL ON TABLE cleanup.audit_user TO vanch;


--
-- Name: TABLE auth_stats; Type: ACL; Schema: cleanup; Owner: bitzlato
--

GRANT SELECT ON TABLE cleanup.auth_stats TO drey;
GRANT SELECT ON TABLE cleanup.auth_stats TO zeppelin;
GRANT SELECT ON TABLE cleanup.auth_stats TO admin_manager;
GRANT ALL ON TABLE cleanup.auth_stats TO postgres_exporter;
GRANT SELECT ON TABLE cleanup.auth_stats TO maelstromm;
GRANT SELECT ON TABLE cleanup.auth_stats TO michael;
GRANT SELECT ON TABLE cleanup.auth_stats TO igor;
GRANT SELECT ON TABLE cleanup.auth_stats TO lucky;
GRANT SELECT ON TABLE cleanup.auth_stats TO vladimir;
GRANT ALL ON TABLE cleanup.auth_stats TO vanch;


--
-- Name: TABLE broadcast_result; Type: ACL; Schema: cleanup; Owner: bitzlato
--

GRANT SELECT ON TABLE cleanup.broadcast_result TO drey;
GRANT SELECT ON TABLE cleanup.broadcast_result TO zeppelin;
GRANT SELECT ON TABLE cleanup.broadcast_result TO admin_manager;
GRANT SELECT ON TABLE cleanup.broadcast_result TO lucky;
GRANT SELECT ON TABLE cleanup.broadcast_result TO maelstromm;
GRANT SELECT ON TABLE cleanup.broadcast_result TO igor;
GRANT SELECT ON TABLE cleanup.broadcast_result TO michael;
GRANT SELECT ON TABLE cleanup.broadcast_result TO vladimir;
GRANT ALL ON TABLE cleanup.broadcast_result TO postgres_exporter;
GRANT ALL ON TABLE cleanup.broadcast_result TO vanch;


--
-- Name: TABLE country_code; Type: ACL; Schema: cleanup; Owner: bitzlato
--

GRANT SELECT ON TABLE cleanup.country_code TO drey;
GRANT SELECT ON TABLE cleanup.country_code TO zeppelin;
GRANT SELECT ON TABLE cleanup.country_code TO admin_manager;
GRANT ALL ON TABLE cleanup.country_code TO postgres_exporter;
GRANT SELECT ON TABLE cleanup.country_code TO maelstromm;
GRANT SELECT ON TABLE cleanup.country_code TO michael;
GRANT SELECT ON TABLE cleanup.country_code TO lucky;
GRANT SELECT ON TABLE cleanup.country_code TO igor;
GRANT SELECT ON TABLE cleanup.country_code TO vladimir;
GRANT ALL ON TABLE cleanup.country_code TO vanch;


--
-- Name: TABLE daily_reports_dash; Type: ACL; Schema: cleanup; Owner: bitzlato
--

GRANT SELECT ON TABLE cleanup.daily_reports_dash TO igor;


--
-- Name: TABLE one_time_code; Type: ACL; Schema: cleanup; Owner: bitzlato
--

GRANT SELECT ON TABLE cleanup.one_time_code TO drey;
GRANT SELECT ON TABLE cleanup.one_time_code TO admin_manager;
GRANT SELECT ON TABLE cleanup.one_time_code TO zeppelin;
GRANT SELECT ON TABLE cleanup.one_time_code TO lucky;
GRANT SELECT ON TABLE cleanup.one_time_code TO maelstromm;
GRANT SELECT ON TABLE cleanup.one_time_code TO igor;
GRANT SELECT ON TABLE cleanup.one_time_code TO michael;
GRANT SELECT ON TABLE cleanup.one_time_code TO vladimir;
GRANT ALL ON TABLE cleanup.one_time_code TO postgres_exporter;
GRANT ALL ON TABLE cleanup.one_time_code TO vanch;


--
-- Name: TABLE stablecoin_exchange; Type: ACL; Schema: cleanup; Owner: bitzlato
--

GRANT SELECT ON TABLE cleanup.stablecoin_exchange TO drey;
GRANT SELECT ON TABLE cleanup.stablecoin_exchange TO admin_manager;
GRANT SELECT ON TABLE cleanup.stablecoin_exchange TO zeppelin;
GRANT SELECT ON TABLE cleanup.stablecoin_exchange TO lucky;
GRANT SELECT ON TABLE cleanup.stablecoin_exchange TO maelstromm;
GRANT SELECT ON TABLE cleanup.stablecoin_exchange TO igor;
GRANT SELECT ON TABLE cleanup.stablecoin_exchange TO michael;
GRANT SELECT ON TABLE cleanup.stablecoin_exchange TO vladimir;
GRANT ALL ON TABLE cleanup.stablecoin_exchange TO postgres_exporter;
GRANT ALL ON TABLE cleanup.stablecoin_exchange TO vanch;


--
-- Name: TABLE trade_stats; Type: ACL; Schema: cleanup; Owner: bitzlato
--

GRANT SELECT ON TABLE cleanup.trade_stats TO drey;
GRANT SELECT ON TABLE cleanup.trade_stats TO zeppelin;
GRANT SELECT ON TABLE cleanup.trade_stats TO admin_manager;
GRANT ALL ON TABLE cleanup.trade_stats TO postgres_exporter;
GRANT SELECT ON TABLE cleanup.trade_stats TO maelstromm;
GRANT SELECT ON TABLE cleanup.trade_stats TO michael;
GRANT SELECT ON TABLE cleanup.trade_stats TO igor;
GRANT SELECT ON TABLE cleanup.trade_stats TO lucky;
GRANT SELECT ON TABLE cleanup.trade_stats TO vladimir;
GRANT ALL ON TABLE cleanup.trade_stats TO vanch;


--
-- Name: TABLE wallet_backup_merge_issues; Type: ACL; Schema: history; Owner: vanch
--

GRANT SELECT ON TABLE history.wallet_backup_merge_issues TO bitzlato_reader;


--
-- Name: TABLE wallets_backup; Type: ACL; Schema: history; Owner: bitzlato
--

GRANT SELECT ON TABLE history.wallets_backup TO admin_manager;
GRANT SELECT ON TABLE history.wallets_backup TO drey;
GRANT SELECT ON TABLE history.wallets_backup TO maelstromm;
GRANT SELECT ON TABLE history.wallets_backup TO michael;
GRANT SELECT ON TABLE history.wallets_backup TO igor;
GRANT SELECT ON TABLE history.wallets_backup TO vladimir;
GRANT SELECT ON TABLE history.wallets_backup TO zeppelin;
GRANT SELECT ON TABLE history.wallets_backup TO bitzlato_reader;


--
-- Name: TABLE wallets_change; Type: ACL; Schema: history; Owner: bitzlato
--

GRANT SELECT ON TABLE history.wallets_change TO drey;
GRANT SELECT ON TABLE history.wallets_change TO zeppelin;
GRANT SELECT ON TABLE history.wallets_change TO maelstromm;
GRANT SELECT ON TABLE history.wallets_change TO bitzlato_reader;


--
-- Name: TABLE address_analyses; Type: ACL; Schema: meduza; Owner: meduza
--

GRANT SELECT ON TABLE meduza.address_analyses TO bitzlato_reader;


--
-- Name: TABLE analysis_results; Type: ACL; Schema: meduza; Owner: meduza
--

GRANT SELECT ON TABLE meduza.analysis_results TO bitzlato_reader;


--
-- Name: TABLE analyzed_users; Type: ACL; Schema: meduza; Owner: meduza
--

GRANT SELECT ON TABLE meduza.analyzed_users TO bitzlato_reader;


--
-- Name: TABLE ar_internal_metadata; Type: ACL; Schema: meduza; Owner: meduza
--

GRANT SELECT ON TABLE meduza.ar_internal_metadata TO bitzlato_reader;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: meduza; Owner: meduza
--

GRANT SELECT ON TABLE meduza.schema_migrations TO bitzlato_reader;


--
-- Name: TABLE transaction_analyses; Type: ACL; Schema: meduza; Owner: meduza
--

GRANT SELECT ON TABLE meduza.transaction_analyses TO bitzlato_reader;


--
-- Name: TABLE transaction_sources; Type: ACL; Schema: meduza; Owner: meduza
--

GRANT SELECT ON TABLE meduza.transaction_sources TO bitzlato_reader;


--
-- Name: TABLE bill; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT SELECT ON TABLE mer.bill TO michael;
GRANT SELECT ON TABLE mer.bill TO backadm;
GRANT SELECT ON TABLE mer.bill TO bitzlato_reader;
GRANT ALL ON TABLE mer.bill TO bitzlato_admin;


--
-- Name: SEQUENCE bills_id_seq; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT ALL ON SEQUENCE mer.bills_id_seq TO bitzlato_admin;


--
-- Name: TABLE invoice; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT SELECT ON TABLE mer.invoice TO michael;
GRANT SELECT ON TABLE mer.invoice TO backadm;
GRANT SELECT ON TABLE mer.invoice TO bitzlato_reader;
GRANT ALL ON TABLE mer.invoice TO bitzlato_admin;


--
-- Name: TABLE invoice_transaction; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT SELECT ON TABLE mer.invoice_transaction TO michael;
GRANT SELECT ON TABLE mer.invoice_transaction TO backadm;
GRANT SELECT ON TABLE mer.invoice_transaction TO bitzlato_reader;
GRANT ALL ON TABLE mer.invoice_transaction TO bitzlato_admin;


--
-- Name: SEQUENCE invoices_id_seq; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT ALL ON SEQUENCE mer.invoices_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE invoices_transactions_id_seq; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT ALL ON SEQUENCE mer.invoices_transactions_id_seq TO bitzlato_admin;


--
-- Name: TABLE merchant; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT SELECT ON TABLE mer.merchant TO michael;
GRANT SELECT ON TABLE mer.merchant TO backadm;
GRANT SELECT ON TABLE mer.merchant TO bitzlato_reader;
GRANT ALL ON TABLE mer.merchant TO bitzlato_admin;


--
-- Name: SEQUENCE merchant_id_seq; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT ALL ON SEQUENCE mer.merchant_id_seq TO bitzlato_admin;


--
-- Name: TABLE payment; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT SELECT ON TABLE mer.payment TO bitzlato_reader;
GRANT ALL ON TABLE mer.payment TO bitzlato_admin;


--
-- Name: SEQUENCE payments_id_seq; Type: ACL; Schema: mer; Owner: bitzlato
--

GRANT ALL ON SEQUENCE mer.payments_id_seq TO bitzlato_admin;


--
-- Name: TABLE admin_file_uploaded; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.admin_file_uploaded TO zeppelin;
GRANT SELECT ON TABLE p2p.admin_file_uploaded TO admin_manager;
GRANT SELECT ON TABLE p2p.admin_file_uploaded TO michael;
GRANT SELECT ON TABLE p2p.admin_file_uploaded TO igor;
GRANT SELECT ON TABLE p2p.admin_file_uploaded TO vladimir;
GRANT ALL ON TABLE p2p.admin_file_uploaded TO vanch;
GRANT SELECT ON TABLE p2p.admin_file_uploaded TO bitzlato_reader;


--
-- Name: SEQUENCE admin_file_uploded_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.admin_file_uploded_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE ads_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.ads_id_seq TO bitzlato_admin;


--
-- Name: TABLE audit; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.audit TO zeppelin;
GRANT SELECT ON TABLE p2p.audit TO admin_manager;
GRANT SELECT ON TABLE p2p.audit TO michael;
GRANT SELECT ON TABLE p2p.audit TO igor;
GRANT SELECT ON TABLE p2p.audit TO vladimir;
GRANT ALL ON TABLE p2p.audit TO vanch;
GRANT SELECT ON TABLE p2p.audit TO bitzlato_reader;


--
-- Name: SEQUENCE audit_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.audit_id_seq TO bitzlato_admin;


--
-- Name: TABLE "backup$wallet_log"; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p."backup$wallet_log" TO zeppelin;
GRANT SELECT ON TABLE p2p."backup$wallet_log" TO admin_manager;
GRANT SELECT ON TABLE p2p."backup$wallet_log" TO michael;
GRANT SELECT ON TABLE p2p."backup$wallet_log" TO igor;
GRANT SELECT ON TABLE p2p."backup$wallet_log" TO vladimir;
GRANT ALL ON TABLE p2p."backup$wallet_log" TO vanch;
GRANT SELECT ON TABLE p2p."backup$wallet_log" TO bitzlato_reader;


--
-- Name: TABLE cryptocurrency_settings; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.cryptocurrency_settings TO zeppelin;
GRANT SELECT ON TABLE p2p.cryptocurrency_settings TO admin_manager;
GRANT SELECT ON TABLE p2p.cryptocurrency_settings TO michael;
GRANT SELECT ON TABLE p2p.cryptocurrency_settings TO igor;
GRANT SELECT ON TABLE p2p.cryptocurrency_settings TO vladimir;
GRANT ALL ON TABLE p2p.cryptocurrency_settings TO vanch;
GRANT SELECT ON TABLE p2p.cryptocurrency_settings TO bitzlato_monitoring;
GRANT SELECT ON TABLE p2p.cryptocurrency_settings TO bitzlato_reader;
GRANT INSERT,DELETE,UPDATE ON TABLE p2p.cryptocurrency_settings TO bitzlato_admin;


--
-- Name: TABLE rate; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.rate TO zeppelin;
GRANT SELECT ON TABLE p2p.rate TO admin_manager;
GRANT SELECT ON TABLE p2p.rate TO michael;
GRANT SELECT ON TABLE p2p.rate TO igor;
GRANT SELECT ON TABLE p2p.rate TO vladimir;
GRANT ALL ON TABLE p2p.rate TO vanch;
GRANT SELECT ON TABLE p2p.rate TO bitzlato_reader;


--
-- Name: TABLE trade_statistic; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.trade_statistic TO admin_manager;
GRANT SELECT ON TABLE p2p.trade_statistic TO zeppelin;
GRANT SELECT ON TABLE p2p.trade_statistic TO igor;
GRANT SELECT ON TABLE p2p.trade_statistic TO michael;
GRANT SELECT ON TABLE p2p.trade_statistic TO vladimir;
GRANT ALL ON TABLE p2p.trade_statistic TO vanch;
GRANT UPDATE ON TABLE p2p.trade_statistic TO bitzlato_writer;
GRANT SELECT ON TABLE p2p.trade_statistic TO bitzlato_reader;


--
-- Name: TABLE user_profile; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_profile TO zeppelin;
GRANT SELECT ON TABLE p2p.user_profile TO admin_manager;
GRANT SELECT ON TABLE p2p.user_profile TO michael;
GRANT SELECT ON TABLE p2p.user_profile TO igor;
GRANT SELECT ON TABLE p2p.user_profile TO vladimir;
GRANT ALL ON TABLE p2p.user_profile TO vanch;
GRANT SELECT ON TABLE p2p.user_profile TO bitzlato_reader;
GRANT INSERT,DELETE,UPDATE ON TABLE p2p.user_profile TO bitzlato_admin;


--
-- Name: COLUMN user_profile.lang; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(lang) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.user_id; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(user_id) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.currency; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(currency) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.cryptocurrency; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(cryptocurrency) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.start_of_use_date; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(start_of_use_date) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.rating; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(rating) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.lastactivity; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(lastactivity) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.blocked_by_admin; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(blocked_by_admin) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.verified; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(verified) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.safe_mode_enabled; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(safe_mode_enabled) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.pass_safety_wizard; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(pass_safety_wizard) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.suspicious; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(suspicious) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.merged; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(merged) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.lang_web; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(lang_web) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.verification_date; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(verification_date) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: COLUMN user_profile.timezone; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(timezone) ON TABLE p2p.user_profile TO bitzlato_analytics;


--
-- Name: TABLE cryptocurrency; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.cryptocurrency TO admin_manager;
GRANT SELECT ON TABLE public.cryptocurrency TO igor;
GRANT SELECT ON TABLE public.cryptocurrency TO michael;
GRANT SELECT ON TABLE public.cryptocurrency TO vladimir;
GRANT SELECT ON TABLE public.cryptocurrency TO bitzlato_reader;
GRANT ALL ON TABLE public.cryptocurrency TO bitzlato_admin;
GRANT SELECT ON TABLE public.cryptocurrency TO bitzlato_monitoring;


--
-- Name: TABLE user_cryptocurrency_settings; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.user_cryptocurrency_settings TO admin_manager;
GRANT SELECT ON TABLE public.user_cryptocurrency_settings TO igor;
GRANT SELECT ON TABLE public.user_cryptocurrency_settings TO vladimir;
GRANT SELECT ON TABLE public.user_cryptocurrency_settings TO bitzlato_reader;
GRANT ALL ON TABLE public.user_cryptocurrency_settings TO bitzlato_admin;


--
-- Name: TABLE buy_ads_mview; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.buy_ads_mview TO drey;
GRANT SELECT ON TABLE p2p.buy_ads_mview TO bitzlato_reader;


--
-- Name: TABLE buy_ads_view; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.buy_ads_view TO drey;
GRANT SELECT ON TABLE p2p.buy_ads_view TO bitzlato_reader;


--
-- Name: TABLE cc_settings_backup; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.cc_settings_backup TO admin_manager;
GRANT SELECT ON TABLE p2p.cc_settings_backup TO michael;
GRANT SELECT ON TABLE p2p.cc_settings_backup TO igor;
GRANT SELECT ON TABLE p2p.cc_settings_backup TO vladimir;
GRANT SELECT ON TABLE p2p.cc_settings_backup TO zeppelin;
GRANT SELECT ON TABLE p2p.cc_settings_backup TO bitzlato_reader;


--
-- Name: TABLE chat; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.chat TO zeppelin;
GRANT SELECT ON TABLE p2p.chat TO admin_manager;
GRANT SELECT ON TABLE p2p.chat TO michael;
GRANT SELECT ON TABLE p2p.chat TO igor;
GRANT SELECT ON TABLE p2p.chat TO vladimir;
GRANT ALL ON TABLE p2p.chat TO vanch;
GRANT SELECT ON TABLE p2p.chat TO bitzlato_reader;


--
-- Name: SEQUENCE chat_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.chat_id_seq TO bitzlato_admin;


--
-- Name: TABLE config; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.config TO admin_manager;
GRANT SELECT ON TABLE p2p.config TO michael;
GRANT SELECT ON TABLE p2p.config TO zeppelin;
GRANT SELECT ON TABLE p2p.config TO igor;
GRANT SELECT ON TABLE p2p.config TO vladimir;
GRANT ALL ON TABLE p2p.config TO vanch;
GRANT SELECT ON TABLE p2p.config TO bitzlato_reader;


--
-- Name: TABLE config_maintenance; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.config_maintenance TO admin_manager;
GRANT SELECT ON TABLE p2p.config_maintenance TO michael;
GRANT SELECT ON TABLE p2p.config_maintenance TO zeppelin;
GRANT SELECT ON TABLE p2p.config_maintenance TO igor;
GRANT SELECT ON TABLE p2p.config_maintenance TO vladimir;
GRANT ALL ON TABLE p2p.config_maintenance TO vanch;
GRANT SELECT ON TABLE p2p.config_maintenance TO bitzlato_reader;


--
-- Name: TABLE cryptocurrency_rate_source; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.cryptocurrency_rate_source TO admin_manager;
GRANT SELECT ON TABLE p2p.cryptocurrency_rate_source TO igor;
GRANT SELECT ON TABLE p2p.cryptocurrency_rate_source TO vladimir;
GRANT ALL ON TABLE p2p.cryptocurrency_rate_source TO vanch;
GRANT SELECT ON TABLE p2p.cryptocurrency_rate_source TO zeppelin;
GRANT SELECT ON TABLE p2p.cryptocurrency_rate_source TO bitzlato_reader;


--
-- Name: TABLE currency; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.currency TO zeppelin;
GRANT SELECT ON TABLE p2p.currency TO admin_manager;
GRANT SELECT ON TABLE p2p.currency TO michael;
GRANT SELECT ON TABLE p2p.currency TO igor;
GRANT SELECT ON TABLE p2p.currency TO vladimir;
GRANT ALL ON TABLE p2p.currency TO vanch;
GRANT SELECT ON TABLE p2p.currency TO bitzlato_reader;
GRANT INSERT,UPDATE ON TABLE p2p.currency TO bitzlato_admin;


--
-- Name: TABLE debt; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.debt TO admin_manager;
GRANT SELECT ON TABLE p2p.debt TO michael;
GRANT SELECT ON TABLE p2p.debt TO zeppelin;
GRANT SELECT ON TABLE p2p.debt TO igor;
GRANT SELECT ON TABLE p2p.debt TO vladimir;
GRANT ALL ON TABLE p2p.debt TO vanch;
GRANT SELECT ON TABLE p2p.debt TO bitzlato_reader;


--
-- Name: SEQUENCE debts_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.debts_id_seq TO bitzlato_admin;


--
-- Name: TABLE deep_link_action; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.deep_link_action TO zeppelin;
GRANT SELECT ON TABLE p2p.deep_link_action TO admin_manager;
GRANT SELECT ON TABLE p2p.deep_link_action TO michael;
GRANT SELECT ON TABLE p2p.deep_link_action TO igor;
GRANT SELECT ON TABLE p2p.deep_link_action TO vladimir;
GRANT ALL ON TABLE p2p.deep_link_action TO vanch;
GRANT SELECT ON TABLE p2p.deep_link_action TO bitzlato_reader;


--
-- Name: SEQUENCE deep_link_action_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.deep_link_action_id_seq TO bitzlato_admin;


--
-- Name: TABLE deep_link_referal_action; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.deep_link_referal_action TO zeppelin;
GRANT SELECT ON TABLE p2p.deep_link_referal_action TO admin_manager;
GRANT SELECT ON TABLE p2p.deep_link_referal_action TO michael;
GRANT SELECT ON TABLE p2p.deep_link_referal_action TO igor;
GRANT SELECT ON TABLE p2p.deep_link_referal_action TO vladimir;
GRANT ALL ON TABLE p2p.deep_link_referal_action TO vanch;
GRANT SELECT ON TABLE p2p.deep_link_referal_action TO bitzlato_reader;


--
-- Name: TABLE deeplink_utm; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.deeplink_utm TO admin_manager;
GRANT SELECT ON TABLE p2p.deeplink_utm TO zeppelin;
GRANT SELECT ON TABLE p2p.deeplink_utm TO igor;
GRANT SELECT ON TABLE p2p.deeplink_utm TO michael;
GRANT SELECT ON TABLE p2p.deeplink_utm TO vladimir;
GRANT ALL ON TABLE p2p.deeplink_utm TO vanch;
GRANT SELECT ON TABLE p2p.deeplink_utm TO bitzlato_reader;


--
-- Name: TABLE dispute; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.dispute TO zeppelin;
GRANT SELECT ON TABLE p2p.dispute TO admin_manager;
GRANT SELECT ON TABLE p2p.dispute TO michael;
GRANT SELECT ON TABLE p2p.dispute TO igor;
GRANT SELECT ON TABLE p2p.dispute TO vladimir;
GRANT ALL ON TABLE p2p.dispute TO vanch;
GRANT SELECT ON TABLE p2p.dispute TO bitzlato_reader;
GRANT SELECT ON TABLE p2p.dispute TO bitzlato_analytics;


--
-- Name: TABLE dispute_decision; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.dispute_decision TO admin_manager;
GRANT SELECT ON TABLE p2p.dispute_decision TO zeppelin;
GRANT SELECT ON TABLE p2p.dispute_decision TO igor;
GRANT SELECT ON TABLE p2p.dispute_decision TO michael;
GRANT SELECT ON TABLE p2p.dispute_decision TO vladimir;
GRANT ALL ON TABLE p2p.dispute_decision TO vanch;
GRANT SELECT ON TABLE p2p.dispute_decision TO bitzlato_reader;


--
-- Name: SEQUENCE dispute_decisions_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.dispute_decisions_id_seq TO bitzlato_admin;


--
-- Name: TABLE dispute_video; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.dispute_video TO zeppelin;
GRANT SELECT ON TABLE p2p.dispute_video TO igor;
GRANT SELECT ON TABLE p2p.dispute_video TO bitzlato_reader;


--
-- Name: SEQUENCE dispute_video_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.dispute_video_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE disputes_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.disputes_id_seq TO bitzlato_admin;


--
-- Name: TABLE dust_aggregation; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON TABLE p2p.dust_aggregation TO dust_collector;
GRANT SELECT ON TABLE p2p.dust_aggregation TO igor;
GRANT SELECT ON TABLE p2p.dust_aggregation TO zeppelin;
GRANT SELECT ON TABLE p2p.dust_aggregation TO bitzlato_reader;


--
-- Name: SEQUENCE dust_aggregation_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.dust_aggregation_id_seq TO bitzlato_admin;


--
-- Name: TABLE feature; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.feature TO admin_manager;
GRANT SELECT ON TABLE p2p.feature TO michael;
GRANT SELECT ON TABLE p2p.feature TO zeppelin;
GRANT SELECT ON TABLE p2p.feature TO igor;
GRANT SELECT ON TABLE p2p.feature TO vladimir;
GRANT ALL ON TABLE p2p.feature TO vanch;
GRANT SELECT ON TABLE p2p.feature TO bitzlato_reader;


--
-- Name: TABLE feedback; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.feedback TO zeppelin;
GRANT SELECT ON TABLE p2p.feedback TO admin_manager;
GRANT SELECT ON TABLE p2p.feedback TO michael;
GRANT SELECT ON TABLE p2p.feedback TO igor;
GRANT SELECT ON TABLE p2p.feedback TO vladimir;
GRANT ALL ON TABLE p2p.feedback TO vanch;
GRANT UPDATE ON TABLE p2p.feedback TO bitzlato_writer;
GRANT SELECT ON TABLE p2p.feedback TO bitzlato_reader;


--
-- Name: SEQUENCE feedbacks_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.feedbacks_id_seq TO bitzlato_admin;


--
-- Name: TABLE forbidden_public_name; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.forbidden_public_name TO igor;
GRANT SELECT ON TABLE p2p.forbidden_public_name TO michael;
GRANT SELECT ON TABLE p2p.forbidden_public_name TO admin_manager;
GRANT SELECT ON TABLE p2p.forbidden_public_name TO vladimir;
GRANT ALL ON TABLE p2p.forbidden_public_name TO vanch;
GRANT SELECT ON TABLE p2p.forbidden_public_name TO zeppelin;
GRANT INSERT ON TABLE p2p.forbidden_public_name TO bitzlato_writer;
GRANT SELECT ON TABLE p2p.forbidden_public_name TO bitzlato_reader;


--
-- Name: TABLE identity_verification_attempt; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.identity_verification_attempt TO zeppelin;
GRANT SELECT ON TABLE p2p.identity_verification_attempt TO igor;
GRANT SELECT ON TABLE p2p.identity_verification_attempt TO bitzlato_reader;


--
-- Name: TABLE lang; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.lang TO zeppelin;
GRANT SELECT ON TABLE p2p.lang TO admin_manager;
GRANT SELECT ON TABLE p2p.lang TO michael;
GRANT SELECT ON TABLE p2p.lang TO igor;
GRANT SELECT ON TABLE p2p.lang TO vladimir;
GRANT ALL ON TABLE p2p.lang TO vanch;
GRANT SELECT ON TABLE p2p.lang TO bitzlato_reader;


--
-- Name: TABLE merge; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.merge TO admin_manager;
GRANT SELECT ON TABLE p2p.merge TO michael;
GRANT SELECT ON TABLE p2p.merge TO zeppelin;
GRANT SELECT ON TABLE p2p.merge TO igor;
GRANT SELECT ON TABLE p2p.merge TO vladimir;
GRANT ALL ON TABLE p2p.merge TO vanch;
GRANT SELECT ON TABLE p2p.merge TO bitzlato_reader;


--
-- Name: TABLE merge_token; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.merge_token TO admin_manager;
GRANT SELECT ON TABLE p2p.merge_token TO zeppelin;
GRANT SELECT ON TABLE p2p.merge_token TO igor;
GRANT SELECT ON TABLE p2p.merge_token TO michael;
GRANT SELECT ON TABLE p2p.merge_token TO vladimir;
GRANT ALL ON TABLE p2p.merge_token TO vanch;
GRANT SELECT ON TABLE p2p.merge_token TO bitzlato_finance;
GRANT SELECT ON TABLE p2p.merge_token TO bitzlato_reader;


--
-- Name: SEQUENCE merge_tokens_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.merge_tokens_id_seq TO bitzlato_admin;


--
-- Name: TABLE muted_user; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.muted_user TO admin_manager;
GRANT SELECT ON TABLE p2p.muted_user TO michael;
GRANT SELECT ON TABLE p2p.muted_user TO zeppelin;
GRANT SELECT ON TABLE p2p.muted_user TO igor;
GRANT SELECT ON TABLE p2p.muted_user TO vladimir;
GRANT ALL ON TABLE p2p.muted_user TO vanch;
GRANT UPDATE ON TABLE p2p.muted_user TO bitzlato_writer;
GRANT SELECT ON TABLE p2p.muted_user TO bitzlato_reader;


--
-- Name: SEQUENCE muted_users_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.muted_users_id_seq TO bitzlato_admin;


--
-- Name: TABLE notebook; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.notebook TO zeppelin;
GRANT SELECT ON TABLE p2p.notebook TO admin_manager;
GRANT SELECT ON TABLE p2p.notebook TO michael;
GRANT SELECT ON TABLE p2p.notebook TO igor;
GRANT SELECT ON TABLE p2p.notebook TO vladimir;
GRANT ALL ON TABLE p2p.notebook TO vanch;
GRANT SELECT ON TABLE p2p.notebook TO bitzlato_reader;


--
-- Name: SEQUENCE notebook_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.notebook_id_seq TO bitzlato_admin;


--
-- Name: TABLE notification; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.notification TO admin_manager;
GRANT SELECT ON TABLE p2p.notification TO michael;
GRANT SELECT ON TABLE p2p.notification TO zeppelin;
GRANT SELECT ON TABLE p2p.notification TO igor;
GRANT SELECT ON TABLE p2p.notification TO vladimir;
GRANT ALL ON TABLE p2p.notification TO vanch;
GRANT SELECT ON TABLE p2p.notification TO bitzlato_reader;


--
-- Name: TABLE notification_token; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.notification_token TO admin_manager;
GRANT SELECT ON TABLE p2p.notification_token TO michael;
GRANT SELECT ON TABLE p2p.notification_token TO zeppelin;
GRANT SELECT ON TABLE p2p.notification_token TO igor;
GRANT SELECT ON TABLE p2p.notification_token TO vladimir;
GRANT ALL ON TABLE p2p.notification_token TO vanch;
GRANT SELECT ON TABLE p2p.notification_token TO bitzlato_reader;


--
-- Name: SEQUENCE notifications_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.notifications_id_seq TO bitzlato_admin;


--
-- Name: TABLE old_data_profile; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.old_data_profile TO admin_manager;
GRANT SELECT ON TABLE p2p.old_data_profile TO michael;
GRANT SELECT ON TABLE p2p.old_data_profile TO zeppelin;
GRANT SELECT ON TABLE p2p.old_data_profile TO igor;
GRANT SELECT ON TABLE p2p.old_data_profile TO vladimir;
GRANT ALL ON TABLE p2p.old_data_profile TO vanch;
GRANT SELECT ON TABLE p2p.old_data_profile TO bitzlato_reader;


--
-- Name: SEQUENCE old_data_profile_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.old_data_profile_id_seq TO bitzlato_admin;


--
-- Name: TABLE payment_group; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.payment_group TO admin_manager;
GRANT SELECT ON TABLE p2p.payment_group TO zeppelin;
GRANT SELECT ON TABLE p2p.payment_group TO igor;
GRANT SELECT ON TABLE p2p.payment_group TO michael;
GRANT SELECT ON TABLE p2p.payment_group TO vladimir;
GRANT ALL ON TABLE p2p.payment_group TO vanch;
GRANT SELECT ON TABLE p2p.payment_group TO bitzlato_reader;
GRANT SELECT ON TABLE p2p.payment_group TO bitzlato_analytics;


--
-- Name: TABLE payment_group_multilang; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.payment_group_multilang TO zeppelin;
GRANT SELECT ON TABLE p2p.payment_group_multilang TO admin_manager;
GRANT SELECT ON TABLE p2p.payment_group_multilang TO igor;
GRANT SELECT ON TABLE p2p.payment_group_multilang TO michael;
GRANT SELECT ON TABLE p2p.payment_group_multilang TO vladimir;
GRANT ALL ON TABLE p2p.payment_group_multilang TO vanch;
GRANT SELECT ON TABLE p2p.payment_group_multilang TO bitzlato_reader;


--
-- Name: TABLE payment_list_precalculation; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.payment_list_precalculation TO zeppelin;
GRANT SELECT ON TABLE p2p.payment_list_precalculation TO admin_manager;
GRANT SELECT ON TABLE p2p.payment_list_precalculation TO michael;
GRANT SELECT ON TABLE p2p.payment_list_precalculation TO igor;
GRANT SELECT ON TABLE p2p.payment_list_precalculation TO vladimir;
GRANT ALL ON TABLE p2p.payment_list_precalculation TO vanch;
GRANT SELECT ON TABLE p2p.payment_list_precalculation TO bitzlato_reader;


--
-- Name: TABLE payment_method_global; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.payment_method_global TO admin_manager;
GRANT SELECT ON TABLE p2p.payment_method_global TO zeppelin;
GRANT SELECT ON TABLE p2p.payment_method_global TO igor;
GRANT SELECT ON TABLE p2p.payment_method_global TO michael;
GRANT SELECT ON TABLE p2p.payment_method_global TO vladimir;
GRANT ALL ON TABLE p2p.payment_method_global TO vanch;
GRANT SELECT ON TABLE p2p.payment_method_global TO bitzlato_reader;


--
-- Name: SEQUENCE payment_method_global_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.payment_method_global_id_seq TO bitzlato_admin;


--
-- Name: TABLE payment_method_hist; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.payment_method_hist TO igor;
GRANT SELECT ON TABLE p2p.payment_method_hist TO bitzlato_reader;


--
-- Name: SEQUENCE payment_method_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.payment_method_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE payments_group_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.payments_group_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE payments_group_multilang_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.payments_group_multilang_id_seq TO bitzlato_admin;


--
-- Name: TABLE rate_fiat; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.rate_fiat TO zeppelin;
GRANT SELECT ON TABLE p2p.rate_fiat TO admin_manager;
GRANT SELECT ON TABLE p2p.rate_fiat TO michael;
GRANT SELECT ON TABLE p2p.rate_fiat TO igor;
GRANT SELECT ON TABLE p2p.rate_fiat TO vladimir;
GRANT ALL ON TABLE p2p.rate_fiat TO vanch;
GRANT SELECT ON TABLE p2p.rate_fiat TO bitzlato_reader;


--
-- Name: TABLE rate_plan_withdraw; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.rate_plan_withdraw TO drey;
GRANT INSERT,UPDATE ON TABLE p2p.rate_plan_withdraw TO bitzlato_finance;
GRANT SELECT ON TABLE p2p.rate_plan_withdraw TO bitzlato_monitoring;
GRANT SELECT ON TABLE p2p.rate_plan_withdraw TO bitzlato_reader;


--
-- Name: TABLE rate_source; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.rate_source TO admin_manager;
GRANT SELECT ON TABLE p2p.rate_source TO igor;
GRANT SELECT ON TABLE p2p.rate_source TO vladimir;
GRANT ALL ON TABLE p2p.rate_source TO vanch;
GRANT SELECT ON TABLE p2p.rate_source TO zeppelin;
GRANT SELECT ON TABLE p2p.rate_source TO bitzlato_reader;


--
-- Name: SEQUENCE rates_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.rates_id_seq TO bitzlato_admin;


--
-- Name: TABLE rating_change_log; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.rating_change_log TO admin_manager;
GRANT SELECT ON TABLE p2p.rating_change_log TO zeppelin;
GRANT SELECT ON TABLE p2p.rating_change_log TO igor;
GRANT SELECT ON TABLE p2p.rating_change_log TO michael;
GRANT SELECT ON TABLE p2p.rating_change_log TO vladimir;
GRANT ALL ON TABLE p2p.rating_change_log TO vanch;
GRANT SELECT ON TABLE p2p.rating_change_log TO bitzlato_reader;


--
-- Name: SEQUENCE rating_change_log_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.rating_change_log_id_seq TO bitzlato_admin;


--
-- Name: TABLE referal_bonus; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.referal_bonus TO zeppelin;
GRANT SELECT ON TABLE p2p.referal_bonus TO admin_manager;
GRANT SELECT ON TABLE p2p.referal_bonus TO michael;
GRANT SELECT ON TABLE p2p.referal_bonus TO igor;
GRANT SELECT ON TABLE p2p.referal_bonus TO vladimir;
GRANT ALL ON TABLE p2p.referal_bonus TO vanch;
GRANT SELECT ON TABLE p2p.referal_bonus TO bitzlato_reader;


--
-- Name: SEQUENCE referal_bonuses_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.referal_bonuses_id_seq TO bitzlato_admin;


--
-- Name: TABLE referral_links_statistic; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.referral_links_statistic TO admin_manager;
GRANT SELECT ON TABLE p2p.referral_links_statistic TO michael;
GRANT SELECT ON TABLE p2p.referral_links_statistic TO zeppelin;
GRANT SELECT ON TABLE p2p.referral_links_statistic TO igor;
GRANT SELECT ON TABLE p2p.referral_links_statistic TO vladimir;
GRANT ALL ON TABLE p2p.referral_links_statistic TO vanch;
GRANT SELECT ON TABLE p2p.referral_links_statistic TO bitzlato_reader;


--
-- Name: SEQUENCE referral_links_statistic_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.referral_links_statistic_id_seq TO bitzlato_admin;


--
-- Name: TABLE report; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.report TO zeppelin;
GRANT SELECT ON TABLE p2p.report TO admin_manager;
GRANT SELECT ON TABLE p2p.report TO michael;
GRANT SELECT ON TABLE p2p.report TO igor;
GRANT SELECT ON TABLE p2p.report TO vladimir;
GRANT ALL ON TABLE p2p.report TO vanch;
GRANT SELECT ON TABLE p2p.report TO bitzlato_reader;


--
-- Name: TABLE requisite; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.requisite TO zeppelin;
GRANT SELECT ON TABLE p2p.requisite TO admin_manager;
GRANT SELECT ON TABLE p2p.requisite TO michael;
GRANT SELECT ON TABLE p2p.requisite TO igor;
GRANT SELECT ON TABLE p2p.requisite TO vladimir;
GRANT ALL ON TABLE p2p.requisite TO vanch;
GRANT SELECT ON TABLE p2p.requisite TO bitzlato_reader;


--
-- Name: SEQUENCE requisites_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.requisites_id_seq TO bitzlato_admin;


--
-- Name: TABLE sell_ads_mview; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.sell_ads_mview TO drey;
GRANT SELECT ON TABLE p2p.sell_ads_mview TO bitzlato_reader;


--
-- Name: TABLE sell_ads_view; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.sell_ads_view TO drey;
GRANT SELECT ON TABLE p2p.sell_ads_view TO bitzlato_reader;


--
-- Name: TABLE stablecoin_trade; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.stablecoin_trade TO admin_manager;
GRANT SELECT ON TABLE p2p.stablecoin_trade TO zeppelin;
GRANT SELECT ON TABLE p2p.stablecoin_trade TO igor;
GRANT SELECT ON TABLE p2p.stablecoin_trade TO michael;
GRANT SELECT ON TABLE p2p.stablecoin_trade TO vladimir;
GRANT ALL ON TABLE p2p.stablecoin_trade TO vanch;
GRANT SELECT ON TABLE p2p.stablecoin_trade TO bitzlato_reader;


--
-- Name: TABLE trade; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.trade TO zeppelin;
GRANT SELECT ON TABLE p2p.trade TO admin_manager;
GRANT SELECT ON TABLE p2p.trade TO michael;
GRANT SELECT ON TABLE p2p.trade TO igor;
GRANT SELECT ON TABLE p2p.trade TO vladimir;
GRANT ALL ON TABLE p2p.trade TO vanch;
GRANT SELECT ON TABLE p2p.trade TO bitzlato_reader;


--
-- Name: COLUMN trade.id; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(id) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.trade_initiator; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(trade_initiator) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.crypto_seller; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(crypto_seller) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.crypto_buyer; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(crypto_buyer) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.status; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(status) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.currency; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(currency) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.amount; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(amount) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.cc_code; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(cc_code) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.cryptoamount; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(cryptoamount) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.fee_buyer; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(fee_buyer) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.fee_seller; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(fee_seller) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.ad_user_id; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(ad_user_id) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.ad_rate; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(ad_rate) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.ad_type; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(ad_type) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.ad_paymethod; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(ad_paymethod) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.ref_bonus_paid; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(ref_bonus_paid) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.comission; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(comission) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.creater_platform; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(creater_platform) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.confirmer_platform; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(confirmer_platform) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.ref_bonus_percent; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(ref_bonus_percent) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.created_at; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(created_at) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.tips_payed; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(tips_payed) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: COLUMN trade.tips_amount; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(tips_amount) ON TABLE p2p.trade TO bitzlato_analytics;


--
-- Name: TABLE trade_history; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.trade_history TO zeppelin;
GRANT SELECT ON TABLE p2p.trade_history TO admin_manager;
GRANT SELECT ON TABLE p2p.trade_history TO michael;
GRANT SELECT ON TABLE p2p.trade_history TO igor;
GRANT SELECT ON TABLE p2p.trade_history TO vladimir;
GRANT ALL ON TABLE p2p.trade_history TO vanch;
GRANT SELECT ON TABLE p2p.trade_history TO bitzlato_reader;


--
-- Name: SEQUENCE trade_history_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.trade_history_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE trade_statistic_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.trade_statistic_id_seq TO bitzlato_admin;


--
-- Name: TABLE trade_statistic_log; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.trade_statistic_log TO admin_manager;
GRANT SELECT ON TABLE p2p.trade_statistic_log TO zeppelin;
GRANT SELECT ON TABLE p2p.trade_statistic_log TO igor;
GRANT SELECT ON TABLE p2p.trade_statistic_log TO michael;
GRANT SELECT ON TABLE p2p.trade_statistic_log TO vladimir;
GRANT ALL ON TABLE p2p.trade_statistic_log TO vanch;
GRANT SELECT ON TABLE p2p.trade_statistic_log TO bitzlato_reader;


--
-- Name: SEQUENCE trade_statistic_log_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.trade_statistic_log_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE trades_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.trades_id_seq TO bitzlato_admin;


--
-- Name: TABLE untrusted_user; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.untrusted_user TO admin_manager;
GRANT SELECT ON TABLE p2p.untrusted_user TO michael;
GRANT SELECT ON TABLE p2p.untrusted_user TO zeppelin;
GRANT SELECT ON TABLE p2p.untrusted_user TO igor;
GRANT SELECT ON TABLE p2p.untrusted_user TO vladimir;
GRANT ALL ON TABLE p2p.untrusted_user TO vanch;
GRANT DELETE ON TABLE p2p.untrusted_user TO bitzlato_writer;
GRANT SELECT ON TABLE p2p.untrusted_user TO bitzlato_reader;


--
-- Name: SEQUENCE untrusted_users_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.untrusted_users_id_seq TO bitzlato_admin;


--
-- Name: TABLE user_2fa; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_2fa TO admin_manager;
GRANT SELECT ON TABLE p2p.user_2fa TO zeppelin;
GRANT SELECT ON TABLE p2p.user_2fa TO igor;
GRANT SELECT ON TABLE p2p.user_2fa TO michael;
GRANT SELECT ON TABLE p2p.user_2fa TO vladimir;
GRANT ALL ON TABLE p2p.user_2fa TO vanch;
GRANT SELECT ON TABLE p2p.user_2fa TO bitzlato_finance;
GRANT SELECT ON TABLE p2p.user_2fa TO bitzlato_reader;


--
-- Name: TABLE user_action_freeze; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_action_freeze TO admin_manager;
GRANT SELECT ON TABLE p2p.user_action_freeze TO zeppelin;
GRANT SELECT ON TABLE p2p.user_action_freeze TO igor;
GRANT SELECT ON TABLE p2p.user_action_freeze TO michael;
GRANT SELECT ON TABLE p2p.user_action_freeze TO vladimir;
GRANT ALL ON TABLE p2p.user_action_freeze TO vanch;
GRANT SELECT ON TABLE p2p.user_action_freeze TO bitzlato_reader;
GRANT SELECT ON TABLE p2p.user_action_freeze TO bitzlato_analytics;


--
-- Name: SEQUENCE user_actions_freeze_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.user_actions_freeze_id_seq TO bitzlato_admin;


--
-- Name: TABLE user_ad_filter; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_ad_filter TO admin_manager;
GRANT SELECT ON TABLE p2p.user_ad_filter TO zeppelin;
GRANT SELECT ON TABLE p2p.user_ad_filter TO igor;
GRANT SELECT ON TABLE p2p.user_ad_filter TO michael;
GRANT SELECT ON TABLE p2p.user_ad_filter TO vladimir;
GRANT ALL ON TABLE p2p.user_ad_filter TO vanch;
GRANT SELECT ON TABLE p2p.user_ad_filter TO bitzlato_reader;


--
-- Name: TABLE user_block; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_block TO zeppelin;
GRANT SELECT ON TABLE p2p.user_block TO admin_manager;
GRANT SELECT ON TABLE p2p.user_block TO michael;
GRANT SELECT ON TABLE p2p.user_block TO igor;
GRANT SELECT ON TABLE p2p.user_block TO vladimir;
GRANT ALL ON TABLE p2p.user_block TO vanch;
GRANT SELECT ON TABLE p2p.user_block TO bitzlato_reader;


--
-- Name: SEQUENCE user_block_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.user_block_id_seq TO bitzlato_admin;


--
-- Name: TABLE user_feature; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_feature TO admin_manager;
GRANT SELECT ON TABLE p2p.user_feature TO michael;
GRANT SELECT ON TABLE p2p.user_feature TO zeppelin;
GRANT SELECT ON TABLE p2p.user_feature TO igor;
GRANT SELECT ON TABLE p2p.user_feature TO vladimir;
GRANT ALL ON TABLE p2p.user_feature TO vanch;
GRANT SELECT ON TABLE p2p.user_feature TO bitzlato_reader;


--
-- Name: TABLE user_note; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_note TO admin_manager;
GRANT SELECT ON TABLE p2p.user_note TO zeppelin;
GRANT SELECT ON TABLE p2p.user_note TO igor;
GRANT SELECT ON TABLE p2p.user_note TO michael;
GRANT SELECT ON TABLE p2p.user_note TO vladimir;
GRANT ALL ON TABLE p2p.user_note TO vanch;
GRANT SELECT ON TABLE p2p.user_note TO bitzlato_reader;


--
-- Name: SEQUENCE user_notes_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.user_notes_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE user_profile_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.user_profile_id_seq TO bitzlato_admin;


--
-- Name: TABLE user_rate; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_rate TO zeppelin;
GRANT SELECT ON TABLE p2p.user_rate TO admin_manager;
GRANT SELECT ON TABLE p2p.user_rate TO michael;
GRANT SELECT ON TABLE p2p.user_rate TO igor;
GRANT SELECT ON TABLE p2p.user_rate TO vladimir;
GRANT ALL ON TABLE p2p.user_rate TO vanch;
GRANT SELECT ON TABLE p2p.user_rate TO bitzlato_reader;


--
-- Name: SEQUENCE user_rates_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.user_rates_id_seq TO bitzlato_admin;


--
-- Name: TABLE user_settings; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_settings TO zeppelin;
GRANT SELECT ON TABLE p2p.user_settings TO admin_manager;
GRANT SELECT ON TABLE p2p.user_settings TO igor;
GRANT SELECT ON TABLE p2p.user_settings TO michael;
GRANT SELECT ON TABLE p2p.user_settings TO vladimir;
GRANT ALL ON TABLE p2p.user_settings TO vanch;
GRANT SELECT ON TABLE p2p.user_settings TO bitzlato_reader;


--
-- Name: SEQUENCE user_settings_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.user_settings_id_seq TO bitzlato_admin;


--
-- Name: TABLE user_trust; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.user_trust TO admin_manager;
GRANT SELECT ON TABLE p2p.user_trust TO zeppelin;
GRANT SELECT ON TABLE p2p.user_trust TO igor;
GRANT SELECT ON TABLE p2p.user_trust TO michael;
GRANT SELECT ON TABLE p2p.user_trust TO vladimir;
GRANT ALL ON TABLE p2p.user_trust TO vanch;
GRANT SELECT ON TABLE p2p.user_trust TO bitzlato_reader;


--
-- Name: SEQUENCE user_trust_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.user_trust_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE users_2fa_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.users_2fa_id_seq TO bitzlato_admin;


--
-- Name: TABLE utm_statistic; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.utm_statistic TO michael;
GRANT SELECT ON TABLE p2p.utm_statistic TO zeppelin;
GRANT SELECT ON TABLE p2p.utm_statistic TO admin_manager;
GRANT SELECT ON TABLE p2p.utm_statistic TO igor;
GRANT SELECT ON TABLE p2p.utm_statistic TO vladimir;
GRANT ALL ON TABLE p2p.utm_statistic TO vanch;
GRANT SELECT ON TABLE p2p.utm_statistic TO bitzlato_reader;


--
-- Name: TABLE voucher; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.voucher TO zeppelin;
GRANT SELECT ON TABLE p2p.voucher TO admin_manager;
GRANT SELECT ON TABLE p2p.voucher TO michael;
GRANT SELECT ON TABLE p2p.voucher TO igor;
GRANT SELECT ON TABLE p2p.voucher TO vladimir;
GRANT ALL ON TABLE p2p.voucher TO vanch;
GRANT SELECT ON TABLE p2p.voucher TO bitzlato_finance;
GRANT SELECT ON TABLE p2p.voucher TO bitzlato_reader;


--
-- Name: COLUMN voucher.id; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(id) ON TABLE p2p.voucher TO bitzlato_analytics;


--
-- Name: COLUMN voucher.cc_code; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(cc_code) ON TABLE p2p.voucher TO bitzlato_analytics;


--
-- Name: COLUMN voucher.amount; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(amount) ON TABLE p2p.voucher TO bitzlato_analytics;


--
-- Name: COLUMN voucher.currency; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(currency) ON TABLE p2p.voucher TO bitzlato_analytics;


--
-- Name: COLUMN voucher.created_at; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(created_at) ON TABLE p2p.voucher TO bitzlato_analytics;


--
-- Name: COLUMN voucher.deleted_at; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(deleted_at) ON TABLE p2p.voucher TO bitzlato_analytics;


--
-- Name: COLUMN voucher.cashed_at; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(cashed_at) ON TABLE p2p.voucher TO bitzlato_analytics;


--
-- Name: COLUMN voucher.user_id; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(user_id) ON TABLE p2p.voucher TO bitzlato_analytics;


--
-- Name: COLUMN voucher.cashed_by_user_id; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT(cashed_by_user_id) ON TABLE p2p.voucher TO bitzlato_analytics;


--
-- Name: SEQUENCE voucher_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.voucher_id_seq TO bitzlato_admin;


--
-- Name: TABLE vw_audit; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.vw_audit TO drey;
GRANT SELECT ON TABLE p2p.vw_audit TO bitzlato_reader;


--
-- Name: TABLE vw_audit_latest; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.vw_audit_latest TO drey;
GRANT SELECT ON TABLE p2p.vw_audit_latest TO bitzlato_monitoring;
GRANT SELECT ON TABLE p2p.vw_audit_latest TO bitzlato_reader;


--
-- Name: TABLE blockchain_tx; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.blockchain_tx TO drey;
GRANT SELECT ON TABLE public.blockchain_tx TO bitzlato_reader;
GRANT ALL ON TABLE public.blockchain_tx TO bitzlato_admin;
GRANT REFERENCES,UPDATE ON TABLE public.blockchain_tx TO meduza;


--
-- Name: TABLE deposit; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.deposit TO admin_manager;
GRANT SELECT ON TABLE public.deposit TO michael;
GRANT SELECT ON TABLE public.deposit TO igor;
GRANT SELECT ON TABLE public.deposit TO vladimir;
GRANT SELECT ON TABLE public.deposit TO bitzlato_reader;
GRANT ALL ON TABLE public.deposit TO bitzlato_admin;
GRANT UPDATE ON TABLE public.deposit TO meduza;


--
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."user" TO admin_manager;
GRANT SELECT ON TABLE public."user" TO michael;
GRANT SELECT ON TABLE public."user" TO igor;
GRANT SELECT ON TABLE public."user" TO vladimir;
GRANT SELECT ON TABLE public."user" TO bitzlato_reader;
GRANT ALL ON TABLE public."user" TO bitzlato_admin;
GRANT REFERENCES ON TABLE public."user" TO meduza;
GRANT REFERENCES ON TABLE public."user" TO whaler;


--
-- Name: COLUMN "user".id; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(id) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".email_verified; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(email_verified) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".email_auth_enabled; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(email_auth_enabled) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".created_at; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(created_at) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".updated_at; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(updated_at) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".telegram_id; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(telegram_id) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".ref_parent_user_id; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(ref_parent_user_id) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".country; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(country) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".real_email; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(real_email) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user"."2fa_enabled"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT("2fa_enabled") ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".ref_type; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(ref_type) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".deleted_at; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(deleted_at) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: COLUMN "user".password_reset_at; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT(password_reset_at) ON TABLE public."user" TO bitzlato_analytics;


--
-- Name: TABLE withdrawal; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.withdrawal TO admin_manager;
GRANT SELECT ON TABLE public.withdrawal TO michael;
GRANT SELECT ON TABLE public.withdrawal TO igor;
GRANT SELECT ON TABLE public.withdrawal TO vladimir;
GRANT SELECT ON TABLE public.withdrawal TO bitzlato_reader;
GRANT ALL ON TABLE public.withdrawal TO bitzlato_admin;
GRANT SELECT ON TABLE public.withdrawal TO bitzlato_monitoring;
GRANT UPDATE ON TABLE public.withdrawal TO meduza;


--
-- Name: COLUMN withdrawal.status; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT UPDATE(status) ON TABLE public.withdrawal TO drey;


--
-- Name: TABLE vw_audit_source; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.vw_audit_source TO drey;
GRANT SELECT ON TABLE p2p.vw_audit_source TO bitzlato_reader;


--
-- Name: TABLE vw_audit_watchdog; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.vw_audit_watchdog TO drey;
GRANT SELECT ON TABLE p2p.vw_audit_watchdog TO bitzlato_reader;
GRANT SELECT ON TABLE p2p.vw_audit_watchdog TO bitzlato_monitoring;


--
-- Name: TABLE vw_disputes_list; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.vw_disputes_list TO drey;
GRANT SELECT ON TABLE p2p.vw_disputes_list TO bitzlato_reader;


--
-- Name: TABLE vw_inappropriate_ads; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.vw_inappropriate_ads TO drey;
GRANT SELECT ON TABLE p2p.vw_inappropriate_ads TO bitzlato_reader;


--
-- Name: TABLE vw_user_notification_alarm_mode; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.vw_user_notification_alarm_mode TO igor;
GRANT SELECT ON TABLE p2p.vw_user_notification_alarm_mode TO bitzlato_reader;


--
-- Name: TABLE vw_user_voucher; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.vw_user_voucher TO drey;
GRANT SELECT ON TABLE p2p.vw_user_voucher TO bitzlato_reader;


--
-- Name: TABLE wallet_log; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.wallet_log TO drey;
GRANT SELECT ON TABLE p2p.wallet_log TO bitzlato_reader;


--
-- Name: SEQUENCE wallet_log_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.wallet_log_id_seq TO bitzlato_admin;


--
-- Name: TABLE withdraw_voucher; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.withdraw_voucher TO admin_manager;
GRANT SELECT ON TABLE p2p.withdraw_voucher TO zeppelin;
GRANT SELECT ON TABLE p2p.withdraw_voucher TO michael;
GRANT SELECT ON TABLE p2p.withdraw_voucher TO igor;
GRANT SELECT ON TABLE p2p.withdraw_voucher TO vladimir;
GRANT ALL ON TABLE p2p.withdraw_voucher TO vanch;
GRANT SELECT ON TABLE p2p.withdraw_voucher TO bitzlato_reader;


--
-- Name: TABLE withdraw_voucher_prime_time; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT SELECT ON TABLE p2p.withdraw_voucher_prime_time TO michael;
GRANT SELECT ON TABLE p2p.withdraw_voucher_prime_time TO admin_manager;
GRANT SELECT ON TABLE p2p.withdraw_voucher_prime_time TO igor;
GRANT SELECT ON TABLE p2p.withdraw_voucher_prime_time TO vladimir;
GRANT ALL ON TABLE p2p.withdraw_voucher_prime_time TO vanch;
GRANT SELECT ON TABLE p2p.withdraw_voucher_prime_time TO zeppelin;
GRANT SELECT ON TABLE p2p.withdraw_voucher_prime_time TO bitzlato_reader;


--
-- Name: SEQUENCE withdraw_vouchers_id_seq; Type: ACL; Schema: p2p; Owner: bitzlato
--

GRANT ALL ON SEQUENCE p2p.withdraw_vouchers_id_seq TO bitzlato_admin;


--
-- Name: TABLE pg_aggregate; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_aggregate TO drey;


--
-- Name: TABLE pg_am; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_am TO drey;


--
-- Name: TABLE pg_amop; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_amop TO drey;


--
-- Name: TABLE pg_amproc; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_amproc TO drey;


--
-- Name: TABLE pg_attrdef; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_attrdef TO drey;


--
-- Name: TABLE pg_attribute; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_attribute TO drey;


--
-- Name: TABLE pg_auth_members; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_auth_members TO drey;


--
-- Name: TABLE pg_authid; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_authid TO drey;


--
-- Name: TABLE pg_available_extension_versions; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_available_extension_versions TO drey;


--
-- Name: TABLE pg_available_extensions; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_available_extensions TO drey;


--
-- Name: TABLE pg_cast; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_cast TO drey;


--
-- Name: TABLE pg_class; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_class TO drey;


--
-- Name: TABLE pg_collation; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_collation TO drey;


--
-- Name: TABLE pg_config; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_config TO drey;


--
-- Name: TABLE pg_constraint; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_constraint TO drey;


--
-- Name: TABLE pg_conversion; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_conversion TO drey;


--
-- Name: TABLE pg_cursors; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_cursors TO drey;


--
-- Name: TABLE pg_database; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_database TO drey;


--
-- Name: TABLE pg_db_role_setting; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_db_role_setting TO drey;


--
-- Name: TABLE pg_default_acl; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_default_acl TO drey;


--
-- Name: TABLE pg_depend; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_depend TO drey;


--
-- Name: TABLE pg_description; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_description TO drey;


--
-- Name: TABLE pg_enum; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_enum TO drey;


--
-- Name: TABLE pg_event_trigger; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_event_trigger TO drey;


--
-- Name: TABLE pg_extension; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_extension TO drey;


--
-- Name: TABLE pg_file_settings; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_file_settings TO drey;


--
-- Name: TABLE pg_foreign_data_wrapper; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_foreign_data_wrapper TO drey;


--
-- Name: TABLE pg_foreign_server; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_foreign_server TO drey;


--
-- Name: TABLE pg_foreign_table; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_foreign_table TO drey;


--
-- Name: TABLE pg_group; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_group TO drey;


--
-- Name: TABLE pg_hba_file_rules; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_hba_file_rules TO drey;


--
-- Name: TABLE pg_index; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_index TO drey;


--
-- Name: TABLE pg_indexes; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_indexes TO drey;


--
-- Name: TABLE pg_inherits; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_inherits TO drey;


--
-- Name: TABLE pg_init_privs; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_init_privs TO drey;


--
-- Name: TABLE pg_language; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_language TO drey;


--
-- Name: TABLE pg_largeobject; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_largeobject TO drey;


--
-- Name: TABLE pg_largeobject_metadata; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_largeobject_metadata TO drey;


--
-- Name: TABLE pg_locks; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_locks TO drey;


--
-- Name: TABLE pg_matviews; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_matviews TO drey;


--
-- Name: TABLE pg_namespace; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_namespace TO drey;


--
-- Name: TABLE pg_opclass; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_opclass TO drey;


--
-- Name: TABLE pg_operator; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_operator TO drey;


--
-- Name: TABLE pg_opfamily; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_opfamily TO drey;


--
-- Name: TABLE pg_partitioned_table; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_partitioned_table TO drey;


--
-- Name: TABLE pg_policies; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_policies TO drey;


--
-- Name: TABLE pg_policy; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_policy TO drey;


--
-- Name: TABLE pg_prepared_statements; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_prepared_statements TO drey;


--
-- Name: TABLE pg_prepared_xacts; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_prepared_xacts TO drey;


--
-- Name: TABLE pg_proc; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_proc TO drey;


--
-- Name: TABLE pg_publication; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_publication TO drey;


--
-- Name: TABLE pg_publication_rel; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_publication_rel TO drey;


--
-- Name: TABLE pg_publication_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_publication_tables TO drey;


--
-- Name: TABLE pg_range; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_range TO drey;


--
-- Name: TABLE pg_replication_origin; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_replication_origin TO drey;


--
-- Name: TABLE pg_replication_origin_status; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_replication_origin_status TO drey;


--
-- Name: TABLE pg_replication_slots; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_replication_slots TO drey;


--
-- Name: TABLE pg_rewrite; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_rewrite TO drey;


--
-- Name: TABLE pg_roles; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_roles TO drey;


--
-- Name: TABLE pg_rules; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_rules TO drey;


--
-- Name: TABLE pg_seclabel; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_seclabel TO drey;


--
-- Name: TABLE pg_seclabels; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_seclabels TO drey;


--
-- Name: TABLE pg_sequence; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_sequence TO drey;


--
-- Name: TABLE pg_sequences; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_sequences TO drey;


--
-- Name: TABLE pg_settings; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_settings TO drey;


--
-- Name: TABLE pg_shadow; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_shadow TO drey;


--
-- Name: TABLE pg_shdepend; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_shdepend TO drey;


--
-- Name: TABLE pg_shdescription; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_shdescription TO drey;


--
-- Name: TABLE pg_shseclabel; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_shseclabel TO drey;


--
-- Name: TABLE pg_stat_activity; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_activity TO drey;


--
-- Name: TABLE pg_stat_all_indexes; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_all_indexes TO drey;


--
-- Name: TABLE pg_stat_all_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_all_tables TO drey;


--
-- Name: TABLE pg_stat_archiver; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_archiver TO drey;


--
-- Name: TABLE pg_stat_bgwriter; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_bgwriter TO drey;


--
-- Name: TABLE pg_stat_database; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_database TO drey;


--
-- Name: TABLE pg_stat_database_conflicts; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_database_conflicts TO drey;


--
-- Name: TABLE pg_stat_progress_vacuum; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_progress_vacuum TO drey;


--
-- Name: TABLE pg_stat_replication; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_replication TO drey;


--
-- Name: TABLE pg_stat_ssl; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_ssl TO drey;


--
-- Name: TABLE pg_stat_subscription; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_subscription TO drey;


--
-- Name: TABLE pg_stat_sys_indexes; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_sys_indexes TO drey;


--
-- Name: TABLE pg_stat_sys_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_sys_tables TO drey;


--
-- Name: TABLE pg_stat_user_functions; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_user_functions TO drey;


--
-- Name: TABLE pg_stat_user_indexes; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_user_indexes TO drey;


--
-- Name: TABLE pg_stat_user_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_user_tables TO drey;


--
-- Name: TABLE pg_stat_wal_receiver; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_wal_receiver TO drey;


--
-- Name: TABLE pg_stat_xact_all_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_xact_all_tables TO drey;


--
-- Name: TABLE pg_stat_xact_sys_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_xact_sys_tables TO drey;


--
-- Name: TABLE pg_stat_xact_user_functions; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_xact_user_functions TO drey;


--
-- Name: TABLE pg_stat_xact_user_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_xact_user_tables TO drey;


--
-- Name: TABLE pg_statio_all_indexes; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_all_indexes TO drey;


--
-- Name: TABLE pg_statio_all_sequences; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_all_sequences TO drey;


--
-- Name: TABLE pg_statio_all_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_all_tables TO drey;


--
-- Name: TABLE pg_statio_sys_indexes; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_sys_indexes TO drey;


--
-- Name: TABLE pg_statio_sys_sequences; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_sys_sequences TO drey;


--
-- Name: TABLE pg_statio_sys_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_sys_tables TO drey;


--
-- Name: TABLE pg_statio_user_indexes; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_user_indexes TO drey;


--
-- Name: TABLE pg_statio_user_sequences; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_user_sequences TO drey;


--
-- Name: TABLE pg_statio_user_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_user_tables TO drey;


--
-- Name: TABLE pg_statistic; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statistic TO drey;


--
-- Name: TABLE pg_statistic_ext; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_statistic_ext TO drey;


--
-- Name: TABLE pg_stats; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stats TO drey;


--
-- Name: TABLE pg_subscription; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_subscription TO drey;


--
-- Name: TABLE pg_subscription_rel; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_subscription_rel TO drey;


--
-- Name: TABLE pg_tables; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_tables TO drey;


--
-- Name: TABLE pg_tablespace; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_tablespace TO drey;


--
-- Name: TABLE pg_timezone_abbrevs; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_timezone_abbrevs TO drey;


--
-- Name: TABLE pg_timezone_names; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_timezone_names TO drey;


--
-- Name: TABLE pg_transform; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_transform TO drey;


--
-- Name: TABLE pg_trigger; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_trigger TO drey;


--
-- Name: TABLE pg_ts_config; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_config TO drey;


--
-- Name: TABLE pg_ts_config_map; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_config_map TO drey;


--
-- Name: TABLE pg_ts_dict; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_dict TO drey;


--
-- Name: TABLE pg_ts_parser; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_parser TO drey;


--
-- Name: TABLE pg_ts_template; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_template TO drey;


--
-- Name: TABLE pg_type; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_type TO drey;


--
-- Name: TABLE pg_user; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_user TO drey;


--
-- Name: TABLE pg_user_mapping; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_user_mapping TO drey;


--
-- Name: TABLE pg_user_mappings; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_user_mappings TO drey;


--
-- Name: TABLE pg_views; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_views TO drey;


--
-- Name: TABLE pg_stat_activity; Type: ACL; Schema: postgres_exporter; Owner: postgres
--

GRANT SELECT ON TABLE postgres_exporter.pg_stat_activity TO bitzlato_reader;
GRANT ALL ON TABLE postgres_exporter.pg_stat_activity TO bitzlato_admin;


--
-- Name: TABLE pg_stat_replication; Type: ACL; Schema: postgres_exporter; Owner: postgres
--

GRANT SELECT ON TABLE postgres_exporter.pg_stat_replication TO bitzlato_reader;
GRANT ALL ON TABLE postgres_exporter.pg_stat_replication TO bitzlato_admin;


--
-- Name: TABLE account; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.account TO drey;
GRANT SELECT ON TABLE public.account TO bitzlato_reader;


--
-- Name: TABLE account_kyc_hist; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.account_kyc_hist TO drey;
GRANT SELECT ON TABLE public.account_kyc_hist TO bitzlato_reader;


--
-- Name: TABLE account_swap_log; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.account_swap_log TO admin_manager;
GRANT SELECT ON TABLE public.account_swap_log TO igor;
GRANT SELECT ON TABLE public.account_swap_log TO michael;
GRANT SELECT ON TABLE public.account_swap_log TO vladimir;
GRANT SELECT ON TABLE public.account_swap_log TO bitzlato_reader;
GRANT ALL ON TABLE public.account_swap_log TO bitzlato_admin;


--
-- Name: SEQUENCE account_swap_log_id_seq; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON SEQUENCE public.account_swap_log_id_seq TO bitzlato_admin;


--
-- Name: TABLE admin_user; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.admin_user TO admin_manager;
GRANT SELECT ON TABLE public.admin_user TO michael;
GRANT SELECT ON TABLE public.admin_user TO igor;
GRANT SELECT ON TABLE public.admin_user TO vladimir;
GRANT SELECT ON TABLE public.admin_user TO bitzlato_reader;
GRANT ALL ON TABLE public.admin_user TO bitzlato_admin;


--
-- Name: TABLE "backup$wallet_log_unknown_users"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."backup$wallet_log_unknown_users" TO admin_manager;
GRANT SELECT ON TABLE public."backup$wallet_log_unknown_users" TO drey;
GRANT SELECT ON TABLE public."backup$wallet_log_unknown_users" TO maelstromm;
GRANT SELECT ON TABLE public."backup$wallet_log_unknown_users" TO michael;
GRANT SELECT ON TABLE public."backup$wallet_log_unknown_users" TO igor;
GRANT SELECT ON TABLE public."backup$wallet_log_unknown_users" TO vladimir;
GRANT SELECT ON TABLE public."backup$wallet_log_unknown_users" TO bitzlato_reader;


--
-- Name: TABLE "backup$wallet_unknown_users"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."backup$wallet_unknown_users" TO drey;
GRANT SELECT ON TABLE public."backup$wallet_unknown_users" TO bitzlato_reader;


--
-- Name: TABLE banned_user; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.banned_user TO admin_manager;
GRANT SELECT ON TABLE public.banned_user TO michael;
GRANT SELECT ON TABLE public.banned_user TO igor;
GRANT SELECT ON TABLE public.banned_user TO vladimir;
GRANT SELECT ON TABLE public.banned_user TO bitzlato_reader;
GRANT ALL ON TABLE public.banned_user TO bitzlato_admin;
GRANT SELECT ON TABLE public.banned_user TO bitzlato_analytics;


--
-- Name: SEQUENCE blockchain_tx_id_seq; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON SEQUENCE public.blockchain_tx_id_seq TO bitzlato_admin;


--
-- Name: TABLE event; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.event TO admin_manager;
GRANT SELECT ON TABLE public.event TO igor;
GRANT SELECT ON TABLE public.event TO michael;
GRANT SELECT ON TABLE public.event TO vladimir;
GRANT SELECT ON TABLE public.event TO bitzlato_reader;
GRANT ALL ON TABLE public.event TO bitzlato_admin;


--
-- Name: SEQUENCE event_id_seq; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON SEQUENCE public.event_id_seq TO bitzlato_admin;


--
-- Name: TABLE flyway_schema_history; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.flyway_schema_history TO admin_manager;
GRANT SELECT ON TABLE public.flyway_schema_history TO michael;
GRANT SELECT ON TABLE public.flyway_schema_history TO igor;
GRANT SELECT ON TABLE public.flyway_schema_history TO vladimir;
GRANT SELECT ON TABLE public.flyway_schema_history TO bitzlato_reader;
GRANT ALL ON TABLE public.flyway_schema_history TO bitzlato_admin;


--
-- Name: TABLE lock_monitor; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.lock_monitor TO admin_manager;
GRANT SELECT ON TABLE public.lock_monitor TO michael;
GRANT ALL ON TABLE public.lock_monitor TO bitzlato;
GRANT SELECT ON TABLE public.lock_monitor TO igor;
GRANT SELECT ON TABLE public.lock_monitor TO vladimir;
GRANT SELECT ON TABLE public.lock_monitor TO bitzlato_reader;
GRANT ALL ON TABLE public.lock_monitor TO bitzlato_admin;


--
-- Name: TABLE withdrawal_log; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.withdrawal_log TO admin_manager;
GRANT SELECT ON TABLE public.withdrawal_log TO michael;
GRANT SELECT ON TABLE public.withdrawal_log TO igor;
GRANT SELECT ON TABLE public.withdrawal_log TO vladimir;
GRANT SELECT ON TABLE public.withdrawal_log TO bitzlato_reader;
GRANT ALL ON TABLE public.withdrawal_log TO bitzlato_admin;


--
-- Name: SEQUENCE payment_logs_id_seq; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON SEQUENCE public.payment_logs_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE payments_id_seq; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON SEQUENCE public.payments_id_seq TO bitzlato_admin;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: public; Owner: postgres
--

REVOKE SELECT ON TABLE public.pg_stat_statements FROM "19764";
REVOKE SELECT ON TABLE public.pg_stat_statements FROM drey;
REVOKE SELECT ON TABLE public.pg_stat_statements FROM maelstromm;
GRANT ALL ON TABLE public.pg_stat_statements TO bitzlato;
GRANT SELECT ON TABLE public.pg_stat_statements TO igor;
GRANT SELECT ON TABLE public.pg_stat_statements TO vladimir;
GRANT SELECT ON TABLE public.pg_stat_statements TO bitzlato_reader;
GRANT ALL ON TABLE public.pg_stat_statements TO bitzlato_admin;


--
-- Name: TABLE signed_operation_request; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.signed_operation_request TO igor;
GRANT SELECT ON TABLE public.signed_operation_request TO bitzlato_reader;
GRANT ALL ON TABLE public.signed_operation_request TO bitzlato_admin;


--
-- Name: TABLE "signed_operation_request$20220131"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220131" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220131" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220201"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220201" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220201" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220202"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220202" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220202" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220203"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220203" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220203" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220204"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220204" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220204" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220205"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220205" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220205" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220206"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220206" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220206" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220207"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220207" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220207" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220208"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220208" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220208" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220209"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220209" TO drey;
GRANT SELECT ON TABLE public."signed_operation_request$20220209" TO bitzlato_reader;


--
-- Name: TABLE "signed_operation_request$20220210"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220210" TO drey;


--
-- Name: TABLE "signed_operation_request$20220211"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220211" TO drey;


--
-- Name: TABLE "signed_operation_request$20220212"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220212" TO drey;


--
-- Name: TABLE "signed_operation_request$20220213"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220213" TO drey;


--
-- Name: TABLE "signed_operation_request$20220214"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220214" TO drey;


--
-- Name: TABLE "signed_operation_request$20220215"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220215" TO drey;


--
-- Name: TABLE "signed_operation_request$20220216"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220216" TO drey;


--
-- Name: TABLE "signed_operation_request$20220217"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220217" TO drey;


--
-- Name: TABLE "signed_operation_request$20220218"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220218" TO drey;


--
-- Name: TABLE "signed_operation_request$20220219"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220219" TO drey;


--
-- Name: TABLE "signed_operation_request$20220220"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220220" TO drey;


--
-- Name: TABLE "signed_operation_request$20220221"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220221" TO drey;


--
-- Name: TABLE "signed_operation_request$20220222"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220222" TO drey;


--
-- Name: TABLE "signed_operation_request$20220223"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220223" TO drey;


--
-- Name: TABLE "signed_operation_request$20220224"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220224" TO drey;


--
-- Name: TABLE "signed_operation_request$20220225"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220225" TO drey;


--
-- Name: TABLE "signed_operation_request$20220226"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220226" TO drey;


--
-- Name: TABLE "signed_operation_request$20220227"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220227" TO drey;


--
-- Name: TABLE "signed_operation_request$20220228"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220228" TO drey;


--
-- Name: TABLE "signed_operation_request$20220301"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220301" TO drey;


--
-- Name: TABLE "signed_operation_request$20220302"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220302" TO drey;


--
-- Name: TABLE "signed_operation_request$20220303"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220303" TO drey;


--
-- Name: TABLE "signed_operation_request$20220304"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220304" TO drey;


--
-- Name: TABLE "signed_operation_request$20220305"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."signed_operation_request$20220305" TO drey;


--
-- Name: SEQUENCE signed_operation_request_id_seq; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON SEQUENCE public.signed_operation_request_id_seq TO bitzlato_admin;


--
-- Name: SEQUENCE transactions_id_seq; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON SEQUENCE public.transactions_id_seq TO bitzlato_admin;


--
-- Name: TABLE user_auth_pub_key; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.user_auth_pub_key TO michael;
GRANT SELECT ON TABLE public.user_auth_pub_key TO admin_manager;
GRANT SELECT ON TABLE public.user_auth_pub_key TO igor;
GRANT SELECT ON TABLE public.user_auth_pub_key TO vladimir;
GRANT SELECT ON TABLE public.user_auth_pub_key TO bitzlato_reader;
GRANT ALL ON TABLE public.user_auth_pub_key TO bitzlato_admin;


--
-- Name: TABLE user_token_mfa; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.user_token_mfa TO michael;
GRANT SELECT ON TABLE public.user_token_mfa TO admin_manager;
GRANT SELECT ON TABLE public.user_token_mfa TO igor;
GRANT SELECT ON TABLE public.user_token_mfa TO vladimir;
GRANT SELECT ON TABLE public.user_token_mfa TO bitzlato_reader;
GRANT ALL ON TABLE public.user_token_mfa TO bitzlato_admin;


--
-- Name: TABLE "user_token_mfa$20220227"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."user_token_mfa$20220227" TO drey;


--
-- Name: TABLE "user_token_mfa$20220228"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."user_token_mfa$20220228" TO drey;


--
-- Name: TABLE "user_token_mfa$20220301"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."user_token_mfa$20220301" TO drey;


--
-- Name: TABLE "user_token_mfa$20220302"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."user_token_mfa$20220302" TO drey;


--
-- Name: TABLE "user_token_mfa$20220303"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."user_token_mfa$20220303" TO drey;


--
-- Name: TABLE "user_token_mfa$20220304"; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public."user_token_mfa$20220304" TO drey;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON SEQUENCE public.users_id_seq TO bitzlato_admin;


--
-- Name: TABLE vw_admin; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.vw_admin TO drey;
GRANT SELECT ON TABLE public.vw_admin TO bitzlato_reader;


--
-- Name: TABLE wallet_address; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.wallet_address TO drey;
GRANT SELECT ON TABLE public.wallet_address TO bitzlato_reader;


--
-- Name: TABLE wallet_address_hist; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT SELECT ON TABLE public.wallet_address_hist TO bitzlato_reader;
GRANT ALL ON TABLE public.wallet_address_hist TO bitzlato_admin;
GRANT SELECT ON TABLE public.wallet_address_hist TO igor;


--
-- Name: SEQUENCE wallets_id_seq; Type: ACL; Schema: public; Owner: bitzlato
--

GRANT ALL ON SEQUENCE public.wallets_id_seq TO bitzlato_admin;


--
-- Name: TABLE ar_internal_metadata; Type: ACL; Schema: whaler; Owner: whaler
--

GRANT SELECT ON TABLE whaler.ar_internal_metadata TO bitzlato_reader;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: whaler; Owner: whaler
--

GRANT SELECT ON TABLE whaler.schema_migrations TO bitzlato_reader;


--
-- Name: TABLE transfers; Type: ACL; Schema: whaler; Owner: whaler
--

GRANT SELECT ON TABLE whaler.transfers TO bitzlato_reader;


--
-- Name: TABLE wallet_transfers; Type: ACL; Schema: whaler; Owner: whaler
--

GRANT SELECT ON TABLE whaler.wallet_transfers TO bitzlato_reader;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: mer; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA mer REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA mer GRANT SELECT ON TABLES  TO backadm;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA mer GRANT SELECT ON TABLES  TO drey;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA mer GRANT SELECT ON TABLES  TO maelstromm;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA mer GRANT SELECT ON TABLES  TO zeppelin;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA mer GRANT SELECT ON TABLES  TO michael;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA mer GRANT SELECT ON TABLES  TO bitzlato_reader;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: p2p; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA p2p REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA p2p GRANT SELECT ON TABLES  TO admin_manager;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA p2p GRANT SELECT ON TABLES  TO drey;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA p2p GRANT SELECT ON TABLES  TO maelstromm;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA p2p GRANT SELECT ON TABLES  TO michael;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA p2p GRANT SELECT ON TABLES  TO igor;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA p2p GRANT SELECT ON TABLES  TO vladimir;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA p2p GRANT SELECT ON TABLES  TO bitzlato_reader;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: p2p; Owner: bitzlato
--

ALTER DEFAULT PRIVILEGES FOR ROLE bitzlato IN SCHEMA p2p REVOKE ALL ON TABLES  FROM bitzlato;
ALTER DEFAULT PRIVILEGES FOR ROLE bitzlato IN SCHEMA p2p GRANT SELECT ON TABLES  TO drey;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO admin_manager;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO drey;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO maelstromm;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO michael;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO igor;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO vladimir;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO bitzlato_reader;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: bitzlato
--

ALTER DEFAULT PRIVILEGES FOR ROLE bitzlato IN SCHEMA public REVOKE ALL ON TABLES  FROM bitzlato;
ALTER DEFAULT PRIVILEGES FOR ROLE bitzlato IN SCHEMA public GRANT SELECT ON TABLES  TO drey;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: rep; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA rep REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA rep GRANT SELECT ON TABLES  TO igor;


--
-- PostgreSQL database dump complete
--

