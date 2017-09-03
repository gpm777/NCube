require("core/NCube")

local doc = Document:create({id="doc", xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"}, "<?xml version= \"1.0\" encoding=\"ISO-8859-1\"?>", true)

local rb1 = RegionBase:create({id="rb1", device="rbTV"}, true)

doc:getHead():addRegionBase(rb1)

local rg1 = Region:create{id="rg1", width="100%", height="100%"}

rb1:addRegion(rg1)

local d1 = Descriptor:create{id="d1", region="rg1"}

doc:getHead():getDescriptorBase():addDescriptor(d1)

local p1 = Port:create{id="p1", component="m1"}

local m1 = Media:create{id ="m1", src="media/media1.mpg", type="video/mpeg", descriptor="d1"}

doc:getBody():addPort(p1)
doc:getBody():addMedia(m1)

doc:saveNcl("doc.ncl")