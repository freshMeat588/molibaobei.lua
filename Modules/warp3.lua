local Warp=ModuleBase:createModule("warp3")

local warpPoints={
  { "圣拉鲁卡村", 0, 100, 134, 218 },
  { "伊尔村", 0, 100, 681, 343 },
  { "亚留特村", 0, 100, 587, 51 },
  { "维诺亚村", 0, 100, 330, 480 },
  { "奇利村", 0, 300, 273, 294 },
  { "加纳村", 0, 300, 702, 147 },
  { "杰诺瓦镇", 0, 400, 217, 455 },
  { "蒂娜村", 0, 400, 570, 274 },
  { "阿巴尼斯村", 0, 400, 248, 247 },
  { "阿凯鲁法村", 0, 33200, 99, 165 },
  { "坎那贝拉村", 0, 33500, 17, 76 },
  { "哥拉尔镇", 0, 43100, 120, 107 },
  { "鲁米那斯村", 0, 43000, 322, 883 },
  { "米诺基亚村", 0, 43000, 431, 823 },
  { "雷克塔尔镇", 0, 43000, 556, 313 },
  { "艾尔莎新城", 0, 59520, 143, 108 },
  { "辛梅尔", 0, 59519, 26, 17 },
  { "汉米顿村", 0, 32205, 127, 138 },
  { "亚纪城", 0, 32277, 33, 56 },
}

local function calcWarp()
  --[[math.modf 是 Lua 中的一个数学函数，用于获取一个数的整数部分和小数部分。
  它返回两个值，第一个值是输入数的整数部分，第二个值是小数部分。整数部分被截断为最接近零的整数，小数部分保持原来的符号。
  --
  --例如，math.modf(3.14) 返回值为 3 和 0.14，math.modf(-2.5) 返回值为 -2 和 -0.5。
  在上述代码中，math.modf(#warpPoints / 8) 的作用是计算 warpPoints 表的长度除以 8 的整数部分，以确定页数。]]
  local page=math.modf(#warpPoints/8)+1
  --[[math.fmod 是 Lua 中的一个数学函数，用于计算两个数的浮点数取余。它返回第一个数除以第二个数的余数，
  保持与被除数相同的符号。
  --
  --在你的代码中，math.fmod(#warpPoints, 8) 的作用是计算 warpPoints 表的长度除以 8 的余数，以确定剩余的数据量。
  #warpPoints 表示 warpPoints 表的长度，然后将其与 8 进行取余运算，得到剩余的数据量。]]
  local remaind=math.fmod(#warpPoints,8)
  return page,remaind
end

function Warp:onLoad()
  self:logInfo('load');
  local warpNpc=self:NPC_createNormal('传送石',103010,{x=240,y=81,mapType=0,map=1000,direction=6});
  self:NPC_regWindowTalkedEvent(warpNpc,function(npc,player,_seqno,_select,_data)
    local column=tonumber(_data)
    local page=tonumber(_seqno)
    local warpPage=page;
    local winMsg="1\\n请问你想去哪里\\n"
    local winButton=CONST_BUTTON_关闭；
    local totalPage,rest=calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.BUTTON_下一页 then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and rest == 0)) then
          winButton = CONST.BUTTON_上取消
        else
          winButton = CONST.BUTTON_上下取消
        end
      elseif _select == CONST.BUTTON_上一页 then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_下取消
        else
          winButton = CONST.BUTTON_下取消
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 8 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, rest + count do
          winMsg = winMsg .. warpPoints[i][1] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
          winMsg = winMsg .. warpPoints[i][1] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      local short = warpPoints[count]
      Char.Warp(player, short[2], short[3], short[4], short[5])
    end
  end)
  self:NPC_regTalkedEvent(warpNpc,function(npc,player)
    if(NLG.CanTalk(npc,player)==true) then
      local msg="1\\n请问你想去哪里\\n"
      for i=1,8 do
        msg = msg .. warpPoints[i][1] .. "\\n"
      end
      NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框,CONST.BUTTON_下取消,1,msg);
    end
    return
  end)
end 

function Warp:onUnload()
  self:logInfo('unload')
end
return Warp;
