# Python ipaddressでCIDR境界を観察

Python標準ライブラリ `ipaddress` だけで、CIDRからnetwork address、broadcast address、利用可能host数を表示します。外部通信は行いません。

## 実行

```bash
python3 demo.py 192.168.1.0/24
python3 demo.py 10.0.0.0/30
```

入力したnetworkの境界がどう変わるかを比較します。

[Python documentation — ipaddress](https://docs.python.org/3/library/ipaddress.html)

検証状態: Python公式仕様確認済み。実行再確認は未実施。
