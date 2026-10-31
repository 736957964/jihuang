# -*- coding: utf-8 -*-
import urllib.request, json, os, zipfile, io, time

TOP_MODS = [
    ('375850593', 'Extra Equip Slots', '棰濆瑁呭鏍忎笌鐙珛妲戒綅'),
    ('462434129', 'Restart', '涓栫晫閲嶅紑涓庣綉缁淩PC璋冨害'),
    ('378160973', 'Global Positions', '鍏ㄥ浘瀹氫綅涓庣綉缁滆〃鍚屾'),
    ('1207269292', 'Simple Health Bar', '绠€鏄撹鏉′笌UI鍔ㄦ€佽拷韪?),
    ('345692228', 'Minimap HUD', '灏忓湴鍥綡UD鎸傝浇'),
    ('666155465', 'Show Me', '淇℃伅鏄剧ず涓庡鎴风鏁版嵁绐ユ帰'),
    ('790933758', 'Combined Status', '鍏ㄧ姸鎬佸父椹荤洃鎺I'),
    ('1467214795', 'Insight', '鍏ㄥ疄浣撳睘鎬т笌鎺夎惤鍒嗘瀽'),
    ('351325790', 'Geometric Placement', '寤虹瓚鍑犱綍瀵归綈涓庣綉鏍兼覆鏌?),
    ('362175979', 'Wormhole Marks', '铏礊鏍囪涓庝笘鐣屽疄浣擄拷锟借壊')
]

out_dir = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main\workshop_mods"
os.makedirs(out_dir, exist_ok=True)
log_file = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main\worker.log"

def log(msg):
    t = time.strftime('%Y-%m-%d %H:%M:%S')
    line = f'[{t}] {msg}\n'
    print(line, end='', flush=True)
    with open(log_file, 'a', encoding='utf-8') as f:
        f.write(line)

log('Starting DST Workshop Background Worker...')

for fid, title, desc in TOP_MODS:
    mod_dest = os.path.join(out_dir, f'{fid}_{title}')
    if os.path.exists(mod_dest):
        log(f'Mod already downloaded: {title} ({fid})')
        continue
    log(f'Fetching metadata for {title} ({fid})...')
    try:
        url = 'https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/'
        data = f'itemcount=1&publishedfileids[0]={fid}'
        req = urllib.request.Request(url, data=data.encode('utf-8'), headers={'User-Agent': 'Mozilla/5.0', 'Content-Type': 'application/x-www-form-urlencoded'})
        with urllib.request.urlopen(req, timeout=15) as resp:
            res = json.loads(resp.read().decode('utf-8'))
        details = res.get('response', {}).get('publishedfiledetails', [{}])[0]
        furl = details.get('file_url')
        if not furl:
            log(f'No direct file_url for {title} ({fid})')
            continue
        log(f'Downloading {title}...')
        req2 = urllib.request.Request(furl, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req2, timeout=30) as r2:
            zdata = r2.read()
        os.makedirs(mod_dest, exist_ok=True)
        with zipfile.ZipFile(io.BytesIO(zdata)) as z:
            z.extractall(mod_dest)
        log(f'Successfully downloaded and extracted {title} ({len(zdata)} bytes)')
        time.sleep(2)
    except Exception as e:
        log(f'Error processing {title} ({fid}): {e}')

log('Worker run finished.')

