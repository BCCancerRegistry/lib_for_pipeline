CREATE ROLE bccancer_admin WITH
  LOGIN
  SUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'md5057afd3d29b2df7a535e890d5020d7bc';

-- Role: bccancer_de_ro_gp
-- DROP ROLE IF EXISTS bccancer_de_ro_gp;

CREATE ROLE bccancer_de_ro_gp WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

-- Role: bccancer_de_ro_user
-- DROP ROLE IF EXISTS bccancer_de_ro_user;

CREATE ROLE bccancer_de_ro_user WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'md5d6884f157991c05469e264f044af7ad0';


-- Role: bccancer_de_rw_gp
-- DROP ROLE IF EXISTS bccancer_de_rw_gp;

CREATE ROLE bccancer_de_rw_gp WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
-- Role: bccancer_de_rw_user
-- DROP ROLE IF EXISTS bccancer_de_rw_user;

CREATE ROLE bccancer_de_rw_user WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'md5e997ebbf7de75f298ab810285e985996';

GRANT bccancer_de_rw_gp TO bccancer_de_rw_user;
GRANT bccancer_de_ro_gp, bccancer_de_rw_gp TO bccancer_admin WITH ADMIN OPTION;
GRANT bccancer_de_ro_gp TO bccancer_de_ro_user;