--
-- PostgreSQL database dump
--

\restrict tUkwPfSRNAhWG2vGU0wjYuWrYtF7Ysq4bw2Ks97rvY2Lwmkf5sCbtuAiuO31ZCQ

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-11-17 19:58:12

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 16610)
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    id integer NOT NULL,
    user_id integer,
    action character varying(50) NOT NULL,
    description text,
    ip_address character varying(45) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16609)
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activity_logs_id_seq OWNER TO postgres;

--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 225
-- Name: activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_logs_id_seq OWNED BY public.activity_logs.id;


--
-- TOC entry 222 (class 1259 OID 16561)
-- Name: laporan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laporan (
    id integer NOT NULL,
    user_id integer NOT NULL,
    judul character varying(150) NOT NULL,
    lokasi character varying(255) NOT NULL,
    deskripsi text NOT NULL,
    status character varying(20) DEFAULT 'reported'::character varying NOT NULL,
    tanggal_aksi date,
    kuota integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    permintaan_volunteer character varying(10) DEFAULT 'tidak'::character varying CONSTRAINT laporan_permintaan_gotong_royong_not_null NOT NULL,
    deskripsi_volunteer text,
    deleted_at timestamp without time zone,
    gambar character varying(40),
    CONSTRAINT laporan_gambar_check CHECK (((gambar IS NULL) OR ((gambar)::text ~ '^[a-f0-9]{32}\.(jpg|png)$'::text))),
    CONSTRAINT laporan_kuota_check CHECK (((kuota IS NULL) OR (kuota > 0))),
    CONSTRAINT laporan_permintaan_volunteer_check CHECK (((permintaan_volunteer)::text = ANY ((ARRAY['tidak'::character varying, 'menunggu'::character varying, 'disetujui'::character varying, 'ditolak'::character varying])::text[]))),
    CONSTRAINT laporan_status_check CHECK (((status)::text = ANY ((ARRAY['reported'::character varying, 'gotong_royong'::character varying, 'done'::character varying])::text[])))
);


ALTER TABLE public.laporan OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16560)
-- Name: laporan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.laporan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.laporan_id_seq OWNER TO postgres;

--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 221
-- Name: laporan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.laporan_id_seq OWNED BY public.laporan.id;


--
-- TOC entry 224 (class 1259 OID 16586)
-- Name: laporan_participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laporan_participants (
    id integer NOT NULL,
    laporan_id integer NOT NULL,
    user_id integer NOT NULL,
    joined_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.laporan_participants OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16585)
-- Name: laporan_participants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.laporan_participants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.laporan_participants_id_seq OWNER TO postgres;

--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 223
-- Name: laporan_participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.laporan_participants_id_seq OWNED BY public.laporan_participants.id;


--
-- TOC entry 220 (class 1259 OID 16544)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(10) DEFAULT 'user'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    username character varying(30) NOT NULL,
    email character varying(254) NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'user'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16543)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4880 (class 2604 OID 16613)
-- Name: activity_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs ALTER COLUMN id SET DEFAULT nextval('public.activity_logs_id_seq'::regclass);


--
-- TOC entry 4874 (class 2604 OID 16564)
-- Name: laporan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan ALTER COLUMN id SET DEFAULT nextval('public.laporan_id_seq'::regclass);


--
-- TOC entry 4878 (class 2604 OID 16589)
-- Name: laporan_participants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan_participants ALTER COLUMN id SET DEFAULT nextval('public.laporan_participants_id_seq'::regclass);


--
-- TOC entry 4871 (class 2604 OID 16547)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5058 (class 0 OID 16610)
-- Dependencies: 226
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_logs (id, user_id, action, description, ip_address, created_at) FROM stdin;
1	1	REGISTER_SUCCESS	Akun baru dibuat	::1	2026-11-17 04:11:23.680675
2	3	REGISTER_SUCCESS	Akun baru dibuat	::1	2026-11-17 04:11:38.310838
3	1	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 04:29:51.693576
4	1	LOGIN_FAILED	Login gagal	::1	2026-11-17 04:32:50.455015
5	1	LOGIN_FAILED	Login gagal	::1	2026-11-17 04:32:54.729015
6	1	LOGIN_FAILED	Login gagal	::1	2026-11-17 04:32:58.951602
7	1	LOGIN_FAILED	Login gagal	::1	2026-11-17 04:33:02.141638
8	1	LOGIN_FAILED	Login gagal	::1	2026-11-17 04:33:06.283301
9	\N	LOGIN_BLOCKED	Percobaan login saat IP diblokir	::1	2026-11-17 04:33:10.291143
10	\N	IP_UNBLOCKED	uji manual	127.0.0.1	2026-11-17 04:35:31.50737
11	\N	REGISTER_FAILED	Registrasi gagal	::1	2026-11-17 04:48:20.807519
12	\N	REGISTER_FAILED	Registrasi gagal	::1	2026-11-17 04:48:34.701273
13	\N	REGISTER_FAILED	Registrasi gagal	::1	2026-11-17 04:48:43.545117
14	\N	REGISTER_BLOCKED	Registrasi saat IP dibatasi	::1	2026-11-17 04:48:55.091433
15	\N	IP_UNBLOCKED	uji registrasi	127.0.0.1	2026-11-17 04:50:57.939377
16	3	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 05:00:52.836327
17	3	ACCESS_DENIED	Akses ditolak ke test_admin.php	::1	2026-11-17 05:01:22.612026
18	3	LOGOUT	Logout	::1	2026-11-17 05:01:29.620389
19	1	LOGIN_FAILED	Login gagal	::1	2026-11-17 05:01:34.394617
20	1	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 05:01:42.059003
21	1	LOGOUT	Logout	::1	2026-11-17 05:06:40.969086
22	3	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 05:07:02.169437
23	3	LAPORAN_CREATED	Laporan #1 dibuat	::1	2026-11-17 05:08:12.1145
24	3	SESSION_TIMEOUT	Sesi berakhir karena tidak aktif	::1	2026-11-17 05:28:39.806025
25	3	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 05:28:52.303081
26	3	LAPORAN_CREATED	Laporan #2 dibuat	::1	2026-11-17 05:29:16.715332
27	3	GOTONG_ROYONG_REQUESTED	Laporan #2 mengajukan gotong royong	::1	2026-11-17 05:29:16.716504
28	3	LAPORAN_CREATED	Laporan #3 dibuat	::1	2026-11-17 05:29:30.191163
29	3	LAPORAN_CREATED	Laporan #4 dibuat	::1	2026-11-17 05:37:08.307311
30	3	GOTONG_ROYONG_REQUESTED	Laporan #4 mengajukan gotong royong	::1	2026-11-17 05:37:08.308245
31	3	LAPORAN_CREATED	Laporan #5 dibuat	::1	2026-11-17 05:38:52.762346
32	3	SESSION_TIMEOUT	Sesi berakhir karena tidak aktif	::1	2026-11-17 12:21:31.055852
33	3	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 12:21:40.844893
34	3	LAPORAN_CREATED	Laporan #6 dibuat	::1	2026-11-17 12:22:00.066302
35	3	LAPORAN_CREATED	Laporan #7 dibuat	::1	2026-11-17 12:23:01.054888
36	3	VOLUNTEER_REQUESTED	Laporan #7 mengajukan volunteer	::1	2026-11-17 12:23:01.057533
37	1	LOGIN_FAILED	Login gagal	::1	2026-11-17 15:24:04.900048
38	3	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 15:24:13.281687
39	3	LAPORAN_CREATED	Laporan #8 dibuat	::1	2026-11-17 15:27:01.755309
40	3	VOLUNTEER_REQUESTED	Laporan #8 mengajukan volunteer	::1	2026-11-17 15:27:01.756519
41	\N	REGISTER_FAILED	Registrasi gagal	::1	2026-11-17 15:38:51.47678
42	6	REGISTER_SUCCESS	Akun baru dibuat	::1	2026-11-17 15:39:13.276353
43	6	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 15:39:20.483687
44	3	LOGOUT	Logout	::1	2026-11-17 15:40:54.011024
45	3	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 15:45:05.964816
46	3	VOLUNTEER_JOINED	Mendaftar di laporan #7	::1	2026-11-17 15:45:51.895948
47	6	VOLUNTEER_JOIN_REJECTED	Laporan #7: Kuota sudah penuh.	::1	2026-11-17 15:45:59.004576
48	3	LOGOUT	Logout	::1	2026-11-17 15:59:52.551663
49	1	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 15:59:55.680789
50	6	ACCESS_DENIED	Akses ditolak ke admin.php	::1	2026-11-17 16:00:34.397899
51	1	VOLUNTEER_APPROVED	Laporan #8	::1	2026-11-17 16:04:31.867648
52	6	LOGOUT	Logout	::1	2026-11-17 16:09:27.991662
53	6	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 16:09:35.645936
54	3	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 16:10:08.762067
55	3	LAPORAN_CREATED	Laporan #1 dibuat	::1	2026-11-17 16:11:33.634192
56	6	LAPORAN_CREATED	Laporan #2 dibuat	::1	2026-11-17 16:12:35.92781
57	6	LAPORAN_CREATED	Laporan #3 dibuat	::1	2026-11-17 16:16:50.104825
58	6	VOLUNTEER_REQUESTED	Laporan #3 mengajukan volunteer	::1	2026-11-17 16:16:50.105765
59	1	VOLUNTEER_APPROVED	Laporan #3	::1	2026-11-17 16:19:21.476599
60	6	VOLUNTEER_JOINED	Mendaftar di laporan #3	::1	2026-11-17 16:19:33.824863
61	1	LAPORAN_DONE	Laporan #3	::1	2026-11-17 16:20:32.284843
62	1	SESSION_TIMEOUT	Sesi berakhir karena tidak aktif	::1	2026-11-17 16:45:30.552267
63	3	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 16:45:32.728061
64	3	ACCESS_DENIED	Akses ditolak ke admin.php	::1	2026-11-17 16:45:47.437084
65	3	ACCESS_DENIED	Akses ditolak ke admin.php	::1	2026-11-17 16:45:48.574061
66	3	LOGOUT	Logout	::1	2026-11-17 16:45:50.816526
67	1	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 16:45:55.095475
68	1	SESSION_TIMEOUT	Sesi berakhir karena tidak aktif	::1	2026-11-17 17:38:14.291483
69	1	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 17:38:35.146863
70	\N	REGISTER_FAILED	Registrasi gagal	::1	2026-11-17 18:09:33.288625
71	3	LOGIN_FAILED	Login gagal	::1	2026-11-17 18:10:21.784826
72	3	LOGIN_FAILED	Login gagal	::1	2026-11-17 18:10:24.66726
73	\N	LOGIN_FAILED	Login gagal	::1	2026-11-17 18:10:34.605779
74	\N	LOGIN_FAILED	Login gagal	::1	2026-11-17 18:10:38.249332
75	\N	LOGIN_FAILED	Login gagal	::1	2026-11-17 18:10:45.835607
76	\N	LOGIN_BLOCKED	Percobaan login saat IP diblokir	::1	2026-11-17 18:10:51.277668
77	1	LOGOUT	Logout	::1	2026-11-17 18:11:17.210899
78	\N	LOGIN_BLOCKED	Percobaan login saat IP diblokir	::1	2026-11-17 18:11:22.957464
79	\N	LOGIN_BLOCKED	Percobaan login saat IP diblokir	::1	2026-11-17 18:11:26.006025
80	1	LOGIN_SUCCESS	Login berhasil	192.168.1.4	2026-11-17 18:16:20.959458
81	3	LOGIN_SUCCESS	Login berhasil	127.0.0.1	2026-11-17 18:17:51.996055
82	1	LOGIN_SUCCESS	Login berhasil	127.0.0.1	2026-11-17 18:57:04.203198
83	1	LOGOUT	Logout	127.0.0.1	2026-11-17 19:09:28.764796
84	6	LOGIN_SUCCESS	Login berhasil	127.0.0.1	2026-11-17 19:09:32.898131
85	1	LOGIN_SUCCESS	Login berhasil	127.0.0.1	2026-11-17 19:11:22.20706
86	6	LAPORAN_CREATED	Laporan #11 dibuat	::1	2026-11-17 19:40:58.826514
87	6	LAPORAN_CREATED	Laporan #12 dibuat (dengan gambar)	::1	2026-11-17 19:41:46.300215
88	6	GOTONG_ROYONG_REQUESTED	Laporan #12 mengajukan gotong royong	::1	2026-11-17 19:41:46.30161
89	6	LOGOUT	Logout	::1	2026-11-17 19:46:03.969504
90	1	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 19:46:07.017317
91	1	LOGOUT	Logout	::1	2026-11-17 19:56:00.895151
92	3	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 19:56:03.442934
93	3	LOGOUT	Logout	::1	2026-11-17 19:56:51.595075
94	6	LOGIN_SUCCESS	Login berhasil	::1	2026-11-17 19:56:54.950585
\.


--
-- TOC entry 5054 (class 0 OID 16561)
-- Dependencies: 222
-- Data for Name: laporan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laporan (id, user_id, judul, lokasi, deskripsi, status, tanggal_aksi, kuota, created_at, permintaan_volunteer, deskripsi_volunteer, deleted_at, gambar) FROM stdin;
1	3	Tumpukan Sampah Sampai Jalanan	Jl. Petojo Barat XI No.5, RT.12/RW.1, Duri Pulo, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10140	Ini ada banyak sekali sampah sampai jalanan, ganggu banget	reported	\N	\N	2026-11-17 16:11:33.631893	tidak	\N	\N	\N
2	6	Banyak Sampah Dekat UBM Ancol	Jl. Lodan Raya No. 2, Ancol, Kecamatan Pademangan, Jakarta Utara 14430, Indonesia. • Nomor Tel	Sampah menggunung hingga menyebabkan kemacetan	reported	\N	\N	2026-11-17 16:12:35.926401	tidak	\N	\N	\N
3	6	Sampah Plastik di Kali Ciliwung	Pintu Air Manggarai	Tumpukan sampah plastik terlihat mengambang di kali ciliwung, bisa menyebabkan banjir	done	2026-11-26	500	2026-11-17 16:16:50.10267	disetujui	- Saya terinspirasi Pandawara dan ingin mengajak relawan masyarakat , gotong royong memebrsihkan kali ciliwung\r\n\r\n- Kumpul di Pintu Air Manggarai\r\n\r\n- Bawa sepatu boots, baju celana ganti, dan peralatan kebersihan	\N	\N
11	6	addddddddddddddddd	ddaaaaaaaaaaaaaaa	aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa	reported	\N	\N	2026-11-17 19:40:58.82403	tidak	\N	\N	\N
12	6	Tes gambarrr	Gambar Mobil	ini gambar mobil	reported	2026-11-26	123	2026-11-17 19:41:46.298184	menunggu	tesssssssssssssss	\N	b8479737a5c646a5100ba80d71f7e09b.png
\.


--
-- TOC entry 5056 (class 0 OID 16586)
-- Dependencies: 224
-- Data for Name: laporan_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laporan_participants (id, laporan_id, user_id, joined_at) FROM stdin;
1	3	6	2026-11-17 16:19:33.820386
\.


--
-- TOC entry 5052 (class 0 OID 16544)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, password, role, created_at, username, email) FROM stdin;
1	$2y$10$0cfyNgvo0C/trHiMI6Elv.zELYls.jzpwCWCaR7ioGqTuVioXeboW	admin	2026-11-17 04:11:23.678651	Jos1	tes@gmail.com
3	$2y$10$qP3tSSMk4JLz.0xhwHNqHOQxEXusfiah41/OqipsDILymIereNCiS	user	2026-11-17 04:11:38.309549	tes1	tes1@gmail.com
6	$2y$10$i2V9TDgqLQB2WnHzTGZw0ejAeH4Y1RYmmBCcJo7hJN0Fl6UwthOOC	user	2026-11-17 15:39:13.2747	tes2	tes2@gmail.com
\.


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 225
-- Name: activity_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_logs_id_seq', 94, true);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 221
-- Name: laporan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.laporan_id_seq', 12, true);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 223
-- Name: laporan_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.laporan_participants_id_seq', 1, true);


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- TOC entry 4898 (class 2606 OID 16622)
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4894 (class 2606 OID 16598)
-- Name: laporan_participants laporan_participants_laporan_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan_participants
    ADD CONSTRAINT laporan_participants_laporan_id_user_id_key UNIQUE (laporan_id, user_id);


--
-- TOC entry 4896 (class 2606 OID 16596)
-- Name: laporan_participants laporan_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan_participants
    ADD CONSTRAINT laporan_participants_pkey PRIMARY KEY (id);


--
-- TOC entry 4892 (class 2606 OID 16579)
-- Name: laporan laporan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan
    ADD CONSTRAINT laporan_pkey PRIMARY KEY (id);


--
-- TOC entry 4888 (class 2606 OID 16652)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4890 (class 2606 OID 16557)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4899 (class 1259 OID 16628)
-- Name: idx_log_rate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_log_rate ON public.activity_logs USING btree (action, ip_address, created_at);


--
-- TOC entry 4903 (class 2606 OID 16623)
-- Name: activity_logs activity_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4901 (class 2606 OID 16599)
-- Name: laporan_participants laporan_participants_laporan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan_participants
    ADD CONSTRAINT laporan_participants_laporan_id_fkey FOREIGN KEY (laporan_id) REFERENCES public.laporan(id);


--
-- TOC entry 4902 (class 2606 OID 16604)
-- Name: laporan_participants laporan_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan_participants
    ADD CONSTRAINT laporan_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4900 (class 2606 OID 16580)
-- Name: laporan laporan_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan
    ADD CONSTRAINT laporan_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO app_pedulilingkungan;


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE activity_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.activity_logs TO app_pedulilingkungan;


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE activity_logs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.activity_logs_id_seq TO app_pedulilingkungan;


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE laporan; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.laporan TO app_pedulilingkungan;


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 221
-- Name: SEQUENCE laporan_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.laporan_id_seq TO app_pedulilingkungan;


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE laporan_participants; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.laporan_participants TO app_pedulilingkungan;


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE laporan_participants_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.laporan_participants_id_seq TO app_pedulilingkungan;


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.users TO app_pedulilingkungan;


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.users_id_seq TO app_pedulilingkungan;


-- Completed on 2026-11-17 19:58:12

--
-- PostgreSQL database dump complete
--

\unrestrict tUkwPfSRNAhWG2vGU0wjYuWrYtF7Ysq4bw2Ks97rvY2Lwmkf5sCbtuAiuO31ZCQ

