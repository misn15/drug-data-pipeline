-- NDC Drug API Raw Tables
CREATE TABLE raw_ndc_product (
    product_id TEXT PRIMARY KEY,
    product_ndc TEXT,
    generic_name TEXT,
    labeler_name TEXT,
    brand_name TEXT,
    brand_name_base TEXT,
    finished BOOLEAN,
    listing_expiration_date DATE,
    marketing_category TEXT,
    dosage_form TEXT,
    spl_id TEXT,
    product_type TEXT,
    marketing_start_date DATE,
    application_number TEXT,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE raw_ndc_active_ingredient (
    product_id TEXT,
    product_ndc TEXT,
    ingredient TEXT,
    strength TEXT,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE raw_ndc_pharm_class (
    product_id TEXT,
    product_ndc TEXT,
    pharm_class TEXT,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- NDC Drug API Transformed Tables 
CREATE TABLE drugs (
    id SERIAL PRIMARY KEY,
    spl_id VARCHAR(50),
    drug_id VARCHAR(50),
    ndc_code VARCHAR(20) NOT NULL,
    generic_name VARCHAR(255) NOT NULL,
    brand_name VARCHAR(255),
    labeler VARCHAR(255),
    product_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE active_ingredients (
    id SERIAL PRIMARY KEY,
    ingredient_name VARCHAR(255) NOT NULL,
    strength VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE drug_ingredients (
    id SERIAL PRIMARY KEY,
    drug_id INT REFERENCES drugs (id) ON DELETE CASCADE,
    ingredient_id INT REFERENCES active_ingredients (id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE dosage_type (
    id SERIAL PRIMARY KEY,
    dosage_form VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE drug_dosage (
    id SERIAL PRIMARY KEY,
    dosage_form VARCHAR(50) REFERENCES dosage_type (dosage_form) ON DELETE CASCADE,
    drug_id INT REFERENCES drugs (id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE pharm_class (
    id SERIAL PRIMARY KEY,
    pharm_class VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE drug_pharm_class (
    id SERIAL PRIMARY KEY,
    drug_id INT REFERENCES drugs (id) ON DELETE CASCADE,
    pharm_class_id INT REFERENCES pharm_class (id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
