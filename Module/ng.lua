Delegate.RegDelTalkEvent("ng_TalkEvent");

function ng_TalkEvent(player,msg,color,range,size)
	if (msg == "/bbyd")then  ---步步遇敌
		local getXiangVar1 = Char.GetData(player,%对象_香步数%);
		local getXiangVar2 = Char.GetData(player,%对象_香上限%);
		if(getXiangVar1 > 0)then
			Char.SetData(player,%对象_香步数%,0);
			Char.SetData(player,%对象_香上限%,0);
			NLG.SystemMessage(player,"步步遇敌已经关闭！");
		else
			Char.SetData(player,%对象_香步数%,999);
			Char.SetData(player,%对象_香上限%,999);
			NLG.SystemMessage(player,"步步遇敌已经开启！");
		end
	end
		if(msg == "/byd")then  --不遇敌
		local kg = Char.GetData(player,%对象_不遇敌开关%);
		if(kg == 0)then
			 Char.SetData(player,%对象_不遇敌开关%,1);
			NLG.SystemMessage(player,"不遇敌已经开启！");
		else
			 Char.SetData(player,%对象_不遇敌开关%,0);
			NLG.SystemMessage(player,"不遇敌已经关闭！");
		end
	end
	if (msg == "/hc")then   ---回城
		Char.Warp(player, 0, 1000, 242, 88)
		NLG.SystemMessage(player,"恭喜您已回城。");
		return 0
	end	
	if (msg == "/zl")then   ---背包整理
		NLG.SortItem(player);
		NLG.SystemMessage(player,"背包整理完毕。");
		return 0
	end	
	if msg == "/jd" then  ----鉴定
		local Count = 0
		for ItemSlot = 8,27 do
			local ItemIndex = Char.GetItemIndex(player, ItemSlot)
			if ItemIndex > 0 then
				local money = Char.GetData(player,%对象_金币%);
				local itemLevel = Item.GetData(ItemIndex,%道具_等级%);
				local kcmb = itemLevel*200;
				if Item.GetData(ItemIndex, %道具_已鉴定%)==0 and money >= (itemLevel*200) then
					Count = Count + 1
					Char.SetData(player,%对象_金币%,money-kcmb);
					Item.SetData(ItemIndex, %道具_已鉴定%, 1)
					NLG.SystemMessage(player,"[系统] 您鉴定的道具等级为"..itemLevel.."级。扣除魔币"..kcmb.."G");
					NLG.SystemMessage(player,"[系统] 你身上的 " .. Item.GetData(ItemIndex, %道具_鉴前名%) .. "已鉴定为 " .. Item.GetData(ItemIndex, %道具_名字%))
					Item.UpItem(player, ItemSlot);
					NLG.UpChar(player);
					return ;
				end
			end
		end
		if Count==0 then
			NLG.SystemMessage(player,"[系统] 你身上没有需要鉴定的物品【或你的钱不足以鉴定此道具】");
			return;
		end
		return 0
	end	
	if msg == "/xl" then  ----修理
		local Count = 0
		for ItemSlot = 8,27 do
			local ItemIndex = Char.GetItemIndex(player, ItemSlot)
			local money = Char.GetData(player,%对象_金币%);
			local itemLevel = Item.GetData(ItemIndex,%道具_等级%);
			local itemName = Item.GetData(ItemIndex,%道具_名字%);
			local itemDurability = Item.GetData(ItemIndex,%道具_耐久%);
			local itemMaxDurability = Item.GetData(ItemIndex,%道具_最大耐久%);
			local equipmentDamage = itemMaxDurability-itemDurability
			local jdnj = equipmentDamage*0.5
			local costOfRepair = jdnj*10
			local itemType = Item.GetData(ItemIndex,%道具_类型%);
			if money > costOfRepair and itemMaxDurability > itemDurability and itemType>= 0 and itemType <= 14 then
				Count = Count + 1
				Char.SetData(player,%对象_金币%,money-costOfRepair);
				Item.SetData(ItemIndex,%道具_耐久%,itemDurability+equipmentDamage);
				Item.UpItem(player, ItemSlot);
				local itemDurability1 = Item.GetData(ItemIndex,%道具_耐久%);
				local itemMaxDurability1 = Item.GetData(ItemIndex,%道具_最大耐久%);
				Item.SetData(ItemIndex,%道具_耐久%,itemDurability1+jdnj);
				Item.SetData(ItemIndex,%道具_最大耐久%,itemMaxDurability1+jdnj);
				NLG.SystemMessage(player,"[系统] 您修理的装备【"..itemName.."】恢复了【"..equipmentDamage.."】耐久。扣除魔币【"..costOfRepair.."G】");
				Item.UpItem(player, ItemSlot);
				NLG.UpChar(player);
				return 0
			end
		end
		if Count == 0 then
			NLG.SystemMessage(player,"[系统] 你道具栏第一格没有要恢复耐久的装备或者您的修理魔币不足。");
			return 0
		end
		return 0
	end
	if msg == "/dk" then  --打卡
		local daka = Char.GetData(player, 4008);
		local money = Char.GetData(player,%对象_金币%);
		if daka == 0 and money >= 200 then
			Char.SetData(player,%对象_金币%,money-200);
			Char.FeverStart(player);
			NLG.UpChar(player);
			NLG.SystemMessage(player, "扣除魔币200G。");	
			NLG.SystemMessage(player, "恭喜您打卡成功。");	
			return ;
		end
		if daka == 1 and money >= 200 then
			Char.SetData(player,%对象_金币%,money-200);
			Char.FeverStop(player);
			NLG.UpChar(player);
			NLG.SystemMessage(player, "扣除魔币200G。");
			NLG.SystemMessage(player, "恭喜您关闭打卡成功。");	
			return ;
		end
		if money < 200 then
			NLG.SystemMessage(player, "您的魔币不够，无法使用。");	
			return ;
		end
	end
	if msg == "/zh" then  ---快捷招魂
		local ZH = Char.GetData(player,170);
		local money = Char.GetData(player,%对象_金币%);
		local LV = Char.GetData(player,%对象_等级%);
		local ZHMB = ZH*200;
		local ZHMBKC = ZHMB*LV
		if ZH <= 0 then
			NLG.SystemMessage(player,"你没有掉魂。");	
		end
		if money >= ZHMBKC and ZH > 0 then
			Char.SetData(player,%对象_金币%,money-ZHMBKC);
			Char.SetData(player,170,ZH-ZH);
			Char.FeverStop(player);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"招魂完成。招魂数量为【"..ZH.."】费用为【"..ZHMBKC.."】魔币。");	
		end
		if money < ZHMBKC then
			NLG.SystemMessage(player,"连钱都没有你还招魂，一边尿尿玩泥巴去吧。【招魂价格计算 掉魂*1000*等级】");	
		end
	end
	return 1;
end
