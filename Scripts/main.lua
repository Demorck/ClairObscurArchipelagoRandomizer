print("[MyLuaMod] Mod loaded\n")

function TestSomeFunctions()
  
    ---@class UAC_jRPG_InventoryManager_C
    local a = FindFirstOf("AC_jRPG_InventoryManager_C")
    if a:IsValid() then
        local s = FText("aa")
        a:ReceiveGold(500000, s:ToString())
    end
end

function Test()
    ---@class UBP_ExplorationProgressionSystem_C
    local a = FindFirstOf("BP_ExplorationProgressionSystem_C")
    if a:IsValid() then
        a:SetExplorationCapacityUnlocked(6, true)
        --a:SetExplorationCapacityUnlocked(6, false)
    end
end


RegisterKeyBind(Key.F1, { ModifierKey.CONTROL }, function()
    ExecuteInGameThread(function()
        TestSomeFunctions()
    end)
end)


RegisterKeyBind(Key.F2, { ModifierKey.CONTROL }, function()
    ExecuteInGameThread(function()
        Test()
    end)
end)
