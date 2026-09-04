#!/usr/bin/env python3
"""Daily Code Samples の検索サイトを生成する。

300本を単純に一覧表示するのではなく、
- 仕事ですぐ使う Daily Practical
- 仕組みを体験する Engineering Lab
を分け、Track / 難しさ / キーワードから探せるようにします。

sample.jsonだけを情報源にするため、新しいサンプルが追加されると
GitHub Pagesも自動的に同じ分類へ加わります。
"""
from __future__ import annotations

import html
import json
import os
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "_site"
BASE_URL = os.environ.get(
    "PAGES_BASE_URL",
    "https://papanda925.github.io/Daily-Code-Samples",
).rstrip("/")

CSS = """
:root{
  --bg:#f6f8fa;--card:#fff;--text:#1f2328;--muted:#59636e;
  --line:#d0d7de;--accent:#0969da;--soft:#eef4fb;--lab:#f6f0ff
}
*{box-sizing:border-box}
body{margin:0;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI","Noto Sans JP",sans-serif;background:var(--bg);color:var(--text);line-height:1.65}
a{color:var(--accent)}
.wrap{max-width:1180px;margin:auto;padding:28px 20px 60px}
.topbar{display:flex;justify-content:space-between;align-items:center;gap:18px;padding:4px 0 22px;border-bottom:1px solid var(--line);margin-bottom:34px}
.brand{font-weight:800;color:var(--text);text-decoration:none}
.nav{display:flex;gap:16px;flex-wrap:wrap}.nav a{font-size:.92rem;text-decoration:none}
.hero{padding:6px 0 18px}.eyebrow{font-weight:700;color:var(--accent);margin:0}
.hero h1{font-size:clamp(2rem,5vw,3.35rem);line-height:1.2;margin:.15em 0}
.hero>p:not(.eyebrow){max-width:850px;color:var(--muted)}
.hero-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:20px}
.button{display:inline-block;padding:10px 14px;border-radius:10px;text-decoration:none;border:1px solid var(--line);background:#fff}
.primary{background:var(--accent);color:#fff;border-color:var(--accent)}
.stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px;margin:22px 0 28px}
.stat{background:#fff;border:1px solid var(--line);border-radius:14px;padding:16px}
.stat strong{display:block;font-size:1.7rem}.stat span{color:var(--muted);font-size:.9rem}
.section-title{margin:34px 0 10px}.section-title p{color:var(--muted);margin-top:0}
.track-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:10px;margin:16px 0 30px}
.track-button{width:100%;text-align:left;border:1px solid var(--line);background:#fff;border-radius:12px;padding:12px;cursor:pointer;color:var(--text)}
.track-button:hover,.track-button.active{border-color:var(--accent);box-shadow:0 0 0 2px rgba(9,105,218,.08)}
.track-button strong{display:block}.track-button span{font-size:.85rem;color:var(--muted)}
.controls{display:grid;grid-template-columns:2fr repeat(3,1fr);gap:10px;margin:18px 0}
.controls input,.controls select{padding:12px;border:1px solid var(--line);border-radius:10px;background:#fff;font-size:.96rem;min-width:0}
.count{color:var(--muted);margin:8px 0 18px}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(285px,1fr));gap:14px}
.card,.detail{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:18px}
.card h2{font-size:1.08rem;line-height:1.45;margin:.65em 0}
.summary{color:var(--muted)}
.meta,.tags{display:flex;gap:6px;flex-wrap:wrap}
.pill{font-size:.8rem;padding:3px 8px;border-radius:999px;background:#eef2f6}
.pill.practical{background:var(--soft);color:#0550ae}
.pill.lab{background:var(--lab);color:#6639ba}
.pill.experimental{background:#fff8c5}
.kv{display:grid;grid-template-columns:150px 1fr;gap:8px 14px}
.kv dt{font-weight:700}.kv dd{margin:0}
.notice{padding:12px 14px;border-radius:10px;background:#fff8c5;margin:16px 0}
.learning-flow{background:#f6f8fa;border-radius:12px;padding:14px 18px;margin:18px 0}
.site-footer{display:flex;justify-content:space-between;gap:16px;flex-wrap:wrap;padding-top:22px;border-top:1px solid var(--line);margin-top:40px;color:var(--muted)}
@media(max-width:800px){
  .topbar{align-items:flex-start;flex-direction:column}
  .controls{grid-template-columns:1fr 1fr}
  .stats{grid-template-columns:1fr}
}
@media(max-width:520px){
  .controls{grid-template-columns:1fr}
  .kv{grid-template-columns:1fr}
}
"""

JS = """
const q=document.querySelector('#q');
const mode=document.querySelector('#mode');
const track=document.querySelector('#track');
const level=document.querySelector('#level');
const cards=[...document.querySelectorAll('.card')];
const count=document.querySelector('#count');
const trackButtons=[...document.querySelectorAll('.track-button')];

function apply(){
  const s=q.value.toLowerCase().trim();
  const m=mode.value;
  const t=track.value;
  const l=level.value;
  let n=0;

  for(const card of cards){
    const show=
      (!s || card.dataset.search.includes(s)) &&
      (!m || card.dataset.mode===m) &&
      (!t || card.dataset.track===t) &&
      (!l || card.dataset.level===l);
    card.hidden=!show;
    if(show)n++;
  }
  count.textContent=n+'件表示';
  for(const b of trackButtons){
    b.classList.toggle('active', b.dataset.track===t && t!=='');
  }
}

q.addEventListener('input',apply);
mode.addEventListener('change',apply);
track.addEventListener('change',apply);
level.addEventListener('change',apply);

for(const b of trackButtons){
  b.addEventListener('click',()=>{
    track.value=b.dataset.track;
    mode.value=b.dataset.mode||'';
    document.querySelector('#samples').scrollIntoView({behavior:'smooth'});
    apply();
  });
}
apply();
"""


def esc(value):
    return html.escape(str(value), quote=True)


def normalize_list(value):
    if not isinstance(value, list):
        return []
    result=[]
    for item in value:
        if isinstance(item, list):
            result.extend(str(v) for v in item)
        else:
            result.append(str(item))
    return result


def load_samples():
    items=[]
    for path in sorted((ROOT/"samples").glob("*/sample.json")):
        data=json.loads(path.read_text(encoding="utf-8-sig"))

        for key in ("purposes","apps","methods","tags","audience"):
            data[key]=normalize_list(data.get(key,[]))

        sid=int(str(data.get("id","0")))
        # #001〜#041は旧メタデータでも「すぐ使える」入口として扱います。
        data.setdefault("track","Daily Practical" if sid<=41 else "Engineering Lab")
        data.setdefault("maturity","stable" if sid<=41 else "experimental")
        data["_mode"]="practical" if data["track"]=="Daily Practical" or sid<=41 else "lab"
        data["_folder"]=path.parent.name
        items.append(data)

    return sorted(items,key=lambda x:int(str(x["id"])))


def shell(title,description,canonical,body,structured=None):
    ld=""
    if structured is not None:
        raw=json.dumps(structured,ensure_ascii=False).replace("</","<\/")
        ld=f'<script type="application/ld+json">{raw}</script>'
    return f"""<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{esc(title)}</title>
<meta name="description" content="{esc(description)}">
<meta name="google-site-verification" content="keoWiVOQke6IeKbY9fTOYm8W-eCr2RZUNmlJ7UQXH8A">
<link rel="canonical" href="{esc(canonical)}">
<meta property="og:type" content="website">
<meta property="og:title" content="{esc(title)}">
<meta property="og:description" content="{esc(description)}">
<meta property="og:url" content="{esc(canonical)}">
<style>{CSS}</style>
{ld}
</head>
<body><div class="wrap">{body}</div></body>
</html>"""


def track_buttons(items):
    counts=Counter(x["track"] for x in items)
    order=[
        "Daily Practical",
        "OS Fundamentals Lab",
        "Windows & Device Trace Lab",
        "Network & Wireless Lab",
        "Visual Security Lab",
        "Architecture & Algorithm Lab",
        "VBA Deep Dive",
        "PowerShell / WinRT / .NET Lab",
        "Legacy Data & File Format Lab",
        "Binary / Hex / Encoding Lab",
        "Language Basics Lab",
        "Built-in Tools & Scripting Map",
    ]
    descriptions={
        "Daily Practical":"仕事ですぐ使う",
        "OS Fundamentals Lab":"Process・Thread・HWND・Memory",
        "Windows & Device Trace Lab":"USB・Bluetooth・Display・Battery",
        "Network & Wireless Lab":"Wi-Fi・DNS・TCP/IP",
        "Visual Security Lab":"Hash・暗号・署名・TLS",
        "Architecture & Algorithm Lab":"Blockchain・Queue・設計パターン",
        "VBA Deep Dive":"Async・Event・DI・COM",
        "PowerShell / WinRT / .NET Lab":"WinRT・.NET・GUI・API",
        "Legacy Data & File Format Lab":"固定長・全銀風・CSV・XML",
        "Binary / Hex / Encoding Lab":"Hex・BOM・Endian・Encoding",
        "Language Basics Lab":"型・引数・配列・Class",
        "Built-in Tools & Scripting Map":"cmd・curl・robocopy・netsh",
    }
    buttons=[]
    for name in order:
        if name not in counts:
            continue
        mode="practical" if name=="Daily Practical" else "lab"
        buttons.append(
            f'<button class="track-button" data-track="{esc(name)}" data-mode="{mode}">'
            f'<strong>{esc(name)}</strong>'
            f'<span>{esc(descriptions.get(name,""))} · {counts[name]}本</span>'
            f'</button>'
        )
    return "".join(buttons)


def build_index(items):
    total=len(items)
    practical=sum(1 for x in items if x["_mode"]=="practical")
    labs=total-practical
    tracks=sorted({x["track"] for x in items})
    levels=sorted({str(x.get("level","")) for x in items if x.get("level")})

    cards=[]
    entries=[]
    for pos,x in enumerate(items,1):
        searchable=" ".join([
            str(x.get("title","")),
            str(x.get("summary","")),
            str(x.get("track","")),
            *x.get("purposes",[]),
            *x.get("apps",[]),
            *x.get("methods",[]),
            *x.get("tags",[]),
        ]).lower()

        mode_label="すぐ使える" if x["_mode"]=="practical" else "仕組みを学ぶ"
        mode_class=x["_mode"]
        maturity=str(x.get("maturity",""))
        maturity_pill=(
            f'<span class="pill experimental">実験・学習用</span>'
            if maturity=="experimental" else ""
        )
        app_pills="".join(
            f'<span class="pill">{esc(v)}</span>' for v in x.get("apps",[])[:3]
        )

        cards.append(f"""<article class="card"
 data-search="{esc(searchable)}"
 data-mode="{esc(x['_mode'])}"
 data-track="{esc(x['track'])}"
 data-level="{esc(x.get('level',''))}">
<div class="meta">
  <span class="pill">#{esc(x['id'])}</span>
  <span class="pill {mode_class}">{mode_label}</span>
  {maturity_pill}
</div>
<h2><a href="./sample/{esc(x['id'])}/">{esc(x['title'])}</a></h2>
<p class="summary">{esc(x.get('summary',''))}</p>
<div class="tags">{app_pills}</div>
</article>""")

        entries.append({
            "@type":"ListItem",
            "position":pos,
            "url":f"{BASE_URL}/sample/{x['id']}/",
            "name":x["title"],
        })

    track_options="".join(
        f'<option value="{esc(v)}">{esc(v)}</option>' for v in tracks
    )
    level_options="".join(
        f'<option value="{esc(v)}">{esc(v)}</option>' for v in levels
    )

    body=f"""
<header class="topbar">
<a class="brand" href="https://papanda925.github.io/">papanda925</a>
<nav class="nav" aria-label="関連サイト">
<a href="https://papanda925.com/">Blog</a>
<a href="https://github.com/papanda925/Daily-Code-Samples">GitHub</a>
</nav>
</header>

<section class="hero">
<p class="eyebrow">Daily Code Samples</p>
<h1>使って理解する。<br>仕組みまで見に行く。</h1>
<p>
ExcelやWindowsの「ちょっと困った」から、Process・Thread・Wi-Fi・USB・暗号・WinRT・固定長・Hexまで。
1本を短くし、実際に動かして前後の違いを確認できる教材を集めています。
</p>
<div class="hero-actions">
<a class="button primary" href="#samples">300本から探す</a>
<a class="button" href="https://papanda925.com/">技術ブログを読む</a>
<a class="button" href="https://github.com/papanda925/Daily-Code-Samples">ソースコードを見る</a>
</div>
</section>

<section class="stats" aria-label="サンプル数">
<div class="stat"><strong>{total}</strong><span>全サンプル</span></div>
<div class="stat"><strong>{practical}</strong><span>仕事ですぐ使える Practical</span></div>
<div class="stat"><strong>{labs}</strong><span>仕組みを体験する Engineering Lab</span></div>
</section>

<section>
<div class="section-title">
<h2>興味のある入口から探す</h2>
<p>専門用語が分からなくても大丈夫です。まず気になるテーマを選び、実際に動かしてみてください。</p>
</div>
<div class="track-grid">{track_buttons(items)}</div>
</section>

<section id="samples">
<div class="section-title">
<h2>サンプルを検索</h2>
<p>キーワード、入口、シリーズ、難しさを組み合わせて絞り込めます。</p>
</div>
<div class="controls">
<input id="q" type="search" placeholder="例：Wi-Fi、固定長、DoEvents、引数、USB…">
<select id="mode">
<option value="">すべての入口</option>
<option value="practical">すぐ使える</option>
<option value="lab">仕組みを学ぶ</option>
</select>
<select id="track"><option value="">すべてのシリーズ</option>{track_options}</select>
<select id="level"><option value="">すべての難しさ</option>{level_options}</select>
</div>
<p id="count" class="count"></p>
<main class="grid">{''.join(cards)}</main>
</section>

<footer class="site-footer">
<span>Daily Code Samples by papanda925</span>
<span><a href="https://papanda925.com/">Blog</a> · <a href="https://papanda925.github.io/">Portfolio</a> · <a href="https://github.com/papanda925">GitHub</a></span>
</footer>
<script>{JS}</script>
"""

    structured={
        "@context":"https://schema.org",
        "@type":"ItemList",
        "name":"Daily Code Samples",
        "numberOfItems":total,
        "itemListElement":entries,
    }
    return shell(
        "Daily Code Samples｜使って理解するWindows・Office・OS実験集",
        f"Windows、Office、PowerShell、VBA、OS、ネットワーク、セキュリティなど{total}本の短い実用・学習サンプルを検索できます。",
        f"{BASE_URL}/",
        body,
        structured,
    )


def build_detail(x):
    canonical=f"{BASE_URL}/sample/{x['id']}/"
    mode_label="すぐ使える Practical" if x["_mode"]=="practical" else "仕組みを学ぶ Engineering Lab"
    maturity=str(x.get("maturity",""))
    fields=[
        ("入口",mode_label),
        ("シリーズ",x.get("track","")),
        ("分類"," / ".join(x.get("purposes",[]))),
        ("アプリ・技術"," / ".join(x.get("apps",[]))),
        ("方法"," / ".join(x.get("methods",[]))),
        ("難しさ",x.get("level","")),
        ("目安時間",str(x.get("estimated_minutes",""))+"分"),
        ("管理者権限","必要" if x.get("requires_admin") else "不要"),
    ]
    kv="".join(
        f"<dt>{esc(k)}</dt><dd>{esc(v)}</dd>" for k,v in fields if v
    )
    tags="".join(
        f'<span class="pill">{esc(v)}</span>' for v in x.get("tags",[])[:10]
    )
    github=f"https://github.com/papanda925/Daily-Code-Samples/tree/main/samples/{x['_folder']}"
    article_url=str(x.get("article_url","")).strip()

    notice=""
    if maturity=="experimental":
        notice=(
            '<div class="notice"><strong>実験・学習用サンプルです。</strong> '
            'Windows版、PowerShell版、デバイス有無などで結果が変わる場合があります。'
            'READMEの「見るポイント」「うまくいかないとき」も確認してください。</div>'
        )

    article_button=(
        f'<a class="button" href="{esc(article_url)}">ブログの詳しい解説を読む</a>'
        if article_url.startswith("http") else ""
    )

    body=f"""
<header class="topbar">
<a class="brand" href="https://papanda925.github.io/">papanda925</a>
<nav class="nav" aria-label="関連サイト">
<a href="https://papanda925.com/">Blog</a>
<a href="https://github.com/papanda925/Daily-Code-Samples">GitHub</a>
</nav>
</header>

<p><a href="../../">← 300本の一覧へ</a></p>
<article class="detail">
<div class="meta">
<span class="pill">#{esc(x['id'])}</span>
<span class="pill {esc(x['_mode'])}">{esc(mode_label)}</span>
</div>
<h1>{esc(x['title'])}</h1>
<p class="summary">{esc(x.get('summary',''))}</p>
{notice}

<div class="learning-flow">
<strong>おすすめの進め方</strong>
<ol>
<li>READMEとコードを先に読む</li>
<li>実行前の状態を確認する</li>
<li>そのまま動かす</li>
<li>値や条件を1つ変え、前後の差を見る</li>
</ol>
</div>

<dl class="kv">{kv}</dl>
<div class="tags">{tags}</div>
<p>
<a class="button primary" href="{esc(github)}">GitHubでコードと詳しい手順を見る</a>
{article_button}
<a class="button" href="../../">別のサンプルを検索</a>
</p>
</article>

<footer class="site-footer">
<span>Daily Code Samples by papanda925</span>
<span><a href="https://papanda925.com/">Blog</a> · <a href="https://papanda925.github.io/">Portfolio</a></span>
</footer>
"""

    structured={
        "@context":"https://schema.org",
        "@type":"LearningResource",
        "name":x["title"],
        "description":x.get("summary",""),
        "url":canonical,
        "learningResourceType":"Tutorial",
        "educationalLevel":x.get("level",""),
        "isAccessibleForFree":True,
    }
    return shell(
        f"{x['title']}｜Daily Code Samples",
        x.get("summary",""),
        canonical,
        body,
        structured,
    )


def main():
    items=load_samples()
    OUT.mkdir(exist_ok=True)
    (OUT/"index.html").write_text(build_index(items),encoding="utf-8")

    for x in items:
        detail=OUT/"sample"/str(x["id"])
        detail.mkdir(parents=True,exist_ok=True)
        (detail/"index.html").write_text(build_detail(x),encoding="utf-8")

    public_index=[
        {k:v for k,v in x.items() if not k.startswith("_")}
        for x in items
    ]
    (OUT/"search-index.json").write_text(
        json.dumps(public_index,ensure_ascii=False,indent=2),
        encoding="utf-8",
    )

    urls=[f"{BASE_URL}/"]+[
        f"{BASE_URL}/sample/{x['id']}/" for x in items
    ]
    sitemap=(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
        + "\n".join(
            f"  <url><loc>{html.escape(url)}</loc></url>" for url in urls
        )
        + "\n</urlset>\n"
    )
    (OUT/"sitemap.xml").write_text(sitemap,encoding="utf-8")
    (OUT/"robots.txt").write_text(
        f"User-agent: *\nAllow: /\nSitemap: {BASE_URL}/sitemap.xml\n",
        encoding="utf-8",
    )
    print(f"Built {len(items)} samples")


if __name__=="__main__":
    main()
