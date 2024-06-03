
use "data/setpiece";

use "data/configurations/layouts"

local layouts = use "data/layouts"
for k, v in pairs(layouts) do
    if v.enabled then
       v.load(v.count, v.chance)
    end
end

_G.RemoveListener = use "data/scripts/RemoveListener"
_G.RemoveWatchWorldState = use "data/scripts/RemoveWatchWorldState"
