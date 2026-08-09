SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict chwG8uMn8U4MNzdRVfEFfSLhuBKJf290gwSYlTh1qxrDxHwr3TuE0L1EdrYElP5

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

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
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."photos" ("id", "user_id", "storage_path", "status", "lat", "lng", "created_at", "updated_at", "comment") VALUES
	('25e55f3d-78bb-4d80-96ab-ca6115b7d0e2', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/6ed7af1d-2e7a-4110-8cff-4036f7d366dd.webp', 'approved', 33.77505495362655, -84.39393056263447, '2026-08-04 18:58:35.316335+00', '2026-08-07 16:34:34.457975+00', 'jew locker'),
	('dd6d7d2d-2556-41b6-bdfe-22bded550751', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/142fe8c1-1c74-4f8b-9d0c-7f0b4193d827.webp', 'approved', 33.77395023581906, -84.39778611580311, '2026-08-04 18:59:07.50294+00', '2026-08-07 16:35:44.450148+00', NULL),
	('34efa918-11cf-4cd4-9373-6a8b8b0068aa', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/59849630-91fc-4238-99fd-d9788b5126e6.webp', 'approved', 33.77856581489441, -84.4009462258718, '2026-08-04 18:59:22.308647+00', '2026-08-07 16:36:15.67456+00', NULL),
	('19b7d4de-6db6-4319-8975-5f50aec70d22', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/ee6ed958-93c3-42bf-aed0-6d5d2b02dfe7.webp', 'approved', 33.77974509820025, -84.40477011560978, '2026-08-04 18:58:48.896838+00', '2026-08-07 16:36:45.891754+00', NULL),
	('995e8201-26c3-4a37-95b3-bbf9a0a64541', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/cc3aa527-e197-4b85-abb3-c2e8723e85cc.webp', 'approved', 33.774260058447844, -84.39545069803138, '2026-08-04 18:58:20.268459+00', '2026-08-07 16:37:25.014737+00', NULL),
	('5ea15889-4d12-4332-a019-5883d1709679', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/94113f9a-ab57-43be-b57e-3d0f7f89ee4f.webp', 'approved', 33.77016043649862, -84.39125973626442, '2026-08-04 18:58:04.382347+00', '2026-08-07 16:37:56.015673+00', NULL);


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."profiles" ("id", "updated_at", "username", "avatar_url") VALUES
	('1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 18:57:10.418+00', 'gurtson', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/1785869827340.png');


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id", "type") VALUES
	('avatars', 'avatars', NULL, '2026-07-29 22:53:56.611682+00', '2026-07-29 22:53:56.611682+00', false, false, 5242880, '{image/jpeg,image/webp,image/png}', NULL, 'STANDARD'),
	('photos', 'photos', NULL, '2026-08-03 18:15:33.220482+00', '2026-08-03 18:15:33.220482+00', true, false, 5242880, '{image/jpeg,image/png,image/webp}', NULL, 'STANDARD');


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata") VALUES
	('b3a14cde-f47d-4d5b-9676-38236615bc90', 'avatars', '.emptyFolderPlaceholder', NULL, '2026-07-31 19:20:21.137476+00', '2026-07-31 19:20:21.137476+00', '2026-07-31 19:20:21.137476+00', '{"eTag": "\"d41d8cd98f00b204e9800998ecf8427e\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-07-31T19:20:21.143Z", "contentLength": 0, "httpStatusCode": 200}', '6157c7af-f262-4837-9062-649222f36a57', NULL, '{}'),
	('c408d582-6f45-47d4-9d57-2bfebdf229e1', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/.emptyFolderPlaceholder', NULL, '2026-08-03 18:51:04.204835+00', '2026-08-03 18:51:04.204835+00', '2026-08-03 18:51:04.204835+00', '{"eTag": "\"d41d8cd98f00b204e9800998ecf8427e\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-08-03T18:51:04.203Z", "contentLength": 0, "httpStatusCode": 200}', '2f5f8428-bca6-46ac-8299-2a072d0415bb', NULL, '{}'),
	('7ac08605-9deb-42c0-bfff-38fdc7f2531c', 'avatars', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/.emptyFolderPlaceholder', NULL, '2026-08-04 18:53:49.036999+00', '2026-08-04 18:53:49.036999+00', '2026-08-04 18:53:49.036999+00', '{"eTag": "\"d41d8cd98f00b204e9800998ecf8427e\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T18:53:49.031Z", "contentLength": 0, "httpStatusCode": 200}', 'db60702a-ad2d-4d5f-84c4-a466d44acaa5', NULL, '{}'),
	('8089f989-9283-4d7c-b9fc-d4117937e178', 'avatars', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/1785869827340.png', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 18:57:07.424439+00', '2026-08-04 18:57:07.424439+00', '2026-08-04 18:57:07.424439+00', '{"eTag": "\"ebe7988bbc1193f87b8b80c63ca64689\"", "size": 67127, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T18:57:07.419Z", "contentLength": 67127, "httpStatusCode": 200}', '800d86c3-8253-4377-b2e3-a186191e05f1', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('7e4fc696-185d-484c-a1fa-2bd41696c1c5', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/94113f9a-ab57-43be-b57e-3d0f7f89ee4f.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 18:58:04.358279+00', '2026-08-04 18:58:04.358279+00', '2026-08-04 18:58:04.358279+00', '{"eTag": "\"cd9a9540255dd6ec05f77dc9d8f5a858\"", "size": 175688, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T18:58:04.355Z", "contentLength": 175688, "httpStatusCode": 200}', 'fc9e219c-d485-4ad1-b8c3-54c82bca91a3', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('f448ab51-da63-4b79-9b8f-40f795ae94ba', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/cc3aa527-e197-4b85-abb3-c2e8723e85cc.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 18:58:20.246616+00', '2026-08-04 18:58:20.246616+00', '2026-08-04 18:58:20.246616+00', '{"eTag": "\"e0b488f0542b7565061ad48cc9886713\"", "size": 413876, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T18:58:20.243Z", "contentLength": 413876, "httpStatusCode": 200}', '80601390-902e-4e4c-829c-4fe8bed73b63', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('5d05c0a3-2cf2-49f0-b174-67a5ef7009d7', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/6ed7af1d-2e7a-4110-8cff-4036f7d366dd.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 18:58:35.299467+00', '2026-08-04 18:58:35.299467+00', '2026-08-04 18:58:35.299467+00', '{"eTag": "\"18ad2ec8fcfeed8c3deca61fb1a4d2c1\"", "size": 586854, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T18:58:35.295Z", "contentLength": 586854, "httpStatusCode": 200}', '0eab5990-6c2b-4b12-a0dd-8ff910e92a89', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('6c593ef6-2223-419b-aaf8-b62c893cf6e3', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/ee6ed958-93c3-42bf-aed0-6d5d2b02dfe7.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 18:58:48.868156+00', '2026-08-04 18:58:48.868156+00', '2026-08-04 18:58:48.868156+00', '{"eTag": "\"77ed65970a39eeadf2d75d77f2ac748f\"", "size": 565390, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T18:58:48.864Z", "contentLength": 565390, "httpStatusCode": 200}', 'ff90e840-80af-4b9e-9953-f2743f7cba67', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('b67158e5-f6dc-4a26-9d58-9aff6a5d702b', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/142fe8c1-1c74-4f8b-9d0c-7f0b4193d827.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 18:59:07.479732+00', '2026-08-04 18:59:07.479732+00', '2026-08-04 18:59:07.479732+00', '{"eTag": "\"5886d9be14ae221fe613caed7102471a\"", "size": 843470, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T18:59:07.440Z", "contentLength": 843470, "httpStatusCode": 200}', '945b5077-4e30-4757-92e7-c22c1fa91a3d', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('fd9d5198-a378-40f1-aa47-ec428a096d7e', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/59849630-91fc-4238-99fd-d9788b5126e6.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 18:59:22.269918+00', '2026-08-04 18:59:22.269918+00', '2026-08-04 18:59:22.269918+00', '{"eTag": "\"79423cb289d58ea27134cafea89697f7\"", "size": 934868, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T18:59:22.263Z", "contentLength": 934868, "httpStatusCode": 200}', 'bbf0399e-6335-4a90-83d1-502a501f4995', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}');


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- PostgreSQL database dump complete
--

-- \unrestrict chwG8uMn8U4MNzdRVfEFfSLhuBKJf290gwSYlTh1qxrDxHwr3TuE0L1EdrYElP5

RESET ALL;
