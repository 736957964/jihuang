>  坎普斯随笔
## projectile弹道
```lua 
inst:AddComponent("projectile")  --弹道组件
inst.components.projectile:SetSpeed(60) --弹道速度
inst.components.projectile:SetOnHitFn(onhit)--武器击中的时候触发自定义函数onhit
inst:ListenForEvent("onthrown", onthrown) --？？？？？ 投掷出去的时候
```
## projectile弹道
```lua 
inst:AddComponent("projectile")  --弹道组件
inst.components.projectile:SetSpeed(60) --弹道速度
inst.components.projectile:SetOnHitFn(onhit)--武器击中的时候触发自定义函数onhit
inst:ListenForEvent("onthrown", onthrown) --？？？？？ 投掷出去的时候
```
