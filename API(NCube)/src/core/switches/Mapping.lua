local NCLElem = require "core/NCLElem"

local Mapping = NCLElem:extends()

Mapping.nameElem = "mapping"

Mapping.attributesTypeMap = {
  component = "string",
  interface = "string"
}

Mapping.assMap = {
  {"component", "componentAss"},
  {"interface", "interfaceAss"}
}

function Mapping:create(attributes)
  local mapping = Mapping:new()

  mapping.component = nil
  mapping.interface = nil

  mapping.componentAss = nil
  mapping.interfaceAss = nil

  if(attributes ~= nil)then
    mapping:setAttributes(attributes)
  end

  return mapping
end

function Mapping:setComponent(component)
  if(type(component) == "table")then
    if(component["getNameElem"] ~= nil
      and component:getNameElem() ~= "switch"
      and component:getNameElem() ~= "context"
      and component:getNameElem() ~= "media")then
      error("Error! Invalid component element!", 2)
    elseif(component:getId() ~= nil)then
      self:addAttribute("component", component:getId())
      self.componentAss = component
      table.insert(component.ass, self)
    else
      error("Error! Component element with nil id attribute!", 2)
    end
  elseif(type(component) == "string" )then
    self:addAttribute("component", component)
  else
    error("Error! Invalid component element!", 2)
  end
end

function Mapping:getComponent()
  return self:getAttribute("component")
end

function Mapping:setInterface(interface)
  if(type(interface) == "table")then
    if(interface["getNameElem"] ~= nil
      and interface:getNameElem() ~= "area"
      and interface:getNameElem() ~= "property"
      and interface:getNameElem() ~= "port"
      and interface:getNameElem() ~= "switchPort")then
      error("Error! Invalid interface element!", 2)
    else
      if(interface["getId"] ~= nil and interface:getId() ~= nil)then
        self:addAttribute("interface", interface:getId())
      elseif(interface["getName"] ~= nil and interface:getName() ~= nil)then
        self:addAttribute("interface", interface:getName())
      else
        error("Error! Interface element with nil id attribute!", 2)
      end
      self.interfaceAss = interface
      table.insert(interface.ass, self)
    end
  elseif(type(interface) == "string" )then
    self:addAttribute("interface", interface)
  else
    error("Error! Invalid interface element!", 2)
  end
end

function Mapping:getInterface()
  return self:getAttribute("interface")
end

return Mapping