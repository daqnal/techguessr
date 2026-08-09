-- Migration unit 1: schema_changes
-- Transaction mode: transactional
-- Boundary reason: default

ALTER TABLE public.photos
  DROP COLUMN long;

ALTER TABLE public.photos
  ADD COLUMN lng double precision;