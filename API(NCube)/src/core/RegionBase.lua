local NCLElem = require "core/NCLElem"

local Region = require "core/Region"

local RegionBase = Class:createClass(NCLElem)

RegionBase.name = "regionBase"

RegionBase.attributes = { 
  id = nil,
  device = nil,
  region = nil 
}

RegionBase.childsMap = {
 ["region"] = {Region, "many", 1}
}

RegionBase.regions = nil
RegionBase.seq = true

function RegionBase:create(attributes, empty)
   local attributes = attributes or {}     
   local regionBase = RegionBase:new()  
    
   regionBase:setAttributes(attributes)
   regionBase:setChilds()  
   
   if(empty ~= nil)then
      regionBase.regions = {}
      regionBase.childs[1] = {} 
   end
   
   return regionBase
end

function RegionBase:setId(id)
   self.attributes.id = id
end

function RegionBase:getId()
   return self.attributes.id
end

function RegionBase:setDevice(device)
   self.attributes.device = device
end

function RegionBase:getDevice()
   return self.attributes.device
end

function RegionBase:setRegionExt(region)
   self.attributes.region = region
end

function RegionBase:getRegionExt()
   return self.attributes.region
end

function RegionBase:addRegion(region)
    table.insert(self.regions, region)
    table.insert(self:getChild(1), region)
end

function RegionBase:getRegion(i)
    return self.regions[i]
end

function RegionBase:getRegionById(id)
   for i, v in ipairs(self.regions) do
       if(self.regions[i]:getId() == id)then
          return self.regions[i]
       end
   end
   
   return nil
end

function RegionBase:setRegions(...)
    if(#arg>0)then
      for i, v in ipairs(arg) do
          self:addRegion(v)
      end
    end
end

return RegionBase