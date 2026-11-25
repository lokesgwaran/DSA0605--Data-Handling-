import streamlit as st
import pandas as pd
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from pathlib import Path

st.set_page_config(page_title="Intelligent Stock Market Analytics", page_icon="📈", layout="wide")
st.title("📈 Intelligent Stock Market Analytics & Investment Insights")
st.caption("Educational analytics dashboard. Not investment advice. Demo dataset is synthetic.")

@st.cache_data
def load_demo():
    return pd.read_csv(Path(__file__).parent / "data" / "sample_stock_data.csv", parse_dates=["Date"])

def clean_data(df):
    df=df.copy()
    df.columns=[str(c).strip().title() for c in df.columns]
    if "Date" not in df.columns or "Close" not in df.columns:
        raise ValueError("Data must contain Date and Close columns. Open, High, Low and Volume are recommended.")
    df["Date"]=pd.to_datetime(df["Date"],errors="coerce")
    for col in ["Open","High","Low","Close","Volume"]:
        if col in df.columns: df[col]=pd.to_numeric(df[col],errors="coerce")
    df=df.dropna(subset=["Date","Close"]).sort_values("Date").drop_duplicates("Date")
    df=df[df["Close"]>0]
    return df

def calculate(df):
    d=df.copy()
    d["Return"]=d["Close"].pct_change()
    d["SMA20"]=d["Close"].rolling(20).mean()
    d["SMA50"]=d["Close"].rolling(50).mean()
    d["EMA12"]=d["Close"].ewm(span=12,adjust=False).mean()
    d["EMA26"]=d["Close"].ewm(span=26,adjust=False).mean()
    d["MACD"]=d["EMA12"]-d["EMA26"]
    d["MACD_Signal"]=d["MACD"].ewm(span=9,adjust=False).mean()
    delta=d["Close"].diff()
    gain=delta.clip(lower=0).rolling(14).mean()
    loss=(-delta.clip(upper=0)).rolling(14).mean()
    rs=gain/(loss.replace(0,np.nan))
    d["RSI14"]=100-(100/(1+rs))
    # RSI edge cases: if there are no losses in window, RSI tends to 100
    d["RSI14"]=d["RSI14"].fillna(50)
    d["Volatility252"]=d["Return"].rolling(252).std()*np.sqrt(252)
    peak=d["Close"].cummax()
    d["Drawdown"]=d["Close"]/peak-1
    return d

def risk_stats(d):
    r=d["Return"].dropna()
    if len(r)<2:return {}
    vol=float(r.std()*np.sqrt(252))
    dd=float(d["Drawdown"].min())
    var95=float(np.quantile(-r,0.95))
    return {"Annualized volatility":vol,"Maximum drawdown":dd,"Historical 95% daily VaR":var95}

st.sidebar.header("Data")
uploaded=st.sidebar.file_uploader("Upload CSV (Date and Close required)",type=["csv"])
if uploaded:
    try:
        raw=pd.read_csv(uploaded); data_source="Uploaded CSV"
    except Exception as e:
        st.error(f"Could not read CSV: {e}"); st.stop()
else:
    raw=load_demo(); data_source="Synthetic demo data"
st.sidebar.caption("For uploads, Date and Close are required. Open, High, Low and Volume are optional.")
try:
    df=clean_data(raw)
except Exception as e:
    st.error(str(e)); st.stop()
if len(df)<30:
    st.warning("Dataset is short; some indicators may not be meaningful.")

df=calculate(df)
min_date=df["Date"].min().date(); max_date=df["Date"].max().date()
start,end=st.sidebar.date_input("Date range",value=(min_date,max_date),min_value=min_date,max_value=max_date)
if isinstance(start,tuple): start,end=start
view=df[(df["Date"].dt.date>=start)&(df["Date"].dt.date<=end)].copy()
if view.empty: st.warning("No rows in this date range.");st.stop()

st.caption(f"Data source: {data_source} | {len(view):,} rows in selected period | {view['Date'].min().date()} to {view['Date'].max().date()}")
last=view.iloc[-1]
stats=risk_stats(view)
cols=st.columns(4)
cols[0].metric("Latest close",f"{last['Close']:,.2f}")
cols[1].metric("Period change",f"{(view['Close'].iloc[-1]/view['Close'].iloc[0]-1)*100:.2f}%")
cols[2].metric("Annualized volatility",f"{stats.get('Annualized volatility',float('nan'))*100:.2f}%")
cols[3].metric("Maximum drawdown",f"{stats.get('Maximum drawdown',float('nan'))*100:.2f}%")

st.subheader("Price & moving averages")
fig=go.Figure()
fig.add_trace(go.Scatter(x=view.Date,y=view.Close,name="Close",mode="lines"))
fig.add_trace(go.Scatter(x=view.Date,y=view.SMA20,name="SMA 20",mode="lines"))
fig.add_trace(go.Scatter(x=view.Date,y=view.SMA50,name="SMA 50",mode="lines"))
fig.update_layout(height=450,xaxis_title="Date",yaxis_title="Price",legend_title="Series",hovermode="x unified")
st.plotly_chart(fig,use_container_width=True)

if "Volume" in view:
    st.subheader("Trading volume")
    st.plotly_chart(go.Figure(go.Bar(x=view.Date,y=view.Volume,name="Volume")).update_layout(height=250,xaxis_title="Date",yaxis_title="Volume"),use_container_width=True)

st.subheader("RSI (14)")
st.plotly_chart(go.Figure(go.Scatter(x=view.Date,y=view.RSI14,mode="lines",name="RSI 14")).update_layout(height=280,yaxis=dict(range=[0,100]),xaxis_title="Date"),use_container_width=True)
st.subheader("MACD (12, 26, 9)")
macdfig=go.Figure()
macdfig.add_trace(go.Scatter(x=view.Date,y=view.MACD,name="MACD",mode="lines"))
macdfig.add_trace(go.Scatter(x=view.Date,y=view.MACD_Signal,name="Signal",mode="lines"))
macdfig.update_layout(height=280,xaxis_title="Date")
st.plotly_chart(macdfig,use_container_width=True)

st.subheader("Risk measures")
st.write("Historical daily Value at Risk (95%) estimates a percentile of observed daily losses. It is not a worst-case loss estimate.")
for k,v in stats.items():
    st.write(f"**{k}:** {v*100:.2f}%")
st.subheader("Data preview")
st.dataframe(view.tail(25),use_container_width=True)
csv=view.to_csv(index=False).encode("utf-8")
st.download_button("Download selected data and indicators as CSV",csv,"stock_analytics_output.csv","text/csv")
st.info("Indicators describe historical data. They are not guaranteed signals or personalized recommendations.")
