local dumper = {
	data = {},
};

---
-- @param table options What is saved
function dumper:dump(options)
  self.data = {};
  
  
end

---
-- Get entity field
function dumper:getEntity(name)
  if self.data[name] ~= nil then
    return self.data[name];
  end
end
