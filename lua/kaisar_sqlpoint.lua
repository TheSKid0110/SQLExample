util.AddNetworkString("kaisar_sqlpoint_receive")
util.AddNetworkString("kaisar_sqlpoint_check")

if not sql.TableExists("kaisar_sqlpoint") then
    sql.Query("CREATE TABLE kaisar_sqlpoint (steamid TEXT, point INTEGER)")
end

hook.Add("PlayerInitialSpawn", "KaisarSQLPoint", function(ply)
    local result = sql.Query("SELECT * FROM kaisar_sqlpoint WHERE steamid = '"..ply:SteamID().."'")
    if not result then
        sql.Query("INSERT INTO kaisar_sqlpoint (steamid, point) VALUES ('"..ply:SteamID().."', 0)")
    end
end)

local ranks = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["moderator"] =false,
    ["vip"] = false ,
    ["user"] = false 
}

net.Receive("kaisar_sqlpoint_receive", function(len, ply)
    if not ranks[ply:GetUserGroup()] then return end
    local player = net.ReadEntity()
    local amount = net.ReadInt(32)
    local result = sql.Query("SELECT * FROM kaisar_sqlpoint WHERE steamid = '"..player:SteamID().."'")
    if not result then
        sql.Query("INSERT INTO kaisar_sqlpoint (steamid, point) VALUES ('"..player:SteamID().."', "..amount..")")
    else
        sql.Query("UPDATE kaisar_sqlpoint SET point = "..result[1].point + amount.." WHERE steamid = '"..player:SteamID().."'")
    end

end)

net.Receive("kaisar_sqlpoint_check", function(len, ply)
    print("test")
    if not ranks[ply:GetUserGroup()] then return end
    local player = net.ReadEntity()
    print(player)
    local result = sql.Query("SELECT * FROM kaisar_sqlpoint WHERE steamid = '"..player:SteamID().."'")
    if not result then
        ply:ChatPrint("Player "..player:Nick().." has 0 points.")
    else
        ply:ChatPrint("Player "..player:Nick().." has "..result[1].point.." points.")
    end
end)