from pathlib import Path
from playwright.sync_api import sync_playwright
import sys
with sync_playwright() as p:
    browser = p.chromium.launch(executable_path=sys.argv[1] if len(sys.argv) > 1 else None, args=['--no-sandbox'])
    page = browser.new_page(viewport={'width': 800, 'height': 900})
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    root = Path(__file__).parent
    html = (root / 'index.html').read_text(encoding='utf-8')
    script = (root / 'app.js').read_text(encoding='utf-8')
    page.set_content(html.replace('<script src="app.js"></script>', ''))
    page.add_script_tag(content=script)
    def check(w, n, expected_fill, expected_fit):
        page.locator('#width').evaluate('(e,w)=>{e.value=w;e.dispatchEvent(new Event("input"))}', w)
        page.locator('#count').evaluate('(e,n)=>{e.value=n;e.dispatchEvent(new Event("input"))}', n)
        for mode, expected in [('fill', expected_fill), ('fit', expected_fit)]:
            actual = page.locator('#'+mode).evaluate('e=>getComputedStyle(e).gridTemplateColumns.split(" ").map(parseFloat)')
            assert actual == expected, (w,n,mode,actual,expected)
            assert page.locator('#'+mode+' .card').count() == n
        print(f'PASS {w}px/{n} cards')
    check(540,2,[126]*4,[264,264,0,0])
    check(540,4,[126]*4,[126]*4)
    check(540,5,[126]*4,[126]*4)
    check(252,1,[120,120],[252,0])
    check(251,1,[251],[251])
    check(120,2,[120],[120])
    assert not errors, errors
    print('Chromium',browser.version,'6 cases PASS; page errors 0')
    browser.close()
