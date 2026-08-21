--
-- PostgreSQL database dump
--

\restrict EsFfErPTSVAgQzYbcuDXSu0RHtxg0LOeKwkwJf5htg2Ds2pdQ8fLETL7y4A88hB

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-08-21 10:16:00 MST

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
-- TOC entry 230 (class 1259 OID 16503)
-- Name: aire_acondicionado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aire_acondicionado (
    id_ac integer NOT NULL,
    id_area integer,
    marca character varying(50),
    modelo_serie character varying(100),
    capacidad character varying(50),
    corriente character varying(50),
    estado_general text
);


ALTER TABLE public.aire_acondicionado OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16502)
-- Name: aire_acondicionado_id_ac_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.aire_acondicionado_id_ac_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aire_acondicionado_id_ac_seq OWNER TO postgres;

--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 229
-- Name: aire_acondicionado_id_ac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.aire_acondicionado_id_ac_seq OWNED BY public.aire_acondicionado.id_ac;


--
-- TOC entry 220 (class 1259 OID 16426)
-- Name: area; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.area (
    id_area integer NOT NULL,
    nombre_area character varying(50)
);


ALTER TABLE public.area OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16425)
-- Name: area_id_area_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.area_id_area_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.area_id_area_seq OWNER TO postgres;

--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 219
-- Name: area_id_area_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.area_id_area_seq OWNED BY public.area.id_area;


--
-- TOC entry 224 (class 1259 OID 16442)
-- Name: inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario (
    id_articulo integer NOT NULL,
    producto character varying(100) NOT NULL,
    marca character varying(100),
    modelo character varying(50),
    especificacion text,
    cantidad integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.inventario OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16441)
-- Name: inventario_id_articulo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventario_id_articulo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_id_articulo_seq OWNER TO postgres;

--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 223
-- Name: inventario_id_articulo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventario_id_articulo_seq OWNED BY public.inventario.id_articulo;


--
-- TOC entry 234 (class 1259 OID 16527)
-- Name: revision_vehiculo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revision_vehiculo (
    id_revision integer NOT NULL,
    id_vehiculo integer,
    id_usuario_revisa integer,
    fecha_revision date DEFAULT CURRENT_DATE NOT NULL,
    nivel_agua character varying(50),
    nivel_aceite character varying(50),
    carroceria character varying(50),
    gasolina character varying(50),
    estado_llantas character varying(50),
    aire_llantas character varying(50),
    documentos_guantera character varying(50),
    ruidos_extranos text,
    residuos_extranos text
);


ALTER TABLE public.revision_vehiculo OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16526)
-- Name: revision_vehiculo_id_revision_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.revision_vehiculo_id_revision_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.revision_vehiculo_id_revision_seq OWNER TO postgres;

--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 233
-- Name: revision_vehiculo_id_revision_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.revision_vehiculo_id_revision_seq OWNED BY public.revision_vehiculo.id_revision;


--
-- TOC entry 226 (class 1259 OID 16455)
-- Name: solicitud; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.solicitud (
    id_solicitud integer NOT NULL,
    fecha_solicitud date DEFAULT CURRENT_DATE NOT NULL,
    fecha_asignacion date,
    fecha_realizacion date,
    descripcion text NOT NULL,
    estado character varying(30) NOT NULL,
    prioridad character varying(20) NOT NULL,
    riesgo_seguridad character varying(2) NOT NULL,
    categoria character varying(30) NOT NULL,
    comentarios text,
    tipo_servicio character varying(20) NOT NULL,
    costo numeric(10,2) DEFAULT 0.00,
    financiamiento character varying(100),
    id_usuario_reporta integer,
    id_area_equipo integer,
    fecha_programada date,
    frecuencia character varying(50) DEFAULT 'Unica vez'::character varying,
    id_tecnico_asignadio integer,
    id_tecnico_asignado integer,
    nota_resolucion text
);


ALTER TABLE public.solicitud OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16484)
-- Name: solicitud_articulo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.solicitud_articulo (
    id_detalle integer NOT NULL,
    id_solicitud integer,
    id_articulo integer,
    cantidad_utilizada integer NOT NULL
);


ALTER TABLE public.solicitud_articulo OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16483)
-- Name: solicitud_articulo_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.solicitud_articulo_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solicitud_articulo_id_detalle_seq OWNER TO postgres;

--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 227
-- Name: solicitud_articulo_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.solicitud_articulo_id_detalle_seq OWNED BY public.solicitud_articulo.id_detalle;


--
-- TOC entry 225 (class 1259 OID 16454)
-- Name: solicitud_id_solicitud_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.solicitud_id_solicitud_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solicitud_id_solicitud_seq OWNER TO postgres;

--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 225
-- Name: solicitud_id_solicitud_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.solicitud_id_solicitud_seq OWNED BY public.solicitud.id_solicitud;


--
-- TOC entry 222 (class 1259 OID 16434)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    nombre_usuario character varying(50)
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16433)
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 221
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- TOC entry 232 (class 1259 OID 16518)
-- Name: vehiculo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehiculo (
    id_vehiculo integer NOT NULL,
    marca_modelo character varying(100) NOT NULL,
    placas character varying(20)
);


ALTER TABLE public.vehiculo OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16517)
-- Name: vehiculo_id_vehiculo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehiculo_id_vehiculo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehiculo_id_vehiculo_seq OWNER TO postgres;

--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 231
-- Name: vehiculo_id_vehiculo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehiculo_id_vehiculo_seq OWNED BY public.vehiculo.id_vehiculo;


--
-- TOC entry 3372 (class 2604 OID 16506)
-- Name: aire_acondicionado id_ac; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aire_acondicionado ALTER COLUMN id_ac SET DEFAULT nextval('public.aire_acondicionado_id_ac_seq'::regclass);


--
-- TOC entry 3363 (class 2604 OID 16429)
-- Name: area id_area; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area ALTER COLUMN id_area SET DEFAULT nextval('public.area_id_area_seq'::regclass);


--
-- TOC entry 3365 (class 2604 OID 16445)
-- Name: inventario id_articulo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario ALTER COLUMN id_articulo SET DEFAULT nextval('public.inventario_id_articulo_seq'::regclass);


--
-- TOC entry 3374 (class 2604 OID 16530)
-- Name: revision_vehiculo id_revision; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision_vehiculo ALTER COLUMN id_revision SET DEFAULT nextval('public.revision_vehiculo_id_revision_seq'::regclass);


--
-- TOC entry 3367 (class 2604 OID 16458)
-- Name: solicitud id_solicitud; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud ALTER COLUMN id_solicitud SET DEFAULT nextval('public.solicitud_id_solicitud_seq'::regclass);


--
-- TOC entry 3371 (class 2604 OID 16487)
-- Name: solicitud_articulo id_detalle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_articulo ALTER COLUMN id_detalle SET DEFAULT nextval('public.solicitud_articulo_id_detalle_seq'::regclass);


--
-- TOC entry 3364 (class 2604 OID 16437)
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- TOC entry 3373 (class 2604 OID 16521)
-- Name: vehiculo id_vehiculo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculo ALTER COLUMN id_vehiculo SET DEFAULT nextval('public.vehiculo_id_vehiculo_seq'::regclass);


--
-- TOC entry 3559 (class 0 OID 16503)
-- Dependencies: 230
-- Data for Name: aire_acondicionado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aire_acondicionado (id_ac, id_area, marca, modelo_serie, capacidad, corriente, estado_general) FROM stdin;
\.


--
-- TOC entry 3549 (class 0 OID 16426)
-- Dependencies: 220
-- Data for Name: area; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.area (id_area, nombre_area) FROM stdin;
1	Aula 3
2	Laboratorio de Ciencias
3	Bodega central
4	Edificio Administrativo
\.


--
-- TOC entry 3553 (class 0 OID 16442)
-- Dependencies: 224
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario (id_articulo, producto, marca, modelo, especificacion, cantidad) FROM stdin;
\.


--
-- TOC entry 3563 (class 0 OID 16527)
-- Dependencies: 234
-- Data for Name: revision_vehiculo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revision_vehiculo (id_revision, id_vehiculo, id_usuario_revisa, fecha_revision, nivel_agua, nivel_aceite, carroceria, gasolina, estado_llantas, aire_llantas, documentos_guantera, ruidos_extranos, residuos_extranos) FROM stdin;
\.


--
-- TOC entry 3555 (class 0 OID 16455)
-- Dependencies: 226
-- Data for Name: solicitud; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.solicitud (id_solicitud, fecha_solicitud, fecha_asignacion, fecha_realizacion, descripcion, estado, prioridad, riesgo_seguridad, categoria, comentarios, tipo_servicio, costo, financiamiento, id_usuario_reporta, id_area_equipo, fecha_programada, frecuencia, id_tecnico_asignadio, id_tecnico_asignado, nota_resolucion) FROM stdin;
1	2026-08-20	\N	\N	Hola maria (la mira sospechosamente).	Cerrado	Baja	No	Correctivo	\N	Interno	0.00	\N	\N	1	\N	\N	\N	2	Hola :O
\.


--
-- TOC entry 3557 (class 0 OID 16484)
-- Dependencies: 228
-- Data for Name: solicitud_articulo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.solicitud_articulo (id_detalle, id_solicitud, id_articulo, cantidad_utilizada) FROM stdin;
\.


--
-- TOC entry 3551 (class 0 OID 16434)
-- Dependencies: 222
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id_usuario, nombre_usuario) FROM stdin;
1	Juan
2	María Torres
\.


--
-- TOC entry 3561 (class 0 OID 16518)
-- Dependencies: 232
-- Data for Name: vehiculo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehiculo (id_vehiculo, marca_modelo, placas) FROM stdin;
\.


--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 229
-- Name: aire_acondicionado_id_ac_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aire_acondicionado_id_ac_seq', 1, false);


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 219
-- Name: area_id_area_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.area_id_area_seq', 4, true);


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 223
-- Name: inventario_id_articulo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventario_id_articulo_seq', 1, false);


--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 233
-- Name: revision_vehiculo_id_revision_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.revision_vehiculo_id_revision_seq', 1, false);


--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 227
-- Name: solicitud_articulo_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.solicitud_articulo_id_detalle_seq', 1, false);


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 225
-- Name: solicitud_id_solicitud_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.solicitud_id_solicitud_seq', 1, true);


--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 221
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 1, true);


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 231
-- Name: vehiculo_id_vehiculo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehiculo_id_vehiculo_seq', 1, false);


--
-- TOC entry 3387 (class 2606 OID 16511)
-- Name: aire_acondicionado aire_acondicionado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aire_acondicionado
    ADD CONSTRAINT aire_acondicionado_pkey PRIMARY KEY (id_ac);


--
-- TOC entry 3377 (class 2606 OID 16432)
-- Name: area area_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area
    ADD CONSTRAINT area_pkey PRIMARY KEY (id_area);


--
-- TOC entry 3381 (class 2606 OID 16453)
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_articulo);


--
-- TOC entry 3391 (class 2606 OID 16537)
-- Name: revision_vehiculo revision_vehiculo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision_vehiculo
    ADD CONSTRAINT revision_vehiculo_pkey PRIMARY KEY (id_revision);


--
-- TOC entry 3385 (class 2606 OID 16491)
-- Name: solicitud_articulo solicitud_articulo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_articulo
    ADD CONSTRAINT solicitud_articulo_pkey PRIMARY KEY (id_detalle);


--
-- TOC entry 3383 (class 2606 OID 16472)
-- Name: solicitud solicitud_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud
    ADD CONSTRAINT solicitud_pkey PRIMARY KEY (id_solicitud);


--
-- TOC entry 3379 (class 2606 OID 16440)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 3389 (class 2606 OID 16525)
-- Name: vehiculo vehiculo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculo
    ADD CONSTRAINT vehiculo_pkey PRIMARY KEY (id_vehiculo);


--
-- TOC entry 3398 (class 2606 OID 16512)
-- Name: aire_acondicionado aire_acondicionado_id_area_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aire_acondicionado
    ADD CONSTRAINT aire_acondicionado_id_area_fkey FOREIGN KEY (id_area) REFERENCES public.area(id_area);


--
-- TOC entry 3399 (class 2606 OID 16543)
-- Name: revision_vehiculo revision_vehiculo_id_usuario_revisa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision_vehiculo
    ADD CONSTRAINT revision_vehiculo_id_usuario_revisa_fkey FOREIGN KEY (id_usuario_revisa) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 3400 (class 2606 OID 16538)
-- Name: revision_vehiculo revision_vehiculo_id_vehiculo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision_vehiculo
    ADD CONSTRAINT revision_vehiculo_id_vehiculo_fkey FOREIGN KEY (id_vehiculo) REFERENCES public.vehiculo(id_vehiculo);


--
-- TOC entry 3396 (class 2606 OID 16497)
-- Name: solicitud_articulo solicitud_articulo_id_articulo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_articulo
    ADD CONSTRAINT solicitud_articulo_id_articulo_fkey FOREIGN KEY (id_articulo) REFERENCES public.inventario(id_articulo);


--
-- TOC entry 3397 (class 2606 OID 16492)
-- Name: solicitud_articulo solicitud_articulo_id_solicitud_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_articulo
    ADD CONSTRAINT solicitud_articulo_id_solicitud_fkey FOREIGN KEY (id_solicitud) REFERENCES public.solicitud(id_solicitud);


--
-- TOC entry 3392 (class 2606 OID 16478)
-- Name: solicitud solicitud_id_area_equipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud
    ADD CONSTRAINT solicitud_id_area_equipo_fkey FOREIGN KEY (id_area_equipo) REFERENCES public.area(id_area);


--
-- TOC entry 3393 (class 2606 OID 16565)
-- Name: solicitud solicitud_id_tecnico_asignadio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud
    ADD CONSTRAINT solicitud_id_tecnico_asignadio_fkey FOREIGN KEY (id_tecnico_asignadio) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 3394 (class 2606 OID 16570)
-- Name: solicitud solicitud_id_tecnico_asignado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud
    ADD CONSTRAINT solicitud_id_tecnico_asignado_fkey FOREIGN KEY (id_tecnico_asignado) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 3395 (class 2606 OID 16473)
-- Name: solicitud solicitud_id_usuario_reporta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud
    ADD CONSTRAINT solicitud_id_usuario_reporta_fkey FOREIGN KEY (id_usuario_reporta) REFERENCES public.usuario(id_usuario);


-- Completed on 2026-08-21 10:16:00 MST

--
-- PostgreSQL database dump complete
--

\unrestrict EsFfErPTSVAgQzYbcuDXSu0RHtxg0LOeKwkwJf5htg2Ds2pdQ8fLETL7y4A88hB

