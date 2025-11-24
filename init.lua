dofile_once("mods/seed_changer/files/persistent_store.lua")

config_time = 0
button_hidden = false
stored_seed = 0
nameseed =  ModSettingGet( "seed_changer.nameseed" )

if not ModSettingSet then
  stored_seed = retrieve_int("seed_changer_seed", 32)
else
  if nameseed == "" then
	stored_seed = ModSettingGet( "seed_changer.seed" )
  else
	local concatenated_number_str = ""
    for i = 1, #nameseed do
        local decimal_value = string.byte(nameseed, i)
        concatenated_number_str = concatenated_number_str .. tostring(decimal_value)
    end
	local hash = 5381 
    local MAX_UINT32 = 4294967296 
    for i = 1, #concatenated_number_str do
        local char_code = string.byte(concatenated_number_str, i)
        local h = (hash * 32) + hash
        hash = h + char_code
        hash = hash % MAX_UINT32
    end
    stored_seed = math.floor(hash)
  end
end

current_seed = current_seed or stored_seed or 0

flag = false

if not ModSettingSet then
  flag = HasFlagPersistent("seed_changer_enable_fixed_world_seed")
else
  flag = ModSettingGet( "seed_changer.fixed_seed" )
end

if(flag and current_seed ~= "")then
 --print("Setting seed: "..current_seed)
  ModTextFileSetContent("mods/seed_changer/files/magic_numbers.xml", [[
    <MagicNumbers _DEBUG_DONT_SAVE_MAGIC_NUMBERS="1" WORLD_SEED="]]..tostring(current_seed)..[["/>
  ]])  
 -- print(ModTextFileGetContent("mods/seed_changer/files/magic_numbers.xml"))
  ModMagicNumbersFileAdd("mods/seed_changer/files/magic_numbers.xml")
else
  ModTextFileSetContent("mods/seed_changer/files/magic_numbers.xml", [[<MagicNumbers _DEBUG_DONT_SAVE_MAGIC_NUMBERS="1" WORLD_SEED="0"/>]])  

  ModMagicNumbersFileAdd("mods/seed_changer/files/magic_numbers.xml")
end

function OnWorldPreUpdate()
  if not ModSettingSet then
    if(GameGetFrameNum() > 30)then
      config_time = config_time + 1
      dofile("mods/seed_changer/files/gui.lua")
      if(HasFlagPersistent("seed_changer_enable_hide_menu"))then
          --GamePrint("Time = "..config_time)
          if(config_time > 1800)then
              button_hidden = true
          end
      end
    end
  else
	if GameGetFrameNum() == 300 and nameseed ~= "" then GamePrintImportant(nameseed .. " = " .. current_seed) end
  end
end

function OnPlayerSpawned(player)
  print("Our new world seed = "..current_seed)
end
