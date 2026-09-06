local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[DECIPHERER.name] = "Decipherer"
L["info_popup_" .. DECIPHERER.name] = [[You are the Decipherer! Scan other players to learn their role with your Minitester.]]
L["body_found_" .. DECIPHERER.abbr] = "They were a Decipherer."
L["search_role_" .. DECIPHERER.abbr] = "This person was a Decipherer!"
L["target_" .. DECIPHERER.name] = "Decipherer"
L["ttt2_desc_" .. DECIPHERER.name] = [[The Decipherer can discover other player's roles using his Minitester.]]
L["credit_" .. DECIPHERER.abbr .. "_all"] = "Decipherer, you have been awarded {num} equipment credit(s) for your performance."

-- CONVAR LANGUAGE STRINGS
L["ttt2_label_decipherer_max_charge"] = "Maximum charge required to use Minitester"
L["ttt2_label_decipherer_start_charge_pct"] = "Starting charge percentage"
L["ttt2_label_decipherer_max_uses_enabled"] = "Enable maximum uses for the Minitester"
L["ttt2_label_decipherer_max_uses"] = "Maximum number of uses"
L["ttt2_label_decipherer_destroy_on_traitor"] = "Destroy Minitester when it scans a traitor"
L["ttt2_label_decipherer_discombob_on_traitor"] = "Spawn discombobulator explosion when it scans a traitor"
L["ttt2_label_decipherer_smoke_on_traitor"] = "Spawn smoke explosion when it scans a traitor"

-- MINITESTER GUI LANGUAGE STRINGS
L["ttt2_label_decipherer_minitester_help"] = "Hold to scan player"
L["ttt2_label_decipherer_hold_key_to_scan"] = "Hold [{key}] to scan player"
L["ttt2_label_decipherer_scan_progress"] = "Time left: {time}s"
L["ttt2_label_decipherer_uses_left"] = "Uses left: {current}/{maximum}"

-- MINITESTER SWEP LANGUAGE STRINGS
L["ttt2_label_decipherer_minitester_name"] = "Minitester"
L["ttt2_label_decipherer_minitester_desc"] = "Use this to scan other players to learn their role."

-- MINITESTER MESSAGE LANGUAGE STRINGS
L["ttt2_label_decipherer_error_no_player"] = "You are not scanning a player."
L["ttt2_label_decipherer_error_lost_target"] = "You lost your target. Please try again."
L["ttt2_label_decipherer_error_no_uses"] = "You are out of Minitester uses."
L["ttt2_label_decipherer_error_not_charged"] = "Your Minitester is not fully charged yet."
L["ttt2_label_decipherer_msg_ready"] = "Your Minitester is fully charged!"

-- EVENT POPUP LANGUAGE STRINGS
L["ttt2_label_decipherer_epop"] = "{player} is a {role}!"
L["ttt2_label_decipherer_epop_desc"] = "Only you can see this message."

-- EVENT LANGUAGE STRINGS
L["ttt2_label_decipherer_event_title"] = "A Minitester was used"
L["ttt2_label_decipherer_event"] = "{decipherer} has learned that {victim} is a {role} using a Minitester."
