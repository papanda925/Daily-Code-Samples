#!/usr/bin/env python3
from __future__ import annotations

import html
import json
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "_site"
BASE_URL = os.environ.get(
    "PAGES_BASE_URL",
    "https://papanda925.github.io/Daily-Code-Samples",
).rstrip("/")

CSS = """
:root{--bg:#f6f8fa;--card:#fff;--text:#1f2328;--muted:#59636e;--line:#d0d7de;--accent:#0969da}
*{box-sizing:border-box}body{margin:0;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI","Noto Sans JP",sans-serif;background:var(--bg);color:var(--text);line-height:1.65}
a{color:var(--accent)}.wrap{max-width:1100px;margin:auto;padding:28px 20px 60px}.hero h1{font-size:clamp(2rem,5vw,3.2rem);margin:.1em 0}.hero p{max-width:820px;color:var(--muted)}
.controls{display:grid;grid-template-columns:1fr 240px;gap:12px;margin:24px 0}.controls input,.controls select{padding:12px;border:1px solid var(--line);border-radius:10px;background:#fff;font-size:1rem}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:16px}.card,.detail{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:18px}
.card h2{font-size:1.15rem}.meta,.tags{display:flex;gap:6px;flex-wrap:wrap}.pill{font-size:.82rem;padding:3px 8px;border-radius:999px;background:#eef2f6}.summary,.count,footer{color:var(--muted)}
.kv{display:grid;grid-template-columns:150px 1fr;gap:8px 14px}.kv dt{font-weight:700}.kv dd{margin:0}.button{display:inline-block;padding:10px 14px;border-radius:10px;text-decoration:none;border:1px solid var(--line);margin:18px 8px 0 0}.primary{background:var(--accent);color:#fff;border-color:var(--accent)}
footer{margin-top:36px}@media(max-width:700px){.controls{grid-template-columns:1fr}.kv{grid-template-columns:1fr}}
"""

JS = """
const q=document.querySelector('#q'),cat=document.querySelector('#cat'),cards=[...document.querySelectorAll('.card')],count=document.querySelector('#count');
function apply(){const s=q.value.toLowerCase().trim(),c=cat.value;let n=0;for(const card of cards){const show=(!s||card.dataset.search.includes(s))&&(!c||card.dataset.categories.split('|').includes(c));card.hidden=!show;if(show)n++;}count.textContent=n+'件表示';}
q.addEventListener('input',apply);cat.addEventListener('change',apply);apply();
"""

def esc(v):
    return html.escape(str(v), quote=True)

def load_samples():
    items=[]
    for p in sorted((ROOT/"samples").glob("*/sample.json")):
        x=json.loads(p.read_text(encoding="utf-8-sig"))
        x["_folder"]=p.parent.name
        items.append(x)
    return items

def shell(title, description, canonical, body, structured=None):
    ld=""
    if structured is not None:
        raw=json.dumps(structured, ensure_ascii=False).replace("</","<\\/")
        ld=f'<script type="application/ld+json">{raw}</script>'
    return f"""<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{esc(title)}</title>
<meta name="description" content="{esc(description)}">
<link rel="canonical" href="{esc(canonical)}">
<meta property="og:title" content="{esc(title)}">
<meta property="og:description" content="{esc(description)}">
<meta property="og:url" content="{esc(canonical)}">
<style>{CSS}</style>
{ld}
</head>
<body><div class="wrap">{body}</div></body>
</html>"""

def build_index(items):
    cats=sorted({v for x in items for v in x.get("purposes",[])})
    cards=[]
    entries=[]
    for i,x in enumerate(items,1):
        searchable=" ".join([
            x.get("title",""),x.get("summary",""),
            *x.get("purposes",[]),*x.get("apps",[]),
            *x.get("methods",[]),*x.get("tags",[])
        ]).lower()
        pills="".join(f'<span class="pill">{esc(v)}</span>' for v in [*x.get("apps",[]),x.get("level_mark","")] if v)
        tags="".join(f'<span class="pill">{esc(v)}</span>' for v in x.get("tags",[])[:5])
        cards.append(f"""<article class="card" data-search="{esc(searchable)}" data-categories="{esc('|'.join(x.get('purposes',[])))}">
<div class="meta"><span class="pill">#{esc(x['id'])}</span>{pills}</div>
<h2><a href="./sample/{esc(x['id'])}/">{esc(x['title'])}</a></h2>
<p class="summary">{esc(x.get('summary',''))}</p><div class="tags">{tags}</div>
</article>""")
        entries.append({"@type":"ListItem","position":i,"url":f"{BASE_URL}/sample/{x['id']}/","name":x["title"]})
    options="".join(f'<option value="{esc(c)}">{esc(c)}</option>' for c in cats)
    body=f"""
<section class="hero"><p>Daily-Code-Samples</p>
<h1>仕事の「ちょっと困った」を検索</h1>
<p>Windows、Excel、Word、PowerPoint、PowerShell、VBAなどの実用サンプルを、技術名ではなく「やりたいこと」から探せます。</p></section>
<section class="controls"><input id="q" type="search" placeholder="例：未処理、CSV、音が出ない、列幅…"><select id="cat"><option value="">すべての分類</option>{options}</select></section>
<p id="count" class="count"></p><main class="grid">{''.join(cards)}</main>
<footer><a href="https://github.com/papanda925/Daily-Code-Samples">GitHubリポジトリを見る</a></footer><script>{JS}</script>"""
    structured={"@context":"https://schema.org","@type":"ItemList","name":"Daily Code Samples","itemListElement":entries}
    return shell("Daily Code Samples｜仕事の困りごとから探せるPC・Office実用サンプル",
                 "Windows、Excel、Word、PowerPoint、PowerShell、VBAなどの実用サンプルを、やりたいことから検索できます。",
                 f"{BASE_URL}/",body,structured)

def build_detail(x):
    canonical=f"{BASE_URL}/sample/{x['id']}/"
    fields=[
        ("分類"," / ".join(x.get("purposes",[]))),
        ("アプリ・機能"," / ".join(x.get("apps",[]))),
        ("方法"," / ".join(x.get("methods",[]))),
        ("難しさ",x.get("level","")),
        ("目安時間",str(x.get("estimated_minutes",""))+"分"),
        ("管理者権限","必要" if x.get("requires_admin") else "不要"),
    ]
    kv="".join(f"<dt>{esc(k)}</dt><dd>{esc(v)}</dd>" for k,v in fields if v)
    tags="".join(f'<span class="pill">{esc(v)}</span>' for v in x.get("tags",[]))
    github=f"https://github.com/papanda925/Daily-Code-Samples/tree/main/samples/{x['_folder']}"
    body=f"""<p><a href="../../">← サンプル一覧へ</a></p><article class="detail">
<div class="meta"><span class="pill">#{esc(x['id'])}</span></div><h1>{esc(x['title'])}</h1>
<p class="summary">{esc(x.get('summary',''))}</p><dl class="kv">{kv}</dl><div class="tags">{tags}</div>
<a class="button primary" href="{esc(github)}">GitHubで詳しい手順を見る</a><a class="button" href="../../">別のサンプルを検索</a>
</article><footer>Daily Code Samples</footer>"""
    structured={"@context":"https://schema.org","@type":"LearningResource","name":x["title"],
        "description":x.get("summary",""),"url":canonical,"learningResourceType":"Tutorial",
        "educationalLevel":x.get("level",""),"isAccessibleForFree":True}
    return shell(f"{x['title']}｜Daily Code Samples",x.get("summary",""),canonical,body,structured)

def main():
    items=load_samples()
    OUT.mkdir(exist_ok=True)
    (OUT/"index.html").write_text(build_index(items),encoding="utf-8")
    for x in items:
        d=OUT/"sample"/str(x["id"]);d.mkdir(parents=True,exist_ok=True)
        (d/"index.html").write_text(build_detail(x),encoding="utf-8")
    (OUT/"search-index.json").write_text(json.dumps([{k:v for k,v in x.items() if not k.startswith("_")} for x in items],ensure_ascii=False,indent=2),encoding="utf-8")
    urls=[f"{BASE_URL}/"]+[f"{BASE_URL}/sample/{x['id']}/" for x in items]
    sitemap='<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'+"\n".join(f"  <url><loc>{html.escape(u)}</loc></url>" for u in urls)+"\n</urlset>\n"
    (OUT/"sitemap.xml").write_text(sitemap,encoding="utf-8")
    (OUT/"robots.txt").write_text(f"User-agent: *\nAllow: /\nSitemap: {BASE_URL}/sitemap.xml\n",encoding="utf-8")
    print(f"Built {len(items)} samples")

if __name__=="__main__":
    main()
