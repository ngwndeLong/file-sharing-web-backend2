--
-- PostgreSQL database dump
--

\restrict qoGFfKoHl9IB59A2n3p7KTf48M3aui2JF0t21hdwrwNeE1LdhIn7UygVHLWnjjE

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: download; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.download (
    download_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "time" timestamp with time zone DEFAULT now(),
    user_id uuid NOT NULL,
    file_id uuid NOT NULL
);


ALTER TABLE public.download OWNER TO postgres;

--
-- Name: files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.files (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    password text,
    type text,
    size bigint,
    created_at timestamp with time zone DEFAULT now(),
    available_from timestamp with time zone,
    available_to timestamp with time zone,
    enable_totp boolean DEFAULT false,
    share_token text,
    CONSTRAINT files_password_check CHECK ((length(password) >= 6))
);


ALTER TABLE public.files OWNER TO postgres;

--
-- Name: shared; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shared (
    user_id uuid NOT NULL,
    file_id uuid NOT NULL
);


ALTER TABLE public.shared OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    mail text NOT NULL,
    role text NOT NULL,
    CONSTRAINT users_password_check CHECK ((length(password) >= 6))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: download; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.download (download_id, "time", user_id, file_id) FROM stdin;
\.


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.files (id, user_id, name, password, type, size, created_at, available_from, available_to, enable_totp, share_token) FROM stdin;
\.


--
-- Data for Name: shared; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shared (user_id, file_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, mail, role) FROM stdin;
\.


--
-- Name: download download_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.download
    ADD CONSTRAINT download_pkey PRIMARY KEY (download_id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: shared shared_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shared
    ADD CONSTRAINT shared_pkey PRIMARY KEY (user_id, file_id);


--
-- Name: users users_mail_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_mail_key UNIQUE (mail);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: download download_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.download
    ADD CONSTRAINT download_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: download download_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.download
    ADD CONSTRAINT download_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: files files_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: shared shared_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shared
    ADD CONSTRAINT shared_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: shared shared_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shared
    ADD CONSTRAINT shared_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict qoGFfKoHl9IB59A2n3p7KTf48M3aui2JF0t21hdwrwNeE1LdhIn7UygVHLWnjjE

