local chardumps = chardumps;

function chardumps:getEntityManager()
	return self.entityManager;
end

function chardumps:getEncryption()
  return self.encryption;
end

function chardumps:GetLocale()
	return self.locale;
end

function chardumps:GetVersion()
	return "1.11";
end

function chardumps:getPatchVersion()
	if self.patchVertion == nil then
		local _, clientBuild = GetBuildInfo();
		clientBuild = tonumber(clientBuild);
		if clientBuild >= 6080 and clientBuild <= 8478 then
			self.patchVertion = 2;
		elseif clientBuild >= 9056 and clientBuild <= 12340 then
			self.patchVertion = 3;
		elseif clientBuild >= 13164 and clientBuild <= 15595 then
			self.patchVertion = 4;
		end
	end
	return self.patchVertion;
end

---
-- Main initialization
function chardumps:Init()
	self:checkWowVersion();
	self:initSlashCommands();
	self:initConstants();

  self.options:Init();
	self.entityManager:Init();
	self.dumper:Init();
	self.mainFrame:Init();
end

function chardumps:initConstants()
  self.MAX_NUM_CONTINENT = 4;
end

---
-- Console commands
function chardumps:initSlashCommands()
  local helpFun = function()
    local log = chardumps.log;
    log:Message("/chardumps, /chardumps help");
    log:Message("/chardumps dump");
    log:Message("/chardumps clear");
    log:Message("/chardumps save");
    log:Message("/chardumps show");
    log:Message("/chardumps hide");
    log:Message("/chardumps version");
  end
  local commandHandlers = {
    help = helpFun,
    dump = function() print("dump...") end,
    clear = function() print("clear...") end,
    save = function() print("save...") end,
    show = function()
      chardumps.mainFrame:Show();
    end,
    hide = function()
      chardumps.mainFrame.OnHideClick();
    end,
    version = function() print("version...") end,
  };

  local commandId = "CHARDUMPS";
  _G["SLASH_" .. commandId .. 1] = "/chardumps";
  SlashCmdList[commandId] = function(msg, editBox)
    -- parse only one argument
    local commnadHandler = commandHandlers[msg];
    if (commnadHandler ~= nil) then
      commnadHandler();
    else
      helpFun();
    end
  end
end

function chardumps:checkWowVersion()
  assert("Unsupported WoW version. ASSERT");
	if self:getPatchVersion() == nil then
		error("Unsupported WoW version");
	end
end

chardumps:Init();