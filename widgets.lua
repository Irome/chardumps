local chardumps = chardumps;
local widgets = {};

function widgets:checkbox(name, x, y, parent)
  local L = chardumps:GetLocale();
  local chbName = parent:GetName() .. name;
  local chb = CreateFrame("CheckButton", chbName, parent, "ChatConfigCheckButtonTemplate");
  chb:ClearAllPoints();
  chb:SetPoint("TOPLEFT", parent, x, -y);
  chb:SetWidth(chbWidth);
  chb:SetHeight(chbHeight);
  chb:SetChecked(true);

  self:SetTooltip(chb, L[name], L["tt" .. name]);

  local chbText = getglobal(chbName .. "Text");
  chbText:SetText(L[name]);

  return chb;
end

local chbWidth = 24;
local chbHeight = 22;
local btnWidth = 20;
local btnHeight = 20;
local frameWidth = 540;
local frameHeight = 310;


function widgets:button(name, x, y, cx, cy, parent, title)
  local L = chardumps:GetLocale();
  local btnName = parent:GetName() .. name;
  local btn = CreateFrame("Button", btnName, parent, "OptionsButtonTemplate");
  btn:ClearAllPoints();
  btn:SetPoint("TOPLEFT", parent, x, -y);
  btn:SetWidth(cx);
  btn:SetHeight(cy);
  if not title then
    title = L[name];
  end
  widgets:SetTooltip(btn, title, L["tt" .. name]);
  btn:SetText(L[name]);

  return btn;
end

local function createMessageBox()
  local dialog = CreateFrame("Frame", nil, UIParent);

  dialog:ClearAllPoints();
  dialog:SetPoint("CENTER", UIParent);
  dialog:SetHeight(78);
  dialog:SetWidth(200);

  dialog:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = {left = 1, right = 1, top = 1, bottom = 1},
  });
  dialog:SetFrameStrata("TOOLTIP");
  dialog:EnableMouse(true);
  dialog:SetMovable(true);

  dialog:SetScript("OnMouseDown", function(this)
    if ( ( ( not this.isLocked ) or ( this.isLocked == 0 ) ) and ( arg1 == "LeftButton" ) ) then
      this:StartMoving();
      this.isMoving = true;
    end
  end);
  dialog:SetScript("OnMouseUp", function(this)
    if ( this.isMoving ) then
      this:StopMovingOrSizing();
      this.isMoving = false;
    end
  end);
  dialog:SetScript("OnHide", function(this)
    if ( this.isMoving ) then
      this:StopMovingOrSizing();
      this.isMoving = false;
    end
  end);

  dialog.Title = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal");
  dialog.Title:SetPoint("TOPLEFT", dialog, "TOPLEFT", 6, -10);
  dialog.Title:SetTextColor(1.0,1.0,0.0,1.0);
  dialog.Title:SetText("null");

  dialog.Text = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal");
  dialog.Text:SetPoint("CENTER",dialog,"CENTER",0,0);
  dialog.Text:SetTextColor(1.0,1.0,1.0);
  dialog.Text:SetText(L.areyousure);

  dialog.YesButton = CreateFrame("Button", nil, dialog, "OptionsButtonTemplate");
  dialog.YesButton:SetWidth(90);
  dialog.YesButton:SetHeight(24);
  dialog.YesButton:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -4, 4);
  dialog.YesButton:SetScript("OnClick", function()
    if dialog.onOK then
      dialog:onOK();
    end
    dialog:Hide();
  end);
  dialog.YesButton:SetText(L.Yes);

  dialog.NoButton = CreateFrame("Button", nil, dialog, "OptionsButtonTemplate");
  dialog.NoButton:SetWidth(90);
  dialog.NoButton:SetHeight(24);
  dialog.NoButton:SetPoint("BOTTOMLEFT", dialog, "BOTTOM", 4, 4);
  dialog.NoButton:SetScript("OnClick", function() dialog:Hide() end);
  dialog.NoButton:SetText(L.No);

  dialog.SetTitle = function(title)
    dialog.Title:SetText(title);
  end

  --dialog:Hide();

  return dialog;
end

---
-- Simple dialog with Ok and Cancel buttons
function widgets:showMessageBox(title, onOk)
  if self.messageBox == nil then
    self.messageBox = createMessageBox();
  end
  self.messageBox:setTitle(title);
  self.messageBox.onOk = onOk;
  self.messageBox.Show();
end

---
-- Add tooltip to the frame
function widgets:SetTooltip(frame, title, text)
  frame.tooltipTitle = title;
  frame.tooltipText = text;
  frame:SetScript("OnEnter", function()
        GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");
        GameTooltip:ClearLines();
        GameTooltip:SetText(frame.tooltipTitle);
        GameTooltip:AddLine(frame.tooltipText, 1, 1, 1, true);
        GameTooltip:Show();
      end);
  frame:SetScript("OnLeave", function() GameTooltip:Hide() end);
end

---
-- Return common addon backdrop
function widgets:GetBackdrop()
  local backdrop = {
    bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = {
      left = 5,
      right = 5,
      top = 5,
      bottom = 5
    }
  }

  return backdrop;
end

local framePrefix = "chd";

function widgets:GetFrameName(name, parentName)
  local result = framePrefix;
  if parentName ~= nil and type(parentName) == "string" then
    result = result .. parentName:sub(1, 1):upper() .. parentName:sub(2);
  end
  result = result .. name:sub(1, 1):upper() .. name:sub(2);

	return result;
end

function widgets:GetWidget(name)
  local realName = name:sub(1, 1):upper() .. name:sub(2);
  local frameName = framePrefix .. realName;
  return getglobal(frameName);
end

chardumps.widgets = widgets;
