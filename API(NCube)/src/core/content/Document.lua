local NCLElem = require "core/NCLElem"
local Head = require "core/content/Head"
local Body = require "core/content/Body"

local Document = NCLElem:extends()

Document.name = "ncl"

Document.childrenMap = {
 ["head"] = {Head, "one"}, 
 ["body"] = {Body, "one"}
}

function Document:create(attributes, xmlHead, full)
   local xmlHead = xmlHead or {}  
   local document = Document:new()   
   
   document.attributes = { 
      ["id"] = "",
      ["title"] = "",
      ["xmlns"] = "",
      ["xmlns:xsi"] = "",
      ["xsi:schemaLocation"] = ""
   }
   
   if(attributes ~= nil)then
      document:setAttributes(attributes)
   end
   
   document.children = {}
   document:setXmlHead(xmlHead)
   
   if(full ~= nil)then
      document:setHead(Head:create(full))   
      document:setBody(Body:create(nil, full))  
   end

   return document
end

function Document:setId(id)
   self:addAttribute("id", id)
end

function Document:getId()
   return self:getAttribute("id")
end

function Document:setTitle(title)
   self:addAttribute("title", title)
end

function Document:getTitle()
   return self:getAttribute("title")
end

function Document:setXmlns(xmlns)
   self:addAttribute("xmlns", xmlns)
end

function Document:getXmlns()
   return self:getAttribute("xmlns")
end

function Document:setXsi(xsi)
   self:addAttribute("xmlns:xsi", xsi)
end

function Document:getXsi()
   return self:getAttribute("xmlns:xsi")
end

function Document:setSchemaLocation(schemaLocation)
   self:addAttribute("xsi:schemaLocation", schemaLocation)
end

function Document:getSchemaLocation()
   return self:getAttribute("xsi:schemaLocation")
end

function Document:setXmlHead(xmlHead)
   self.xmlHead = xmlHead
end

function Document:getXmlHead()
   return self.xmlHead
end

function Document:setHead(head)
   self:addChild(head, 1)
   self.head = head
end

function Document:getHead()
   return self.head
end

function Document:removeHead(head)
   self:removeChild(head)
   self.head = nil
end

function Document:setBody(body)
   self:addChild(body, 2)
   self.body = body
end

function Document:getBody()
   return self.body
end

function Document:removeBody(body)
   self:removeChild(body)
   self.body = nil
end

function Document:saveNcl(name)
   local ncl = self:table2Ncl(0)   
   local file = io.open(name, "w")       
   file:write(ncl)   
   file:close()
end

function Document:removeComments(ncl)
   local newNcl = ncl
   
   local t, u = string.find(newNcl,"<!--.-->")
   
   if(t == nil and u == nil)then
       return newNcl
   end
  
   while(1)do
     local aux1 = string.sub(newNcl, 1, t-1)
     local aux2 = string.sub(newNcl, u+1, string.len(newNcl))
     
     newNcl = aux1..aux2
     
     t, u = string.find(newNcl,"<!--.-->")
     
     if(t == nil and u == nil)then
        break
     end
   end
   
   return newNcl
end

function Document:readNclFile(name)
   local ncl = "" 
   local isXmlHead = true;
   
   local file = io.open(name, "r")
   io.input(file)       
     
   for line in io.lines() do
      if(isXmlHead)then
         self:setXmlHead(line)
         isXmlHead = false
      else
         ncl = ncl..line.."\n"
      end
   end  
       
   file:close()
   
   return ncl
end

function Document:connectAssociatedElements()
   local descendants = self:getDescendants()
   
   if(descendants ~= nil)then
       for _, descendant in ipairs(descendants) do
           if(descendant.hasAss == true)then
              for _, ass in ipairs(descendant:getAssMap()) do
                 local id = descendant:getAttribute(ass[1])
                 local field = ass[2]                
                 descendant[field] = self:getDescendantByAttribute("id", id)
              end
           end
       end
   end
end

function Document:loadNcl(name)
   local ncl = self:readNclFile(name) 
   ncl = self:removeComments(ncl)
   self:setNcl(ncl) 
   self:ncl2Table()
   self:connectAssociatedElements()
end

return Document