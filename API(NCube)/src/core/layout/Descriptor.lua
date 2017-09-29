local NCLElem = require "core/structure_content/NCLElem"

local Descriptor = NCLElem:extends()

Descriptor.name = "descriptor"

Descriptor.attributes = {
  id = nil,  
  region = nil
}

Descriptor.hasAss = true

Descriptor.assMap = {
  {"region", "regionAss"}
}

Descriptor.regionAss = nil

function Descriptor:create(attributes)  
   local attributes = attributes or {}  
   local descriptor = Descriptor:new() 
     
   descriptor:setAttributes(attributes)
   descriptor:setChilds()
   
   return descriptor
end

function Descriptor:setId(id)
   self.attributes.id = id
end

function Descriptor:getId()
   return self.attributes.id
end

function Descriptor:setRegion(region)
   self.attributes.region = region
end

function Descriptor:getRegion()
   return self.attributes.region
end

function Descriptor:setRegionAss(regionAss)
   self.regionAss = regionAss
end

function Descriptor:getRegionAss()
   return self.regionAss
end

return Descriptor