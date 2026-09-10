## FDA Drug Data Pipeline
### Overview

An end-to-end data engineering project using FDA open data to explore trends in the U.S. pharmaceutical landscape.

The pipeline ingests and transforms FDA drug data into a PostgreSQL database so that it can be used to answer questions such as:

- How are drug approvals changing over time?
- What types of drugs are being approved?
- What trends exist in reported adverse events?
- Are newer drugs associated with different patterns of adverse events?

This project combines drug approval, product, ingredient, classification and adverse-event data to provide a data-driven perspective on the pharmaceutical industry.

### Technologies
- Python — API ingestion and data transformation
- PostgreSQL — relational data storage
- SQL — querying and analysis
- Tableau — visualization and dashboarding
- openFDA API — datasource

### Data Sources
The project uses FDA open data, including:
- NDC Directory — drug products and packaging information
- Drugs@FDA — FDA-approved drug products and approval information
- Drug Adverse Events — reported adverse events and associated drug/reaction information
- Pharmaceutic classifications and ingredients — to analyze what types of drugs are being approved
