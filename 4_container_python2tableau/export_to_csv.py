import os
import pandas as pd
from clickhouse_driver import Client

ch_client = Client(host='clickhouse', port=9000, user='admin', password='admin')

output_dir = '/data/tableau'
os.makedirs(output_dir, exist_ok=True)

marts = ['mart_operations', 'mart_finance', 'mart_service_quality']

for mart in marts:
    print(f"Exporting {mart}...")
    rows, columns = ch_client.execute(
        f"SELECT * FROM taxi_marts.{mart}",
        with_column_types=True
    )
    col_names = [col[0] for col in columns]
    df = pd.DataFrame(rows, columns=col_names)
    df.to_csv(f"{output_dir}/{mart}.csv", index=False)
    print(f"{mart} exported: {len(df)} rows")

print("Done!")
