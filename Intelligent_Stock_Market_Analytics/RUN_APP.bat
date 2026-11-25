@echo off
cd /d "%~dp0"
echo Setting up stock analytics dashboard...
py -m pip install -r requirements.txt
if errorlevel 1 (
  python -m pip install -r requirements.txt
)
echo.
echo Starting dashboard in your browser...
python -m streamlit run app.py
pause
