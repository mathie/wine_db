--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: classifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE classifications (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    designation character varying NOT NULL,
    classification character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    search_vector tsvector
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    parent_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    search_vector tsvector
);


--
-- Name: lwin_identifiers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lwin_identifiers (
    id integer NOT NULL,
    identifier character varying NOT NULL,
    status integer NOT NULL,
    identifier_updated_at date NOT NULL,
    wine_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    search_vector tsvector
);


--
-- Name: lwin_identifiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lwin_identifiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lwin_identifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lwin_identifiers_id_seq OWNED BY lwin_identifiers.id;


--
-- Name: producers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE producers (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    search_vector tsvector
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: wines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wines (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    colour integer DEFAULT 0 NOT NULL,
    wine_type integer DEFAULT 0 NOT NULL,
    producer_id uuid,
    location_id uuid NOT NULL,
    classification_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    search_vector tsvector
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lwin_identifiers ALTER COLUMN id SET DEFAULT nextval('lwin_identifiers_id_seq'::regclass);


--
-- Name: classifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY classifications
    ADD CONSTRAINT classifications_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: lwin_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lwin_identifiers
    ADD CONSTRAINT lwin_identifiers_pkey PRIMARY KEY (id);


--
-- Name: producers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY producers
    ADD CONSTRAINT producers_pkey PRIMARY KEY (id);


--
-- Name: wines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wines
    ADD CONSTRAINT wines_pkey PRIMARY KEY (id);


--
-- Name: index_classifications_on_designation_and_classification; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_classifications_on_designation_and_classification ON classifications USING btree (designation, classification);


--
-- Name: index_classifications_on_search_vector; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classifications_on_search_vector ON classifications USING gin (search_vector);


--
-- Name: index_locations_on_parent_id_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_locations_on_parent_id_and_name ON locations USING btree (parent_id, name);


--
-- Name: index_locations_on_search_vector; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_search_vector ON locations USING gin (search_vector);


--
-- Name: index_lwin_identifiers_on_identifier; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_lwin_identifiers_on_identifier ON lwin_identifiers USING btree (identifier);


--
-- Name: index_lwin_identifiers_on_search_vector; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lwin_identifiers_on_search_vector ON lwin_identifiers USING gin (search_vector);


--
-- Name: index_producers_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_producers_on_name ON producers USING btree (name);


--
-- Name: index_producers_on_search_vector; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_producers_on_search_vector ON producers USING gin (search_vector);


--
-- Name: index_wines_on_search_vector; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_wines_on_search_vector ON wines USING gin (search_vector);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: classifications_search_vector_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER classifications_search_vector_update BEFORE INSERT OR UPDATE ON classifications FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('search_vector', 'pg_catalog.english', 'designation', 'classification');


--
-- Name: locations_search_vector_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER locations_search_vector_update BEFORE INSERT OR UPDATE ON locations FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('search_vector', 'pg_catalog.english', 'name');


--
-- Name: lwin_identifiers_search_vector_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER lwin_identifiers_search_vector_update BEFORE INSERT OR UPDATE ON lwin_identifiers FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('search_vector', 'pg_catalog.english', 'identifier');


--
-- Name: producers_search_vector_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER producers_search_vector_update BEFORE INSERT OR UPDATE ON producers FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('search_vector', 'pg_catalog.english', 'name');


--
-- Name: wines_search_vector_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER wines_search_vector_update BEFORE INSERT OR UPDATE ON wines FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('search_vector', 'pg_catalog.english', 'name');


--
-- Name: fk_rails_0cdd19cca2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT fk_rails_0cdd19cca2 FOREIGN KEY (parent_id) REFERENCES locations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fk_rails_4e220a279b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY wines
    ADD CONSTRAINT fk_rails_4e220a279b FOREIGN KEY (location_id) REFERENCES locations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fk_rails_68591a5bb5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY wines
    ADD CONSTRAINT fk_rails_68591a5bb5 FOREIGN KEY (producer_id) REFERENCES producers(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fk_rails_86d26ef3c0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY wines
    ADD CONSTRAINT fk_rails_86d26ef3c0 FOREIGN KEY (classification_id) REFERENCES classifications(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fk_rails_d4e8ca76a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lwin_identifiers
    ADD CONSTRAINT fk_rails_d4e8ca76a6 FOREIGN KEY (wine_id) REFERENCES wines(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150112164948');

INSERT INTO schema_migrations (version) VALUES ('20150112172627');

INSERT INTO schema_migrations (version) VALUES ('20150113155025');

INSERT INTO schema_migrations (version) VALUES ('20150113173000');

INSERT INTO schema_migrations (version) VALUES ('20150113190459');

INSERT INTO schema_migrations (version) VALUES ('20150119080948');

