#!/usr/bin/env python3
from __future__ import annotations
import argparse, datetime as dt, json, os, re, subprocess, sys, tempfile
from pathlib import Path

HOME=Path.home(); REPO0=HOME/'Daily-Code-Samples'; BOT0=HOME/'new_gemini_postbot'; WP0=Path('/var/www/papanda925.com')
EXT={'.ps1':'powershell','.bas':'vb','.cls':'vb','.py':'python','.js':'javascript','.json':'json','.xml':'xml','.html':'html','.css':'css','.sql':'sql','.m':'text','.txt':'text','.csv':'csv'}
FENCE=chr(96)*3

def cmd(a,check=True): return subprocess.run(a,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=check)
def git(repo,*a,check=True): return cmd(['git','-C',str(repo),*a],check)
def load(p):
    if not p.exists(): return {'version':1,'samples':{}}
    d=json.loads(p.read_text(encoding='utf-8')); d.setdefault('samples',{}); return d
def save(p,d):
    p.parent.mkdir(parents=True,exist_ok=True); q=p.with_suffix('.tmp'); q.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8'); q.replace(p)
def sid(p): return re.match(r'^(\d{3,})-',p.name).group(1)
def samples(repo):
    a=[]
    for p in (repo/'samples').iterdir():
        m=re.match(r'^(\d{3,})-',p.name)
        if p.is_dir() and m: a.append((int(m.group(1)),p))
    return [p for _,p in sorted(a)]
def title_of(md,s):
    m=re.search(r'^#\s+(.+)$',md,re.M); t=m.group(1).strip() if m else f'Daily Code #{s}'
    return re.sub(rf'^{re.escape(s)}\s*[:：-]\s*','',t)
def body_of(md):
    md=re.sub(r'^#\s+.*\n','',md,count=1)
    md=re.sub(r'\n##\s+関連記事\s*\n.*\Z','',md,flags=re.S)
    return md.strip()
def article(sample,slug):
    s=sid(sample); md=(sample/'README.md').read_text(encoding='utf-8'); title=f'Daily Code #{s}：{title_of(md,s)}'
    out=[f'# {title}','', '日々の事務作業や学習でそのまま試せる小さなサンプルを紹介する「Daily Code」です。','',body_of(md)]
    code=[]
    for p in sorted(sample.iterdir()):
        if not p.is_file() or p.name.lower()=='readme.md' or p.name.startswith('.'): continue
        try: t=p.read_text(encoding='utf-8')
        except UnicodeDecodeError: continue
        if len(t)>120000: continue
        code += [f'### {p.name}','',FENCE+EXT.get(p.suffix.lower(),'text'),t.rstrip(),FENCE,'']
    if code: out += ['','## サンプルコード','']+code
    url=f'https://github.com/{slug}/tree/main/samples/{sample.name}'
    out += ['','## GitHubで確認する','',f'最新のREADMEとソースコードは [Daily-Code-Samples #{s}]({url}) で確認できます。','','## まとめ','','まずはそのまま動かし、次に値や条件を少し変えて試してください。業務利用時は実行環境と元データを十分確認してください。']
    return title,'\n'.join(out).strip()+'\n'
def serialize(md,bot):
    sys.path.insert(0,str(bot)); from utils.gutenberg_serializer import serialize_markdown_to_gutenberg
    return serialize_markdown_to_gutenberg(md)
def category(wp,wppath):
    p=cmd([wp,f'--path={wppath}','term','get','category','daily-code','--by=slug','--field=term_id'],False)
    if p.returncode==0 and p.stdout.strip().isdigit(): return int(p.stdout)
    return int(cmd([wp,f'--path={wppath}','term','create','category','Daily Code','--slug=daily-code','--porcelain']).stdout)
def publish(wp,wppath,title,content,status,cat):
    with tempfile.NamedTemporaryFile('w',encoding='utf-8',suffix='.html',delete=False) as f: f.write(content); tmp=Path(f.name)
    try:
        pid=int(cmd([wp,f'--path={wppath}','post','create',str(tmp),'--post_type=post',f'--post_status={status}',f'--post_title={title}',f'--post_category={cat}','--porcelain']).stdout)
        actual=cmd([wp,f'--path={wppath}','post','get',str(pid),'--field=post_status']).stdout.strip()
        if actual!=status: raise RuntimeError(f'status mismatch: {actual}')
        url=cmd([wp,f'--path={wppath}','eval',f'echo get_permalink({pid});']).stdout.strip()
        if not url.startswith('http'): raise RuntimeError(f'bad permalink: {url}')
        return pid,url
    finally: tmp.unlink(missing_ok=True)
def writeback(repo,sample,s,url,push=True):
    root=repo/'README.md'; lines=root.read_text(encoding='utf-8').splitlines(); changed=False
    for i,line in enumerate(lines):
        if re.match(rf'^\|\s*{re.escape(s)}\s*\|',line):
            c=[x.strip() for x in line.strip('|').split('|')]
            if len(c)>=6: c[-1]=f'[記事]({url})'; lines[i]='| '+' | '.join(c)+' |'; changed=True
            break
    if changed: root.write_text('\n'.join(lines)+'\n',encoding='utf-8')
    sr=sample/'README.md'; t=sr.read_text(encoding='utf-8'); link=f'[papanda925.com の解説記事]({url})'
    n=re.sub(r'papanda925\.com\s*に解説記事を追加予定です。',link,t)
    if n==t and link not in t: n=t.rstrip()+'\n\n## 関連記事\n\n'+link+'\n'
    if n!=t: sr.write_text(n if n.endswith('\n') else n+'\n',encoding='utf-8'); changed=True
    if not changed: return {'changed':False,'pushed':False}
    git(repo,'add','README.md',str(sr.relative_to(repo))); d=git(repo,'diff','--cached','--quiet',check=False)
    if d.returncode: git(repo,'commit','-m',f'docs: add blog link for sample {s}')
    if push: git(repo,'push','origin','main')
    return {'changed':True,'pushed':push}
def main():
    a=argparse.ArgumentParser(); a.add_argument('--dry-run',action='store_true'); a.add_argument('--no-push',action='store_true'); a.add_argument('--status',default=os.getenv('DAILY_CODE_WP_STATUS','publish'),choices=['draft','publish','private']); x=a.parse_args()
    repo=Path(os.getenv('DAILY_CODE_REPO',REPO0)).expanduser(); bot=Path(os.getenv('POSTBOT_ROOT',BOT0)).expanduser(); wppath=Path(os.getenv('WP_PATH',WP0)); wp=os.getenv('WP_BIN','/usr/local/bin/wp'); statep=bot/'state/daily_code_wordpress.json'
    p=git(repo,'pull','--ff-only','origin','main',check=False)
    if p.returncode: raise SystemExit('git pull failed: '+p.stderr.strip())
    st=load(statep); sample=next((p for p in samples(repo) if not st['samples'].get(sid(p),{}).get('wordpress_post_id') or not st['samples'].get(sid(p),{}).get('github_writeback')),None)
    if not sample: print(json.dumps({'result':'no_pending_sample'},ensure_ascii=False)); return 0
    s=sid(sample); row=st['samples'].setdefault(s,{})
    if row.get('wordpress_post_id') and row.get('wordpress_url'):
        if x.dry_run: print(json.dumps({'result':'would_retry_writeback','sample_id':s},ensure_ascii=False)); return 0
        r=writeback(repo,sample,s,row['wordpress_url'],not x.no_push); row['github_writeback']=bool(r['pushed'] or x.no_push); save(statep,st); print(json.dumps({'result':'writeback_ok','sample_id':s,**r},ensure_ascii=False)); return 0
    title,md=article(sample,'papanda925/Daily-Code-Samples')
    if x.dry_run: print(json.dumps({'result':'dry_run','sample_id':s,'title':title,'markdown_chars':len(md)},ensure_ascii=False)); return 0
    content=serialize(md,bot); pid,url=publish(wp,wppath,title,content,x.status,category(wp,wppath)); row.update({'sample_dir':sample.name,'wordpress_post_id':pid,'wordpress_url':url,'wordpress_status':x.status,'published_at':dt.datetime.now(dt.timezone.utc).isoformat(),'github_writeback':False}); save(statep,st)
    r=writeback(repo,sample,s,url,not x.no_push); row['github_writeback']=bool(r['pushed'] or x.no_push); save(statep,st); print(json.dumps({'result':'publish_ok','sample_id':s,'post_id':pid,'url':url,'github':r},ensure_ascii=False)); return 0
if __name__=='__main__': raise SystemExit(main())
