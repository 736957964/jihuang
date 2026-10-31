# -*- coding: utf-8 -*-
import http.client
import json

conn = http.client.HTTPConnection("127.0.0.1", 3000, timeout=10)
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer 3Az8ZteKSuvWFXX5BGa-r1j_aX4JL3RKX1ZbKSUja7U"
}
body = json.dumps({"group_id": 773647531, "message": "已归档铭感会话"}, ensure_ascii=False).encode("utf-8")
conn.request("POST", "/send_group_msg", body, headers)
res = conn.getresponse()
print("status:", res.status, res.read().decode("utf-8"))
conn.close()