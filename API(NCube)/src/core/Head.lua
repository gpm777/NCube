local NCLElem = require "core/NCLElem"

local RegionBase = require "core/RegionBase"
local DescriptorBase = require "core/DescriptorBase"

local Head = Class:createClass(NCLElem)

Head.name = "head"

Head.childsMap = {
 ["regionBase"] = {RegionBase, "many", 1}, 
 ["descriptorBase"] = {DescriptorBase, "one", 2}
}

Head.regionBases = nil
Head.descriptorBase = nil
Head.seq = true

function Head:create(empty)
   local head = Head:new()
      
   head:setChilds()   
   
   if(empty ~= nil)then      
      head.regionBases = {}
      head:addChild({} , 1)
      
      local descriptorBase = DescriptorBase:create(nil, empty)
      head:setDescriptorBase(descriptorBase)
   end
   return head
end

function Head:addRegionBase(regionBase)
    table.insert(self.regionBases, regionBase)
    table.insert(self:getChild(1), regionBase)
end

function Head:getRegionBase(i)
    return self.regionBases[i]
end

function Head:getRegionBaseById(id)
   for i, v in ipairs(self.regionBases) do
       if(self.regionBases[i]:getId() == id)then
          return self.regionBases[i]
       end
   end
   
   return nil
end

function Head:setRegionBases(...)
    if(#arg>0)then
      for i, v in ipairs(arg[1]) do
          self:addRegionBase(v)
      end
    end
end

function Head:setDescriptorBase(descriptorBase)
   self.descriptorBase = descriptorBase
   self:addChild(descriptorBase, 2)
end

function Head:getDescriptorBase()
   return self.descriptorBase
end

return Head