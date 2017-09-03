require("core/NCube")

local doc = Document:create()
doc:loadNCL("doc.ncl")

local rg1 = doc:getHead():getRegionBaseById("rb1"):getRegionById("rg1")

local d1 = doc:getHead():getDescriptorBase(1):getDescriptorById("d1")

print(doc:getChildById("rg1"):writeNcl())
print(doc:getChildById("rb1"):writeNcl())

--local rg3 = Region:create({id="rg3", width="100%", height="100%"})5
--doc:getHead():getRegionBase(1):addRegion(rg3)
--
--local d3 = Descriptor:create{id="d3", region="rg3"}
--
--doc:getHead():getDescriptorBase():addDescriptor(d3)
--
--doc:saveNcl("doc2.ncl")
