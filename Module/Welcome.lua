local announceflg = true; --对首次进入游戏玩家全副公告
local useloginpoint = false; --是否开启新玩家自定义登陆点,可以再cgmsv.cf中设置,所以默认关闭
local WelcomeMessage = {};--欢迎词
table.insert(WelcomeMessage,"你好呀，冒险者");
table.insert(WelcomeMessage,"Ctrl+1 内挂菜单，Ctrl+3 英雄管理菜单，/1 自动遇敌 /2 不遇敌。");
table.insert(WelcomeMessage,"点亮交易按钮开启战斗结束整理背包+卖魔石!");

Delegate.RegDelLoginEvent("Welcome_LoginEvent");

function Welcome_LoginEvent(player)
	if (WelcomeMessage ~= nil) then --欢迎词
		for _,text in ipairs(WelcomeMessage) do
		      NLG.TalkToCli(player,-1,text,%颜色_黄色%,%字体_中%);
		end
		if (announceflg == true and Char.GetData(player,%对象_登陆次数%) == 1) then
			NLG.SystemMessage(-1,"欢迎["..Char.GetData(player,%对象_原名%).."]来到了游戏.")
		end
	end

	if (useloginpoint == true and Char.EndEvent(player,0) == 0) then
		Char.Warp(player,0,1530,15,6);
	end

	local szBuffer ="\\n            你好呀，冒险者"..
					"\\n\\n欢迎你来到这个世界"..

	NLG.ShowWindowTalked(player,player, 10, 2, 44, szBuffer);
end