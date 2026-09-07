# `/proc/self` は「誰のself」なのかを観察する

Bashの `$$` と、別プロセスである `awk` が読む `/proc/self/status` を比べます。Linux kernel documentationの「selfは、そのfilesystemを読むprocessを指す」を目で確認するサンプルです。

## 面白いところ

Bashから次を実行していても、`/proc/self/status` を実際にopen/readするのが `awk` なら、そこに見えるPidはawk自身になります。

```text
[SHELL] Bash PID = 589
[OBSERVE 2]
Name: awk
Pid: 593
PPid: 589
```

## 安全性

`status` など読み取り専用の情報だけを対象にします。`/proc/*/environ` は秘密情報を含む可能性があるため、このサンプルでは読みません。

## 検証状態

2026-09-07、Debian GNU/Linux 13 / Bash 5.2.37 で実行確認済み。Ubuntu実機では別途未確認です。

## 公式情報

- Linux Kernel Documentation — The /proc Filesystem: https://docs.kernel.org/filesystems/proc.html
