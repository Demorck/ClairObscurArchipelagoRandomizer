local ClientBP = {}

local BlueprintName = "BP_ArchipelagoHelper_C"

---comment
---@param item integer
---@param player integer
function ClientBP:PushNotification(item, player)
    local helper = FindFirstOf(BlueprintName) ---@type ABP_ArchipelagoHelper_C

    if helper == nil or not helper:IsValid() then
        Debug.print("Impossible to push notification: ClientBP nil", "Client:PushNotification")
        return
    end

    helper:AddToLogger(tostring(item), tostring(player))
end


return ClientBP