---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by norguhtar.
--- DateTime: 19.09.2019 11:42
---

local schema = {
    tables = {}
}

function schema:search(table)
    for key, exist in pairs(self.tables) do
        if key == table then
            return exist
        end
    end
end

function schema:add(table)
    if not schema:search(table) then
        local key = string.format("%s_%s", table.schema, table.table)
        self.tables[key] = table
    end
end

function schema:get()
    return self.tables
end

return schema
