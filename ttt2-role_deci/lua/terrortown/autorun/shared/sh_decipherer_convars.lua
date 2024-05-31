CreateConVar("ttt2_decitester_charge_time", 40, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_decitester_confirm_time", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY})


hook.Add("TTTUlxDynamicRCVars", "TTTUlxDynamicVultureCVars", function(tbl)
  tbl[ROLE_DECIPHERER] = tbl[ROLE_DECIPHERER] or {}

table.insert(tbl[ROLE_DECIPHERER], {
      cvar = "ttt2_decitester_charge_time",
      slider = true,
      min = 5,
      max = 120,
      decimal = 0,
      desc = "ttt2_decitester_charge_time (def. 40)"
})

table.insert(tbl[ROLE_DECIPHERER], {
      cvar = "ttt2_decitester_confirm_time",
      slider = true,
      min = 5,
      max = 30,
      decimal = 0,
      desc = "ttt2_decitester_confirm_time (def. 10)"
})
end)