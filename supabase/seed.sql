SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict rCioFTaxXMw5tYPscKZvodKdNeZ4MrlhJntk1LUme73kn5hz4SG7C5MVtiBkDZa

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
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', 'authenticated', 'authenticated', 'dxgd@pm.me', '$2a$10$J4AoqJPiVZQmO5eHOxzDqe7TjC5QfGp/wYgRhx5sxs8hM42YCHRya', '2026-07-31 14:18:44.031513+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-08-03 22:40:08.674504+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "1657d2b1-6215-41cf-bec2-bcc02ade02ba", "email": "dxgd@pm.me", "email_verified": true, "phone_verified": false}', NULL, '2026-07-31 14:18:44.003483+00', '2026-08-04 17:32:07.456958+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{"sub": "1657d2b1-6215-41cf-bec2-bcc02ade02ba", "email": "dxgd@pm.me", "email_verified": false, "phone_verified": false}', 'email', '2026-07-31 14:18:44.027863+00', '2026-07-31 14:18:44.027907+00', '2026-07-31 14:18:44.027907+00', 'bbcd8e1b-3fd8-4cd1-be0f-673bee8f286d');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag", "oauth_client_id", "refresh_token_hmac_key", "refresh_token_counter", "scopes") VALUES
	('686a889e-b450-4b11-86b8-83c35626204a', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-07-31 19:36:54.277401+00', '2026-08-01 16:34:44.055472+00', NULL, 'aal1', NULL, '2026-08-01 16:34:44.055384', 'Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0', '155.186.208.147', NULL, NULL, NULL, NULL, NULL),
	('f3be737f-1d53-4879-9f20-91fc746edf48', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-03 04:44:10.127809+00', '2026-08-03 05:43:28.760673+00', NULL, 'aal1', NULL, '2026-08-03 05:43:28.760589', 'Mozilla/5.0 (X11; Linux x86_64; rv:153.0) Gecko/20100101 Firefox/153.0', '185.98.168.57', NULL, NULL, NULL, NULL, NULL),
	('f0d74d9d-e62f-447f-9a3f-32314138ef31', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-03 16:55:50.611742+00', '2026-08-03 17:54:44.254257+00', NULL, 'aal1', NULL, '2026-08-03 17:54:44.254172', 'Mozilla/5.0 (X11; Linux x86_64; rv:153.0) Gecko/20100101 Firefox/153.0', '185.98.168.31', NULL, NULL, NULL, NULL, NULL),
	('e8217f46-88b6-422d-88de-65e324829159', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-03 22:40:08.674588+00', '2026-08-04 17:32:07.474521+00', NULL, 'aal1', NULL, '2026-08-04 17:32:07.472701', 'Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0', '185.98.168.5', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('686a889e-b450-4b11-86b8-83c35626204a', '2026-07-31 19:36:54.294704+00', '2026-07-31 19:36:54.294704+00', 'password', 'eb6c02fc-6b86-49f3-b482-08bb3ecdece7'),
	('f3be737f-1d53-4879-9f20-91fc746edf48', '2026-08-03 04:44:10.228893+00', '2026-08-03 04:44:10.228893+00', 'password', '098fc69e-6de6-4c07-964f-62070d00315c'),
	('f0d74d9d-e62f-447f-9a3f-32314138ef31', '2026-08-03 16:55:50.684787+00', '2026-08-03 16:55:50.684787+00', 'password', '3b5f014e-897d-4254-ac02-949cac73cd5c'),
	('e8217f46-88b6-422d-88de-65e324829159', '2026-08-03 22:40:08.750996+00', '2026-08-03 22:40:08.750996+00', 'password', 'd949097a-a033-4d86-a1bb-92852d46abb9');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 6, 'wpmkqdhzstaj', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-07-31 19:36:54.284464+00', '2026-07-31 23:27:07.703229+00', NULL, '686a889e-b450-4b11-86b8-83c35626204a'),
	('00000000-0000-0000-0000-000000000000', 7, '3q7qwlazzefl', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-07-31 23:27:07.717354+00', '2026-08-01 04:24:30.07972+00', 'wpmkqdhzstaj', '686a889e-b450-4b11-86b8-83c35626204a'),
	('00000000-0000-0000-0000-000000000000', 8, 'ztn2rgfif4uc', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-01 04:24:30.101594+00', '2026-08-01 16:34:44.024438+00', '3q7qwlazzefl', '686a889e-b450-4b11-86b8-83c35626204a'),
	('00000000-0000-0000-0000-000000000000', 9, 'eilzypfglxkt', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', false, '2026-08-01 16:34:44.034748+00', '2026-08-01 16:34:44.034748+00', 'ztn2rgfif4uc', '686a889e-b450-4b11-86b8-83c35626204a'),
	('00000000-0000-0000-0000-000000000000', 10, 'wwqsrigag7bk', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-03 04:44:10.182497+00', '2026-08-03 05:43:28.738907+00', NULL, 'f3be737f-1d53-4879-9f20-91fc746edf48'),
	('00000000-0000-0000-0000-000000000000', 11, 'wzh24riuk3y3', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', false, '2026-08-03 05:43:28.750749+00', '2026-08-03 05:43:28.750749+00', 'wwqsrigag7bk', 'f3be737f-1d53-4879-9f20-91fc746edf48'),
	('00000000-0000-0000-0000-000000000000', 12, 'bljfvrey4xyx', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-03 16:55:50.656053+00', '2026-08-03 17:54:44.218215+00', NULL, 'f0d74d9d-e62f-447f-9a3f-32314138ef31'),
	('00000000-0000-0000-0000-000000000000', 13, 'tql46cc67akg', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', false, '2026-08-03 17:54:44.230596+00', '2026-08-03 17:54:44.230596+00', 'bljfvrey4xyx', 'f0d74d9d-e62f-447f-9a3f-32314138ef31'),
	('00000000-0000-0000-0000-000000000000', 14, '4iy62nqoszbr', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-03 22:40:08.722702+00', '2026-08-03 23:38:22.179716+00', NULL, 'e8217f46-88b6-422d-88de-65e324829159'),
	('00000000-0000-0000-0000-000000000000', 15, 'drobrpx5ma6x', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-03 23:38:22.188914+00', '2026-08-04 00:36:24.277386+00', '4iy62nqoszbr', 'e8217f46-88b6-422d-88de-65e324829159'),
	('00000000-0000-0000-0000-000000000000', 16, 'qy75gvfp6pae', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-04 00:36:24.284283+00', '2026-08-04 01:35:31.917995+00', 'drobrpx5ma6x', 'e8217f46-88b6-422d-88de-65e324829159'),
	('00000000-0000-0000-0000-000000000000', 17, 'r2sfykhsypdj', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-04 01:35:31.9308+00', '2026-08-04 02:34:02.109474+00', 'qy75gvfp6pae', 'e8217f46-88b6-422d-88de-65e324829159'),
	('00000000-0000-0000-0000-000000000000', 18, 'cesnmxyix7bf', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-04 02:34:02.127957+00', '2026-08-04 03:32:50.773802+00', 'r2sfykhsypdj', 'e8217f46-88b6-422d-88de-65e324829159'),
	('00000000-0000-0000-0000-000000000000', 19, 'fltxw5g55twl', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-04 03:32:50.787335+00', '2026-08-04 04:30:47.326837+00', 'cesnmxyix7bf', 'e8217f46-88b6-422d-88de-65e324829159'),
	('00000000-0000-0000-0000-000000000000', 20, 'kmgtd2efdwxo', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-04 04:30:47.338932+00', '2026-08-04 12:47:26.373987+00', 'fltxw5g55twl', 'e8217f46-88b6-422d-88de-65e324829159'),
	('00000000-0000-0000-0000-000000000000', 21, 'nzxs7rcbnftw', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', true, '2026-08-04 12:47:26.385006+00', '2026-08-04 17:32:07.444194+00', 'kmgtd2efdwxo', 'e8217f46-88b6-422d-88de-65e324829159'),
	('00000000-0000-0000-0000-000000000000', 22, '3tnebtc2fabb', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', false, '2026-08-04 17:32:07.45479+00', '2026-08-04 17:32:07.45479+00', 'nzxs7rcbnftw', 'e8217f46-88b6-422d-88de-65e324829159');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."photos" ("id", "user_id", "storage_path", "status", "lat", "long", "created_at", "updated_at", "comment") VALUES
	('081c76fb-8251-47f8-8fc0-7c1a51a832c2', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/ee3ff5f4-dd03-46cf-88c4-040d21931e45.webp', 'approved', 12, 2, '2026-08-04 13:11:29.145126+00', '2026-08-04 13:12:44.087297+00', NULL),
	('0f0674cd-9bfd-4fe6-a730-947a51cd803e', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/bc3473be-951a-406b-9ac3-b07078d29000.webp', 'approved', 18, 10, '2026-08-04 13:12:14.181623+00', '2026-08-04 13:12:49.331572+00', NULL),
	('298e7840-218b-4bf5-a405-41060d7a0d50', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/5cfd1397-aee2-428a-9af8-84e0aa67fefb.webp', 'approved', -5, 9, '2026-08-04 13:11:48.646571+00', '2026-08-04 13:12:55.66997+00', NULL),
	('6acf94ee-5e92-4c41-8e62-0070f75f6cad', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/fe4da327-58a3-4bc8-ad91-7e2428f28336.webp', 'approved', 3, 1, '2026-08-04 13:11:40.552935+00', '2026-08-04 13:13:02.202692+00', NULL),
	('7033f8e3-b0b7-4bbf-a8f5-4594c0b00c02', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/d90d894e-11e7-4318-b1a3-6327d503d4a4.webp', 'approved', 487, 1, '2026-08-04 04:36:09.787665+00', '2026-08-04 13:13:06.756202+00', NULL);


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."profiles" ("id", "updated_at", "username", "avatar_url") VALUES
	('1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-07-31 19:23:00.979+00', 'gurtson', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/1785525780537.png');


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
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata") VALUES
	('b3a14cde-f47d-4d5b-9676-38236615bc90', 'avatars', '.emptyFolderPlaceholder', NULL, '2026-07-31 19:20:21.137476+00', '2026-07-31 19:20:21.137476+00', '2026-07-31 19:20:21.137476+00', '{"eTag": "\"d41d8cd98f00b204e9800998ecf8427e\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-07-31T19:20:21.143Z", "contentLength": 0, "httpStatusCode": 200}', '6157c7af-f262-4837-9062-649222f36a57', NULL, '{}'),
	('6eb7cf56-29b0-4d98-b032-a1adcae5ebdf', 'avatars', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/1785525780537.png', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-07-31 19:22:58.711404+00', '2026-07-31 19:22:58.711404+00', '2026-07-31 19:22:58.711404+00', '{"eTag": "\"ebe7988bbc1193f87b8b80c63ca64689\"", "size": 67127, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-07-31T19:22:59.000Z", "contentLength": 67127, "httpStatusCode": 200}', '391e03f3-334a-44f2-ae25-85269a66ac2d', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('c408d582-6f45-47d4-9d57-2bfebdf229e1', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/.emptyFolderPlaceholder', NULL, '2026-08-03 18:51:04.204835+00', '2026-08-03 18:51:04.204835+00', '2026-08-03 18:51:04.204835+00', '{"eTag": "\"d41d8cd98f00b204e9800998ecf8427e\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-08-03T18:51:04.203Z", "contentLength": 0, "httpStatusCode": 200}', '2f5f8428-bca6-46ac-8299-2a072d0415bb', NULL, '{}'),
	('54fa5ddf-f724-46f6-93de-00327cd5afe7', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/3e98cf7f-2142-473f-a3b0-0f3ee60718b3.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-03 22:50:09.755263+00', '2026-08-03 22:50:09.755263+00', '2026-08-03 22:50:09.755263+00', '{"eTag": "\"cd9a9540255dd6ec05f77dc9d8f5a858\"", "size": 175688, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-03T22:50:10.000Z", "contentLength": 175688, "httpStatusCode": 200}', '81f59449-a3dd-4af3-a3c9-16e85462be0a', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('aa3671bf-bf15-4595-a935-19b6004d7942', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/0c9b8f7c-68af-460c-ad1c-d012a5f4825c.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-03 22:57:52.6516+00', '2026-08-03 22:57:52.6516+00', '2026-08-03 22:57:52.6516+00', '{"eTag": "\"e0b488f0542b7565061ad48cc9886713\"", "size": 413876, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-03T22:57:53.000Z", "contentLength": 413876, "httpStatusCode": 200}', 'f7a48695-2332-4167-b430-98314160266e', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('7f15cd40-b2d9-47fc-a3fb-e6c7b207be4c', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/55ceb063-8fbe-4e27-a880-b31d95083715.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 01:35:40.159558+00', '2026-08-04 01:35:40.159558+00', '2026-08-04 01:35:40.159558+00', '{"eTag": "\"a0f76d7e9ad02d5ea3c24bca9c620cbe\"", "size": 435566, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T01:35:41.000Z", "contentLength": 435566, "httpStatusCode": 200}', '753f24e7-2394-4a6f-9628-6f9686c9ff5a', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('c4928fdd-a13c-4eb7-be1f-f732040e8a82', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/4ab79c90-27ed-420e-842a-acb393766389.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 01:35:48.495627+00', '2026-08-04 01:35:48.495627+00', '2026-08-04 01:35:48.495627+00', '{"eTag": "\"18ad2ec8fcfeed8c3deca61fb1a4d2c1\"", "size": 586854, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T01:35:49.000Z", "contentLength": 586854, "httpStatusCode": 200}', '50520bcc-86b6-4712-9c5d-4a44b0467b2a', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('97693ac6-0e70-4ccd-ab58-29be1fafba70', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/a49bc046-2ac8-4407-9b5f-24088def51ed.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 01:35:58.218145+00', '2026-08-04 01:35:58.218145+00', '2026-08-04 01:35:58.218145+00', '{"eTag": "\"77ed65970a39eeadf2d75d77f2ac748f\"", "size": 565390, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T01:35:59.000Z", "contentLength": 565390, "httpStatusCode": 200}', '884d19ed-fd27-45ac-81ee-cf5208aa680d', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('d4846802-6981-4a54-bf0c-7bc74ba3c4c8', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/63f83552-5efe-4115-97db-87dde6028955.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 01:38:34.617586+00', '2026-08-04 01:38:34.617586+00', '2026-08-04 01:38:34.617586+00', '{"eTag": "\"79423cb289d58ea27134cafea89697f7\"", "size": 934868, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T01:38:35.000Z", "contentLength": 934868, "httpStatusCode": 200}', '68cbbed3-c15d-42aa-b036-c4753abcd9d4', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('13985920-7607-4346-aeaa-d658a93fd1a6', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/ada799cf-6ea4-42b6-b9ad-7b6942b533f3.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 02:58:26.282624+00', '2026-08-04 02:58:26.282624+00', '2026-08-04 02:58:26.282624+00', '{"eTag": "\"18ad2ec8fcfeed8c3deca61fb1a4d2c1\"", "size": 586854, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T02:58:27.000Z", "contentLength": 586854, "httpStatusCode": 200}', 'dfd150c1-8c23-4fd8-b4dd-c2dff45f3066', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('922ba4e1-440b-4147-8e0a-cf8f35290d24', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/a919100b-ad41-4081-b862-d41148a418a9.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 03:40:25.498471+00', '2026-08-04 03:40:25.498471+00', '2026-08-04 03:40:25.498471+00', '{"eTag": "\"cd9a9540255dd6ec05f77dc9d8f5a858\"", "size": 175688, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T03:40:26.000Z", "contentLength": 175688, "httpStatusCode": 200}', 'f3f98b93-2bca-4455-94ca-9c30b47ca841', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('dcb9fc5c-f5a8-4e65-a279-93554bb56684', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/4eb4115f-bc54-4e42-a64d-f8807ba33da8.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 03:46:07.768494+00', '2026-08-04 03:46:07.768494+00', '2026-08-04 03:46:07.768494+00', '{"eTag": "\"cd9a9540255dd6ec05f77dc9d8f5a858\"", "size": 175688, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T03:46:08.000Z", "contentLength": 175688, "httpStatusCode": 200}', '27e0b972-9046-4d8e-af10-67c5188cdae3', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('00a40831-bb92-4b26-898c-f12f1011b34c', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/6e772a40-f4c4-47dd-83b8-ff19e21240f9.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 03:48:36.442788+00', '2026-08-04 03:48:36.442788+00', '2026-08-04 03:48:36.442788+00', '{"eTag": "\"18ad2ec8fcfeed8c3deca61fb1a4d2c1\"", "size": 586854, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T03:48:37.000Z", "contentLength": 586854, "httpStatusCode": 200}', '303ca73b-f009-4622-803a-86f8035dd6f3', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('0814cc82-b1f8-414d-b1ac-27ec1c668335', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/1483cf52-32da-4395-bed0-c599e68db71c.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 03:53:04.900653+00', '2026-08-04 03:53:04.900653+00', '2026-08-04 03:53:04.900653+00', '{"eTag": "\"a0f76d7e9ad02d5ea3c24bca9c620cbe\"", "size": 435566, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T03:53:05.000Z", "contentLength": 435566, "httpStatusCode": 200}', '31c78c02-89c2-4eab-bc18-b8bfc21e0f9b', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('be96513d-0106-4553-9e18-7efbd3939f60', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/8c7f0add-787b-49a7-8314-b622152d8798.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 04:26:49.006962+00', '2026-08-04 04:26:49.006962+00', '2026-08-04 04:26:49.006962+00', '{"eTag": "\"cd9a9540255dd6ec05f77dc9d8f5a858\"", "size": 175688, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T04:26:49.000Z", "contentLength": 175688, "httpStatusCode": 200}', 'cb5cbf20-099f-4863-8db9-55d65236f5d7', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('eff5358b-1a4a-45be-8c22-d4f5612c9ab7', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/e913836d-1fea-4d66-9896-45e73ff94299.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 04:28:04.520043+00', '2026-08-04 04:28:04.520043+00', '2026-08-04 04:28:04.520043+00', '{"eTag": "\"cd9a9540255dd6ec05f77dc9d8f5a858\"", "size": 175688, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T04:28:05.000Z", "contentLength": 175688, "httpStatusCode": 200}', '3fb65e01-4390-49c8-a6e5-e10798ab3e94', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('cf06aa98-3de5-4cc0-a57a-32e2ba5a3fca', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/b881b876-ec3a-4ffb-a4df-41f354904f63.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 04:30:31.705257+00', '2026-08-04 04:30:31.705257+00', '2026-08-04 04:30:31.705257+00', '{"eTag": "\"a0f76d7e9ad02d5ea3c24bca9c620cbe\"", "size": 435566, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T04:30:32.000Z", "contentLength": 435566, "httpStatusCode": 200}', '0bc5455f-bf3d-4300-b6ca-fe8b27b1f8a7', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('5ad3eba8-9cac-4ea0-b00a-9ff867dc026b', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/faf71baf-072d-4ee3-add8-4d3a74e8e3ef.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 04:31:56.006665+00', '2026-08-04 04:31:56.006665+00', '2026-08-04 04:31:56.006665+00', '{"eTag": "\"e0b488f0542b7565061ad48cc9886713\"", "size": 413876, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T04:31:56.000Z", "contentLength": 413876, "httpStatusCode": 200}', 'bd9c5a52-7a02-4e7e-b85c-e0c48f079ed2', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('681bd820-b07b-42c5-85d1-f7ed4fa91ec7', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/8a78af8e-e5d8-454c-ada2-00a18c6e082d.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 04:32:11.398249+00', '2026-08-04 04:32:11.398249+00', '2026-08-04 04:32:11.398249+00', '{"eTag": "\"e0b488f0542b7565061ad48cc9886713\"", "size": 413876, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T04:32:12.000Z", "contentLength": 413876, "httpStatusCode": 200}', '22232789-9585-4ef3-8ef9-a4bbcbce4cdb', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('19792389-15b1-4560-9b1d-59dacd18bff5', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/480eede0-e4e4-4ba7-940c-2bace9a4ede4.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 04:33:35.017307+00', '2026-08-04 04:33:35.017307+00', '2026-08-04 04:33:35.017307+00', '{"eTag": "\"18ad2ec8fcfeed8c3deca61fb1a4d2c1\"", "size": 586854, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T04:33:35.000Z", "contentLength": 586854, "httpStatusCode": 200}', '279a465d-61cd-4c28-889a-032f48fb3ff2', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('b127ad80-8359-4e33-a538-969d377483b8', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/d90d894e-11e7-4318-b1a3-6327d503d4a4.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 04:36:09.691874+00', '2026-08-04 04:36:09.691874+00', '2026-08-04 04:36:09.691874+00', '{"eTag": "\"cd9a9540255dd6ec05f77dc9d8f5a858\"", "size": 175688, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T04:36:10.000Z", "contentLength": 175688, "httpStatusCode": 200}', '78e92944-da4e-4d09-bc24-05a26093c575', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('ed05eeb4-a45a-48ed-ae41-235b4a2b037d', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/a6c9686b-b077-40a2-a6ba-a8c766d800c4.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 04:37:38.608343+00', '2026-08-04 04:37:38.608343+00', '2026-08-04 04:37:38.608343+00', '{"eTag": "\"e0b488f0542b7565061ad48cc9886713\"", "size": 413876, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T04:37:39.000Z", "contentLength": 413876, "httpStatusCode": 200}', '5512c51a-8a96-433d-bd31-360dc854de75', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('150d01b1-fd9a-4a4e-8fd1-fdcb59553093', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/ee3ff5f4-dd03-46cf-88c4-040d21931e45.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 13:11:28.949519+00', '2026-08-04 13:11:28.949519+00', '2026-08-04 13:11:28.949519+00', '{"eTag": "\"18ad2ec8fcfeed8c3deca61fb1a4d2c1\"", "size": 586854, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T13:11:29.000Z", "contentLength": 586854, "httpStatusCode": 200}', '1aff155b-41d4-481c-9a0d-0149c1b40f55', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('29b67638-0533-417f-86f2-c445e1ab7bb6', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/fe4da327-58a3-4bc8-ad91-7e2428f28336.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 13:11:40.468107+00', '2026-08-04 13:11:40.468107+00', '2026-08-04 13:11:40.468107+00', '{"eTag": "\"e0b488f0542b7565061ad48cc9886713\"", "size": 413876, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T13:11:41.000Z", "contentLength": 413876, "httpStatusCode": 200}', 'a86d6ea1-eef1-4200-be86-2f80c0153272', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('60302ae3-0e46-4f21-91f4-e91f5e39486a', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/5cfd1397-aee2-428a-9af8-84e0aa67fefb.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 13:11:48.566136+00', '2026-08-04 13:11:48.566136+00', '2026-08-04 13:11:48.566136+00', '{"eTag": "\"5886d9be14ae221fe613caed7102471a\"", "size": 843470, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T13:11:49.000Z", "contentLength": 843470, "httpStatusCode": 200}', '818b138e-e236-4a75-9334-247e50362810', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}'),
	('014285a3-c9dd-4575-b6f2-b2b62428db42', 'photos', '1657d2b1-6215-41cf-bec2-bcc02ade02ba/bc3473be-951a-406b-9ac3-b07078d29000.webp', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '2026-08-04 13:12:13.847209+00', '2026-08-04 13:12:13.847209+00', '2026-08-04 13:12:13.847209+00', '{"eTag": "\"77ed65970a39eeadf2d75d77f2ac748f\"", "size": 565390, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-08-04T13:12:14.000Z", "contentLength": 565390, "httpStatusCode": 200}', '0a05c34c-c999-42a3-910a-069fcc665dad', '1657d2b1-6215-41cf-bec2-bcc02ade02ba', '{}');


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
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 22, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict rCioFTaxXMw5tYPscKZvodKdNeZ4MrlhJntk1LUme73kn5hz4SG7C5MVtiBkDZa

RESET ALL;
