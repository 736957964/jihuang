import os
import sys
import markdown
from playwright.sync_api import sync_playwright

HTML_TEMPLATE = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
    line-height: 1.6;
    color: #24292e;
    background-color: #ffffff;
    padding: 30px 40px;
    max-width: 900px;
    margin: 0 auto;
  }
  h1 { font-size: 26px; border-bottom: 2px solid #eaecef; padding-bottom: 8px; color: #0f172a; }
  h2 { font-size: 20px; border-bottom: 1px solid #eaecef; padding-bottom: 6px; margin-top: 24px; color: #1e293b; }
  h3 { font-size: 16px; margin-top: 18px; color: #334155; }
  blockquote {
    padding: 8px 16px;
    color: #475569;
    border-left: 4px solid #3b82f6;
    background: #f8fafc;
    margin: 12px 0;
  }
  code {
    font-family: "Cascadia Code", Consolas, Monaco, monospace;
    font-size: 13px;
    background-color: #f1f5f9;
    padding: 2px 6px;
    border-radius: 4px;
    color: #0f172a;
  }
  pre {
    background-color: #0f172a;
    color: #f8fafc;
    padding: 16px;
    border-radius: 8px;
    overflow-x: auto;
    font-family: "Cascadia Code", Consolas, Monaco, monospace;
    font-size: 13px;
    line-height: 1.5;
  }
  pre code {
    background-color: transparent;
    padding: 0;
    color: inherit;
  }
  table {
    border-collapse: collapse;
    width: 100%;
    margin: 16px 0;
  }
  th, td {
    border: 1px solid #cbd5e1;
    padding: 8px 12px;
    text-align: left;
    font-size: 13px;
  }
  th {
    background-color: #f1f5f9;
    font-weight: 600;
  }
  tr:nth-child(even) { background-color: #f8fafc; }
  hr { height: 1px; background-color: #e2e8f0; border: none; margin: 24px 0; }
  .badge {
    display: inline-block;
    padding: 4px 8px;
    border-radius: 4px;
    background: #e0e7ff;
    color: #3730a3;
    font-size: 12px;
    font-weight: 600;
    margin-bottom: 12px;
  }
</style>
</head>
<body>
<div class="badge">饥荒工坊母本权威归约渲染自检</div>
__BODY__
</body>
</html>
"""

def render_markdown_to_long_screenshot(md_file_path, out_png_path):
    if not os.path.exists(md_file_path):
        return None
    with open(md_file_path, "r", encoding="utf-8") as f:
        md_text = f.read()
    
    html_body = markdown.markdown(md_text, extensions=['fenced_code', 'tables', 'toc', 'nl2br'])
    full_html = HTML_TEMPLATE.replace("__BODY__", html_body)
    
    tmp_html = out_png_path + ".html"
    with open(tmp_html, "w", encoding="utf-8") as f:
        f.write(full_html)
        
    try:
        with sync_playwright() as p:
            edge_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
            if os.path.exists(edge_path):
                browser = p.chromium.launch(executable_path=edge_path, headless=True)
            else:
                browser = p.chromium.launch(headless=True)
            page = browser.new_page(viewport={"width": 960, "height": 800})
            page.goto("file:///" + tmp_html.replace("\\", "/"))
            page.wait_for_load_state("networkidle")
            page.screenshot(path=out_png_path, full_page=True)
            browser.close()
    finally:
        if os.path.exists(tmp_html):
            os.remove(tmp_html)
            
    return out_png_path

if __name__ == "__main__":
    if len(sys.argv) > 2:
        res = render_markdown_to_long_screenshot(sys.argv[1], sys.argv[2])
        print("Rendered:", res)
