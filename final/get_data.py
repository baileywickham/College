import yfinance as yf

gme = yf.Ticker('GME')
print(gme.info)
gme.history(period='max').to_csv('gme')
