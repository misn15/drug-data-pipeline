-- Creating raw tables
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
    application_number TEXT
);

-- raw_ndc_product
-- raw_ndc_active_ingredient
-- raw_ndc_packaging
-- raw_ndc_route
-- raw_ndc_rxcui
-- raw_ndc_nui
-- raw_ndc_pharm_class
-- raw_ndc_pharm_class_epc
-- raw_ndc_pharm_class_moa
-- raw_ndc_unit
-- NDC API endpoint 
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
