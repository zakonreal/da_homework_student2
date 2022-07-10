import os
import requests
import yfinance as yf
import pandas as pd
import matplotlib.pyplot as plt
import seaborn
from bs4 import BeautifulSoup
import numpy as np
from tqdm.auto import tqdm
from pylab import rcParams
from datetime import datetime
from conf import customers, costs, discounts, prices_path


seaborn.set()

# Подгружаем котировки курсы
print("Подгружаем котировки и курсы")
df_rubber = pd.DataFrame()
for i in ['2019', '2020', '2021', '2022']:
  for j in ['01', '02', '03', '04','05', '06', '07', '08','09', '10', '11', '12']:
    url = f"https://www.lgm.gov.my/webv2api/api/rubberprice/month={j}&year={i}"
    res = requests.get(url)
    rj = res.json()
    df1 = pd.json_normalize(rj)
    df_rubber = df_rubber.append(df1, ignore_index=True)
    
DF = df_rubber.set_index('date')
DFF = DF.rename(columns={'us': 'Close'})
DFF.index = pd.to_datetime(DFF.index)
DFF = DFF.astype({'Close': np.float})
df_rubber_m = DFF.Close.resample('M').mean()

df_dict = {}
for ticker in tqdm(['USDRUB=X', 'EURUSD=X', 'EURRUB=X']):
    df = yf.download(ticker, progress=False)
    df = df.Close.copy()
    df = df.resample('M').mean()
    df_dict[ticker] = df

# Рассчитываем цены
print("Рассчитываем цены")
main_df = pd.concat(df_dict.values(), axis=1)
main_df = pd.concat([df_rubber_m, main_df], axis=1)
main_df.columns = ['CRUDE_RUBBER_USD', 'USDRUB', 'EURUSD', 'EURRUB']
main_df = main_df.loc['2019-06-30':].copy()
main_df['MWP_PRICE_EUR'] = main_df.CRUDE_RUBBER_USD * (1 / main_df.EURUSD)
main_df['MWP_PRICE_USD'] = main_df.CRUDE_RUBBER_USD
main_df['MWP_PRICE_RUB'] = main_df.CRUDE_RUBBER_USD * main_df.USDRUB
main_df['MWP_PRICE_EUR_EU'] = main_df['MWP_PRICE_EUR'] + costs.get('EU_LOGISTIC_COST_EUR')
main_df['MWP_PRICE_USD_CN'] = main_df['MWP_PRICE_USD'] + costs.get('CN_LOGISTIC_COST_USD')
main_df['MWP_PRICE_EUR_EU_MA'] = main_df.MWP_PRICE_EUR_EU.rolling(window=3).mean()
main_df['MWP_PRICE_USD_RU'] = main_df['MWP_PRICE_RUB']

# Создаем отдельный файл для каждого из клиентов

rcParams['figure.figsize'] = 15,7

print("Готовим отдельный файл для клиентов")
for client, v in customers.items():

    # Создаем директорию и путь к файлу
    client_price_path = os.path.join(prices_path, f"{client.lower()}")
    if not os.path.exists(client_price_path ):
        os.makedirs(client_price_path)

    calculation_date = datetime.today().date().strftime(format="%d%m%Y")
    client_price_file_path = os.path.join(client_price_path, f'{client}_mwp_price_{calculation_date}.xlsx')

    location = v.get('location')
    disc = 0.0
    if v.get('location') == "EU":
        fl = 0
        for k_lim, discount_share in discounts.items():
            if v.get('volumes') > k_lim:
                continue
            else:
                disc = discount_share
                fl = 1
                break
        if fl == 0:
            disc = discounts.get(max(discounts.keys()))

        if v.get('comment') == 'monthly':
            client_price = main_df['MWP_PRICE_EUR_EU'].mul((1 - disc)).add(costs.get('EU_LOGISTIC_COST_EUR')).round(2)
        elif v.get('comment') == 'moving_average':
            client_price = main_df['MWP_PRICE_EUR_EU_MA'].mul((1 - disc)).add(costs.get('EU_LOGISTIC_COST_EUR')).round(2)

    elif v.get('location') == 'CN':
        fl = 0
        for k_lim, discount_share in discounts.items():
            if v.get('volumes') > k_lim:
                continue
            else:
                disc = discount_share
                fl = 1
                break
        if fl == 0:
            disc = discounts.get(max(discounts.keys()))

        client_price = main_df['MWP_PRICE_USD_CN'].mul((1 - disc)).add(costs.get('CN_LOGISTIC_COST_USD')).round(2)
    print(client_price.head())
    with pd.ExcelWriter(client_price_file_path, engine='xlsxwriter') as writer:
        client_price.to_excel(writer, sheet_name='price')

        # Добавляем график с ценой
        plot_path = f'{client}_wbp.png'
        plt.title('Цена ВБП(DDP)', fontsize=16, fontweight='bold')
        plt.plot(client_price)
        plt.savefig(plot_path)
        plt.close()

        worksheet = writer.sheets['price']
        worksheet.insert_image('C2', plot_path)

    print(f"{client} готов")

print("Удаляем ненужные файлы")
for k, v in customers.items():
    if os.path.exists(f"{k}_wbp.png"):
        os.remove(f"{k}_wbp.png")

# Добавляем нового клиента из России
print("Добавляем нового клиента из России")
with pd.ExcelWriter('price_proposal_RU.xlsx', engine = 'xlsxwriter') as writer:
        client_price = main_df['MWP_PRICE_USD_RU']
 
       # print(client, v, disc)
        client_price.to_excel(writer, sheet_name='price_proposal_RU')
        # Добавляем график с ценой
        plot_path = f'{client}_wbp.png'
        plt.title('Цена ВБП(DDP)', fontsize=16, fontweight='bold')
        plt.plot(client_price)
        plt.savefig(plot_path)
        plt.show()
        worksheet = writer.sheets['price_proposal_RU']
        worksheet.insert_image('C2',plot_path)        
print(f"{client} готов")        
        
print("Работа завершена!")