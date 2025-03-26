hook.Add("OnPlayerChat", "KaisarSQLPoint", function(ply, text)
    text = string.Explode(" ", text)
    if text[1] == "!sqlpoint" then
        local amount = tonumber(text[2])
        local player = player.GetBySteamID(text[3])
        if not player then return end
        if not amount then return end
        net.Start("kaisar_sqlpoint_receive")
        net.WriteEntity(player)
        net.WriteInt(amount, 32)
        net.SendToServer()
    end

    if text[1] == "!sqlpointcheck" then
        local player = player.GetBySteamID(text[2])
        if not player then return end
        net.Start("kaisar_sqlpoint_check")
        net.WriteEntity(player)
        net.SendToServer()
    end
end) 
