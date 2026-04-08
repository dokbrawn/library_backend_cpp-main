--
-- PostgreSQL database dump
--

\restrict zDvd49gjR1CBd9ltnkMU6bTZsYbmYrnE8Jek1nHoH47bErwKuhdS0UvQ38Zvfje

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    id integer NOT NULL,
    subgenre_id integer,
    title text NOT NULL,
    author text NOT NULL,
    publisher text,
    year integer DEFAULT 0 NOT NULL,
    format text,
    rating real DEFAULT 0 NOT NULL,
    price real DEFAULT 0 NOT NULL,
    age_rating text,
    isbn text,
    total_print_run bigint DEFAULT 0 NOT NULL,
    signed_to_print_date text,
    additional_print_dates text,
    cover_image_path text,
    license_image_path text,
    bibliographic_reference text,
    cover_url text,
    search_frequency real DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    total_circulation bigint DEFAULT 0,
    print_sign_date text DEFAULT ''::text,
    additional_prints text DEFAULT '[]'::text,
    bibliographic_ref text DEFAULT ''::text,
    CONSTRAINT books_age_rating_check CHECK (((age_rating = ANY (ARRAY['0+'::text, '6+'::text, '12+'::text, '16+'::text, '18+'::text])) OR (age_rating = ''::text)))
);


ALTER TABLE public.books OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_id_seq OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genres (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.genres OWNER TO postgres;

--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.genres_id_seq OWNER TO postgres;

--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genres_id_seq OWNED BY public.genres.id;


--
-- Name: subgenres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subgenres (
    id integer NOT NULL,
    genre_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.subgenres OWNER TO postgres;

--
-- Name: subgenres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subgenres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subgenres_id_seq OWNER TO postgres;

--
-- Name: subgenres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subgenres_id_seq OWNED BY public.subgenres.id;


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: genres id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);


--
-- Name: subgenres id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subgenres ALTER COLUMN id SET DEFAULT nextval('public.subgenres_id_seq'::regclass);


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (id, subgenre_id, title, author, publisher, year, format, rating, price, age_rating, isbn, total_print_run, signed_to_print_date, additional_print_dates, cover_image_path, license_image_path, bibliographic_reference, cover_url, search_frequency, created_at, total_circulation, print_sign_date, additional_prints, bibliographic_ref) FROM stdin;
52	28	Преступление и наказание	Фёдор Михайлович Достоевский	Русский вестник	1866	Электронная книга	4.9	399	16+	9785352021781	0	\N	\N	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTou7htWLqxJoXbgE9mcqGPObFjfLgooDCqA&s	images/license_dostoevsky_pd.jpg	\N	\N	1	2026-03-26 01:24:54.317881	5000000	1866-01-01	["["1882", "1910", "1959", "1999", "2021"]"]	Фёдор Михайлович Достоевский. Преступление и наказание. — 1866. — Русский вестник. — ISBN 9785352021781
50	67	Капитанская дочка	Александр Сергеевич Пушкин	Художественная литература	1836	Электронная книга	4.1	254.78	12+	9788475251288	0	\N	\N	https://covers.openlibrary.org/b/id/893480-L.jpg		\N	\N	1	2026-03-26 01:06:31.17163	15000000		[]	Александр Сергеевич Пушкин Капитанская дочка. — 1836. — Художественная литература. — ISBN 9788475251288
62	146	Дом свиданий	Глеб Викторович Гаврилов	АСМИ	2019	Электронная книга	3	0		9661823561	0	\N	\N	https://www.kino-teatr.ru/movie/posters/big/9/5/1959.jpg		\N	\N	1	2026-03-26 11:59:47.091132	0		["["[]"]"]	Глеб Викторович Гаврилов Дом свиданий. — 2019. — АСМИ. — ISBN 9661823561
54	103	Романовы	Евгений Вадимович Тамплон	Баско	2018	Электронная книга	3.1	1299	12+	9785913570642	0	\N	\N	C:\\Users\\tanis\\Documents\\library_backend_cpp-main\\build\\images\\166060.jpg		\N	\N	1	2026-03-26 11:15:08.229579	1000		["[]"]	Евгений Вадимович Тамплон Романовы. — 2018. — Баско. — ISBN 9785913570642
65	\N	Дядя Ваня	Антон Павлович Чехов	Open Road Integrated Media, Inc.	1897		0	0		9781460988107	0	\N	\N	images/cover_9781460988107.jpg		\N	\N	1	2026-03-26 12:02:08.996359	0		[]	Антон Павлович Чехов Дядя Ваня. — 1897. — Open Road Integrated Media, Inc.. — ISBN 9781460988107
66	\N	Чайка	Антон Павлович Чехов	Methuen Drama	1915		0	0		9781419281709	0	\N	\N	images/cover_9781419281709.jpg		\N	\N	1	2026-03-26 12:02:24.605635	0		[]	Антон Павлович Чехов Чайка. — 1915. — Methuen Drama. — ISBN 9781419281709
67	\N	Павел Иванович Голландский и его крымская эпопея	Элеонора Борисовна Петрова	Н. Орiанда	2013		0	0		9789661691758	0	\N	\N			\N	\N	1	2026-03-26 12:02:46.235683	0		[]	Элеонора Борисовна Петрова Павел Иванович Голландский и его крымская эпопея. — 2013. — Н. Орiанда. — ISBN 9789661691758
68	\N	Альберт Николаевич Елсуков	Александр Николаевич Данилов	BGU	2016		0	0		9789855663301	0	\N	\N			\N	\N	1	2026-03-26 12:03:45.338788	0		[]	Александр Николаевич Данилов Альберт Николаевич Елсуков. — 2016. — BGU. — ISBN 9789855663301
51	68	Отцы и дети	Иван Сергеевич Тургенев	Русский вестник	1861	Электронная книга	4.8	457.99	12+	9785352021453	0	\N	\N	C:\\Users\\tanis\\Documents\\library_backend_cpp-main\\build\\images\\Fathers_and_Sons_cover_-_retouched.jpg		\N	\N	1	2026-03-26 01:13:04.620508	17000000		["[]"]	Иван Сергеевич Тургеньев. Отцы и дети. — 1861. — Русский вестник. — ISBN 9785352021453
55	70	Бесы	Фёдор Михайлович Достоевский	Русский вестник	1872	Электронная книга	3.9	666.66	16+	9789660303003	0	\N	\N	C:\\Users\\tanis\\Documents\\library_backend_cpp-main\\build\\images\\737752e4-6d3c-4e0b-ae7a-437fc2968668.jpg		\N	\N	1	2026-03-26 11:16:43.552264	6666666		["[]"]	Фёдор Михайлович Достоевский Бесы. — 1872. — Русский вестник. — ISBN 9789660303003
53	104	Der Mantel	Николай Васильевич Гоголь	Insel-verlag	1846	Электронная книга	3.9	579	12+	3958700160	0	\N	\N	https://img.labirint.ru/images/comments_pic/2150/0_e6bf1f045126fdd35bd11612481b5848_1639387487.jpg		\N	\N	1	2026-03-26 11:14:23.000009	2300000		["[]"]	Николай Васильевич Гоголь Der Mantel. — 1846. — Insel-verlag. - ISBN 3958700160
9	29	Самир	Тимур Юрьевич Анисимов	Журнал «Москва»	2026	Электронная книга	5	899.99	12+	\N	6000000	\N	\N	C:\\Users\\tanis\\Documents\\library_backend_cpp-main\\build\\images\\images.jpg		\N	\N	1	2026-03-25 04:22:26.981818	0	1966	["[1967, 1967, 1969, 1973, 1975, 1978, 1980, 1984, 1989, 2014]"]	Анисимов Тимур Юрьевич Самир. — 2026
69	\N	Тато Жора	Петр Немировский	Path to Victory	2023		0	0		\N	0	\N	\N	images/cover_Тато Жора.jpg		\N	\N	1	2026-03-26 12:06:03.783119	0		[]	Петр Немировский Тато Жора. — 2023. — Path to Victory
75	\N	Война и мир князя Петра Ивановича Багратиона	Г. Е. Бродский	Minuvshee	2020		0	0		5905901597	0	\N	\N			\N	\N	1	2026-03-26 12:08:27.872356	0		[]	Г. Е. Бродский Война и мир князя Петра Ивановича Багратиона. — 2020. — Minuvshee. — ISBN 5905901597
78	\N	Iоанн Павло II - Папа миру	Олександр Яремович Федорiв	Пiдруч. i Посiб.	2001		0	0		9789665624875	0	\N	\N			\N	\N	1	2026-03-26 12:23:50.22868	0		[]	Олександр Яремович Федорiв Iоанн Павло II - Папа миру. — 2001. — Пiдруч. i Посiб.. — ISBN 9789665624875
111	\N	Death on the Nile	Agatha Christie	Wydawnictwo Dolnoslaskie	1937	Электронная книга	4.16667	0		0007135742	0	\N	\N	https://covers.openlibrary.org/b/id/14066646-L.jpg		\N	\N	1	2026-03-26 12:29:30.35071	0		["["[]"]"]	Agatha Christie Death on the Nile. — 1944. — New Avon Library
115	141	Roughing It	Mark Twain	American publishing companyy	1872	Электронная книга	4.16667	0		9798732389906	0	\N	\N	https://covers.openlibrary.org/b/id/9165528-L.jpg		\N	\N	1	2026-03-26 13:10:25.496927	0		["["["["["["[]"]"]"]"]"]"]	Mark Twain Roughing It. — 1872. — American publishing companyy. — ISBN 9798732389906
113	142	Death Comes for the Archbishop	Willa Cather	Ft. Raphael Publishing Company	1732	Электронная книга	3.6	0		9781985058941	0	\N	\N	https://covers.openlibrary.org/b/id/6833506-L.jpg		\N	\N	1	2026-03-26 12:50:04.428137	0		["[]"]	Willa Cather Death Comes for the Archbishop. — 1732. — Ft. Raphael Publishing Company. — ISBN 9781985058941
76	151	Story	Robert McKee	Independently Published	1997	Электронная книга	4.66667	0		0060391685	0	\N	\N	https://covers.openlibrary.org/b/id/38437-L.jpg		\N	\N	1	2026-03-26 12:08:57.889175	0			Robert McKee Story. — 1997. — Independently Published. — ISBN 0060391685
71	139	Собачье сердце ; Романы ; Повести ; Рассказы	Михаил Афанасьевич Булгаков	Hesperus Press Ltd	2011	Электронная книга	3	0		517002603X	0	\N	\N	https://upload.wikimedia.org/wikipedia/ru/5/51/%D0%A1%D0%BE%D0%B1%D0%B0%D1%87%D1%8C%D0%B5_%D1%81%D0%B5%D1%80%D0%B4%D1%86%D0%B5_%28%D1%84%D0%B8%D0%BB%D1%8C%D0%BC%2C_1988%29.jpg		\N	\N	1	2026-03-26 12:07:07.417037	0		["["[]"]"]	Михаил Афанасьевич Булгаков Собачье сердце. — 1968. — Hesperus Press Ltd. — ISBN 517002603X
151	\N	Eugene Onegin: Commentary and index	Aleksandr Sergeevich Pushkin	Princeton University Press	1991	Электронная книга	3.5	0		\N	0	\N	\N	https://cdn.azbooka.ru/cv/w1100/8fb16b40-17d4-43fa-b3fa-20238b342ad3.jpg		\N	\N	1	2026-04-01 22:11:24.436157	0		["[]"]	Aleksandr Sergeevich Pushkin Eugene Onegin: Commentary and index. — 1991. — Princeton University Press
112	\N	Смерть Ивана Ильича	Лев Толстой	Penguin	1887	Электронная книга	3	0		9781791733506	0	\N	\N	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQK9EH-yE-6_TMMubiVjYICaKxR6f2HRQgohQ&s		\N	\N	1	2026-03-26 12:40:33.710615	0		["[]"]	Лев Толстой Смерть Ивана Ильича. — 1887. — Penguin. — ISBN 9781791733506
56	\N	Три сестры	Антон Павлович Чехов	Methuen Drama	1901	Электронная книга	3	0		9780571334926	0	\N	\N	https://cdn.azbooka.ru/cv/w1100/c6b534ec-4824-45c2-bddc-e77d684f2dcb.jpg		\N	\N	1	2026-03-26 11:53:42.252046	0		["[]"]	Антон Павлович Чехов Три сестры. — 1901. — Methuen Drama. — ISBN 9780571334926
116	\N	Мистер Смерть и чокнутая ведьма	Милена Завойчинская	ЛитРес, Э	2017	Электронная книга	3	0		\N	0	\N	\N	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfl7id6aM27i196MYrFnHV0Fd1P4ak9N0LIg&s		\N	\N	1	2026-03-26 13:14:46.871722	0		["[]"]	Милена Завойчинская Мистер Смерть и чокнутая ведьма. — 2017. — ЛитРес, Э
74	\N	Анна Каренина	Лев Толстой	Hern Books, Limited, Nick	1876	Электронная книга	3	0		9798673567456	0	\N	\N	https://cdn.azbooka.ru/cv/w1100/f85b70c8-f0e4-4104-bd2e-b3de263793d8.jpg		\N	\N	1	2026-03-26 12:07:57.104728	0		["[]"]	Лев Толстой Анна Каренина. — 1876. — Hern Books, Limited, Nick. — ISBN 9798673567456
57	67	Евгений Онегин	Александр Сергеевич Пушкин	АСТ	2000	Электронная книга	3.57	0	18+	9785170003440	0	\N	\N	https://cdn.azbooka.ru/cv/w1100/8fb16b40-17d4-43fa-b3fa-20238b342ad3.jpg		\N	\N	1	2026-03-26 11:55:14.50688	50000000		["[]"]	Александр Сергеевич Пушкин Евгений Онегин. — 2000. — АСТ. — ISBN 9785170003440
49	150	Портал	Юрий Иванович Писковский	Емма	2008	Электронная книга	3	899.99	12+	9669682428	0	\N	\N	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLlyWNCg0amIrm6oZkyhVJ_GQtlARkHpJ6Dg&s		\N	\N	1	2026-03-26 00:53:18.42118	9000000		["["["[]"]"]"]	Михаил Афанасьевич Булгаков Мастер и Маргарита. — 1966. — ISBN 9781530555383
154	148	Мастер и Маргарита	Михаил Афанасьевич Булгаков	AzbukaAzbukaAttikus	1966	Электронная книга	4.15957	0		1986264149	0	\N	\N	https://covers.openlibrary.org/b/id/12947486-L.jpg		\N	\N	1	2026-04-02 12:47:04.730467	0			Михаил Афанасьевич Булгаков Мастер и Маргарита. — 1966. — AzbukaAzbukaAttikus. — ISBN 1986264149
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genres (id, name) FROM stdin;
28	Роман
29	Ужасы
63	хуй
64	ужасы
65	Классическая литература
102	Научно-популярное издание
103	Художественная литература
104	воа
138	Историческая
139	19th century
141	Fiction
142	Филологические науки. Художественная литература -- Художественная литература. Литературоведение -- Российская Федерация -- Русская литература -- с 1991 г. -- Произведения художественной литературы -- Художественная проза -- Романы. Повести. Рассказы
144	Филологические науки
147	satire
149	Искусство
150	Motion picture plays
\.


--
-- Data for Name: subgenres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subgenres (id, genre_id, name) FROM stdin;
28	28	Киберпанк
29	29	Триллер
63	63	хуй
64	64	Боевик
65	65	Русская классика
66	28	Мистика
67	28	Мемуары
68	28	Реализм
69	28	Идеологический
70	28	Трагедия
103	102	Документально-иллюстрированное исследование
104	103	Повесть
105	104	ывм
139	138	Древний мир
140	139	Gbdj
141	139	-
142	141	-
143	142	-
145	144	-
146	28	-
148	147	-
150	149	-
151	150	-
\.


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_id_seq', 154, true);


--
-- Name: genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genres_id_seq', 163, true);


--
-- Name: subgenres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subgenres_id_seq', 164, true);


--
-- Name: books books_isbn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_isbn_key UNIQUE (isbn);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: genres genres_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_name_key UNIQUE (name);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: subgenres subgenres_genre_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subgenres
    ADD CONSTRAINT subgenres_genre_id_name_key UNIQUE (genre_id, name);


--
-- Name: subgenres subgenres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subgenres
    ADD CONSTRAINT subgenres_pkey PRIMARY KEY (id);


--
-- Name: idx_books_author; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_books_author ON public.books USING btree (author);


--
-- Name: idx_books_isbn; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_books_isbn ON public.books USING btree (isbn);


--
-- Name: idx_books_subgenre_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_books_subgenre_id ON public.books USING btree (subgenre_id);


--
-- Name: idx_books_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_books_title ON public.books USING btree (title);


--
-- Name: idx_subgenres_genre_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_subgenres_genre_id ON public.subgenres USING btree (genre_id);


--
-- Name: books books_subgenre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_subgenre_id_fkey FOREIGN KEY (subgenre_id) REFERENCES public.subgenres(id) ON DELETE SET NULL;


--
-- Name: subgenres subgenres_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subgenres
    ADD CONSTRAINT subgenres_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genres(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict zDvd49gjR1CBd9ltnkMU6bTZsYbmYrnE8Jek1nHoH47bErwKuhdS0UvQ38Zvfje

