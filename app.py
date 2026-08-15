import streamlit as st
import pandas as pd
import numpy as np

# Set the page title
st.title("Drugs")

# Add a simple header and text description
st.header("Welcome!")
st.write("Search for a drug to see its details and visualize trends.")

# Create an interactive sidebar slider widget
st.sidebar.header("Settings")
data_points = st.sidebar.slider("Number of data points", min_value=10, max_value=200, value=100)

drug_name = st.text_input(
    label="Enter drug name:",
    value="Ibuprofen",          # Optional default value
    max_chars=50,              # Optional character limit
    help="Please enter the name of the drug you are searching for." # Optional tooltip
)

# Generate mock data based on the slider input
# chart_data = pd.DataFrame(
#     np.random.randn(data_points, 3),
#     columns=['Metric A', 'Metric B', 'Metric C']
# )

# Display an interactive line chart
# st.subheader("Random Trend Visualizer")
# st.line_chart(chart_data)

# Display the underlying data frame if the user checks a box
# if st.checkbox("Show raw data"):
#     st.subheader("Raw Data Table")
#     st.dataframe(chart_data)
