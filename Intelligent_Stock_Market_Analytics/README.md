# Intelligent Stock Market Analytics and Investment Insights Platform

## Run on Windows
1. Extract this folder from the ZIP.
2. Install Python 3.10+ from https://www.python.org/downloads/ (enable Add Python to PATH).
3. Double-click `RUN_APP.bat`. It installs the required Python packages and launches the dashboard.
4. Streamlit will open a browser tab (usually http://localhost:8501).

## Features
- Upload your own CSV or use the included demo data.
- Price chart and 20/50-day moving averages.
- RSI (14), MACD (12,26,9), volume.
- Annualized volatility, maximum drawdown, historical daily 95% VaR.
- Date range filter, data preview and CSV download.

## CSV requirements
Required: `Date`, `Close`.
Optional: `Open`, `High`, `Low`, `Volume`.
Date should be parseable. Prices should be positive. The app sorts dates and removes duplicate dates.

## Demo data
`data/sample_stock_data.csv` is **synthetically generated** for demonstration. It is not real stock market history. Results from it are illustrative only.

## Disclaimer
This project is for education and demonstration, not investment advice. Historical metrics and indicators do not guarantee future results.

## Troubleshooting
- If `py` is unavailable, try installing Python with the PATH option enabled.
- If the app does not start, open Command Prompt in this folder and run:
  `python -m pip install -r requirements.txt`
  then `python -m streamlit run app.py`
