CREATE OR REPLACE FUNCTION index_size(index_name text) RETURNS bigint AS $$
DECLARE
    total_size bigint;
BEGIN
    SELECT pg_total_relation_size(index_name) INTO total_size
    FROM pg_indexes
    WHERE indexname = index_name;

    RETURN total_size;
END;
$$ LANGUAGE plpgsql;