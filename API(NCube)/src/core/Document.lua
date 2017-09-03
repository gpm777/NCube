local NCLElem = require "core/NCLElem"

local Head = require "core/Head"

local Body = require "core/Body"

local Document = Class:createClass(NCLElem)

Document.name = "ncl"

Document.xmlHead = nil

Document.attributes = { 
  id = nil,
  title = nil,
  xmlns = nil
}

Document.childsMap = {
 ["head"] = {Head, "one", 1}, 
 ["body"] = {Body, "one", 2}
}

Document.head = nil
Document.body = nil
Document.seq = true

function Document:create(attributes, xmlHead, empty)
   local attributes = attributes or {}  
   local xmlHead = xmlHead or {}  
   local document = Document:new()   
   
   document:setAttributes(attributes)   
   document:setChilds() 
   document:setXmlHead(xmlHead)
   
   if(empty ~= nil)then
      document:setHead(Head:create(empty))   
      document:setBody(Body:create(nil, empty))  
   end

   return document
end

function Document:setId(id)
   self.attributes.id = id
end

function Document:getId()
   return self.attributes.id
end

function Document:setTitle(title)
   self.attributes.title = title
end

function Document:getTitle()
   return self.attributes.title
end

function Document:setXmlns(xmlns)
   self.attributes.xmlns = xmlns
end

function Document:getXmlns()
   return self.attributes.xmlns
end

function Document:setXmlHead(xmlHead)
   self.xmlHead = xmlHead
end

function Document:getXmlHead()
   return self.xmlHead
end

function Document:setHead(head)
   self.head = head
   self:addChild(head, 1)
end

function Document:getHead()
   return self.head
end

function Document:setBody(body)
   self.body = body
   self:addChild(body, 2)
end

function Document:getBody()
   return self.body
end

function Document:saveNcl(name)
   local ncl = self:generateNcl(0)   
   local file = io.open(name, "w")       
   file:write(ncl)   
   file:close()
end

function Document:loadNCL(name)
   local file = io.open(name, "a+")
   io.input(file)   
   
   local ncl = "" 
   local isXmlHead = true;
   
   for line in io.lines() do
      if(isXmlHead)then
         self:setXmlHead(line)
         isXmlHead = false
      else
         ncl = ncl..line.."\n"
      end
   end   

   self:setNcl(ncl)
   
   file:close()
   
   self:generateElem()
   
--   for i, v in ipairs(self:getChilds()) do
--      if(v.hasAss)then
--      end
--   end
end

return Document