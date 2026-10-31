"""Local browser smoke checks for the exact repository HTML and JavaScript.
Optional: pip install playwright; python -m playwright install chromium.
No GitHub Pages or WordPress access. No network required for the demo.
"""
import os
from pathlib import Path
from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[3]
DEMO = ROOT / "docs" / "demos" / "svg-bezier-control-lab"
HTML = (DEMO / "index.html").read_text(encoding="utf-8")
SCRIPT = DEMO / "app.js"
assert SCRIPT.is_file()
# Some managed sandboxes disallow file:// navigation. Use exact HTML/JS as local content.
HTML = HTML.replace('<script src="./app.js" defer></script>', "")
passed = 0

def check(name, ok):
    global passed
    if not ok:
        raise AssertionError(name)
    passed += 1
    print("PASS", name)

with sync_playwright() as p:
    launch = {"headless": True}
    if os.environ.get("CHROMIUM_PATH"):
        launch["executable_path"] = os.environ["CHROMIUM_PATH"]
    browser = p.chromium.launch(**launch)
    page = browser.new_page(viewport={"width": 1280, "height": 800}, locale="ja-JP")
    errors = []
    page.on("pageerror", lambda err: errors.append(str(err)))
    page.set_content(HTML)
    page.add_script_tag(path=str(SCRIPT))
    route = page.locator("#route")
    check("initial path", route.get_attribute("d") == "M 60 160 C 200 70 400 250 540 160")
    check("initial status", "70" in page.locator("#readout").inner_text() and "250" in page.locator("#readout").inner_text())
    page.locator("#control1").fill("160")
    check("slider1 path", route.get_attribute("d") == "M 60 160 C 200 160 400 250 540 160")
    check("slider1 point", page.locator("#point1").get_attribute("cy") == "160" and page.locator("#helper1").get_attribute("y2") == "160")
    page.locator("#straight").click()
    check("straight path", route.get_attribute("d") == "M 60 160 C 200 160 400 160 540 160")
    check("straight text", "水平な直線" in page.locator("#readout").inner_text())
    page.locator("#reset").click()
    check("reset path", route.get_attribute("d") == "M 60 160 C 200 70 400 250 540 160")
    check("reset controls", page.locator("#control1").input_value() == "70" and page.locator("#control2").input_value() == "250")
    check("svg rendered", page.locator("svg").bounding_box()["width"] > 300 and route.evaluate("(el)=>el.getTotalLength()") > 400)
    check("no JS errors", not errors)
    mobile = browser.new_page(viewport={"width": 390, "height": 844}, is_mobile=True, has_touch=True)
    mobile.set_content(HTML)
    mobile.add_script_tag(path=str(SCRIPT))
    check("mobile path", mobile.locator("#route").get_attribute("d") == "M 60 160 C 200 70 400 250 540 160")
    check("mobile no overflow", mobile.evaluate("document.documentElement.scrollWidth <= window.innerWidth"))
    print("CHECKS_PASSED", passed, "BROWSER", browser.version)
    browser.close()
