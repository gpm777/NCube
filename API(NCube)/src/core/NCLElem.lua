Class = require "oo/Class"

local NCLElem = Class:createClass{
  name = nil, 
  childs = nil,
  childsAux = nil,
  childsMap = nil,
  attributes = nil, 
  ncl = nil,
  seq = nil,
  hasAss = nil
}

function NCLElem:setName(name)
    self.name = name
end

function NCLElem:getName()
    return self.name
end

function NCLElem:addChild(child, p)
    if(p ~= nil)then
       self.childs[p] = child
    else
       table.insert(self.childs, child)
    end
end

function NCLElem:getChild(i)
    return self.childs[i]
end

function NCLElem:getChildById(id)
   
   local childTarget = nil
   local childs = self.childsAux 
   local nchilds = #childs
               
   if(childs ~= nil)then
     for i=1,nchilds do
         local child = self.childsAux[i]
         if(child["getId"] ~= nil and child:getId() == id)then
            childTarget = child
            if(childTarget ~= nil)then
               return childTarget
            end 
         else
            local grandChilds = child.childsAux
            if(grandChilds ~= nil)then
               for j, grandChild in ipairs(grandChilds)do
                  if(grandChild["getId"] ~= nil and grandChild:getId() == id)then
                     childTarget = grandChild
                  else
                     childTarget = grandChild:getChildById(id)
                  end 
                  if(childTarget ~= nil)then
                     return childTarget
                  end 
               end
            end
         end
      end
   end
   
   return childTarget
end

function NCLElem:setChilds(...)
    self.childs = {}
    if(#arg>0)then
      for i, v in ipairs(arg) do
          self.childs[i] =  v
      end
    end
end

function NCLElem:getChilds()
    return self.childs
end

function NCLElem:getChildsMap()
    return self.childsMap
end

function NCLElem:addAttribute(attribute, value)
    if(attribute ~= "" and value ~= "")then
       self.attributes[attribute] = value
    end
end

function NCLElem:getAttribute(attribute)
    return self.attributes[attribute]
end

function NCLElem:setAttributes(attributes)
    self.attributes = {}
    local attributes = attributes or {}
    for i, v in pairs(attributes) do
       self:addAttribute(i, v)
    end
end

function NCLElem:getAttributes()
    return self.attributes
end

function NCLElem:generateElem()   
   local s, e, t, u = nil
   local elemNCL = self:getNcl()    
     
   _, s = string.find(elemNCL, "<"..self:getName().." ")
   _, t = string.find(elemNCL, "<"..self:getName()..">")
   e = string.find(elemNCL, ">")

   if(s ~= nil and t == nil and e ~= nil)then
     local attributes = string.sub(elemNCL,s,e-1)   
     local w = nil
     
     for w in string.gmatch(attributes, "%S+") do
       t = string.find(w, "=")
       local attribute = string.sub(w, 1, t-1)
       
       local valuewithQuotes = string.sub(w,t+2,string.len(w))
       u = string.find(valuewithQuotes, "\"")
       local value = string.sub(valuewithQuotes, 1, u-1)  
       self:addAttribute(attribute, value)
     end
   end
   
   s = string.find(elemNCL, "<"..self:getName())
   t = string.find(elemNCL, "</"..self:getName()..">")  
   e = string.find(elemNCL, ">")
     
   local childsNCL = nil
   
   if(s ~= nil and t ~= nil and e ~= nil)then
        childsNCL = string.sub(elemNCL, e+1, t-1)   
   end              
   
   if(childsNCL ~= nil)then
     repeat     
       s, e = string.find(childsNCL, "<%a+")      
       local childName = nil
       
       if(s ~= nil and e ~= nil)then
          childName = string.sub(childsNCL, s+1, e)
               
          s = string.find(childsNCL, "<"..childName)
          _, t  = string.find(childsNCL, "</"..childName..">")
          e = string.find(childsNCL, ">")
          
          local childNCL = nil
          
          if(s ~= nil)then
            if(t ~= nil)then
               childNCL = string.sub(childsNCL, s, t)
               else if(e ~= nil)then
                    childNCL = string.sub(childsNCL, s, e)
               end
            end
          end  
          
          if(childNCL ~= nil)then          
             local childClass = self:getChildsMap()[childName][1]
                          
             local childObject = childClass:create()            
             
             childObject:setNcl(childNCL)
             childObject:generateElem()  
             
             if(self.childsAux == nil)then
                self.childsAux = {}
             end
             
             table.insert(self.childsAux, childObject)   
             
             local cardinality = self:getChildsMap()[childName][2]
             
             local p = self:getChildsMap()[childName][3]
                 
             if(self.seq)then             
               if(cardinality == "many")then    
                  if(self[childName..'s'] == nil and self:getChild(p) == nil)then
                     self[childName..'s'] = {}
                     self.childs[p] = {}
                  end
                              
                  table.insert(self[childName.."s"], childObject) 
                  table.insert(self:getChild(p), childObject)                
               else if(cardinality == "one")then                       
                       self[childName] = childObject 
                       self:addChild(childObject, p)
                    end
               end  
             else 
                if(self[childName.."s"] == nil)then
                     self[childName.."s"] = {}
                end
                table.insert(self[childName.."s"], childObject) 
                self:addChild(childObject)
             end   
                                                              
             local c1, c2 = nil
             
             if(t ~= nil)then
                c1 = string.sub(childsNCL, 1, s-1)
                c2 = string.sub(childsNCL, t+1, string.len(childsNCL))
                else if(e ~= nil)then
                     c1 = string.sub(childsNCL, 1, s-1)
                     c2 = string.sub(childsNCL, e+1, string.len(childsNCL))
                end
             end
             
             childsNCL = c1..c2
          end
       end
       
     until (s == nil)
   end
end

function NCLElem:generateNcl(deep)
  local ncl = ""
  
  if(deep == 0 and self:getName() == "ncl")then
     ncl = self:getXmlHead().."\n"
  else
    for i=1,deep do
       ncl = ncl.." "
    end 
  end 
    
  ncl = ncl.."<"..self:getName()
  
  local attrs = self:getAttributes()
  if(attrs ~= nil)then
    for k, v in pairs(attrs) do
         if(v ~= nil)then
            ncl = ncl.." "..k.."=".."\""..v.."\""
         end
    end
  end 
 
  local childs = self:getChilds()
  local nchilds = #childs
  
  if(nchilds == 0)then
     return ncl.."/>\n"
  end
  
  if(childs ~= nil)then
     ncl = ncl..">\n"  
     for i=1,nchilds do
         local child = self:getChild(i)
         local nchild = #child
                     
         if(nchild > 0)then
            for j, v in ipairs(child) do
                ncl = ncl..v:generateNcl(deep+1)
             end    
          else 
             ncl = ncl..child:generateNcl(deep+1)
          end          
     end
           
     for i=1,deep do
         ncl = ncl.." "
     end 
  end
  
  return ncl.."</"..self:getName()..">\n"
end

function NCLElem:setNcl(ncl)
   self.ncl = ncl
end

function NCLElem:getNcl()
   return self.ncl
end

function NCLElem:writeNcl()
  print(self:generateNcl(0))
end

return NCLElem