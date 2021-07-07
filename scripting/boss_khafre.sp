#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

bool g_bEnabled;
//int bossModel, eliteModel;

public Plugin myinfo =
{
	name = "[NMRIH] NMO_Khafre Models",
	author = "Ulreth & Dysphie",
	description = "Custom model for nmo_khafre_vx",
	version = "1.1",
	url = "https://steamcommunity.com/groups/lunreth-laboratory"
};

public void OnMapStart()
{
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, sizeof(map));

	if(StrContains(map, "nmo_khafre") != -1)
    {
		PrecacheModel("models/zombies/monster/monster.mdl");
		PrecacheModel("models/zombies/molded.mdl");
		g_bEnabled = true;
	}
	else
	{
		g_bEnabled = false;
	}
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if(!g_bEnabled)
        return;
	if(StrEqual(classname, "npc_nmrih_shamblerzombie"))
		SDKHook(entity, SDKHook_SpawnPost, OnShamblerSpawned);
	if(StrEqual(classname, "npc_nmrih_runnerzombie"))
		SDKHook(entity, SDKHook_SpawnPost, OnRunnerSpawned);
}

public void OnShamblerSpawned(int zombie)
{
	char targetname[64];
	GetEntPropString(zombie, Prop_Send, "m_iName", targetname, sizeof(targetname));

	if(StrEqual(targetname, "elite_template"))
	{
		CreateTimer(0.5, Timer_ShamblerSpawn, EntIndexToEntRef(zombie));
	}
}

public Action Timer_ShamblerSpawn(Handle timer, int ref_zombie)
{
	int zombie_index = EntRefToEntIndex(ref_zombie);
	if (zombie_index > 0)
	{
		if (IsValidEntity(zombie_index))
		{
			//SetEntProp(zombie_index, Prop_Send, "m_nModelIndex", eliteModel);
			SetEntityModel(zombie_index, "models/zombies/monster/monster.mdl");
			SetEntProp(zombie_index, Prop_Data, "m_iMaxHealth", 2501);
			SetEntProp(zombie_index, Prop_Data, "m_iHealth", 2500);
			//SetEntityHealth(zombie_index, 2500);
		}
	}
	return Plugin_Continue;
}

public void OnRunnerSpawned(int zombie)
{
	char targetname[64];
	GetEntPropString(zombie, Prop_Send, "m_iName", targetname, sizeof(targetname));

	if(StrEqual(targetname, "boss_template"))
	{
		CreateTimer(0.5, Timer_RunnerSpawn, EntIndexToEntRef(zombie));
	}
}

public Action Timer_RunnerSpawn(Handle timer, int ref_zombie)
{
	int zombie_index = EntRefToEntIndex(ref_zombie);
	if (zombie_index > 0)
	{
		if (IsValidEntity(zombie_index))
		{
			//SetEntProp(zombie_index, Prop_Send, "m_nModelIndex", bossModel);
			SetEntityModel(zombie_index, "models/zombies/molded.mdl");
		}
	}
	return Plugin_Continue;
}