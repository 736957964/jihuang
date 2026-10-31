# -*- coding: utf-8 -*-
"""
饥荒官方与工坊知识库文档检索器 (Doc Searcher)
支持全库快速检索组件、事件、API与工坊MOD实现文档。
"""
import os, sys, json, argparse

ROOT = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main"

for name in ('stdout', 'stderr'):
    stream = getattr(sys, name, None)
    buf = getattr(stream, 'buffer', None)
    if buf is not None:
        try:
            import io
            setattr(sys, name, io.TextIOWrapper(buf, encoding='utf-8', errors='replace', line_buffering=True))
        except Exception:
            pass

def search_docs(keyword, limit=5):
    results = []
    kw = keyword.lower()
    for root, dirs, files in os.walk(ROOT):
        # 排除 git / idea
        if '.git' in root or '.idea' in root:
            continue
        for f in files:
            if f.endswith('.md') or f.endswith('.lua') or f.endswith('.txt'):
                fpath = os.path.join(root, f)
                relpath = os.path.relpath(fpath, ROOT)
                try:
                    with open(fpath, 'r', encoding='utf-8', errors='ignore') as fp:
                        content = fp.read()
                        if kw in content.lower() or kw in f.lower():
                            # 提取匹配片段
                            lines = content.split('\n')
                            matched_lines = [l.strip() for l in lines if kw in l.lower()]
                            snippet = " | ".join(matched_lines[:3])[:180]
                            results.append({
                                'path': relpath,
                                'file': f,
                                'snippet': snippet
                            })
                            if len(results) >= limit:
                                return results
                except Exception:
                    pass
    return results

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('keyword', type=str)
    parser.add_argument('--limit', type=int, default=5)
    args = parser.parse_args()
    res = search_docs(args.keyword, args.limit)
    print(json.dumps(res, ensure_ascii=False, indent=2))
